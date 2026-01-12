/// 토큰 발급 응답 모델
class TokenResponse {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int expiresIn;
  final String? scope;
  final String? clientId;
  final String? userId;
  final bool? isUserProfileRegistered;
  final String? userTimezone;
  final String? languageSeCd;
  final String? loginId;
  final bool? isPasswordChangeRequired;

  TokenResponse({
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.scope,
    this.clientId,
    this.userId,
    this.isUserProfileRegistered,
    this.userTimezone,
    this.languageSeCd,
    this.loginId,
    this.isPasswordChangeRequired,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 0,
      scope: json['scope'] as String?,
      clientId: json['clientId'] as String?,
      userId: json['userId'] as String?,
      isUserProfileRegistered: json['isUserProfileRegistered'] as bool?,
      userTimezone: json['userTimezone'] as String?,
      languageSeCd: json['languageSeCd'] as String?,
      loginId: json['loginId'] as String?,
      isPasswordChangeRequired: json['isPasswordChangeRequired'] as bool?,
    );
  }
}
