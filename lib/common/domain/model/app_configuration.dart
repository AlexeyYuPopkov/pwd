import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class AppConfiguration extends Equatable {
  final ProxyAppConfiguration? proxyData;
  final bool showRawErrors;

  const AppConfiguration({
    required this.proxyData,
    required this.showRawErrors,
  });

  factory AppConfiguration.defaultConfiguration() => const AppConfiguration(
        proxyData: null,
        showRawErrors: false,
      );

  @override
  List<Object?> get props => [proxyData, showRawErrors];
}

@immutable
final class ProxyAppConfiguration extends Equatable {
  final String ip;
  final String port;

  const ProxyAppConfiguration({
    required this.ip,
    required this.port,
  });

  bool get isEmpty => ip.isEmpty || port.isEmpty;

  @override
  List<Object?> get props => [ip, port];
}
