import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:test/test.dart';

void main() {
  final CreditCardValidator validator = CreditCardValidator();
  group('Month tests', () {
    final String year = '25'; // TODO make date programmatically, this needs to be updated manually for tests to pass
    final String badMonth1 = '00/' + year;
    final String badMonth2 = '13/' + year;
    final String correctMonth1 = '03/' + year;
    final String correctMonth2 = '10/' + year;

    test('less than 1 (January)', () {
      ValidationResults results = validator.validateExpDate(badMonth1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('greater than 12 (December)', () {
      ValidationResults results = validator.validateExpDate(badMonth2);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('march', () {
      ValidationResults results = validator.validateExpDate(correctMonth1);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });

    test('october', () {
      ValidationResults results = validator.validateExpDate(correctMonth2);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });
  });

  group('Year tests', () {
    final String expiredAbbr = '20';
    final String expiredFull = '2020';
    final String tooFarInFutureFull = '2040'; // Further than 19 years in the future, TODO make date programmatically
    final String goodAbbr = '24';
    final String goodFull = '2024';

    final String expired1 = '03/' + expiredAbbr;
    final String expired2 = '10/' + expiredAbbr;
    final String expired3 = '03/' + expiredFull;
    final String expired4 = '10/' + expiredFull;
    final String good1 = '03/' + goodAbbr;
    final String good2 = '10/' + goodAbbr;
    final String good3 = '03/' + goodFull;
    final String good4 = '10/' + goodFull;

    test('expired abbreviated year', () {
      ValidationResults results = validator.validateExpDate(expired1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
      results = validator.validateExpDate(expired2);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('expired full year', () {
      ValidationResults results = validator.validateExpDate(expired3);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
      results = validator.validateExpDate(expired4);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('too far in future full year', () {
      ValidationResults results = validator.validateExpDate(tooFarInFutureFull);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('good abbreviated year', () {
      ValidationResults results = validator.validateExpDate(good1);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
      results = validator.validateExpDate(good2);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });

    test('good full year', () {
      ValidationResults results = validator.validateExpDate(good3);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
      results = validator.validateExpDate(good4);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });
  });

  group('Full dates', () {
    final String good = '04/23'; // TODO make date programmatically
    final String expired = '04/20';
    test('good', () {
      ValidationResults results = validator.validateExpDate(good);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });

    test('expired', () {
      ValidationResults results = validator.validateExpDate(expired);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });
  });

  group('Incomplete dates', () {
    final String incompleteYear = '04/2';
    test('incomplete year', () {
      ValidationResults results = validator.validateExpDate(incompleteYear);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });
  });

  group('Formatting', () {
    final String hyphens = '04-22'; // TODO make date programmatically
    test('hyphens', () {
      ValidationResults results = validator.validateExpDate(hyphens);
      expect(results.isValid, true);
      expect(results.isPotentiallyValid, true);
    });
  });

  group('Edge cases', () {
    final String empty = '';
    final String alpha1 = 'A/20';
    final String alpha2 = '6/2o21';
    test('empty string', () {
      ValidationResults results = validator.validateExpDate(empty);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });

    test('alphabetic characters', () {
      ValidationResults results = validator.validateExpDate(alpha1);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
      results = validator.validateExpDate(alpha2);
      expect(results.isValid, false);
      expect(results.isPotentiallyValid, false);
    });
  });
}