# credit_card_validator | Credit Card Validator
A Dart package that validates credit card numbers, expiration dates, and security codes (CVV/CVC) of a credit card. It also determines the type of credit card as part of the validation process.

This package should be used to quickly validate credit card data inputs and provide feedback to the user in your application's UI. It includes support for "potentially valid" inputs so that you can appropriately display the results to the user as they type.

**Important: This package does not verify the information with the user's bank or credit company. Please use a payment processing service like Stripe or Braintree for true verification and validation of the user's payment info.**

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
        var cvvResults = _ccValidator.validateCVV(cvv, ccNumResults.ccType);
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
  * Diners Club
  * JCB
  * Union Pay
  * Maestro
  * Mir
  * Elo
  * Hiper/Hipercard

# Original Repo
This package is based off of [Braintree's Credit Card Validator JS package](https://github.com/braintree/card-validator)

# Author
Cholojuanito (Tanner Davis) - *Creator and repo owner* - [Github Profile](https://github.com/cholojuanito)

# Support
If you think this package is helpful, tell your friends, give it a star on GitHub, and a like on [pub.dev](https://pub.dev/packages/credit_card_type_detector)

I also have a Patreon if you are feeling extra generous

[![Patreon](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fwww.patreon.com%2Fapi%2Fcampaigns%2F6586046&query=data.attributes.patron_count&suffix=%20Patrons&color=FF5441&label=Patreon&logo=Patreon&logoColor)](https://patreon.com/cholojuanito)

# License
This project is licensed under the MIT License - see the [LICENSE file](LICENSE) for more details
