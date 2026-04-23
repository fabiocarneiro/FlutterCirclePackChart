import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circle_pack_chart/circle_pack_chart.dart';

void main() {
  testWidgets('CirclePackChartPainter should render circles', (
    WidgetTester tester,
  ) async {
    final root = CircleNode(label: 'Root', value: 100.0);
    final packedNode = CirclePacker.pack(root, radius: 100.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CustomPaint(
              painter: CirclePackChartPainter(
                root: packedNode,
                focusedNode: root,
                animationValue: 1.0,
                isDrillingIn: true,
                cameraScale: 1.0,
                baseFontSize: 12.0,
              ),
              size: const Size(200, 200),
            ),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is CirclePackChartPainter,
      ),
      findsOneWidget,
    );
  });
}
