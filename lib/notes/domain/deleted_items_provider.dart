import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

abstract interface class DeletedItemsProvider {
  Future<Set<String>> getDeletedItems({
    required RemoteConfiguration configuration,
  });
  Future<void> addDeletedItems(
    Set<String> items, {
    required RemoteConfiguration configuration,
  });
  Future<void> dropDeletedItems({
    required RemoteConfiguration configuration,
  });
}
