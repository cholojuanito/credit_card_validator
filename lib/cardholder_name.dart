import 'validation_results.dart';

/// Validates the card holder's name
/// 
/// Reminder: This package does not check with the user's bank or 
/// credit card company. Please use a payment processing 
/// service like Stripe or Braintree for that.

/// Checks that the card holder's name:
///   1) is reasonable, just letters, no numbers or weird characters. Sorry X Æ A-12 Musk
///   2) is less than 256 characters long
ValidationResults validateCardHolderName(String name) {
  // TODO implement
  throw UnimplementedError();
}