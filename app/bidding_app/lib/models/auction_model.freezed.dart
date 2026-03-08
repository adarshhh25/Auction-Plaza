// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Auction _$AuctionFromJson(Map<String, dynamic> json) {
  return _Auction.fromJson(json);
}

/// @nodoc
mixin _$Auction {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get seller => throw _privateConstructorUsedError;
  String? get sellerName => throw _privateConstructorUsedError;
  double get startingPrice => throw _privateConstructorUsedError;
  double get currentBid => throw _privateConstructorUsedError;
  double get minimumIncrement => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int? get totalBids => throw _privateConstructorUsedError;
  String? get highestBidder => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Auction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Auction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuctionCopyWith<Auction> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuctionCopyWith<$Res> {
  factory $AuctionCopyWith(Auction value, $Res Function(Auction) then) =
      _$AuctionCopyWithImpl<$Res, Auction>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    String seller,
    String? sellerName,
    double startingPrice,
    double currentBid,
    double minimumIncrement,
    DateTime startTime,
    DateTime endTime,
    String status,
    List<String>? images,
    String? category,
    int? totalBids,
    String? highestBidder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AuctionCopyWithImpl<$Res, $Val extends Auction>
    implements $AuctionCopyWith<$Res> {
  _$AuctionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Auction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? seller = null,
    Object? sellerName = freezed,
    Object? startingPrice = null,
    Object? currentBid = null,
    Object? minimumIncrement = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? images = freezed,
    Object? category = freezed,
    Object? totalBids = freezed,
    Object? highestBidder = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            seller: null == seller
                ? _value.seller
                : seller // ignore: cast_nullable_to_non_nullable
                      as String,
            sellerName: freezed == sellerName
                ? _value.sellerName
                : sellerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            startingPrice: null == startingPrice
                ? _value.startingPrice
                : startingPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            currentBid: null == currentBid
                ? _value.currentBid
                : currentBid // ignore: cast_nullable_to_non_nullable
                      as double,
            minimumIncrement: null == minimumIncrement
                ? _value.minimumIncrement
                : minimumIncrement // ignore: cast_nullable_to_non_nullable
                      as double,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalBids: freezed == totalBids
                ? _value.totalBids
                : totalBids // ignore: cast_nullable_to_non_nullable
                      as int?,
            highestBidder: freezed == highestBidder
                ? _value.highestBidder
                : highestBidder // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$AuctionImplCopyWith<$Res> implements $AuctionCopyWith<$Res> {
  factory _$$AuctionImplCopyWith(
    _$AuctionImpl value,
    $Res Function(_$AuctionImpl) then,
  ) = __$$AuctionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    String seller,
    String? sellerName,
    double startingPrice,
    double currentBid,
    double minimumIncrement,
    DateTime startTime,
    DateTime endTime,
    String status,
    List<String>? images,
    String? category,
    int? totalBids,
    String? highestBidder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AuctionImplCopyWithImpl<$Res>
    extends _$AuctionCopyWithImpl<$Res, _$AuctionImpl>
    implements _$$AuctionImplCopyWith<$Res> {
  __$$AuctionImplCopyWithImpl(
    _$AuctionImpl _value,
    $Res Function(_$AuctionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Auction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? seller = null,
    Object? sellerName = freezed,
    Object? startingPrice = null,
    Object? currentBid = null,
    Object? minimumIncrement = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? images = freezed,
    Object? category = freezed,
    Object? totalBids = freezed,
    Object? highestBidder = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AuctionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        seller: null == seller
            ? _value.seller
            : seller // ignore: cast_nullable_to_non_nullable
                  as String,
        sellerName: freezed == sellerName
            ? _value.sellerName
            : sellerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        startingPrice: null == startingPrice
            ? _value.startingPrice
            : startingPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        currentBid: null == currentBid
            ? _value.currentBid
            : currentBid // ignore: cast_nullable_to_non_nullable
                  as double,
        minimumIncrement: null == minimumIncrement
            ? _value.minimumIncrement
            : minimumIncrement // ignore: cast_nullable_to_non_nullable
                  as double,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalBids: freezed == totalBids
            ? _value.totalBids
            : totalBids // ignore: cast_nullable_to_non_nullable
                  as int?,
        highestBidder: freezed == highestBidder
            ? _value.highestBidder
            : highestBidder // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$AuctionImpl implements _Auction {
  const _$AuctionImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    required this.description,
    required this.seller,
    this.sellerName,
    required this.startingPrice,
    required this.currentBid,
    required this.minimumIncrement,
    required this.startTime,
    required this.endTime,
    required this.status,
    final List<String>? images,
    this.category,
    this.totalBids,
    this.highestBidder,
    this.createdAt,
    this.updatedAt,
  }) : _images = images;

  factory _$AuctionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuctionImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String seller;
  @override
  final String? sellerName;
  @override
  final double startingPrice;
  @override
  final double currentBid;
  @override
  final double minimumIncrement;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String status;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? category;
  @override
  final int? totalBids;
  @override
  final String? highestBidder;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Auction(id: $id, title: $title, description: $description, seller: $seller, sellerName: $sellerName, startingPrice: $startingPrice, currentBid: $currentBid, minimumIncrement: $minimumIncrement, startTime: $startTime, endTime: $endTime, status: $status, images: $images, category: $category, totalBids: $totalBids, highestBidder: $highestBidder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuctionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.startingPrice, startingPrice) ||
                other.startingPrice == startingPrice) &&
            (identical(other.currentBid, currentBid) ||
                other.currentBid == currentBid) &&
            (identical(other.minimumIncrement, minimumIncrement) ||
                other.minimumIncrement == minimumIncrement) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalBids, totalBids) ||
                other.totalBids == totalBids) &&
            (identical(other.highestBidder, highestBidder) ||
                other.highestBidder == highestBidder) &&
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
    title,
    description,
    seller,
    sellerName,
    startingPrice,
    currentBid,
    minimumIncrement,
    startTime,
    endTime,
    status,
    const DeepCollectionEquality().hash(_images),
    category,
    totalBids,
    highestBidder,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Auction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuctionImplCopyWith<_$AuctionImpl> get copyWith =>
      __$$AuctionImplCopyWithImpl<_$AuctionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuctionImplToJson(this);
  }
}

