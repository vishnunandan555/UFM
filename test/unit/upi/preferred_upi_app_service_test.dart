import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/features/upi/app_selector/preferred_upi_app_service.dart';

void main() {
  group('InMemoryPreferredUpiAppService Tests', () {
    test('stores, retrieves, and clears preferred package in memory', () async {
      final service = InMemoryPreferredUpiAppService();
      expect(await service.getPreferredPackage(), isNull);

      await service.setPreferredPackage('com.phonepe.app');
      expect(await service.getPreferredPackage(), 'com.phonepe.app');

      await service.clearPreferredPackage();
      expect(await service.getPreferredPackage(), isNull);
    });
  });

  group('FilePreferredUpiAppService Tests', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ufm_pref_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('persists preference to file and reads it back', () async {
      final service = FilePreferredUpiAppService(customDir: tempDir);
      expect(await service.getPreferredPackage(), isNull);

      await service.setPreferredPackage('net.one97.paytm');
      expect(await service.getPreferredPackage(), 'net.one97.paytm');

      // Create new instance pointing to same directory to verify disk persistence
      final newService = FilePreferredUpiAppService(customDir: tempDir);
      expect(await newService.getPreferredPackage(), 'net.one97.paytm');

      await newService.clearPreferredPackage();
      expect(await newService.getPreferredPackage(), isNull);
    });

    test('handles corrupt json gracefully without throwing', () async {
      final corruptFile = File('${tempDir.path}/upi_preferences.json');
      await corruptFile.writeAsString('{not valid json}');

      final service = FilePreferredUpiAppService(customDir: tempDir);
      expect(await service.getPreferredPackage(), isNull);
    });

    test('creates missing parent directory when persisting preference', () async {
      final nestedDir = Directory('${tempDir.path}/nested/sub/folder');
      expect(await nestedDir.exists(), isFalse);

      final service = FilePreferredUpiAppService(customDir: nestedDir);
      await service.setPreferredPackage('com.phonepe.app');

      expect(await nestedDir.exists(), isTrue);
      final newService = FilePreferredUpiAppService(customDir: nestedDir);
      expect(await newService.getPreferredPackage(), 'com.phonepe.app');
    });

    test('handles rapid concurrent writes without corrupting json', () async {
      final service = FilePreferredUpiAppService(customDir: tempDir);
      final packages = List.generate(100, (i) => 'com.app.pkg$i');

      await Future.wait(
        packages.map((pkg) => service.setPreferredPackage(pkg)),
      );

      final newService = FilePreferredUpiAppService(customDir: tempDir);
      final preferred = await newService.getPreferredPackage();
      expect(preferred, isNotNull);
      expect(packages, contains(preferred));

      // File on disk must exist and contain valid uncorrupted JSON
      final file = File('${tempDir.path}/upi_preferences.json');
      expect(await file.exists(), isTrue);
      final content = await file.readAsString();
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      expect(packages, contains(decoded['preferred_package']));
    });
  });
}
