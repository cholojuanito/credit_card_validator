import 'package:credit_card_type_detector/models.dart';

import 'card_number.dart';
import 'security_code.dart';
import 'validation_results.dart';
import 'expiration_date.dart';

/// [CreditCardValidator] helps with validating credit card numbers, expiration dates, and security codes.
///  It is meant to validate the credit card as the user is typing in the card information
///
///  Exposes 3 public functions which can be used to validate different parts of the credit card
class CreditCardValidator {
  static final CreditCardType unknownCardType = UNKNOWN_CARD_TYPE;

  /// Validates based on type of card, luhn validity & card number length
  CCNumValidationResults validateCCNum(
    String ccNumStr, {
    bool luhnValidateUnionPay = false,
    bool ignoreLuhnValidation = false,
  }) {
    return validateCardNumber(ccNumStr.trim(),
        luhnValidateUnionPay: luhnValidateUnionPay,
        ignoreLuhnValidation: ignoreLuhnValidation);
  }

  /// Validates the card's expiration date based on the date being a valid string & not expiring more
  /// than 19 years in the future.
  ValidationResults validateExpDate(String expDateStr) {
    return validateExpirationDate(expDateStr.trim());
  }

  /// Validates the security code based on the length of the code in conjunction with the type of card
  ValidationResults validateCVV(String cvv, CreditCardType cardType) {
    return validateSecurityCode(cvv.trim(), cardType);
  }
}
