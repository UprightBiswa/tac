import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';
import 'package:tac_app/features/booking/domain/booking.dart';

/// 12 · Booking confirmed. Also opened from My rides.
class BookingConfirmedScreen extends ConsumerWidget {
  const BookingConfirmedScreen({super.key, required this.bookingRef});

  final String bookingRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingByRefProvider(bookingRef));
    final router = GoRouter.of(context);

    // Reached with context.go after booking, so system back should land on Home.
    return PopScope(
      canPop: router.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: () => router.canPop() ? context.pop() : context.go(AppRoutes.home),
          ),
        ),
        body: booking == null ? const Center(child: Text('Booking not found.')) : _Summary(booking: booking),
        bottomNavigationBar: booking == null || booking.status != BookingStatus.upcoming
            ? null
            : BottomCta(
                children: [
                  PrimaryButton(
                    label: 'Start trip (demo)',
                    icon: Icons.navigation_outlined,
                    onPressed: () => context.push(AppRoutes.trip(bookingRef)),
                  ),
                  OutlinedButton(onPressed: () => context.go(AppRoutes.myRides), child: const Text('View my rides')),
                  TextButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Back to home')),
                ],
              ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final ride = booking.ride;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      children: [
        SuccessHeader(title: 'Seat booked with ${ride.driver.firstName}', subtitle: 'Booking ref ${booking.ref}'),
        Gap.h24,
        SectionCard(
          child: Column(
            children: [
              InfoRow('Route', '${ride.from.city} → ${ride.to.city}'),
              InfoRow('When', '${formatDay(ride.date)}, ${ride.departTime}'),
              InfoRow('Pickup', booking.pickup),
              InfoRow('Seats', '${booking.seats}'),
              InfoRow('Payment', booking.payment.label),
              const Divider(height: AppSizes.s16),
              InfoRow('Total', formatEuro(booking.totalCents), emphasis: true),
            ],
          ),
        ),
        Gap.h12,
        Container(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: AppColors.successSoft,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: Text(
            "You'll save ~${booking.co2SavedKg} kg CO₂ on this trip 🌱",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.success),
          ),
        ),
        Gap.h16,
      ],
    );
  }
}
