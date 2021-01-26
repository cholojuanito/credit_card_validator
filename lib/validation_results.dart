import 'package:credit_card_type_detector/credit_card_type_detector.dart';

/// Contains classes that hold the results for credit card validations

/// A class that contains the results from the validation process
/// Each of the parts of the credit card are either 'valid' or 'potentially valid'
///
class ValidationResults {
  /// Whether or not the part of the card in question was valid
  bool isValid;

  /// Whether or not the part of the card in question has the potential to be valid
  bool isPotentiallyValid;

  /// A message that contains the reason why the validation failed
  /// NOTE: This will only be present if both `isValid` and `isPotentiallyValid` are false
  String message;

  ValidationResults({
    required this.isValid,
    required this.isPotentiallyValid,
    this.message = '',
  });
}

class CCNumValidationResults extends ValidationResults {
  /// The type of the credit card that was validated
  /// This is meant to be used in the other validation processes
  /// because the card number length and security codes depend on this
  CreditCardType ccType;

  CCNumValidationResults({
    required this.ccType,
    required bool isValid,
    required bool isPotentiallyValid,
    String message = '',
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
        );
}

class ExpYearValidationResults extends ValidationResults {
  /// Whether or not the card expires this year
  bool expiresThisYear;

  ExpYearValidationResults({
    required this.expiresThisYear,
    required bool isValid,
    required bool isPotentiallyValid,
    String message = '',
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
        );
}

class ExpMonthValidationResults extends ValidationResults {
  /// Whether or not the card is good if it expires this year
  bool isValidForCurrentYear;

  ExpMonthValidationResults({
    required this.isValidForCurrentYear,
    required bool isValid,
    required bool isPotentiallyValid,
    String message = '',
  }) : super(
          isValid: isValid,
          isPotentiallyValid: isPotentiallyValid,
          message: message,
        );
}