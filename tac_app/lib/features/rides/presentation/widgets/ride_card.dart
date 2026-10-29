import 'package:flutter/material.dart';

import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

class RideCard extends StatelessWidget {
  const RideCard({super.key, required this.ride, required this.onTap});

  final Ride ride;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fewSeats = ride.seatsLeft == 1;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialsAvatar(ride.driver.initials),
                  Gap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride.driver.name, style: text.titleSmall),
                        RatingText(rating: ride.driver.rating, reviews: ride.driver.reviews),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatEuro(ride.pricePerSeatCents),
                        style: text.titleLarge?.copyWith(color: AppColors.primary),
                      ),
                      Text('per seat', style: text.bodySmall),
                    ],
                  ),
                ],
              ),
              Gap.h12,
              Row(
                children: [
                  Text(ride.departTime, style: text.titleMedium),
                  const Expanded(
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Divider()),
                  ),
                  Text(ride.arriveTime, style: text.titleMedium),
                ],
              ),
              Gap.h4,
              Row(
                children: [
                  const Icon(Icons.trip_origin, size: 14, color: AppColors.muted),
                  Gap.w4,
                  Expanded(child: Text('Pickup: ${ride.pickup}', style: text.bodySmall)),
                ],
              ),
              Gap.h12,
              Wrap(
                spacing: AppSizes.s8,
                runSpacing: AppSizes.s4,
                children: [
                  TagPill(
                    fewSeats ? 'Only 1 seat left' : '${ride.seatsLeft} seats left',
                    color: fewSeats ? AppColors.warning : AppColors.navy,
                    background: fewSeats ? AppColors.warningSoft : AppColors.bg,
                    icon: Icons.event_seat_outlined,
                  ),
                  TagPill('Saves ${ride.co2SavedKg} kg CO₂', icon: Icons.eco_outlined),
                  if (ride.car.isElectric) const TagPill('Electric', icon: Icons.bolt),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingText extends StatelessWidget {
  const RatingText({super.key, required this.rating, required this.reviews});

  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
        Gap.w4,
        Text('${rating.toStringAsFixed(1)} ($reviews)', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
