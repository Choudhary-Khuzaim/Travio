const sqlite3 = require('sqlite3');
const { open } = require('sqlite');
const path = require('path');

const dbPath = path.join(__dirname, '..', 'travio.db');

let dbConnection = null;

async function getDb() {
  if (dbConnection) return dbConnection;

  dbConnection = await open({
    filename: dbPath,
    driver: sqlite3.Database
  });

  // Enable foreign keys
  await dbConnection.run('PRAGMA foreign_keys = ON;');
  return dbConnection;
}

async function initDb() {
  const db = await getDb();

  // Create tables
  await db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      email TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      name TEXT,
      phone TEXT,
      location TEXT,
      profile_image TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS destinations (
      id TEXT PRIMARY KEY,
      city TEXT NOT NULL,
      country TEXT NOT NULL,
      imageUrl TEXT NOT NULL,
      rating REAL,
      price TEXT,
      description TEXT,
      facilities TEXT, -- JSON stringified array
      attractions TEXT, -- JSON stringified array of objects
      hotels TEXT, -- JSON stringified array of objects
      latitude REAL,
      longitude REAL
    );

    CREATE TABLE IF NOT EXISTS flights (
      id TEXT PRIMARY KEY,
      airline TEXT NOT NULL,
      airlineLogo TEXT NOT NULL,
      fromCity TEXT NOT NULL,
      fromCode TEXT NOT NULL,
      toCity TEXT NOT NULL,
      toCode TEXT NOT NULL,
      departureTime TEXT NOT NULL,
      arrivalTime TEXT NOT NULL,
      price REAL,
      duration TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS saved_destinations (
      user_id TEXT,
      destination_id TEXT,
      PRIMARY KEY (user_id, destination_id),
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS bookings (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      type TEXT NOT NULL, -- 'flight', 'hotel', 'cab'
      details TEXT NOT NULL, -- JSON details
      price REAL,
      booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
      status TEXT DEFAULT 'Confirmed',
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS trips (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      airline TEXT NOT NULL,
      flightNo TEXT NOT NULL,
      from_code TEXT NOT NULL,
      from_city TEXT NOT NULL,
      to_code TEXT NOT NULL,
      to_city TEXT NOT NULL,
      duration TEXT NOT NULL,
      date TEXT NOT NULL,
      time TEXT NOT NULL,
      seat TEXT NOT NULL,
      gate TEXT NOT NULL,
      status TEXT DEFAULT 'Confirmed',
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `);

  // Seed Destinations if empty
  const destCount = await db.get('SELECT COUNT(*) as count FROM destinations');
  if (destCount.count === 0) {
    console.log('Seeding destinations into database...');
    const destinationsList = [
      {
        id: '4',
        city: 'Islamabad',
        country: 'Pakistan',
        imageUrl: 'https://images.unsplash.com/photo-1627896157734-4d7d4388f24b?q=80&w=1000', // Replaced local assets with beautiful unsplash image urls
        rating: 4.9,
        price: 'Rs. 12,000',
        description: 'The beautiful capital city of Pakistan, known for its greenery, Margalla Hills, and peaceful atmosphere.',
        facilities: JSON.stringify(['Hiking', 'Parks', 'Wifi', 'Restaurants']),
        attractions: JSON.stringify([
          {
            name: 'Faisal Mosque',
            image: 'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=600',
            description: 'Faisal Mosque is the largest mosque in Pakistan, located in the foothills of Margalla Hills in Islamabad.'
          },
          {
            name: 'Lok Virsa',
            image: 'https://images.unsplash.com/photo-1615560124350-0081d0be6ca1?q=80&w=600',
            description: 'The Lok Virsa Museum is a museum of history and culture in Islamabad, showcasing the diverse heritage of Pakistan.'
          },
          {
            name: 'Pakistan Monument',
            image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?q=80&w=600',
            description: 'The Pakistan Monument is a national monument and heritage museum representing the four provinces.'
          }
        ]),
        hotels: JSON.stringify([
          {
            name: 'Serena Hotel',
            image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600',
            rating: 4.9,
            price: 'Rs. 45,000',
            location: 'Khayaban-e-Suharwardy, Islamabad'
          },
          {
            name: 'Islamabad Marriott Hotel',
            image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=600',
            rating: 4.8,
            price: 'Rs. 38,000',
            location: 'Aga Khan Rd, Islamabad'
          }
        ]),
        latitude: 33.6844,
        longitude: 73.0479
      },
      {
        id: '6',
        city: 'Karachi',
        country: 'Pakistan',
        imageUrl: 'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=1000',
        rating: 4.8,
        price: 'Rs. 20,000',
        description: 'The city of lights and the economic hub of Pakistan. Famous for its beaches, nightlife, and diverse food culture.',
        facilities: JSON.stringify(['Beach', 'Seaview', 'Wifi', 'Mall']),
        attractions: JSON.stringify([
          {
            name: 'Clifton Beach',
            image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=600',
            description: 'Clifton Beach is a popular beach in Karachi along the Arabian Sea.'
          },
          {
            name: 'Mazar-e-Quaid',
            image: 'https://images.unsplash.com/photo-1622547748225-3fc4abd2cca0?q=80&w=600',
            description: 'Mazar-e-Quaid is the final resting place of Quaid-e-Azam Muhammad Ali Jinnah.'
          }
        ]),
        hotels: JSON.stringify([
          {
            name: 'Pearl Continental Hotel',
            image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=600',
            rating: 4.7,
            price: 'Rs. 30,000',
            location: 'Club Rd, Karachi'
          },
          {
            name: 'Mövenpick Hotel',
            image: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=600',
            rating: 4.8,
            price: 'Rs. 32,000',
            location: 'Club Rd, Karachi'
          }
        ]),
        latitude: 24.8607,
        longitude: 67.0011
      },
      {
        id: '3',
        city: 'Lahore',
        country: 'Pakistan',
        imageUrl: 'https://images.unsplash.com/photo-1602497672207-6bb40213d2f9?q=80&w=1000',
        rating: 4.8,
        price: 'Rs. 15,000',
        description: 'Lahore is the heart of Pakistan. Known for its rich history, vibrant culture, and delicious food street.',
        facilities: JSON.stringify(['Museum', 'Food', 'Wifi', 'Hotel']),
        attractions: JSON.stringify([
          {
            name: 'Badshahi Mosque',
            image: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=600',
            description: 'Built by Emperor Aurangzeb in 1673, the Badshahi Mosque is an iconic Mughal-era mosque.'
          },
          {
            name: 'Lahore Fort',
            image: 'https://images.unsplash.com/photo-1588052144365-d01c0a0c4f82?q=80&w=600',
            description: 'A Citadel in the city of Lahore, the Lahore Fort (Shahi Qila) is a UNESCO World Heritage site.'
          }
        ]),
        hotels: JSON.stringify([
          {
            name: 'Pearl Continental Lahore',
            image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600',
            rating: 4.8,
            price: 'Rs. 35,000',
            location: 'Shahrah-e-Quaid-e-Azam, Lahore'
          },
          {
            name: 'The Nishat Hotel',
            image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600',
            rating: 4.9,
            price: 'Rs. 40,000',
            location: 'Gulberg III, Lahore'
          }
        ]),
        latitude: 31.5204,
        longitude: 74.3587
      },
      {
        id: '7',
        city: 'Quetta',
        country: 'Pakistan',
        imageUrl: 'https://images.unsplash.com/photo-1538330621152-478fc1255d01?q=80&w=1000',
        rating: 4.9,
        price: 'Rs. 18,000',
        description: 'The Fruit Garden of Pakistan, Quetta is famous for its delicious fruits, dry fruits, and the majestic Quetta Serena Hotel.',
        facilities: JSON.stringify(['Fruit Markets', 'Mountains', 'Wifi', 'Hotel']),
        attractions: JSON.stringify([
          {
            name: 'Hanna Lake',
            image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600',
            description: 'Hanna Lake is one of the most beautiful lakes in Quetta, surrounded by mountains.'
          }
        ]),
        hotels: JSON.stringify([
          {
            name: 'Quetta Serena Hotel',
            image: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
            rating: 4.9,
            price: 'Rs. 45,000',
            location: 'Shahrah-e-Zarghoon, Quetta'
          }
        ]),
        latitude: 30.1798,
        longitude: 66.9750
      },
      {
        id: '5',
        city: 'Swat',
        country: 'Pakistan',
        imageUrl: 'https://images.unsplash.com/photo-1598091873871-23f8e713b2c9?q=80&w=1000',
        rating: 4.8,
        price: 'Rs. 25,000',
        description: 'Known as the Switzerland of the East, Swat offers lush green valleys, rivers, and snow-capped mountains.',
        facilities: JSON.stringify(['River View', 'Heater', 'Camping', 'Food']),
        attractions: JSON.stringify([
          {
            name: 'Malam Jabba',
            image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=600',
            description: 'Malam Jabba is a popular hill station and ski resort in the Hindu Kush mountain range.'
          }
        ]),
        hotels: JSON.stringify([
          {
            name: 'Swat Serena Hotel',
            image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=600',
            rating: 4.8,
            price: 'Rs. 35,000',
            location: 'Saidu Sharif, Swat'
          }
        ]),
        latitude: 34.7717,
        longitude: 72.3602
      }
    ];

    const stmt = await db.prepare(`
      INSERT INTO destinations (id, city, country, imageUrl, rating, price, description, facilities, attractions, hotels, latitude, longitude)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    for (const dest of destinationsList) {
      await stmt.run(
        dest.id,
        dest.city,
        dest.country,
        dest.imageUrl,
        dest.rating,
        dest.price,
        dest.description,
        dest.facilities,
        dest.attractions,
        dest.hotels,
        dest.latitude,
        dest.longitude
      );
    }
    await stmt.finalize();
  }

  // Seed Flights if empty
  const flightCount = await db.get('SELECT COUNT(*) as count FROM flights');
  if (flightCount.count === 0) {
    console.log('Seeding flights into database...');
    const now = new Date();
    
    // Helper to get formatted dates
    const addDays = (days, hours) => {
      const d = new Date(now);
      d.setDate(d.getDate() + days);
      d.setHours(d.getHours() + hours);
      return d.toISOString();
    };

    const flightsList = [
      {
        id: '1',
        airline: 'PIA',
        airlineLogo: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Pakistan_International_Airlines_logo.svg',
        fromCity: 'Karachi',
        fromCode: 'KHI',
        toCity: 'Islamabad',
        toCode: 'ISB',
        departureTime: addDays(1, 10),
        arrivalTime: addDays(1, 12),
        price: 15000.00,
        duration: '2h 00m'
      },
      {
        id: '2',
        airline: 'Airblue',
        airlineLogo: 'https://upload.wikimedia.org/wikipedia/en/e/e2/Airblue_Logo.svg',
        fromCity: 'Lahore',
        fromCode: 'LHE',
        toCity: 'Karachi',
        toCode: 'KHI',
        departureTime: addDays(1, 8),
        arrivalTime: addDays(1, 9),
        price: 25000.50,
        duration: '1h 00m'
      },
      {
        id: '3',
        airline: 'SereneAir',
        airlineLogo: 'https://upload.wikimedia.org/wikipedia/en/4/4e/SereneAir_logo.svg',
        fromCity: 'Islamabad',
        fromCode: 'ISB',
        toCity: 'Karachi',
        toCode: 'KHI',
        departureTime: addDays(2, 7),
        arrivalTime: addDays(2, 9),
        price: 12000.00,
        duration: '2h 00m'
      },
      {
        id: '4',
        airline: 'AirSial',
        airlineLogo: 'https://upload.wikimedia.org/wikipedia/en/6/6b/AirSial_logo.svg',
        fromCity: 'Karachi',
        fromCode: 'KHI',
        toCity: 'Lahore',
        toCode: 'LHE',
        departureTime: addDays(3, 14),
        arrivalTime: addDays(3, 16),
        price: 18500.00,
        duration: '2h 00m'
      }
    ];

    const stmt = await db.prepare(`
      INSERT INTO flights (id, airline, airlineLogo, fromCity, fromCode, toCity, toCode, departureTime, arrivalTime, price, duration)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    for (const fl of flightsList) {
      await stmt.run(
        fl.id,
        fl.airline,
        fl.airlineLogo,
        fl.fromCity,
        fl.fromCode,
        fl.toCity,
        fl.toCode,
        fl.departureTime,
        fl.arrivalTime,
        fl.price,
        fl.duration
      );
    }
    await stmt.finalize();
  }
}

module.exports = {
  getDb,
  initDb
};
