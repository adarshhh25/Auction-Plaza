import User from '../../models/user.model';
import logger from '../../utils/logger';

/**
 * Users Service
 * Handles business logic for user operations
 */
export class UsersService {
  /**
   * Get user profile by ID
   */
  async getProfile(userId: string) {
    try {
      const user = await User.findById(userId).select('-password -refreshToken');

      if (!user) {
        throw new Error('User not found');
      }

      return user;
    } catch (error: any) {
      logger.error('Get profile error:', error);
      throw error;
    }
  }

  /**
   * Update user profile
   */
  async updateProfile(userId: string, updates: { name?: string }) {
    try {
      const user = await User.findByIdAndUpdate(
        userId,
        { $set: updates },
        { new: true, runValidators: true }
      ).select('-password -refreshToken');

      if (!user) {
        throw new Error('User not found');
      }

      logger.info(`User profile updated: ${userId}`);
      return user;
    } catch (error: any) {
      logger.error('Update profile error:', error);
      throw error;
    }
  }

  /**
   * Add funds to wallet
   */
  async addFunds(userId: string, amount: number) {
    try {
      if (amount <= 0) {
        throw new Error('Amount must be greater than 0');
      }

      const user = await User.findByIdAndUpdate(
        userId,
        { $inc: { walletBalance: amount } },
        { new: true }
      ).select('-password -refreshToken');

      if (!user) {
        throw new Error('User not found');
      }

      logger.info(`Funds added to user ${userId}: ${amount}`);
      return user;
    } catch (error: any) {
      logger.error('Add funds error:', error);
      throw error;
    }
  }

  /**
   * Deduct funds from wallet
   */
  async deductFunds(userId: string, amount: number) {
    try {
      if (amount <= 0) {
        throw new Error('Amount must be greater than 0');
      }

      const user = await User.findById(userId);

      if (!user) {
        throw new Error('User not found');
      }

      if (user.walletBalance < amount) {
        throw new Error('Insufficient wallet balance');
      }

      user.walletBalance -= amount;
      await user.save();

      logger.info(`Funds deducted from user ${userId}: ${amount}`);
      return user.toJSON();
    } catch (error: any) {
      logger.error('Deduct funds error:', error);
      throw error;
    }
  }

  /**
   * Get wallet balance
   */
  async getWalletBalance(userId: string) {
    try {
      const user = await User.findById(userId).select('walletBalance');

      if (!user) {
        throw new Error('User not found');
      }

      return { walletBalance: user.walletBalance };
    } catch (error: any) {
      logger.error('Get wallet balance error:', error);
      throw error;
    }
  }
}

export default new UsersService();
