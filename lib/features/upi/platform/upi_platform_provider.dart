import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'method_channel_upi_platform.dart';
import 'upi_platform.dart';

/// Provider for the UPI platform bridge. Overridable in widget and integration tests.
final upiPlatformProvider = Provider<UpiPlatform>((ref) {
  return const MethodChannelUpiPlatform();
});
