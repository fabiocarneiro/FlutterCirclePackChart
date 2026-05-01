import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';
import 'circle_pack_chart_scope.dart';

/// A widget that displays a vertical legend for the currently focused level of a circular treemap.
class FlutterCirclePackChartLegend extends StatelessWidget {
  /// The controller whose navigation state this legend follows.
  /// If null, will attempt to find one from a [CirclePackChart] scope.
  final CirclePackChartController? controller;

  /// The top-level children nodes.
  /// If null, will attempt to find them from a [CirclePackChart] scope.
  final List<CircleNode>? children;

  /// The title for the top-level view.
  /// If null, will attempt to find it from a [CirclePackChart] scope.
  final String? title;

  const FlutterCirclePackChartLegend({
    super.key,
    this.controller,
    this.children,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scope = CirclePackChartScope.of(context);
    final effectiveController = controller ?? scope?.controller;
    final effectiveChildren = children ?? scope?.children;
    final effectiveTitle = title ?? scope?.title ?? 'Root';

    if (effectiveController == null || effectiveChildren == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<CircleNode?>(
      valueListenable: effectiveController,
      builder: (context, focusedNode, _) {
        final currentChildren = focusedNode?.children ?? effectiveChildren;
        if (currentChildren.isEmpty) return const SizedBox.shrink();

        final Color parentColor = focusedNode?.color ?? Colors.blue;
        final String currentLabel = focusedNode?.label ?? effectiveTitle;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Items in $currentLabel',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...currentChildren.map((node) {
              final Color color = node.color ?? parentColor;
              final bool canDrill = node.children.isNotEmpty;

              return InkWell(
                onTap: canDrill ? () => effectiveController.drillDown(node) : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          node.label,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Text(
                        node.displayValue ?? node.value.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      if (canDrill) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
