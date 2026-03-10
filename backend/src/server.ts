import http from 'http';
import { createApp } from './app';
import { config, validateConfig } from './config/env';
import connectDB from './config/db';
import { initializeSocket } from './sockets/bidding.socket';
import auctionJob from './jobs/auction.job';
import logger from './utils/logger';

/**
 * Server Entry Point
 * Initializes and starts the application server
 */
async function startServer() {
  try {
    // ========================================
    // Validate Configuration
    // ========================================

    validateConfig();

    // ========================================
    // Create Express App
    // ========================================

    const app = createApp();

    // ========================================
    // Create HTTP Server
    // ========================================

    const httpServer = http.createServer(app);

    // ========================================
    // Connect to Database
    // ========================================

    await connectDB();

    // ========================================
    // Initialize Socket.IO
    // ========================================

    const io = initializeSocket(httpServer);

    // Store io instance globally for access in other parts of the app
    (global as any).io = io;

    // ========================================
    // Start Scheduled Jobs
    // ========================================

    auctionJob.start();

    // ========================================
    // Start HTTP Server
    // ========================================

    const PORT = config.port;
    const HOST = '0.0.0.0'; // Listen on all network interfaces

    httpServer.listen(PORT, HOST, () => {
      logger.info('='.repeat(50));
      logger.info(`🚀 Server started successfully!`);
      logger.info(`📡 Environment: ${config.node_env}`);
      logger.info(`🌐 Server running on: ${HOST}:${PORT}`);
      logger.info(`🔗 API: http://localhost:${PORT}/api/v1`);
      logger.info(`📱 Android Emulator: http://10.0.2.2:${PORT}/api/v1`);
      logger.info(`🔌 WebSocket: ws://localhost:${PORT}/bidding`);
      logger.info(`💚 Health Check: http://localhost:${PORT}/health`);
      logger.info('='.repeat(50));
    });

    // ========================================
    // Graceful Shutdown
    // ========================================

    const gracefulShutdown = async (signal: string) => {
      logger.info(`\n${signal} received. Starting graceful shutdown...`);

      // Stop accepting new connections
      httpServer.close(() => {
        logger.info('HTTP server closed');
      });

      // Stop scheduled jobs
      auctionJob.stop();

      // Close Socket.IO
      io.close(() => {
        logger.info('Socket.IO closed');
      });

      // Give ongoing requests time to complete
      setTimeout(() => {
        logger.info('Graceful shutdown completed');
        process.exit(0);
      }, 5000);
    };

    // Handle shutdown signals
    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));

  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

// ========================================
// Start the Server
// ========================================

startServer();
