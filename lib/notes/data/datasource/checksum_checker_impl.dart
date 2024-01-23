import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class ChecksumCheckerImpl implements ChecksumChecker {
  static const String _sharedPreferencesKey = 'ChecksumChecker.ChecksumKey';

  const ChecksumCheckerImpl();

  @override
  Future<String?> getChecksum() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(_sharedPreferencesKey);
  }

  @override
  Future<void> setChecksum(String checksum) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(_sharedPreferencesKey, checksum);
  }

  @override
  Future<void> dropChecksum() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(_sharedPreferencesKey);
  }
}
