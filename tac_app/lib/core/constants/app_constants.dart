/// App-wide copy that appears on more than one screen.
abstract final class AppStrings {
  static const appName = 'TAC';
  static const tagline = 'Rides for a cleaner, closer Ireland.';
  static const demoLabel = 'Demo — no backend';
  static const notInPoc = 'Not in the POC yet.';
}

/// Business and demo values. Money is always in euro cents.
abstract final class AppConstants {
  static const serviceFeeCents = 50;
  static const suggestedPriceCents = 1200;
  static const minPriceCents = 500;
  static const maxPriceCents = 4000;
  static const priceStepCents = 50;

  static const maxSeats = 4;
  static const minPhoneDigits = 7;
  static const maxPhoneDigits = 10;
  static const otpLength = 4;
  static const otpResendSeconds = 24;
  static const noteMaxLength = 140;

  static const mockLatency = Duration(milliseconds: 600);
  static const bookingLatency = Duration(milliseconds: 1500);
  static const demoTripDuration = Duration(seconds: 12);
  static const demoTripMinutes = 12;
}
