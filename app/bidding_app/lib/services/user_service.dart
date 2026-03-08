import '../core/config/api_config.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';

/// User Service
/// 
/// Handles user profile and wallet operations.
class UserService {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  /// Get user profile
  Future<ApiResponse<User>> getProfile() async {
    return await _apiClient.get<User>(
      ApiConfig.profile,
      fromJson: (json) => User.fromJson(json['user']),
    );
  }

  /// Update user profile
  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    final response = await _apiClient.patch<User>(
      ApiConfig.updateProfile,
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
      },
      fromJson: (json) => User.fromJson(json['user']),
    );

    // Update stored user data on success
    if (response.success && response.data != null) {
      await _storage.saveUser(response.data!);
    }

    return response;
  }

  /// Get wallet balance
  Future<ApiResponse<WalletBalance>> getWalletBalance() async {
    return await _apiClient.get<WalletBalance>(
      ApiConfig.walletBalance,
      fromJson: (json) => WalletBalance.fromJson(json['wallet']),
    );
  }

  /// Add funds to wallet
  Future<ApiResponse<WalletBalance>> addToWallet(double amount) async {
    return await _apiClient.post<WalletBalance>(
      ApiConfig.addToWallet,
      data: {'amount': amount},
      fromJson: (json) => WalletBalance.fromJson(json['wallet']),
    );
  }
}
