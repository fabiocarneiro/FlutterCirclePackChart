import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  testWidgets('FlutterCirclePackChartPainter should render', (
    WidgetTester tester,
  ) async {
    final root = CircleNode(
      label: 'Root',
      children: [CircleNode(label: 'Child', value: 10.0)],
    );
    final packedRoot = CirclePacker.pack(root, radius: 100.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPaint(
            painter: FlutterCirclePackChartPainter(
              root: packedRoot,
              focusedNode: null,
              animationValue: 1.0,
              isDrillingIn: true,
              cameraScale: 1.0,
              baseFontSize: 12.0,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is FlutterCirclePackChartPainter,
      ),
      findsOneWidget,
    );
  });
}
