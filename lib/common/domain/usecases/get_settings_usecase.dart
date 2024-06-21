import 'dart:async';

import 'package:pwd/common/domain/model/app_settings.dart';

// import 'package:googleapis/calendar/v3.dart';

class GetSettingsUsecase {
  FutureOr<AppSettings> execute() {
    return AppSettings(
      enterPinKeyboardType: EnterPinKeyboardType.number,
    );
  }
}
