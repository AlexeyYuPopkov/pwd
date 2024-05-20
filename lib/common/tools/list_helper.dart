mixin ListHelper {
  List<T> moveItem<T>({
    required List<T> src,
    required int oldIndex,
    required int newIndex,
  }) {
    if (oldIndex == newIndex) {
      return List.unmodifiable(src);
    }

    assert(oldIndex >= 0 && oldIndex < src.length);
    assert(newIndex >= 0 && newIndex < src.length);

    var items = List.from(src);

    // var newIndexVar = newIndex;
    // if (oldIndex < newIndexVar) {
    //   newIndexVar -= 1;
    // }

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    return List.unmodifiable(items);
  }

  bool isEqual<T>(List<T> one, List<T> other) => one.isEqual(other);
}

extension on List {
  bool isEqual<T>(List<T> other) {
    if (identical(this, other)) {
      return true;
    }

    if (runtimeType != other.runtimeType) {
      return false;
    }

    if (isEmpty != other.isEmpty) {
      return false;
    }

    final thisLength = length;

    if (thisLength != other.length) {
      return false;
    }

    for (int i = 0; i < thisLength; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
