import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/count_stepper.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/domain/ride.dart';
import 'package:tac_app/features/rides/presentation/widgets/date_chips.dart';

/// 08 · Search
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _to = TextEditingController(text: ref.read(rideSearchProvider).to?.label);

  @override
  void dispose() {
    _to.dispose();
    super.dispose();
  }

  void _pick(Place place) {
    ref.read(rideSearchProvider.notifier).setTo(place);
    _to.text = place.label;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final query = ref.watch(rideSearchProvider);
    final notifier = ref.read(rideSearchProvider.notifier);
    final typed = _to.text.trim().toLowerCase();
    final chosen = query.to != null && query.to!.label == _to.text;
    final suggestions = chosen
        ? const <Place>[]
        : mockPlaces.where((p) => p != query.from && p.label.toLowerCase().contains(typed)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find a ride')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          SectionCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'From',
                          prefixIcon: Icon(Icons.my_location, color: AppColors.navy),
                        ),
                        child: Text(query.from.label, style: text.titleSmall),
                      ),
                      Gap.h8,
                      TextField(
                        controller: _to,
                        autofocus: query.to == null,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'To',
                          hintText: 'Town, station or airport',
                          prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Swap from and to',
                  icon: const Icon(Icons.swap_vert, color: AppColors.navy),
                  onPressed: query.to == null
                      ? null
                      : () {
                          notifier.swap();
                          _to.text = ref.read(rideSearchProvider).to!.label;
                          setState(() {});
                        },
                ),
              ],
            ),
          ),
          if (suggestions.isNotEmpty) ...[
            Gap.h8,
            Card(
              child: Column(
                children: [
                  for (final place in suggestions)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined, color: AppColors.muted),
                      title: Text(place.label, style: text.titleSmall),
                      onTap: () => _pick(place),
                    ),
                ],
              ),
            ),
          ],
          Gap.h16,
          SectionCard(
            title: 'When',
            child: DateChips(selected: query.date, onSelected: notifier.setDate),
          ),
          Gap.h16,
          SectionCard(
            child: CountStepper(
              label: 'Seats',
              value: query.seats,
              min: 1,
              max: AppConstants.maxSeats,
              onChanged: notifier.setSeats,
              format: (v) => '$v',
              caption: pluralSeats(query.seats),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [
          PrimaryButton(
            label: 'Search rides',
            icon: Icons.search,
            onPressed: chosen ? () => context.push(AppRoutes.results) : null,
          ),
        ],
      ),
    );
  }
}
