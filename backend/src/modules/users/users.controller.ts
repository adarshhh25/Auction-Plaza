import { Response } from 'express';
import usersService from './users.service';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { AppError } from '../../middlewares/error.middleware';
import logger from '../../utils/logger';

/**
 * Users Controller
 * Handles HTTP requests for user operations
 */
export class UsersController {
  /**
   * Get current user profile
   * GET /users/profile
   */
  async getProfile(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const user = await usersService.getProfile(req.user.userId);

      res.status(200).json({
        success: true,
        data: user,
      });
    } catch (error: any) {
      logger.error('Get profile controller error:', error);
      
      if (error.message === 'User not found') {
        throw new AppError(error.message, 404);
      }
      
      throw new AppError('Failed to get profile', 500);
    }
  }

  /**
   * Update current user profile
   * PATCH /users/profile
   */
  async updateProfile(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const updates = {
        name: req.body.name,
      };

      const user = await usersService.updateProfile(req.user.userId, updates);

      res.status(200).json({
        success: true,
        message: 'Profile updated successfully',
        data: user,
      });
    } catch (error: any) {
      logger.error('Update profile controller error:', error);
      
      if (error.message === 'User not found') {
        throw new AppError(error.message, 404);
      }
      
      throw new AppError('Failed to update profile', 500);
    }
  }

  /**
   * Add funds to wallet
   * POST /users/wallet/add
   */
  async addFunds(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const { amount } = req.body;

      if (!amount || typeof amount !== 'number') {
        throw new AppError('Valid amount is required', 400);
      }

      const user = await usersService.addFunds(req.user.userId, amount);

      res.status(200).json({
        success: true,
        message: 'Funds added successfully',
        data: user,
      });
    } catch (error: any) {
      logger.error('Add funds controller error:', error);
      
      if (error.message === 'Amount must be greater than 0') {
        throw new AppError(error.message, 400);
      }
      
      throw new AppError('Failed to add funds', 500);
    }
  }

  /**
   * Get wallet balance
   * GET /users/wallet/balance
   */
  async getWalletBalance(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const balance = await usersService.getWalletBalance(req.user.userId);

      res.status(200).json({
        success: true,
        data: balance,
      });
    } catch (error: any) {
      logger.error('Get wallet balance controller error:', error);
      throw new AppError('Failed to get wallet balance', 500);
    }
  }
}

export default new UsersController();
