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
    // Build a sample hierarchical dataset
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
            CircleNode(label: 'Indonesia', value: 270.0),
            CircleNode(label: 'Pakistan', value: 220.0),
            CircleNode(label: 'Bangladesh', value: 170.0),
            CircleNode(label: 'Vietnam', value: 98.0),
          ],
        ),
        CircleNode(
          label: 'Europe',
          color: Colors.blue,
          children: [
            CircleNode(label: 'Germany', value: 83.0),
            CircleNode(label: 'France', value: 67.0),
            CircleNode(label: 'UK', value: 66.0),
            CircleNode(label: 'Italy', value: 60.0),
            CircleNode(label: 'Spain', value: 47.0),
            CircleNode(label: 'Ukraine', value: 44.0),
            CircleNode(label: 'Poland', value: 38.0),
          ],
        ),
        CircleNode(
          label: 'Americas',
          color: Colors.green,
          children: [
            CircleNode(label: 'USA', value: 330.0),
            CircleNode(label: 'Brazil', value: 210.0),
            CircleNode(label: 'Mexico', value: 128.0),
            CircleNode(label: 'Colombia', value: 50.0),
            CircleNode(label: 'Argentina', value: 45.0),
            CircleNode(label: 'Canada', value: 38.0),
            CircleNode(label: 'Peru', value: 33.0),
          ],
        ),
        CircleNode(
          label: 'Africa',
          color: Colors.orange,
          children: [
            CircleNode(label: 'Nigeria', value: 200.0),
            CircleNode(label: 'Ethiopia', value: 110.0),
            CircleNode(label: 'Egypt', value: 100.0),
            CircleNode(label: 'DRC', value: 90.0),
            CircleNode(label: 'Tanzania', value: 60.0),
            CircleNode(label: 'South Africa', value: 59.0),
            CircleNode(label: 'Kenya', value: 53.0),
          ],
        ),
        CircleNode(
          label: 'Tiny Items',
          color: Colors.purple,
          children: List.generate(15, (i) => CircleNode(label: 'T$i', value: 0.1)),
        ),
        CircleNode(
          label: 'Long Names',
          color: Colors.teal,
          children: [
            CircleNode(label: 'Republic of the Congo', value: 100.0),
            CircleNode(label: 'Sao Tome and Principe', value: 50.0),
            CircleNode(label: 'Saint Vincent and the Grenadines', value: 30.0),
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
              // Header displaying current level
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    return Text(
                      value.label,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    );
                  },
                ),
              ),

              // Main Treemap Visualization
              Expanded(
                child: CircularTreemap(
                  root: _controller.root,
                  controller: _controller,
                ),
              ),

              // Fixed-height Legend Area to prevent layout jumps
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TreemapLegend(controller: _controller),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Tap a circle to drill down • Tap background to go back',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
