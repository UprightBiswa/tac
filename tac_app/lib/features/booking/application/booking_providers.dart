import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/notifications/notification_service.dart';
import 'package:tac_app/features/booking/data/bookings_repository.dart';
import 'package:tac_app/features/booking/domain/booking.dart';

/// Bookings made in this session (screen 13 "Upcoming", then "Past" once rated).
class MyBookingsController extends Notifier<List<Booking>> {
  @override
  List<Booking> build() => const [];

  void add(Booking booking) => state = [booking, ...state];

  void complete(String ref, {required int rating}) =>
      state = [for (final b in state) b.ref == ref ? b.complete(rating: rating) : b];
}

final myBookingsProvider = NotifierProvider<MyBookingsController, List<Booking>>(MyBookingsController.new);

final bookingByRefProvider = Provider.family<Booking?, String>(
  (ref, bookingRef) => ref.watch(myBookingsProvider).where((b) => b.ref == bookingRef).firstOrNull,
);

final pastTripsProvider = FutureProvider<List<Booking>>((ref) => ref.watch(bookingsRepositoryProvider).pastTrips());

/// Confirms a booking (screen 11 → 12). The UI watches `isLoading` for the spinner.
class BookingController extends AsyncNotifier<Booking?> {
  @override
  Future<Booking?> build() async => null;

  Future<Booking?> confirm(BookingRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(bookingsRepositoryProvider).create(request));
    final booking = state.value;
    if (booking != null) {
      ref.read(myBookingsProvider.notifier).add(booking);
      ref
          .read(notificationServiceProvider)
          .showForeground(
            title: 'Booking confirmed',
            body: '${booking.ride.driver.firstName} will pick you up at ${booking.pickup}.',
          );
    }
    return booking;
  }
}

final bookingControllerProvider = AsyncNotifierProvider<BookingController, Booking?>(BookingController.new);
