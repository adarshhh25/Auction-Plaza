// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BidImpl _$$BidImplFromJson(Map<String, dynamic> json) => _$BidImpl(
  id: json['_id'] as String,
  auction: json['auction'] as String,
  bidder: json['bidder'] as String,
  bidderName: json['bidderName'] as String?,
  amount: (json['amount'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  isWinning: json['isWinning'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$BidImplToJson(_$BidImpl instance) => <String, dynamic>{
  '_id': instance.id,
  'auction': instance.auction,
  'bidder': instance.bidder,
  'bidderName': instance.bidderName,
  'amount': instance.amount,
  'timestamp': instance.timestamp.toIso8601String(),
  'isWinning': instance.isWinning,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$PlaceBidRequestImpl _$$PlaceBidRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PlaceBidRequestImpl(
  auctionId: json['auctionId'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$$PlaceBidRequestImplToJson(
  _$PlaceBidRequestImpl instance,
) => <String, dynamic>{
  'auctionId': instance.auctionId,
  'amount': instance.amount,
};

_$BidResponseImpl _$$BidResponseImplFromJson(Map<String, dynamic> json) =>
    _$BidResponseImpl(
      message: json['message'] as String,
      bid: Bid.fromJson(json['bid'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BidResponseImplToJson(_$BidResponseImpl instance) =>
    <String, dynamic>{'message': instance.message, 'bid': instance.bid};
