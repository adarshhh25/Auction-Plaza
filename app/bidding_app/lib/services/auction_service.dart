import '../core/config/api_config.dart';
import '../models/auction_model.dart';
import '../models/api_response.dart';
import 'api_client.dart';

/// Auction Service
/// 
/// Handles all auction-related API operations.
class AuctionService {
  final ApiClient _apiClient = ApiClient();

  /// Get all auctions with pagination
  Future<ApiResponse<AuctionListResponse>> getAuctions({
    int page = 1,
    int limit = 20,
    String? status,
    String? category,
  }) async {
    return await _apiClient.get<AuctionListResponse>(
      ApiConfig.auctions,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (category != null) 'category': category,
      },
      fromJson: (json) => AuctionListResponse.fromJson(json['data']),
    );
  }

  /// Get auction by ID
  Future<ApiResponse<Auction>> getAuctionById(String id) async {
    return await _apiClient.get<Auction>(
      ApiConfig.auctionById(id),
      fromJson: (json) => Auction.fromJson(json['data']['auction']),
    );
  }

  /// Get my auctions (seller)
  Future<ApiResponse<List<Auction>>> getMyAuctions() async {
    return await _apiClient.get<List<Auction>>(
      ApiConfig.myAuctions,
      fromJson: (json) {
        final auctions = json['data']['auctions'] as List;
        return auctions.map((a) => Auction.fromJson(a)).toList();
      },
    );
  }

  /// Create new auction
  Future<ApiResponse<Auction>> createAuction(CreateAuctionRequest request) async {
    return await _apiClient.post<Auction>(
      ApiConfig.auctions,
      data: request.toJson(),
      fromJson: (json) => Auction.fromJson(json['data']['auction']),
    );
  }

  /// Update auction status
  Future<ApiResponse<Auction>> updateAuctionStatus(
    String id,
    String status,
  ) async {
    return await _apiClient.patch<Auction>(
      ApiConfig.updateAuctionStatus(id),
      data: {'status': status},
      fromJson: (json) => Auction.fromJson(json['data']['auction']),
    );
  }

  /// Search auctions
  Future<ApiResponse<AuctionListResponse>> searchAuctions(String query) async {
    return await _apiClient.get<AuctionListResponse>(
      ApiConfig.auctions,
      queryParameters: {'search': query},
      fromJson: (json) => AuctionListResponse.fromJson(json['data']),
    );
  }
}
