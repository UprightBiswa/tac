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
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/booking/application/booking_providers.dart';

/// 15 · Trip complete + rate driver
class RateTripScreen extends ConsumerStatefulWidget {
  const RateTripScreen({super.key, required this.bookingRef});

  final String bookingRef;

  @override
  ConsumerState<RateTripScreen> createState() => _RateTripScreenState();
}

class _RateTripScreenState extends ConsumerState<RateTripScreen> {
  static const _tags = ['Punctual', 'Friendly', 'Safe driving', 'Clean car'];

  int _rating = 0;
  final _selectedTags = <String>{};

  void _submit(String driverName) {
    ref.read(myBookingsProvider.notifier).complete(widget.bookingRef, rating: _rating);
    showToast('Thanks for rating $driverName!');
    context.go(AppRoutes.home);
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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          const SuccessHeader(title: 'Trip complete'),
          Gap.h24,
          Row(
            spacing: AppSizes.s12,
            children: [
              Expanded(
                child: _Stat(label: 'Fare (demo)', value: formatEuro(booking.totalCents)),
              ),
              Expanded(
                child: _Stat(label: 'CO₂ saved', value: '${booking.co2SavedKg} kg', color: AppColors.success),
              ),
            ],
          ),
          Gap.h24,
          Text('How was your ride with ${driver.firstName}?', style: text.titleLarge, textAlign: TextAlign.center),
          Gap.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: '$i star${i == 1 ? '' : 's'}',
                  iconSize: 40,
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: i <= _rating ? AppColors.warning : AppColors.muted,
                  ),
                ),
            ],
          ),
          Gap.h16,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: [
              for (final tag in _tags)
                FilterChip(
                  label: Text(tag),
                  selected: _selectedTags.contains(tag),
                  onSelected: (on) => setState(() => on ? _selectedTags.add(tag) : _selectedTags.remove(tag)),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Submit', onPressed: _rating == 0 ? null : () => _submit(driver.firstName))],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color = AppColors.navy});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SectionCard(
      child: Column(
        children: [
          Text(value, style: text.headlineSmall?.copyWith(color: color)),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }
}
