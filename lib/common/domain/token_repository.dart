import 'base_token_info.dart';

abstract class TokenRepository {
  /// RU: [accessToken] - модель токена доступа
  ///
  /// EN: [accessToken] - model of token
  ///
  BaseTokenInfo? get token;

  /// RU: [setToken] - закэшировать модель токена доступа
  ///
  /// EN: [setToken] - cashe model of token
  ///
  Future<void> setToken(BaseTokenInfo token);

  /// RU: [setToken] - удалить модель токена доступа
  ///
  /// EN: [setToken] - drop model of token
  ///
  Future<void> dropToken();

  /// RU: [isAuthorized] - залогинен ли пользователь
  ///
  /// EN: [isAuthorized] - did user pass login flow?
  ///
  bool get isAuthorized;

  /// RU: [tokenInfoStream] - залогинен ли пользователь
  ///
  /// EN: [tokenInfoStream] - did user pass login flow?
  ///
  Stream<BaseTokenInfo> get tokenInfoStream;
}
