import { Request, Response } from 'express';
import authService from './auth.service';
import { RegisterDTO, LoginDTO } from './auth.types';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { AppError } from '../../middlewares/error.middleware';
import logger from '../../utils/logger';

/**
 * Authentication Controller
 * Handles HTTP requests for authentication
 */
export class AuthController {
  /**
   * Register a new user
   * POST /auth/register
   */
  async register(req: Request, res: Response): Promise<void> {
    try {
      const data: RegisterDTO = req.body;

      const result = await authService.register(data);

      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: result,
      });
    } catch (error: any) {
      logger.error('Register controller error:', error);
      
      if (error.message === 'User with this email already exists') {
        throw new AppError(error.message, 400);
      }
      
      throw new AppError('Registration failed', 500);
    }
  }

  /**
   * Login user
   * POST /auth/login
   */
  async login(req: Request, res: Response): Promise<void> {
    try {
      const data: LoginDTO = req.body;

      const result = await authService.login(data);

      // Set refresh token in HTTP-only cookie
      res.cookie('refreshToken', result.refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
      });

      res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user: result.user,
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        },
      });
    } catch (error: any) {
      logger.error('Login controller error:', error);
      
      if (error.message === 'Invalid email or password') {
        throw new AppError(error.message, 401);
      }
      
      throw new AppError('Login failed', 500);
    }
  }

  /**
   * Refresh access token
   * POST /auth/refresh
   */
  async refresh(req: Request, res: Response): Promise<void> {
    try {
      // Get refresh token from body or cookie
      const refreshToken = req.body.refreshToken || req.cookies.refreshToken;

      if (!refreshToken) {
        throw new AppError('Refresh token is required', 400);
      }

      const result = await authService.refreshAccessToken(refreshToken);

      res.status(200).json({
        success: true,
        message: 'Access token refreshed successfully',
        data: result,
      });
    } catch (error: any) {
      logger.error('Refresh controller error:', error);
      
      if (error.message === 'Invalid refresh token' || error.message.includes('expired')) {
        throw new AppError(error.message, 401);
      }
      
      throw new AppError('Token refresh failed', 500);
    }
  }

  /**
   * Logout user
   * POST /auth/logout
   */
  async logout(req: AuthRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      await authService.logout(req.user.userId);

      // Clear refresh token cookie
      res.clearCookie('refreshToken');

      res.status(200).json({
        success: true,
        message: 'Logout successful',
      });
    } catch (error: any) {
      logger.error('Logout controller error:', error);
      throw new AppError('Logout failed', 500);
    }
  }
}

export default new AuthController();
