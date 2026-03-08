// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuctionImpl _$$AuctionImplFromJson(Map<String, dynamic> json) =>
    _$AuctionImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      seller: json['seller'] as String,
      sellerName: json['sellerName'] as String?,
      startingPrice: (json['startingPrice'] as num).toDouble(),
      currentBid: (json['currentBid'] as num).toDouble(),
      minimumIncrement: (json['minimumIncrement'] as num).toDouble(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      category: json['category'] as String?,
      totalBids: (json['totalBids'] as num?)?.toInt(),
      highestBidder: json['highestBidder'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AuctionImplToJson(_$AuctionImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'seller': instance.seller,
      'sellerName': instance.sellerName,
      'startingPrice': instance.startingPrice,
      'currentBid': instance.currentBid,
      'minimumIncrement': instance.minimumIncrement,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': instance.status,
      'images': instance.images,
      'category': instance.category,
      'totalBids': instance.totalBids,
      'highestBidder': instance.highestBidder,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AuctionListResponseImpl _$$AuctionListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AuctionListResponseImpl(
  auctions: (json['auctions'] as List<dynamic>)
      .map((e) => Auction.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$$AuctionListResponseImplToJson(
  _$AuctionListResponseImpl instance,
) => <String, dynamic>{
  'auctions': instance.auctions,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_$CreateAuctionRequestImpl _$$CreateAuctionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateAuctionRequestImpl(
  title: json['title'] as String,
  description: json['description'] as String,
  startingPrice: (json['startingPrice'] as num).toDouble(),
  minimumIncrement: (json['minimumIncrement'] as num).toDouble(),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  category: json['category'] as String?,
);

Map<String, dynamic> _$$CreateAuctionRequestImplToJson(
  _$CreateAuctionRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'startingPrice': instance.startingPrice,
  'minimumIncrement': instance.minimumIncrement,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'images': instance.images,
  'category': instance.category,
};
