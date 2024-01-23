import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DeletedItemsProviderImpl implements DeletedItemsProvider {
  static const String _sharedPreferencesKey =
      'DeletedItemsProviderImpl.DeletedItemsKey';

  const DeletedItemsProviderImpl();

  @override
  Future<Set<String>> getDeletedItems() async {
    final storage = await SharedPreferences.getInstance();

    return storage
            .getStringList(_sharedPreferencesKey)
            ?.whereType<String>()
            .toSet() ??
        {};
  }

  @override
  Future<void> addDeletedItems(Set<String> items) async {
    final storage = await SharedPreferences.getInstance();

    var deleted = await getDeletedItems();
    deleted.addAll(items);

    storage.setStringList(
      _sharedPreferencesKey,
      deleted.toList(),
    );
  }

  @override
  Future<void> dropDeletedItems() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(_sharedPreferencesKey);
  }
}
