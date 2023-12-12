import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'package:pwd/common/data/network_error_mapper_impl.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

typedef UnAuthDio = Dio;
typedef AuthDio = Dio;

class NetworkDiModule extends DiModule {
  @override
  void bind(DiStorage di) async {
    di.bind<NetworkErrorMapper>(
      module: this,
      () => NetworkErrorMapperImpl(),
    );

    final dioOptions = _createDioOptions(di);

    final AppConfigurationProvider appConfigurationProvider =
        di.resolve<AppConfigurationProvider>();
    final appConfiguration = await appConfigurationProvider.appConfiguration;

    di.bind<UnAuthDio>(
      module: this,
      () {
        final dio = Dio(dioOptions);
        return _adjustedDioProxyIfNeeded(
          dio: dio,
          proxy: appConfiguration.proxyIp ?? '',
          port: appConfiguration.proxyPort ?? '',
        );
      },
      lifeTime: const LifeTime.single(),
    );

    // di.bind<AuthDio>(
    //   module: this,
    //   () {
    //     final dio = Dio(dioOptions)
    //       ..interceptors.addAll(
    //         [
    //           // OAuthBearerInterceptor(tokenRepository: di.resolve()),
    //         ],
    //       );
    //     return _adjustedDioProxyIfNeeded(
    //       dio: dio,
    //       proxy: appConfiguration.proxyIp ?? '',
    //       port: appConfiguration.proxyPort ?? '',
    //     );
    //   },
    //   lifeTime: const LifeTime.single(),
    // );
  }

  BaseOptions _createDioOptions(DiStorage di) {
    // const connectTimeout = 60 * 1000;
    // const receiveTimeout = 60 * 1000;
    // const sendTimeout = 60 * 1000;

    return BaseOptions(
        // connectTimeout:  connectTimeout,
        // receiveTimeout: receiveTimeout,
        // sendTimeout: sendTimeout,
        );
  }

  Dio _adjustedDioProxyIfNeeded({
    required Dio dio,
    required String proxy,
    required String port,
  }) {
    if (!kIsWeb && kDebugMode) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          // Config the client.
          client.findProxy = (uri) {
            // Forward all request to proxy "localhost:8888".
            // Be aware, the proxy should went through you running device,
            // not the host platform.
            // return 'PROXY localhost:8888';

            if (kDebugMode) {
              final proxyPort = int.tryParse(port) ?? 0;
              final isProxyAvailable = proxy.isNotEmpty && proxyPort != 0;

              final result =
                  isProxyAvailable ? 'PROXY $proxy:$proxyPort' : 'DIRECT';

              debugPrint('PROXY: $result');

              return result;
            } else {
              return 'DIRECT';
            }
          };

          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

          return client;
        },
      );
    }

    return dio;
  }

  // dynamic _configureHttpClient({
  //   required Set<String> allowHostsWithBadCertificates,
  //   required String proxyIp,
  //   required int proxyPort,
  // }) {
  //   return (HttpClient httpClient) {
  //     if (kDebugMode) {
  //       final isProxyAvailable = proxyIp.isNotEmpty && proxyPort != 0;
  //       httpClient.findProxy = isProxyAvailable
  //           ? (url) => 'PROXY $proxyIp:$proxyPort;'
  //           : (url) => 'DIRECT';

  //       debugPrint('PROXY: $proxyIp:$proxyPort;');

  //       httpClient.badCertificateCallback = (
  //         X509Certificate cert,
  //         String host,
  //         int port,
  //       ) =>
  //           allowHostsWithBadCertificates.contains(host);
  //     }

  //     return httpClient;
  //   };
  // }
}
