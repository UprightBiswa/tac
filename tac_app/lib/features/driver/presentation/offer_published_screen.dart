import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/demo_badge.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/driver/application/offer_controller.dart';

/// D3 · Ride published
class OfferPublishedScreen extends ConsumerWidget {
  const OfferPublishedScreen({super.key});

  void _home(BuildContext context, WidgetRef ref) {
    ref.invalidate(offerProvider);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(offerProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
          children: [
            const SuccessHeader(title: 'Ride published', subtitle: "We'll notify you when passengers book."),
            Gap.h24,
            SectionCard(
              child: Column(
                children: [
                  InfoRow('Route', '${offer.from.city} → ${offer.to?.city ?? ''}'),
                  InfoRow('When', '${formatDay(offer.date)}, ${offer.time.format(context)}'),
                  InfoRow('Seats', '${offer.seats}'),
                  InfoRow('Car', offer.car.model),
                  const Divider(height: AppSizes.s16),
                  InfoRow('Price per seat', formatEuro(offer.pricePerSeatCents), emphasis: true),
                ],
              ),
            ),
            Gap.h16,
            const DemoNote('Demo: the ride is not saved anywhere and nobody will book it.'),
          ],
        ),
        bottomNavigationBar: BottomCta(
          children: [PrimaryButton(label: 'Back to home', onPressed: () => _home(context, ref))],
        ),
      ),
    );
  }
}
