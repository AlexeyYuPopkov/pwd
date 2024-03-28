import 'dart:convert';

import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/clock_model_data.dart';

class ClockConfigurationProviderImpl implements ClockConfigurationProvider {
  static const String _jsonSharedPreferencesKey =
      'ClockConfigurationProviderImpl.Clocks';

  @override
  Future<List<ClockModel>> get clocks async {
    final storage = await SharedPreferences.getInstance();
    final json = storage.getString(_jsonSharedPreferencesKey);

    if (json == null || json.isEmpty) {
      return [];
    } else {
      final jsonMap = jsonDecode(json);
      if (jsonMap is Map<String, dynamic>) {
        return jsonMap.toClockModelList();
      } else {
        assert(
          jsonMap is Map<String, dynamic>,
          'ClockConfigurationProviderImpl: mapping error',
        );
        return [];
      }
    }
  }

  @override
  Future<void> setClocks(List<ClockModel> clocks) async {
    final jsonStr = jsonEncode(clocks.toJson());
    final storage = await SharedPreferences.getInstance();
    await storage.setString(_jsonSharedPreferencesKey, jsonStr);
  }
}

extension on Map<String, dynamic> {
  List<ClockModel> toClockModelList() {
    return ClocksModelData.fromJson(this)
        .content
        .map(
          (src) => ClockModel(
            id: src.id,
            label: src.label,
            timeZoneOffset: Duration(seconds: src.timezoneOffsetInSeconds),
          ),
        )
        .toList();
  }
}

extension on List<ClockModel> {
  Map<String, dynamic> toJson() => ClocksModelData(
        content: map(
          (src) => ClockModelData(
            id: src.id,
            label: src.label,
            timezoneOffsetInSeconds: src.timeZoneOffset.inSeconds,
          ),
        ),
      ).toJson();
}
