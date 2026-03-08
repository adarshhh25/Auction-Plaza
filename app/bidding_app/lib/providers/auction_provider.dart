import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auction_model.dart';
import '../services/auction_service.dart';

/// Auctions State
class AuctionsState {
  final List<Auction> auctions;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  AuctionsState({
    this.auctions = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  AuctionsState copyWith({
    List<Auction>? auctions,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return AuctionsState(
      auctions: auctions ?? this.auctions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Auctions Notifier
class AuctionsNotifier extends StateNotifier<AuctionsState> {
  final AuctionService _auctionService = AuctionService();

  AuctionsNotifier() : super(AuctionsState()) {
    loadAuctions();
  }

  /// Load auctions
  Future<void> loadAuctions({bool refresh = false}) async {
    if (refresh) {
      state = AuctionsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final response = await _auctionService.getAuctions(
      page: refresh ? 1 : state.currentPage,
    );

    if (response.success && response.data != null) {
      state = state.copyWith(
        auctions: refresh
            ? response.data!.auctions
            : [...state.auctions, ...response.data!.auctions],
        isLoading: false,
        currentPage: refresh ? 1 : state.currentPage,
        hasMore: response.data!.auctions.isNotEmpty,
      );
    } else {
      state = state.copyWith(
        error: response.error?.message ?? 'Failed to load auctions',
        isLoading: false,
      );
    }
  }

  /// Load more auctions (pagination)
  Future<void> loadMore() async {
    if (!state.isLoading && state.hasMore) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      await loadAuctions();
    }
  }

  /// Refresh auctions
  Future<void> refresh() async {
    await loadAuctions(refresh: true);
  }

  /// Update auction in list
  void updateAuction(Auction auction) {
    final updatedAuctions = state.auctions.map((a) {
      return a.id == auction.id ? auction : a;
    }).toList();

    state = state.copyWith(auctions: updatedAuctions);
  }
}

/// Auctions Provider
final auctionsProvider =
    StateNotifierProvider<AuctionsNotifier, AuctionsState>((ref) {
  return AuctionsNotifier();
});

/// Single Auction Provider
final auctionProvider = FutureProvider.family<Auction, String>((ref, id) async {
  final auctionService = AuctionService();
  final response = await auctionService.getAuctionById(id);
  
  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.error?.message ?? 'Failed to load auction');
  }
});

/// My Auctions Provider (for sellers)
final myAuctionsProvider = FutureProvider<List<Auction>>((ref) async {
  final auctionService = AuctionService();
  final response = await auctionService.getMyAuctions();
  
  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.error?.message ?? 'Failed to load my auctions');
  }
});
