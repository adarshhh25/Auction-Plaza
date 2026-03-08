import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken, JWTPayload } from '../config/jwt';
import logger from '../utils/logger';

/**
 * Extend Express Request to include user data
 */
export interface AuthRequest extends Request {
  user?: JWTPayload;
}

/**
 * Authentication Middleware
 * Verifies JWT access token and attaches user data to request
 */
export const authenticate = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // Get token from Authorization header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        success: false,
        message: 'Access token is required',
      });
      return;
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    try {
      // Verify token
      const decoded = verifyAccessToken(token);

      // Attach user data to request
      req.user = decoded;

      next();
    } catch (error) {
      logger.warn('Invalid access token attempt');
      res.status(401).json({
        success: false,
        message: 'Invalid or expired access token',
      });
      return;
    }
  } catch (error) {
    logger.error('Authentication middleware error:', error);
    res.status(500).json({
      success: false,
      message: 'Authentication failed',
    });
    return;
  }
};

/**
 * Optional Authentication Middleware
 * Attaches user data if token is present, but doesn't fail if absent
 */
export const optionalAuthenticate = async (
  req: AuthRequest,
  _res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);

      try {
        const decoded = verifyAccessToken(token);
        req.user = decoded;
      } catch (error) {
        // Token is invalid, but we don't fail the request
        logger.debug('Optional auth: Invalid token provided');
      }
    }

    next();
  } catch (error) {
    logger.error('Optional authentication middleware error:', error);
    next();
  }
};
