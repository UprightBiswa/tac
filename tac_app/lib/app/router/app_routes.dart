/// Every route path in one place. Widgets use these, never string literals.
abstract final class AppRoutes {
  // Onboarding (01–06)
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const google = '/welcome/google';
  static const phone = '/phone';
  static const otp = '/otp';
  static const details = '/details';
  static const location = '/location';
  static const manualAddress = '/location/manual';

  // Bottom-nav tabs
  static const home = '/home';
  static const myRides = '/my-rides';
  static const profile = '/profile';

  // Rider (08–15)
  static const search = '/search';
  static const results = '/results';
  static String ride(String id) => '/ride/$id';
  static String book(String id) => '/ride/$id/book';
  static String booking(String ref) => '/booking/$ref';
  static String trip(String ref) => '/trip/$ref';
  static String rate(String ref) => '/trip/$ref/rate';

  // Driver (D1–D3)
  static const offer = '/offer';
  static const offerPrice = '/offer/price';
  static const offerPublished = '/offer/published';

  static const onboarding = {splash, welcome, google, phone, otp, details, location, manualAddress};
}
