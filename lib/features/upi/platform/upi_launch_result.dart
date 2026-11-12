/// Outcome status of an attempt to launch an external UPI application.
enum UpiLaunchStatus {
  /// The target application was successfully launched into the foreground.
  launched,

  /// The application was not found or could not resolve the UPI payment intent.
  appNotFound,

  /// The launch failed due to an exception (security, activity unavailable, etc.).
  failed,
}

/// Result returned from invoking [UpiPlatform.launchPayment].
class UpiLaunchResult {
  const UpiLaunchResult({
    required this.status,
    this.errorMessage,
  });

  final UpiLaunchStatus status;
  final String? errorMessage;

  bool get isSuccessful => status == UpiLaunchStatus.launched;

  factory UpiLaunchResult.fromMap(Map<dynamic, dynamic> map) {
    final statusStr = map['status']?.toString() ?? 'failed';
    final error = map['errorMessage']?.toString();

    final UpiLaunchStatus parsedStatus;
    switch (statusStr) {
      case 'launched':
        parsedStatus = UpiLaunchStatus.launched;
      case 'appNotFound':
        parsedStatus = UpiLaunchStatus.appNotFound;
      default:
        parsedStatus = UpiLaunchStatus.failed;
    }

    return UpiLaunchResult(
      status: parsedStatus,
      errorMessage: error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpiLaunchResult &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => status.hashCode ^ errorMessage.hashCode;

  @override
  String toString() =>
      'UpiLaunchResult(status: $status, errorMessage: $errorMessage)';
}
