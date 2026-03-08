import '../core/config/api_config.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';

/// Authentication Service
/// 
/// Handles user authentication operations: login, register, logout, refresh token.
class AuthService {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  /// Register new user
  Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final response = await _apiClient.post<AuthResponse>(
      ApiConfig.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        if (phone != null) 'phone': phone,
      },
      fromJson: (json) => AuthResponse.fromJson(json),
    );

    // Save tokens and user data on success
    if (response.success && response.data != null) {
      await _storage.saveTokens(response.data!.tokens);
      await _storage.saveUser(response.data!.user);
    }

    return response;
  }

  /// Login user
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<AuthResponse>(
      ApiConfig.login,
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => AuthResponse.fromJson(json),
    );

    // Save tokens and user data on success
    if (response.success && response.data != null) {
      await _storage.saveTokens(response.data!.tokens);
      await _storage.saveUser(response.data!.user);
    }

    return response;
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout endpoint (optional)
      await _apiClient.post(
        ApiConfig.logout,
        data: {},
        fromJson: (json) => json,
      );
    } catch (e) {
      // Ignore logout errors
    } finally {
      // Clear local storage
      await _storage.clearAll();
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    return await _storage.getUser();
  }

  /// Refresh access token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        ApiConfig.refresh,
        data: {'refreshToken': refreshToken},
        fromJson: (json) => json,
      );

      if (response.success && response.data != null) {
        await _storage.saveAccessToken(response.data['tokens']['accessToken']);
        await _storage.saveRefreshToken(response.data['tokens']['refreshToken']);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
