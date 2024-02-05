abstract interface class DeletedItemsProvider {
  Future<Set<String>> getDeletedItems();
  Future<void> addDeletedItems(Set<String> items);
  Future<void> dropDeletedItems();
}
