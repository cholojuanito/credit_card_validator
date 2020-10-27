import 'validation_results.dart';

/// Validates postal codes for credit cards
/// 
/// Reminder! This package does not check with the user's bank or 
/// credit card company. Please use a payment processing 
/// service like Stripe or Braintree for that.

/// The default minimum postal code string length. Set to 3
const int DEFAULT_MIN_POSTAL_CODE_LENGTH = 3;

/// Checks if the postal code
ValidationResults validatePostalCode(String postalCode, {int minLength}) {
  // TODO implement
  return null;
}