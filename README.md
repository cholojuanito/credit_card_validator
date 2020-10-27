# credit_card_validator | Credit Card Validator
A Dart package that validates credit card numbers, expiration dates, and security codes (CVV/CVC) of a credit card. It also determines the type of credit card as part of the validation process.

This package should be used to quickly validate credit card data inputs and provide feedback to the user in your application's UI. It includes support for "potentially valid" inputs so that you can appropriately display the results to the user as they type.

**This package does not verify the information with the user's bank or credit company. Please use a payment processing service like Stripe or Braintree for true verification and validation of the user's payment info.**

# Installing
1. Add dependency to `pubspec.yaml`

    *Get the current version in the 'Installing' tab on pub.dartlang.org*
```
dependencies:
    credit_card_validator: *current-version*
```

2. Import the package
```
import 'package:credit_card_validator/credit_card_validator.dart';
```

#  Usage
A basic example
```
import 'package:credit_card_validator/credit_card_validator.dart';

class CreditCardValidationBloc {
    CreditCardValidator _ccValidator = CreditCardValidator()

    bool validateCreditCardInfo(string ccNum, string expDate, string cvv, ...) {
        var ccNumResults = _ccValidator.validateCCNum(ccNum);
        var expDateResults = _ccValidator.validateExpDate(expDate);
        var cvvResults = _ccValidator.validateCVV(cvv);
        ...

        if(ccNumResults.isPotentiallyValid) {
            # Call UI code that shows to the user their credit card number is invalid
            displayInvalidCardNumber();
        }
    }
}

```

# Features
* Supported cards:
  * Visa
  * Mastercard
  * American Express
  * Discover
  * More to come!

# Original Repo
This lab is based off of [Braintree's Credit Card Validator JS package](https://github.com/braintree/card-validator)

# Author
Tanner Davis (Cholojuanito) - *Creator and repo owner* - [Github Profile](https://github.com/cholojuanito)

# License
This project is licensed under the MIT License - see the [LICENSE file](LICENSE) for more details