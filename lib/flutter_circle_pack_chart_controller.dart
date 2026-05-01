import 'package:flutter/foundation.dart';
import 'flutter_circle_pack_chart.dart';

/// A controller for the [CirclePackChartScope] that manages the navigation state.
class CirclePackChartScopeController extends ValueNotifier<CircleNode?> {
  final List<CircleNode?> _navigationStack = [];

  CirclePackChartScopeController() : super(null);

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

  /// Resets the navigation state to the top level.
  void reset() {
    _navigationStack.clear();
    value = null;
  }
}

/// Legacy alias for [CirclePackChartScopeController].
typedef CirclePackChartScopeController = CirclePackChartScopeController;
