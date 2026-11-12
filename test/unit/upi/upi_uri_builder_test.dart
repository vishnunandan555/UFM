import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/features/upi/parser/upi_uri_builder.dart';
import 'package:ufm/features/upi/parser/upi_uri_parser.dart';

void main() {
  group('UpiUriBuilder Tests', () {
    test('builds standard UPI URI with valid mandatory parameters', () {
      final uriString = UpiUriBuilder.build(
        payeeVpa: 'merchant@upi',
        payeeName: 'Test Merchant',
        amountPaise: 25000, // ₹250.00
      );

      final uri = Uri.parse(uriString);
      expect(uri.scheme, 'upi');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['pa'], 'merchant@upi');
      expect(uri.queryParameters['pn'], 'Test Merchant');
      expect(uri.queryParameters['am'], '250.00');
      expect(uri.queryParameters['cu'], 'INR');
      expect(uri.queryParameters.containsKey('tn'), isFalse);
      expect(uri.queryParameters.containsKey('tr'), isFalse);
      expect(uri.queryParameters.containsKey('mc'), isFalse);
    });

    test('correctly formats single-digit paise with zero padding', () {
      final uriString = UpiUriBuilder.build(
        payeeVpa: 'user@bank',
        payeeName: 'User Name',
        amountPaise: 105, // ₹1.05
      );

      final uri = Uri.parse(uriString);
      expect(uri.queryParameters['am'], '1.05');
    });

    test('correctly formats trailing zero paise', () {
      final uriString = UpiUriBuilder.build(
        payeeVpa: 'user@bank',
        payeeName: 'User Name',
        amountPaise: 5010, // ₹50.10
      );

      final uri = Uri.parse(uriString);
      expect(uri.queryParameters['am'], '50.10');
    });

    test('builds URI with optional metadata (note, ref, mcc)', () {
      final uriString = UpiUriBuilder.build(
        payeeVpa: 'store@upi',
        payeeName: 'Grocery Store',
        amountPaise: 154075, // ₹1,540.75
        currency: 'INR',
        note: 'Weekly Grocery',
        transactionRef: 'ORDER-9988',
        merchantCategoryCode: '5411',
      );

      final uri = Uri.parse(uriString);
      expect(uri.queryParameters['am'], '1540.75');
      expect(uri.queryParameters['tn'], 'Weekly Grocery');
      expect(uri.queryParameters['tr'], 'ORDER-9988');
      expect(uri.queryParameters['mc'], '5411');
    });

    test('ignores empty or blank optional fields', () {
      final uriString = UpiUriBuilder.build(
        payeeVpa: 'store@upi',
        payeeName: 'Grocery Store',
        amountPaise: 5000,
        note: '   ',
        transactionRef: '',
        merchantCategoryCode: '  ',
      );

      final uri = Uri.parse(uriString);
      expect(uri.queryParameters.containsKey('tn'), isFalse);
      expect(uri.queryParameters.containsKey('tr'), isFalse);
      expect(uri.queryParameters.containsKey('mc'), isFalse);
    });

    test('throws ArgumentError when amountPaise <= 0', () {
      expect(
        () => UpiUriBuilder.build(
          payeeVpa: 'store@upi',
          payeeName: 'Store',
          amountPaise: 0,
        ),
        throwsArgumentError,
      );

      expect(
        () => UpiUriBuilder.build(
          payeeVpa: 'store@upi',
          payeeName: 'Store',
          amountPaise: -500,
        ),
        throwsArgumentError,
      );
    });

    test('output can be roundtrip parsed by UpiUriParser', () {
      final builtUri = UpiUriBuilder.build(
        payeeVpa: 'cafe@okhdfcbank',
        payeeName: 'Chai Point',
        amountPaise: 8550,
        note: 'Ginger Chai',
        transactionRef: 'TX12345',
        merchantCategoryCode: '5814',
      );

      final parseResult = UpiUriParser.parse(builtUri);
      expect(parseResult, isA<UpiParseSuccess>());

      final draft = (parseResult as UpiParseSuccess).draft;
      expect(draft.payeeVpa, 'cafe@okhdfcbank');
      expect(draft.payeeName, 'Chai Point');
      expect(draft.amountPaise, 8550);
      expect(draft.note, 'Ginger Chai');
      expect(draft.transactionRef, 'TX12345');
      expect(draft.merchantCategoryCode, '5814');
    });
  });
}
