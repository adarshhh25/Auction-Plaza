import { Router } from 'express';
import auctionsController from './auctions.controller';
import { authenticate, optionalAuthenticate } from '../../middlewares/auth.middleware';
import { authorizeRoles } from '../../middlewares/role.middleware';
import { UserRole } from '../../models/user.model';
import { validate } from '../../middlewares/validation.middleware';
import { createAuctionSchema, updateAuctionStatusSchema, auctionQuerySchema } from './auctions.validation';
import { auctionCreationLimiter } from '../../middlewares/rateLimit.middleware';
import { asyncHandler } from '../../middlewares/error.middleware';

const router = Router();

/**
 * POST /auctions
 * Create a new auction (Seller only)
 */
router.post(
  '/',
  authenticate,
  authorizeRoles(UserRole.SELLER, UserRole.ADMIN),
  auctionCreationLimiter,
  validate(createAuctionSchema),
  asyncHandler(auctionsController.createAuction.bind(auctionsController))
);

/**
 * GET /auctions/my-auctions
 * Get current user's auctions (Seller only)
 * Note: This route must be before /:id to avoid conflicts
 */
router.get(
  '/my-auctions',
  authenticate,
  authorizeRoles(UserRole.SELLER, UserRole.ADMIN),
  validate(auctionQuerySchema, 'query'),
  asyncHandler(auctionsController.getMyAuctions.bind(auctionsController))
);

/**
 * GET /auctions
 * Get all auctions (public, but optional auth for personalization)
 */
router.get(
  '/',
  optionalAuthenticate,
  validate(auctionQuerySchema, 'query'),
  asyncHandler(auctionsController.getAllAuctions.bind(auctionsController))
);

/**
 * GET /auctions/:id
 * Get auction by ID (public, but optional auth)
 */
router.get(
  '/:id',
  optionalAuthenticate,
  asyncHandler(auctionsController.getAuctionById.bind(auctionsController))
);

/**
 * PATCH /auctions/:id/status
 * Update auction status (Seller only - owner of auction)
 */
router.patch(
  '/:id/status',
  authenticate,
  authorizeRoles(UserRole.SELLER, UserRole.ADMIN),
  validate(updateAuctionStatusSchema),
  asyncHandler(auctionsController.updateAuctionStatus.bind(auctionsController))
);

export default router;
