import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/map_preview.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';
import 'package:tac_app/features/rides/application/rides_providers.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';

/// 07 · Home
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final session = ref.watch(sessionProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          children: [
            Row(
              children: [
                Expanded(child: Text('Hi ${session.greetingName} 👋', style: text.headlineSmall)),
                const DemoBadge(),
              ],
            ),
            Gap.h4,
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                Gap.w4,
                Flexible(
                  child: Text(session.area, style: text.bodyMedium?.copyWith(color: AppColors.muted)),
                ),
              ],
            ),
            Gap.h16,
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: false, label: Text('Find a ride'), icon: Icon(Icons.search)),
                  ButtonSegment(value: true, label: Text('Offer a ride'), icon: Icon(Icons.directions_car)),
                ],
                selected: const {false},
                onSelectionChanged: (selection) {
                  if (selection.first) context.push(AppRoutes.offer);
                },
              ),
            ),
            Gap.h16,
            MapPreview(height: 170, label: session.area),
            Gap.h16,
            Card(
              child: InkWell(
                onTap: () => context.push(AppRoutes.search),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.s16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                        ),
                        child: const Icon(Icons.search, color: AppColors.primary),
                      ),
                      Gap.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Where to?', style: text.titleLarge),
                            Text('Search rides across Ireland', style: text.bodySmall),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.muted),
                    ],
                  ),
                ),
              ),
            ),
            Gap.h24,
            Text('Recent places', style: text.titleMedium),
            Gap.h8,
            Card(
              child: Column(
                children: [
                  for (final (i, place) in recentPlaces.indexed) ...[
                    if (i > 0) const Divider(indent: 56),
                    ListTile(
                      leading: const Icon(Icons.history, color: AppColors.muted),
                      title: Text(place.label, style: text.titleSmall),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                      onTap: () {
                        ref.read(rideSearchProvider.notifier).setTo(place);
                        context.push(AppRoutes.search);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
