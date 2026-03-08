import { Response, NextFunction } from 'express';
import { AuthRequest } from './auth.middleware';
import { UserRole } from '../models/user.model';
import logger from '../utils/logger';

/**
 * Role-Based Access Control Middleware
 * Requires authentication middleware to run first
 */
export const authorizeRoles = (...allowedRoles: UserRole[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction): void => {
    try {
      // Check if user is authenticated
      if (!req.user) {
        res.status(401).json({
          success: false,
          message: 'Authentication required',
        });
        return;
      }

      // Check if user's role is in allowed roles
      if (!allowedRoles.includes(req.user.role)) {
        logger.warn(
          `Access denied for user ${req.user.userId} with role ${req.user.role}`
        );
        res.status(403).json({
          success: false,
          message: 'You do not have permission to access this resource',
        });
        return;
      }

      next();
    } catch (error) {
      logger.error('Role authorization error:', error);
      res.status(500).json({
        success: false,
        message: 'Authorization failed',
      });
      return;
    }
  };
};

/**
 * Admin Only Middleware
 */
export const adminOnly = authorizeRoles(UserRole.ADMIN);

/**
 * Seller Only Middleware
 */
export const sellerOnly = authorizeRoles(UserRole.SELLER);

/**
 * Buyer Only Middleware
 */
export const buyerOnly = authorizeRoles(UserRole.BUYER);

/**
 * Seller or Admin Middleware
 */
export const sellerOrAdmin = authorizeRoles(UserRole.SELLER, UserRole.ADMIN);

/**
 * Buyer or Admin Middleware
 */
export const buyerOrAdmin = authorizeRoles(UserRole.BUYER, UserRole.ADMIN);
