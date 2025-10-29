import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceHelper {
  static Future<Map<String, dynamic>> getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await deviceInfo.androidInfo;
      return {
        "deviceModel": info.model ,
        "deviceFingerprint": info.fingerprint ,
        "deviceBrand": info.brand ,
        "deviceId": info.id , // ✅ fixed here
        "deviceName": info.device,
        "deviceManufacturer": info.manufacturer ,
        "deviceProduct": info.product ,
        "deviceSerialNumber": "unknown",
      };
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final info = await deviceInfo.iosInfo;
      return {
        "deviceModel": info.utsname.machine ,
        "deviceFingerprint": info.systemVersion ,
        "deviceBrand": "Apple",
        "deviceId": info.identifierForVendor ?? "unknown",
        "deviceName": info.name ,
        "deviceManufacturer": "Apple",
        "deviceProduct": info.model ,
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
