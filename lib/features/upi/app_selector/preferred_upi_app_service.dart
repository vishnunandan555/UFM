import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Contract for persisting and retrieving user's preferred UPI application.
abstract interface class PreferredUpiAppService {
  Future<String?> getPreferredPackage();
  Future<void> setPreferredPackage(String packageName);
  Future<void> clearPreferredPackage();
}

/// File-backed persistent implementation of [PreferredUpiAppService].
class FilePreferredUpiAppService implements PreferredUpiAppService {
  FilePreferredUpiAppService({this.customDir});

  final Directory? customDir;
  String? _cachedPackage;
  bool _initialized = false;
  static int _tmpCounter = 0;

  Future<File> _getFile() async {
    final dir = customDir ?? await getApplicationSupportDirectory();
    return File('${dir.path}/upi_preferences.json');
  }

  @override
  Future<String?> getPreferredPackage() async {
    if (_initialized) return _cachedPackage;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        if (data is Map<String, dynamic>) {
          _cachedPackage = data['preferred_package'] as String?;
        }
      }
    } catch (_) {
      // In case of file/JSON read errors, return cached or null
    }
    _initialized = true;
    return _cachedPackage;
  }

  @override
  Future<void> setPreferredPackage(String packageName) async {
    _cachedPackage = packageName;
    _initialized = true;
    try {
      final file = await _getFile();
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      final data = {'preferred_package': packageName};
      final tmpFile = File(
        '${file.path}.${DateTime.now().microsecondsSinceEpoch}_${_tmpCounter++}.tmp',
      );
      await tmpFile.writeAsString(jsonEncode(data), flush: true);
      await tmpFile.rename(file.path);
    } catch (_) {}
  }

  @override
  Future<void> clearPreferredPackage() async {
    _cachedPackage = null;
    _initialized = true;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}

/// In-memory implementation of [PreferredUpiAppService] for unit/widget tests.
class InMemoryPreferredUpiAppService implements PreferredUpiAppService {
  InMemoryPreferredUpiAppService([this._package]);

  String? _package;

  @override
  Future<String?> getPreferredPackage() async => _package;

  @override
  Future<void> setPreferredPackage(String packageName) async {
    _package = packageName;
  }

  @override
  Future<void> clearPreferredPackage() async {
    _package = null;
  }
}

/// Riverpod provider for [PreferredUpiAppService].
final preferredUpiAppServiceProvider = Provider<PreferredUpiAppService>((ref) {
  return FilePreferredUpiAppService();
});
