import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'flutter_circle_pack_chart.dart';
import 'circle_pack_chart_scope.dart';

/// A widget that displays an animated circular treemap with camera-style drill-down.
///
/// Can be used as a standalone widget by providing [children] and [title],
/// or it can automatically consume state from a parent [CirclePackChart] scope.
class FlutterCirclePackChart extends StatefulWidget {
  /// The top-level children nodes to display.
  /// If null, will attempt to find them from a [CirclePackChart] scope.
  final List<CircleNode>? children;

  /// The title for the overall chart.
  /// If null, will attempt to find it from a [CirclePackChart] scope.
  final String? title;

  /// Optional controller to manage the navigation state.
  /// If null, will attempt to find one from a [CirclePackChart] scope,
  /// or create an internal one.
  final CirclePackChartController? controller;

  /// Defines the minimum radius of a child circle as a fraction of its parent.
  /// Defaults to 0.20 to allow better visual hierarchy while maintaining labels.
  final double minRadiusRatio;

  /// A factor to adjust the automatically calculated responsive font size.
  /// Defaults to 1.0. Higher values make text larger globally.
  final double fontSizeFactor;

  /// Whether to show the [CircleNode.value] (or [CircleNode.displayValue])
  /// inside the circles. Defaults to true.
  final bool showValue;

  /// Whether to show the [CircleNode.label] inside the circles.
  /// Defaults to true.
  final bool showLabels;

  const FlutterCirclePackChart({
    super.key,
    this.children,
    this.title,
    this.controller,
    this.minRadiusRatio = 0.20,
    this.fontSizeFactor = 1.0,
    this.showValue = true,
    this.showLabels = true,
  });

  @override
  State<FlutterCirclePackChart> createState() => _FlutterCirclePackChartState();
}

class _FlutterCirclePackChartState extends State<FlutterCirclePackChart>
    with SingleTickerProviderStateMixin {
  CirclePackChartController? _internalController;
  CirclePackChartController? _activeController;

  late AnimationController _animationController;
  late Animation<double> _animation;

  PackedNode? _packedRoot;

  // State tracking for transitions
  CircleNode? _currentFocus;
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = CirclePackChartScope.of(context);
    final controller = widget.controller ?? scope?.controller;

    if (controller != null) {
      _internalController?.dispose();
      _internalController = null;
      _updateController(controller);
    } else if (_internalController == null) {
      _internalController = CirclePackChartController();
      _updateController(_internalController!);
    }

    final children = widget.children ?? scope?.children ?? [];
    final title = widget.title ?? scope?.title ?? 'Chart';

    _packedRoot = CirclePacker.packList(
      children,
      label: title,
      radius: 100.0,
      minRadiusRatio: widget.minRadiusRatio,
    );
    _animationController.value = 1.0;
  }

  void _updateController(CirclePackChartController controller) {
    if (_activeController != controller) {
      _activeController?.removeListener(_onStateChanged);
      _activeController = controller;
      _activeController?.addListener(_onStateChanged);
      _currentFocus = _activeController?.value;
    }
  }

  @override
  void didUpdateWidget(FlutterCirclePackChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
        _updateController(widget.controller!);
      }
    }
  }

  @override
  void dispose() {
    _activeController?.removeListener(_onStateChanged);
    _internalController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {
      final oldFocus = _currentFocus;
      final newFocus = _activeController?.value;

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

  bool _isAncestor(CircleNode? potentialAncestor, CircleNode? target) {
    if (target == null) return false;
    if (potentialAncestor == null) return true;

    for (final child in potentialAncestor.children) {
      if (child == target) return true;
      if (_isAncestor(child, target)) return true;
    }
    return false;
  }

  PackedNode? _findPackedNode(PackedNode root, CircleNode? target) {
    if (target == null) return root;

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

        final double responsiveBaseFontSize =
            (10.0 + (minSide / 120)) * widget.fontSizeFactor;

        final focusedPacked = _findPackedNode(_packedRoot!, _activeController?.value);
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
              _activeController?.value,
            );
            if (currentFocusedPacked != null) {
              bool tappedChild = false;
              for (final child in currentFocusedPacked.children) {
                final dx = relativeX - child.x;
                final dy = relativeY - child.y;
                if (dx * dx + dy * dy <= child.r * child.r) {
                  _activeController?.drillDown(child.node);
                  tappedChild = true;
                  break;
                }
              }

              if (!tappedChild && (_activeController?.canGoBack ?? false)) {
                _activeController?.goBack();
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
                        painter: FlutterCirclePackChartPainter(
                          root: _packedRoot!,
                          focusedNode: _activeController?.value,
                          previousFocusedNode: _animationController.isAnimating
                              ? _previousFocus
                              : null,
                          animationValue: _animation.value,
                          isDrillingIn: _isDrillingIn,
                          cameraScale: scale,
                          baseFontSize: responsiveBaseFontSize,
                          showValue: widget.showValue,
                          showLabels: widget.showLabels,
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
