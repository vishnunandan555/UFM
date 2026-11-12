import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('MethodChannelUpiPlatform Adversarial & Resilience Tests', () {
    test('launchPayment handles malformed map with non-string status and non-string error',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return {
          'status': 123,
          'errorMessage': 500,
        };
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, '500');
    });

    test('launchPayment handles malformed map with boolean status', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return {
          'status': true,
        };
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
    });

    test('launchPayment handles missing status in map', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return {
          'errorMessage': 'No status provided',
        };
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, 'No status provided');
    });

    test('launchPayment handles unexpected exception types from channel',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw StateError('Unexpected runtime state in platform binding');
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, contains('Unexpected runtime state'));
    });

    test('launchPayment handles MissingPluginException without throwing',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw MissingPluginException('No implementation found for method launchPayment');
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, contains('MissingPluginException'));
    });

    test('launchPayment handles unhandled channel (null handler) gracefully',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
    });

    test('launchPayment handles null response from channel', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return null;
      });

      final result = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(result.status, UpiLaunchStatus.failed);
      expect(result.isSuccessful, isFalse);
      expect(result.errorMessage, 'Null response received from native platform');
    });

    test('launchPayment handles standard launched and appNotFound statuses',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return {'status': 'launched'};
      });

      final launchedResult = await platform.launchPayment(
        packageName: 'com.phonepe.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(launchedResult.status, UpiLaunchStatus.launched);
      expect(launchedResult.isSuccessful, isTrue);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return {
          'status': 'appNotFound',
          'errorMessage': 'Activity not found',
        };
      });

      final notFoundResult = await platform.launchPayment(
        packageName: 'missing.app',
        paymentUri: 'upi://pay?pa=store@upi&pn=Store&am=10.00&cu=INR',
      );

      expect(notFoundResult.status, UpiLaunchStatus.appNotFound);
      expect(notFoundResult.isSuccessful, isFalse);
      expect(notFoundResult.errorMessage, 'Activity not found');
    });
  });
}

