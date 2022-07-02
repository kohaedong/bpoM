import 'package:json_annotation/json_annotation.dart';
part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  @JsonKey(name: 'access_token')
  String accessToken;
  @JsonKey(name: 'token_type')
  String tokenType;
  @JsonKey(name: 'refresh_token')
  String refreshToken;
  @JsonKey(name: 'expires_in')
  int expiresIn;
  String scope;
  String jti;

  TokenModel(this.accessToken, this.tokenType, this.refreshToken,
      this.expiresIn, this.scope, this.jti);
  factory TokenModel.fromJson(Object? json) =>
      _$TokenModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
