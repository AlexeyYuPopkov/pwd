import 'package:pwd/common/domain/base_token_info.dart';
import 'package:pwd/common/domain/token_repository.dart';
import 'package:rxdart/rxdart.dart';

class CacheTokenDataSource implements TokenRepository {
  final _tokenInfoStream = BehaviorSubject<BaseTokenInfo>.seeded(
    BaseTokenInfo.empty(),
  );

  @override
  BaseTokenInfo get token => _tokenInfoStream.value;

  @override
  Future<void> setToken(BaseTokenInfo token) async =>
      _tokenInfoStream.sink.add(token);

  @override
  Future<void> dropToken() async =>
      _tokenInfoStream.sink.add(BaseTokenInfo.empty());

  @override
  bool get isAuthorized => _tokenInfoStream.value.isAuthorized == true;

  @override
  Stream<BaseTokenInfo> get tokenInfoStream => _tokenInfoStream
      .distinct(
        (previous, next) =>
            previous.accessToken == next.accessToken &&
            previous.refreshToken == next.refreshToken,
      )
      .asBroadcastStream();
}
