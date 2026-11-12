import 'package:flutter/services.dart';

import 'installed_upi_app.dart';
import 'upi_launch_result.dart';
import 'upi_platform.dart';

/// Concrete [UpiPlatform] implementation communicating via Android MethodChannel.
class MethodChannelUpiPlatform implements UpiPlatform {
  const MethodChannelUpiPlatform([
    this._channel = const MethodChannel('com.ufm.tracker.ufm/upi'),
  ]);

  final MethodChannel _channel;

  @override
  Future<List<InstalledUpiApp>> getCompatibleApps() async {
    try {
      final List<dynamic>? rawApps =
          await _channel.invokeListMethod<dynamic>('getCompatibleApps');
      if (rawApps == null) return const [];

      return rawApps
          .whereType<Map<dynamic, dynamic>>()
          .map(InstalledUpiApp.fromMap)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<UpiLaunchResult> launchPayment({
    required String packageName,
    required String paymentUri,
  }) async {
    try {
      final Map<dynamic, dynamic>? result =
          await _channel.invokeMapMethod<dynamic, dynamic>(
        'launchPayment',
        {
          'packageName': packageName,
          'paymentUri': paymentUri,
        },
      );

      if (result == null) {
        return const UpiLaunchResult(
          status: UpiLaunchStatus.failed,
          errorMessage: 'Null response received from native platform',
        );
      }

      return UpiLaunchResult.fromMap(result);
    } on PlatformException catch (e) {
      return UpiLaunchResult(
        status: UpiLaunchStatus.failed,
        errorMessage: e.message ?? e.toString(),
      );
    } catch (e) {
      return UpiLaunchResult(
        status: UpiLaunchStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}
