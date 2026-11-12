import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/utilities/money_formatter.dart';

void main() {
  group('MoneyFormatter Tests', () {
    test('formatPaise formats positive and zero amounts accurately', () {
      expect(MoneyFormatter.formatPaise(0), '₹0.00');
      expect(MoneyFormatter.formatPaise(10050), '₹100.50');
      expect(MoneyFormatter.formatPaise(50), '₹0.50');
      expect(MoneyFormatter.formatPaise(10000000), '₹1,00,000.00');
    });

    test('formatPaise compact mode formats whole rupee values without decimals', () {
      expect(MoneyFormatter.formatPaise(10000, compactIfWhole: true), '₹100');
      expect(MoneyFormatter.formatPaise(10050, compactIfWhole: true), '₹100.50');
    });

    test('parseRupeesToPaise parses standard strings', () {
      expect(MoneyFormatter.parseRupeesToPaise('150.75'), 15075);
      expect(MoneyFormatter.parseRupeesToPaise('100'), 10000);
      expect(MoneyFormatter.parseRupeesToPaise('0.5'), 50);
      expect(MoneyFormatter.parseRupeesToPaise('0.05'), 5);
      expect(MoneyFormatter.parseRupeesToPaise('1,250.00'), 125000);
      expect(MoneyFormatter.parseRupeesToPaise('₹ 500.50'), 50050);
    });

    test('parseRupeesToPaise rejects invalid, sub-paise, or negative amounts', () {
      expect(MoneyFormatter.parseRupeesToPaise('-50'), isNull);
      expect(MoneyFormatter.parseRupeesToPaise('abc'), isNull);
      expect(MoneyFormatter.parseRupeesToPaise('12.345'), isNull); // Sub-paise rejected
      expect(MoneyFormatter.parseRupeesToPaise(''), isNull);
    });
  });
}

