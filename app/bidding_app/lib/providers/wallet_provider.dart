import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

/// Wallet State
class WalletState {
  final WalletBalance? balance;
  final bool isLoading;
  final String? error;

  WalletState({
    this.balance,
    this.isLoading = false,
    this.error,
  });

  WalletState copyWith({
    WalletBalance? balance,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Wallet Notifier
class WalletNotifier extends StateNotifier<WalletState> {
  final UserService _userService = UserService();

  WalletNotifier() : super(WalletState()) {
    loadBalance();
  }

  /// Load wallet balance
  Future<void> loadBalance() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _userService.getWalletBalance();

    if (response.success && response.data != null) {
      state = state.copyWith(
        balance: response.data,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        error: response.error?.message ?? 'Failed to load balance',
        isLoading: false,
      );
    }
  }

  /// Add funds to wallet
  Future<bool> addFunds(double amount) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _userService.addToWallet(amount);

    if (response.success && response.data != null) {
      state = state.copyWith(
        balance: response.data,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        error: response.error?.message ?? 'Failed to add funds',
        isLoading: false,
      );
      return false;
    }
  }

  /// Refresh balance
  Future<void> refresh() async {
    await loadBalance();
  }
}

/// Wallet Provider
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});

/// Convenience provider for balance
final walletBalanceProvider = Provider<double>((ref) {
  return ref.watch(walletProvider).balance?.balance ?? 0.0;
});
