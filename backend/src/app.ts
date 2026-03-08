import express, { Application } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import { config } from './config/env';
import { generalLimiter } from './middlewares/rateLimit.middleware';
import { errorHandler, notFound } from './middlewares/error.middleware';
import logger from './utils/logger';

// Import routes
import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import auctionsRoutes from './modules/auctions/auctions.routes';
import bidsRoutes from './modules/bids/bids.routes';
import paymentsRoutes from './modules/payments/payments.routes';

/**
 * Create Express Application
 */
export function createApp(): Application {
  const app: Application = express();

  // ========================================
  // Security Middleware
  // ========================================

  // Helmet - Set security headers
  app.use(helmet());

  // CORS - Enable Cross-Origin Resource Sharing
  app.use(
    cors({
      origin: config.cors.allowedOrigins,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    })
  );

  // ========================================
  // Body Parsing Middleware
  // ========================================

  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true, limit: '10mb' }));
  app.use(cookieParser());

  // ========================================
  // Rate Limiting
  // ========================================

  // Apply general rate limiting to all routes
  app.use(generalLimiter);

  // ========================================
  // Request Logging
  // ========================================

  app.use((req, _res, next) => {
    logger.debug(`${req.method} ${req.path}`, {
      ip: req.ip,
      userAgent: req.get('user-agent'),
    });
    next();
  });

  // ========================================
  // Health Check Endpoint
  // ========================================

  app.get('/health', (_req, res) => {
    res.status(200).json({
      success: true,
      message: 'Server is healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    });
  });

  // ========================================
  // API Routes
  // ========================================

  const API_PREFIX = '/api/v1';

  app.use(`${API_PREFIX}/auth`, authRoutes);
  app.use(`${API_PREFIX}/users`, usersRoutes);
  app.use(`${API_PREFIX}/auctions`, auctionsRoutes);
  app.use(`${API_PREFIX}/bids`, bidsRoutes);
  app.use(`${API_PREFIX}/payments`, paymentsRoutes);

  // ========================================
  // API Documentation / Welcome Route
  // ========================================

  app.get('/', (_req, res) => {
    res.status(200).json({
      success: true,
      message: 'Welcome to Bidding App API',
      version: '1.0.0',
      documentation: '/api/v1',
      endpoints: {
        auth: `${API_PREFIX}/auth`,
        users: `${API_PREFIX}/users`,
        auctions: `${API_PREFIX}/auctions`,
        bids: `${API_PREFIX}/bids`,
        payments: `${API_PREFIX}/payments`,
      },
      websocket: {
        namespace: '/bidding',
        events: ['joinAuction', 'leaveAuction', 'bidUpdate', 'auctionExtended', 'auctionClosed'],
      },
    });
  });

  // ========================================
  // Error Handling
  // ========================================

  // 404 handler
  app.use(notFound);

  // Global error handler (must be last)
  app.use(errorHandler);

  // ========================================
  // Unhandled Rejection Handler
  // ========================================

  process.on('unhandledRejection', (reason: any, _promise: Promise<any>) => {
    logger.error('Unhandled Rejection:', reason);
    // In production, you might want to restart the process
    // process.exit(1);
  });

  process.on('uncaughtException', (error: Error) => {
    logger.error('Uncaught Exception:', error);
    // Exit process for uncaught exceptions
    process.exit(1);
  });

  return app;
}
