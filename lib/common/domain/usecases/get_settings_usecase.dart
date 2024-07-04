import 'dart:async';

import 'package:pwd/common/domain/model/app_settings.dart';

class GetSettingsUsecase {
  FutureOr<AppSettings> execute() {
    return AppSettings(
      enterPinKeyboardType: EnterPinKeyboardType.number,
    );
  }
}
