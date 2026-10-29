import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/features/onboarding/application/session_controller.dart';
import 'package:tac_app/features/rides/data/rides_repository.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// Search form state (screen 08). Carries forward into results and booking.
class RideSearchController extends Notifier<SearchQuery> {
  @override
  SearchQuery build() {
    final area = ref.watch(sessionProvider.select((s) => s.area));
    return SearchQuery(
      from: Place('Dublin', area.isEmpty ? 'Dublin 2' : area),
      date: dateOnly(DateTime.now()).add(const Duration(days: 1)),
    );
  }

  void setTo(Place place) => state = state.copyWith(to: place);

  void setDate(DateTime date) => state = state.copyWith(date: dateOnly(date));

  void setSeats(int seats) => state = state.copyWith(seats: seats);

  void swap() {
    final to = state.to;
    if (to == null) return;
    state = SearchQuery(from: to, to: state.from, date: state.date, seats: state.seats);
  }
}

final rideSearchProvider = NotifierProvider<RideSearchController, SearchQuery>(RideSearchController.new);

/// Results for the current search (screen 09). Re-fetches when the query changes.
final searchResultsProvider = FutureProvider.autoDispose<List<Ride>>(
  (ref) => ref.watch(ridesRepositoryProvider).search(ref.watch(rideSearchProvider)),
);

final rideByIdProvider = FutureProvider.autoDispose.family<Ride, String>(
  (ref, id) => ref.watch(ridesRepositoryProvider).getById(id),
);
