import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// User models for authentication and profile
// Updated to match backend response structure
@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'id') required String id, // Backend returns 'id', not '_id'
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'walletBalance') @Default(0.0) double walletBalance, // Backend returns number, not object
    @Default(false) bool isVerified,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required User user,
    required String accessToken, // Backend returns these at top level, not nested
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

// Legacy classes - keeping for backward compatibility with existing code
@freezed
class WalletBalance with _$WalletBalance {
  const factory WalletBalance({
    @Default(0.0) double balance,
  }) = _WalletBalance;

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);
}

@freezed
class Tokens with _$Tokens {
  const factory Tokens({
    required String accessToken,
    required String refreshToken,
  }) = _Tokens;

  factory Tokens.fromJson(Map<String, dynamic> json) =>
      _$TokensFromJson(json);
}
