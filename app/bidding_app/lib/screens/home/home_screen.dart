import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auction_card.dart';
import '../../core/constants/app_constants.dart';

/// Home Screen - Auction List
/// 
/// Displays list of active auctions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when user scrolls to 90% of list
      ref.read(auctionsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(auctionsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final auctionsState = ref.watch(auctionsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isSeller = currentUser?.role == AppConstants.roleSeller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BidMaster'),
        actions: [
          // My Bids
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.push('/my-bids'),
            tooltip: 'My Bids',
          ),
          // Wallet
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => context.push('/wallet'),
            tooltip: 'Wallet',
          ),
          // Profile
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: auctionsState.isLoading && auctionsState.auctions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : auctionsState.error != null && auctionsState.auctions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          auctionsState.error!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _onRefresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : auctionsState.auctions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No auctions available',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: auctionsState.auctions.length +
                            (auctionsState.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == auctionsState.auctions.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final auction = auctionsState.auctions[index];
                          return AuctionCard(
                            auction: auction,
                            onTap: () =>
                                context.push('/auction/${auction.id}'),
                          );
                        },
                      ),
      ),
      floatingActionButton: isSeller
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/create-auction'),
              icon: const Icon(Icons.add),
              label: const Text('Create Auction'),
            )
          : null,
    );
  }
}
