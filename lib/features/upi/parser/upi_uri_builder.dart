/// Utility for constructing NPCI-compliant `upi://pay` URIs for external payment app intents.
class UpiUriBuilder {
  const UpiUriBuilder._();

  /// Constructs a valid `upi://pay` URI string.
  ///
  /// [amountPaise] must be a positive integer representing amount in paise (1 INR = 100 paise).
  /// Integer arithmetic is strictly used to format the decimal representation without floating-point inaccuracies.
  static String build({
    required String payeeVpa,
    required String payeeName,
    required int amountPaise,
    String currency = 'INR',
    String? note,
    String? transactionRef,
    String? merchantCategoryCode,
  }) {
    if (amountPaise <= 0) {
      throw ArgumentError.value(
        amountPaise,
        'amountPaise',
        'Amount must be greater than zero paise',
      );
    }

    final rupees = amountPaise ~/ 100;
    final paise = amountPaise % 100;
    final amountString = '$rupees.${paise.toString().padLeft(2, '0')}';

    final queryParams = <String, String>{
      'pa': payeeVpa,
      'pn': payeeName,
      'am': amountString,
      'cu': currency,
    };

    if (note != null && note.trim().isNotEmpty) {
      queryParams['tn'] = note.trim();
    }
    if (transactionRef != null && transactionRef.trim().isNotEmpty) {
      queryParams['tr'] = transactionRef.trim();
    }
    if (merchantCategoryCode != null && merchantCategoryCode.trim().isNotEmpty) {
      queryParams['mc'] = merchantCategoryCode.trim();
    }

    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: queryParams,
    ).toString();
  }
}
