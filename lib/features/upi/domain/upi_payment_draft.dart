/// Domain entity representing a validated UPI payment draft from a scanned QR or intent.
class UpiPaymentDraft {
  const UpiPaymentDraft({
    required this.payeeVpa,
    required this.payeeName,
    required this.rawUri,
    this.amountPaise,
    this.amountWasProvidedByQr = false,
    this.currency = 'INR',
    this.note,
    this.transactionRef,
    this.merchantCategoryCode,
  });

  /// Payee Virtual Payment Address (e.g. `merchant@upi` or `9876543210@paytm`).
  final String payeeVpa;

  /// Payee name (e.g. `Coffee House`). If not provided in QR, falls back to VPA.
  final String payeeName;

  /// Complete unparsed/raw URI string for audit and logging.
  final String rawUri;

  /// Amount in integer paise (if provided in the QR code).
  final int? amountPaise;

  /// True if amount was fixed/embedded in the QR code; false if user must enter amount.
  final bool amountWasProvidedByQr;

  /// Currency code (INR only in v1).
  final String currency;

  /// Transaction note / description.
  final String? note;

  /// Merchant transaction reference / order ID.
  final String? transactionRef;

  /// Merchant Category Code (4 digits).
  final String? merchantCategoryCode;

  @override
  String toString() {
    return 'UpiPaymentDraft(vpa: $payeeVpa, name: $payeeName, amountPaise: $amountPaise, fixed: $amountWasProvidedByQr)';
  }
}
