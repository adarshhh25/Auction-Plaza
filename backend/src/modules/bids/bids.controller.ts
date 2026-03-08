import { Response } from 'express';
import bidsService from './bids.service';
import { PlaceBidDTO } from './bids.types';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { AppError } from '../../middlewares/error.middleware';
import logger from '../../utils/logger';

/**
 * Bids Controller
 * Handles HTTP requests for bidding operations
 */
export class BidsController {
  /**
   * Place a bid
   * POST /bids/place
   */
  async placeBid(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const data: PlaceBidDTO = req.body;
      const result = await bidsService.placeBid(req.user.userId, data);

      res.status(201).json({
        success: true,
        message: result.auctionExtended
          ? 'Bid placed successfully. Auction extended due to anti-snipe rule.'
          : 'Bid placed successfully',
        data: result,
      });
    } catch (error: any) {
      logger.error('Place bid controller error:', error);

      // Handle specific error messages
      const errorMessage = error.message;

      if (errorMessage === 'Auction not found') {
        throw new AppError(errorMessage, 404);
      }

      if (
        errorMessage.includes('not active') ||
        errorMessage.includes('not started') ||
        errorMessage.includes('has ended')
      ) {
        throw new AppError(errorMessage, 400);
      }

      if (
        errorMessage.includes('Sellers cannot bid') ||
        errorMessage.includes('Bid must be at least') ||
        errorMessage.includes('Insufficient wallet balance')
      ) {
        throw new AppError(errorMessage, 400);
      }

      if (errorMessage.includes('Failed to acquire lock')) {
        throw new AppError(
          'Too many concurrent bids on this auction. Please try again.',
          429
        );
      }

      throw new AppError('Failed to place bid', 500);
    }
  }

  /**
   * Get bids for an auction
   * GET /bids/auction/:auctionId
   */
  async getAuctionBids(req: AuthRequest, res: Response): Promise<void> {
    try {
      const { auctionId } = req.params;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await bidsService.getAuctionBids(auctionId, page, limit);

      res.status(200).json({
        success: true,
        data: result.bids,
        pagination: result.pagination,
      });
    } catch (error: any) {
      logger.error('Get auction bids controller error:', error);
      throw new AppError('Failed to get auction bids', 500);
    }
  }

  /**
   * Get bids by current user
   * GET /bids/my-bids
   */
  async getMyBids(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await bidsService.getBidsByBidder(req.user.userId, page, limit);

      res.status(200).json({
        success: true,
        data: result.bids,
        pagination: result.pagination,
      });
    } catch (error: any) {
      logger.error('Get my bids controller error:', error);
      throw new AppError('Failed to get bids', 500);
    }
  }

  /**
   * Get winning bids by current user
   * GET /bids/winning
   */
  async getWinningBids(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const bids = await bidsService.getWinningBids(req.user.userId);

      res.status(200).json({
        success: true,
        data: bids,
      });
    } catch (error: any) {
      logger.error('Get winning bids controller error:', error);
      throw new AppError('Failed to get winning bids', 500);
    }
  }
}

export default new BidsController();
