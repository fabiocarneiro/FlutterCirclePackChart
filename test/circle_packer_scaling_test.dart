import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  test('CirclePacker scales relative to total value, not absolute sqrt', () {
    // Case 1: Values 50 and 930
    final root1 = CircleNode(
      label: 'Root',
      children: [
        CircleNode(label: 'Small', value: 50),
        CircleNode(label: 'Large', value: 930),
      ],
    );

    final packed1 = CirclePacker.pack(root1, radius: 100, minRadiusRatio: 0.1);
    final small1 = packed1.children.firstWhere((c) => c.node.label == 'Small');
    final large1 = packed1.children.firstWhere((c) => c.node.label == 'Large');

    // Case 2: Values 500 and 9300 (10x larger values, same ratio)
    final root2 = CircleNode(
      label: 'Root',
      children: [
        CircleNode(label: 'Small', value: 500),
        CircleNode(label: 'Large', value: 9300),
      ],
    );

    final packed2 = CirclePacker.pack(root2, radius: 100, minRadiusRatio: 0.1);
    final small2 = packed2.children.firstWhere((c) => c.node.label == 'Small');
    final large2 = packed2.children.firstWhere((c) => c.node.label == 'Large');

    // They SHOULD have the same radii in both cases because the total radius is fixed to 100.
    expect(small1.r, closeTo(small2.r, 0.01), reason: 'Small node radius should be invariant to absolute scale');
    expect(large1.r, closeTo(large2.r, 0.01), reason: 'Large node radius should be invariant to absolute scale');
    
    // The ratio should be sqrt(930/50) = 4.31
    expect(large1.r / small1.r, closeTo(4.31, 0.01));
  });
}
