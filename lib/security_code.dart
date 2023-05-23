import 'package:credit_card_type_detector/models.dart';
import 'package:credit_card_validator/validation_results.dart';

import 'regexs.dart';

/// Checks the validity of the CVV or security code for the credit card

/// The default length of the CVV or security code (most cards do this)
const int _DEFAULT_SECURITY_CODE_LENGTH = 3;

/// The alternate length of the security code (only American Express cards use this)
const int _ALT_SECURITY_CODE_LENGTH = 4;

/// Validates the card's security code based allowed card type's length and whether it contains only numbers 
/// 
/// Default length is 3 digits but American Express uses security codes that are 4 digits long
  ValidationResults validateSecurityCode(String code, CreditCardType type ) {
    String trimmedCode = code.replaceAll(whiteSpaceRegex, '');

    if (trimmedCode.isEmpty) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'No security code given',
      );
    }

    if (nonNumberRegex.hasMatch(trimmedCode)) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'Alphabetic characters are not allowed',
      );
    }

    // Set the correct security code length
    int expectedCodeLength = type == CreditCardType.americanExpress()
        ? _ALT_SECURITY_CODE_LENGTH
        : _DEFAULT_SECURITY_CODE_LENGTH;

    if (trimmedCode.length < expectedCodeLength) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: true,
        message: 'Security code is too short for this card type',
      );
    }
    else if (trimmedCode.length > expectedCodeLength) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'Security code is too long',
      );
    }

    return ValidationResults(
      isValid: true,
      isPotentiallyValid: true,
    );
  }