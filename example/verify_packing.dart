import 'package:circular_treemap/circular_treemap.dart';
import 'dart:math';

void main() {
  final root = CircleNode(
    label: 'Root',
    children: [
      CircleNode(
        label: 'A',
        children: [
          CircleNode(label: 'A1', value: 10.0),
          CircleNode(label: 'A2', value: 20.0),
        ],
      ),
      CircleNode(label: 'B', value: 30.0),
    ],
  );

  print('Packing root with radius 100.0...');
  final packedRoot = CirclePacker.pack(root, radius: 100.0);

  _printNode(packedRoot, 0);
}

void _printNode(PackedNode node, int depth) {
  final indent = '  ' * depth;
  print('${indent}Node: ${node.node.label}, x: ${node.x.toStringAsFixed(2)}, y: ${node.y.toStringAsFixed(2)}, r: ${node.r.toStringAsFixed(2)}');
  for (final child in node.children) {
    _printNode(child, depth + 1);
    
    // Simple verification check
    final dist = sqrt(pow(child.x - node.x, 2) + pow(child.y - node.y, 2));
    if (dist + child.r > node.r + 0.001) {
      print('${indent}  WARNING: Child ${child.node.label} exceeds parent ${node.node.label} boundary!');
    }
  }
}
