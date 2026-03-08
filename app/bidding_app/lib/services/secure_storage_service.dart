import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

/// Secure Storage Service
/// 
/// Handles secure storage of sensitive data like JWT tokens and user data.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Singleton pattern
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  /// Save user data
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: AppConstants.userDataKey, value: userJson);
  }

  /// Get user data
  Future<User?> getUser() async {
    final userJson = await _storage.read(key: AppConstants.userDataKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Save tokens from AuthResponse
  Future<void> saveTokens(Tokens tokens) async {
    await saveAccessToken(tokens.accessToken);
    await saveRefreshToken(tokens.refreshToken);
  }
}
