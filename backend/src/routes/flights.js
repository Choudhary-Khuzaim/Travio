const express = require('express');
const router = express.Router();
const { getDb } = require('../db');

// GET / - Search/list all flights
router.get('/', async (req, res) => {
  const { from, to } = req.query;

  try {
    const db = await getDb();
    let query = 'SELECT * FROM flights';
    const params = [];

    if (from && to) {
      query += ' WHERE (fromCity LIKE ? OR fromCode LIKE ?) AND (toCity LIKE ? OR toCode LIKE ?)';
      params.push(`%${from}%`, `%${from}%`, `%${to}%`, `%${to}%`);
    } else if (from) {
      query += ' WHERE fromCity LIKE ? OR fromCode LIKE ?';
      params.push(`%${from}%`, `%${from}%`);
    } else if (to) {
      query += ' WHERE toCity LIKE ? OR toCode LIKE ?';
      params.push(`%${to}%`, `%${to}%`);
    }

    const flights = await db.all(query, params);
    res.json({ flights });
  } catch (error) {
    console.error('Fetch flights error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
