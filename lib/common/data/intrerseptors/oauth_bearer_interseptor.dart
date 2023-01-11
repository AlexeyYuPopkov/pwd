import 'package:dio/dio.dart';
import 'package:pwd/common/domain/base_token_info.dart';
import 'package:pwd/common/domain/token_repository.dart';

class OAuthBearerInterceptor extends Interceptor {
  final TokenRepository tokenRepository;

  OAuthBearerInterceptor({
    required this.tokenRepository,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = tokenRepository.token?.accessToken;

    if (accessToken is TokenInfo) {
      options.headers['Authorization'] = 'bearer $accessToken';
    }

    super.onRequest(options, handler);
  }
}
