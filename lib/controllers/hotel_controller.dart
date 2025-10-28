import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/hotel_model.dart';

class HotelController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs;
  RxList<String> suggestions = <String>[].obs;
  RxList<Hotel> fetchedHotels = <Hotel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;

  final storage = GetStorage();

  /// ✅ Fetch default popular stays (shown when no search is done)
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

  /// ✅ Fetch hotels when searching
  Future<void> fetchHotelsFromSearch(String query) async {
    if (query.isEmpty) {
      fetchDefaultHotels();
      return;
    }

    isLoading.value = true;
    const url = AppConfig.baseUrl;
    final visitorToken = storage.read('visitorToken') ?? '';

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "authToken": AppConfig.authToken,
      "visitorToken": visitorToken,
    };

    final body ={
      "action":"searchAutoComplete",
      "searchAutoComplete":{
        "inputText":"delhi",
        "searchType":[
          "byCity",
          "byState",
          "byCountry",
          "byRandom",
          "byPropertyName" // you can put any searchType from the list
        ],
        "limit":10
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      log("📥 Search Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true &&
            decoded["data"]?["autoCompleteList"] != null) {
          final autoCompleteList = decoded["data"]["autoCompleteList"];
          fetchedHotels.clear();

          for (final category in autoCompleteList.keys) {
            final list = autoCompleteList[category]?["listOfResult"];
            if (list is List) {
              for (final item in list) {
                try {
                  fetchedHotels.add(
                    Hotel(
                      propertyName: item["propertyName"] ?? "",
                      propertyStar: 0,
                      propertyImage: "",
                      propertyCode: "",
                      propertyType: "",
                      propertyPoliciesAndAmmenities:
                          PropertyPoliciesAndAmenities(present: false),
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
                        street: "",
                        city: item["address"]?["city"] ?? "",
                        state: item["address"]?["state"] ?? "",
                        country: item["address"]?["country"] ?? "",
                        zipcode: "",
                        mapAddress: "",
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

          hotels.assignAll(fetchedHotels);
          log("✅ Parsed ${fetchedHotels.length} hotels");
        } else {
          hotels.clear();
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
}
