import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    @JsonKey(name: '_id') required String id,
    required String user,
    required String auction,
    required double amount,
    required String status,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

@freezed
class CreatePaymentRequest with _$CreatePaymentRequest {
  const factory CreatePaymentRequest({
    required String auctionId,
    required double amount,
    String? paymentMethod,
  }) = _CreatePaymentRequest;

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'auctionId': auctionId,
    'amount': amount,
    if (paymentMethod != null) 'paymentMethod': paymentMethod,
  };
}
