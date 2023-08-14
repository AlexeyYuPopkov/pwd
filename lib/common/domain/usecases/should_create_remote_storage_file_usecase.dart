class ShouldCreateRemoteStorageFileUsecase {
  static ShouldCreateRemoteStorageFileUsecase? _instance;

  ShouldCreateRemoteStorageFileUsecase._();

  factory ShouldCreateRemoteStorageFileUsecase() =>
      _instance ??= ShouldCreateRemoteStorageFileUsecase._();

  bool _value = false;

  bool get flag {
    final result = _value;
    if (result) {
      setFlag(false);
    }

    return result;
  }

  void setFlag(bool flag) {
    _value = flag;
  }
}
