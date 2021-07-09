## Up next
* "Validate" card holder name and postal codes

## [2.0.0]
* Official null safety support

## [2.0.0-nullsafety.0]
* Initial null safety changes

## [1.2.0]
* Card type parameter is now **required** when validating security codes
* More cards supported:
  * Diners Club
  * JCB
  * Union Pay
  * Maestro
  * Mir
  * Elo
  * Hiper/Hipercard
* Unit tests all setup and passing
* Fixed expiration date regex
* Added security code validation based on length

## [1.1.0]
* Fixed error that happened when validating card number of cards that are not supported

## [1.0.1]
* Added better usage example

## [1.0.0] - Oct 27, 2020
* Finalized method and class declarations

## [0.1.0] - July 29, 2019
* Security code validation

## [0.0.2] - April 18, 2019
* Expiration date validation
  * Allows for dates with the following formats:
    * MM/YYYY
    * MM/YYY *will only happen when the user is typing in a 4 digit year*
    * MM/YY
  * Also makes sure the expiration year isn't beyond a certain limit, default is 19

## [0.0.1] - April 15, 2019

* Initial release
* Card number validation supported for:
  * Visa
  * American Express
  * Discover
  * MasterCard
