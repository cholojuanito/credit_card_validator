import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:test/test.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';

void main() {
  final CreditCardValidator validator = CreditCardValidator();
  final CreditCardType amex = CreditCardType.amex;
  final CreditCardType other1 = CreditCardType.visa;
  final CreditCardType other2 = CreditCardType.discover;
  final String cvv4Digits = '1234';
  final String cvv3Digits = '123';
  final String cvv5Digits = '12345';

  group('Correct codes', () {
    test('4 digit cvv, type: amex', () {
      ValidationResults results = validator.validateCVV(cvv4Digits, amex);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });

    test('3 digit cvv, type: not amex', () {
      ValidationResults results = validator.validateCVV(cvv3Digits, other1);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCVV(cvv3Digits, other2);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });
  });

  group('Incorrect codes', () {
    test('4 digit cvv, type: not amex', () {
      ValidationResults results = validator.validateCVV(cvv4Digits, other1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
      results = validator.validateCVV(cvv4Digits, other2);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('3 digit cvv, type: amex', () {
      ValidationResults results = validator.validateCVV(cvv3Digits, amex);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, true);
    });

    test('5 digit cvv, type: amex', () {
      ValidationResults results = validator.validateCVV(cvv5Digits, amex);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('5 digit cvv, type: not amex', () {
      ValidationResults results = validator.validateCVV(cvv5Digits, other1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });
  });  

  group('Edge cases', () {
    final String empty = '';
    final String alpha1 = 'A20';
    final String alpha2 = '41A1';
    test('empty string', () {
      ValidationResults results = validator.validateCVV(empty, amex);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);

      results = validator.validateCVV(empty, other1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('alphabetic characters', () {
      ValidationResults results = validator.validateCVV(alpha1, other1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
      results = validator.validateCVV(alpha2, other1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });
  });
}