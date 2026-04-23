import 'package:flutter/foundation.dart';
import 'flutter_circle_pack_chart.dart';

/// A controller for the [FlutterCirclePackChart] that manages the navigation state.
class FlutterCirclePackChartController extends ValueNotifier<CircleNode> {
  /// The absolute root of the hierarchy.
  final CircleNode root;

  final List<CircleNode> _navigationStack = [];

  FlutterCirclePackChartController({required this.root}) : super(root);

  /// Whether it is possible to navigate back to a parent level.
  bool get canGoBack => _navigationStack.isNotEmpty;

  /// Drills down into the specified [node].
  void drillDown(CircleNode node) {
    if (node.children.isNotEmpty) {
      _navigationStack.add(value);
      value = node;
    }
  }

  /// Navigates back to the previous level in the hierarchy.
  void goBack() {
    if (canGoBack) {
      value = _navigationStack.removeLast();
    }
  }
}
