// lib/controllers/settings_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/settings_model.dart';


class SettingsController extends GetxController {
  final storage = GetStorage();

  final Rxn<AppSettings> settings = Rxn<AppSettings>();
  final RxBool isLoading = false.obs;

  /// Fetch settings via GET. Replace endpoint as needed.
  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      // Example: AppConfig.settingsUrl should point to the GET settings endpoint
      final url = AppConfig.settingUrl; // e.g. "https://api.mytravaly.com/public/v1/settings"
      final visitorToken = storage.read('visitorToken')?.toString() ?? '';

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'authToken': AppConfig.authToken,
      };

      // If visitor token required in header (optional)
      if (visitorToken.isNotEmpty) {
        headers['visitorToken'] = visitorToken;
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      log('Settings GET ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          final model = AppSettings.fromJson(decoded['data'] as Map<String, dynamic>);
          settings.value = model;

          // persist to GetStorage for easy reuse
          storage.write('appSettings', model.toJson());

          log('✅ Settings saved locally');
        } else {
          log('⚠️ Settings response status false or data null');
        }
      } else {
        log('❌ Settings fetch failed: ${response.statusCode}');
      }
    } catch (e, st) {
      log('❌ fetchSettings error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load settings from local storage (if available)
  void loadFromStorage() {
    final data = storage.read('appSettings');
    if (data is Map<String, dynamic>) {
      settings.value = AppSettings.fromJson(data);
    }
  }
}
