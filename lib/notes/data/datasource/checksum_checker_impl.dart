import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class ChecksumCheckerImpl implements ChecksumChecker {
  static String _sharedPreferencesKey(RemoteConfiguration configuration) =>
      'ChecksumChecker.ChecksumKey.${configuration.type.toString()}.${configuration.cacheFileName}';

  const ChecksumCheckerImpl();

  @override
  Future<String?> getChecksum({
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();

    return storage.getString(_sharedPreferencesKey(configuration));
  }

  @override
  Future<void> setChecksum(
    String checksum, {
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString(_sharedPreferencesKey(configuration), checksum);
  }

  @override
  Future<void> dropChecksum({
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove(_sharedPreferencesKey(configuration));
  }
}
