import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circle_pack_chart/circle_pack_chart.dart';

void main() {
  testWidgets('CirclePackChartLegend should display items for focused node', (
    WidgetTester tester,
  ) async {
    final root = CircleNode(
      label: 'Root',
      children: [
        CircleNode(label: 'A', value: 10, color: Colors.red),
        CircleNode(label: 'B', value: 20, color: Colors.blue),
      ],
    );
    final controller = CirclePackChartController(root: root);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CirclePackChartLegend(controller: controller)),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
