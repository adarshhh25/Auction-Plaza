import cron from 'node-cron';
import Auction, { AuctionStatus } from '../models/auction.model';
import Bid from '../models/bid.model';
import logger from '../utils/logger';
import { config } from '../config/env';

/**
 * Auction Job
 * Scheduled task to check and close expired auctions
 */
export class AuctionJob {
  private task: cron.ScheduledTask | null = null;

  /**
   * Start the scheduled job
   * Runs every N seconds (configurable via environment)
   */
  start() {
    // Calculate cron expression based on config
    const intervalSeconds = config.auction.checkIntervalSeconds;
    const cronExpression = `*/${intervalSeconds} * * * * *`; // Every N seconds

    this.task = cron.schedule(cronExpression, async () => {
      await this.processExpiredAuctions();
    });

    logger.info(
      `✅ Auction job started (checking every ${intervalSeconds} seconds)`
    );
  }

  /**
   * Stop the scheduled job
   */
  stop() {
    if (this.task) {
      this.task.stop();
      logger.info('Auction job stopped');
    }
  }

  /**
   * Process expired auctions
   * Finds auctions that have ended and updates their status
   */
  async processExpiredAuctions() {
    try {
      const now = new Date();

      // Find all active auctions that have expired
      const expiredAuctions = await Auction.find({
        status: AuctionStatus.ACTIVE,
        endTime: { $lte: now },
      });

      if (expiredAuctions.length === 0) {
        logger.debug('No expired auctions found');
        return;
      }

      logger.info(`Processing ${expiredAuctions.length} expired auctions`);

      // Process each expired auction
      for (const auction of expiredAuctions) {
        await this.closeAuction(auction._id.toString());
      }
    } catch (error) {
      logger.error('Error processing expired auctions:', error);
    }
  }

  /**
   * Close a specific auction
   * Sets status to Ended and assigns winner
   */
  async closeAuction(auctionId: string) {
    try {
      const auction = await Auction.findById(auctionId);

      if (!auction) {
        logger.warn(`Auction not found: ${auctionId}`);
        return;
      }

      // Find the winning bid
      const winningBid = await Bid.findOne({
        auction: auctionId,
        isWinningBid: true,
      }).populate('bidder', 'name email');

      // Update auction status
      auction.status = AuctionStatus.ENDED;

      if (winningBid) {
        auction.winner = winningBid.bidder._id;
      }

      await auction.save();

      // Broadcast auction ended event via Socket.IO
      const io = (global as any).io;
      if (io) {
        const roomName = `auction_${auctionId}`;
        io.of('/bidding').to(roomName).emit('auctionClosed', {
          auctionId,
          winner: winningBid
            ? {
                id: winningBid.bidder._id,
                name: (winningBid.bidder as any).name,
                email: (winningBid.bidder as any).email,
              }
            : null,
          finalBid: winningBid ? winningBid.amount : null,
          message: 'Auction has ended',
        });
      }

      logger.info(
        `Auction closed: ${auctionId}, Winner: ${winningBid ? winningBid.bidder._id : 'None'}`
      );
    } catch (error) {
      logger.error(`Error closing auction ${auctionId}:`, error);
    }
  }

  /**
   * Manually trigger auction processing (for testing)
   */
  async triggerProcessing() {
    await this.processExpiredAuctions();
  }
}

// Export singleton instance
export default new AuctionJob();
