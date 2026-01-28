class Flight {
  final String id;
  final String airline;
  final String airlineLogo;
  final String fromCity;
  final String fromCode;
  final String toCity;
  final String toCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String duration;

  Flight({
    required this.id,
    required this.airline,
    required this.airlineLogo,
    required this.fromCity,
    required this.fromCode,
    required this.toCity,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.duration,
  });
}

// Mock Data
final List<Flight> mockFlights = [
  Flight(
    id: '1',
    airline: 'PIA',
    airlineLogo: 'assets/airline1.png', // Placeholder
    fromCity: 'Karachi',
    fromCode: 'KHI',
    toCity: 'Islamabad',
    toCode: 'ISB',
    departureTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
    arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 12)),
    price: 15000.00,
    duration: '2h 00m',
  ),
  Flight(
    id: '2',
    airline: 'Airblue',
    airlineLogo: 'assets/airline2.png', // Placeholder
    fromCity: 'Lahore',
    fromCode: 'LHE',
    toCity: 'Skardu',
    toCode: 'KDU',
    departureTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
    arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
    price: 25000.50,
    duration: '1h 00m',
  ),
  Flight(
    id: '3',
    airline: 'SereneAir',
    airlineLogo: 'assets/airline3.png',
    fromCity: 'Islamabad',
    fromCode: 'ISB',
    toCity: 'Gilgit',
    toCode: 'GIL',
    departureTime: DateTime.now().add(const Duration(days: 2, hours: 7)),
    arrivalTime: DateTime.now().add(const Duration(days: 2, hours: 8)),
    price: 12000.00,
    duration: '1h 00m',
  ),
  Flight(
    id: '4',
    airline: 'PIA',
    airlineLogo: 'assets/airline1.png',
    fromCity: 'Karachi',
    fromCode: 'KHI',
    toCity: 'Quetta',
    toCode: 'UET',
    departureTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
    arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 15, minutes: 20)),
    price: 18500.00,
    duration: '1h 20m',
  ),
  Flight(
    id: '5',
    airline: 'AirSial',
    airlineLogo: 'assets/airline4.png',
    fromCity: 'Karachi',
    fromCode: 'KHI',
    toCity: 'Islamabad',
    toCode: 'ISB',
    departureTime: DateTime.now().add(const Duration(days: 3, hours: 9)),
    arrivalTime: DateTime.now().add(const Duration(days: 3, hours: 11)),
    price: 22000.00,
    duration: '2h 00m',
  ),
  Flight(
    id: '6',
    airline: 'Airblue',
    airlineLogo: 'assets/airline2.png',
    fromCity: 'Lahore',
    fromCode: 'LHE',
    toCity: 'Karachi',
    toCode: 'KHI',
    departureTime: DateTime.now().add(const Duration(days: 2, hours: 18)),
    arrivalTime: DateTime.now().add(const Duration(days: 2, hours: 19, minutes: 50)),
    price: 26500.00,
    duration: '1h 50m',
  ),
    Flight(
    id: '7',
    airline: 'SereneAir',
    airlineLogo: 'assets/airline3.png',
    fromCity: 'Islamabad',
    fromCode: 'ISB',
    toCity: 'Peshawar',
    toCode: 'PEW',
    departureTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
    arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 11, minutes: 45)),
    price: 8000.00,
    duration: '0h 45m',
  ),
   Flight(
    id: '8',
    airline: 'PIA',
    airlineLogo: 'assets/airline1.png',
    fromCity: 'Multan',
    fromCode: 'MUX',
    toCity: 'Karachi',
    toCode: 'KHI',
    departureTime: DateTime.now().add(const Duration(days: 4, hours: 7)),
    arrivalTime: DateTime.now().add(const Duration(days: 4, hours: 8, minutes: 30)),
    price: 16000.00,
    duration: '1h 30m',
  ),
];