abstract class _Auction implements Auction {
  const factory _Auction({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    required final String description,
    required final String seller,
    final String? sellerName,
    required final double startingPrice,
    required final double currentBid,
    required final double minimumIncrement,
    required final DateTime startTime,
    required final DateTime endTime,
    required final String status,
    final List<String>? images,
    final String? category,
    final int? totalBids,
    final String? highestBidder,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$AuctionImpl;

  factory _Auction.fromJson(Map<String, dynamic> json) = _$AuctionImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get seller;
  @override
  String? get sellerName;
  @override
  double get startingPrice;
  @override
  double get currentBid;
  @override
  double get minimumIncrement;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get status;
  @override
  List<String>? get images;
  @override
  String? get category;
  @override
  int? get totalBids;
  @override
  String? get highestBidder;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Auction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuctionImplCopyWith<_$AuctionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuctionListResponse _$AuctionListResponseFromJson(Map<String, dynamic> json) {
  return _AuctionListResponse.fromJson(json);
}

/// @nodoc
mixin _$AuctionListResponse {
  List<Auction> get auctions => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this AuctionListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuctionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuctionListResponseCopyWith<AuctionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuctionListResponseCopyWith<$Res> {
  factory $AuctionListResponseCopyWith(
    AuctionListResponse value,
    $Res Function(AuctionListResponse) then,
  ) = _$AuctionListResponseCopyWithImpl<$Res, AuctionListResponse>;
  @useResult
  $Res call({List<Auction> auctions, int total, int page, int limit});
}

/// @nodoc
class _$AuctionListResponseCopyWithImpl<$Res, $Val extends AuctionListResponse>
    implements $AuctionListResponseCopyWith<$Res> {
  _$AuctionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuctionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auctions = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _value.copyWith(
            auctions: null == auctions
                ? _value.auctions
                : auctions // ignore: cast_nullable_to_non_nullable
                      as List<Auction>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuctionListResponseImplCopyWith<$Res>
    implements $AuctionListResponseCopyWith<$Res> {
  factory _$$AuctionListResponseImplCopyWith(
    _$AuctionListResponseImpl value,
    $Res Function(_$AuctionListResponseImpl) then,
  ) = __$$AuctionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Auction> auctions, int total, int page, int limit});
}

/// @nodoc
class __$$AuctionListResponseImplCopyWithImpl<$Res>
    extends _$AuctionListResponseCopyWithImpl<$Res, _$AuctionListResponseImpl>
    implements _$$AuctionListResponseImplCopyWith<$Res> {
  __$$AuctionListResponseImplCopyWithImpl(
    _$AuctionListResponseImpl _value,
    $Res Function(_$AuctionListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuctionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auctions = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(
      _$AuctionListResponseImpl(
        auctions: null == auctions
            ? _value._auctions
            : auctions // ignore: cast_nullable_to_non_nullable
                  as List<Auction>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuctionListResponseImpl implements _AuctionListResponse {
  const _$AuctionListResponseImpl({
    required final List<Auction> auctions,
    required this.total,
    required this.page,
    required this.limit,
  }) : _auctions = auctions;

  factory _$AuctionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuctionListResponseImplFromJson(json);

  final List<Auction> _auctions;
  @override
  List<Auction> get auctions {
    if (_auctions is EqualUnmodifiableListView) return _auctions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_auctions);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;

  @override
  String toString() {
    return 'AuctionListResponse(auctions: $auctions, total: $total, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuctionListResponseImpl &&
            const DeepCollectionEquality().equals(other._auctions, _auctions) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_auctions),
    total,
    page,
    limit,
  );

  /// Create a copy of AuctionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuctionListResponseImplCopyWith<_$AuctionListResponseImpl> get copyWith =>
      __$$AuctionListResponseImplCopyWithImpl<_$AuctionListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuctionListResponseImplToJson(this);
  }
}

abstract class _AuctionListResponse implements AuctionListResponse {
  const factory _AuctionListResponse({
    required final List<Auction> auctions,
    required final int total,
    required final int page,
    required final int limit,
  }) = _$AuctionListResponseImpl;

  factory _AuctionListResponse.fromJson(Map<String, dynamic> json) =
      _$AuctionListResponseImpl.fromJson;

  @override
  List<Auction> get auctions;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;

  /// Create a copy of AuctionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuctionListResponseImplCopyWith<_$AuctionListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateAuctionRequest _$CreateAuctionRequestFromJson(Map<String, dynamic> json) {
  return _CreateAuctionRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateAuctionRequest {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get startingPrice => throw _privateConstructorUsedError;
  double get minimumIncrement => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this CreateAuctionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateAuctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAuctionRequestCopyWith<CreateAuctionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAuctionRequestCopyWith<$Res> {
  factory $CreateAuctionRequestCopyWith(
    CreateAuctionRequest value,
    $Res Function(CreateAuctionRequest) then,
  ) = _$CreateAuctionRequestCopyWithImpl<$Res, CreateAuctionRequest>;
  @useResult
  $Res call({
    String title,
    String description,
    double startingPrice,
    double minimumIncrement,
    DateTime startTime,
    DateTime endTime,
    List<String>? images,
    String? category,
  });
}

/// @nodoc
class _$CreateAuctionRequestCopyWithImpl<
  $Res,
  $Val extends CreateAuctionRequest
>
    implements $CreateAuctionRequestCopyWith<$Res> {
  _$CreateAuctionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAuctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? startingPrice = null,
    Object? minimumIncrement = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? images = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            startingPrice: null == startingPrice
                ? _value.startingPrice
                : startingPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            minimumIncrement: null == minimumIncrement
                ? _value.minimumIncrement
                : minimumIncrement // ignore: cast_nullable_to_non_nullable
                      as double,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateAuctionRequestImplCopyWith<$Res>
    implements $CreateAuctionRequestCopyWith<$Res> {
  factory _$$CreateAuctionRequestImplCopyWith(
    _$CreateAuctionRequestImpl value,
    $Res Function(_$CreateAuctionRequestImpl) then,
  ) = __$$CreateAuctionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    double startingPrice,
    double minimumIncrement,
    DateTime startTime,
    DateTime endTime,
    List<String>? images,
    String? category,
  });
}

/// @nodoc
class __$$CreateAuctionRequestImplCopyWithImpl<$Res>
    extends _$CreateAuctionRequestCopyWithImpl<$Res, _$CreateAuctionRequestImpl>
    implements _$$CreateAuctionRequestImplCopyWith<$Res> {
  __$$CreateAuctionRequestImplCopyWithImpl(
    _$CreateAuctionRequestImpl _value,
    $Res Function(_$CreateAuctionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateAuctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? startingPrice = null,
    Object? minimumIncrement = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? images = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _$CreateAuctionRequestImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        startingPrice: null == startingPrice
            ? _value.startingPrice
            : startingPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        minimumIncrement: null == minimumIncrement
            ? _value.minimumIncrement
            : minimumIncrement // ignore: cast_nullable_to_non_nullable
                  as double,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateAuctionRequestImpl implements _CreateAuctionRequest {
  const _$CreateAuctionRequestImpl({
    required this.title,
    required this.description,
    required this.startingPrice,
    required this.minimumIncrement,
    required this.startTime,
    required this.endTime,
    final List<String>? images,
    this.category,
  }) : _images = images;

  factory _$CreateAuctionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateAuctionRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final double startingPrice;
  @override
  final double minimumIncrement;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? category;

  @override
  String toString() {
    return 'CreateAuctionRequest(title: $title, description: $description, startingPrice: $startingPrice, minimumIncrement: $minimumIncrement, startTime: $startTime, endTime: $endTime, images: $images, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAuctionRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startingPrice, startingPrice) ||
                other.startingPrice == startingPrice) &&
            (identical(other.minimumIncrement, minimumIncrement) ||
                other.minimumIncrement == minimumIncrement) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    startingPrice,
    minimumIncrement,
    startTime,
    endTime,
    const DeepCollectionEquality().hash(_images),
    category,
  );

  /// Create a copy of CreateAuctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAuctionRequestImplCopyWith<_$CreateAuctionRequestImpl>
  get copyWith =>
      __$$CreateAuctionRequestImplCopyWithImpl<_$CreateAuctionRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateAuctionRequestImplToJson(this);
  }
}

abstract class _CreateAuctionRequest implements CreateAuctionRequest {
  const factory _CreateAuctionRequest({
    required final String title,
    required final String description,
    required final double startingPrice,
    required final double minimumIncrement,
    required final DateTime startTime,
    required final DateTime endTime,
    final List<String>? images,
    final String? category,
  }) = _$CreateAuctionRequestImpl;

  factory _CreateAuctionRequest.fromJson(Map<String, dynamic> json) =
      _$CreateAuctionRequestImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  double get startingPrice;
  @override
  double get minimumIncrement;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  List<String>? get images;
  @override
  String? get category;

  /// Create a copy of CreateAuctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAuctionRequestImplCopyWith<_$CreateAuctionRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
