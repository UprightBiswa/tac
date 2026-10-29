import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/map_preview.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';
import 'package:tac_app/features/rides/presentation/widgets/ride_card.dart';

/// 14 · Trip in progress (simulated: the car moves along a drawn route).
class TripScreen extends ConsumerStatefulWidget {
  const TripScreen({super.key, required this.bookingRef});

  final String bookingRef;

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> with SingleTickerProviderStateMixin {
  late final _car = AnimationController(vsync: this, duration: AppConstants.demoTripDuration)..forward();

  @override
  void dispose() {
    _car.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final booking = ref.watch(bookingByRefProvider(widget.bookingRef));
    if (booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Trip not found.')),
      );
    }
    final driver = booking.ride.driver;

    return Scaffold(
      appBar: AppBar(title: const Text('On your way'), actions: const [DemoBadge(), Gap.w16]),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          AnimatedBuilder(
            animation: _car,
            builder: (context, _) {
              final minutes = (AppConstants.demoTripMinutes * (1 - _car.value)).ceil();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MapPreview(height: 280, carProgress: _car.value),
                  Gap.h16,
                  Text(minutes > 0 ? 'Arriving in $minutes min' : 'You have arrived', style: text.headlineSmall),
                ],
              );
            },
          ),
          Text('${booking.ride.to.label} · drop-off', style: text.bodyMedium?.copyWith(color: AppColors.muted)),
          Gap.h16,
          SectionCard(
            child: Row(
              children: [
                InitialsAvatar(driver.initials),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driver.name, style: text.titleSmall),
                      Text(booking.ride.car.label, style: text.bodySmall),
                    ],
                  ),
                ),
                RatingText(rating: driver.rating, reviews: driver.reviews),
              ],
            ),
          ),
          Gap.h16,
          OutlinedButton.icon(
            onPressed: () => showToast('SOS and safety tools come in a later phase.'),
            icon: const Icon(Icons.sos, color: AppColors.error),
            label: const Text('SOS', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [
          PrimaryButton(
            label: 'End trip (demo)',
            onPressed: () => context.pushReplacement(AppRoutes.rate(widget.bookingRef)),
          ),
        ],
      ),
    );
  }
}
