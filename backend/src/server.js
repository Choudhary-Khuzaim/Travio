const express = require('express');
const cors = require('cors');
const { initDb } = require('./db');

const authRoutes = require('./routes/auth');
const destinationRoutes = require('./routes/destinations');
const flightRoutes = require('./routes/flights');
const bookingRoutes = require('./routes/bookings');
const tripRoutes = require('./routes/trips');
const savedRoutes = require('./routes/saved');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/destinations', destinationRoutes);
app.use('/api/flights', flightRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/saved', savedRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// Start Server
async function startServer() {
  try {
    console.log('Initializing database...');
    await initDb();
    console.log('Database initialized successfully.');

    app.listen(PORT, '0.0.0.0', () => {
      console.log(`Travio Backend running on http://localhost:${PORT}`);
      console.log(`External access available on http://0.0.0.0:${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
