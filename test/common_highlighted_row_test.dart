import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';

void main() {
  testWidgets('CommonHighlightedRow', (WidgetTester tester) async {
    final List<String> log = <String>[];

    final testWidget = MaterialApp(
      home: CommonHighlightedRow(
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
