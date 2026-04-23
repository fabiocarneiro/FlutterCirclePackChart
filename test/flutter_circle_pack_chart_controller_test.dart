import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  group('FlutterCirclePackChartController', () {
    test('should start with root as focused node', () {
      final root = CircleNode(label: 'Root');
      final controller = FlutterCirclePackChartController(root: root);
      expect(controller.value, root);
      expect(controller.canGoBack, isFalse);
    });

    test('should drill down to child', () {
      final leaf = CircleNode(label: 'Leaf', value: 10.0);
      final child = CircleNode(label: 'Child', children: [leaf]);
      final root = CircleNode(label: 'Root', children: [child]);
      final controller = FlutterCirclePackChartController(root: root);

      controller.drillDown(child);
      expect(controller.value, child);
      expect(controller.canGoBack, isTrue);
    });

    test('should go back to parent', () {
      final leaf = CircleNode(label: 'Leaf', value: 10.0);
      final child = CircleNode(label: 'Child', children: [leaf]);
      final root = CircleNode(label: 'Root', children: [child]);
      final controller = FlutterCirclePackChartController(root: root);

      controller.drillDown(child);
      controller.goBack();
      expect(controller.value, root);
      expect(controller.canGoBack, isFalse);
    });
  });
}
