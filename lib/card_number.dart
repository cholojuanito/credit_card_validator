import 'dart:math';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

import 'luhn.dart';
import 'regexs.dart';
import 'validation_results.dart';

/// Validates the credit card number and determines
/// the credit card type as well


/// A mapping of possible credit card types to their respective possible card number lengths
const Map<CreditCardType, List<int>> _ccNumLengths = {
  CreditCardType.visa: [16, 18, 19],
  CreditCardType.mastercard: [16],
  CreditCardType.amex: [15],
  CreditCardType.discover: [16, 19],
  CreditCardType.dinersclub: [14, 16, 19],
  CreditCardType.jcb: [16, 17, 18, 19],
  CreditCardType.unionpay: [14, 15, 16, 17, 18, 19],
  CreditCardType.maestro: [12, 13, 14, 15, 16, 17, 18, 19],
  CreditCardType.elo: [16],
  CreditCardType.mir: [16, 17, 18, 19],
  CreditCardType.hiper: [16],
  CreditCardType.hipercard: [16],
  CreditCardType.unknown: [],
};

/// The default card number length. Set to 19
const int _DEFAULT_MAX_CARD_NUM_LENGTH = 19;

/// Default string returned on a failed validation
const String _DEFAULT_FAIL_MESSAGE = 'Invalid credit card number';

/// Validates a credit card number that is passed in as a string
/// Args:
/// * `ccNumStr` (`String`): may have spaces or hyphens but no non-numeric characters
/// * `luhnValidateUnionPay` (`bool`): determines if the UnionPay card's number should be checked for Luhn validity. 
///  Default is to not check since some UnionPay cards do not use the Luhn algorithm.
CCNumValidationResults validateCardNumber(String ccNumStr, 
  {bool luhnValidateUnionPay = false}) {
    // Replace any whitespace or hyphens
    String trimmedNumStr = ccNumStr.replaceAll(whiteSpaceRegex, '');

    // If the str is empty or contains any non-numeric characters
    if (trimmedNumStr.isEmpty || trimmedNumStr.contains(nonNumberRegex)) {
      return CCNumValidationResults(
        ccType: CreditCardType.unknown,
        isValid: false,
        isPotentiallyValid: false,
        message: 'No input or contains non-numerical characters',
      );
    }

    CreditCardType type = detectCCType(trimmedNumStr);
    // Card type couldn't be detected but it is still potentially valid
    // TODO change? because then any unknown card could be potentially valid
    if (type == CreditCardType.unknown) {
      return CCNumValidationResults(
        ccType: type,
        isValid: false,
        isPotentiallyValid: true,
        message: _DEFAULT_FAIL_MESSAGE
      );
    }

    // Card number is longer than the industry standard of 19. Not valid nor potentially valid
    if (trimmedNumStr.length > _DEFAULT_MAX_CARD_NUM_LENGTH) {
      return CCNumValidationResults(
        ccType: type,
        isValid: false,
        isPotentiallyValid: false,
        message: 'Card number is greater than 19 digits',
      );
    }

    bool isLuhnValid = false;
    bool isPotentiallyValid = false;

    // Check Luhn validity of the number if the conditions are met, usually Luhn validity is checked
    if (type == CreditCardType.unionpay && luhnValidateUnionPay == false) {
      isLuhnValid = true;
    } else { 
      isLuhnValid = checkLuhnValidity(trimmedNumStr);
    }

    int maxCardLength = _ccNumLengths.containsKey(type) ? _ccNumLengths[type].reduce(max) : _DEFAULT_MAX_CARD_NUM_LENGTH;
    String failedMessage = _DEFAULT_FAIL_MESSAGE;

    // Check if the card number length is viable.
    // If it is then decide the potential validity of this card number
    // The card number will be potentially valid if:
    //    The number is luhn valid OR the card number isn't complete yet
    if (_ccNumLengths[type].contains(trimmedNumStr.length)) {
      isPotentiallyValid = isLuhnValid || trimmedNumStr.length < maxCardLength;

      if (isLuhnValid && isPotentiallyValid) {
        failedMessage = null; // Not a failed validation
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
      failedMessage = null; // Not an failed validation since there could be more digits being typed in
    }
    // Not a valid card but if the str passed in is 'incomplete' it is potentially valid
    // Incomplete means that the str passed in isn't as long as the max allowed card length
    return CCNumValidationResults(
      ccType: type,
      isValid: false,
      isPotentiallyValid: potentialForMoreDigits,
      message: failedMessage,
    );
  }