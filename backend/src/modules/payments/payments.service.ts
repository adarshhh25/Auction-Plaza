import Payment, { PaymentStatus } from '../../models/payment.model';
import User from '../../models/user.model';
import Auction from '../../models/auction.model';
import logger from '../../utils/logger';
import { v4 as uuidv4 } from 'uuid';

/**
 * Payments Service
 * Handles business logic for payment operations
 * Note: This is a simplified implementation. In production, integrate with Stripe, PayPal, etc.
 */
export class PaymentsService {
  /**
   * Create a payment for won auction
   */
  async createPayment(userId: string, auctionId: string) {
    try {
      // Verify auction and user
      const [auction, user] = await Promise.all([
        Auction.findById(auctionId),
        User.findById(userId),
      ]);

      if (!auction) {
        throw new Error('Auction not found');
      }

      if (!user) {
        throw new Error('User not found');
      }

      // Verify user is the winner
      if (!auction.winner || auction.winner.toString() !== userId) {
        throw new Error('You are not the winner of this auction');
      }

      // Check if payment already exists
      const existingPayment = await Payment.findOne({
        user: userId,
        auction: auctionId,
      });

      if (existingPayment) {
        return existingPayment;
      }

      // Create payment
      const payment = await Payment.create({
        user: userId,
        auction: auctionId,
        amount: auction.currentHighestBid,
        transactionId: `TXN-${uuidv4()}`,
        status: PaymentStatus.PENDING,
      });

      logger.info(`Payment created: ${payment._id} for auction ${auctionId}`);
      return payment;
    } catch (error: any) {
      logger.error('Create payment error:', error);
      throw error;
    }
  }

  /**
   * Get payment by ID
   */
  async getPaymentById(paymentId: string) {
    try {
      const payment = await Payment.findById(paymentId)
        .populate('user', 'name email')
        .populate('auction', 'title currentHighestBid');

      if (!payment) {
        throw new Error('Payment not found');
      }

      return payment;
    } catch (error: any) {
      logger.error('Get payment error:', error);
      throw error;
    }
  }

  /**
   * Get user payments
   */
  async getUserPayments(userId: string) {
    try {
      const payments = await Payment.find({ user: userId })
        .sort({ createdAt: -1 })
        .populate('auction', 'title currentHighestBid status');

      return payments;
    } catch (error: any) {
      logger.error('Get user payments error:', error);
      throw error;
    }
  }
}

export default new PaymentsService();
