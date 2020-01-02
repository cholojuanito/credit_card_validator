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

  /// A message that contains the reason why the validation failed
  /// NOTE: This will only be present if both `isValid` and `isPotentiallyValid` are false
  String message;

  ValidationResults({
    this.isValid,
    this.isPotentiallyValid,
    this.message,
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
    String message,
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
        );
}

class _ExpYearValidationResults extends ValidationResults {
  /// Whether or not the card expires this year
  bool expiresThisYear;

  _ExpYearValidationResults({
    this.expiresThisYear,
    bool isValid,
    bool isPotentiallyValid,
    String message,
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
        );
}

class _ExpMonthValidationResults extends ValidationResults {
  /// Whether or not the card is good if it expires this year
  bool isValidForCurrentYear;

  _ExpMonthValidationResults({
    this.isValidForCurrentYear,
    bool isValid,
    bool isPotentiallyValid,
    String message,
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
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
mixin CreditCardValidator {
  /// Validates a credit card number that is passed in as a string
  /// The string may have spaces or hyphens but no letters
  CCNumValidationResults validateCCNum(String ccNumStr) {
    // If the str is empty or contains any letters
    if (ccNumStr.isEmpty || ccNumStr.contains(_alphaCharsRegex)) {
      return CCNumValidationResults(
        ccType: CreditCardType.unknown,
        isValid: false,
        isPotentiallyValid: false,
        message: 'No input or contains alphabetic characters',
      );
    }

    // Replace any whitespace or hyphens
    String trimmedNumStr = ccNumStr.replaceAll(_whiteSpaceRegex, '');

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
        message: 'Card number is greater than 19 digits',
      );
    }

    bool isLuhnValid = false;
    bool isPotentiallyValid = false;
    String failedMessage = 'Not a valid credit card number';

    // Check Luhn validity of the number
    isLuhnValid = _luhnValidity(trimmedNumStr);

    int maxCardLength = _ccNumLengths[type].reduce(max);

    // Check if the card number length is viable.
    // If it is then decide the potential validity of this card number
    // The card number will be potentially valid if:
    //    The number is luhn valid OR the card number isn't complete yet
    if (_ccNumLengths[type].contains(trimmedNumStr.length)) {
      isPotentiallyValid = isLuhnValid || trimmedNumStr.length < maxCardLength;

      if (isLuhnValid && isPotentiallyValid) {
        failedMessage = null;
      }

      return CCNumValidationResults(
        ccType: type,
        isValid: isLuhnValid,
        isPotentiallyValid: isPotentiallyValid,
        message: failedMessage,
      );
    }

    bool potentialForMoreDigits = trimmedNumStr.length < maxCardLength;
    if (potentialForMoreDigits) {
      failedMessage = null;
    }
    // Not a valid card but if the str passed in is 'incomplete' it is potentially valid
    // Incomplete means that the str passed in isn't as long as the max card length
    return CCNumValidationResults(
      ccType: type,
      isValid: false,
      isPotentiallyValid: potentialForMoreDigits,
      message: failedMessage,
    );
  }

  /// Validates the card's expiration date based on the standard that no credit cards
  ValidationResults validateExpDate(String expDateStr) {
    if (expDateStr == null || expDateStr.isEmpty) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'No date given',
      );
    }

