// lib/models/settings_model.dart
class AppSettings {
  final String? googleMapApi;
  final String? appAndroidVersion;
  final String? appIosVersion;
  final bool appAndroidForceUpdate;
  final bool appIsoForceUpdate;
  final bool appMaintenanceMode;
  final String? supportEmailId;
  final String? contactEmailId;
  final String? conatctNumber;
  final String? whatsappNumber;
  final String? updateTitle;
  final String? updateMessage;
  final String? playStoreLink;
  final String? appStoreLink;
  final String? termsAndConditionUrl;
  final String? privacyUrl;

  AppSettings({
    this.googleMapApi,
    this.appAndroidVersion,
    this.appIosVersion,
    required this.appAndroidForceUpdate,
    required this.appIsoForceUpdate,
    required this.appMaintenanceMode,
    this.supportEmailId,
    this.contactEmailId,
    this.conatctNumber,
    this.whatsappNumber,
    this.updateTitle,
    this.updateMessage,
    this.playStoreLink,
    this.appStoreLink,
    this.termsAndConditionUrl,
    this.privacyUrl,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      googleMapApi: json['googleMapApi']?.toString(),
      appAndroidVersion: json['appAndroidVersion']?.toString(),
      appIosVersion: json['appIosVersion']?.toString(),
      appAndroidForceUpdate: json['appAndroidForceUpdate'] ?? false,
      appIsoForceUpdate: json['appIsoForceUpdate'] ?? false,
      appMaintenanceMode: json['appMaintenanceMode'] ?? false,
      supportEmailId: json['supportEmailId']?.toString(),
      contactEmailId: json['contactEmailId']?.toString(),
      conatctNumber: json['conatctNumber']?.toString(),
      whatsappNumber: json['whatsappNumber']?.toString(),
      updateTitle: json['updateTitle']?.toString(),
      updateMessage: json['updateMessage']?.toString(),
      playStoreLink: json['playStoreLink']?.toString(),
      appStoreLink: json['appStoreLink']?.toString(),
      termsAndConditionUrl: json['termsAndConditionUrl']?.toString(),
      privacyUrl: json['privacyUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'googleMapApi': googleMapApi,
    'appAndroidVersion': appAndroidVersion,
    'appIosVersion': appIosVersion,
    'appAndroidForceUpdate': appAndroidForceUpdate,
    'appIsoForceUpdate': appIsoForceUpdate,
    'appMaintenanceMode': appMaintenanceMode,
    'supportEmailId': supportEmailId,
    'contactEmailId': contactEmailId,
    'conatctNumber': conatctNumber,
    'whatsappNumber': whatsappNumber,
    'updateTitle': updateTitle,
    'updateMessage': updateMessage,
    'playStoreLink': playStoreLink,
    'appStoreLink': appStoreLink,
    'termsAndConditionUrl': termsAndConditionUrl,
    'privacyUrl': privacyUrl,
  };
}
