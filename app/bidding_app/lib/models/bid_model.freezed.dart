// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Bid _$BidFromJson(Map<String, dynamic> json) {
  return _Bid.fromJson(json);
}

/// @nodoc
mixin _$Bid {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get auction => throw _privateConstructorUsedError;
  String get bidder => throw _privateConstructorUsedError;
  String? get bidderName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool? get isWinning => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Bid to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BidCopyWith<Bid> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BidCopyWith<$Res> {
  factory $BidCopyWith(Bid value, $Res Function(Bid) then) =
      _$BidCopyWithImpl<$Res, Bid>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String auction,
    String bidder,
    String? bidderName,
    double amount,
    DateTime timestamp,
    bool? isWinning,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$BidCopyWithImpl<$Res, $Val extends Bid> implements $BidCopyWith<$Res> {
  _$BidCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? auction = null,
    Object? bidder = null,
    Object? bidderName = freezed,
    Object? amount = null,
    Object? timestamp = null,
    Object? isWinning = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            auction: null == auction
                ? _value.auction
                : auction // ignore: cast_nullable_to_non_nullable
                      as String,
            bidder: null == bidder
                ? _value.bidder
                : bidder // ignore: cast_nullable_to_non_nullable
                      as String,
            bidderName: freezed == bidderName
                ? _value.bidderName
                : bidderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isWinning: freezed == isWinning
                ? _value.isWinning
                : isWinning // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BidImplCopyWith<$Res> implements $BidCopyWith<$Res> {
  factory _$$BidImplCopyWith(_$BidImpl value, $Res Function(_$BidImpl) then) =
      __$$BidImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String auction,
    String bidder,
    String? bidderName,
    double amount,
    DateTime timestamp,
    bool? isWinning,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$BidImplCopyWithImpl<$Res> extends _$BidCopyWithImpl<$Res, _$BidImpl>
    implements _$$BidImplCopyWith<$Res> {
  __$$BidImplCopyWithImpl(_$BidImpl _value, $Res Function(_$BidImpl) _then)
    : super(_value, _then);

  /// Create a copy of Bid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? auction = null,
    Object? bidder = null,
    Object? bidderName = freezed,
    Object? amount = null,
    Object? timestamp = null,
    Object? isWinning = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BidImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        auction: null == auction
            ? _value.auction
            : auction // ignore: cast_nullable_to_non_nullable
                  as String,
        bidder: null == bidder
            ? _value.bidder
            : bidder // ignore: cast_nullable_to_non_nullable
                  as String,
        bidderName: freezed == bidderName
            ? _value.bidderName
            : bidderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isWinning: freezed == isWinning
            ? _value.isWinning
            : isWinning // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BidImpl implements _Bid {
  const _$BidImpl({
    @JsonKey(name: '_id') required this.id,
    required this.auction,
    required this.bidder,
    this.bidderName,
    required this.amount,
    required this.timestamp,
    this.isWinning,
    this.createdAt,
    this.updatedAt,
  });

  factory _$BidImpl.fromJson(Map<String, dynamic> json) =>
      _$$BidImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String auction;
  @override
  final String bidder;
  @override
  final String? bidderName;
  @override
  final double amount;
  @override
  final DateTime timestamp;
  @override
  final bool? isWinning;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Bid(id: $id, auction: $auction, bidder: $bidder, bidderName: $bidderName, amount: $amount, timestamp: $timestamp, isWinning: $isWinning, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BidImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.auction, auction) || other.auction == auction) &&
            (identical(other.bidder, bidder) || other.bidder == bidder) &&
            (identical(other.bidderName, bidderName) ||
                other.bidderName == bidderName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isWinning, isWinning) ||
                other.isWinning == isWinning) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    auction,
    bidder,
    bidderName,
    amount,
    timestamp,
    isWinning,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Bid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BidImplCopyWith<_$BidImpl> get copyWith =>
      __$$BidImplCopyWithImpl<_$BidImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BidImplToJson(this);
  }
}

