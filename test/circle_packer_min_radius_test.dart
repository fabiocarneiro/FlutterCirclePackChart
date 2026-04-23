import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  group('CirclePacker - Minimum Radius', () {
    test('should enforce minRadius for very small values', () {
      final root = CircleNode(
        label: 'Root',
        children: [
          CircleNode(label: 'Big', value: 1000.0),
          CircleNode(label: 'Tiny', value: 0.0001), // Almost zero
        ],
      );

      // With radius 100 and minRadiusRatio 0.2, minR should be 20.
      final packedRoot = CirclePacker.pack(
        root,
        radius: 100.0,
        minRadiusRatio: 0.2,
      );

      final big = packedRoot.children.firstWhere((c) => c.node.label == 'Big');
      final tiny = packedRoot.children.firstWhere(
        (c) => c.node.label == 'Tiny',
      );

      expect(tiny.r, greaterThanOrEqualTo(19.99)); // Allowing for precision
      expect(big.r, greaterThan(tiny.r));
    });
  });
}
