import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/count_stepper.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';
import 'package:tac_app/features/booking/domain/booking.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// 11 · Book ride
class BookRideScreen extends ConsumerWidget {
  const BookRideScreen({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(rideByIdProvider(rideId))
        .when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(e.toString())),
          ),
          data: (ride) => _BookingForm(ride: ride),
        );
  }
}

class _BookingForm extends ConsumerStatefulWidget {
  const _BookingForm({required this.ride});

  final Ride ride;

  @override
  ConsumerState<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends ConsumerState<_BookingForm> {
  late int _seats = ref.read(rideSearchProvider).seats.clamp(1, widget.ride.seatsLeft);
  late String _pickup = widget.ride.pickup;
  PaymentMethod _payment = PaymentMethod.card;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  BookingRequest get _request =>
      BookingRequest(ride: widget.ride, seats: _seats, pickup: _pickup, payment: _payment, note: _note.text.trim());

  Future<void> _confirm() async {
    final booking = await ref.read(bookingControllerProvider.notifier).confirm(_request);
    if (!mounted) return;
    if (booking == null) {
      showToast(ref.read(bookingControllerProvider).error?.toString() ?? 'Booking failed. Please try again.');
      return;
    }
    context.go(AppRoutes.booking(booking.ref));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final ride = widget.ride;
    final request = _request;
    final confirming = ref.watch(bookingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Book your seat')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          SectionCard(
            child: Row(
              children: [
                InitialsAvatar(ride.driver.initials),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${ride.from.city} → ${ride.to.city}', style: text.titleSmall),
                      Text(
                        '${formatDay(ride.date)}, ${ride.departTime} with ${ride.driver.firstName}',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.h12,
          SectionCard(
            child: CountStepper(
              label: 'Seats',
              caption: '${ride.seatsLeft} available',
              value: _seats,
              min: 1,
              max: ride.seatsLeft,
              onChanged: (v) => setState(() => _seats = v),
            ),
          ),
          Gap.h12,
          SectionCard(
            title: 'Pickup point',
            child: RadioGroup<String>(
              groupValue: _pickup,
              onChanged: (v) => setState(() => _pickup = v!),
              child: Column(
                children: [
                  for (final option in ride.pickupOptions)
                    RadioListTile<String>(value: option, title: Text(option), contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
          ),
          Gap.h12,
          TextField(
            controller: _note,
            maxLength: AppConstants.noteMaxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Note to driver (optional)',
              hintText: 'e.g. I have a small backpack',
            ),
          ),
          Gap.h4,
          SectionCard(
            title: 'Payment',
            child: RadioGroup<PaymentMethod>(
              groupValue: _payment,
              onChanged: (v) => setState(() => _payment = v!),
              child: Column(
                children: [
                  for (final method in PaymentMethod.values)
                    RadioListTile<PaymentMethod>(
                      value: method,
                      title: Text(method.label),
                      subtitle: Text(method.caption),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ),
          Gap.h12,
          SectionCard(
            child: Column(
              children: [
                InfoRow('$_seats × ${formatEuro(ride.pricePerSeatCents)}', formatEuro(request.subtotalCents)),
                InfoRow('Service fee', formatEuro(AppConstants.serviceFeeCents)),
                const Divider(height: AppSizes.s16),
                InfoRow('Total', formatEuro(request.totalCents), emphasis: true),
              ],
            ),
          ),
          Gap.h12,
          const DemoNote('Demo: no payment is taken and no seat is reserved.'),
          Gap.h16,
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Confirm booking', loading: confirming, onPressed: _confirm)],
      ),
    );
  }
}
