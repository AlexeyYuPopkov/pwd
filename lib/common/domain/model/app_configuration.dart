class AppConfiguration {
  final String? proxyIp;
  final String? proxyPort;

  const AppConfiguration({
    required this.proxyIp,
    required this.proxyPort,
  });

  factory AppConfiguration.empty() => const AppConfiguration(
        proxyIp: null,
        proxyPort: null,
      );
}
