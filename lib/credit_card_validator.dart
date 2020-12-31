import 'package:credit_card_type_detector/credit_card_type_detector.dart';

import 'card_number.dart';
import 'security_code.dart';
import 'validation_results.dart';
import 'expiration_date.dart';

/// [CreditCardValidator] helps with validating credit card numbers, expiration dates, and security codes.
///  It is meant to validate the credit card as the user is typing in the card information
///
///  Exposes 3 public functions which can be used to validate different parts of the credit card
///     1) Card number - validated based on type of card, luhn validity & card number length
///     2) Expiration Date - validated based on the date being a valid string & not expiring more
///         than 'n' years in the future. 'n' defaults to 19 years.
///     3) Security code (CVV) - validates based on the length of the code in conjunction with the type of card
class CreditCardValidator {

  /// Validates a credit card number
  CCNumValidationResults validateCCNum(String ccNumStr) {
    return validateCardNumber(ccNumStr.trim());
  }

  /// Validates the card's expiration date based on the standard that no credit cards
  ValidationResults validateExpDate(String expDateStr) {
    return validateExpirationDate(expDateStr.trim());
  }

  ValidationResults validateCVV(String cvv, {CreditCardType cardType = CreditCardType.unknown}) {
    return validateSecurityCode(cvv.trim(), type: cardType);
  }

}
