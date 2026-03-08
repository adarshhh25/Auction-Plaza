import { Response } from 'express';
import paymentsService from './payments.service';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { AppError } from '../../middlewares/error.middleware';
import logger from '../../utils/logger';

/**
 * Payments Controller
 * Handles HTTP requests for payment operations
 */
export class PaymentsController {
  /**
   * Create payment for won auction
   * POST /payments/create
   */
  async createPayment(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const { auctionId } = req.body;

      if (!auctionId) {
        throw new AppError('Auction ID is required', 400);
      }

      const payment = await paymentsService.createPayment(req.user.userId, auctionId);

      res.status(201).json({
        success: true,
        message: 'Payment created successfully',
        data: payment,
      });
    } catch (error: any) {
      logger.error('Create payment controller error:', error);

      if (
        error.message === 'Auction not found' ||
        error.message === 'User not found'
      ) {
        throw new AppError(error.message, 404);
      }

      if (error.message === 'You are not the winner of this auction') {
        throw new AppError(error.message, 403);
      }

      throw new AppError('Failed to create payment', 500);
    }
  }

  /**
   * Get user payments
   * GET /payments/my-payments
   */
  async getMyPayments(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const payments = await paymentsService.getUserPayments(req.user.userId);

      res.status(200).json({
        success: true,
        data: payments,
      });
    } catch (error: any) {
      logger.error('Get my payments controller error:', error);
      throw new AppError('Failed to get payments', 500);
    }
  }

  /**
   * Get payment by ID
   * GET /payments/:id
   */
  async getPaymentById(req: AuthRequest, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const payment = await paymentsService.getPaymentById(id);

      res.status(200).json({
        success: true,
        data: payment,
      });
    } catch (error: any) {
      logger.error('Get payment by ID controller error:', error);

      if (error.message === 'Payment not found') {
        throw new AppError(error.message, 404);
      }

      throw new AppError('Failed to get payment', 500);
    }
  }
}

export default new PaymentsController();
