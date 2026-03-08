import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  /// Format amount as currency: "$1,234.56"
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
  
  /// Format amount as compact currency: "$1.2K", "$3.5M"
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${AppConstants.currencySymbol}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${AppConstants.currencySymbol}${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return format(amount);
    }
  }
  
  /// Format amount without symbol: "1,234.56"
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}
