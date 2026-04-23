import 'dart:ui';

/// Represents the visual state of a node at a specific point in an animation.
class NodeTransform {
  final double x;
  final double y;
  final double r;
  final double opacity;

  const NodeTransform({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
  });

  /// Linearly interpolates between two [NodeTransform]s.
  static NodeTransform? lerp(NodeTransform? a, NodeTransform? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return NodeTransform(
      x: lerpDouble(a.x, b.x, t)!,
      y: lerpDouble(a.y, b.y, t)!,
      r: lerpDouble(a.r, b.r, t)!,
      opacity: lerpDouble(a.opacity, b.opacity, t)!,
    );
  }
}
