import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/constants/app_constants.dart';
import 'package:tac_app/core/env/env.dart';
import 'package:tac_app/core/network/app_exception.dart';
import 'package:tac_app/core/network/dio_client.dart';
import 'package:tac_app/features/rides/data/mock_data.dart';
import 'package:tac_app/features/rides/domain/ride.dart';

/// Maps to the NestJS Search + Rides modules.
abstract interface class RidesRepository {
  Future<List<Ride>> search(SearchQuery query);

  Future<Ride> getById(String id);

  /// Publishes a driver's offer and returns the new ride id.
  Future<String> publish(RideOffer offer);
}

/// In-memory data for the POC. Remembers search results so details can be looked up by id.
class MockRidesRepository implements RidesRepository {
  final _cache = <String, Ride>{};

  @override
  Future<List<Ride>> search(SearchQuery query) async {
    await Future<void>.delayed(AppConstants.mockLatency);
    final to = query.to;
    if (to == null || to.city == emptyResultCity) return const [];
    final rides = mockRidesFor(
      from: query.from,
      to: to,
      date: query.date,
    ).where((r) => r.seatsLeft >= query.seats).toList();
    _cache.addAll({for (final r in rides) r.id: r});
    return rides;
  }

  @override
  Future<Ride> getById(String id) async {
    final ride = _cache[id];
    if (ride == null) throw const AppException('This ride is no longer available.');
    return ride;
  }

  @override
  Future<String> publish(RideOffer offer) async {
    await Future<void>.delayed(AppConstants.mockLatency);
    return 'offer-${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// Real implementation, ready for when the backend exists (`USE_MOCK_DATA=false`).
class ApiRidesRepository implements RidesRepository {
  ApiRidesRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Ride>> search(SearchQuery query) => guardDio(() async {
    final res = await _dio.get<List<dynamic>>(
      '/rides/search',
      queryParameters: {
        'from': query.from.label,
        'to': query.to?.label,
        'date': query.date.toIso8601String(),
        'seats': query.seats,
      },
    );
    return (res.data ?? const []).cast<Map<String, dynamic>>().map(Ride.fromJson).toList();
  });

  @override
  Future<Ride> getById(String id) => guardDio(() async {
    final res = await _dio.get<Map<String, dynamic>>('/rides/$id');
    return Ride.fromJson(res.data!);
  });

  @override
  Future<String> publish(RideOffer offer) => guardDio(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/rides',
      data: {
        'from': offer.from.label,
        'to': offer.to?.label,
        'date': offer.date.toIso8601String(),
        'departTime': '${offer.time.hour}:${offer.time.minute}',
        'seats': offer.seats,
        'pricePerSeatCents': offer.pricePerSeatCents,
        'carPlate': offer.car.plate,
      },
    );
    return res.data!['id'] as String;
  });
}

final ridesRepositoryProvider = Provider<RidesRepository>(
  (ref) => Env.useMockData ? MockRidesRepository() : ApiRidesRepository(ref.watch(dioProvider)),
);
