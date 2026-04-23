import 'dart:ui';
import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';

/// A [CustomPainter] that renders a circular treemap with symmetric
/// explosion/implosion animations and anti-scaled labels.
class FlutterCirclePackChartPainter extends CustomPainter {
  /// The absolute root of the packed hierarchy.
  final PackedNode root;

  /// The currently focused node.
  final CircleNode focusedNode;

  /// The node that was focused before the current transition.
  final CircleNode? previousFocusedNode;

  /// The current progress of the animation (0.0 to 1.0).
  final double animationValue;

  /// Whether we are currently drilling deeper into the hierarchy.
  final bool isDrillingIn;

  /// The current camera scale applied to the view.
  final double cameraScale;

  /// The base font size for labels (anti-scaled).
  final double baseFontSize;

  FlutterCirclePackChartPainter({
    required this.root,
    required this.focusedNode,
    this.previousFocusedNode,
    required this.animationValue,
    required this.isDrillingIn,
    required this.cameraScale,
    required this.baseFontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    _drawNode(canvas, root, root.node.color ?? Colors.blue);
    canvas.restore();
  }

  void _drawNode(Canvas canvas, PackedNode node, Color parentColor) {
    final Color color = node.node.color ?? parentColor;

    if (node.node == focusedNode) {
      // Current focus level
      for (final child in node.children) {
        if (isDrillingIn) {
          // Drill In: children explode from parent center
          final double x = node.x + (child.x - node.x) * animationValue;
          final double y = node.y + (child.y - node.y) * animationValue;
          // Use parent radius (node.r) as start for interpolation
          final double r = lerpDouble(node.r, child.r, animationValue)!;
          _drawLeaf(canvas, x, y, r, child.node, color, opacity: 1.0);
        } else {
          // Drill Out: new focus is parent.
          if (child.node == previousFocusedNode && animationValue < 1.0) {
            _drawImplodingNode(canvas, child, color);
          } else {
            _drawLeaf(
              canvas,
              child.x,
              child.y,
              child.r,
              child.node,
              color,
              opacity: 1.0,
            );
          }
        }
      }
    } else if (_isAncestor(node.node, focusedNode)) {
      // Higher level ancestor: recurse
      for (final child in node.children) {
        _drawNode(canvas, child, color);
      }
    } else {
      // Sibling or unrelated branch
      _drawLeaf(canvas, node.x, node.y, node.r, node.node, color, opacity: 1.0);
    }
  }

  void _drawImplodingNode(Canvas canvas, PackedNode node, Color parentColor) {
    final Color color = node.node.color ?? parentColor;

    for (final child in node.children) {
      final double x = child.x + (node.x - child.x) * animationValue;
      final double y = child.y + (node.y - child.y) * animationValue;
      final double r = lerpDouble(child.r, node.r, animationValue)!;
      final double opacity = 1.0 - animationValue;
      _drawLeaf(canvas, x, y, r, child.node, color, opacity: opacity);
    }

    _drawLeaf(
      canvas,
      node.x,
      node.y,
      node.r,
      node.node,
      color,
      opacity: animationValue,
    );
  }

  void _drawLeaf(
    Canvas canvas,
    double x,
    double y,
    double r,
    CircleNode node,
    Color parentColor, {
    double opacity = 1.0,
  }) {
    if (opacity <= 0) return;

    final Color color = node.color ?? parentColor;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final double padding = r * 0.05;
    final double effectiveRadius = (r - padding).clamp(0.0, r);

    canvas.drawCircle(Offset(x, y), effectiveRadius, paint);

    _drawLabel(canvas, node, Offset(x, y), effectiveRadius, opacity);
  }

  bool _isAncestor(CircleNode potentialAncestor, CircleNode target) {
    if (potentialAncestor.children.isEmpty) return false;
    for (final child in potentialAncestor.children) {
      if (child == target) return true;
      if (_isAncestor(child, target)) return true;
    }
    return false;
  }
void _drawLabel(
  Canvas canvas,
  CircleNode node, // Pass the whole node to access secondaryLabel
  Offset center,
  double radius,
  double opacity,
) {
  // Use "Anti-Scaling": divide font size by cameraScale to keep it constant on screen.
  final double targetScreenSize = 12.0;
  final double fontSize = (targetScreenSize / cameraScale).clamp(0.1, 100.0);

  final String fullText = node.secondaryLabel != null
      ? '${node.secondaryLabel}\n${node.label}'
      : node.label;

  final textPainter = TextPainter(
    text: TextSpan(
      text: fullText,
      style: TextStyle(
        color: Colors.white.withValues(alpha: opacity),
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
    maxLines: 2,
    ellipsis: '...',
  );

  // Allow some overflow for tiny circles to ensure labels are visible.
  textPainter.layout(maxWidth: radius * 3.0);

  textPainter.paint(
    canvas,
    center - Offset(textPainter.width / 2, textPainter.height / 2),
  );
}

  @override
  bool shouldRepaint(covariant FlutterCirclePackChartPainter oldDelegate) {
    return oldDelegate.root != root ||
        oldDelegate.focusedNode != focusedNode ||
        oldDelegate.previousFocusedNode != previousFocusedNode ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.isDrillingIn != isDrillingIn ||
        oldDelegate.cameraScale != cameraScale ||
        oldDelegate.baseFontSize != baseFontSize;
  }
}
