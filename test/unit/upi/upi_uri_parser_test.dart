import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/features/upi/parser/upi_uri_parser.dart';

void main() {
  group('UpiUriParser Tests', () {
    test('successfully parses fixed amount UPI URI with full parameters', () {
      const uri =
          'upi://pay?pa=merchant@upi&pn=The%20Coffee%20Roaster&am=250.75&cu=INR&tn=Cold%20Brew&tr=ORD12345&mc=5411';
      final result = UpiUriParser.parse(uri);

      expect(result, isA<UpiParseSuccess>());
      final draft = (result as UpiParseSuccess).draft;

      expect(draft.payeeVpa, 'merchant@upi');
      expect(draft.payeeName, 'The Coffee Roaster');
      expect(draft.amountPaise, 25075);
      expect(draft.amountWasProvidedByQr, isTrue);
      expect(draft.currency, 'INR');
      expect(draft.note, 'Cold Brew');
      expect(draft.transactionRef, 'ORD12345');
      expect(draft.merchantCategoryCode, '5411');
    });

    test('successfully parses variable amount UPI URI (no amount in QR)', () {
      const uri = 'upi://pay?pa=sharma.store@okaxis&pn=Sharma%20General%20Store';
      final result = UpiUriParser.parse(uri);

      expect(result, isA<UpiParseSuccess>());
      final draft = (result as UpiParseSuccess).draft;

      expect(draft.payeeVpa, 'sharma.store@okaxis');
      expect(draft.payeeName, 'Sharma General Store');
      expect(draft.amountPaise, isNull);
      expect(draft.amountWasProvidedByQr, isFalse);
    });

    test('falls back to payee VPA when payee name (pn) is omitted', () {
      const uri = 'upi://pay?pa=person@paytm';
      final result = UpiUriParser.parse(uri);

      expect(result, isA<UpiParseSuccess>());
      final draft = (result as UpiParseSuccess).draft;

      expect(draft.payeeVpa, 'person@paytm');
      expect(draft.payeeName, 'person@paytm');
    });

    test('rejects non-UPI schemes', () {
      final res1 = UpiUriParser.parse('https://example.com/pay');
      expect(res1, isA<UpiParseFailure>());

      final res2 = UpiUriParser.parse('intent://pay?pa=test@upi');
      expect(res2, isA<UpiParseFailure>());

      final res3 = UpiUriParser.parse('random text string');
      expect(res3, isA<UpiParseFailure>());

      final res4 = UpiUriParser.parse('');
      expect(res4, isA<UpiParseFailure>());
    });

    test('rejects missing or empty payee VPA', () {
      const uri = 'upi://pay?pn=Store&am=100';
      final result = UpiUriParser.parse(uri);

      expect(result, isA<UpiParseFailure>());
      expect((result as UpiParseFailure).reason, contains('payee VPA'));
    });

    test('rejects invalid VPA formats (missing @ or illegal characters)', () {
      final res1 = UpiUriParser.parse('upi://pay?pa=no_at_sign');
      expect(res1, isA<UpiParseFailure>());

      final res2 = UpiUriParser.parse('upi://pay?pa=@bank');
      expect(res2, isA<UpiParseFailure>());
    });

    test('rejects non-INR currencies', () {
      const uri = 'upi://pay?pa=merchant@upi&am=100&cu=USD';
      final result = UpiUriParser.parse(uri);

      expect(result, isA<UpiParseFailure>());
      expect((result as UpiParseFailure).reason, contains('currency'));
    });

    test('rejects negative, zero, or malformed amounts', () {
      final res1 = UpiUriParser.parse('upi://pay?pa=m@upi&am=-50');
      expect(res1, isA<UpiParseFailure>());

      final res2 = UpiUriParser.parse('upi://pay?pa=m@upi&am=0');
      expect(res2, isA<UpiParseFailure>());

      final res3 = UpiUriParser.parse('upi://pay?pa=m@upi&am=abc');
      expect(res3, isA<UpiParseFailure>());

      // Sub-paise amount (3 decimal places)
      final res4 = UpiUriParser.parse('upi://pay?pa=m@upi&am=10.555');
      expect(res4, isA<UpiParseFailure>());
    });
  });
}
