import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tac_app/core/utils/formatters.dart';
import 'package:tac_app/features/booking/domain/booking.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/data/rides_repository.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

void main() {
  final tomorrow = dateOnly(DateTime.now()).add(const Duration(days: 1));
  const dublin = Place('Dublin', 'Dublin 2');
  const galway = Place('Galway', 'Eyre Square');

  group('formatters', () {
    test('formatEuro drops zero cents', () {
      expect(formatEuro(1400), '€14');
      expect(formatEuro(2850), '€28.50');
      expect(formatEuro(50), '€0.50');
    });

    test('formatDay labels today and tomorrow', () {
      final now = DateTime(2026, 10, 29, 9);
      expect(formatDay(DateTime(2026, 10, 29), now: now), 'Today');
      expect(formatDay(DateTime(2026, 10, 30), now: now), 'Tomorrow');
      expect(formatDay(DateTime(2026, 11, 1), now: now), 'Sun 1 Nov');
    });
  });

  test('booking total = seats × price + €0.50 service fee', () {
    final ride = mockRidesFor(from: dublin, to: galway, date: tomorrow).first;
    final request = BookingRequest(ride: ride, seats: 2, pickup: ride.pickup, payment: PaymentMethod.card);
    expect(request.totalCents, 2 * 1400 + 50);
  });

  group('MockRidesRepository', () {
    late ProviderContainer container;
    late RidesRepository repo;

    setUp(() {
      container = ProviderContainer();
      repo = container.read(ridesRepositoryProvider);
    });
    tearDown(() => container.dispose());

    test('returns 4 Dublin → Galway rides for 1 seat', () async {
      final rides = await repo.search(SearchQuery(from: dublin, to: galway, date: tomorrow));
      expect(rides, hasLength(4));
      expect(rides.first.driver.name, 'Seán Murphy');
    });

    test('hides rides without enough seats', () async {
      final rides = await repo.search(SearchQuery(from: dublin, to: galway, date: tomorrow, seats: 2));
      expect(rides.any((r) => r.seatsLeft < 2), isFalse);
    });

    test('Belmullet has no rides (empty state)', () async {
      final rides = await repo.search(SearchQuery(from: dublin, to: const Place('Belmullet'), date: tomorrow));
      expect(rides, isEmpty);
    });

    test('details can be looked up after a search', () async {
      final rides = await repo.search(SearchQuery(from: dublin, to: galway, date: tomorrow));
      expect((await repo.getById(rides.first.id)).id, rides.first.id);
    });
  });
}
