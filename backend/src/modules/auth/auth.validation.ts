import Joi from 'joi';
import { UserRole } from '../../models/user.model';
import { emailSchema, passwordSchema } from '../../middlewares/validation.middleware';

/**
 * Register Validation Schema
 */
export const registerSchema = Joi.object({
  name: Joi.string()
    .min(2)
    .max(100)
    .trim()
    .required()
    .messages({
      'string.min': 'Name must be at least 2 characters',
      'string.max': 'Name cannot exceed 100 characters',
      'any.required': 'Name is required',
    }),

  email: emailSchema,

  password: passwordSchema,

  role: Joi.string()
    .valid(...Object.values(UserRole))
    .default(UserRole.BUYER)
    .messages({
      'any.only': `Role must be one of: ${Object.values(UserRole).join(', ')}`,
    }),
});

/**
 * Login Validation Schema
 */
export const loginSchema = Joi.object({
  email: emailSchema,

  password: Joi.string()
    .required()
    .messages({
      'any.required': 'Password is required',
    }),
});

/**
 * Refresh Token Validation Schema
 */
export const refreshTokenSchema = Joi.object({
  refreshToken: Joi.string()
    .required()
    .messages({
      'any.required': 'Refresh token is required',
    }),
});
