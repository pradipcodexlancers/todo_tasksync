/// Splash Data Model (Optional)
///
/// If your splash screen fetches remote app configuration, version checks,
/// or onboarding flags, you can define their data models in this directory.
class SplashModel {
  final String appVersion;
  final bool isUnderMaintenance;
  final String? maintenanceMessage;

  const SplashModel({
    required this.appVersion,
    this.isUnderMaintenance = false,
    this.maintenanceMessage,
  });

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      appVersion: json['app_version'] as String? ?? '1.0.0',
      isUnderMaintenance: json['is_under_maintenance'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_version': appVersion,
      'is_under_maintenance': isUnderMaintenance,
      'maintenance_message': maintenanceMessage,
    };
  }
}
