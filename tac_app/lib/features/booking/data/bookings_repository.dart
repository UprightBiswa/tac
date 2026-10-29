import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/features/booking/domain/booking.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// Maps to the NestJS Bookings + Payments modules. An `ApiBookingsRepository`
/// using the shared Dio client (like `ApiRidesRepository`) slots in later.
abstract interface class BookingsRepository {
  Future<Booking> create(BookingRequest request);

  Future<List<Booking>> pastTrips();
}

class MockBookingsRepository implements BookingsRepository {
  final _random = Random();

  @override
  Future<Booking> create(BookingRequest request) async {
    await Future<void>.delayed(AppConstants.bookingLatency);
    return Booking(
      ref: 'TAC-${10000 + _random.nextInt(89999)}',
      ride: request.ride,
      seats: request.seats,
      pickup: request.pickup,
      payment: request.payment,
      totalCents: request.totalCents,
    );
  }

  @override
  Future<List<Booking>> pastTrips() async {
    await Future<void>.delayed(AppConstants.mockLatency);
    final now = DateTime.now();
    Booking past(int daysAgo, Place from, Place to, int driver, String ref) {
      final ride = mockRidesFor(
        from: from,
        to: to,
        date: now.subtract(Duration(days: daysAgo)),
      )[driver];
      return Booking(
        ref: ref,
        ride: ride,
        seats: 1,
        pickup: ride.pickup,
        payment: PaymentMethod.card,
        totalCents: ride.pricePerSeatCents + AppConstants.serviceFeeCents,
        status: BookingStatus.completed,
        rating: 5,
      );
    }

    return [
      past(9, const Place('Cork', 'Kent Station'), const Place('Dublin', 'Heuston'), 1, 'TAC-31877'),
      past(23, const Place('Limerick', 'Colbert Station'), const Place('Galway', 'Eyre Square'), 2, 'TAC-29034'),
    ];
  }
}

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) => MockBookingsRepository());
