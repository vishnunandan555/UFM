import 'installed_upi_app.dart';
import 'upi_launch_result.dart';

/// Platform boundary interface for discovering installed UPI applications
/// and launching targeted UPI payment intents.
abstract interface class UpiPlatform {
  /// Queries installed applications that support UPI intents.
  Future<List<InstalledUpiApp>> getCompatibleApps();

  /// Launches the given [paymentUri] targeted specifically to [packageName].
  Future<UpiLaunchResult> launchPayment({
    required String packageName,
    required String paymentUri,
  });
}
