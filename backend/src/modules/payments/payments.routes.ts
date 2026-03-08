import { Router } from 'express';
import paymentsController from './payments.controller';
import { authenticate } from '../../middlewares/auth.middleware';
import { asyncHandler } from '../../middlewares/error.middleware';

const router = Router();

/**
 * All payment routes require authentication
 */
router.use(authenticate);

/**
 * POST /payments/create
 * Create payment for won auction
 */
router.post(
  '/create',
  asyncHandler(paymentsController.createPayment.bind(paymentsController))
);

/**
 * GET /payments/my-payments
 * Get current user's payments
 */
router.get(
  '/my-payments',
  asyncHandler(paymentsController.getMyPayments.bind(paymentsController))
);

/**
 * GET /payments/:id
 * Get payment by ID
 */
router.get(
  '/:id',
  asyncHandler(paymentsController.getPaymentById.bind(paymentsController))
);

export default router;
