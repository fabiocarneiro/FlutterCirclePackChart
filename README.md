# FlutterCirclePackChart

[![Pub Version](https://img.shields.io/pub/v/flutter_circle_pack_chart.svg)](https://pub.dev/packages/flutter_circle_pack_chart)
[![Documentation](https://img.shields.io/badge/docs-pub.dev-blue.svg)](https://pub.dev/documentation/flutter_circle_pack_chart/latest/)
[![Demo](https://img.shields.io/badge/demo-live-brightgreen.svg)](https://fabiocarneiro.github.io/FlutterCirclePackChart/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Deploy to GitHub Pages](https://github.com/fabiocarneiro/FlutterCirclePackChart/actions/workflows/deploy.yml/badge.svg)](https://github.com/fabiocarneiro/FlutterCirclePackChart/actions/workflows/deploy.yml)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)

A powerful, interactive, and highly customizable Circle Pack Chart (Circular Treemap) library for Flutter. Built with performance and user experience in mind, it features immersive drill-down navigation and a responsive, data-driven label system.

**[Live Demo](https://fabiocarneiro.github.io/FlutterCirclePackChart/)**

## 🌟 Features

- **🚀 Immersive Drill-Down:** Tapping a circle triggers a smooth, symmetric "breaking apart" animation where children emerge from the parent's center as the view zooms in.
- **♾️ Infinite Zoom Context:** Sibling nodes remain visible and partially overflow the square viewport during transitions, maintaining clear hierarchical context.
- **🔄 Bidirectional Navigation:** Seamlessly supports both drill-in (explosion) and drill-out (implosion) animations for a natural, physical feel.
- **📏 Professional Label System:**
  - **Structured Data:** Use `label` for the name and `displayValue` for monetary values, percentages, or custom strings.
  - **Guaranteed Visibility:** Enforces a minimum circle size to ensure every item has a legible label.
  - **Anti-Scaled Consistency:** Labels maintain a constant visual size on screen regardless of the zoom level.
- **✨ Dynamic Opacity:** Automatically scales child circle opacity based on their relative values, visually highlighting more important data points.
- **📋 Interactive Legend:** Includes a built-in vertical legend component that automatically updates.

## 📦 Installation

```bash
flutter pub add flutter_circle_pack_chart
```

## 🚀 Getting Started

### 1. Define your data
Create a list of `CircleNode` objects:

```dart
final children = [
  CircleNode(
    label: 'Needs',
    value: 2500.0,
    displayValue: '\$2500',
    color: Colors.orange,
    children: [
      CircleNode(label: 'Rent', value: 1500.0, displayValue: '\$1500'),
      CircleNode(label: 'Groceries', value: 400.0, displayValue: '\$400'),
    ],
  ),
  CircleNode(
    label: 'Wants',
    value: 1100.0,
    displayValue: '\$1100',
    color: Colors.pink,
    children: [
      CircleNode(label: 'Dining', value: 300.0, displayValue: '\$300'),
    ],
  ),
];
```

### 2. Basic Usage
For a simple chart, just drop the widget in:

```dart
FlutterCirclePackChart(
  children: children,
  title: 'Monthly Budget',
)
```

### 3. Usage with Legend
To include an interactive legend, wrap them in a `CirclePackChart` scope:

```dart
CirclePackChart(
  children: children,
  title: 'Monthly Budget',
  child: Column(
    children: [
      Expanded(child: FlutterCirclePackChart()),
      FlutterCirclePackChartLegend(),
    ],
  ),
)
```

## 🛠️ Customization

| Property | Description | Default |
| :--- | :--- | :--- |
| `children` | The top-level data nodes. (Required if not in scope) | `null` |
| `title` | The label for the top-most level. | `'Chart'` |
| `showValue` | Whether to display values inside circles. | `true` |
| `minRadiusRatio` | Minimum radius fraction for children. | `0.20` |
| `fontSizeFactor` | Responsive font size multiplier. | `1.0` |

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.
