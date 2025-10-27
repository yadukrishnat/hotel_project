import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../services/device_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final storage = GetStorage();

  Future<void> loginWithGoogle() async {
    isLoading.value = true;

    try {
      final deviceDetails = await DeviceHelper.getDeviceDetails();

      final body = {
        "action": "deviceRegister",
        "deviceRegister": deviceDetails,
      };

      final headers = {
        "Content-Type": "application/json",
        "authToken": AppConfig.authToken,
      };

      final response = await http.post(
        Uri.parse(AppConfig.baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      log("${response.statusCode}");
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["status"] == true &&
            data["data"] != null &&
            data["data"]["visitorToken"] != null) {
          final visitorToken = data["data"]["visitorToken"].toString();

          // ✅ Save token locally for later API calls
          storage.write('visitorToken', visitorToken);

          Get.snackbar('Success', 'Login Successful');
          Get.offAllNamed('/home');
        } else {
          Get.snackbar('Error', 'Login failed: ${response.body} ');
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
