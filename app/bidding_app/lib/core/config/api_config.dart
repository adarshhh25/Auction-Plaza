/// API Configuration
/// 
/// Centralized configuration for all API endpoints and settings.
class ApiConfig {
  // Base URL for all API calls
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  // Socket.IO URL
  static const String socketUrl = 'http://localhost:5000';
  
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
