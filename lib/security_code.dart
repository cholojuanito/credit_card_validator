import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_validator/validation_results.dart';

import 'regexs.dart';

/// Checks the validity of the CVV or security code for the credit card

/// The default length of the CVV or security code (most cards do this)
/// Set to 3
const int DEFAULT_SECURITY_CODE_LENGTH = 3;

/// The alternate length of the security code (only American Express cards use this)
/// Set to 4
const int ALT_SECURITY_CODE_LENGTH = 4;

/// Validates the card's security code based on the card type.
  ///  Default is 3 digits but Amex is the only card provider with security codes that are 4 digits
  ValidationResults validateSecurityCode(String code,
      {CreditCardType type = CreditCardType.unknown}) {
    if (code.isEmpty) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'No security code given',
      );
    }

    String trimmedCode = code.replaceAll(nonNumberRegex, '')
      ..replaceAll(whiteSpaceRegex, '');

    // Set the correct security code length
    int expectedCodeLength = type == CreditCardType.amex
        ? ALT_SECURITY_CODE_LENGTH
        : DEFAULT_SECURITY_CODE_LENGTH;

    if (trimmedCode.length != expectedCodeLength) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'The security code is not the right length for this card type',
      );
    }

    return ValidationResults(
      isValid: true,
      isPotentiallyValid: true,
    );
  }