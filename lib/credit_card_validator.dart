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
///  It is meant to validate the credit card as the user is typing in the card information
/// This class is meant to be used as a mixin and is not inheritable
///  For example:
///     class CreditCardValidationBloc extends Object with CreditCardValidator
/// Will allow access to the functions mentioned below
///  Exposes 3 public functions which can be used to validate different parts of the credit card
///     1) Card number - validated based on type of card, luhn validity & card number length
///     2) Expiration Date - validated based on the date being a valid string & not expiring more
///         than 'n' years in the future. 'n' defaults to 19 years.
///     3) Security code (CVV) - validates based on the length of the code in conjunction with the type of card
class CreditCardValidator {
  /// Private constructor
  /// Makes this class not inheritable or extendable because it cannot be instantiated
  CreditCardValidator._();

  /// Validates a credit card number that is passed in as a string
  /// The string may have spaces or hyphens but no letters
  CCNumValidationResults validateCCNum(String ccNumStr) {
    // If the str is empty or contains any letters
    if (ccNumStr.isEmpty || ccNumStr.contains(RegExp(r'[a-zA-Z]'))) {
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
    // TODO change because then any unknown card  could be potentially valid
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

    // Check Luhn validity of the number
    isLuhnValid = _luhnValidity(trimmedNumStr);

    int maxCardLength = _ccNumLengths[type].reduce(max);

    // Check if the card number length is viable.
    // If it is then decide the potential validity of this card number
    // The card number will be potentially valid if:
    //    The number is luhn valid OR the card number isn't complete yet
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

  /// Validates the card's expiration date based on the standard that no credit cards
  ValidationResults validateExpDate(String expDateStr) {
    return null;
  }

  /// Validates the card's security code based on the card type.
  ///  Default is 3 digits but Amex is the only card provider with security codes that are 4 digits
  ValidationResults validateSecurityCode(String code) {
    return null;
  }

  /// Checks the validity of the card number using the Luhn algorithm (the modulus 10 algorithm)
  ///  For more info on Luhn algorithm check these URLS
  ///     https://en.wikipedia.org/wiki/Luhn_algorithm
  ///     https://www.geeksforgeeks.org/luhn-algorithm
  ///
  /// This method assumes that the incoming string is trimmed of whitespace
  ///  and does not contain non-numerical characters. i.e.' -' or 'a-z'
  bool _luhnValidity(String ccNum) {
    int sum = 0;
    bool alternate = false;

    for (int i = ccNum.length - 1; i >= 0; i--) {
      int digit = int.parse(ccNum[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;

      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}
