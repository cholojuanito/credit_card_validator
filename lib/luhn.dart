/// Implementation of the Luhn algorithm in Dart.
/// It is also known as the "modulus 10" algorithm
/// 
/// For more info on Luhn algorithm check these URLS
///     https://en.wikipedia.org/wiki/Luhn_algorithm
///     https://www.geeksforgeeks.org/luhn-algorithm
 

/// Checks the validity of the card number using the Luhn algorithm (the modulus 10 algorithm)
/// 
/// This method assumes that the incoming string is trimmed of whitespace 
/// and does not contain non-numerical characters. i.e. 'A-Z', 'a-z', etc.
bool checkLuhnValidity(String ccNum) {
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