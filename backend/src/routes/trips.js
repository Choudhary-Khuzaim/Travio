const express = require('express');
const router = express.Router();
const { getDb } = require('../db');
const { authenticateToken } = require('../middleware/auth');

// GET / - Retrieve user's trips split into upcoming and past
router.get('/', authenticateToken, async (req, res) => {
  const userId = req.user.id;

  try {
    const db = await getDb();
    const rows = await db.all('SELECT * FROM trips WHERE user_id = ?', [userId]);

    const upcoming = [];
    const past = [];

    const now = new Date();

    for (const trip of rows) {
      // Parse dates to classify
      let isPastTrip = false;
      try {
        // Support custom formats like "Dec 28", "Jan 05", etc.
        // We'll parse or fallback to status
        if (trip.status === 'Completed' || trip.status === 'Completed'.toUpperCase()) {
          isPastTrip = true;
        } else {
          // Attempt date parsing
          const tripDate = new Date(trip.date);
          if (!isNaN(tripDate.getTime()) && tripDate < now) {
            isPastTrip = true;
          }
        }
      } catch (e) {
        // Fallback
      }

      if (isPastTrip) {
        past.push(trip);
      } else {
        upcoming.push(trip);
      }
    }

    // If both lists are empty, add some seeded trips so the user sees sample data when they first sign up!
    if (rows.length === 0) {
      // Return seeded placeholder trips so the screen is not completely blank for a new user
      const placeholderUpcoming = [
        {
          id: 'seed-upcoming-1',
          user_id: userId,
          airline: 'Emirates',
          flightNo: 'EK 613',
          from_code: 'KHI',
          from_city: 'Karachi',
          to_code: 'DXB',
          to_city: 'Dubai',
          duration: '2h 15m',
          date: 'Dec 28',
          time: '10:30 PM',
          seat: '12A',
          gate: 'B4',
          status: 'Confirmed'
        },
        {
          id: 'seed-upcoming-2',
          user_id: userId,
          airline: 'PIA',
          flightNo: 'PK 308',
          from_code: 'KHI',
          from_city: 'Karachi',
          to_code: 'ISB',
          to_city: 'Islamabad',
          duration: '1h 50m',
          date: 'Jan 12',
          time: '09:00 AM',
          seat: '08C',
          gate: 'C2',
          status: 'Confirmed'
        }
      ];

      const placeholderPast = [
        {
          id: 'seed-past-1',
          user_id: userId,
          airline: 'Turkish Airlines',
          flightNo: 'TK 709',
          from_code: 'KHI',
          from_city: 'Karachi',
          to_code: 'IST',
          to_city: 'Istanbul',
          duration: '6h 10m',
          date: 'Nov 12',
          time: '05:45 AM',
          seat: '14B',
          gate: 'D8',
          status: 'Completed'
        }
      ];

      return res.json({ upcoming: placeholderUpcoming, past: placeholderPast });
    }

    res.json({ upcoming, past });
  } catch (error) {
    console.error('Fetch trips error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
