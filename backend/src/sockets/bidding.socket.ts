import { Server as HTTPServer } from 'http';
import { Server as SocketIOServer, Socket } from 'socket.io';
import { verifyAccessToken } from '../config/jwt';
import logger from '../utils/logger';
import { config } from '../config/env';

/**
 * Initialize Socket.IO server with authentication
 */
export function initializeSocket(httpServer: HTTPServer): SocketIOServer {
  const io = new SocketIOServer(httpServer, {
    cors: {
      origin: config.cors.allowedOrigins,
      credentials: true,
    },
    path: '/socket.io',
  });

  /**
   * Authentication middleware for Socket.IO
   */
  io.use((socket, next) => {
    try {
      const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.split(' ')[1];

      if (!token) {
        return next(new Error('Authentication token required'));
      }

      // Verify JWT token
      const decoded = verifyAccessToken(token);
      (socket as any).user = decoded;

      logger.debug(`Socket authenticated: User ${decoded.userId}`);
      next();
    } catch (error) {
      logger.warn('Socket authentication failed:', error);
      next(new Error('Authentication failed'));
    }
  });

  /**
   * Bidding namespace for auction-related real-time events
   */
  const biddingNamespace = io.of('/bidding');

  biddingNamespace.on('connection', (socket: Socket) => {
    const user = (socket as any).user;
    logger.info(`User connected to bidding namespace: ${user?.userId}`);

    /**
     * Join auction room
     * Client emits: { auctionId: string }
     */
    socket.on('joinAuction', (data: { auctionId: string }) => {
      const { auctionId } = data;
      
      if (!auctionId) {
        socket.emit('error', { message: 'Auction ID is required' });
        return;
      }

      const roomName = `auction_${auctionId}`;
      socket.join(roomName);
      
      logger.debug(`User ${user?.userId} joined auction room: ${roomName}`);
      
      socket.emit('joinedAuction', {
        auctionId,
        message: 'Successfully joined auction room',
      });
    });

    /**
     * Leave auction room
     * Client emits: { auctionId: string }
     */
    socket.on('leaveAuction', (data: { auctionId: string }) => {
      const { auctionId } = data;
      
      if (!auctionId) {
        socket.emit('error', { message: 'Auction ID is required' });
        return;
      }

      const roomName = `auction_${auctionId}`;
      socket.leave(roomName);
      
      logger.debug(`User ${user?.userId} left auction room: ${roomName}`);
      
      socket.emit('leftAuction', {
        auctionId,
        message: 'Successfully left auction room',
      });
    });

    /**
     * Handle disconnect
     */
    socket.on('disconnect', (reason) => {
      logger.info(`User disconnected from bidding namespace: ${user?.userId}, Reason: ${reason}`);
    });

    /**
     * Handle errors
     */
    socket.on('error', (error) => {
      logger.error('Socket error:', error);
    });
  });

  logger.info('✅ Socket.IO initialized with /bidding namespace');
  return io;
}

/**
 * Broadcast event to specific auction room
 */
export function broadcastToAuction(
  io: SocketIOServer,
  auctionId: string,
  event: string,
  data: any
) {
  const roomName = `auction_${auctionId}`;
  io.of('/bidding').to(roomName).emit(event, data);
  logger.debug(`Broadcasted ${event} to ${roomName}`);
}
