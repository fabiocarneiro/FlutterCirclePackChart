import 'dart:math';
import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A widget that displays an animated circular treemap with drill-down support.
class CircularTreemap extends StatefulWidget {
  /// The root node of the hierarchical data to display.
  final CircleNode root;

  /// Optional controller to manage the navigation state.
  final TreemapController? controller;

  const CircularTreemap({super.key, required this.root, this.controller});

  @override
  State<CircularTreemap> createState() => _CircularTreemapState();
}

class _CircularTreemapState extends State<CircularTreemap>
    with SingleTickerProviderStateMixin {
  late TreemapController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TreemapController(root: widget.root);
    _controller.addListener(_onStateChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start with fully visible
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(CircularTreemap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onStateChanged);
      _controller = widget.controller ?? TreemapController(root: widget.root);
      _controller.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double radius =
            min(constraints.maxWidth, constraints.maxHeight) / 2;

        final focusedNode = _controller.value;
        final packed = CirclePacker.pack(focusedNode, radius: radius);

        return GestureDetector(
          onTapUp: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localOffset = box.globalToLocal(details.globalPosition);
            final centerX = constraints.maxWidth / 2;
            final centerY = constraints.maxHeight / 2;
            final relativeX = localOffset.dx - centerX;
            final relativeY = localOffset.dy - centerY;

            for (final child in packed.children) {
              final dx = relativeX - child.x;
              final dy = relativeY - child.y;
              if (dx * dx + dy * dy <= child.r * child.r) {
                _controller.drillDown(child.node);
                break;
              }
            }
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * _animation.value),
                child: Opacity(
                  opacity: _animation.value,
                  child: Center(
                    child: CustomPaint(
                      painter: CircularTreemapPainter(packedNode: packed),
                      size: Size(radius * 2, radius * 2),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
