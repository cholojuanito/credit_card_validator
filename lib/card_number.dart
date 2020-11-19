import 'dart:math';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

import 'luhn.dart';
import 'regexs.dart';
import 'validation_results.dart';

/// Validates the credit card number and determines
/// the credit card type as well


/// A mapping of possible credit card types to their respective possible card number lengths
const Map<CreditCardType, List<int>> ccNumLengths = {
  CreditCardType.visa: [16, 18, 19],
  CreditCardType.mastercard: [16],
  CreditCardType.amex: [15],
  CreditCardType.discover: [16, 19],
  CreditCardType.unknown: [],
};

/// The default card number length. Set to 19
const int DEFAULT_MAX_CARD_NUM_LENGTH = 19;

/// Validates a credit card number that is passed in as a string
  /// The string may have spaces or hyphens but no letters
  CCNumValidationResults validateCardNumber(String ccNumStr) {
    // If the str is empty or contains any letters
    if (ccNumStr.isEmpty || ccNumStr.contains(alphaCharsRegex)) {
      return CCNumValidationResults(
        ccType: CreditCardType.unknown,
        isValid: false,
        isPotentiallyValid: false,
        message: 'No input or contains alphabetic characters',
      );
    }

    // Replace any whitespace or hyphens
    String trimmedNumStr = ccNumStr.replaceAll(whiteSpaceRegex, '');

    CreditCardType type = detectCCType(trimmedNumStr);
    // Card type couldn't be detected but it is still potentially valid
    // TODO change? because then any unknown card could be potentially valid
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
    isLuhnValid = checkLuhnValidity(trimmedNumStr);

    int maxCardLength = ccNumLengths.containsKey(type) ? ccNumLengths[type].reduce(max) : DEFAULT_MAX_CARD_NUM_LENGTH;

    // Check if the card number length is viable.
    // If it is then decide the potential validity of this card number
    // The card number will be potentially valid if:
    //    The number is luhn valid OR the card number isn't complete yet
    if (ccNumLengths[type].contains(trimmedNumStr.length)) {
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