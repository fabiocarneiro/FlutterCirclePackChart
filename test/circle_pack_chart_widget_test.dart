import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circle_pack_chart/circle_pack_chart.dart';

void main() {
  testWidgets('CirclePackChart widget should render', (
    WidgetTester tester,
  ) async {
    final root = CircleNode(
      label: 'Root',
      children: [
        CircleNode(label: 'A', value: 10.0),
        CircleNode(label: 'B', value: 20.0),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            height: 500,
            child: CirclePackChart(root: root),
          ),
        ),
      ),
    );

    expect(find.byType(CirclePackChart), findsOneWidget);
  });
}
