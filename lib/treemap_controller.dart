import 'package:flutter/foundation.dart';
import 'circular_treemap.dart';

/// A controller for the [CircularTreemap] that manages the navigation state.
class TreemapController extends ValueNotifier<CircleNode> {
  /// The absolute root of the hierarchy.
  final CircleNode root;

  final List<CircleNode> _navigationStack = [];

  TreemapController({required this.root}) : super(root);

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
