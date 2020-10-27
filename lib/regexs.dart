/// Contains regular expressions that are used across files

/// Recognizes all whitespace characters
RegExp whiteSpaceRegex = RegExp(r'-|\s+\b|\b\s');

/// Recognizes all alphabet characters
RegExp alphaCharsRegex = RegExp(r'[a-zA-Z]');

/// Recognizes acceptable expiration date formats
/// In plain english the steps are:
///       1) The month:
///           a '0' followed by a number between '1' & '9 '
///           OR
///           a '1' followed by a number between '0' & '2'
///       2) The slash:
///            a '/' (forward slash)
///       3) The year:
///           any combo of 2-4 numeric characters
RegExp expDateFormat = RegExp(r'((0[1-9])|(1[0-2]))(/)+(\d{2,4})');