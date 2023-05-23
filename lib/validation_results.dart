import 'package:credit_card_type_detector/models.dart';

/// A class that contains the results from a validation process.
/// Each of the parts of the credit card are either `valid` or `potentially valid`
class ValidationResults {
  /// Whether or not the part of the card in question was valid
  bool isValid;

  /// Whether or not the part of the card in question has the potential to be valid
  bool isPotentiallyValid;

  /// A message that contains the reason why the validation failed. Default is an empty string
  String message;

  ValidationResults({
    required this.isValid,
    required this.isPotentiallyValid,
    this.message = '',
  });
}

/// Validation reults that are specific to credit card number validations. It contains the type of credit card
/// in addition to the other properties found in [ValidationResults]
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

/// Validation results specific to the year part of the expiration date. It contains a information about
/// whether or not the card expires this calendar year in addition to the other properties found in [ValidationResults]
/// 
/// This is used internally so you should not worry about using it
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

/// Validation results specific to the month part of the expiration date. It contains a information about
/// whether or not the card is still valid for this calendar year in addition to the other properties found in [ValidationResults]
/// 
/// This is used internally so you should not worry about using it
class ExpMonthValidationResults extends ValidationResults {
  /// Whether or not the card is good for this calendar year
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