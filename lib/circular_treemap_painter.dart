import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A [CustomPainter] that renders a packed circular treemap.
class CircularTreemapPainter extends CustomPainter {
  /// The packed node hierarchy to render.
  final PackedNode packedNode;

  CircularTreemapPainter({required this.packedNode});

  @override
  void paint(Canvas canvas, Size size) {
    // Center the rendering within the available size.
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    _drawNode(canvas, packedNode);

    canvas.restore();
  }

  void _drawNode(Canvas canvas, PackedNode node) {
    final paint = Paint()
      ..color = node.node.color ?? Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Draw the circle.
    canvas.drawCircle(Offset(node.x, node.y), node.r, paint);

    // Draw a subtle border for each circle.
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(node.x, node.y), node.r, borderPaint);

    // Recursively draw all nested children.
    for (final child in node.children) {
      _drawNode(canvas, child);
    }
  }

  @override
  bool shouldRepaint(covariant CircularTreemapPainter oldDelegate) {
    return oldDelegate.packedNode != packedNode;
  }
}
