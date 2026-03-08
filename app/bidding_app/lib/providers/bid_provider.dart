import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bid_model.dart';
import '../services/bid_service.dart';

/// Bid State for placing bids
class BidState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  BidState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  BidState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return BidState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Bid Notifier
class BidNotifier extends StateNotifier<BidState> {
  final BidService _bidService = BidService();

  BidNotifier() : super(BidState());

  /// Place a bid
  Future<bool> placeBid(String auctionId, double amount) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final response = await _bidService.placeBid(
      PlaceBidRequest(auctionId: auctionId, amount: amount),
    );

    if (response.success && response.data != null) {
      state = state.copyWith(
        isLoading: false,
        successMessage: response.data!.message,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error?.message ?? 'Failed to place bid',
      );
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Bid Provider
final bidProvider = StateNotifierProvider<BidNotifier, BidState>((ref) {
  return BidNotifier();
});

/// Bids for Auction Provider
final auctionBidsProvider = FutureProvider.family<List<Bid>, String>((ref, auctionId) async {
  final bidService = BidService();
  final response = await bidService.getBidsForAuction(auctionId);
  
  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.error?.message ?? 'Failed to load bids');
  }
});

/// My Bids Provider
final myBidsProvider = FutureProvider<List<Bid>>((ref) async {
  final bidService = BidService();
  final response = await bidService.getMyBids();
  
  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.error?.message ?? 'Failed to load my bids');
  }
});

/// Winning Bids Provider
final winningBidsProvider = FutureProvider<List<Bid>>((ref) async {
  final bidService = BidService();
  final response = await bidService.getWinningBids();
  
  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.error?.message ?? 'Failed to load winning bids');
  }
});
