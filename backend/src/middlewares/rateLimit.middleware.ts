import rateLimit from 'express-rate-limit';
import { config } from '../config/env';

/**
 * General Rate Limiter
 * Applied to all routes
 */
export const generalLimiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.maxRequests,
  message: {
    success: false,
    message: 'Too many requests from this IP, please try again later',
  },
  standardHeaders: true, // Return rate limit info in `RateLimit-*` headers
  legacyHeaders: false, // Disable `X-RateLimit-*` headers
  // Skip successful requests
  skipSuccessfulRequests: false,
});

/**
 * Authentication Rate Limiter
 * Stricter limits for auth endpoints (login, register)
 */
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 requests per window
  message: {
    success: false,
    message: 'Too many authentication attempts, please try again after 15 minutes',
  },
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: false,
});

/**
 * Bid Rate Limiter
 * Very strict limits for placing bids to prevent spam
 */
export const bidLimiter = rateLimit({
  windowMs: config.rateLimit.bidWindowMs,
  max: config.rateLimit.bidMaxRequests,
  message: {
    success: false,
    message: 'Too many bids in a short time, please slow down',
  },
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: false,
  // Use user ID as key if authenticated
  keyGenerator: (req) => {
    return (req as any).user?.userId || req.ip;
  },
});

/**
 * Auction Creation Rate Limiter
 * Limit auction creation to prevent spam
 */
export const auctionCreationLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10, // 10 auctions per hour
  message: {
    success: false,
    message: 'You have created too many auctions, please try again later',
  },
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: false,
  keyGenerator: (req) => {
    return (req as any).user?.userId || req.ip;
  },
});
