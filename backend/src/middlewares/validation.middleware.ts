import { Request, Response, NextFunction } from 'express';
import Joi, { ObjectSchema } from 'joi';
import logger from '../utils/logger';

/**
 * Validation Middleware Factory
 * Validates request body, query, or params against a Joi schema
 */
export const validate = (schema: ObjectSchema, property: 'body' | 'query' | 'params' = 'body') => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false, // Show all errors, not just the first one
      stripUnknown: true, // Remove unknown keys
    });

    if (error) {
      logger.warn('Validation error:', {
        url: req.url,
        method: req.method,
        errors: error.details,
      });

      res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: error.details.map((detail) => ({
          field: detail.path.join('.'),
          message: detail.message,
        })),
      });
      return;
    }

    // Replace request property with validated value
    req[property] = value;
    next();
  };
};

/**
 * Common Validation Schemas
 */

// MongoDB ObjectId validation
export const objectIdSchema = Joi.string()
  .regex(/^[0-9a-fA-F]{24}$/)
  .message('Invalid ID format');

// Email validation
export const emailSchema = Joi.string()
  .email()
  .lowercase()
  .trim()
  .required();

// Password validation
export const passwordSchema = Joi.string()
  .min(8)
  .max(128)
  .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
  .message('Password must contain at least one uppercase letter, one lowercase letter, and one number')
  .required();

// Pagination schemas
export const paginationSchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(10),
  sort: Joi.string().valid('createdAt', '-createdAt', 'price', '-price'),
});
