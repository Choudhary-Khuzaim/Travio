const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { getDb } = require('../db');
const { authenticateToken, JWT_SECRET } = require('../middleware/auth');

// POST /signup - Register a user
router.post('/signup', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const normalizedEmail = email.toLowerCase().trim();
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(normalizedEmail)) {
    return res.status(400).json({ error: 'Invalid email format' });
  }

  if (password.length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters long' });
  }

  try {
    const db = await getDb();
    
    // Check if user already exists
    const existingUser = await db.get('SELECT * FROM users WHERE email = ?', [normalizedEmail]);
    if (existingUser) {
      return res.status(409).json({ error: 'Email already registered' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);
    const userId = crypto.randomUUID();

    // Insert user (profile fields will be filled in create-profile step)
    await db.run(
      'INSERT INTO users (id, email, password_hash) VALUES (?, ?, ?)',
      [userId, normalizedEmail, passwordHash]
    );

    // Return verification OTP code (mocked as '0000')
    res.status(201).json({
      message: 'Signup successful. OTP sent.',
      email: normalizedEmail,
      otp: '0000'
    });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /verify-otp - Verify OTP and generate JWT token
router.post('/verify-otp', async (req, res) => {
  const { email, otp } = req.body;

  if (!email || otp === undefined || otp === null) {
    return res.status(400).json({ error: 'Email and OTP are required' });
  }

  const normalizedEmail = email.toLowerCase().trim();

  if (String(otp) !== '0000') {
    return res.status(400).json({ error: 'Invalid OTP code' });
  }

  try {
    const db = await getDb();
    const user = await db.get('SELECT * FROM users WHERE email = ?', [normalizedEmail]);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Generate JWT
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    res.json({
      message: 'OTP verified successfully',
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name || '',
        phone: user.phone || '',
        location: user.location || '',
        profile_image: user.profile_image || ''
      }
    });
  } catch (error) {
    console.error('OTP verification error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /create-profile - Complete profile setup (Authenticated)
router.post('/create-profile', authenticateToken, async (req, res) => {
  const { name, phone, location, profile_image } = req.body;
  const userId = req.user.id;

  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }

  try {
    const db = await getDb();
    
    await db.run(
      'UPDATE users SET name = ?, phone = ?, location = ?, profile_image = ? WHERE id = ?',
      [name, phone || '', location || '', profile_image || '', userId]
    );

    const updatedUser = await db.get('SELECT id, email, name, phone, location, profile_image FROM users WHERE id = ?', [userId]);

    res.json({
      message: 'Profile created successfully',
      user: updatedUser
    });
  } catch (error) {
    console.error('Create profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /login - Login user
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const normalizedEmail = email.toLowerCase().trim();

  try {
    const db = await getDb();
    const user = await db.get('SELECT * FROM users WHERE email = ?', [normalizedEmail]);

    if (!user) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Generate JWT
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name || '',
        phone: user.phone || '',
        location: user.location || '',
        profile_image: user.profile_image || ''
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /profile - Get current user profile (Authenticated)
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const db = await getDb();
    const user = await db.get(
      'SELECT id, email, name, phone, location, profile_image, created_at FROM users WHERE id = ?',
      [req.user.id]
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PUT /profile - Update profile details (Authenticated)
router.put('/profile', authenticateToken, async (req, res) => {
  const { name, phone, location, profile_image } = req.body;
  const userId = req.user.id;

  try {
    const db = await getDb();
    
    await db.run(
      'UPDATE users SET name = ?, phone = ?, location = ?, profile_image = ? WHERE id = ?',
      [name || '', phone || '', location || '', profile_image || '', userId]
    );

    const updatedUser = await db.get('SELECT id, email, name, phone, location, profile_image FROM users WHERE id = ?', [userId]);

    res.json({
      message: 'Profile updated successfully',
      user: updatedUser
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /forgot-password - Forgot password stub
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }
  const normalizedEmail = email.toLowerCase().trim();
  res.json({
    message: 'Password reset code sent successfully',
    email: normalizedEmail,
    otp: '0000'
  });
});

module.exports = router;
