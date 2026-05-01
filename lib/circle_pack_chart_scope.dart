import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';

/// An [InheritedWidget] that provides the data and controller for a Circle Pack Chart.
class CirclePackChartScope extends InheritedWidget {
  final List<CircleNode> children;
  final String title;
  final CirclePackChartController controller;

  const CirclePackChartScope({
    super.key,
    required this.children,
    required this.title,
    required this.controller,
    required super.child,
  });

  static CirclePackChartScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CirclePackChartScope>();
  }

  @override
  bool updateShouldNotify(CirclePackChartScope oldWidget) {
    return children != oldWidget.children ||
        title != oldWidget.title ||
        controller != oldWidget.controller;
  }
}

/// A wrapper widget that provides the [CirclePackChartScope] to its subtree.
class CirclePackChart extends StatefulWidget {
  /// The top-level children nodes to display.
  final List<CircleNode> children;

  /// The title for the overall chart.
  final String title;

  /// Optional controller to manage the navigation state.
  final CirclePackChartController? controller;

  /// The widget subtree that will consume the chart state.
  final Widget child;

  const CirclePackChart({
    super.key,
    required this.children,
    this.title = 'Chart',
    this.controller,
    required this.child,
  });

  @override
  State<CirclePackChart> createState() => _CirclePackChartState();
}

class _CirclePackChartState extends State<CirclePackChart> {
  late CirclePackChartController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CirclePackChartController();
  }

  @override
  void didUpdateWidget(CirclePackChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? CirclePackChartController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CirclePackChartScope(
      children: widget.children,
      title: widget.title,
      controller: _controller,
      child: widget.child,
    );
  }
}
