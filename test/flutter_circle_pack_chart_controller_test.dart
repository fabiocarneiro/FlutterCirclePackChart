import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  group('FlutterCirclePackChartController', () {
    test('should start with null (Top Level) as focused node', () {
      final children = [CircleNode(label: 'Child 1', value: 10.0)];
      final controller = FlutterCirclePackChartController(children: children);
      expect(controller.value, isNull);
      expect(controller.canGoBack, isFalse);
    });

    test('should drill down to child', () {
      final leaf = CircleNode(label: 'Leaf', value: 10.0);
      final child = CircleNode(label: 'Child', children: [leaf]);
      final children = [child];
      final controller = FlutterCirclePackChartController(children: children);

      controller.drillDown(child);
      expect(controller.value, child);
      expect(controller.canGoBack, isTrue);
    });

    test('should go back to parent', () {
      final leaf = CircleNode(label: 'Leaf', value: 10.0);
      final child = CircleNode(label: 'Child', children: [leaf]);
      final children = [child];
      final controller = FlutterCirclePackChartController(children: children);

      controller.drillDown(child);
      controller.goBack();
      expect(controller.value, isNull);
      expect(controller.canGoBack, isFalse);
    });
  });
}
