import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:pwd/common/data/cache_token_data_source.dart';
import 'package:pwd/common/data/network_error_mapper_impl.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/domain/token_repository.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

const _scheme = 'https';
const _host = '';
String get _baseUrl => '$_scheme://$_host';
const _proxyIp = '127.0.0.1';
const _proxyPort = '8888';

// const _proxyIp = '';
// const _proxyPort = '';

typedef UnAuthDio = Dio;
typedef AuthDio = Dio;

class NetworkDiModule extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<NetworkErrorMapper>(() => NetworkErrorMapperImpl());

    di.bind<TokenRepository>(() => CacheTokenDataSource());

    final dioOptions = _createDioOptions(di);

    di.bind<UnAuthDio>(
      () {
        final dio = Dio(dioOptions);
        return _adjustedDioProxyIfNeeded(dio);
      },
      lifeTime: const LifeTime.single(),
    );

    di.bind<AuthDio>(
      () {
        final dio = Dio(dioOptions)
          ..interceptors.addAll(
            [
              // OAuthBearerInterceptor(tokenRepository: di.resolve()),
            ],
          );
        return _adjustedDioProxyIfNeeded(dio);
      },
      lifeTime: const LifeTime.single(),
    );
  }

  BaseOptions _createDioOptions(DiStorage di) {
    const connectTimeout = 60 * 1000;
    const receiveTimeout = 60 * 1000;
    const sendTimeout = 60 * 1000;

    return BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
  }

  Dio _adjustedDioProxyIfNeeded(Dio dio) {
    if (!kIsWeb && kDebugMode) {
      var adapter = dio.httpClientAdapter;

      if (adapter is DefaultHttpClientAdapter) {
        adapter.onHttpClientCreate = _configureHttpClient(
          [_host],
          _proxyIp,
          int.tryParse(_proxyPort) ?? 0,
        );
      }
    }
    return dio;
  }

  dynamic _configureHttpClient(
    List<String> allowHostsWithBadCertificates,
    String proxyIp,
    int proxyPort,
  ) {
    return (HttpClient httpClient) {
      if (kDebugMode) {
        final isProxyAvailable = proxyIp.isNotEmpty && proxyPort != 0;
        httpClient.findProxy = isProxyAvailable
            ? (url) => 'PROXY $proxyIp:$proxyPort;'
            : (url) => 'DIRECT';

        debugPrint('PROXY: $proxyIp:$proxyPort;');

        httpClient.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            allowHostsWithBadCertificates.contains(host);
      }

      return httpClient;
    };
  }
}
