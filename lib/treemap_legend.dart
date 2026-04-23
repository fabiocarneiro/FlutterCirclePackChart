import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A widget that displays a legend for the currently focused level of a circular treemap.
class TreemapLegend extends StatelessWidget {
  /// The controller whose navigation state this legend follows.
  final TreemapController controller;

  const TreemapLegend({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, focusedNode, _) {
        final children = focusedNode.children;
        if (children.isEmpty) return const SizedBox.shrink();

        final Color parentColor = focusedNode.color ?? Colors.blue;

        return Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: children.map((node) {
            final Color color = node.color ?? parentColor;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  node.label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
