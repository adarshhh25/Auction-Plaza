import Bid from '../../models/bid.model';
import Auction, { AuctionStatus } from '../../models/auction.model';
import User from '../../models/user.model';
import { PlaceBidDTO } from './bids.types';
import { withLock } from '../../utils/lock';
import auctionsService from '../auctions/auctions.service';
import { config } from '../../config/env';
import logger from '../../utils/logger';

/**
 * Bids Service
 * Handles business logic for bidding operations
 */
export class BidsService {
  /**
   * Place a bid with atomic operations and distributed locking
   * This is the CRITICAL business logic for the bidding system
   */
  async placeBid(bidderId: string, data: PlaceBidDTO) {
    const { auctionId, amount } = data;

    // Use distributed lock to ensure atomic bid placement
    return await withLock(
      `auction:${auctionId}`,
      async () => {
        // 1. Get auction and validate
        const auction = await Auction.findById(auctionId);
        if (!auction) {
          throw new Error('Auction not found');
        }

        // 2. Validate auction status
        if (auction.status !== AuctionStatus.ACTIVE) {
          throw new Error('Auction is not active');
        }

        // 3. Validate auction time window
        const now = new Date();
        if (now < auction.startTime) {
          throw new Error('Auction has not started yet');
        }

        if (now > auction.endTime) {
          throw new Error('Auction has ended');
        }

        // 4. Validate bidder is not the seller
        if (auction.seller.toString() === bidderId) {
          throw new Error('Sellers cannot bid on their own auctions');
        }

        // 5. Validate bid amount is greater than current highest bid + minimum increment
        const minimumBid = auction.currentHighestBid + auction.minimumIncrement;
        if (amount < minimumBid) {
          throw new Error(
            `Bid must be at least ${minimumBid.toFixed(2)} (current highest: ${auction.currentHighestBid.toFixed(2)} + minimum increment: ${auction.minimumIncrement.toFixed(2)})`
          );
        }

        // 6. Validate bidder has sufficient wallet balance
        const bidder = await User.findById(bidderId);
        if (!bidder) {
          throw new Error('Bidder not found');
        }

        if (bidder.walletBalance < amount) {
          throw new Error(
            `Insufficient wallet balance. Required: ${amount.toFixed(2)}, Available: ${bidder.walletBalance.toFixed(2)}`
          );
        }

        // 7. Mark previous winning bid as false (if exists)
        await Bid.updateMany(
          { auction: auctionId, isWinningBid: true },
          { isWinningBid: false }
        );

        // 8. Create new bid
        const bid = await Bid.create({
          auction: auctionId,
          bidder: bidderId,
          amount,
          isWinningBid: true,
        });

        // 9. Update auction's current highest bid
        auction.currentHighestBid = amount;
        await auction.save();

        // 10. Check for anti-snipe rule (bid placed within last 60 seconds)
        const timeUntilEnd = auction.endTime.getTime() - now.getTime();
        const antiSnipeThreshold = config.auction.antiSnipeSeconds * 1000; // Convert to ms
        let auctionExtended = false;

        if (timeUntilEnd <= antiSnipeThreshold) {
          // Extend auction by configured seconds
          const extensionMs = config.auction.antiSnipeExtensionSeconds * 1000;
          await auctionsService.extendAuctionEndTime(
            auctionId,
            config.auction.antiSnipeExtensionSeconds
          );
          auctionExtended = true;

          logger.info(
            `Anti-snipe activated: Auction ${auctionId} extended by ${config.auction.antiSnipeExtensionSeconds} seconds`
          );

          // Broadcast auction extended event via Socket.IO
          const io = (global as any).io;
          if (io) {
            const roomName = `auction_${auctionId}`;
            io.of('/bidding').to(roomName).emit('auctionExtended', {
              auctionId,
              newEndTime: new Date(auction.endTime.getTime() + extensionMs),
              extensionSeconds: config.auction.antiSnipeExtensionSeconds,
              message: `Auction extended by ${config.auction.antiSnipeExtensionSeconds} seconds due to last-minute bid`,
            });
          }
        }

        // 11. Broadcast bid event via Socket.IO for real-time updates
        const io = (global as any).io;
        if (io) {
          const roomName = `auction_${auctionId}`;
          io.of('/bidding').to(roomName).emit('bidUpdate', {
            auctionId,
            bid: {
              id: bid._id,
              amount: bid.amount,
              bidder: {
                id: bidder._id,
                name: bidder.name,
              },
              createdAt: bid.createdAt,
            },
            auctionExtended,
          });
        }

        logger.info(
          `Bid placed: Auction ${auctionId}, Amount ${amount}, Bidder ${bidderId}`
        );

        // Return populated bid data
        const populatedBid = await Bid.findById(bid._id).populate('bidder', 'name email');

        return {
          bid: populatedBid,
          auction,
          auctionExtended,
        };
      },
      {
        ttl: 30, // Lock for 30 seconds max
        retries: 5, // Retry up to 5 times
        retryDelay: 200, // Wait 200ms between retries
      }
    );
  }

  /**
   * Get bids for an auction
   */
  async getAuctionBids(auctionId: string, page: number = 1, limit: number = 20) {
    try {
      const skip = (page - 1) * limit;

      const [bids, total] = await Promise.all([
        Bid.find({ auction: auctionId })
          .sort({ createdAt: -1 })
          .skip(skip)
          .limit(limit)
          .populate('bidder', 'name email'),
        Bid.countDocuments({ auction: auctionId }),
      ]);

      return {
        bids,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      };
    } catch (error: any) {
      logger.error('Get auction bids error:', error);
      throw error;
    }
  }

  /**
   * Get bids by bidder
   */
  async getBidsByBidder(bidderId: string, page: number = 1, limit: number = 20) {
    try {
      const skip = (page - 1) * limit;

      const [bids, total] = await Promise.all([
        Bid.find({ bidder: bidderId })
          .sort({ createdAt: -1 })
          .skip(skip)
          .limit(limit)
          .populate('auction', 'title currentHighestBid status endTime'),
        Bid.countDocuments({ bidder: bidderId }),
      ]);

      return {
        bids,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      };
    } catch (error: any) {
      logger.error('Get bids by bidder error:', error);
      throw error;
    }
  }

  /**
   * Get winning bids for a user
   */
  async getWinningBids(bidderId: string) {
    try {
      const winningBids = await Bid.find({
        bidder: bidderId,
        isWinningBid: true,
      })
        .sort({ createdAt: -1 })
        .populate('auction', 'title currentHighestBid status endTime');

      return winningBids;
    } catch (error: any) {
      logger.error('Get winning bids error:', error);
      throw error;
    }
  }
}

export default new BidsService();
