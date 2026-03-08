import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/auction_model.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// Auction Card Widget
/// 
/// Displays auction information in a card format.
class AuctionCard extends StatelessWidget {
  final Auction auction;
  final VoidCallback onTap;

  const AuctionCard({
    super.key,
    required this.auction,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (auction.status) {
      case AppConstants.auctionStatusActive:
        return AppTheme.activeAuctionColor;
      case AppConstants.auctionStatusCompleted:
        return AppTheme.closedAuctionColor;
      case AppConstants.auctionStatusCancelled:
        return AppTheme.losingBidColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = auction.images?.isNotEmpty == true
        ? auction.images!.first
        : AppConstants.placeholderImage;

    final isActive = auction.status == AppConstants.auctionStatusActive;
    final timeRemaining = isActive
        ? DateFormatter.formatRemainingTime(auction.endTime)
        : auction.status;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    auction.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Current Bid
                  Row(
                    children: [
                      Text(
                        'Current Bid:',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        CurrencyFormatter.format(auction.currentBid),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.winningBidColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Total Bids
                  if (auction.totalBids != null && auction.totalBids! > 0)
                    Text(
                      '${auction.totalBids} bids',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 8),
                  
                  // Time Remaining / Status
                  Row(
                    children: [
                      Icon(
                        isActive ? Icons.access_time : Icons.info_outline,
                        size: 16,
                        color: _getStatusColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeRemaining,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
