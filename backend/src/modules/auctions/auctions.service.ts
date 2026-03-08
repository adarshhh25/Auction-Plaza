import Auction, { IAuction, AuctionStatus } from '../../models/auction.model';
import User from '../../models/user.model';
import { CreateAuctionDTO, AuctionQueryParams } from './auctions.types';
import logger from '../../utils/logger';

/**
 * Auctions Service
 * Handles business logic for auction operations
 */
export class AuctionsService {
  /**
   * Create a new auction
   */
  async createAuction(sellerId: string, data: CreateAuctionDTO): Promise<IAuction> {
    try {
      // Verify seller exists and has Seller role
      const seller = await User.findById(sellerId);
      if (!seller) {
        throw new Error('Seller not found');
      }

      // Create auction
      const auction = await Auction.create({
        ...data,
        seller: sellerId,
        currentHighestBid: data.startingPrice,
      });

      // Determine initial status based on start time
      const now = new Date();
      if (new Date(data.startTime) <= now && new Date(data.endTime) > now) {
        auction.status = AuctionStatus.ACTIVE;
      }

      await auction.save();

      logger.info(`Auction created: ${auction._id} by seller ${sellerId}`);
      return auction;
    } catch (error: any) {
      logger.error('Create auction error:', error);
      throw error;
    }
  }

  /**
   * Get all auctions with filters and pagination
   */
  async getAllAuctions(query: AuctionQueryParams) {
    try {
      const { status, page = 1, limit = 10, sort = '-createdAt' } = query;

      const filter: any = {};
      if (status) {
        filter.status = status;
      }

      const skip = (page - 1) * limit;

      const [auctions, total] = await Promise.all([
        Auction.find(filter)
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .populate('seller', 'name email')
          .populate('winner', 'name email'),
        Auction.countDocuments(filter),
      ]);

      return {
        auctions,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      };
    } catch (error: any) {
      logger.error('Get all auctions error:', error);
      throw error;
    }
  }

  /**
   * Get auction by ID
   */
  async getAuctionById(auctionId: string): Promise<IAuction> {
    try {
      // Get from database
      const auction = await Auction.findById(auctionId)
        .populate('seller', 'name email')
        .populate('winner', 'name email');

      if (!auction) {
        throw new Error('Auction not found');
      }

      return auction;
    } catch (error: any) {
      logger.error('Get auction by ID error:', error);
      throw error;
    }
  }

  /**
   * Update auction status
   */
  async updateAuctionStatus(
    auctionId: string,
    sellerId: string,
    newStatus: AuctionStatus
  ): Promise<IAuction> {
    try {
      const auction = await Auction.findById(auctionId);

      if (!auction) {
        throw new Error('Auction not found');
      }

      // Verify seller owns the auction
      if (auction.seller.toString() !== sellerId) {
        throw new Error('You do not have permission to update this auction');
      }

      // Validate status transitions
      if (auction.status === AuctionStatus.ENDED) {
        throw new Error('Cannot update status of ended auction');
      }

      if (auction.status === AuctionStatus.CANCELLED) {
        throw new Error('Cannot update status of cancelled auction');
      }

      // Update status
      auction.status = newStatus;
      await auction.save();

      logger.info(`Auction ${auctionId} status updated to ${newStatus}`);
      return auction;
    } catch (error: any) {
      logger.error('Update auction status error:', error);
      throw error;
    }
  }

  /**
   * Get auctions by seller
   */
  async getAuctionsBySeller(sellerId: string, query: AuctionQueryParams) {
    try {
      const { status, page = 1, limit = 10, sort = '-createdAt' } = query;

      const filter: any = { seller: sellerId };
      if (status) {
        filter.status = status;
      }

      const skip = (page - 1) * limit;

      const [auctions, total] = await Promise.all([
        Auction.find(filter)
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .populate('winner', 'name email'),
        Auction.countDocuments(filter),
      ]);

      return {
        auctions,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      };
    } catch (error: any) {
      logger.error('Get auctions by seller error:', error);
      throw error;
    }
  }

  /**
   * Extend auction end time (anti-snipe mechanism)
   */
  async extendAuctionEndTime(auctionId: string, extensionSeconds: number): Promise<IAuction> {
    try {
      const auction = await Auction.findById(auctionId);

      if (!auction) {
        throw new Error('Auction not found');
      }

      // Extend end time
      auction.endTime = new Date(auction.endTime.getTime() + extensionSeconds * 1000);
      await auction.save();

      logger.info(`Auction ${auctionId} extended by ${extensionSeconds} seconds`);
      return auction;
    } catch (error: any) {
      logger.error('Extend auction error:', error);
      throw error;
    }
  }
}

export default new AuctionsService();
