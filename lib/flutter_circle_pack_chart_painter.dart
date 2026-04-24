import 'dart:ui';
import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';

/// A [CustomPainter] that renders the circular treemap circles with symmetric 
/// explosion/implosion animations, dynamic opacity, and anti-scaled labels.
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

  /// Whether to show the [CircleNode.value] or [CircleNode.displayValue] in the circles.
  final bool showValue;

  /// Whether to show the [CircleNode.label] in the circles.
  final bool showLabels;

  FlutterCirclePackChartPainter({
    required this.root,
    required this.focusedNode,
    this.previousFocusedNode,
    required this.animationValue,
    required this.isDrillingIn,
    required this.cameraScale,
    required this.baseFontSize,
    this.showValue = true,
    this.showLabels = true,
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
      final sortedChildren = List<PackedNode>.from(node.children)
        ..sort((a, b) => a.r.compareTo(b.r));

      // Calculate max/min values for dynamic opacity
      final double maxValue = node.children.isEmpty ? 1.0 : node.children.map((c) => c.node.value).reduce((a, b) => a > b ? a : b);
      final double minValue = node.children.isEmpty ? 0.0 : node.children.map((c) => c.node.value).reduce((a, b) => a < b ? a : b);

      for (final child in sortedChildren) {
        // Dynamic opacity with a tight range (0.85 - 1.0)
        final double importance = (focusedNode == root.node)
            ? 1.0
            : (maxValue == minValue
                ? 1.0
                : 0.85 + (0.15 * (child.node.value - minValue) / (maxValue - minValue)));

        if (isDrillingIn) {
          // Drill In: children explode from parent center
          final double x = node.x + (child.x - node.x) * animationValue;
          final double y = node.y + (child.y - node.y) * animationValue;
          final double r = lerpDouble(node.r, child.r, animationValue)!;
          _drawLeaf(canvas, x, y, r, child.node, color, opacity: importance);
        } else {
          // Drill Out: new focus is parent. 
          if (child.node == previousFocusedNode && animationValue < 1.0) {
            _drawImplodingNode(canvas, child, color);
          } else {
            _drawLeaf(canvas, child.x, child.y, child.r, child.node, color, opacity: importance);
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
    
    final sortedChildren = List<PackedNode>.from(node.children)
      ..sort((a, b) => a.r.compareTo(b.r));

    final double maxValue = node.children.isEmpty ? 1.0 : node.children.map((c) => c.node.value).reduce((a, b) => a > b ? a : b);
    final double minValue = node.children.isEmpty ? 0.0 : node.children.map((c) => c.node.value).reduce((a, b) => a < b ? a : b);

    for (final child in sortedChildren) {
      final double importance = (focusedNode == root.node)
          ? 1.0
          : (maxValue == minValue
              ? 1.0
              : 0.85 + (0.15 * (child.node.value - minValue) / (maxValue - minValue)));
      
      final double x = child.x + (node.x - child.x) * animationValue;
      final double y = child.y + (node.y - child.y) * animationValue;
      final double r = lerpDouble(child.r, node.r, animationValue)!;
      
      _drawLeaf(canvas, x, y, r, child.node, color, opacity: importance);
    }
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
    CircleNode node,
    Offset center,
    double radius,
    double opacity,
  ) {
    if (!showValue && !showLabels) return;

    // --- MATHEMATICALLY STABLE FONT SIZING & SPACING ---
    // Instead of using TextPainter.height (which jitters), we use a fixed multiplier
    // of the baseFontSize for vertical positioning.
    
    final double valueSize = (baseFontSize / cameraScale).clamp(0.1, 100.0);
    final double labelSize = ((baseFontSize * 0.75) / cameraScale).clamp(0.1, 100.0);
    
    // Total visual vertical height block (in canvas units)
    // 1.2 and 1.0 are stable line-height multipliers.
    final double valueHeight = showValue ? (valueSize * 1.2) : 0.0;
    final double labelHeight = showLabels ? (labelSize * 1.0) : 0.0;
    final double totalHeight = valueHeight + labelHeight;
    final double maxWidth = radius * 2.2; // Tighter constraint to avoid edges

    double currentY = center.dy - (totalHeight / 2);

    if (showValue) {
      final valuePainter = TextPainter(
        text: TextSpan(
          text: node.displayValue ?? node.value.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.white.withValues(alpha: opacity),
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1,
        ellipsis: '...',
      )..layout(maxWidth: maxWidth);

      valuePainter.paint(
        canvas,
        Offset(center.dx - (valuePainter.width / 2), currentY),
      );
      currentY += valueHeight; // Advance by the FIXED multiplier, not dynamic height
    }

    if (showLabels) {
      final labelPainter = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: opacity),
            fontSize: labelSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1,
        ellipsis: '...',
      )..layout(maxWidth: maxWidth);

      labelPainter.paint(
        canvas,
        Offset(center.dx - (labelPainter.width / 2), currentY),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlutterCirclePackChartPainter oldDelegate) {
    return oldDelegate.root != root ||
        oldDelegate.focusedNode != focusedNode ||
        oldDelegate.previousFocusedNode != previousFocusedNode ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.isDrillingIn != isDrillingIn ||
        oldDelegate.cameraScale != cameraScale ||
        oldDelegate.baseFontSize != baseFontSize ||
        oldDelegate.showValue != showValue ||
        oldDelegate.showLabels != showLabels;
  }
}
