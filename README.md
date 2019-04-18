# credit_card_validator | Credit Card Validator
A Dart package that validates credit card numbers, expiration dates, and security codes (CVV/CVC) based on the type of credit card

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
### Note:
The `CreditCardValidator` class is meant to be **used as a mixin and is not instantiable or extendable**. 
```
import 'package:credit_card_validator/credit_card_validator.dart';

class CreditCardValidationBloc with CreditCardValidator {
    // Your wrapper class for validating credit cards that now has access to validation functions
    // You can evaluate the results from the functions in your own functions inside this class
}

```

# Features
* Supported cards:
  * Visa
  * Mastercard
  * American Express
  * Discover
  * More to come!


# Author
Tanner Davis (Cholojuanito) - *Creator and repo owner* - [Github Profile](https://github.com/cholojuanito)

# License
This project is licensed under the MIT License - see the [LICENSE file](LICENSE) for more details