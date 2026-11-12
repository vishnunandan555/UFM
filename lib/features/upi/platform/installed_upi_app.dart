/// Represents an installed UPI application discovered on the host operating system.
class InstalledUpiApp {
  const InstalledUpiApp({
    required this.packageName,
    required this.appName,
    this.iconBase64,
    this.isTestApp = false,
  });

  /// The Android package name (e.g. `com.phonepe.app` or `com.ufm.fakeupi`).
  final String packageName;

  /// User-friendly display label (e.g. "PhonePe" or "Fake UPI").
  final String appName;

  /// Base64-encoded PNG image of the app's launcher icon, or null if unavailable.
  final String? iconBase64;

  /// True if this application is a test harness (specifically `com.ufm.fakeupi`).
  final bool isTestApp;

  factory InstalledUpiApp.fromMap(Map<dynamic, dynamic> map) {
    return InstalledUpiApp(
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? 'UPI App',
      iconBase64: map['iconBase64'] as String?,
      isTestApp: map['isTestApp'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstalledUpiApp &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName &&
          appName == other.appName &&
          iconBase64 == other.iconBase64 &&
          isTestApp == other.isTestApp;

  @override
  int get hashCode =>
      packageName.hashCode ^
      appName.hashCode ^
      iconBase64.hashCode ^
      isTestApp.hashCode;

  @override
  String toString() =>
      'InstalledUpiApp(packageName: $packageName, appName: $appName, isTestApp: $isTestApp)';
}
