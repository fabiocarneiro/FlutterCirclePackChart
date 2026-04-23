import 'package:flutter/material.dart';
import 'package:circular_treemap/circular_treemap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Treemap Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TreemapDemo(),
    );
  }
}

class TreemapDemo extends StatefulWidget {
  const TreemapDemo({super.key});

  @override
  State<TreemapDemo> createState() => _TreemapDemoState();
}

class _TreemapDemoState extends State<TreemapDemo> {
  late CircleNode root;
  late CircleNode focusedNode;
  List<CircleNode> navigationStack = [];

  @override
  void initState() {
    super.initState();
    root = CircleNode(
      label: 'World',
      color: Colors.blueGrey,
      children: [
        CircleNode(
          label: 'Asia',
          color: Colors.red,
          children: [
            CircleNode(label: 'China', value: 1400.0),
            CircleNode(label: 'India', value: 1300.0),
            CircleNode(label: 'Japan', value: 125.0),
          ],
        ),
        CircleNode(
          label: 'Europe',
          color: Colors.blue,
          children: [
            CircleNode(label: 'Germany', value: 83.0),
            CircleNode(label: 'France', value: 67.0),
            CircleNode(label: 'UK', value: 66.0),
          ],
        ),
        CircleNode(
          label: 'Americas',
          color: Colors.green,
          children: [
            CircleNode(label: 'USA', value: 330.0),
            CircleNode(label: 'Brazil', value: 210.0),
            CircleNode(label: 'Canada', value: 38.0),
          ],
        ),
        CircleNode(
          label: 'Africa',
          color: Colors.orange,
          children: [
            CircleNode(label: 'Nigeria', value: 200.0),
            CircleNode(label: 'Egypt', value: 100.0),
            CircleNode(label: 'Ethiopia', value: 110.0),
          ],
        ),
      ],
    );
    focusedNode = root;
  }

  void _onTap(PackedNode packed) {
    if (packed.node.children.isNotEmpty) {
      setState(() {
        navigationStack.add(focusedNode);
        focusedNode = packed.node;
      });
    }
  }

  void _goBack() {
    if (navigationStack.isNotEmpty) {
      setState(() {
        focusedNode = navigationStack.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treemap: ${focusedNode.label}'),
        leading: navigationStack.isNotEmpty
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double radius =
                  (constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight) /
                  2;

              final packed = CirclePacker.pack(focusedNode, radius: radius);

              return GestureDetector(
                onTapUp: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localOffset = box.globalToLocal(details.globalPosition);
                  // Adjust for centering
                  final centerX = constraints.maxWidth / 2;
                  final centerY = constraints.maxHeight / 2;
                  final relativeX = localOffset.dx - centerX;
                  final relativeY = localOffset.dy - centerY;

                  for (final child in packed.children) {
                    final dx = relativeX - child.x;
                    final dy = relativeY - child.y;
                    if (dx * dx + dy * dy <= child.r * child.r) {
                      _onTap(child);
                      break;
                    }
                  }
                },
                child: CustomPaint(
                  painter: CircularTreemapPainter(packedNode: packed),
                  size: Size(radius * 2, radius * 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
