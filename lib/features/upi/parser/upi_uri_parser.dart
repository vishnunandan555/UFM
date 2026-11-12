import '../../../core/utilities/money_formatter.dart';
import '../domain/upi_payment_draft.dart';

sealed class UpiParseResult {
  const UpiParseResult();
}

class UpiParseSuccess extends UpiParseResult {
  const UpiParseSuccess(this.draft);
  final UpiPaymentDraft draft;
}

class UpiParseFailure extends UpiParseResult {
  const UpiParseFailure(this.reason);
  final String reason;
}

class UpiUriParser {
  const UpiUriParser._();

  static final RegExp _vpaRegex =
      RegExp(r'^[a-zA-Z0-9.\-_+]+@[a-zA-Z0-9.\-_]+$');

  /// Parses a raw QR code string or URI into a validated [UpiPaymentDraft].
  ///
  /// Rejects non-UPI schemes, invalid VPAs, non-INR currencies, or malformed amounts.
  static UpiParseResult parse(String rawInput) {
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) {
      return const UpiParseFailure('QR payload is empty');
    }

    Uri uri;
    try {
      uri = Uri.parse(trimmed);
    } catch (e) {
      return UpiParseFailure('Malformed URI structure: $e');
    }

    // Scheme check
    if (uri.scheme.toLowerCase() != 'upi') {
      return UpiParseFailure(
        'Unsupported scheme "${uri.scheme}". Expected "upi://pay".',
      );
    }

    // Host check (must be 'pay' or authority must contain 'pay')
    final pathOrHost = '${uri.host}${uri.path}'.toLowerCase();
    if (!pathOrHost.contains('pay')) {
      return const UpiParseFailure(
        'Unsupported UPI operation. Only "upi://pay" is supported.',
      );
    }

    final queryParams = uri.queryParameters;

    // 1. Payee VPA ('pa') - Mandatory
    final pa = queryParams['pa']?.trim();
    if (pa == null || pa.isEmpty) {
      return const UpiParseFailure('Missing required payee VPA ("pa") parameter');
    }
    if (!_vpaRegex.hasMatch(pa)) {
      return UpiParseFailure('Invalid payee VPA format: "$pa"');
    }

    // 2. Payee Name ('pn') - Optional, falls back to pa
    final pnRaw = queryParams['pn']?.trim();
    final payeeName = (pnRaw != null && pnRaw.isNotEmpty) ? pnRaw : pa;

    // 3. Currency ('cu') - Must be INR in v1
    final cu = queryParams['cu']?.trim().toUpperCase() ?? 'INR';
    if (cu != 'INR') {
      return UpiParseFailure(
        'Unsupported currency "$cu". Only INR is supported in v1.',
      );
    }

    // 4. Amount ('am') - Optional
    int? amountPaise;
    bool amountProvidedByQr = false;
    final amStr = queryParams['am']?.trim();
    if (amStr != null && amStr.isNotEmpty) {
      final parsed = MoneyFormatter.parseRupeesToPaise(amStr);
      if (parsed == null || parsed <= 0) {
        return UpiParseFailure(
          'Invalid or non-positive amount parameter: "$amStr"',
        );
      }
      amountPaise = parsed;
      amountProvidedByQr = true;
    }

    // 5. Optional metadata ('tn', 'tr', 'mc')
    final tn = queryParams['tn']?.trim();
    final tr = queryParams['tr']?.trim();
    final mc = queryParams['mc']?.trim();

    return UpiParseSuccess(
      UpiPaymentDraft(
        payeeVpa: pa,
        payeeName: payeeName,
        rawUri: trimmed,
        amountPaise: amountPaise,
        amountWasProvidedByQr: amountProvidedByQr,
        currency: cu,
        note: (tn != null && tn.isNotEmpty) ? tn : null,
        transactionRef: (tr != null && tr.isNotEmpty) ? tr : null,
        merchantCategoryCode: (mc != null && mc.isNotEmpty) ? mc : null,
      ),
    );
  }
}
