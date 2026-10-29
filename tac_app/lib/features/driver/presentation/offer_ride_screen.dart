import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/driver/application/offer_controller.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/domain/ride.dart';
import 'package:tac_app/features/rides/presentation/widgets/date_chips.dart';

/// D1 · Offer a ride: route, date and departure time.
class OfferRideScreen extends ConsumerWidget {
  const OfferRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(offerProvider);
    final notifier = ref.read(offerProvider.notifier);
    final places = {offer.from, ...mockPlaces}.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Offer a ride')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          SectionCard(
            title: 'Route',
            child: Column(
              children: [
                _PlaceField(
                  label: 'From',
                  icon: Icons.trip_origin,
                  value: offer.from,
                  places: places,
                  onChanged: (p) => notifier.update((o) => o.copyWith(from: p)),
                ),
                Gap.h12,
                _PlaceField(
                  label: 'To',
                  icon: Icons.location_on,
                  value: offer.to,
                  places: places,
                  onChanged: (p) => notifier.update((o) => o.copyWith(to: p)),
                ),
                if (offer.to != null && !offer.hasValidRoute) ...[
                  Gap.h8,
                  const Text('From and To must be different.', style: TextStyle(color: AppColors.error)),
                ],
              ],
            ),
          ),
          Gap.h12,
          SectionCard(
            title: 'Date',
            child: DateChips(
              selected: offer.date,
              onSelected: (d) => notifier.update((o) => o.copyWith(date: d)),
            ),
          ),
          Gap.h12,
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule, color: AppColors.navy),
              title: const Text('Departure time'),
              trailing: Text(offer.time.format(context), style: Theme.of(context).textTheme.titleMedium),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: offer.time);
                if (picked != null) notifier.update((o) => o.copyWith(time: picked));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [
          PrimaryButton(
            label: 'Next',
            onPressed: offer.hasValidRoute ? () => context.push(AppRoutes.offerPrice) : null,
          ),
        ],
      ),
    );
  }
}

class _PlaceField extends StatelessWidget {
  const _PlaceField({
    required this.label,
    required this.icon,
    required this.value,
    required this.places,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final Place? value;
  final List<Place> places;
  final ValueChanged<Place> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Place>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      items: [
        for (final p in places)
          DropdownMenuItem(
            value: p,
            child: Text(p.label, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (p) => p == null ? null : onChanged(p),
    );
  }
}
