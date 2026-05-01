import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  testWidgets('FlutterCirclePackChart should animate on drill down (Implicit Controller)', (
    WidgetTester tester,
  ) async {
    final child = CircleNode(
      label: 'Child',
      children: [CircleNode(label: 'Leaf', value: 10.0)],
    );
    final children = [child];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            height: 500,
            child: FlutterCirclePackChart(
              children: children,
              title: 'Root',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FlutterCirclePackChart), findsOneWidget);

    // Find the child circle and tap it to trigger drill down
    // Since we don't have an explicit controller to call drillDown on,
    // we must tap the UI.
    await tester.tap(find.byType(FlutterCirclePackChart));
    await tester.pump();

    // Verify animation started
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('FlutterCirclePackChart should work with Scope', (
    WidgetTester tester,
  ) async {
    final child = CircleNode(
      label: 'Child',
      children: [CircleNode(label: 'Leaf', value: 10.0)],
    );
    final children = [child];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CirclePackChart(
            children: children,
            title: 'Scope Root',
            child: const FlutterCirclePackChart(),
          ),
        ),
      ),
    );

    expect(find.byType(FlutterCirclePackChart), findsOneWidget);
  });
}
