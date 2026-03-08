import User from '../../models/user.model';
import { generateTokenPair, verifyRefreshToken, JWTPayload } from '../../config/jwt';
import { RegisterDTO, LoginDTO, AuthResponseDTO } from './auth.types';
import logger from '../../utils/logger';

/**
 * Authentication Service
 * Handles business logic for authentication
 */
export class AuthService {
  /**
   * Register a new user
   */
  async register(data: RegisterDTO): Promise<AuthResponseDTO> {
    try {
      // Check if user already exists
      const existingUser = await User.findOne({ email: data.email });
      if (existingUser) {
        throw new Error('User with this email already exists');
      }

      // Create new user (password will be hashed by pre-save hook)
      const user = await User.create({
        name: data.name,
        email: data.email,
        password: data.password,
        role: data.role,
      });

      // Generate tokens
      const payload: JWTPayload = {
        userId: user._id.toString(),
        email: user.email,
        role: user.role,
      };

      const { accessToken, refreshToken } = generateTokenPair(payload);

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      logger.info(`User registered successfully: ${user.email}`);

      return {
        user: {
          id: user._id.toString(),
          name: user.name,
          email: user.email,
          role: user.role,
          walletBalance: user.walletBalance,
          isVerified: user.isVerified,
        },
        accessToken,
        refreshToken,
      };
    } catch (error: any) {
      logger.error('Registration error:', error);
      throw error;
    }
  }

  /**
   * Login user
   */
  async login(data: LoginDTO): Promise<AuthResponseDTO> {
    try {
      // Find user and include password field
      const user = await User.findOne({ email: data.email }).select('+password');

      if (!user) {
        throw new Error('Invalid email or password');
      }

      // Verify password
      const isPasswordValid = await user.comparePassword(data.password);
      if (!isPasswordValid) {
        throw new Error('Invalid email or password');
      }

      // Generate tokens
      const payload: JWTPayload = {
        userId: user._id.toString(),
        email: user.email,
        role: user.role,
      };

      const { accessToken, refreshToken } = generateTokenPair(payload);

      // Save refresh token to user
      user.refreshToken = refreshToken;
      await user.save();

      logger.info(`User logged in: ${user.email}`);

      return {
        user: {
          id: user._id.toString(),
          name: user.name,
          email: user.email,
          role: user.role,
          walletBalance: user.walletBalance,
          isVerified: user.isVerified,
        },
        accessToken,
        refreshToken,
      };
    } catch (error: any) {
      logger.error('Login error:', error);
      throw error;
    }
  }

  /**
   * Refresh access token
   */
  async refreshAccessToken(refreshToken: string): Promise<{ accessToken: string }> {
    try {
      // Verify refresh token
      const decoded = verifyRefreshToken(refreshToken);

      // Find user and verify refresh token matches
      const user = await User.findById(decoded.userId).select('+refreshToken');

      if (!user || user.refreshToken !== refreshToken) {
        throw new Error('Invalid refresh token');
      }

      // Generate new access token
      const payload: JWTPayload = {
        userId: user._id.toString(),
        email: user.email,
        role: user.role,
      };

      const { accessToken } = generateTokenPair(payload);

      logger.debug(`Access token refreshed for user: ${user.email}`);

      return { accessToken };
    } catch (error: any) {
      logger.error('Token refresh error:', error);
      throw error;
    }
  }

  /**
   * Logout user (invalidate refresh token)
   */
  async logout(userId: string): Promise<void> {
    try {
      await User.findByIdAndUpdate(userId, { refreshToken: null });
      logger.info(`User logged out: ${userId}`);
    } catch (error: any) {
      logger.error('Logout error:', error);
      throw error;
    }
  }
}

export default new AuthService();
