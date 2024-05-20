import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwd/common/data/mappers/remote_configurations_mapper.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:rxdart/rxdart.dart';

final class RemoteConfigurationProviderImpl
    implements RemoteConfigurationProvider {
  final SecureStorageBox _storage;

  RemoteConfigurationProviderImpl({required SecureStorageBox storage})
      : _storage = storage; // {}

  late final BehaviorSubject<RemoteConfigurations> _configuration =
      BehaviorSubject<RemoteConfigurations>.seeded(
    RemoteConfigurations.empty(),
    onListen: () {
      _storage.readConfiguration().then(
            (e) => _configuration.sink.add(e),
          );
    },
  );

  @override
  RemoteConfigurations get currentConfiguration => _configuration.value;

  @override
  Stream<RemoteConfigurations> get configuration => _configuration;

  @override
  Future<void> setConfigurations(
    RemoteConfigurations configurations,
  ) async {
    await _storage.writeConfigurations(configurations);
    final result = await _storage.readConfiguration();
    _configuration.sink.add(result);
  }
}

class SecureStorageBox {
  static const String _jsonSharedPreferencesKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';

  final _storage = const FlutterSecureStorage();

  const SecureStorageBox();

  Future<RemoteConfigurations> readConfiguration() async {
    final json = await _storage.read(key: _jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return RemoteConfigurations.empty();
    } else {
      final jsonMap = jsonDecode(json);
      final data = RemoteStorageConfigurationsData.fromJson(jsonMap);

      return RemoteConfigurationsMapper.toDomain(data);
    }
  }

  Future<void> writeConfigurations(
    RemoteConfigurations configurations,
  ) async {
    if (configurations.isNotEmpty) {
      final data = RemoteConfigurationsMapper.toData(configurations);

      final jsonStr = jsonEncode(data.toJson());

      return _storage.write(
        key: _jsonSharedPreferencesKey,
        value: jsonStr,
      );
    } else {
      return _storage.delete(key: _jsonSharedPreferencesKey);
    }
  }
}
