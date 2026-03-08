import mongoose from 'mongoose';
import { config } from './env';
import logger from '../utils/logger';

/**
 * MongoDB Connection Configuration
 */
const connectDB = async (): Promise<void> => {
  try {
    const options = {
      // Use new URL parser
      // useNewUrlParser: true, // Deprecated in newer versions
      // useUnifiedTopology: true, // Deprecated in newer versions
      
      // Set up connection pool
      maxPoolSize: 10,
      minPoolSize: 5,
      
      // Connection timeout
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
      
      // Auto index
      autoIndex: config.node_env === 'development',
    };

    const conn = await mongoose.connect(config.mongodb.uri, options);

    logger.info(`✅ MongoDB Connected: ${conn.connection.host}`);
    logger.info(`📊 Database: ${conn.connection.name}`);

    // Handle connection events
    mongoose.connection.on('error', (err) => {
      logger.error('MongoDB connection error:', err);
    });

    mongoose.connection.on('disconnected', () => {
      logger.warn('MongoDB disconnected. Attempting to reconnect...');
    });

    mongoose.connection.on('reconnected', () => {
      logger.info('MongoDB reconnected');
    });

    // Graceful shutdown
    process.on('SIGINT', async () => {
      await mongoose.connection.close();
      logger.info('MongoDB connection closed due to app termination');
      process.exit(0);
    });

  } catch (error) {
    logger.error('Failed to connect to MongoDB:', error);
    process.exit(1);
  }
};

/**
 * Disconnect from MongoDB
 */
export const disconnectDB = async (): Promise<void> => {
  try {
    await mongoose.connection.close();
    logger.info('MongoDB connection closed');
  } catch (error) {
    logger.error('Error closing MongoDB connection:', error);
  }
};

export default connectDB;
