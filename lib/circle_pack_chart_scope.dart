import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';

/// An [InheritedWidget] that provides the data and controller for a Circle Pack Chart.
class CirclePackScope extends InheritedWidget {
  final List<CircleNode> children;
  final String title;
  final CirclePackChartController controller;

  const CirclePackScope({
    super.key,
    required this.children,
    required this.title,
    required this.controller,
    required super.child,
  });

  static CirclePackScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CirclePackScope>();
  }

  @override
  bool updateShouldNotify(CirclePackScope oldWidget) {
    return children != oldWidget.children ||
        title != oldWidget.title ||
        controller != oldWidget.controller;
  }
}

/// A wrapper widget that provides the [CirclePackScope] to its subtree.
///
/// Use this when you need to share the chart state between multiple widgets,
/// such as a [FlutterCirclePackChart] and a [FlutterCirclePackChartLegend].
class CirclePackProvider extends StatefulWidget {
  /// The top-level children nodes to display.
  final List<CircleNode> children;

  /// The title for the overall chart.
  final String title;

  /// Optional controller to manage the navigation state.
  final CirclePackChartController? controller;

  /// The widget subtree that will consume the chart state.
  final Widget child;

  const CirclePackProvider({
    super.key,
    required this.children,
    this.title = 'Chart',
    this.controller,
    required this.child,
  });

  @override
  State<CirclePackProvider> createState() => _CirclePackProviderState();
}

class _CirclePackProviderState extends State<CirclePackProvider> {
  late CirclePackChartController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CirclePackChartController();
  }

  @override
  void didUpdateWidget(CirclePackProvider oldWidget) {
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
    return CirclePackScope(
      children: widget.children,
      title: widget.title,
      controller: _controller,
      child: widget.child,
    );
  }
}
