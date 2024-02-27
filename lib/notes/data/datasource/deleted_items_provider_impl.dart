import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DeletedItemsProviderImpl implements DeletedItemsProvider {
  static String _sharedPreferencesKey(RemoteConfiguration configuration) =>
      'DeletedItemsProviderImpl.DeletedItemsKey.${configuration.type.toString()}.${configuration.localCacheFileName}';

  const DeletedItemsProviderImpl();

  @override
  Future<Set<String>> getDeletedItems({
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();

    return storage
            .getStringList(_sharedPreferencesKey(configuration))
            ?.whereType<String>()
            .toSet() ??
        {};
  }

  @override
  Future<void> addDeletedItems(
    Set<String> items, {
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();

    var deleted = await getDeletedItems(configuration: configuration);
    deleted.addAll(items);

    storage.setStringList(
      _sharedPreferencesKey(configuration),
      deleted.toList(),
    );
  }

  @override
  Future<void> dropDeletedItems({
    required RemoteConfiguration configuration,
  }) async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(_sharedPreferencesKey(configuration));
  }
}
