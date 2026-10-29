import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

enum PaymentMethod {
  card('Card •••• 4242', 'Demo card: no payment is taken'),
  cash('Cash to driver', 'Pay the driver on the day');

  const PaymentMethod(this.label, this.caption);

  final String label;
  final String caption;
}

enum BookingStatus { upcoming, completed }

/// What the rider submits on screen 11.
class BookingRequest {
  const BookingRequest({
    required this.ride,
    required this.seats,
    required this.pickup,
    required this.payment,
    this.note = '',
  });

  final Ride ride;
  final int seats;
  final String pickup;
  final PaymentMethod payment;
  final String note;

  int get subtotalCents => ride.pricePerSeatCents * seats;

  int get totalCents => subtotalCents + AppConstants.serviceFeeCents;
}

class Booking {
  const Booking({
    required this.ref,
    required this.ride,
    required this.seats,
    required this.pickup,
    required this.payment,
    required this.totalCents,
    this.status = BookingStatus.upcoming,
    this.rating,
  });

  final String ref;
  final Ride ride;
  final int seats;
  final String pickup;
  final PaymentMethod payment;
  final int totalCents;
  final BookingStatus status;
  final int? rating;

  int get co2SavedKg => ride.co2SavedKg;

  Booking complete({required int rating}) => Booking(
    ref: ref,
    ride: ride,
    seats: seats,
    pickup: pickup,
    payment: payment,
    totalCents: totalCents,
    status: BookingStatus.completed,
    rating: rating,
  );
}
