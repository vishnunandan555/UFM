import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/features/upi/platform/installed_upi_app.dart';
import 'package:ufm/features/upi/platform/method_channel_upi_platform.dart';
import 'package:ufm/features/upi/platform/upi_launch_result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.ufm.tracker.ufm/upi');
  late MethodChannelUpiPlatform platform;

  setUp(() {
    platform = const MethodChannelUpiPlatform(channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('InstalledUpiApp Model Tests', () {
    test('deserializes properly from map', () {
      final app = InstalledUpiApp.fromMap({
        'packageName': 'com.phonepe.app',
        'appName': 'PhonePe',
        'iconBase64': 'dGVzdA==',
        'isTestApp': false,
      });

      expect(app.packageName, 'com.phonepe.app');
      expect(app.appName, 'PhonePe');
      expect(app.iconBase64, 'dGVzdA==');
      expect(app.isTestApp, isFalse);
    });

    test('supports value equality', () {
      const app1 = InstalledUpiApp(
        packageName: 'net.one97.paytm',
        appName: 'Paytm',
        isTestApp: false,
      );
      const app2 = InstalledUpiApp(
        packageName: 'net.one97.paytm',
        appName: 'Paytm',
        isTestApp: false,
      );

      expect(app1, equals(app2));
      expect(app1.hashCode, equals(app2.hashCode));
    });
  });

  group('UpiLaunchResult Model Tests', () {
    test('correctly sets isSuccessful for launched status', () {
      const res = UpiLaunchResult(status: UpiLaunchStatus.launched);
      expect(res.isSuccessful, isTrue);
      expect(res.errorMessage, isNull);
    });

    test('deserializes appNotFound and failed maps', () {
      final notFound = UpiLaunchResult.fromMap({
        'status': 'appNotFound',
        'errorMessage': 'Package not installed',
      });
      expect(notFound.status, UpiLaunchStatus.appNotFound);
      expect(notFound.isSuccessful, isFalse);
      expect(notFound.errorMessage, 'Package not installed');

      final failed = UpiLaunchResult.fromMap({
        'status': 'failed',
        'errorMessage': 'Activity crash',
      });
      expect(failed.status, UpiLaunchStatus.failed);
      expect(failed.isSuccessful, isFalse);
      expect(failed.errorMessage, 'Activity crash');
    });
  });

  group('MethodChannelUpiPlatform Tests', () {
    test('getCompatibleApps returns list of apps from platform channel',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'getCompatibleApps') {
          return [
            {
              'packageName': 'com.google.android.apps.nbu.paisa.user',
              'appName': 'Google Pay',
              'iconBase64': null,
              'isTestApp': false,
            },
            {
              'packageName': 'com.ufm.fakeupi',
              'appName': 'Fake UPI',
              'iconBase64': null,
              'isTestApp': true,
            },
          ];
        }
        return null;
      });

      final apps = await platform.getCompatibleApps();
      expect(apps.length, 2);
      expect(apps[0].appName, 'Google Pay');
      expect(apps[0].isTestApp, isFalse);
      expect(apps[1].appName, 'Fake UPI');
      expect(apps[1].isTestApp, isTrue);
    });

    test('getCompatibleApps returns empty list on PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'ERROR', message: 'Failed to query PM');
      });

      final apps = await platform.getCompatibleApps();
      expect(apps, isEmpty);
    });

    test('launchPayment returns launched on success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'launchPayment') {
          expect(call.arguments['packageName'], 'com.phonepe.app');
          expect(call.arguments['paymentUri'], contains('upi://pay'));
          return {'status': 'launched'};
        }
        return null;
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.launched);
      expect(result.isSuccessful, isTrue);
    });

    test('launchPayment returns appNotFound when app is not installed',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'launchPayment') {
          return {
            'status': 'appNotFound',
            'errorMessage': 'Activity not found',
          };
        }
        return null;
      });

      final result = await platform.launchPayment(
        packageName: 'missing.package',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.appNotFound);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, 'Activity not found');
    });

    test('launchPayment handles channel exception gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'SECURITY', message: 'Permission denied');
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, 'Permission denied');
    });

    test('when no mock handler is set at all', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      final apps = await platform.getCompatibleApps();
      expect(apps, isEmpty);
    });
  });
}
