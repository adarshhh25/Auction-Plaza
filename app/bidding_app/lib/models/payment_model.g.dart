// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['_id'] as String,
      user: json['user'] as String,
      auction: json['auction'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'auction': instance.auction,
      'amount': instance.amount,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CreatePaymentRequestImpl _$$CreatePaymentRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePaymentRequestImpl(
  auctionId: json['auctionId'] as String,
  amount: (json['amount'] as num).toDouble(),
  paymentMethod: json['paymentMethod'] as String?,
);

Map<String, dynamic> _$$CreatePaymentRequestImplToJson(
  _$CreatePaymentRequestImpl instance,
) => <String, dynamic>{
  'auctionId': instance.auctionId,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
};
