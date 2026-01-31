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
      {
        'name': 'Faisal Mosque',
        'image':
            'https://images.unsplash.com/photo-1627814760205-59b48c08af7e?q=80&w=400',
      },
      {
        'name': 'Daman-e-Koh',
        'image':
            'https://images.unsplash.com/photo-1549646401-499317d54e4f?q=80&w=400',
      },
      {
        'name': 'Monal',
        'image':
            'https://images.unsplash.com/photo-1590685955113-75b253b89088?q=80&w=400',
      },
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
      {
        'name': 'Clifton Beach',
        'image':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=400',
      },
      {
        'name': 'Mazar-e-Quaid',
        'image':
            'https://images.unsplash.com/photo-1623862211475-14df6385a86d?q=80&w=400',
      },
      {
        'name': 'Dolmen Mall',
        'image':
            'https://images.unsplash.com/photo-1590685955113-75b253b89088?q=80&w=400',
      },
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
      {
        'name': 'Badshahi Mosque',
        'image':
            'https://images.unsplash.com/photo-1594950664878-382944bb978e?q=80&w=400',
      },
      {
        'name': 'Lahore Fort',
        'image':
            'https://images.unsplash.com/photo-1518005068251-37900150dfca?q=80&w=400',
      },
      {
        'name': 'Minar-e-Pakistan',
        'image':
            'https://images.unsplash.com/photo-1627814760205-59b48c08af7e?q=80&w=400',
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
      {
        'name': 'Hanna Lake',
        'image':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400',
      },
      {
        'name': 'Quetta Museum',
        'image':
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=400',
      },
      {
        'name': 'Pishin Valley',
        'image':
            'https://images.unsplash.com/photo-1582719478250-c89cae4df85b?q=80&w=400',
      },
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
      {
        'name': 'Malam Jabba',
        'image':
            'https://images.unsplash.com/photo-1518005068251-37900150dfca?q=80&w=400',
      },
      {
        'name': 'Kalam',
        'image':
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=400',
      },
      {
        'name': 'White Palace',
        'image':
            'https://images.unsplash.com/photo-1627814760205-59b48c08af7e?q=80&w=400',
      },
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
      {
        'name': 'Baltit Fort',
        'image':
            'https://images.unsplash.com/photo-1627814760205-59b48c08af7e?q=80&w=400',
      },
      {
        'name': 'Attabad Lake',
        'image':
            'https://images.unsplash.com/photo-1518005068251-37900150dfca?q=80&w=400',
      },
      {
        'name': 'Rakaposhi',
        'image':
            'https://images.unsplash.com/photo-1594950664878-382944bb978e?q=80&w=400',
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
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=400',
      },
      {
        'name': 'Deosai Plains',
        'image':
            'https://images.unsplash.com/photo-1549646401-499317d54e4f?q=80&w=400',
      },
      {
        'name': 'Upper Kachura',
        'image':
            'https://images.unsplash.com/photo-1590685955113-75b253b89088?q=80&w=400',
      },
    ],
    latitude: 35.2971,
    longitude: 75.6333,
  ),
  Destination(
    id: '8',
    city: 'Ziarat',
    country: 'Pakistan',
    imageUrl: 'assets/images/ziarat.jpg',
    rating: 4.8,
    price: 'Rs. 15,000',
    description:
        'Home to the second largest Juniper forest in the world and the historic Quaid-e-Azam Residency.',
    facilities: ['Forest', 'Hiking', 'Residency', 'Guide'],
    attractions: [
      {
        'name': 'Juniper Forest',
        'image':
            'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?q=80&w=400',
      },
      {
        'name': 'Quaid Residency',
        'image':
            'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?q=80&w=400',
      },
    ],
    latitude: 30.3811,
    longitude: 67.7258,
  ),
];
