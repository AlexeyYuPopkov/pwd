final class AppSettings {
  static const defaultKeyboardTyupe = EnterPinKeyboardType.password;

  final Duration maxInactiveDuration;
  final EnterPinKeyboardType enterPinKeyboardType;

  AppSettings({
    this.maxInactiveDuration = const Duration(seconds: 15),
    this.enterPinKeyboardType = defaultKeyboardTyupe,
  });
}

enum EnterPinKeyboardType {
  number,
  password,
}
