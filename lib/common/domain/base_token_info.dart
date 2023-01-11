abstract class BaseTokenInfo {
  /// EN: [accessToken] - token
  ///
  final String accessToken;

  /// EN: [refreshToken] - refresh token
  ///
  final String refreshToken;

  const BaseTokenInfo({
    required this.accessToken,
    required this.refreshToken,
  });

  /// EN: [isAuthorized] - is user authorized
  ///
  bool get isAuthorized => this is! EmptyTokenInfo && accessToken.isNotEmpty;

  factory BaseTokenInfo.empty() = EmptyTokenInfo;

  factory BaseTokenInfo.token({
    required String accessToken,
    required String refreshToken,
  }) = TokenInfo;
}

class TokenInfo extends BaseTokenInfo {
  TokenInfo({required super.accessToken, required super.refreshToken});
}

class EmptyTokenInfo extends BaseTokenInfo {
  const EmptyTokenInfo()
      : super(
          accessToken: '',
          refreshToken: '',
        );
}
