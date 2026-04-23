import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circle_pack_chart/circle_pack_chart.dart';

void main() {
  testWidgets('CirclePackChart should animate on drill down', (
    WidgetTester tester,
  ) async {
    final child = CircleNode(
      label: 'Child',
      children: [CircleNode(label: 'Leaf', value: 10.0)],
    );
    final root = CircleNode(label: 'Root', children: [child]);

    final controller = CirclePackChartController(root: root);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            height: 500,
            child: CirclePackChart(root: root, controller: controller),
          ),
        ),
      ),
    );

    // Initial state
    expect(find.byType(CirclePackChart), findsOneWidget);

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
