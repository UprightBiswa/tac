import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/app/router/app_routes.dart';
import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/constants/app_sizes.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/core/utils/toast.dart';
import 'package:tac_app/core/widgets/bottom_cta.dart';
import 'package:tac_app/core/widgets/common.dart';
import 'package:tac_app/core/widgets/count_stepper.dart';
import 'package:tac_app/core/widgets/primary_button.dart';
import 'package:tac_app/features/driver/application/offer_controller.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// D2 · Seats and price per seat.
class OfferPriceScreen extends ConsumerStatefulWidget {
  const OfferPriceScreen({super.key});

  @override
  ConsumerState<OfferPriceScreen> createState() => _OfferPriceScreenState();
}

class _OfferPriceScreenState extends ConsumerState<OfferPriceScreen> {
  bool _publishing = false;

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      await ref.read(offerProvider.notifier).publish();
      if (mounted) context.go(AppRoutes.offerPublished);
    } on Exception catch (e) {
      showToast(e.toString());
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = ref.watch(offerProvider);
    final notifier = ref.read(offerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Seats and price')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: [
          SectionCard(
            child: CountStepper(
              label: 'Seats to offer',
              value: offer.seats,
              min: 1,
              max: AppConstants.maxSeats,
              onChanged: (v) => notifier.update((o) => o.copyWith(seats: v)),
            ),
          ),
          Gap.h12,
          SectionCard(
            child: CountStepper(
              label: 'Price per seat',
              caption: 'Suggested ${formatEuro(AppConstants.suggestedPriceCents)} for this route',
              value: offer.pricePerSeatCents,
              min: AppConstants.minPriceCents,
              max: AppConstants.maxPriceCents,
              step: AppConstants.priceStepCents,
              format: formatEuro,
              onChanged: (v) => notifier.update((o) => o.copyWith(pricePerSeatCents: v)),
            ),
          ),
          Gap.h12,
          SectionCard(
            title: 'Car',
            child: RadioGroup<Car>(
              groupValue: offer.car,
              onChanged: (c) => notifier.update((o) => o.copyWith(car: c)),
              child: Column(
                children: [
                  for (final car in driverCars)
                    RadioListTile<Car>(
                      value: car,
                      title: Text(car.model),
                      subtitle: Text('${car.colour} · ${car.plate}'),
                      secondary: Icon(car.isElectric ? Icons.electric_car : Icons.directions_car),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ),
          Gap.h12,
          SectionCard(
            child: InfoRow(
              'You earn if all seats book',
              formatEuro(offer.pricePerSeatCents * offer.seats),
              emphasis: true,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomCta(
        children: [PrimaryButton(label: 'Publish ride', loading: _publishing, onPressed: _publish)],
      ),
    );
  }
}
