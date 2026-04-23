import 'dart:math';
import 'circular_treemap.dart';

/// Represents a node that has been positioned and sized in the treemap.
class PackedNode {
  /// The underlying data node.
  final CircleNode node;

  /// The x-coordinate of the center (relative to parent or global).
  final double x;

  /// The y-coordinate of the center (relative to parent or global).
  final double y;

  /// The radius of the circle.
  final double r;

  /// The children of this node, also packed.
  final List<PackedNode> children;

  PackedNode({
    required this.node,
    required this.x,
    required this.y,
    required this.r,
    this.children = const [],
  });
}

/// Helper class to perform circle packing calculations.
class CirclePacker {
  /// Packs the [root] node and its children into a circle with the given [radius].
  /// [minRadiusRatio] defines the minimum radius of a child circle as a fraction
  /// of the parent radius (default is 0.1, meaning 10% of parent).
  static PackedNode pack(CircleNode root, {required double radius, double minRadiusRatio = 0.1}) {
    return _packNode(root, 0.0, 0.0, radius, minRadiusRatio);
  }

  static PackedNode _packNode(CircleNode node, double x, double y, double r, double minRadiusRatio) {
    if (node.children.isEmpty) {
      return PackedNode(node: node, x: x, y: y, r: r);
    }

    final double totalValue = node.value;
    if (totalValue == 0) {
      return PackedNode(node: node, x: x, y: y, r: r);
    }

    // Calculate initial radii based on value (area proportional to value).
    // We enforce a minimum radius here.
    final double minR = r * minRadiusRatio;
    
    final List<_Circle> circles = node.children.map((child) {
      final double calculatedR = sqrt(child.value);
      // Ensure it doesn't fall below minR. 
      // We use a simple max here; the packing algorithm will handle the layout.
      return _Circle(radius: max(calculatedR, minR));
    }).toList();

    _packCircles(circles);

    // Center the packed circles around the origin before scaling.
    if (circles.isNotEmpty) {
      double minX = double.infinity, maxX = -double.infinity;
      double minY = double.infinity, maxY = -double.infinity;
      for (final c in circles) {
        minX = min(minX, c.x - c.radius);
        maxX = max(maxX, c.x + c.radius);
        minY = min(minY, c.y - c.radius);
        maxY = max(maxY, c.y + c.radius);
      }

      final double midX = (minX + maxX) / 2;
      final double midY = (minY + maxY) / 2;

      for (final c in circles) {
        c.x -= midX;
        c.y -= midY;
      }
    }

    // Find the bounding circle of the packed results to scale them into the parent.
    double maxDist = 0;
    for (final c in circles) {
      maxDist = max(maxDist, sqrt(c.x * c.x + c.y * c.y) + c.radius);
    }

    // Scale back to parent r.
    final double scale = maxDist > 0 ? r / maxDist : 1.0;

    final List<PackedNode> packedChildren = [];
    for (int i = 0; i < node.children.length; i++) {
      final c = circles[i];
      packedChildren.add(_packNode(
        node.children[i],
        x + c.x * scale,
        y + c.y * scale,
        c.radius * scale,
        minRadiusRatio,
      ));
    }

    return PackedNode(
      node: node,
      x: x,
      y: y,
      r: r,
      children: packedChildren,
    );
  }

  /// Simple circle packing algorithm.
  static void _packCircles(List<_Circle> circles) {
    if (circles.isEmpty) return;

    // 1. Place the first circle at the origin.
    circles[0].x = 0;
    circles[0].y = 0;
    if (circles.length == 1) return;

    // 2. Place the second circle touching the first.
    circles[1].x = circles[0].radius + circles[1].radius;
    circles[1].y = 0;
    if (circles.length == 2) {
      final double offset = circles[1].x / 2;
      circles[0].x -= offset;
      circles[1].x -= offset;
      return;
    }

    // 3. Place subsequent circles touching two previous circles.
    for (int i = 2; i < circles.length; i++) {
      _placeCircle(circles, i);
    }
  }

  static void _placeCircle(List<_Circle> circles, int index) {
    final _Circle current = circles[index];
    double minDistanceToOrigin = double.infinity;
    double bestX = 0;
    double bestY = 0;

    for (int i = 0; i < index; i++) {
      for (int j = i + 1; j < index; j++) {
        final c1 = circles[i];
        final c2 = circles[j];
        final results = _findTouchPoints(c1, c2, current.radius);
        for (final p in results) {
          if (!_overlapsAny(p.x, p.y, current.radius, circles, index)) {
            final d = p.x * p.x + p.y * p.y;
            if (d < minDistanceToOrigin) {
              minDistanceToOrigin = d;
              bestX = p.x;
              bestY = p.y;
            }
          }
        }
      }
    }
    
    if (minDistanceToOrigin == double.infinity) {
        bestX = index * 100.0;
        bestY = 0;
    }

    current.x = bestX;
    current.y = bestY;
  }

  static List<Point<double>> _findTouchPoints(_Circle c1, _Circle c2, double r) {
    final double d2 = (pow(c1.x - c2.x, 2) + pow(c1.y - c2.y, 2)).toDouble();
    final double d = sqrt(d2);
    final double r1 = c1.radius + r;
    final double r2 = c2.radius + r;

    if (d > r1 + r2 || d < (r1 - r2).abs() || d == 0) return [];

    final double a = (r1 * r1 - r2 * r2 + d2) / (2 * d);
    final double h = sqrt(max(0, r1 * r1 - a * a));
    final double x2 = c1.x + a * (c2.x - c1.x) / d;
    final double y2 = c1.y + a * (c2.y - c1.y) / d;

    return [
      Point(x2 + h * (c2.y - c1.y) / d, y2 - h * (c2.x - c1.x) / d),
      Point(x2 - h * (c2.y - c1.y) / d, y2 + h * (c2.x - c1.x) / d),
    ];
  }

  static bool _overlapsAny(double x, double y, double r, List<_Circle> circles, int count) {
    for (int i = 0; i < count; i++) {
      final c = circles[i];
      final dist2 = pow(x - c.x, 2) + pow(y - c.y, 2);
      if (dist2 < pow(r + c.radius - 0.001, 2)) return true;
    }
    return false;
  }
}

class _Circle {
  final double radius;
  double x = 0;
  double y = 0;
  _Circle({required this.radius});
}
