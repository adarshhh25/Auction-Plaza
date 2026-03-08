import { Router } from 'express';
import usersController from './users.controller';
import { authenticate } from '../../middlewares/auth.middleware';
import { asyncHandler } from '../../middlewares/error.middleware';

const router = Router();

/**
 * All user routes require authentication
 */
router.use(authenticate);

/**
 * GET /users/profile
 * Get current user profile
 */
router.get(
  '/profile',
  asyncHandler(usersController.getProfile.bind(usersController))
);

/**
 * PATCH /users/profile
 * Update current user profile
 */
router.patch(
  '/updateprofile',
  asyncHandler(usersController.updateProfile.bind(usersController))
);

/**
 * GET /users/wallet/balance
 * Get wallet balance
 */
router.get(
  '/wallet/balance',
  asyncHandler(usersController.getWalletBalance.bind(usersController))
);

/**
 * POST /users/wallet/add
 * Add funds to wallet
 */
router.post(
  '/wallet/add',
  asyncHandler(usersController.addFunds.bind(usersController))
);

export default router;
