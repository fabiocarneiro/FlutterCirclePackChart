import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  testWidgets('FlutterCirclePackChart should animate on drill down', (
    WidgetTester tester,
  ) async {
    final child = CircleNode(
      label: 'Child',
      children: [CircleNode(label: 'Leaf', value: 10.0)],
    );
    final children = [child];

    final controller = FlutterCirclePackChartController(children: children);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            height: 500,
            child: FlutterCirclePackChart(
              children: children,
              title: 'Root',
              controller: controller,
            ),
          ),
        ),
      ),
    );

    // Initial state
    expect(find.byType(FlutterCirclePackChart), findsOneWidget);

    // Trigger drill down
    controller.drillDown(child);

    // Pump one frame to start animation
    await tester.pump();

    // Verify animation is running
    expect(tester.hasRunningAnimations, isTrue);

    // Wait for animation to complete
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });
}
