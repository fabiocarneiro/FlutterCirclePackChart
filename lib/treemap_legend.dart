import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A widget that displays a vertical legend for the currently focused level of a circular treemap.
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 12, // Slightly wider for a "pill" or just 12x12
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      node.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      node.value.toStringAsFixed(0),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
