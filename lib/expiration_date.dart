import 'regexs.dart';
import 'validation_results.dart';

/// Validates the expiration dates on credit cards

/// The default number of years into the future a card is valid. Set to 19
/// i.e. if the current year is 2019 then a valid card would not have an expiration date greater than 2038
const int _DEFAULT_NUM_YEARS_IN_FUTURE = 19;

String _DEFAULT_YEAR_FAIL_MESSAGE = 'Card has expired';
String _DEFAULT_MONTH_FAIL_MESSAGE = 'Card has expired this year';

/// Validates the card's expiration date 
/// 
/// The expiration date must be in one of the following date formats:
/// * 'MM/YY'
/// * 'MM/YYY'
/// * 'MM/YYYY'
ValidationResults validateExpirationDate(String expDateStr) {
  if (expDateStr.isEmpty) {
    return ValidationResults(
      isValid: false,
      isPotentiallyValid: false,
      message: 'No date given',
    );
  }

  List<String> monthAndYear = _parseDate(expDateStr);
  if (monthAndYear.isEmpty) {
    return ValidationResults(
      isValid: false,
      isPotentiallyValid: false,
      message: 'Invalid date format or invalid dates',
    );
  }

  ExpMonthValidationResults monthValidation =
      _validateExpMonth(monthAndYear[0]);
  ExpYearValidationResults yearValidation =
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

ExpYearValidationResults _validateExpYear(String expYearStr,
    [int? maxYearsInFuture]) {

  if (nonNumberRegex.hasMatch(expYearStr)) {
      return ExpYearValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        expiresThisYear: false,
        message: 'Must have only numbers in dates'
    );
  }

  int fourDigitCurrYear = DateTime.now().year;
  String fourDigitCurrYearStr = fourDigitCurrYear.toString();
  int expYear = int.parse(expYearStr);

  if (expYearStr.length < 2) {
    return ExpYearValidationResults(
      isValid: false,
      isPotentiallyValid: true,
      expiresThisYear: false,
    );
  }

  if (expYearStr.length == 3) {
    // The first 3 digits of a 4 digit year. i.e. 2022, we have the '202'
    // This statement is reached when the user is typing in a full 4 digit year
    int firstTwoDigits = int.parse(expYearStr.substring(0, 2));
    int firstTwoDigitsCurrYear =
        int.parse(fourDigitCurrYearStr.substring(0, 2));
    return ExpYearValidationResults(
      isValid: false,
      isPotentiallyValid: firstTwoDigits == firstTwoDigitsCurrYear,
      expiresThisYear: false,
      message: firstTwoDigits != firstTwoDigitsCurrYear ? 'Expiration year is 3 digits long' : '',
    );
  }

  if (expYearStr.length > 4) {
    return ExpYearValidationResults(
      isValid: false,
      isPotentiallyValid: false,
      expiresThisYear: false,
      message: 'Expiration year is longer than 4 digits',
    );
  }

  bool isValid = false;
  String failedMessage = _DEFAULT_YEAR_FAIL_MESSAGE;
  bool isCurrYear = false;
  int maxYearsTillExpiration = maxYearsInFuture != null
      ? maxYearsInFuture
      : _DEFAULT_NUM_YEARS_IN_FUTURE;

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
    failedMessage = '';
  }

  return ExpYearValidationResults(
    isValid: isValid,
    isPotentiallyValid: isValid,
    expiresThisYear: isCurrYear,
    message: failedMessage,
  );
}

ExpMonthValidationResults _validateExpMonth(String expMonthStr) {

  if (nonNumberRegex.hasMatch(expMonthStr)) {
      return ExpMonthValidationResults(
        isValid: false,
        isPotentiallyValid: false,
        isValidForCurrentYear: false,
        message: 'Must have only numbers in dates'
    );
  }

  int currMonth = DateTime.now().month;
  int expMonth = int.parse(expMonthStr);

  bool isValid = expMonth > 0 && expMonth < 13;
  bool isValidForThisYear = isValid && expMonth >= currMonth;
  String failMessage = _DEFAULT_MONTH_FAIL_MESSAGE;

  if (isValid && isValidForThisYear) {
    failMessage = '';
  }

  return ExpMonthValidationResults(
    isValid: isValid,
    isPotentiallyValid: isValid,
    isValidForCurrentYear: isValidForThisYear,
    message: failMessage
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
    ..replaceAll(whiteSpaceRegex, '');

  Match? match = expDateFormat.firstMatch(formattedStr);
  if (match != null) {
    return match[0]!.split('/');
  } else {
    return [];
  }
}
