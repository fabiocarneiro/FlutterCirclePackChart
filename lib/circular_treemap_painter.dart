import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A [CustomPainter] that renders a circular treemap with symmetric 
/// explosion/implosion animations.
class CircularTreemapPainter extends CustomPainter {
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

  CircularTreemapPainter({
    required this.root,
    required this.focusedNode,
    this.previousFocusedNode,
    required this.animationValue,
    required this.isDrillingIn,
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
      // Current focus: draw children
      for (final child in node.children) {
        if (isDrillingIn) {
          // Drill In: children explode from parent center (node.x, node.y)
          final double x = node.x + (child.x - node.x) * animationValue;
          final double y = node.y + (child.y - node.y) * animationValue;
          // Use parent radius (node.r) as start for interpolation
          final double r = lerpDouble(node.r, child.r, animationValue)!;
          final double opacity = 0.2 + 0.6 * animationValue;
          _drawLeaf(canvas, x, y, r, child.node, color, opacity: opacity);
        } else {
          // Drill Out: new focus is parent. Draw normally.
          _drawLeaf(canvas, child.x, child.y, child.r, child.node, color, opacity: 0.8);
        }
      }
    } else if (node.node == previousFocusedNode && !isDrillingIn && animationValue < 1.0) {
      // Drill Out: previous focus is imploding towards its center (node.x, node.y)
      for (final child in node.children) {
        // Move children from their packed positions back to parent center (node.x, node.y)
        final double x = child.x + (node.x - child.x) * animationValue;
        final double y = child.y + (node.y - child.y) * animationValue;
        // Grow from child.r to parent.r (node.r)
        final double r = lerpDouble(child.r, node.r, animationValue)!;
        final double opacity = 0.8 * (1.0 - animationValue);
        _drawLeaf(canvas, x, y, r, child.node, color, opacity: opacity);
      }
    } else if (_isAncestor(node.node, focusedNode)) {
      // Intermediate ancestor: recurse
      for (final child in node.children) {
        _drawNode(canvas, child, color);
      }
    } else {
      // Leaf or unrelated branch
      _drawLeaf(canvas, node.x, node.y, node.r, node.node, color, opacity: 0.8);
    }
  }

  void _drawLeaf(
    Canvas canvas,
    double x,
    double y,
    double r,
    CircleNode node,
    Color parentColor, {
    double opacity = 0.8,
  }) {
    if (opacity <= 0) return;
    
    final Color color = node.color ?? parentColor;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final double padding = r * 0.05;
    final double effectiveRadius = (r - padding).clamp(0.0, r);

    canvas.drawCircle(Offset(x, y), effectiveRadius, paint);

    if (effectiveRadius > 5) {
      _drawLabel(canvas, node.label, Offset(x, y), effectiveRadius, opacity);
    }
  }

  bool _isAncestor(CircleNode potentialAncestor, CircleNode target) {
    if (potentialAncestor.children.isEmpty) return false;
    for (final child in potentialAncestor.children) {
      if (child == target) return true;
      if (_isAncestor(child, target)) return true;
    }
    return false;
  }

  void _drawLabel(Canvas canvas, String label, Offset center, double radius, double opacity) {
    final double fontSize = (radius / 3.0).clamp(2.0, 24.0);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: opacity),
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
      ellipsis: '...',
    );

    textPainter.layout(maxWidth: radius * 1.8);
    if (textPainter.height < radius * 1.5) {
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircularTreemapPainter oldDelegate) {
    return oldDelegate.root != root ||
        oldDelegate.focusedNode != focusedNode ||
        oldDelegate.previousFocusedNode != previousFocusedNode ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.isDrillingIn != isDrillingIn;
  }
}
