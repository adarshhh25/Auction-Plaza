import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../models/auction_model.dart';
import '../../models/bid_model.dart';
import '../../providers/auction_provider.dart';
import '../../providers/bid_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../services/socket_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// Auction Details Screen
/// 
/// Shows detailed auction information and allows placing bids.
class AuctionDetailScreen extends ConsumerStatefulWidget {
  final String auctionId;

  const AuctionDetailScreen({
    super.key,
    required this.auctionId,
  });

  @override
  ConsumerState<AuctionDetailScreen> createState() =>
      _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends ConsumerState<AuctionDetailScreen> {
  final _bidController = TextEditingController();
  final _socketService = SocketService();
  Auction? _currentAuction;

  @override
  void initState() {
    super.initState();
    _setupSocketListeners();
  }

  @override
  void dispose() {
    _bidController.dispose();
    _socketService.leaveAuction(widget.auctionId);
    _socketService.removeAllListeners();
    super.dispose();
  }

  void _setupSocketListeners() {
    _socketService.connect().then((_) {
      _socketService.joinAuction(widget.auctionId);

      // Listen for bid updates
      _socketService.onBidUpdate((data) {
        if (mounted) {
          setState(() {
            _currentAuction = _currentAuction?.copyWith(
              currentBid: (data['amount'] as num).toDouble(),
              totalBids: (_currentAuction?.totalBids ?? 0) + 1,
            );
          });
          ref.invalidate(auctionBidsProvider(widget.auctionId));
        }
      });

      // Listen for auction extended
      _socketService.onAuctionExtended((data) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Auction time extended!'),
              backgroundColor: Colors.orange,
            ),
          );
          ref.invalidate(auctionProvider(widget.auctionId));
        }
      });

      // Listen for auction closed
      _socketService.onAuctionClosed((data) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Auction has ended!'),
              backgroundColor: Colors.red,
            ),
          );
          ref.invalidate(auctionProvider(widget.auctionId));
        }
      });
    });
  }

  Future<void> _showBidDialog(Auction auction) async {
    final currentUser = ref.read(currentUserProvider);
    final walletBalance = ref.read(walletBalanceProvider);

    // Suggest bid amount (current bid + minimum increment)
    final suggestedBid = auction.currentBid + auction.minimumIncrement;
    _bidController.text = suggestedBid.toStringAsFixed(2);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place Your Bid'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Bid: ${CurrencyFormatter.format(auction.currentBid)}'),
            Text('Minimum Increment: ${CurrencyFormatter.format(auction.minimumIncrement)}'),
            Text('Your Balance: ${CurrencyFormatter.format(walletBalance)}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Bid Amount',
                prefixText: AppConstants.currencySymbol,
              ),
              validator: (value) => Validators.validateMinValue(
                value,
                suggestedBid,
                'Bid',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _placeBid(auction);
            },
            child: const Text('Place Bid'),
          ),
        ],
      ),
    );
  }

  Future<void> _placeBid(Auction auction) async {
    final bidAmount = double.tryParse(_bidController.text);
    if (bidAmount == null) return;

    final walletBalance = ref.read(walletBalanceProvider);
    
    // Validate bid amount
    if (bidAmount < auction.currentBid + auction.minimumIncrement) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bid must be at least ${CurrencyFormatter.format(auction.currentBid + auction.minimumIncrement)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (bidAmount > walletBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Insufficient wallet balance'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Add Funds',
            onPressed: () => context.push('/wallet'),
          ),
        ),
      );
      return;
    }

    final success = await ref.read(bidProvider.notifier).placeBid(
          widget.auctionId,
          bidAmount,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bid placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      ref.invalidate(auctionProvider(widget.auctionId));
      ref.invalidate(auctionBidsProvider(widget.auctionId));
      ref.read(walletProvider.notifier).refresh();
    } else if (mounted) {
      final error = ref.read(bidProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to place bid'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auctionAsync = ref.watch(auctionProvider(widget.auctionId));
    final bidsAsync = ref.watch(auctionBidsProvider(widget.auctionId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Details'),
      ),
      body: auctionAsync.when(
        data: (auction) {
          _currentAuction = auction;
          final isActive = auction.status == AppConstants.auctionStatusActive;
          final isSeller = currentUser?.id == auction.seller;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: auction.images?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: auction.images!.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 64),
                        ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        auction.title,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),

                      // Status Badge
                      Chip(
                        label: Text(auction.status.toUpperCase()),
                        backgroundColor: isActive
                            ? AppTheme.activeAuctionColor
                            : AppTheme.closedAuctionColor,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),

                      // Current Bid
                      Card(
                        color: AppTheme.winningBidColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Bid',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    CurrencyFormatter.format(auction.currentBid),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: AppTheme.winningBidColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              if (auction.totalBids != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total Bids',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      '${auction.totalBids}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Time Remaining
                      if (isActive)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.orange),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time Remaining',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      DateFormatter.getCountdown(
                                          auction.endTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auction.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),

                      // Auction Details
                      Text(
                        'Auction Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Starting Price',
                          CurrencyFormatter.format(auction.startingPrice)),
                      _buildDetailRow('Minimum Increment',
                          CurrencyFormatter.format(auction.minimumIncrement)),
                      _buildDetailRow('Start Time',
                          DateFormatter.formatDateTime(auction.startTime)),
                      _buildDetailRow('End Time',
                          DateFormatter.formatDateTime(auction.endTime)),
                      if (auction.sellerName != null)
                        _buildDetailRow('Seller', auction.sellerName!),
                      const SizedBox(height: 24),

                      // Bid History
                      Text(
                        'Bid History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      bidsAsync.when(
                        data: (bids) => bids.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No bids yet. Be the first!'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bids.length,
                                itemBuilder: (context, index) {
                                  final bid = bids[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(
                                      CurrencyFormatter.format(bid.amount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      bid.bidderName ?? 'Anonymous',
                                    ),
                                    trailing: Text(
                                      DateFormatter.formatRelativeTime(
                                          bid.timestamp),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  );
                                },
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) =>
                            Text('Error loading bids: $error'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: auctionAsync.when(
        data: (auction) {
          final isActive = auction.status == AppConstants.auctionStatusActive;
          final isSeller = currentUser?.id == auction.seller;

          if (!isActive || isSeller) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _showBidDialog(auction),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Place Bid'),
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
