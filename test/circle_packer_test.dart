import 'package:flutter_test/flutter_test.dart';
import 'package:circular_treemap/circular_treemap.dart';
import 'dart:math';

void main() {
  group('CirclePacker', () {
    test('should pack a single child in the center', () {
      final root = CircleNode(
        label: 'Root',
        children: [CircleNode(label: 'Child', value: 10.0)],
      );

      final packedRoot = CirclePacker.pack(root, radius: 100.0);

      expect(packedRoot.children.length, 1);
      final child = packedRoot.children.first;
      // For a single child, it should be centered and fill the area if it's the only one
      // Actually, standard packing might just put it at 0,0 with root radius
      expect(child.x, closeTo(0.0, 0.001));
      expect(child.y, closeTo(0.0, 0.001));
      expect(child.r, closeTo(100.0, 0.001));
    });

    test('should pack multiple children within the root radius', () {
      final root = CircleNode(
        label: 'Root',
        children: [
          CircleNode(label: 'A', value: 10.0),
          CircleNode(label: 'B', value: 10.0),
          CircleNode(label: 'C', value: 10.0),
        ],
      );

      final packedRoot = CirclePacker.pack(root, radius: 100.0);

      expect(packedRoot.children.length, 3);
      for (final child in packedRoot.children) {
        // Distance from center + radius should be <= root radius
        final dist = sqrt(child.x * child.x + child.y * child.y);
        expect(dist + child.r, lessThanOrEqualTo(100.001));
      }
    });

    test('should pack children without significant overlap', () {
      final root = CircleNode(
        label: 'Root',
        children: [
          CircleNode(label: 'A', value: 10.0),
          CircleNode(label: 'B', value: 10.0),
          CircleNode(label: 'C', value: 10.0),
        ],
      );

      final packedRoot = CirclePacker.pack(root, radius: 100.0);
      final children = packedRoot.children;

      for (int i = 0; i < children.length; i++) {
        for (int j = i + 1; j < children.length; j++) {
          final c1 = children[i];
          final c2 = children[j];
          final dist = sqrt(pow(c1.x - c2.x, 2) + pow(c1.y - c2.y, 2));
          // Distance should be >= sum of radii (allowing for small float precision)
          expect(dist, greaterThanOrEqualTo(c1.r + c2.r - 0.001));
        }
      }
    });
  });
}
