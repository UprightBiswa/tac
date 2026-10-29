import 'package:flutter/material.dart' show TimeOfDay;

class Place {
  const Place(this.city, [this.area]);

  factory Place.fromJson(Map<String, dynamic> json) => Place(json['city'] as String, json['area'] as String?);

  final String city;
  final String? area;

  String get label => area == null ? city : '$city – $area';

  @override
  bool operator ==(Object other) => other is Place && other.city == city && other.area == area;

  @override
  int get hashCode => Object.hash(city, area);
}

class Car {
  const Car({required this.model, required this.colour, required this.plate, this.isElectric = false});

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    model: json['model'] as String,
    colour: json['colour'] as String,
    plate: json['plate'] as String,
    isElectric: json['isElectric'] as bool? ?? false,
  );

  final String model;
  final String colour;
  final String plate;
  final bool isElectric;

  String get label => '$model · $colour · $plate';
}

class Driver {
  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.ridesCompleted,
    this.idVerified = false,
    this.phoneVerified = false,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviews: json['reviews'] as int,
    ridesCompleted: json['ridesCompleted'] as int,
    idVerified: json['idVerified'] as bool? ?? false,
    phoneVerified: json['phoneVerified'] as bool? ?? false,
  );

  final String id;
  final String name;
  final double rating;
  final int reviews;
  final int ridesCompleted;
  final bool idVerified;
  final bool phoneVerified;

  String get firstName => name.split(' ').first;

  String get initials => name.split(' ').where((p) => p.isNotEmpty).take(2).map((p) => p[0]).join();
}

class Ride {
  const Ride({
    required this.id,
    required this.driver,
    required this.car,
    required this.from,
    required this.to,
    required this.date,
    required this.departTime,
    required this.arriveTime,
    required this.pickupOptions,
    required this.dropOff,
    required this.pricePerSeatCents,
    required this.seatsLeft,
    required this.co2SavedKg,
    this.preferences = const [],
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
    id: json['id'] as String,
    driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
    car: Car.fromJson(json['car'] as Map<String, dynamic>),
    from: Place.fromJson(json['from'] as Map<String, dynamic>),
    to: Place.fromJson(json['to'] as Map<String, dynamic>),
    date: DateTime.parse(json['date'] as String),
    departTime: json['departTime'] as String,
    arriveTime: json['arriveTime'] as String,
    pickupOptions: (json['pickupOptions'] as List<dynamic>).cast<String>(),
    dropOff: json['dropOff'] as String,
    pricePerSeatCents: json['pricePerSeatCents'] as int,
    seatsLeft: json['seatsLeft'] as int,
    co2SavedKg: json['co2SavedKg'] as int,
    preferences: (json['preferences'] as List<dynamic>? ?? const []).cast<String>(),
  );

  final String id;
  final Driver driver;
  final Car car;
  final Place from;
  final Place to;
  final DateTime date;
  final String departTime;
  final String arriveTime;

  /// First entry is the default pickup point.
  final List<String> pickupOptions;
  final String dropOff;
  final int pricePerSeatCents;
  final int seatsLeft;
  final int co2SavedKg;
  final List<String> preferences;

  String get pickup => pickupOptions.first;
}

/// What the rider is searching for (screen 08).
class SearchQuery {
  const SearchQuery({required this.from, required this.date, this.to, this.seats = 1});

  final Place from;
  final Place? to;
  final DateTime date;
  final int seats;

  SearchQuery copyWith({Place? from, Place? to, DateTime? date, int? seats}) =>
      SearchQuery(from: from ?? this.from, to: to ?? this.to, date: date ?? this.date, seats: seats ?? this.seats);
}

/// A ride a driver is offering (screens D1–D2).
class RideOffer {
  const RideOffer({
    required this.from,
    required this.date,
    required this.time,
    required this.car,
    this.to,
    this.seats = 3,
    this.pricePerSeatCents = 1200,
  });

  final Place from;
  final Place? to;
  final DateTime date;
  final TimeOfDay time;
  final Car car;
  final int seats;
  final int pricePerSeatCents;

  bool get hasValidRoute => to != null && to != from;

  RideOffer copyWith({
    Place? from,
    Place? to,
    DateTime? date,
    TimeOfDay? time,
    Car? car,
    int? seats,
    int? pricePerSeatCents,
  }) => RideOffer(
    from: from ?? this.from,
    to: to ?? this.to,
    date: date ?? this.date,
    time: time ?? this.time,
    car: car ?? this.car,
    seats: seats ?? this.seats,
    pricePerSeatCents: pricePerSeatCents ?? this.pricePerSeatCents,
  );
}
