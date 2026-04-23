import 'dart:math';
import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A widget that displays an animated circular treemap with camera-style drill-down.
class CircularTreemap extends StatefulWidget {
  /// The root node of the hierarchical data to display.
  final CircleNode root;

  /// Optional controller to manage the navigation state.
  final TreemapController? controller;

  const CircularTreemap({
    super.key,
    required this.root,
    this.controller,
  });

  @override
  State<CircularTreemap> createState() => _CircularTreemapState();
}

class _CircularTreemapState extends State<CircularTreemap> with SingleTickerProviderStateMixin {
  late TreemapController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  PackedNode? _packedRoot;
  
  // Transform state
  double _startScale = 1.0;
  Offset _startOffset = Offset.zero;
  double _targetScale = 1.0;
  Offset _targetOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TreemapController(root: widget.root);
    _controller.addListener(_onStateChanged);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    
    // Initial packing with a large nominal radius
    _packedRoot = CirclePacker.pack(widget.root, radius: 500.0);
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
    if (widget.root != oldWidget.root) {
      _packedRoot = CirclePacker.pack(widget.root, radius: 500.0);
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
    _startScale = _targetScale;
    _startOffset = _targetOffset;
    _animationController.forward(from: 0.0);
  }

  PackedNode? _findPackedNode(PackedNode root, CircleNode target) {
    if (root.node == target) return root;
    for (final child in root.children) {
      final result = _findPackedNode(child, target);
      if (result != null) return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double viewportRadius = min(constraints.maxWidth, constraints.maxHeight) / 2;
        
        final focusedPacked = _findPackedNode(_packedRoot!, _controller.value);
        if (focusedPacked != null && focusedPacked.r > 0) {
          // Nominal scale to fit viewportRadius (based on nominal 500 radius)
          _targetScale = viewportRadius / focusedPacked.r;
          _targetOffset = Offset(-focusedPacked.x * _targetScale, -focusedPacked.y * _targetScale);
        }

        if (!_animationController.isAnimating && _animationController.value == 1.0) {
            _startScale = _targetScale;
            _startOffset = _targetOffset;
        }

        return GestureDetector(
          onTapUp: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localOffset = box.globalToLocal(details.globalPosition);
            final centerX = constraints.maxWidth / 2;
            final centerY = constraints.maxHeight / 2;
            
            final currentScale = Tween(begin: _startScale, end: _targetScale).evaluate(_animation);
            final currentOffset = Tween(begin: _startOffset, end: _targetOffset).evaluate(_animation);
            
            // Adjust for centering and transform
            final relativeX = (localOffset.dx - centerX - currentOffset.dx) / currentScale;
            final relativeY = (localOffset.dy - centerY - currentOffset.dy) / currentScale;

            final currentFocusedPacked = _findPackedNode(_packedRoot!, _controller.value);
            if (currentFocusedPacked != null) {
              for (final child in currentFocusedPacked.children) {
                final dx = relativeX - child.x;
                final dy = relativeY - child.y;
                if (dx * dx + dy * dy <= child.r * child.r) {
                  _controller.drillDown(child.node);
                  break;
                }
              }
            }
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale = Tween(begin: _startScale, end: _targetScale).evaluate(_animation);
              final offset = Tween(begin: _startOffset, end: _targetOffset).evaluate(_animation);

              return Center(
                child: ClipOval(
                  child: Container(
                    width: viewportRadius * 2,
                    height: viewportRadius * 2,
                    color: Colors.black.withValues(alpha: 0.05), // Subtle background
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(offset.dx, offset.dy)
                          ..scale(scale),
                        alignment: Alignment.center,
                        child: CustomPaint(
                          painter: CircularTreemapPainter(
                            root: _packedRoot!,
                            focusedNode: _controller.value,
                          ),
                          size: const Size(1000, 1000), // Match nominal packing size
                        ),
                      ),
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
