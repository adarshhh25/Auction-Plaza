import Joi from 'joi';
import { objectIdSchema } from '../../middlewares/validation.middleware';

/**
 * Place Bid Validation Schema
 */
export const placeBidSchema = Joi.object({
  auctionId: objectIdSchema.required().messages({
    'any.required': 'Auction ID is required',
  }),

  amount: Joi.number()
    .min(0.01)
    .required()
    .messages({
      'number.min': 'Bid amount must be greater than 0',
      'any.required': 'Bid amount is required',
    }),
});
