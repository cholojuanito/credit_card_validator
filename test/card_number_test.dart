import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:test/test.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';

void main() {
  final String visaCCNumFull = "4647720067791032";
  final String amexCCNumFull = "379996614347278";
  final String discoverCCNumFull = "6011934096440452";
  final String masterCardCCNumFull = "5587192167712970";
  final String jcbCCNumFull = '3538243039991295';
  final String unionPayCCNumFull = '6208243039991295';
  final String maestroCCNumFull = '679990100000000019';

  final String visaCCNumPartial = "46477200";
  final String amexCCNumPartial = "3499";
  final String discoverCCNumPartial = "6011287689";
  final String masterCardCCNumPartial = "528719";

  final CreditCardValidator validator = CreditCardValidator();

  group('Card number sequences', () {
    test('full sequences', () {
      // All of these should be valid and potentially valid
      CCNumValidationResults results = validator.validateCCNum(visaCCNumFull);
      expect(results.ccType, CreditCardType.visa);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(amexCCNumFull);
      expect(results.ccType, CreditCardType.amex);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
      
      results = validator.validateCCNum(discoverCCNumFull);
      expect(results.ccType, CreditCardType.discover);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(masterCardCCNumFull);
      expect(results.ccType, CreditCardType.mastercard);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(jcbCCNumFull);
      expect(results.ccType, CreditCardType.jcb);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(unionPayCCNumFull);
      expect(results.ccType, CreditCardType.unionpay);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(maestroCCNumFull);
      expect(results.ccType, CreditCardType.maestro);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });

    test('partial sequences', () {
      // All of these should not be valid but should be potentially valid
      CCNumValidationResults results = validator.validateCCNum(visaCCNumPartial);
      expect(results.ccType, CreditCardType.visa);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, true);

      results = validator.validateCCNum(amexCCNumPartial);
      expect(results.ccType, CreditCardType.amex);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, true);
      
      results = validator.validateCCNum(discoverCCNumPartial);
      expect(results.ccType, CreditCardType.discover);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, true);
      
      results = validator.validateCCNum(masterCardCCNumPartial);
      expect(results.ccType, CreditCardType.mastercard);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, true);
    });
  });

  group('Formatting', () {
    final String hyphens = "4647-7200-6779-1032";
    final String whiteSpace = "4647 7200 6779 1032";
    final String alpha = "4647 7q00 y390 5673";
    final String symbols = "4647 7#00 8390 5673";
    test('hyphens', () {
      CCNumValidationResults results = validator.validateCCNum(hyphens);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true); 
    });

    test('white space', () {
      CCNumValidationResults results = validator.validateCCNum(whiteSpace);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true); 
    });

    test('alphabetic characters', () {
      CCNumValidationResults results = validator.validateCCNum(alpha);
      expect(results.ccType, CreditCardType.unknown);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false); 
    });

    test('symbols', () {
      CCNumValidationResults results = validator.validateCCNum(symbols);
      expect(results.ccType, CreditCardType.unknown);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);  
    });

  });
  
  // TODO specifically check luhn valid and invalid numbers
  // group('Luhn validity', () {
  //   test('valid numbers', () {
      
  //   });

  //   test('invalid numbers', () {

  //   });

  //   test('union pay (default)', () {

  //   });
    
  //   test('union pay (override luhn check)', () {

  //   });

  // });

  group('Edge cases', () {
    final String empty = '';
    test('empty string', () {
      CCNumValidationResults results = validator.validateCCNum(empty);
      expect(results.ccType, CreditCardType.unknown);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false); 
      
    });

  });
}