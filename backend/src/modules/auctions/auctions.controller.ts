import { Response } from 'express';
import auctionsService from './auctions.service';
import { CreateAuctionDTO, AuctionQueryParams } from './auctions.types';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { AppError } from '../../middlewares/error.middleware';
import logger from '../../utils/logger';

/**
 * Auctions Controller
 * Handles HTTP requests for auction operations
 */
export class AuctionsController {
  /**
   * Create a new auction
   * POST /auctions
   */
  async createAuction(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const data: CreateAuctionDTO = req.body;
      const auction = await auctionsService.createAuction(req.user.userId, data);

      res.status(201).json({
        success: true,
        message: 'Auction created successfully',
        data: auction,
      });
    } catch (error: any) {
      logger.error('Create auction controller error:', error);
      
      if (error.message === 'Seller not found') {
        throw new AppError(error.message, 404);
      }
      
      throw new AppError('Failed to create auction', 500);
    }
  }

  /**
   * Get all auctions
   * GET /auctions
   */
  async getAllAuctions(req: AuthRequest, res: Response): Promise<void> {
    try {
      const query: AuctionQueryParams = req.query as any;
      const result = await auctionsService.getAllAuctions(query);

      res.status(200).json({
        success: true,
        data: result.auctions,
        pagination: result.pagination,
      });
    } catch (error: any) {
      logger.error('Get all auctions controller error:', error);
      throw new AppError('Failed to get auctions', 500);
    }
  }

  /**
   * Get auction by ID
   * GET /auctions/:id
   */
  async getAuctionById(req: AuthRequest, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const auction = await auctionsService.getAuctionById(id);

      res.status(200).json({
        success: true,
        data: auction,
      });
    } catch (error: any) {
      logger.error('Get auction by ID controller error:', error);
      
      if (error.message === 'Auction not found') {
        throw new AppError(error.message, 404);
      }
      
      throw new AppError('Failed to get auction', 500);
    }
  }

  /**
   * Update auction status
   * PATCH /auctions/:id/status
   */
  async updateAuctionStatus(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const { id } = req.params;
      const { status } = req.body;

      const auction = await auctionsService.updateAuctionStatus(
        id,
        req.user.userId,
        status
      );

      res.status(200).json({
        success: true,
        message: 'Auction status updated successfully',
        data: auction,
      });
    } catch (error: any) {
      logger.error('Update auction status controller error:', error);
      
      if (error.message === 'Auction not found') {
        throw new AppError(error.message, 404);
      }
      
      if (error.message.includes('permission')) {
        throw new AppError(error.message, 403);
      }
      
      if (error.message.includes('Cannot update')) {
        throw new AppError(error.message, 400);
      }
      
      throw new AppError('Failed to update auction status', 500);
    }
  }

  /**
   * Get auctions by seller (current user)
   * GET /auctions/my-auctions
   */
  async getMyAuctions(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const query: AuctionQueryParams = req.query as any;
      const result = await auctionsService.getAuctionsBySeller(req.user.userId, query);

      res.status(200).json({
        success: true,
        data: result.auctions,
        pagination: result.pagination,
      });
    } catch (error: any) {
      logger.error('Get my auctions controller error:', error);
      throw new AppError('Failed to get auctions', 500);
    }
  }
}

export default new AuctionsController();
