import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/hotel_model.dart';

class HotelController extends GetxController {
  var hotels = <Hotel>[].obs;
  var isLoading = false.obs;
  var suggestions = <String>[].obs;
  var isSearching = false.obs;
  final storage = GetStorage();

  Future<void> fetchHotels() async {
    isLoading.value = true;
    const url = AppConfig.baseUrl;

    try {
      final visitorToken = storage.read('visitorToken')?.toString() ?? '';

      if (visitorToken.isEmpty) {
        Get.snackbar('Error', 'Visitor token not found. Please login again.');
        isLoading.value = false;
        return;
      }

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "authToken": AppConfig.authToken,
        "visitorToken": visitorToken,
      };

      final Map<String, dynamic> body = {
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
        }
      };

      log("📤 Fetching hotels...");
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      log("📥 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true && decoded["data"] != null) {
          // ✅ Properly parse the list of hotels
          final List<dynamic> hotelList = decoded["data"];
          final parsedHotels =
          hotelList.map((json) => Hotel.fromJson(json)).toList();

          hotels.assignAll(parsedHotels);
          log("✅ Loaded hotels: ${hotels.length}");
        } else {
          Get.snackbar('Error', decoded["message"] ?? 'No hotels found');
        }
      } else {
        Get.snackbar('Error', 'Failed to load hotels (${response.statusCode})');
      }
    } catch (e) {
      log("❌ fetchHotels Error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Fetch autocomplete suggestions
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    const url = AppConfig.baseUrl;
    final visitorToken = storage.read('visitorToken') ?? '';

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "authToken": AppConfig.authToken,
      "visitorToken": visitorToken,
    };

    final body = {
      "action": "searchAutoComplete",
      "searchAutoComplete": {
        "inputText": query,
        "searchType": [
          "byCity",
          "byState",
          "byCountry",
          "byPropertyName"
        ],
        "limit": 10
      }
    };

    try {
      isSearching.value = true;
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final list = (decoded["data"] as List?)
            ?.map((e) => e["displayText"]?.toString() ?? "")
            .where((text) => text.isNotEmpty)
            .toList() ??
            [];
        suggestions.assignAll(list);
      } else {
        log("❌ Autocomplete failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ fetchSuggestions Error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  /// ✅ Fetch actual hotels (after user selects a suggestion)
  Future<void> fetchHotelsFromSearch(String searchQuery) async {
    isLoading.value = true;
    const url = AppConfig.baseUrl;

    final visitorToken = storage.read('visitorToken') ?? '';




    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "authToken": AppConfig.authToken,
      "visitorToken": visitorToken,
    };

    final body = {
      "action": "getSearchResultListOfHotels",
      "getSearchResultListOfHotels": {
        "searchCriteria": {
          "checkIn": "2026-07-11",
          "checkOut": "2026-07-12",
          "rooms": 1,
          "adults": 2,
          "children": 0,
          "searchType": "byCity",
          "searchQuery": [searchQuery],
          "accommodation": ["all", "hotel"],
          "arrayOfExcludedSearchType": ["street"],
          "highPrice": "3000000",
          "lowPrice": "0",
          "limit": 10,
          "preloaderList": [],
          "currency": "INR",
          "rid": 0
        }
      }
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["status"] == true && decoded["data"] != null) {
          hotels.assignAll(
              (decoded["data"] as List).map((e) => Hotel.fromJson(e)).toList());
        } else {
          hotels.clear();
        }
      } else {
        log("❌ fetchHotels failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ fetchHotels Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
