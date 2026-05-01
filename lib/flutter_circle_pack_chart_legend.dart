import 'package:flutter/material.dart';
import 'flutter_circle_pack_chart.dart';

/// A widget that displays a vertical legend for the currently focused level of a circular treemap.
class FlutterCirclePackChartLegend extends StatelessWidget {
  /// The controller whose navigation state this legend follows.
  final FlutterCirclePackChartController controller;

  const FlutterCirclePackChartLegend({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, focusedNode, _) {
        final children = focusedNode.children;
        if (children.isEmpty) return const SizedBox.shrink();

        final Color parentColor = focusedNode.color ?? Colors.blue;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Items in ${focusedNode.label}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...children.map((node) {
              final Color color = node.color ?? parentColor;
              final bool canDrill = node.children.isNotEmpty;

              return InkWell(
                onTap: canDrill ? () => controller.drillDown(node) : null,
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
