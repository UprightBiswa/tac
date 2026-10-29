import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/router/app_shell.dart';
import 'package:tac_app/features/booking/presentation/book_ride_screen.dart';
import 'package:tac_app/features/booking/presentation/booking_confirmed_screen.dart';
import 'package:tac_app/features/booking/presentation/my_rides_screen.dart';
import 'package:tac_app/features/booking/presentation/rate_trip_screen.dart';
import 'package:tac_app/features/booking/presentation/trip_screen.dart';
import 'package:tac_app/features/driver/presentation/offer_price_screen.dart';
import 'package:tac_app/features/driver/presentation/offer_published_screen.dart';
import 'package:tac_app/features/driver/presentation/offer_ride_screen.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';
import 'package:tac_app/features/onboarding/presentation/details_screen.dart';
import 'package:tac_app/features/onboarding/presentation/google_stub_screen.dart';
import 'package:tac_app/features/onboarding/presentation/location_screen.dart';
import 'package:tac_app/features/onboarding/presentation/manual_address_screen.dart';
import 'package:tac_app/features/onboarding/presentation/otp_screen.dart';
import 'package:tac_app/features/onboarding/presentation/phone_screen.dart';
import 'package:tac_app/features/onboarding/presentation/splash_screen.dart';
import 'package:tac_app/features/onboarding/presentation/welcome_screen.dart';
import 'package:tac_app/features/profile/presentation/profile_screen.dart';
import 'package:tac_app/features/rides/presentation/home_screen.dart';
import 'package:tac_app/features/rides/presentation/results_screen.dart';
import 'package:tac_app/features/rides/presentation/ride_details_screen.dart';
import 'package:tac_app/features/rides/presentation/search_screen.dart';

GoRoute _route(String path, Widget Function(GoRouterState state) build) =>
    GoRoute(path: path, builder: (context, state) => build(state));

/// The single route table. Guards live in [GoRouter.redirect], not in screens.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final onboarded = ref.read(sessionProvider).onboarded;
      final inOnboarding = AppRoutes.onboarding.contains(state.matchedLocation);
      if (!onboarded && !inOnboarding) return AppRoutes.splash;
      if (onboarded && inOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      // Onboarding
      _route(AppRoutes.splash, (_) => const SplashScreen()),
      _route(AppRoutes.welcome, (_) => const WelcomeScreen()),
      _route(AppRoutes.google, (_) => const GoogleStubScreen()),
      _route(AppRoutes.phone, (_) => const PhoneScreen()),
      _route(AppRoutes.otp, (_) => const OtpScreen()),
      _route(AppRoutes.details, (_) => const DetailsScreen()),
      _route(AppRoutes.location, (_) => const LocationScreen()),
      _route(AppRoutes.manualAddress, (_) => const ManualAddressScreen()),

      // Tabs with the bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [_route(AppRoutes.home, (_) => const HomeScreen())]),
          StatefulShellBranch(routes: [_route(AppRoutes.myRides, (_) => const MyRidesScreen())]),
          StatefulShellBranch(routes: [_route(AppRoutes.profile, (_) => const ProfileScreen())]),
        ],
      ),

      // Rider, full screen
      _route(AppRoutes.search, (_) => const SearchScreen()),
      _route(AppRoutes.results, (_) => const ResultsScreen()),
      _route('/ride/:id', (s) => RideDetailsScreen(rideId: s.pathParameters['id']!)),
      _route('/ride/:id/book', (s) => BookRideScreen(rideId: s.pathParameters['id']!)),
      _route('/booking/:ref', (s) => BookingConfirmedScreen(bookingRef: s.pathParameters['ref']!)),
      _route('/trip/:ref', (s) => TripScreen(bookingRef: s.pathParameters['ref']!)),
      _route('/trip/:ref/rate', (s) => RateTripScreen(bookingRef: s.pathParameters['ref']!)),

      // Driver
      _route(AppRoutes.offer, (_) => const OfferRideScreen()),
      _route(AppRoutes.offerPrice, (_) => const OfferPriceScreen()),
      _route(AppRoutes.offerPublished, (_) => const OfferPublishedScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
