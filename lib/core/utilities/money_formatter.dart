import 'package:intl/intl.dart';

/// Utility class for handling money values stored strictly as integer paise.
///
/// Invariant: Money is ALWAYS stored as integer paise (1 INR = 100 paise).
/// ₹150.75 is stored as 15075 paise.
class MoneyFormatter {
  const MoneyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Converts integer paise to formatted Indian Rupee string (e.g. 15075 -> "₹150.75").
  static String formatPaise(int paise, {bool compactIfWhole = false}) {
    final double rupees = paise / 100.0;
    if (compactIfWhole && paise % 100 == 0) {
      return _compactCurrencyFormat.format(rupees);
    }
    return _currencyFormat.format(rupees);
  }

  /// Parses a user-input Rupee string into integer paise.
  /// Examples:
  ///   "150.75" -> 15075
  ///   "100" -> 10000
  ///   "0.5" -> 50
  ///   "1,234.50" -> 123450
  /// Returns null if invalid or negative.
  static int? parseRupeesToPaise(String input) {
    final clean = input.replaceAll('₹', '').replaceAll(',', '').trim();
    if (clean.isEmpty) return null;

    final parts = clean.split('.');
    if (parts.length > 2) return null;

    final rupeesPart = int.tryParse(parts[0]);
    if (rupeesPart == null || rupeesPart < 0) return null;

    int paisePart = 0;
    if (parts.length == 2) {
      final decimalStr = parts[1];
      if (decimalStr.length > 2) return null; // Reject sub-paise amounts
      final padded = decimalStr.padRight(2, '0');
      final parsedDecimal = int.tryParse(padded);
      if (parsedDecimal == null || parsedDecimal < 0) return null;
      paisePart = parsedDecimal;
    }

    return (rupeesPart * 100) + paisePart;
  }
}

