import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circular_treemap/circular_treemap.dart';

void main() {
  testWidgets('CircularTreemap widget should render', (
    WidgetTester tester,
  ) async {
    final root = CircleNode(
      label: 'Root',
      children: [
        CircleNode(label: 'A', value: 10.0),
        CircleNode(label: 'B', value: 20.0),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 500,
            height: 500,
            child: CircularTreemap(root: root),
          ),
        ),
      ),
    );

    expect(find.byType(CircularTreemap), findsOneWidget);
  });
}
