import 'dart:ui';
import 'package:flutter/widgets.dart';

export 'circle_packer.dart';
export 'flutter_circle_pack_chart_painter.dart';
export 'flutter_circle_pack_chart_widget.dart';
export 'flutter_circle_pack_chart_controller.dart';
export 'flutter_circle_pack_chart_legend.dart';

/// A function that builds a widget for a given [CircleNode].
typedef NodeWidgetBuilder = Widget Function(BuildContext context, CircleNode node);

/// Represents a node in the hierarchical data structure for the Circle Pack Chart.
class CircleNode {
  /// The display label for this node (used for the legend and default labels).
  final String label;

  /// An optional secondary label (e.g. a monetary value or subtitle).
  final String? secondaryLabel;

  /// An optional builder to provide a custom widget as a label inside the circle.
  /// If provided, this takes precedence over [label] and [secondaryLabel] in the chart view.
  final NodeWidgetBuilder? childBuilder;

  /// The internal value for this node. If children are present, the value is
  /// typically the sum of children values.
  final double? _value;

  /// The color associated with this node.
  final Color? color;

  /// The nested children of this node.
  final List<CircleNode> children;

  CircleNode({
    required this.label,
    this.secondaryLabel,
    this.childBuilder,
    double? value,
    this.color,
    this.children = const [],
  }) : _value = value;

  /// Returns the value of this node.
  /// If it has children, the value is the sum of all children values.
  /// Otherwise, it returns the explicitly provided value.
  double get value {
    if (children.isEmpty) {
      return _value ?? 0.0;
    }
    return children.fold(0.0, (sum, child) => sum + child.value);
  }

  /// Creates a [CircleNode] from a [Map].
  factory CircleNode.fromMap(Map<String, dynamic> map) {
    return CircleNode(
      label: map['label'] as String,
      secondaryLabel: map['secondaryLabel'] as String?,
      value: (map['value'] as num?)?.toDouble(),
      color: map['color'] != null ? Color(map['color'] as int) : null,
      children: (map['children'] as List<dynamic>?)
              ?.map(
                (child) => CircleNode.fromMap(child as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
