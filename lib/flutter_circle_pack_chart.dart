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
  /// The primary display label for this node (descriptive name).
  final String label;

  /// An optional string representation of the [value] (e.g. "$1,500").
  /// If provided, this is preferred for display in the chart and legend.
  final String? formattedValue;

  /// An optional builder to provide a custom widget as a label inside the circle.
  /// If provided, this takes precedence over [label] and [formattedValue] in the chart view.
  final NodeWidgetBuilder? childBuilder;

  /// The numeric value for this node, used to drive sizing and legend totals.
  final double? _value;

  /// The color associated with this node.
  final Color? color;

  /// The nested children of this node.
  final List<CircleNode> children;

  CircleNode({
    required this.label,
    this.formattedValue,
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
      formattedValue: map['formattedValue'] as String?,
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
