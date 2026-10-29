import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/data/rides_repository.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// Driver "Offer a ride" draft (screens D1 → D3).
class OfferController extends Notifier<RideOffer> {
  @override
  RideOffer build() {
    final area = ref.watch(sessionProvider.select((s) => s.area));
    return RideOffer(
      from: Place('Dublin', area.isEmpty ? 'Dublin 2' : area),
      date: dateOnly(DateTime.now()).add(const Duration(days: 1)),
      time: const TimeOfDay(hour: 8, minute: 30),
      car: driverCars.first,
      pricePerSeatCents: AppConstants.suggestedPriceCents,
    );
  }

  void update(RideOffer Function(RideOffer current) change) => state = change(state);

  Future<void> publish() => ref.read(ridesRepositoryProvider).publish(state);
}

final offerProvider = NotifierProvider<OfferController, RideOffer>(OfferController.new);
