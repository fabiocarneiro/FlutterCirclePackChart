import 'dart:math';
import 'package:flutter/material.dart';
import 'circular_treemap.dart';

/// A widget that displays a circular treemap.
class CircularTreemap extends StatelessWidget {
  /// The root node of the hierarchical data to display.
  final CircleNode root;

  const CircularTreemap({super.key, required this.root});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double radius =
            min(constraints.maxWidth, constraints.maxHeight) / 2;

        // Pack the data into the available circular area.
        final packedNode = CirclePacker.pack(root, radius: radius);

        return Center(
          child: CustomPaint(
            painter: CircularTreemapPainter(packedNode: packedNode),
            size: Size(radius * 2, radius * 2),
          ),
        );
      },
    );
  }
}
