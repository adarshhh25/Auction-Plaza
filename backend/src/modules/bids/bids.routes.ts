import { Router } from 'express';
import bidsController from './bids.controller';
import { authenticate } from '../../middlewares/auth.middleware';
import { authorizeRoles } from '../../middlewares/role.middleware';
import { UserRole } from '../../models/user.model';
import { validate } from '../../middlewares/validation.middleware';
import { placeBidSchema } from './bids.validation';
import { bidLimiter } from '../../middlewares/rateLimit.middleware';
import { asyncHandler } from '../../middlewares/error.middleware';

const router = Router();

/**
 * POST /bids/place
 * Place a bid (Buyer only, with strict rate limiting)
 */
router.post(
  '/place',
  authenticate,
  authorizeRoles(UserRole.BUYER, UserRole.ADMIN),
  bidLimiter,
  validate(placeBidSchema),
  asyncHandler(bidsController.placeBid.bind(bidsController))
);

/**
 * GET /bids/my-bids
 * Get current user's bids (Buyer only)
 * Note: This route must be before /auction/:auctionId to avoid conflicts
 */
router.get(
  '/my-bids',
  authenticate,
  authorizeRoles(UserRole.BUYER, UserRole.ADMIN),
  asyncHandler(bidsController.getMyBids.bind(bidsController))
);

/**
 * GET /bids/winning
 * Get current user's winning bids (Buyer only)
 */
router.get(
  '/winning',
  authenticate,
  authorizeRoles(UserRole.BUYER, UserRole.ADMIN),
  asyncHandler(bidsController.getWinningBids.bind(bidsController))
);

/**
 * GET /bids/auction/:auctionId
 * Get bids for a specific auction (authenticated users)
 */
router.get(
  '/auction/:auctionId',
  authenticate,
  asyncHandler(bidsController.getAuctionBids.bind(bidsController))
);

export default router;
