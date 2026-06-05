const express = require('express');
const router = express.Router();
const { getDb } = require('../db');
const { authenticateToken } = require('../middleware/auth');

function safeJsonParse(str, fallback = []) {
  try {
    return str ? JSON.parse(str) : fallback;
  } catch (e) {
    console.error('JSON parse error:', e);
    return fallback;
  }
}

// GET / - Get all bookmarked destinations for authenticated user
router.get('/', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  try {
    const db = await getDb();
    
    // Join saved_destinations with destinations details
    const rows = await db.all(`
      SELECT d.* FROM destinations d
      INNER JOIN saved_destinations sd ON d.id = sd.destination_id
      WHERE sd.user_id = ?
    `, [userId]);

    const destinations = rows.map(row => ({
      ...row,
      facilities: safeJsonParse(row.facilities, []),
      attractions: safeJsonParse(row.attractions, []),
      hotels: safeJsonParse(row.hotels, [])
    }));

    res.json({ destinations });
  } catch (error) {
    console.error('Fetch saved destinations error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST / - Bookmark a destination
router.post('/', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { destination_id } = req.body;

  if (!destination_id) {
    return res.status(400).json({ error: 'destination_id is required' });
  }

  try {
    const db = await getDb();
    
    // Verify destination exists
    const dest = await db.get('SELECT * FROM destinations WHERE id = ?', [destination_id]);
    if (!dest) {
      return res.status(404).json({ error: 'Destination not found' });
    }

    // Insert relationship (or ignore if already exists)
    await db.run(
      'INSERT OR IGNORE INTO saved_destinations (user_id, destination_id) VALUES (?, ?)',
      [userId, destination_id]
    );

    res.json({ message: 'Destination bookmarked successfully' });
  } catch (error) {
    console.error('Save destination error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /:id - Remove bookmark
router.delete('/:id', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const destinationId = req.params.id;

  try {
    const db = await getDb();
    await db.run(
      'DELETE FROM saved_destinations WHERE user_id = ? AND destination_id = ?',
      [userId, destinationId]
    );

    res.json({ message: 'Bookmark removed successfully' });
  } catch (error) {
    console.error('Delete bookmark error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
