const express = require('express');
const router = express.Router();
const crypto = require('crypto');
const { getDb } = require('../db');
const { authenticateToken } = require('../middleware/auth');

function safeJsonParse(str, fallback = {}) {
  try {
    return str ? JSON.parse(str) : fallback;
  } catch (e) {
    console.error('JSON parse error:', e);
    return fallback;
  }
}

// GET / - Retrieve user's bookings
router.get('/', authenticateToken, async (req, res) => {
  const userId = req.user.id;

  try {
    const db = await getDb();
    const rows = await db.all('SELECT * FROM bookings WHERE user_id = ? ORDER BY booking_date DESC', [userId]);

    const bookings = rows.map(row => ({
      ...row,
      details: safeJsonParse(row.details, {})
    }));

    res.json({ bookings });
  } catch (error) {
    console.error('Fetch bookings error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST / - Create a booking
router.post('/', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { type, details, price } = req.body;

  if (!type || !details) {
    return res.status(400).json({ error: 'Type and details are required' });
  }

  try {
    const db = await getDb();
    const bookingId = crypto.randomUUID();

    await db.run(
      'INSERT INTO bookings (id, user_id, type, details, price) VALUES (?, ?, ?, ?, ?)',
      [bookingId, userId, type, JSON.stringify(details), price || 0]
    );

    // Also, if it is a flight booking, let's automatically create a trip item for convenience!
    if (type === 'flight') {
      const tripId = crypto.randomUUID();
      const flightDate = details.date || new Date().toDateString();
      const flightTime = details.time || '12:00 PM';
      const flightSeat = details.seat || '12A';
      const flightGate = details.gate || 'A1';

      await db.run(`
        INSERT INTO trips (id, user_id, airline, flightNo, from_code, from_city, to_code, to_city, duration, date, time, seat, gate, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Confirmed')
      `, [
        tripId,
        userId,
        details.airline || 'PIA',
        details.flightNo || 'PK 308',
        details.fromCode || 'KHI',
        details.fromCity || 'Karachi',
        details.toCode || 'ISB',
        details.toCity || 'Islamabad',
        details.duration || '2h 00m',
        flightDate,
        flightTime,
        flightSeat,
        flightGate
      ]);
    }

    res.status(201).json({
      message: 'Booking created successfully',
      bookingId
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
