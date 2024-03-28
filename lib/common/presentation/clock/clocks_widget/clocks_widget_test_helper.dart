import 'package:pwd/common/domain/model/clock_model.dart';

final class ClocksWidgetTestHelper {
  static String clockItemKey(int index) => 'ClocksWidget.ClockItemKey.$index';
  static String clockWidgetKey(ClockModel clock) =>
      'ClocksWidget.ClockWidget.${clock.hashCode}';
}
