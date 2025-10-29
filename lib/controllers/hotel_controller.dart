import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/hotel_model.dart';

class HotelController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs;          // Default hotels
  RxList<Hotel> fetchedHotels = <Hotel>[].obs;   // Search results
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  final storage = GetStorage();

  /// ✅ Clear search and show default list
  void clearSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    fetchedHotels.clear();
  }

  /// ✅ Fetch default (popular) hotels
  Future<void> fetchDefaultHotels() async {
    isLoading.value = true;
    const url = AppConfig.baseUrl;

    try {
      final visitorToken = storage.read('visitorToken')?.toString() ?? '';
      if (visitorToken.isEmpty) {
        Get.snackbar('Error', 'Visitor token not found. Please login again.');
        return;
      }

      final headers = {
        "Content-Type": "application/json",
        "authToken": AppConfig.authToken,
        "visitorToken": visitorToken,
      };

      final body = {
        "action": "popularStay",
        "popularStay": {
          "limit": 10,
          "entityType": "Any",
          "filter": {
            "searchType": "byCity",
            "searchTypeInfo": {
              "country": "India",
              "state": "Jharkhand",
              "city": "Jamshedpur",
            },
          },
          "currency": "INR",
        },
      };

      log("📤 Fetching default popular hotels...");
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["status"] == true && decoded["data"] != null) {
          final List<dynamic> hotelList = decoded["data"];
          hotels.assignAll(
            hotelList.map((json) => Hotel.fromJson(json)).toList(),
          );
          log("✅ Default hotels loaded: ${hotels.length}");
        } else {
          hotels.clear();
        }
      } else {
        Get.snackbar('Error', 'Failed to load hotels (${response.statusCode})');
      }
    } catch (e) {
      log("❌ fetchDefaultHotels Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Fetch hotels dynamically based on search query
  Future<void> fetchHotelsFromSearch(String query) async {
    searchQuery.value = query.trim();

    if (searchQuery.isEmpty) {
      clearSearch();
      fetchDefaultHotels();
      return;
    }

    isSearching.value = true;
    isLoading.value = true;
    const url = AppConfig.baseUrl;

    try {
      final visitorToken = storage.read('visitorToken')?.toString() ?? '';
      if (visitorToken.isEmpty) {
        Get.snackbar('Error', 'Visitor token not found. Please login again.');
        return;
      }

      final headers = {
        "Content-Type": "application/json",
        "authToken": AppConfig.authToken,
        "visitorToken": visitorToken,
      };

      final body = {
        "action": "searchAutoComplete",
        "searchAutoComplete": {
          "inputText": searchQuery.value, // ✅ dynamic
          "searchType": [
            "byCity",
            "byState",
            "byCountry",
            "byRandom",
            "byPropertyName"
          ],
          "limit": 10
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      log("📥 Search Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded["data"]?["autoCompleteList"];

        fetchedHotels.clear();

        if (decoded["status"] == true && data != null) {
          for (final category in data.keys) {
            final list = data[category]?["listOfResult"];
            if (list is List) {
              for (final item in list) {
                try {
                  fetchedHotels.add(
                    Hotel(
                      propertyName: item["propertyName"] ?? item["valueToDisplay"] ?? "",
                      propertyStar: 0,
                      propertyImage: "",
                      propertyCode: (item["searchArray"]?["query"]?.isNotEmpty ?? false)
                          ? item["searchArray"]["query"][0]
                          : "",
                      propertyType: item["searchArray"]?["type"] ?? "",
                      propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
                        present: false,
                      ),
                      markedPrice: Price(
                        amount: 0,
                        displayAmount: "",
                        currencyAmount: "",
                        currencySymbol: "",
                      ),
                      staticPrice: Price(
                        amount: 0,
                        displayAmount: "",
                        currencyAmount: "",
                        currencySymbol: "",
                      ),
                      googleReview: GoogleReview(reviewPresent: false),
                      propertyUrl: "",
                      propertyAddress: PropertyAddress(
                        street: item["address"]?["street"] ?? "",
                        city: item["address"]?["city"] ?? "",
                        state: item["address"]?["state"] ?? "",
                        country: item["address"]?["country"] ?? "",
                        zipcode: "",
                        mapAddress: item["valueToDisplay"] ?? "",
                        latitude: 0,
                        longitude: 0,
                      ),
                    ),
                  );
                } catch (e) {
                  log("⚠️ Skipped item: $e");
                }
              }
            }
          }
          log("✅ Parsed ${fetchedHotels.length} search hotels");
        } else {
          fetchedHotels.clear();
        }
      } else {
        log("❌ fetchHotelsFromSearch failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ fetchHotelsFromSearch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Computed reactive list for UI
  List<Hotel> get hotelsToShow =>
      isSearching.value ? fetchedHotels : hotels;
}
