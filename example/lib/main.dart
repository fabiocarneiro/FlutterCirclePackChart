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
      debugShowCheckedModeBanner: false,
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
  late TreemapController _controller;

  @override
  void initState() {
    super.initState();
    final root = CircleNode(
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
    _controller = TreemapController(root: root);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    return Text(
                      value.label,
                      style: Theme.of(context).textTheme.headlineLarge,
                    );
                  },
                ),
              ),
              Expanded(
                child: CircularTreemap(
                  root: _controller.root,
                  controller: _controller,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap a circle to drill down. Tap outside to go back.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
