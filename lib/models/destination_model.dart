class Destination {
  final String id;
  final String city;
  final String country;
  final String imageUrl;
  final double rating;
  final String? price;
  final String? description; // Nullable
  final List<String>?
  facilities; // Nullable to prevent crash if old data exists
  final List<Map<String, String>>? attractions; // Nullable
  final double latitude;
  final double longitude;

  Destination({
    required this.id,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.rating,
    this.price,
    this.description = '', // Default empty string
    this.facilities = const [], // Default empty list
    this.attractions = const [], // Default empty list
    required this.latitude,
    required this.longitude,
  });
}

final List<Destination> destinationsList = [
  Destination(
    id: '4',
    city: 'Islamabad',
    country: 'Pakistan',
    imageUrl: 'assets/images/islamabad.png',
    rating: 4.9,
    price: 'Rs. 12,000',
    description:
        'The beautiful capital city of Pakistan, known for its greenery, Margalla Hills, and peaceful atmosphere.',
    facilities: ['Hiking', 'Parks', 'Wifi', 'Restaurants'],
    attractions: [
      {'name': 'Faisal Mosque', 'image': 'assets/images/faisal_mosque.png'},
      {'name': 'Daman-e-Koh', 'image': 'assets/images/daman_e_koh.png'},
      {'name': 'Monal', 'image': 'assets/images/monal.png'},
    ],
    latitude: 33.6844,
    longitude: 73.0479,
  ),
  Destination(
    id: '6',
    city: 'Karachi',
    country: 'Pakistan',
    imageUrl: 'assets/images/karachi.png',
    rating: 4.8,
    price: 'Rs. 20,000',
    description:
        'The city of lights and the economic hub of Pakistan. Famous for its beaches, nightlife, and diverse food culture.',
    facilities: ['Beach', 'Seaview', 'Wifi', 'Mall'],
    attractions: [
      {'name': 'Clifton Beach', 'image': 'assets/images/clifton_beach.png'},
      {'name': 'Mazar-e-Quaid', 'image': 'assets/images/mazar_e_quaid.png'},
      {'name': 'Dolmen Mall', 'image': 'assets/images/dolmen_mall.png'},
    ],
    latitude: 24.8607,
    longitude: 67.0011,
  ),
  Destination(
    id: '3',
    city: 'Lahore',
    country: 'Pakistan',
    imageUrl: 'assets/images/lahore.png',
    rating: 4.8,
    price: 'Rs. 15,000',
    description:
        'Lahore is the heart of Pakistan. Known for its rich history, vibrant culture, and delicious food street.',
    facilities: ['Museum', 'Food', 'Wifi', 'Hotel'],
    attractions: [
      {'name': 'Badshahi Mosque', 'image': 'assets/images/badshahi_mosque.png'},
      {'name': 'Lahore Fort', 'image': 'assets/images/lahore_fort.png'},
      {
        'name': 'Minar-e-Pakistan',
        'image': 'assets/images/minar_e_pakistan.png',
      },
    ],
    latitude: 31.5204,
    longitude: 74.3587,
  ),
  Destination(
    id: '7',
    city: 'Quetta',
    country: 'Pakistan',
    imageUrl: 'assets/images/quetta.png',
    rating: 4.9,
    price: 'Rs. 18,000',
    description:
        'The Fruit Garden of Pakistan, Quetta is famous for its delicious fruits, dry fruits, and the majestic Quetta Serena Hotel.',
    facilities: ['Fruit Markets', 'Mountains', 'Wifi', 'Hotel'],
    attractions: [
      {'name': 'Hanna Lake', 'image': 'assets/images/hanna_lake.png'},
      {'name': 'Quetta Museum', 'image': 'assets/images/quetta_museum.png'},
      {'name': 'Pishin Valley', 'image': 'assets/images/pishin_valley.png'},
    ],
    latitude: 30.1798,
    longitude: 66.9750,
  ),
  Destination(
    id: '5',
    city: 'Swat',
    country: 'Pakistan',
    imageUrl: 'assets/images/swat.png',
    rating: 4.8,
    price: 'Rs. 25,000',
    description:
        'Known as the Switzerland of the East, Swat offers lush green valleys, rivers, and snow-capped mountains.',
    facilities: ['River View', 'Heater', 'Camping', 'Food'],
    attractions: [
      {'name': 'Malam Jabba', 'image': 'assets/images/malam_jabba.png'},
      {'name': 'Kalam', 'image': 'assets/images/kalam.png'},
      {'name': 'White Palace', 'image': 'assets/images/white_palace.png'},
    ],
    latitude: 35.2220,
    longitude: 72.4258,
  ),
  Destination(
    id: '1',
    city: 'Hunza Valley',
    country: 'Pakistan',
    imageUrl: 'assets/images/hunza.png',
    rating: 4.9,
    price: 'Rs. 45,000',
    description:
        'Experience the breathtaking beauty of Hunza Valley. Known as heaven on earth, it serves rich culture, hospitality, and majestic views of Rakaposhi.',
    facilities: ['Hiking', 'Bonfire', 'Wifi', 'Breakfast'],
    attractions: [
      {'name': 'Baltit Fort', 'image': 'assets/images/baltit_fort.png'},
      {'name': 'Attabad Lake', 'image': 'assets/images/attabad_lake.png'},
      {
        'name': 'Rakaposhi',
        'image':
            'https://images.unsplash.com/photo-1739676882863-f087febf073d?q=80&w=400',
      },
    ],
    latitude: 36.3167,
    longitude: 74.6500,
  ),
  Destination(
    id: '2',
    city: 'Skardu',
    country: 'Pakistan',
    imageUrl: 'assets/images/skardu.png',
    rating: 4.9,
    price: 'Rs. 55,000',
    description:
        'Skardu is the gateway to K2 and home to some of the world’s most beautiful cold deserts and lakes. A paradise for trekkers.',
    facilities: ['Jeep Ride', 'Camping', 'Dinner', 'Guide'],
    attractions: [
      {
        'name': 'Shangrila Resort',
        'image':
            'https://images.unsplash.com/photo-1621251910609-b14a29a59560?q=80&w=400',
      },
      {
        'name': 'Deosai Plains',
        'image':
            'https://images.unsplash.com/photo-1627896157734-4d7d4388f24b?q=80&w=400',
      },
      {
        'name': 'Upper Kachura Lake',
        'image':
            'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=400',
      },
    ],
    latitude: 35.2971,
    longitude: 75.6333,
  ),
];
