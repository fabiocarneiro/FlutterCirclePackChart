import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  testWidgets('FlutterCirclePackChartLegend should work with explicit controller and data', (
    WidgetTester tester,
  ) async {
    final children = [
      CircleNode(label: 'A', value: 10, color: Colors.red),
      CircleNode(label: 'B', value: 20, color: Colors.blue),
    ];
    final controller = CirclePackChartController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlutterCirclePackChartLegend(
            controller: controller,
            children: children,
            title: 'Test Root',
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('FlutterCirclePackChartLegend should work with CirclePackProvider', (
    WidgetTester tester,
  ) async {
    final children = [
      CircleNode(label: 'A', value: 10, color: Colors.red),
      CircleNode(label: 'B', value: 20, color: Colors.blue),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CirclePackProvider(
            children: children,
            title: 'Scope Root',
            child: const FlutterCirclePackChartLegend(),
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
