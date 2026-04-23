import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A [CustomPainter] that renders a circular treemap with focus-based visibility.
class CircularTreemapPainter extends CustomPainter {
  /// The absolute root of the packed hierarchy.
  final PackedNode root;

  /// The currently focused node.
  final CircleNode focusedNode;

  CircularTreemapPainter({
    required this.root,
    required this.focusedNode,
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
      // Draw children of the focused node.
      for (final child in node.children) {
        _drawLeaf(canvas, child, color);
      }
    } else if (_isAncestor(node.node, focusedNode)) {
      // If it's an ancestor, we don't draw its boundary, we just look inside.
      for (final child in node.children) {
        _drawNode(canvas, child, color);
      }
    } else {
      // Sibling or unrelated branch: draw as a single leaf circle.
      _drawLeaf(canvas, node, color);
    }
  }

  void _drawLeaf(Canvas canvas, PackedNode node, Color parentColor) {
    final Color color = node.node.color ?? parentColor;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(node.x, node.y), node.r, paint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(node.x, node.y), node.r, borderPaint);

    if (node.r > 10) {
      _drawLabel(canvas, node.node.label, Offset(node.x, node.y), node.r);
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

  void _drawLabel(Canvas canvas, String label, Offset center, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: (radius / 3.5).clamp(6.0, 14.0),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
      ellipsis: '...',
    );

    textPainter.layout(maxWidth: radius * 1.8);
    if (textPainter.width < radius * 1.9) {
        textPainter.paint(
          canvas,
          center - Offset(textPainter.width / 2, textPainter.height / 2),
        );
    }
  }

  @override
  bool shouldRepaint(covariant CircularTreemapPainter oldDelegate) {
    return oldDelegate.root != root || oldDelegate.focusedNode != focusedNode;
  }
}
