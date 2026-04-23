import 'package:flutter/material.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCirclePackChart Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const WorldPopulationExample(),
    const BudgetTrackerExample(),
    const StressTestExample(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Countries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Stress Tests',
          ),
        ],
      ),
    );
  }
}

/// A generic base widget for the examples to maintain consistency
class ChartExampleScaffold extends StatelessWidget {
  final String title;
  final CircleNode root;
  final String subtitle;

  const ChartExampleScaffold({
    super.key,
    required this.title,
    required this.root,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FlutterCirclePackChartController(root: root);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return Column(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.label,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: FlutterCirclePackChart(
                  root: root,
                  controller: controller,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FlutterCirclePackChartLegend(controller: controller),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorldPopulationExample extends StatelessWidget {
  const WorldPopulationExample({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
    );

    return ChartExampleScaffold(
      title: 'WORLD POPULATION',
      root: root,
      subtitle: 'Tapping a continent shows top countries by population.',
    );
  }
}

class BudgetTrackerExample extends StatelessWidget {
  const BudgetTrackerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final root = CircleNode(
      label: 'Monthly Budget',
      color: Colors.blueGrey,
      children: [
        CircleNode(
          label: 'Needs',
          color: Colors.orange,
          children: [
            CircleNode(label: 'Rent/Mortgage', value: 1500.0),
            CircleNode(label: 'Groceries', value: 400.0),
            CircleNode(label: 'Utilities', value: 250.0),
            CircleNode(label: 'Insurance', value: 200.0),
          ],
        ),
        CircleNode(
          label: 'Wants',
          color: Colors.pink,
          children: [
            CircleNode(label: 'Dining Out', value: 300.0),
            CircleNode(label: 'Subscriptions', value: 50.0),
            CircleNode(label: 'Shopping', value: 200.0),
            CircleNode(label: 'Hobbies', value: 150.0),
          ],
        ),
        CircleNode(
          label: 'Savings',
          color: Colors.teal,
          children: [
            CircleNode(label: 'Emergency Fund', value: 500.0),
            CircleNode(label: 'Retirement', value: 400.0),
            CircleNode(label: 'Investments', value: 300.0),
          ],
        ),
      ],
    );

    return ChartExampleScaffold(
      title: 'FINANCIAL TRACKER',
      root: root,
      subtitle: '50/30/20 Rule: Split your income into Needs, Wants, and Savings.',
    );
  }
}

class StressTestExample extends StatelessWidget {
  const StressTestExample({super.key});

  @override
  Widget build(BuildContext context) {
    final root = CircleNode(
      label: 'Stress Tests',
      color: Colors.deepPurple,
      children: [
        CircleNode(
          label: 'Tiny Items',
          color: Colors.purple,
          children: List.generate(20, (i) => CircleNode(label: 'T$i', value: 0.1)),
        ),
        CircleNode(
          label: 'Long Names',
          color: Colors.indigo,
          children: [
            CircleNode(label: 'Democratic Republic of the Congo', value: 100.0),
            CircleNode(label: 'Saint Vincent and the Grenadines', value: 50.0),
            CircleNode(label: 'Bosnia and Herzegovina', value: 40.0),
            CircleNode(label: 'Trinidad and Tobago', value: 30.0),
          ],
        ),
        CircleNode(
          label: 'High Density',
          color: Colors.deepOrange,
          children: List.generate(10, (i) => CircleNode(
            label: 'Group $i',
            children: List.generate(5, (j) => CircleNode(label: 'Item $i-$j', value: 5.0)),
          )),
        ),
      ],
    );

    return ChartExampleScaffold(
      title: 'LIBRARY STRESS TESTS',
      root: root,
      subtitle: 'Testing minimum sizes, long label truncation, and recursive density.',
    );
  }
}
