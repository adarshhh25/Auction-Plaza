/// Application-wide constants
class AppConstants {
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  
  // App Info
  static const String appName = 'BidMaster';
  static const String appVersion = '1.0.0';
  
  // Auction Status
  static const String auctionStatusActive = 'active';
  static const String auctionStatusCompleted = 'completed';
  static const String auctionStatusCancelled = 'cancelled';
  static const String auctionStatusPending = 'pending';
  
  // User Roles
  static const String roleAdmin = 'Admin';
  static const String roleSeller = 'Seller';
  static const String roleBuyer = 'Buyer';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Image Placeholders
  static const String placeholderImage = 'https://via.placeholder.com/400x300?text=No+Image';
  
  // Currency
  static const String currencySymbol = '\$';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
}
