import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'circle_pack_chart.dart';

/// A widget that displays an animated circular treemap with camera-style drill-down.
class CirclePackChart extends StatefulWidget {
  /// The root node of the hierarchical data to display.
  final CircleNode root;

  /// Optional controller to manage the navigation state.
  final CirclePackChartController? controller;

  /// Defines the minimum radius of a child circle as a fraction of its parent.
  /// Defaults to 0.20 to allow better visual hierarchy while maintaining labels.
  final double minRadiusRatio;

  /// A factor to adjust the automatically calculated responsive font size.
  /// Defaults to 1.0. Higher values make text larger globally.
  final double fontSizeFactor;

  const CirclePackChart({
    super.key,
    required this.root,
    this.controller,
    this.minRadiusRatio = 0.20,
    this.fontSizeFactor = 1.0,
  });

  @override
  State<CirclePackChart> createState() => _CirclePackChartState();
}

class _CirclePackChartState extends State<CirclePackChart>
    with SingleTickerProviderStateMixin {
  late CirclePackChartController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  PackedNode? _packedRoot;

  // State tracking for transitions
  late CircleNode _currentFocus;
  CircleNode? _previousFocus;
  bool _isDrillingIn = true;

  // Transform state
  double _startScale = 1.0;
  Offset _startOffset = Offset.zero;
  double _targetScale = 1.0;
  Offset _targetOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? CirclePackChartController(root: widget.root);
    _currentFocus = _controller.value;
    _controller.addListener(_onStateChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Initial packing
    _packedRoot = CirclePacker.pack(
      widget.root,
      radius: 100.0,
      minRadiusRatio: widget.minRadiusRatio,
    );
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(CirclePackChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onStateChanged);
      _controller =
          widget.controller ?? CirclePackChartController(root: widget.root);
      _controller.addListener(_onStateChanged);
    }
    if (widget.root != oldWidget.root ||
        widget.minRadiusRatio != oldWidget.minRadiusRatio) {
      _packedRoot = CirclePacker.pack(
        widget.root,
        radius: 100.0,
        minRadiusRatio: widget.minRadiusRatio,
      );
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
    setState(() {
      final oldFocus = _currentFocus;
      final newFocus = _controller.value;

      _isDrillingIn = _isAncestor(oldFocus, newFocus);
      _previousFocus = oldFocus;
      _currentFocus = newFocus;

      _startScale =
          lerpDouble(_startScale, _targetScale, _animation.value) ??
          _startScale;
      _startOffset = Offset(
        lerpDouble(_startOffset.dx, _targetOffset.dx, _animation.value) ??
            _startOffset.dx,
        lerpDouble(_startOffset.dy, _targetOffset.dy, _animation.value) ??
            _startOffset.dy,
      );
      _animationController.forward(from: 0.0);
    });
  }

  bool _isAncestor(CircleNode potentialAncestor, CircleNode target) {
    if (potentialAncestor.children.isEmpty) return false;
    for (final child in potentialAncestor.children) {
      if (child == target) return true;
      if (_isAncestor(child, target)) return true;
    }
    return false;
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
        final double minSide = min(constraints.maxWidth, constraints.maxHeight);
        final double viewportRadius = minSide / 2;

        // Responsive font calculation:
        // Baseline 12.0 + small increment based on screen size, modified by factor.
        final double responsiveBaseFontSize =
            (10.0 + (minSide / 120)) * widget.fontSizeFactor;

        final focusedPacked = _findPackedNode(_packedRoot!, _controller.value);
        if (focusedPacked != null && focusedPacked.r > 0) {
          _targetScale = viewportRadius / focusedPacked.r;
          _targetOffset = Offset(
            -focusedPacked.x * _targetScale,
            -focusedPacked.y * _targetScale,
          );
        }

        if (!_animationController.isAnimating &&
            _animationController.value == 1.0) {
          _startScale = _targetScale;
          _startOffset = _targetOffset;
        }

        return GestureDetector(
          onTapUp: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localOffset = box.globalToLocal(details.globalPosition);
            final centerX = constraints.maxWidth / 2;
            final centerY = constraints.maxHeight / 2;

            final double scale =
                lerpDouble(_startScale, _targetScale, _animation.value) ??
                _startScale;
            final Offset offset = Offset(
              lerpDouble(_startOffset.dx, _targetOffset.dx, _animation.value) ??
                  _startOffset.dx,
              lerpDouble(_startOffset.dy, _targetOffset.dy, _animation.value) ??
                  _startOffset.dy,
            );

            final relativeX = (localOffset.dx - centerX - offset.dx) / scale;
            final relativeY = (localOffset.dy - centerY - offset.dy) / scale;

            final currentFocusedPacked = _findPackedNode(
              _packedRoot!,
              _controller.value,
            );
            if (currentFocusedPacked != null) {
              bool tappedChild = false;
              for (final child in currentFocusedPacked.children) {
                final dx = relativeX - child.x;
                final dy = relativeY - child.y;
                if (dx * dx + dy * dy <= child.r * child.r) {
                  _controller.drillDown(child.node);
                  tappedChild = true;
                  break;
                }
              }

              if (!tappedChild && _controller.canGoBack) {
                _controller.goBack();
              }
            }
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final scale =
                  lerpDouble(_startScale, _targetScale, _animation.value) ??
                  _startScale;
              final dx =
                  lerpDouble(
                    _startOffset.dx,
                    _targetOffset.dx,
                    _animation.value,
                  ) ??
                  _startOffset.dx;
              final dy =
                  lerpDouble(
                    _startOffset.dy,
                    _targetOffset.dy,
                    _animation.value,
                  ) ??
                  _startOffset.dy;

              return ClipRect(
                child: Center(
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Transform(
                      transform: Matrix4.compose(
                        Vector3(dx, dy, 0.0),
                        Quaternion.identity(),
                        Vector3(scale, scale, 1.0),
                      ),
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: CirclePackChartPainter(
                          root: _packedRoot!,
                          focusedNode: _controller.value,
                          previousFocusedNode: _animationController.isAnimating
                              ? _previousFocus
                              : null,
                          animationValue: _animation.value,
                          isDrillingIn: _isDrillingIn,
                          cameraScale: scale,
                          baseFontSize: responsiveBaseFontSize,
                        ),
                        size: const Size(200, 200),
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
