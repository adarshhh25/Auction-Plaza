import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

/**
 * Environment Configuration
 * Centralized configuration for all environment variables
 */
export const config = {
  // Server Configuration
  node_env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '5000', 10),

  // Database Configuration
  mongodb: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/bidding_app',
  },

  // JWT Configuration
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'default-access-secret',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'default-refresh-secret',
    accessExpiry: process.env.JWT_ACCESS_EXPIRY || '15m',
    refreshExpiry: process.env.JWT_REFRESH_EXPIRY || '7d',
  },

  // Security Configuration
  bcrypt: {
    rounds: parseInt(process.env.BCRYPT_ROUNDS || '12', 10),
  },

  // Rate Limiting Configuration
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000', 10),
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100', 10),
    bidWindowMs: parseInt(process.env.BID_RATE_LIMIT_WINDOW_MS || '10000', 10),
    bidMaxRequests: parseInt(process.env.BID_RATE_LIMIT_MAX_REQUESTS || '5', 10),
  },

  // Auction Configuration
  auction: {
    antiSnipeSeconds: parseInt(process.env.ANTI_SNIPE_SECONDS || '60', 10),
    antiSnipeExtensionSeconds: parseInt(
      process.env.ANTI_SNIPE_EXTENSION_SECONDS || '60',
      10
    ),
    checkIntervalSeconds: parseInt(
      process.env.AUCTION_CHECK_INTERVAL_SECONDS || '10',
      10
    ),
  },

  // CORS Configuration
  cors: {
    allowedOrigins: process.env.ALLOWED_ORIGINS
      ? process.env.ALLOWED_ORIGINS.split(',')
      : ['http://localhost:3000', 'http://localhost:19000', 'http://localhost:19006'],
  },
};

/**
 * Validate critical environment variables
 */
export const validateConfig = (): void => {
  const requiredVars = [
    'MONGODB_URI',
    'JWT_ACCESS_SECRET',
    'JWT_REFRESH_SECRET',
  ];

  const missing = requiredVars.filter((varName) => !process.env[varName]);

  if (missing.length > 0) {
    console.warn(
      `⚠️  Warning: Missing environment variables: ${missing.join(', ')}`
    );
    console.warn('Using default values. Please set these in production!');
  }
};