    List<String> monthAndYear = _parseDate(expDateStr);
    if (monthAndYear == null) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: true,
        message: 'Invalid date format',
      );
    }

    _ExpMonthValidationResults monthValidation =
        _validateExpMonth(monthAndYear[0]);
    _ExpYearValidationResults yearValidation =
        _validateExpYear(monthAndYear[1]);

    if (monthValidation.isValid) {
      if (yearValidation.expiresThisYear) {
        // If the card expires this year then tell whether or not it has expired already
        return ValidationResults(
          isValid: monthValidation.isValidForCurrentYear,
          isPotentiallyValid: monthValidation.isValidForCurrentYear,
          message: yearValidation
              .message, // If year validation failed then this will be set
        );
      }

      // Valid expiration date, all is well
      if (yearValidation.isValid) {
        return ValidationResults(
          isValid: true,
          isPotentiallyValid: true,
        );
      }
    }

    // Still a potentially valid expiration date
    if (monthValidation.isPotentiallyValid &&
        yearValidation.isPotentiallyValid) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: true,
      );
    }

    return ValidationResults(
      isValid: false,
      isPotentiallyValid: false,
      message: monthValidation.message,
    );
  }

  /// Validates the card's security code based on the card type.
  ///  Default is 3 digits but Amex is the only card provider with security codes that are 4 digits
  ValidationResults validateSecurityCode(String code,
      {CreditCardType type = CreditCardType.unknown}) {
    if (code == null || code.isEmpty) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'Empty security code string',
      );
    }

    String trimmedCode = code.replaceAll(_alphaCharsRegex, '')
      ..replaceAll(_whiteSpaceRegex, '');

    // Set the correct security code length
    int expectedCodeLength = type == CreditCardType.amex
        ? ALT_SECURITY_CODE_LENGTH
        : DEFAULT_SECURITY_CODE_LENGTH;

    if (trimmedCode.length != expectedCodeLength) {
      return ValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        message: 'The security code is not the right length',
      );
    }

    return ValidationResults(
      isValid: true,
      isPotentiallyValid: true,
    );
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

  _ExpYearValidationResults _validateExpYear(String expYearStr,
      [int maxYearsInFuture]) {
    int maxYearsTillExpiration = maxYearsInFuture != null
        ? maxYearsInFuture
        : DEFAULT_NUM_YEARS_IN_FUTURE;

    int fourDigitCurrYear = DateTime.now().year;
    String fourDigitCurrYearStr = fourDigitCurrYear.toString();
    int expYear = int.parse(expYearStr);
    bool isCurrYear = false;

    if (expYearStr.length == 3) {
      // The first 3 digits of a 4 digit year. i.e. 2022, we have the '202'
      // This statement is reached when the user is typing in a full 4 digit year
      int firstTwoDigits = int.parse(expYearStr.substring(0, 2));
      int firstTwoDigitsCurrYear =
          int.parse(fourDigitCurrYearStr.substring(0, 2));
      return _ExpYearValidationResults(
        isValid: false,
        isPotentiallyValid: firstTwoDigits == firstTwoDigitsCurrYear,
        expiresThisYear: isCurrYear,
        message: 'Expiration year is 3 digits long',
      );
    }

    if (expYearStr.length > 4) {
      return _ExpYearValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        expiresThisYear: isCurrYear,
        message: 'Expiration year is longer than 4 digits',
      );
    }

    bool isValid = false;
    String failedMessage =
        'Expiration year either has passed already or is too far into the future';

    if (expYearStr.length == 2) {
      // Two digit year
      int lastTwoDigitsCurrYear = int.parse(fourDigitCurrYearStr.substring(2));
      isValid = (expYear >= lastTwoDigitsCurrYear &&
          expYear <= lastTwoDigitsCurrYear + maxYearsTillExpiration);
      isCurrYear = expYear == lastTwoDigitsCurrYear;
    } else if (expYearStr.length == 4) {
      // Four digit year
      isValid = (expYear >= fourDigitCurrYear &&
          expYear <= fourDigitCurrYear + maxYearsTillExpiration);
      isCurrYear = expYear == fourDigitCurrYear;
    }

    if (isValid) {
      failedMessage = null;
    }

    return _ExpYearValidationResults(
      isValid: isValid,
      isPotentiallyValid: isValid,
      expiresThisYear: isCurrYear,
      message: failedMessage,
    );
  }

  _ExpMonthValidationResults _validateExpMonth(String expMonthStr) {
    int currMonth = DateTime.now().month;
    int expMonth = int.parse(expMonthStr);

    bool isValid = expMonth > 0 && expMonth < 13;
    bool isValidForThisYear = isValid && expMonth >= currMonth;

    return _ExpMonthValidationResults(
      isValid: isValid,
      isPotentiallyValid: isValid,
      isValidForCurrentYear: isValidForThisYear,
    );
  }

  /// Parses the string form of the expiration date and returns the month and year
  /// as a `List<String>`
  ///
  /// Allows for the following date formats:
  ///     'MM/YY'
  ///     'MM/YYY'
  ///     'MM/YYYY'
  ///
  /// This function will replace hyphens with slashes for dates that have hyphens in them
  /// and remove any whitespace
  List<String> _parseDate(String expDateStr) {
    // Replace hyphens with slashes and remove whitespaces
    String formattedStr = expDateStr.replaceAll('-', '/')
      ..replaceAll(_whiteSpaceRegex, '');

    Match match = _expDateFormat.firstMatch(formattedStr);
    if (match != null) {
      print("matched! ${match[0]}");
    } else {
      return null;
    }

    List<String> monthAndYear = match[0].split('/');

    return monthAndYear;
  }

  /// The regex for acceptable expiration date formats
  /// In plain english the steps are:
  ///       1) The month:
  ///           a '0' followed by a number between '1' & '9 '
  ///           OR
  ///           a '1' followed by a number between '0' & '2'
  ///       2) The slash:
  ///            a '/' (forward slash)
  ///       3) The year:
  ///           any combo of 2-4 numeric characters
  RegExp _expDateFormat = RegExp(r'((0[1-9])|(1[0-2]))(/)+(\d{2,4})');

  RegExp _whiteSpaceRegex = RegExp(r'-|\s+\b|\b\s');

  RegExp _alphaCharsRegex = RegExp(r'[a-zA-Z]');
}
