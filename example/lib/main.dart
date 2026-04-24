import 'package:flutter/material.dart';
import 'package:flutter_circle_pack_chart/flutter_circle_pack_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/countries',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/countries',
          builder: (context, state) => const WorldPopulationExample(),
        ),
        GoRoute(
          path: '/budget',
          builder: (context, state) => const BudgetTrackerExample(),
        ),
        GoRoute(
          path: '/stress-tests',
          builder: (context, state) => const StressTestExample(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlutterCirclePackChart Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  final Widget child;
  const MainNavigationScreen({super.key, required this.child});

  static final List<_ExamplePage> _pages = [
    const _ExamplePage(
      title: 'Countries',
      path: '/countries',
      icon: Icons.public,
    ),
    const _ExamplePage(
      title: 'Budget',
      path: '/budget',
      icon: Icons.account_balance_wallet,
    ),
    const _ExamplePage(
      title: 'Stress Tests',
      path: '/stress-tests',
      icon: Icons.speed,
    ),
  ];

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/budget')) return 1;
    if (location.startsWith('/stress-tests')) return 2;
    return 0; // Default to countries
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(_pages[index].path);
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[selectedIndex].title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CirclePackChart',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive Visualization',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
            ...List.generate(_pages.length, (index) {
              final page = _pages[index];
              return ListTile(
                leading: Icon(page.icon),
                title: Text(page.title),
                selected: selectedIndex == index,
                onTap: () => _onItemTapped(index, context),
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('View on GitHub'),
              onTap: () async {
                final url = Uri.parse(
                  'https://github.com/fabiocarneiro/FlutterCirclePackChart',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _ExamplePage {
  final String title;
  final String path;
  final IconData icon;

  const _ExamplePage({
    required this.title,
    required this.path,
    required this.icon,
  });
}

/// A generic base widget for the examples to maintain consistency
class ChartExampleScaffold extends StatelessWidget {
  final String title;
  final CircleNode root;
  final String subtitle;
  final bool showValue;

  const ChartExampleScaffold({
    super.key,
    required this.title,
    required this.root,
    required this.subtitle,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FlutterCirclePackChartController(root: root);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Column(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                showValue: showValue,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
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
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
            CircleNode(label: 'China', formattedValue: '1.4B', value: 1400.0),
            CircleNode(label: 'India', formattedValue: '1.3B', value: 1300.0),
            CircleNode(label: 'Japan', formattedValue: '125M', value: 125.0),
            CircleNode(label: 'Indonesia', formattedValue: '270M', value: 270.0),
            CircleNode(label: 'Pakistan', formattedValue: '220M', value: 220.0),
          ],
        ),
        CircleNode(
          label: 'Europe',
          color: Colors.blue,
          children: [
            CircleNode(label: 'Germany', formattedValue: '83M', value: 83.0),
            CircleNode(label: 'France', formattedValue: '67M', value: 67.0),
            CircleNode(label: 'UK', formattedValue: '66M', value: 66.0),
            CircleNode(label: 'Italy', formattedValue: '60M', value: 60.0),
          ],
        ),
        CircleNode(
          label: 'Americas',
          color: Colors.green,
          children: [
            CircleNode(label: 'USA', formattedValue: '330M', value: 330.0),
            CircleNode(label: 'Brazil', formattedValue: '210M', value: 210.0),
            CircleNode(label: 'Canada', formattedValue: '38M', value: 38.0),
          ],
        ),
      ],
    );

    return ChartExampleScaffold(
      title: 'POPULATION STATISTICS',
      root: root,
      subtitle: 'Drill down into continents to see population. Dynamic opacity highlights larger nations.',
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
          formattedValue: '\$2500',
          color: Colors.orange,
          children: [
            CircleNode(label: 'Rent', formattedValue: '\$1500', value: 1500.0),
            CircleNode(label: 'Groceries', formattedValue: '\$400', value: 400.0),
            CircleNode(label: 'Utilities', formattedValue: '\$250', value: 250.0),
            CircleNode(label: 'Insurance', formattedValue: '\$200', value: 200.0),
            CircleNode(label: 'Transport', formattedValue: '\$150', value: 150.0),
          ],
        ),
        CircleNode(
          label: 'Wants',
          formattedValue: '\$1100',
          color: Colors.pink,
          children: [
            CircleNode(label: 'Dining', formattedValue: '\$300', value: 300.0),
            CircleNode(label: 'Subs', formattedValue: '\$50', value: 50.0),
            CircleNode(label: 'Shopping', formattedValue: '\$200', value: 200.0),
            CircleNode(label: 'Hobbies', formattedValue: '\$150', value: 150.0),
            CircleNode(label: 'Travel', formattedValue: '\$400', value: 400.0),
          ],
        ),
        CircleNode(
          label: 'Savings',
          formattedValue: '\$1400',
          color: Colors.teal,
          children: [
            CircleNode(label: 'Emergency', formattedValue: '\$500', value: 500.0),
            CircleNode(label: 'Retire', formattedValue: '\$400', value: 400.0),
            CircleNode(label: 'Invest', formattedValue: '\$300', value: 300.0),
            CircleNode(label: 'Debt', formattedValue: '\$200', value: 200.0),
          ],
        ),
      ],
    );

    return ChartExampleScaffold(
      title: 'HOUSEHOLD BUDGET',
      root: root,
      subtitle: 'Manage your monthly spending. Higher expenses are more opaque.',
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
            CircleNode(label: 'The United Kingdom of Great Britain and Northern Ireland', value: 20.0),
          ],
        ),
      ],
    );

    return const ChartExampleScaffold(
      title: 'LIBRARY LIMITS',
      root: root,
      showValue: false, // Stress test hidden values
      subtitle: 'Testing minimum radii and label overflow with hidden values.',
    );
  }
}
