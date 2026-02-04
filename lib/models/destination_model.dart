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
        'image': 'assets/images/faisal_mosque.png',
        'description':
            'Faisal Mosque is the largest mosque in Pakistan, located in the foothills of Margalla Hills in Islamabad. Its unique contemporary design by Turkish architect Vedat Dalokay is inspired by a Bedouin tent.',
      },
      {
        'name': 'Lok Virsa',
        'image': 'assets/images/lok_virsa.png',
        'description':
            'The Lok Virsa Museum, also known as the National Institute of Folk and Traditional Heritage, is a museum of history and culture in Islamabad, showcasing the diverse heritage of Pakistan.',
      },
      {
        'name': 'Pakistan Monument',
        'image': 'assets/images/shakarparian.png',
        'description':
            'The Pakistan Monument is a national monument and heritage museum located on the western Shakarparian Hills in Islamabad. Built to symbolize the unity of the Pakistani people, its design represents the four provinces and three territories of the country.',
      },
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
      {
        'name': 'Clifton Beach',
        'image': 'assets/images/clifton_beach.png',
        'description':
            'Clifton Beach, also known as Seaview, is a popular beach in Karachi along the Arabian Sea. It is one of the most visited tourist spots in the city, offering camel rides and beautiful sunset views.',
      },
      {
        'name': 'Mazar-e-Quaid',
        'image': 'assets/images/mazar_e_quaid.png',
        'description':
            'Mazar-e-Quaid is the final resting place of Quaid-e-Azam Muhammad Ali Jinnah, the founder of Pakistan. The iconic white marble mausoleum is a symbol of Karachi and the nation.',
      },
      {
        'name': 'PAF Museum',
        'image': 'assets/images/paf_museum.png',
        'description':
            'The Pakistan Air Force Museum is an aviation museum and park situated between PAF Base Faisal and Awami Markaz. It houses various aircraft, including fighter jets and transport planes, as well as several galleries.',
      },
      {
        'name': 'Maritime Museum',
        'image': 'assets/images/maritime_museum.png',
        'description':
            'Pakistan Maritime Museum is a naval museum and park in Karachi. It features a submarine, several ships, and aircraft used by the Pakistan Navy, along with informative indoor galleries.',
      },
      {
        'name': 'Safari Park',
        'image': 'assets/images/safari_park.png',
        'description':
            'Karachi Safari Park is a public wildlife park located in Gulshan-e-Iqbal. It offers a safari experience, an elephant enclosure, and various other animal exhibits in a natural setting.',
      },
      {
        'name': 'Bahria Town',
        'image': 'assets/images/bahria_town.png',
        'description':
            'Bahria Town Karachi is a privately owned gated suburb. It is known for its modern infrastructure, the Grand Jamia Mosque, and replicas of world-famous monuments like the Eiffel Tower.',
      },
      {
        'name': 'Dolmen Mall',
        'image': 'assets/images/dolmen_mall.png',
        'description':
            'Dolmen Mall Clifton is one of the most modern and upscale shopping malls in Karachi, featuring international brands, a large food court, and views of the Arabian Sea.',
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
        'image': 'assets/images/badshahi_mosque.png',
        'description':
            'Built by Emperor Aurangzeb in 1673, the Badshahi Mosque is an iconic Mughal-era congregational mosque in Lahore. It is the second-largest mosque in Pakistan and remains one of the city’s most significant landmarks.',
      },
      {
        'name': 'Lahore Fort',
        'image': 'assets/images/lahore_fort.png',
        'description':
            'A Citadel in the city of Lahore, the Lahore Fort (Shahi Qila) is a UNESCO World Heritage site. It contains various palaces, halls, and gardens constructed by successive Mughal emperors.',
      },
      {
        'name': 'Minar-e-Pakistan',
        'image': 'assets/images/minar_e_pakistan.png',
        'description':
            'Minar-e-Pakistan is a national monument located in Tower Park where the Lahore Resolution was passed in 1940. It is a symbol of the struggle for the creation of Pakistan.',
      },
      {
        'name': 'Shalimar Gardens',
        'image': 'assets/images/shalimar_gardens.png',
        'description':
            'The Shalimar Gardens are a Mughal garden complex completed in 1642. A UNESCO World Heritage site, the gardens are famous for their intricate waterworks, fountains, and lush greenery.',
      },
      {
        'name': 'Wagah Border',
        'image': 'assets/images/wagah_border.png',
        'description':
            'The Wagah-Attari border ceremony is a daily military practice that the security forces of Pakistan (Pakistan Rangers) and India (Border Security Force) have jointly followed since 1959. It is a symbol of patriotic pride.',
      },
      {
        'name': 'Gawalmandi Food Street',
        'image': 'assets/images/gawalmandi.png',
        'description':
            'Gawalmandi Food Street is the oldest food street in Lahore. It is a hub of traditional Lahori cuisine, offering a wide range of authentic dishes in a vibrant, historic atmosphere.',
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
        'name': 'Hanna Urak',
        'image': 'assets/images/hanna_lake.png',
        'description':
            'Hanna Lake is one of the most beautiful lakes in Quetta, surrounded by mountains. The nearby Urak Valley is famous for its orchards of peaches, apples, and pomegranates.',
      },
      {
        'name': 'Quetta Museum',
        'image': 'assets/images/quetta_museum.png',
        'description':
            'The Quetta Museum is a historical museum that features a collection of artifacts, ancient manuscripts, and weapons from the region, offering a glimpse into Balochistan’s rich history.',
      },
      {
        'name': 'Pishin Valley',
        'image': 'assets/images/pishin_valley.png',
        'description':
            'Pishin Valley is a fertile valley located near Quetta, known for its thousands of acres of fruit orchards and the scenic Bund Khushdil Khan lake.',
      },
      {
        'name': 'Askari Park',
        'image': 'assets/images/askari_park.png',
        'description':
            'Askari Park is a popular recreational park in Quetta, offering lush green lawns, amusement rides, and a peaceful environment for families to enjoy.',
      },
      {
        'name': 'Liaquat Park',
        'point': 'Liaquat Park',
        'image': 'assets/images/liaquat_park.png',
        'description':
            'Liaquat Park is one of the oldest parks in Quetta. It provides a serene escape in the heart of the city with beautiful gardens and a historic atmosphere.',
      },
      {
        'name': 'Prince Road Food Street',
        'image':
            'https://images.unsplash.com/photo-1544148103-0773bf10d330?q=80&w=400',
        'description':
            'Prince Road is the culinary hub of Quetta, famous for traditional Balochi Sajji, Rosh, and a variety of other local delicacies that attract food lovers from across the city.',
      },
    ],
    latitude: 30.1798,
    longitude: 66.9750,
  ),
  Destination(
    id: '10',
    city: 'Peshawar',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1626078299034-969408017042?q=80&w=800', // Verified working high-res image
    rating: 4.8,
    price: 'Rs. 14,000',
    description:
        'Peshawar is one of the oldest living cities in South Asia, known for its rich history, the legendary Khyber Pass, and the famous Qissa Khwani Bazaar. It is the cultural hub of Khyber Pakhtunkhwa.',
    facilities: ['Culture', 'Tea Houses', 'Wifi', 'History'],
    attractions: [
      {
        'name': 'Khyber Pass',
        'image':
            'https://images.unsplash.com/photo-1627663243954-d891632007d3?q=80&w=400',
        'description':
            'The Khyber Pass is a mountain pass in the northwest of Pakistan, on the border with Afghanistan. It has been a vital trade route and a strategic military location for centuries.',
      },
      {
        'name': 'Islamia College',
        'image':
            'https://images.unsplash.com/photo-1627663243283-da4c49d01f9b?q=80&w=400',
        'description':
            'Islamia College Peshawar is a renowned educational institution known for its magnificent red-brick Mughal-style architecture and its role in the educational history of the region.',
      },
      {
        'name': 'Qissa Khwani Bazaar',
        'image':
            'https://images.unsplash.com/photo-1627663242637-cd58e652432d?q=80&w=400',
        'description':
            'The "Bazaar of Storytellers" is a historic market in Peshawar where travelers and traders used to gather to share stories over cups of Kahwa (green tea).',
      },
      {
        'name': 'Mahabat Khan Mosque',
        'image':
            'https://images.unsplash.com/photo-1627663242137-0cf791873733?q=80&w=400',
        'description':
            'This 17th-century Mughal-era mosque is famous for its intricate architecture, geometric patterns, and beautiful white marble facade.',
      },
      {
        'name': 'Peshawar Museum',
        'image':
            'https://images.unsplash.com/photo-1518998053502-5190a3915a25?q=80&w=400',
        'description':
            'Known for its extensive collection of Gandharan Buddhist art, the Peshawar Museum is housed in a beautiful Victorian-style building.',
      },
    ],
    latitude: 34.0151,
    longitude: 71.5249,
  ),
  Destination(
    id: '15',
    city: 'Gilgit',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1548263514-a2387102e35a?q=80&w=800', // Gilgit Mountains
    rating: 4.9,
    price: 'Rs. 28,000',
    description:
        'Gilgit is the capital city of Gilgit-Baltistan. It is a major hub for mountaineering and trekking in the Karakoram Range, known for its stunning valleys, rivers, and ancient history.',
    facilities: ['Mountaineering', 'Hiking', 'Wifi', 'Breakfast'],
    attractions: [
      {
        'name': 'Naltar Valley',
        'image':
            'https://images.unsplash.com/photo-1621251910609-b14a29a59560?q=80&w=400',
        'description':
            'Naltar Valley is famous for its colorful lakes and lush green forests. It is one of the most beautiful spots near Gilgit, accessible by 4x4 vehicles.',
      },
      {
        'name': 'Rakaposhi View Point',
        'image':
            'https://images.unsplash.com/photo-1739676882863-f087febf073d?q=80&w=400',
        'description':
            'The Rakaposhi View Point offers a majestic view of the snow-capped Rakaposhi peak, which is part of the Karakoram mountain range.',
      },
      {
        'name': 'Kargah Buddha',
        'image':
            'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=400',
        'description':
            'Kargah Buddha is an archaeological site featuring a large standing Buddha figure carved into a cliffside, dating back to the 7th century.',
      },
      {
        'name': 'Danyore Suspension Bridge',
        'image':
            'https://images.unsplash.com/photo-1518998053502-5190a3915a25?q=80&w=400',
        'description':
            'The Danyore Suspension Bridge is a thrilling and historic bridge connecting Gilgit to the Danyore valley, offering views of the Gilgit River.',
      },
    ],
    latitude: 35.9208,
    longitude: 74.3089,
  ),
  Destination(
    id: '11',
    city: 'Hyderabad',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=800', // Pacco Qillo/City view
    rating: 4.7,
    price: 'Rs. 10,000',
    description:
        'Hyderabad is the second-largest city in Sindh and a major industrial hub. It is famous for its history, traditional handicrafts, Rabri, and historic forts.',
    facilities: ['Culture', 'Markets', 'Wifi', 'Hotels'],
    attractions: [
      {
        'name': 'Pacco Qillo',
        'image':
            'https://images.unsplash.com/photo-1562016335-9610f4435882?q=80&w=400',
        'description':
            'Pacco Qillo (Strong Fort) is a historic fort built by Mian Ghulam Shah Kalhoro in 1768. It is one of the most prominent landmarks of Hyderabad.',
      },
      {
        'name': 'Sindh Museum',
        'image':
            'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=400',
        'description':
            'The Sindh Museum features a wide collection of artifacts and exhibits showcasing the history and culture of the Sindh region, from ancient times to the present.',
      },
      {
        'name': 'Rani Bagh',
        'image':
            'https://images.unsplash.com/photo-1516422317950-ad73562a2828?q=80&w=400',
        'description':
            'Rani Bagh is a historic zoo and park in Hyderabad named after Queen Victoria. It is a popular spot for families, offering a large green space and a zoo.',
      },
      {
        'name': 'Resham Gali',
        'image':
            'https://images.unsplash.com/photo-1590001158193-790130abe86a?q=80&w=400',
        'description':
            'Resham Gali is a famous narrow street market in Hyderabad, known for its traditional clothing, embroidery, and vibrant atmosphere.',
      },
    ],
    latitude: 25.3960,
    longitude: 68.3578,
  ),
  Destination(
    id: '12',
    city: 'Multan',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1621251910609-b14a29a59560?q=80&w=800', // Iconic shrine view
    rating: 4.8,
    price: 'Rs. 13,000',
    description:
        'Multan, known as the City of Saints, is one of the oldest cities in the world. It is famous for its historical shrines, traditional blue pottery, and delicious mangoes.',
    facilities: ['Culture', 'Shrines', 'Wifi', 'Hotels'],
    attractions: [
      {
        'name': 'Shah Rukn-e-Alam',
        'image':
            'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=400',
        'description':
            'The Tomb of Shah Rukn-e-Alam is a masterpiece of Tughluq architecture and one of the most impressive shrines in the Indian subcontinent. It is a symbol of Multan’s spiritual heritage.',
      },
      {
        'name': 'Bahauddin Zakariya',
        'image':
            'https://images.unsplash.com/photo-1590001158193-790130abe86a?q=80&w=400',
        'description':
            'The shrine of the 13th-century Sufi saint Bahauddin Zakariya is a prominent historical and religious site, featuring traditional Multani tile work and a grand brick structure.',
      },
      {
        'name': 'Qila Kohna Multan',
        'image':
            'https://images.unsplash.com/photo-1562016335-9610f4435882?q=80&w=400',
        'description':
            'Also known as Multan Fort, this ancient citadel sits on a high mound and houses several major shrines and historic landmarks of the city.',
      },
      {
        'name': 'Shah Shams Tabrez',
        'image':
            'https://images.unsplash.com/photo-1518998053502-5190a3915a25?q=80&w=400',
        'description':
            'The shrine of Shah Shams Tabrez is another significant spiritual site in Multan, known for its beautiful architecture and the legend of the saint who brought the sun closer.',
      },
      {
        'name': 'Ghanta Ghar Multan',
        'image':
            'https://images.unsplash.com/photo-1516422317950-ad73562a2828?q=80&w=400',
        'description':
            'The Clock Tower (Ghanta Ghar) of Multan is a landmark building from the British era, located in the center of the city and now serving as a museum.',
      },
    ],
    latitude: 30.1575,
    longitude: 71.5249,
  ),
  Destination(
    id: '13',
    city: 'Faisalabad',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1590001158193-790130abe86a?q=80&w=800', // City view
    rating: 4.6,
    price: 'Rs. 9,000',
    description:
        'Faisalabad, formerly known as Lyallpur, is the third-largest city in Pakistan and a major industrial hub, especially famous for its textiles. It is known for its unique city planning and the iconic Clock Tower.',
    facilities: ['Textiles', 'Shopping', 'Wifi', 'Hotels'],
    attractions: [
      {
        'name': 'Clock Tower',
        'image':
            'https://images.unsplash.com/photo-1516422317950-ad73562a2828?q=80&w=400',
        'description':
            'The Faisalabad Clock Tower (Ghanta Ghar) is the oldest monument in the city. It was built during the British era and is unique because it is at the center of eight markets that form the Union Jack flag when viewed from above.',
      },
      {
        'name': 'Lyallpur Museum',
        'image':
            'https://images.unsplash.com/photo-1518998053502-5190a3915a25?q=80&w=400',
        'description':
            'The Lyallpur Museum preserves the regional history and culture of Faisalabad. It features several galleries showcasing ancient artifacts, local heritage, and the story of the city’s development.',
      },
      {
        'name': 'Gatwala Wildlife Park',
        'image':
            'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?q=80&w=400',
        'description':
            'Gatwala Wildlife Park is a large botanical garden and wildlife preserve. It is a popular picnic spot, featuring a lake, forest area, and various bird and animal species.',
      },
      {
        'name': 'Jinnah Garden',
        'image':
            'https://images.unsplash.com/photo-1562016335-9610f4435882?q=80&w=400',
        'description':
            'Jinnah Garden, also known as Dhobi Ghat Park, is one of the oldest and largest parks in Faisalabad. It is a central green space used for public gatherings and recreation.',
      },
      {
        'name': 'Chenab Club',
        'image':
            'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=400',
        'description':
            'Established in 1910, the Chenab Club is a historic social club in Faisalabad, representing the colonial era’s architecture and lifestyle.',
      },
    ],
    latitude: 31.4504,
    longitude: 73.1350,
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
  Destination(
    id: '14',
    city: 'Gwadar',
    country: 'Pakistan',
    imageUrl:
        'https://images.unsplash.com/photo-1627663243954-d891632007d3?q=80&w=800', // Aerial view of Gwadar
    rating: 4.8,
    price: 'Rs. 30,000',
    description:
        'Gwadar is a port city on the southwestern coast of Balochistan. Known for its deep-sea port and stunning coastline, it is a key part of the CPEC project and a rising tourist destination.',
    facilities: ['Port View', 'Beach', 'Wifi', 'Boating'],
    attractions: [
      {
        'name': 'Gwadar Port',
        'image':
            'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?q=80&w=400',
        'description':
            'The Gwadar Deep Water Port is the centerpiece of the city’s development. It is one of the deepest ports in the world and offers impressive views of maritime traffic.',
      },
      {
        'name': 'Marine Drive',
        'image':
            'https://images.unsplash.com/photo-1590001158193-790130abe86a?q=80&w=400',
        'description':
            'Gwadar’s Marine Drive is a beautiful coastal road along the Arabian Sea, perfect for evening walks and enjoying the sea breeze with a view of the sunset.',
      },
      {
        'name': 'Hammerhead',
        'image':
            'https://images.unsplash.com/photo-1518998053502-5190a3915a25?q=80&w=400',
        'description':
            'The Hammerhead is a unique landform that looks like a hammerhead shark from above. It provides a natural harbor for the city and is a significant geological feature.',
      },
      {
        'name': 'Koh-e-Batil',
        'image':
            'https://images.unsplash.com/photo-1516422317950-ad73562a2828?q=80&w=400',
        'description':
            'Koh-e-Batil is a famous hill in Gwadar. Climbing to the top offers breathtaking panoramic views of the entire Gwadar city, the port, and the surrounding ocean.',
      },
    ],
    latitude: 25.1216,
    longitude: 62.3254,
  ),
];
