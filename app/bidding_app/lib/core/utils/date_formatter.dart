import 'package:intl/intl.dart';

/// Date and Time formatting utilities
class DateFormatter {
  /// Format date as "Jan 15, 2024"
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Format time as "02:30 PM"
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  /// Format datetime as "Jan 15, 2024 02:30 PM"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }
  
  /// Format as relative time: "2 hours ago", "3 days ago"
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }
  
  /// Calculate remaining time for auction
  static String formatRemainingTime(DateTime endTime) {
    final now = DateTime.now();
    final difference = endTime.difference(now);
    
    if (difference.isNegative) {
      return 'Ended';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return 'Ending soon';
    }
  }
  
  /// Get countdown string: "2d 5h 30m"
  static String getCountdown(DateTime endTime) {
    final now = DateTime.now();
    final difference = endTime.difference(now);
    
    if (difference.isNegative) {
      return 'Ended';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
