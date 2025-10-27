import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceHelper {
  static Future<Map<String, dynamic>> getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await deviceInfo.androidInfo;
      return {
        "deviceModel": info.model ?? "unknown",
        "deviceFingerprint": info.fingerprint ?? "unknown",
        "deviceBrand": info.brand ?? "unknown",
        "deviceId": info.id ?? "unknown", // ✅ fixed here
        "deviceName": info.device ?? "unknown",
        "deviceManufacturer": info.manufacturer ?? "unknown",
        "deviceProduct": info.product ?? "unknown",
        "deviceSerialNumber": "unknown",
      };
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final info = await deviceInfo.iosInfo;
      return {
        "deviceModel": info.utsname.machine ?? "iPhone",
        "deviceFingerprint": info.systemVersion ?? "iOS",
        "deviceBrand": "Apple",
        "deviceId": info.identifierForVendor ?? "unknown",
        "deviceName": info.name ?? "iPhone",
        "deviceManufacturer": "Apple",
        "deviceProduct": info.model ?? "iPhone",
        "deviceSerialNumber": "unknown",
      };
    } else {
      return {
        "deviceModel": "unknown",
        "deviceFingerprint": "unknown",
        "deviceBrand": "unknown",
        "deviceId": "unknown",
        "deviceName": "unknown",
        "deviceManufacturer": "unknown",
        "deviceProduct": "unknown",
        "deviceSerialNumber": "unknown",
      };
    }
  }
}
