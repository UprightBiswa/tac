import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';
import 'package:tac_app/features/rides/domain/ride.dart';
import 'package:tac_app/features/rides/presentation/widgets/ride_card.dart';

enum _Sort { earliest, cheapest, topRated }

/// 09 · Available rides
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  _Sort _sort = _Sort.earliest;

  List<Ride> _sorted(List<Ride> rides) => [...rides]
    ..sort(switch (_sort) {
      _Sort.earliest => (a, b) => a.departTime.compareTo(b.departTime),
      _Sort.cheapest => (a, b) => a.pricePerSeatCents.compareTo(b.pricePerSeatCents),
      _Sort.topRated => (a, b) => b.driver.rating.compareTo(a.driver.rating),
    });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final query = ref.watch(rideSearchProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${query.from.city} → ${query.to?.city ?? ''}', style: text.titleLarge),
            Text('${formatDay(query.date)} · ${pluralSeats(query.seats)}', style: text.bodySmall),
          ],
        ),
        actions: [TextButton(onPressed: () => context.pop(), child: const Text('Edit'))],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              children: [
                for (final (sort, label) in const [
                  (_Sort.earliest, 'Earliest'),
                  (_Sort.cheapest, 'Cheapest'),
                  (_Sort.topRated, 'Top rated'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSizes.s8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _sort == sort,
                      onSelected: (_) => setState(() => _sort = sort),
                    ),
                  ),
                FilterChip(
                  label: const Text('Women only'),
                  selected: false,
                  onSelected: (_) => showToast('Safety filters are planned for a later phase.'),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _Message(
                icon: Icons.cloud_off,
                title: 'Could not load rides',
                body: error.toString(),
                actionLabel: 'Try again',
                onAction: () => ref.invalidate(searchResultsProvider),
              ),
              data: (rides) => rides.isEmpty
                  ? _Message(
                      icon: Icons.search_off,
                      title: 'No rides yet',
                      body:
                          'Nobody is driving to ${query.to?.city} on this day. Create an alert and we will tell you when a ride appears.',
                      actionLabel: 'Create ride alert',
                      onAction: () => showToast('Ride alerts are not in the POC yet.'),
                      secondaryLabel: 'Change search',
                      onSecondary: () => context.pop(),
                    )
                  : _RideList(rides: _sorted(rides)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideList extends StatelessWidget {
  const _RideList({required this.rides});

  final List<Ride> rides;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      itemCount: rides.length,
      separatorBuilder: (_, _) => Gap.h12,
      itemBuilder: (context, i) => RideCard(ride: rides[i], onTap: () => context.push(AppRoutes.ride(rides[i].id))),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s32),
        child: Column(
          children: [
            Icon(icon, size: 56, color: AppColors.muted),
            Gap.h16,
            Text(title, style: text.titleLarge),
            Gap.h8,
            Text(
              body,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            Gap.h24,
            PrimaryButton(label: actionLabel, onPressed: onAction),
            if (secondaryLabel != null) ...[Gap.h8, TextButton(onPressed: onSecondary, child: Text(secondaryLabel!))],
          ],
        ),
      ),
    );
  }
}
