import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';

import 'test_tools/test_tools.dart';

void main() {
  testWidgets('CommonHighlightedRow', (WidgetTester tester) async {
    final List<String> log = <String>[];

    final testWidget = CreateApp.createMaterialApp(
      child: CommonHighlightedRow(
        child: const Text('123'),
        onTap: () => log.add('tap'),
      ),
    );

    await tester.pumpWidget(testWidget);
    expect(find.text('123'), findsOneWidget);
    expect(log.isEmpty, true);
    await tester.tap(find.byType(InkWell));
    expect(log.first == 'tap', true);
  });
}
