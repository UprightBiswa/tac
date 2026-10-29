import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/app/theme/app_colors.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';
import 'package:tac_app/features/booking/domain/booking.dart';

/// 13 · My rides
class MyRidesScreen extends ConsumerWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(myBookingsProvider);
    final upcoming = mine.where((b) => b.status == BookingStatus.upcoming).toList();
    final completed = mine.where((b) => b.status == BookingStatus.completed).toList();
    final past = ref.watch(pastTripsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My rides'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            upcoming.isEmpty
                ? const _Empty()
                : _BookingList(bookings: upcoming, onTap: (b) => context.push(AppRoutes.booking(b.ref))),
            past.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (older) => _BookingList(bookings: [...completed, ...older]),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({required this.bookings, this.onTap});

  final List<Booking> bookings;
  final ValueChanged<Booking>? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => Gap.h12,
      itemBuilder: (context, i) {
        final b = bookings[i];
        final upcoming = b.status == BookingStatus.upcoming;
        return Card(
          child: InkWell(
            onTap: onTap == null ? null : () => onTap!(b),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Row(
                children: [
                  InitialsAvatar(b.ride.driver.initials),
                  Gap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${b.ride.from.city} → ${b.ride.to.city}', style: text.titleSmall),
                        Text(
                          '${formatDay(b.ride.date)}, ${b.ride.departTime} · ${b.ride.driver.firstName}',
                          style: text.bodySmall,
                        ),
                        Gap.h8,
                        upcoming
                            ? const TagPill('Confirmed', icon: Icons.check_circle_outline)
                            : TagPill(
                                b.rating == null ? 'Completed' : 'Completed · ${b.rating}★',
                                color: AppColors.muted,
                                background: AppColors.bg,
                              ),
                      ],
                    ),
                  ),
                  Text(formatEuro(b.totalCents), style: text.titleMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_car_outlined, size: 56, color: AppColors.muted),
            Gap.h16,
            Text('No upcoming rides', style: text.titleLarge),
            Gap.h24,
            PrimaryButton(label: 'Find a ride', onPressed: () => context.push(AppRoutes.search)),
          ],
        ),
      ),
    );
  }
}
