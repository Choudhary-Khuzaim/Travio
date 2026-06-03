const express = require('express');
const router = express.Router();
const { getDb } = require('../db');

// GET / - Get all destinations
router.get('/', async (req, res) => {
  try {
    const db = await getDb();
    const rows = await db.all('SELECT * FROM destinations');
    
    // Parse JSON fields
    const destinations = rows.map(row => ({
      ...row,
      facilities: row.facilities ? JSON.parse(row.facilities) : [],
      attractions: row.attractions ? JSON.parse(row.attractions) : [],
      hotels: row.hotels ? JSON.parse(row.hotels) : []
    }));

    res.json({ destinations });
  } catch (error) {
    console.error('Fetch destinations error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /:id - Get destination details by ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const db = await getDb();
    const row = await db.get('SELECT * FROM destinations WHERE id = ?', [id]);

    if (!row) {
      return res.status(404).json({ error: 'Destination not found' });
    }

    const destination = {
      ...row,
      facilities: row.facilities ? JSON.parse(row.facilities) : [],
      attractions: row.attractions ? JSON.parse(row.attractions) : [],
      hotels: row.hotels ? JSON.parse(row.hotels) : []
    };

    res.json({ destination });
  } catch (error) {
    console.error('Fetch destination details error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
