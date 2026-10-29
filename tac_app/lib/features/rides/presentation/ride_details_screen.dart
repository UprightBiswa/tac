import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/map_preview.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';
import 'package:tac_app/features/rides/domain/ride.dart';
import 'package:tac_app/features/rides/presentation/widgets/ride_card.dart';

/// 10 · Ride details
class RideDetailsScreen extends ConsumerWidget {
  const RideDetailsScreen({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(rideByIdProvider(rideId));
    return Scaffold(
      appBar: AppBar(title: const Text('Ride details')),
      body: ride.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (ride) => _Details(ride: ride),
      ),
      bottomNavigationBar: ride.hasValue
          ? BottomCta(
              children: [
                Row(
                  spacing: AppSizes.s8,
                  children: [
                    IconButton.outlined(
                      tooltip: 'Message driver',
                      onPressed: () => showToast('Chat is not in the POC yet.'),
                      icon: const Icon(Icons.chat_bubble_outline),
                      constraints: const BoxConstraints.tightFor(
                        width: AppSizes.buttonHeight,
                        height: AppSizes.buttonHeight,
                      ),
                      style: IconButton.styleFrom(side: const BorderSide(color: AppColors.line)),
                    ),
                    Expanded(
                      child: PrimaryButton(label: 'Book seat', onPressed: () => context.push(AppRoutes.book(rideId))),
                    ),
                  ],
                ),
              ],
            )
          : null,
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      children: [
        const MapPreview(height: 170, showRoute: true),
        Gap.h16,
        SectionCard(
          title: formatDay(ride.date),
          child: Column(
            children: [
              _Stop(time: ride.departTime, place: '${ride.from.city}, ${ride.pickup}', color: AppColors.navy),
              _Stop(time: ride.arriveTime, place: ride.dropOff, color: AppColors.primary),
            ],
          ),
        ),
        Gap.h12,
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialsAvatar(ride.driver.initials, size: 52),
                  Gap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride.driver.name, style: text.titleMedium),
                        Row(
                          children: [
                            RatingText(rating: ride.driver.rating, reviews: ride.driver.reviews),
                            Text(' · ${ride.driver.ridesCompleted} rides', style: text.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap.h12,
              Wrap(
                spacing: AppSizes.s8,
                runSpacing: AppSizes.s4,
                children: [
                  if (ride.driver.idVerified) const TagPill('ID verified', icon: Icons.verified_user_outlined),
                  if (ride.driver.phoneVerified) const TagPill('Phone verified', icon: Icons.phone_iphone),
                ],
              ),
              Gap.h8,
              Text('Sample profile. Verification is not real in this demo.', style: text.bodySmall),
            ],
          ),
        ),
        Gap.h12,
        SectionCard(
          title: 'Car',
          child: Row(
            children: [
              Icon(ride.car.isElectric ? Icons.electric_car : Icons.directions_car, color: AppColors.navy),
              Gap.w12,
              Expanded(child: Text(ride.car.label, style: text.bodyMedium)),
            ],
          ),
        ),
        Gap.h12,
        SectionCard(
          title: 'Preferences',
          child: Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: [for (final p in ride.preferences) Chip(label: Text(p))],
          ),
        ),
        Gap.h12,
        SectionCard(
          child: Column(
            children: [
              InfoRow('Price per seat', formatEuro(ride.pricePerSeatCents), emphasis: true),
              InfoRow('Seats left', '${ride.seatsLeft}'),
              InfoRow('CO₂ saved vs driving alone', '~${ride.co2SavedKg} kg'),
            ],
          ),
        ),
        Gap.h16,
      ],
    );
  }
}

class _Stop extends StatelessWidget {
  const _Stop({required this.time, required this.place, required this.color});

  final String time;
  final String place;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s4),
      child: Row(
        children: [
          SizedBox(width: 52, child: Text(time, style: text.titleSmall)),
          Icon(Icons.circle, size: 12, color: color),
          Gap.w12,
          Expanded(child: Text(place, style: text.bodyMedium)),
        ],
      ),
    );
  }
}
