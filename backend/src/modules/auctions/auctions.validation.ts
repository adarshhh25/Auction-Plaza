import Joi from 'joi';
import { AuctionStatus } from '../../models/auction.model';

/**
 * Create Auction Validation Schema
 */
export const createAuctionSchema = Joi.object({
  title: Joi.string()
    .min(5)
    .max(200)
    .trim()
    .required()
    .messages({
      'string.min': 'Title must be at least 5 characters',
      'string.max': 'Title cannot exceed 200 characters',
      'any.required': 'Title is required',
    }),

  description: Joi.string()
    .min(10)
    .max(2000)
    .trim()
    .required()
    .messages({
      'string.min': 'Description must be at least 10 characters',
      'string.max': 'Description cannot exceed 2000 characters',
      'any.required': 'Description is required',
    }),

  images: Joi.array()
    .items(Joi.string().uri())
    .min(1)
    .max(10)
    .required()
    .messages({
      'array.min': 'At least 1 image is required',
      'array.max': 'Maximum 10 images allowed',
      'any.required': 'Images are required',
    }),

  startingPrice: Joi.number()
    .min(0.01)
    .required()
    .messages({
      'number.min': 'Starting price must be greater than 0',
      'any.required': 'Starting price is required',
    }),

  minimumIncrement: Joi.number()
    .min(0.01)
    .required()
    .messages({
      'number.min': 'Minimum increment must be greater than 0',
      'any.required': 'Minimum increment is required',
    }),

  startTime: Joi.date()
    .iso()
    .min('now')
    .required()
    .messages({
      'date.min': 'Start time must be in the future',
      'any.required': 'Start time is required',
    }),

  endTime: Joi.date()
    .iso()
    .greater(Joi.ref('startTime'))
    .required()
    .messages({
      'date.greater': 'End time must be after start time',
      'any.required': 'End time is required',
    }),
});

/**
 * Update Auction Status Validation Schema
 */
export const updateAuctionStatusSchema = Joi.object({
  status: Joi.string()
    .valid(...Object.values(AuctionStatus))
    .required()
    .messages({
      'any.only': `Status must be one of: ${Object.values(AuctionStatus).join(', ')}`,
      'any.required': 'Status is required',
    }),
});

/**
 * Auction Query Validation Schema
 */
export const auctionQuerySchema = Joi.object({
  status: Joi.string().valid(...Object.values(AuctionStatus)),
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(10),
  sort: Joi.string().valid('createdAt', '-createdAt', 'endTime', '-endTime', 'currentHighestBid', '-currentHighestBid'),
});
