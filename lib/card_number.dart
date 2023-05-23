import 'dart:math';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';

import 'luhn.dart';
import 'regexs.dart';
import 'validation_results.dart';

/// Validates the credit card number and determines
/// the credit card type as well

/// Default string returned on a failed validation
const String _DEFAULT_FAIL_MESSAGE = 'Invalid credit card number';


const String _UNKNOWN_TYPE = 'unknown';
const String _UNKNOWN_PRETTY_TYPE = 'Unknown';

final CreditCardType UNKNOWN_CARD_TYPE = CreditCardType(
  _UNKNOWN_TYPE,
  _UNKNOWN_PRETTY_TYPE,
  [],
  Set<Pattern>(),
  SecurityCode.cvv(),
);

/// Validates a credit card number that is passed in as a string.
/// 
/// `luhnValidateUnionPay`: determines if this UnionPay card's number should be checked for Luhn validity. 
///  Default is to not check since some UnionPay cards do not use the Luhn algorithm.
CCNumValidationResults validateCardNumber(String ccNumStr, {
  bool luhnValidateUnionPay = false, 
  bool ignoreLuhnValidation = false,
}) {
    // Replace any whitespace or hyphens
    String trimmedNumStr = ccNumStr.replaceAll(whiteSpaceRegex, '');

    // If the str is empty or contains any non-numeric characters
    if (trimmedNumStr.isEmpty || trimmedNumStr.contains(nonNumberRegex)) {
      return CCNumValidationResults(
        ccType: UNKNOWN_CARD_TYPE,
        isValid: false,
        isPotentiallyValid: false,
        message: 'No input or contains non-numerical characters',
      );
    }

    List<CreditCardType> types = detectCCType(trimmedNumStr);
    // Card type couldn't be detected but it is still potentially valid
    if (types.isEmpty) {
      return CCNumValidationResults(
        ccType: UNKNOWN_CARD_TYPE,
        isValid: false,
        isPotentiallyValid: true,
        message: _DEFAULT_FAIL_MESSAGE
      );
    }
    else if (types.length > 1) {
      return CCNumValidationResults(
        ccType: UNKNOWN_CARD_TYPE,
        isValid: false,
        isPotentiallyValid: true,
        message: 'Multiple card types detected: [${types.map((e) => e.prettyType).join(", ")}]',
      );
    }

    CreditCardType type = types[0];
    int maxCardLength = type.lengths.reduce(max);

    bool isLuhnValid = false;
    bool isPotentiallyValid = false;
    if (ignoreLuhnValidation) {
      isLuhnValid = true;
    }
    else {
        // Check Luhn validity of the number if the conditions are met, usually Luhn validity is checked
      if (types.contains(CreditCardType.unionPay()) && luhnValidateUnionPay == false) {
        isLuhnValid = true;
      } else { 
        isLuhnValid = checkLuhnValidity(trimmedNumStr);
      }
    }
    
    String failedMessage = _DEFAULT_FAIL_MESSAGE;

    // Check if the card number length is viable.
    // If it is then decide the potential validity of this card number
    // The card number will be potentially valid if:
    //    The number is luhn valid OR the card number isn't complete yet
    if (type.lengths.contains(trimmedNumStr.length)) {
      isPotentiallyValid = isLuhnValid || trimmedNumStr.length < maxCardLength;

      if (isLuhnValid && isPotentiallyValid) {
        failedMessage = ''; // Not a failed validation
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
      failedMessage = ''; // Not an failed validation since there could be more digits being typed in
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