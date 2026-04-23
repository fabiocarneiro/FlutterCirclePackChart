import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A [CustomPainter] that renders a focused level of a circular treemap.
class CircularTreemapPainter extends CustomPainter {
  /// The focused node (acting as root for the current view).
  final PackedNode packedNode;

  CircularTreemapPainter({required this.packedNode});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    // We only draw the children of the currently focused packedNode.
    // The parent (packedNode itself) is not drawn, as per the drill-down requirement.
    final Color baseColor = packedNode.node.color ?? Colors.blue;

    for (final child in packedNode.children) {
      _drawChild(canvas, child, baseColor);
    }

    canvas.restore();
  }

  void _drawChild(Canvas canvas, PackedNode node, Color parentColor) {
    final Color color = node.node.color ?? parentColor;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(node.x, node.y), node.r, paint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(node.x, node.y), node.r, borderPaint);

    // Draw label
    if (node.r > 15) {
      _drawLabel(canvas, node.node.label, Offset(node.x, node.y), node.r);
    }
  }

  void _drawLabel(Canvas canvas, String label, Offset center, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: (radius / 3).clamp(8.0, 16.0),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
      ellipsis: '...',
    );

    textPainter.layout(maxWidth: radius * 1.8);
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CircularTreemapPainter oldDelegate) {
    return oldDelegate.packedNode != packedNode;
  }
}
