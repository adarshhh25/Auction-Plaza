// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get user => throw _privateConstructorUsedError;
  String get auction => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String user,
    String auction,
    double amount,
    String status,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? auction = null,
    Object? amount = null,
    Object? status = null,
    Object? paymentMethod = freezed,
    Object? transactionId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as String,
            auction: null == auction
                ? _value.auction
                : auction // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String user,
    String auction,
    double amount,
    String status,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? auction = null,
    Object? amount = null,
    Object? status = null,
    Object? paymentMethod = freezed,
    Object? transactionId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as String,
        auction: null == auction
            ? _value.auction
            : auction // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
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
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({
    @JsonKey(name: '_id') required this.id,
    required this.user,
    required this.auction,
    required this.amount,
    required this.status,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
  });

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String user;
  @override
  final String auction;
  @override
  final double amount;
  @override
  final String status;
  @override
  final String? paymentMethod;
  @override
  final String? transactionId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Payment(id: $id, user: $user, auction: $auction, amount: $amount, status: $status, paymentMethod: $paymentMethod, transactionId: $transactionId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.auction, auction) || other.auction == auction) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
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
    user,
    auction,
    amount,
    status,
    paymentMethod,
    transactionId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    @JsonKey(name: '_id') required final String id,
    required final String user,
    required final String auction,
    required final double amount,
    required final String status,
    final String? paymentMethod,
    final String? transactionId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get user;
  @override
  String get auction;
  @override
  double get amount;
  @override
  String get status;
  @override
  String? get paymentMethod;
  @override
  String? get transactionId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePaymentRequest _$CreatePaymentRequestFromJson(Map<String, dynamic> json) {
  return _CreatePaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePaymentRequest {
  String get auctionId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this CreatePaymentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePaymentRequestCopyWith<CreatePaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePaymentRequestCopyWith<$Res> {
  factory $CreatePaymentRequestCopyWith(
    CreatePaymentRequest value,
    $Res Function(CreatePaymentRequest) then,
  ) = _$CreatePaymentRequestCopyWithImpl<$Res, CreatePaymentRequest>;
  @useResult
  $Res call({String auctionId, double amount, String? paymentMethod});
}

/// @nodoc
class _$CreatePaymentRequestCopyWithImpl<
  $Res,
  $Val extends CreatePaymentRequest
>
    implements $CreatePaymentRequestCopyWith<$Res> {
  _$CreatePaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auctionId = null,
    Object? amount = null,
    Object? paymentMethod = freezed,
  }) {
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
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePaymentRequestImplCopyWith<$Res>
    implements $CreatePaymentRequestCopyWith<$Res> {
  factory _$$CreatePaymentRequestImplCopyWith(
    _$CreatePaymentRequestImpl value,
    $Res Function(_$CreatePaymentRequestImpl) then,
  ) = __$$CreatePaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String auctionId, double amount, String? paymentMethod});
}

/// @nodoc
class __$$CreatePaymentRequestImplCopyWithImpl<$Res>
    extends _$CreatePaymentRequestCopyWithImpl<$Res, _$CreatePaymentRequestImpl>
    implements _$$CreatePaymentRequestImplCopyWith<$Res> {
  __$$CreatePaymentRequestImplCopyWithImpl(
    _$CreatePaymentRequestImpl _value,
    $Res Function(_$CreatePaymentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auctionId = null,
    Object? amount = null,
    Object? paymentMethod = freezed,
  }) {
    return _then(
      _$CreatePaymentRequestImpl(
        auctionId: null == auctionId
            ? _value.auctionId
            : auctionId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePaymentRequestImpl implements _CreatePaymentRequest {
  const _$CreatePaymentRequestImpl({
    required this.auctionId,
    required this.amount,
    this.paymentMethod,
  });

  factory _$CreatePaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePaymentRequestImplFromJson(json);

  @override
  final String auctionId;
  @override
  final double amount;
  @override
  final String? paymentMethod;

  @override
  String toString() {
    return 'CreatePaymentRequest(auctionId: $auctionId, amount: $amount, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePaymentRequestImpl &&
            (identical(other.auctionId, auctionId) ||
                other.auctionId == auctionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, auctionId, amount, paymentMethod);

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePaymentRequestImplCopyWith<_$CreatePaymentRequestImpl>
  get copyWith =>
      __$$CreatePaymentRequestImplCopyWithImpl<_$CreatePaymentRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePaymentRequestImplToJson(this);
  }
}

abstract class _CreatePaymentRequest implements CreatePaymentRequest {
  const factory _CreatePaymentRequest({
    required final String auctionId,
    required final double amount,
    final String? paymentMethod,
  }) = _$CreatePaymentRequestImpl;

  factory _CreatePaymentRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePaymentRequestImpl.fromJson;

  @override
  String get auctionId;
  @override
  double get amount;
  @override
  String? get paymentMethod;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePaymentRequestImplCopyWith<_$CreatePaymentRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