abstract class _Bid implements Bid {
  const factory _Bid({
    @JsonKey(name: '_id') required final String id,
    required final String auction,
    required final String bidder,
    final String? bidderName,
    required final double amount,
    required final DateTime timestamp,
    final bool? isWinning,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$BidImpl;

  factory _Bid.fromJson(Map<String, dynamic> json) = _$BidImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get auction;
  @override
  String get bidder;
  @override
  String? get bidderName;
  @override
  double get amount;
  @override
  DateTime get timestamp;
  @override
  bool? get isWinning;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Bid
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BidImplCopyWith<_$BidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceBidRequest _$PlaceBidRequestFromJson(Map<String, dynamic> json) {
  return _PlaceBidRequest.fromJson(json);
}

/// @nodoc
mixin _$PlaceBidRequest {
  String get auctionId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this PlaceBidRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceBidRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceBidRequestCopyWith<PlaceBidRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceBidRequestCopyWith<$Res> {
  factory $PlaceBidRequestCopyWith(
    PlaceBidRequest value,
    $Res Function(PlaceBidRequest) then,
  ) = _$PlaceBidRequestCopyWithImpl<$Res, PlaceBidRequest>;
  @useResult
  $Res call({String auctionId, double amount});
}

/// @nodoc
class _$PlaceBidRequestCopyWithImpl<$Res, $Val extends PlaceBidRequest>
    implements $PlaceBidRequestCopyWith<$Res> {
  _$PlaceBidRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceBidRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? auctionId = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            auctionId: null == auctionId
                ? _value.auctionId
                : auctionId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceBidRequestImplCopyWith<$Res>
    implements $PlaceBidRequestCopyWith<$Res> {
  factory _$$PlaceBidRequestImplCopyWith(
    _$PlaceBidRequestImpl value,
    $Res Function(_$PlaceBidRequestImpl) then,
  ) = __$$PlaceBidRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String auctionId, double amount});
}

/// @nodoc
class __$$PlaceBidRequestImplCopyWithImpl<$Res>
    extends _$PlaceBidRequestCopyWithImpl<$Res, _$PlaceBidRequestImpl>
    implements _$$PlaceBidRequestImplCopyWith<$Res> {
  __$$PlaceBidRequestImplCopyWithImpl(
    _$PlaceBidRequestImpl _value,
    $Res Function(_$PlaceBidRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceBidRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? auctionId = null, Object? amount = null}) {
    return _then(
      _$PlaceBidRequestImpl(
        auctionId: null == auctionId
            ? _value.auctionId
            : auctionId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceBidRequestImpl implements _PlaceBidRequest {
  const _$PlaceBidRequestImpl({required this.auctionId, required this.amount});

  factory _$PlaceBidRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceBidRequestImplFromJson(json);

  @override
  final String auctionId;
  @override
  final double amount;

  @override
  String toString() {
    return 'PlaceBidRequest(auctionId: $auctionId, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceBidRequestImpl &&
            (identical(other.auctionId, auctionId) ||
                other.auctionId == auctionId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, auctionId, amount);

  /// Create a copy of PlaceBidRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceBidRequestImplCopyWith<_$PlaceBidRequestImpl> get copyWith =>
      __$$PlaceBidRequestImplCopyWithImpl<_$PlaceBidRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceBidRequestImplToJson(this);
  }
}

abstract class _PlaceBidRequest implements PlaceBidRequest {
  const factory _PlaceBidRequest({
    required final String auctionId,
    required final double amount,
  }) = _$PlaceBidRequestImpl;

  factory _PlaceBidRequest.fromJson(Map<String, dynamic> json) =
      _$PlaceBidRequestImpl.fromJson;

  @override
  String get auctionId;
  @override
  double get amount;

  /// Create a copy of PlaceBidRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceBidRequestImplCopyWith<_$PlaceBidRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BidResponse _$BidResponseFromJson(Map<String, dynamic> json) {
  return _BidResponse.fromJson(json);
}

/// @nodoc
mixin _$BidResponse {
  String get message => throw _privateConstructorUsedError;
  Bid get bid => throw _privateConstructorUsedError;

  /// Serializes this BidResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BidResponseCopyWith<BidResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BidResponseCopyWith<$Res> {
  factory $BidResponseCopyWith(
    BidResponse value,
    $Res Function(BidResponse) then,
  ) = _$BidResponseCopyWithImpl<$Res, BidResponse>;
  @useResult
  $Res call({String message, Bid bid});

  $BidCopyWith<$Res> get bid;
}

/// @nodoc
class _$BidResponseCopyWithImpl<$Res, $Val extends BidResponse>
    implements $BidResponseCopyWith<$Res> {
  _$BidResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? bid = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            bid: null == bid
                ? _value.bid
                : bid // ignore: cast_nullable_to_non_nullable
                      as Bid,
          )
          as $Val,
    );
  }

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BidCopyWith<$Res> get bid {
    return $BidCopyWith<$Res>(_value.bid, (value) {
      return _then(_value.copyWith(bid: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BidResponseImplCopyWith<$Res>
    implements $BidResponseCopyWith<$Res> {
  factory _$$BidResponseImplCopyWith(
    _$BidResponseImpl value,
    $Res Function(_$BidResponseImpl) then,
  ) = __$$BidResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Bid bid});

  @override
  $BidCopyWith<$Res> get bid;
}

/// @nodoc
class __$$BidResponseImplCopyWithImpl<$Res>
    extends _$BidResponseCopyWithImpl<$Res, _$BidResponseImpl>
    implements _$$BidResponseImplCopyWith<$Res> {
  __$$BidResponseImplCopyWithImpl(
    _$BidResponseImpl _value,
    $Res Function(_$BidResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? bid = null}) {
    return _then(
      _$BidResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        bid: null == bid
            ? _value.bid
            : bid // ignore: cast_nullable_to_non_nullable
                  as Bid,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BidResponseImpl implements _BidResponse {
  const _$BidResponseImpl({required this.message, required this.bid});

  factory _$BidResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BidResponseImplFromJson(json);

  @override
  final String message;
  @override
  final Bid bid;

  @override
  String toString() {
    return 'BidResponse(message: $message, bid: $bid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BidResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.bid, bid) || other.bid == bid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, bid);

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BidResponseImplCopyWith<_$BidResponseImpl> get copyWith =>
      __$$BidResponseImplCopyWithImpl<_$BidResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BidResponseImplToJson(this);
  }
}

abstract class _BidResponse implements BidResponse {
  const factory _BidResponse({
    required final String message,
    required final Bid bid,
  }) = _$BidResponseImpl;

  factory _BidResponse.fromJson(Map<String, dynamic> json) =
      _$BidResponseImpl.fromJson;

  @override
  String get message;
  @override
  Bid get bid;

  /// Create a copy of BidResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BidResponseImplCopyWith<_$BidResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
