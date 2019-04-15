library credit_card_validator;

import 'dart:math';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

/// A mapping of possible credit card types to their respective possible card number lengths
const Map<CreditCardType, List<int>> _ccNumLengths = {
  CreditCardType.visa: [16, 18, 19],
  CreditCardType.mastercard: [16],
  CreditCardType.amex: [15],
  CreditCardType.discover: [16, 19],
  CreditCardType.unknown: [],
};

/// The default length of the CVV or security code (most cards do this)
/// Set to 3
const int DEFAULT_SECURITY_CODE_LENGTH = 3;

/// The alternate length of the security code (only American Express cards use this)
/// Set to 4
const int ALT_SECURITY_CODE_LENGTH = 4;

/// The default number of years into the future a card is valid. Set to 19
/// i.e. if the current year is 2019 then a valid card would not have an expiration date greater than 2038
const int DEFAULT_NUM_YEARS_IN_FUTURE = 19;

/// The default card number length. Set to 19
const int DEFAULT_MAX_CARD_NUM_LENGTH = 19;

/// A class that contains the results from the validation process
///  Each of the parts of the credit card are either 'valid' or 'potentially valid'
///
/// i.e. User '4'
class ValidationResults {
  /// Whether or not the part of the card in question was valid
  bool isValid;

  /// Whether or not the part of the card in question has the potential to be valid
  bool isPotentiallyValid;

  ValidationResults({
    this.isValid,
    this.isPotentiallyValid,
  });
}

///
class CCNumValidationResults extends ValidationResults {
  /// The type of the credit card that was validated
  /// This is meant to be used in the other validation processes
  /// because the card number length and security codes depend on this
  CreditCardType ccType;

  CCNumValidationResults({
    this.ccType,
    bool isValid,
    bool isPotentiallyValid,
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
        );
}

/// [CreditCardValidator] helps with validating credit card numbers, expiration dates, and security codes.
///  It is meant to  validate the credit card as the user is typing in the card information
// TODO coherent documentation
///  Exposes 3
class CreditCardValidator {
  ///
  CCNumValidationResults validateCCNum(String ccNumStr) {
    // If the str is empty or contains any
    if (ccNumStr.isEmpty) {
      return CCNumValidationResults(
        ccType: CreditCardType.unknown,
        isValid: false,
        isPotentiallyValid: false,
      );
    }

    // Replace any whitespace or hyphens
    String trimmedNumStr = ccNumStr.replaceAll(RegExp(r'-|\s+\b|\b\s'), '');

    CreditCardType type = detectCCType(trimmedNumStr);
    // Card type couldn't be detected but it is still potentially valid
    // TODO this needs to change because then any unknown card  could be potentially valid
    if (type == CreditCardType.unknown) {
      return CCNumValidationResults(
        ccType: type,
        isValid: false,
        isPotentiallyValid: true,
      );
    }

    // Card number is longer than the industry standard of 19. Not valid nor potentially valid
    if (trimmedNumStr.length > DEFAULT_MAX_CARD_NUM_LENGTH) {
      return CCNumValidationResults(
        ccType: type,
        isValid: false,
        isPotentiallyValid: false,
      );
    }

    bool isLuhnValid = false;
    bool isPotentiallyValid = false;
    // Check Luhn validity
    // TODO implement luhn checker

    int maxCardLength = _ccNumLengths[type].reduce(max);

    // TODO coherent comments
    if (_ccNumLengths[type].contains(trimmedNumStr.length)) {
      isPotentiallyValid = isLuhnValid || trimmedNumStr.length < maxCardLength;
      return CCNumValidationResults(
        ccType: type,
        isValid: isLuhnValid,
        isPotentiallyValid: isPotentiallyValid,
      );
    }

    // Not a valid card but if the str passed in is 'incomplete' it is potentially valid
    // Incomplete means that the str passed in isn't as long as the max card length
    return CCNumValidationResults(
      ccType: type,
      isValid: false,
      isPotentiallyValid: trimmedNumStr.length < maxCardLength,
    );
  }

  ///
  ValidationResults validateExpDate(
    String expDateStr, {
    int maxYearsInFuture = DEFAULT_NUM_YEARS_IN_FUTURE,
  }) {
    return null;
  }

  ValidationResults validateSecurityCode() {
    return null;
  }

  bool _isLuhnValid() {}
}
