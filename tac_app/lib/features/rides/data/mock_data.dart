import 'package:tac_app/features/rides/domain/ride.dart';

// Mock data from docs/FLOW.md §5. All names, plates and card numbers are fictional.

const mockPlaces = [
  Place('Galway', 'Eyre Square'),
  Place('Cork', 'Kent Station'),
  Place('Cork', 'Airport'),
  Place('Limerick', 'Colbert Station'),
  Place('Athlone'),
  Place('Belfast'),
  Place('Dublin', 'Heuston'),
  Place('Dublin', 'Airport'),
  Place('Dublin', 'Dublin 2'),
  Place('Belmullet'), // has no rides: shows the empty state
];

const recentPlaces = [Place('Galway', 'Eyre Square'), Place('Cork', 'Airport'), Place('Limerick', 'Colbert Station')];

/// Searching here returns no rides, to demo the empty state.
const emptyResultCity = 'Belmullet';

const driverCars = [
  Car(model: 'Toyota Corolla', colour: 'Silver', plate: '191-D-12345'),
  Car(model: 'Nissan Leaf', colour: 'White', plate: '221-D-67890', isElectric: true),
];

const _drivers = [
  (
    driver: Driver(
      id: 'd1',
      name: 'Seán Murphy',
      rating: 4.9,
      reviews: 128,
      ridesCompleted: 212,
      idVerified: true,
      phoneVerified: true,
    ),
    car: Car(model: 'Toyota Corolla', colour: 'Silver', plate: '191-D-12345'),
    depart: '08:30',
    arrive: '11:00',
    pickups: ['Heuston Station', 'Red Cow Luas'],
    price: 1400,
    seats: 3,
    co2: 9,
    prefs: ['🚭 No smoking', '🎵 Music OK', '🧳 1 bag'],
  ),
  (
    driver: Driver(
      id: 'd2',
      name: 'Aoife Kelly',
      rating: 4.8,
      reviews: 64,
      ridesCompleted: 90,
      idVerified: true,
      phoneVerified: true,
    ),
    car: Car(model: 'VW Golf', colour: 'Blue', plate: '201-KE-2231'),
    depart: '10:15',
    arrive: '12:40',
    pickups: ['Red Cow Luas', 'Heuston Station'],
    price: 1200,
    seats: 1,
    co2: 8,
    prefs: ['🚭 No smoking', '🤫 Quiet ride', '🧳 1 bag'],
  ),
  (
    driver: Driver(id: 'd3', name: 'Ciarán O’Brien', rating: 4.6, reviews: 31, ridesCompleted: 40, phoneVerified: true),
    car: Car(model: 'Skoda Octavia', colour: 'Grey', plate: '182-D-90876'),
    depart: '13:00',
    arrive: '15:30',
    pickups: ['Dublin 2', 'Grand Canal Dock'],
    price: 1100,
    seats: 2,
    co2: 9,
    prefs: ['🎵 Music OK', '🐾 Pets OK', '🧳 2 bags'],
  ),
  (
    driver: Driver(
      id: 'd4',
      name: 'Niamh Byrne',
      rating: 5.0,
      reviews: 12,
      ridesCompleted: 15,
      idVerified: true,
      phoneVerified: true,
    ),
    car: Car(model: 'Tesla Model 3', colour: 'White', plate: '231-D-55102', isElectric: true),
    depart: '17:45',
    arrive: '20:10',
    pickups: ['UCD Belfield', 'Dundrum Luas'],
    price: 1500,
    seats: 4,
    co2: 14,
    prefs: ['🚭 No smoking', '⚡ Electric car', '🧳 1 bag'],
  ),
];

/// Rides from [from] to [to] on [date]. Same four drivers for every destination.
List<Ride> mockRidesFor({required Place from, required Place to, required DateTime date}) => [
  for (final d in _drivers)
    Ride(
      id: '${d.driver.id}-${to.city.toLowerCase()}-${date.month}${date.day}',
      driver: d.driver,
      car: d.car,
      from: from,
      to: to,
      date: date,
      departTime: d.depart,
      arriveTime: d.arrive,
      pickupOptions: d.pickups,
      dropOff: to.label,
      pricePerSeatCents: d.price,
      seatsLeft: d.seats,
      co2SavedKg: d.co2,
      preferences: d.prefs,
    ),
];
