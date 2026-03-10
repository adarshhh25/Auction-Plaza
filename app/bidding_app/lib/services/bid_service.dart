import '../core/config/api_config.dart';
import '../models/bid_model.dart';
import '../models/api_response.dart';
import 'api_client.dart';

/// Bid Service
/// 
/// Handles all bidding-related API operations.
class BidService {
  final ApiClient _apiClient = ApiClient();

  /// Place a bid on an auction
  Future<ApiResponse<BidResponse>> placeBid(PlaceBidRequest request) async {
    return await _apiClient.post<BidResponse>(
      ApiConfig.placeBid,
      data: request.toJson(),
      fromJson: (json) => BidResponse.fromJson(json['data']),
    );
  }

  /// Get all bids for a specific auction
  Future<ApiResponse<List<Bid>>> getBidsForAuction(String auctionId) async {
    return await _apiClient.get<List<Bid>>(
      ApiConfig.bidsForAuction(auctionId),
      fromJson: (json) {
        final bids = json['data']['bids'] as List;
        return bids.map((b) => Bid.fromJson(b)).toList();
      },
    );
  }

  /// Get my bids
  Future<ApiResponse<List<Bid>>> getMyBids() async {
    return await _apiClient.get<List<Bid>>(
      ApiConfig.myBids,
      fromJson: (json) {
        final bids = json['data']['bids'] as List;
        return bids.map((b) => Bid.fromJson(b)).toList();
      },
    );
  }

  /// Get winning bids
  Future<ApiResponse<List<Bid>>> getWinningBids() async {
    return await _apiClient.get<List<Bid>>(
      ApiConfig.winningBids,
      fromJson: (json) {
        final bids = json['data']['bids'] as List;
        return bids.map((b) => Bid.fromJson(b)).toList();
      },
    );
  }
}
