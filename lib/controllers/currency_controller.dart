import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../models/currency_model.dart';

class CurrencyController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Currency?> currency = Rx<Currency?>(null);

  final storage = GetStorage();
  final String apiUrl = AppConfig.baseUrl;

  @override
  void onInit() {
    super.onInit();
    loadSavedCurrency(); // Load saved INR details if present
    fetchINRCurrency();  // Fetch latest INR details
  }

  /// 🔹 Fetch only Indian currency details
  Future<void> fetchINRCurrency() async {
    try {
      isLoading.value = true;
      final visitorToken = storage.read('visitorToken')?.toString() ?? '';

      final headers = {
        "Content-Type": "application/json",
        "authToken": AppConfig.authToken,
        "visitorToken": visitorToken,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          "action": "getCurrencyList",
          "getCurrencyList": {"baseCode": "INR"} // 🔹 Fetch only INR
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true &&
            decoded["data"]?["currencyList"] is List) {
          final List data = decoded["data"]["currencyList"];

          // Try to find INR specifically
          final inrData = data.firstWhere(
                (e) => e["currencyCode"] == "INR",
            orElse: () => {},
          );

          if (inrData.isNotEmpty) {
            final fetchedCurrency = Currency.fromJson(inrData);
            currency.value = fetchedCurrency;
            saveSelectedCurrency(fetchedCurrency);

          } else {

          }
        } else {

        }
      } else {

      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Save INR details locally
  void saveSelectedCurrency(Currency currencyData) {
    storage.write('currencyCode', currencyData.currencyCode);
    storage.write('currencyName', currencyData.currencyName);
    storage.write('currencySymbol', currencyData.currencySymbol);

  }

  /// 🔹 Load saved INR details
  void loadSavedCurrency() {
    final code = storage.read('currencyCode');
    final name = storage.read('currencyName');
    final symbol = storage.read('currencySymbol');

    if (code != null && name != null && symbol != null) {
      currency.value = Currency(
        currencyCode: code,
        currencyName: name,
        currencySymbol: symbol,
      );

    }
  }
}
