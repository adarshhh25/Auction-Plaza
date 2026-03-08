import 'package:freezed_annotation/freezed_annotation.dart';

part 'bid_model.freezed.dart';
part 'bid_model.g.dart';

@freezed
class Bid with _$Bid {
  const factory Bid({
    @JsonKey(name: '_id') required String id,
    required String auction,
    required String bidder,
    String? bidderName,
    required double amount,
    required DateTime timestamp,
    bool? isWinning,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Bid;

  factory Bid.fromJson(Map<String, dynamic> json) => _$BidFromJson(json);
}

@freezed
class PlaceBidRequest with _$PlaceBidRequest {
  const factory PlaceBidRequest({
    required String auctionId,
    required double amount,
  }) = _PlaceBidRequest;

  factory PlaceBidRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceBidRequestFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'auctionId': auctionId,
    'amount': amount,
  };
}

@freezed
class BidResponse with _$BidResponse {
  const factory BidResponse({
    required String message,
    required Bid bid,
  }) = _BidResponse;

  factory BidResponse.fromJson(Map<String, dynamic> json) =>
      _$BidResponseFromJson(json);
}
