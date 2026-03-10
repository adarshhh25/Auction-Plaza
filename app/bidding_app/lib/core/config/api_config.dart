import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;

/// API Configuration
/// 
/// Centralized configuration for all API endpoints and settings.
/// Handles different environments: Android Emulator, Physical Device, Production
class ApiConfig {
  // Environment URLs
  static const String _androidEmulatorUrl = 'http://10.0.2.2:5000'; // Special IP for Android Emulator
  static const String _localhostUrl = 'http://localhost:5000'; // For iOS Simulator
  static const String _localNetworkUrl = 'http://192.168.1.100:5000'; // Replace with your PC's IP for physical devices
  static const String _productionUrl = 'https://api.bidmaster.com'; // Your production server
  
  /// Get Base URL based on platform and environment
  static String get baseUrl {
    if (kDebugMode) {
      // Development mode
      if (Platform.isAndroid) {
        // Android Emulator uses special 10.0.2.2 to access host machine
        print('🌐 API Config: Using Android Emulator URL: $_androidEmulatorUrl');
        return '$_androidEmulatorUrl/api/v1';
      } else if (Platform.isIOS) {
        // iOS Simulator can use localhost
        print('🌐 API Config: Using iOS Simulator URL: $_localhostUrl');
        return '$_localhostUrl/api/v1';
      } else {
        // Web or other platforms
        print('🌐 API Config: Using Localhost URL: $_localhostUrl');
        return '$_localhostUrl/api/v1';
      }
    } else {
      // Production mode
      print('🌐 API Config: Using Production URL: $_productionUrl');
      return '$_productionUrl/api/v1';
    }
  }
  
  /// Get Socket URL based on platform and environment
  static String get socketUrl {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return _androidEmulatorUrl;
      } else if (Platform.isIOS) {
        return _localhostUrl;
      } else {
        return _localhostUrl;
      }
    } else {
      return _productionUrl;
    }
  }
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Endpoints
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Users
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String walletBalance = '/users/wallet/balance';
  static const String addToWallet = '/users/wallet/add';
  
  // Auctions
  static const String auctions = '/auctions';
  static String auctionById(String id) => '/auctions/$id';
  static const String myAuctions = '/auctions/my-auctions';
  static String updateAuctionStatus(String id) => '/auctions/$id/status';
  
  // Bids
  static const String placeBid = '/bids/place';
  static String bidsForAuction(String auctionId) => '/bids/auction/$auctionId';
  static const String myBids = '/bids/my-bids';
  static const String winningBids = '/bids/winning';
  
  // Payments
  static const String createPayment = '/payments/create';
  static const String myPayments = '/payments/my-payments';
  static String paymentById(String id) => '/payments/$id';
  
  // Socket.IO Events
  static const String bidUpdateEvent = 'bidUpdate';
  static const String auctionExtendedEvent = 'auctionExtended';
  static const String auctionClosedEvent = 'auctionClosed';
}
