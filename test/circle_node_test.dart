import 'package:flutter_test/flutter_test.dart';
import 'package:circular_treemap/circular_treemap.dart';

void main() {
  group('CircleNode', () {
    test('should create a leaf node correctly', () {
      final node = CircleNode(label: 'Leaf', value: 10.0);
      expect(node.label, 'Leaf');
      expect(node.value, 10.0);
      expect(node.children, isEmpty);
    });

    test('should create a parent node with children', () {
      final child1 = CircleNode(label: 'Child 1', value: 5.0);
      final child2 = CircleNode(label: 'Child 2', value: 5.0);
      final parent = CircleNode(label: 'Parent', children: [child1, child2]);

      expect(parent.label, 'Parent');
      expect(parent.children.length, 2);
      // Value should be aggregated
      expect(parent.value, 10.0);
    });

    test('should convert from Map correctly', () {
      final json = {
        'label': 'Root',
        'children': [
          {'label': 'A', 'value': 10.0},
          {'label': 'B', 'value': 20.0},
        ],
      };

      final node = CircleNode.fromMap(json);
      expect(node.label, 'Root');
      expect(node.children.length, 2);
      expect(node.value, 30.0);
    });
  });
}
