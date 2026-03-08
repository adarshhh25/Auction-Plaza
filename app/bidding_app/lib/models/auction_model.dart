import 'package:freezed_annotation/freezed_annotation.dart';

part 'auction_model.freezed.dart';
part 'auction_model.g.dart';

@freezed
class Auction with _$Auction {
  const factory Auction({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    required String seller,
    String? sellerName,
    required double startingPrice,
    required double currentBid,
    required double minimumIncrement,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
    List<String>? images,
    String? category,
    int? totalBids,
    String? highestBidder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Auction;

  factory Auction.fromJson(Map<String, dynamic> json) =>
      _$AuctionFromJson(json);
}

@freezed
class AuctionListResponse with _$AuctionListResponse {
  const factory AuctionListResponse({
    required List<Auction> auctions,
    required int total,
    required int page,
    required int limit,
  }) = _AuctionListResponse;

  factory AuctionListResponse.fromJson(Map<String, dynamic> json) =>
      _$AuctionListResponseFromJson(json);
}

@freezed
class CreateAuctionRequest with _$CreateAuctionRequest {
  const factory CreateAuctionRequest({
    required String title,
    required String description,
    required double startingPrice,
    required double minimumIncrement,
    required DateTime startTime,
    required DateTime endTime,
    List<String>? images,
    String? category,
  }) = _CreateAuctionRequest;

  factory CreateAuctionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAuctionRequestFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'startingPrice': startingPrice,
    'minimumIncrement': minimumIncrement,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    if (images != null) 'images': images,
    if (category != null) 'category': category,
  };
}
