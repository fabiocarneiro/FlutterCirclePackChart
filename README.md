# FlutterCirclePackChart

[![Pub Version](https://img.shields.io/pub/v/flutter_circle_pack_chart.svg)](https://pub.dev/packages/flutter_circle_pack_chart)
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
  - **Structured Data:** Use `label` for the name and `displayValue` for monetary values, percentages, or custom strings (rendered larger and bold on top).
  - **Guaranteed Visibility:** Enforces a minimum circle size to ensure every item has a legible label.
  - **Anti-Scaled Consistency:** Labels maintain a constant visual size on screen regardless of the zoom level.
  - **Visibility Toggle:** Control whether values are shown inside circles using the `showValue` flag.
- **✨ Dynamic Opacity:** Automatically scales child circle opacity based on their relative values, visually highlighting more important data points.
- **📋 Dynamic Legend:** Includes a built-in vertical legend component that automatically updates to reflect labels and display values of the currently focused level.

## 📦 Installation

To add **flutter_circle_pack_chart** to your project, run:

```bash
flutter pub add flutter_circle_pack_chart
```

## 🚀 Getting Started

### 1. Define your data
Create a hierarchy of `CircleNode` objects. Use `displayValue` to show custom-formatted data like currency:

```dart
final root = CircleNode(
  label: 'Monthly Budget',
  color: Colors.blueGrey,
  children: [
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
  ],
);
```

### 2. Add the Widget
Place the `FlutterCirclePackChart` in your widget tree.

```dart
// Initialize the controller
final controller = FlutterCirclePackChartController(root: root);

// In your build method
FlutterCirclePackChart(
  root: root,
  controller: controller,
  showValue: true, // Toggle value visibility in circles
)
```

## 🛠️ Customization

| Property | Description | Default |
| :--- | :--- | :--- |
| `showValue` | Whether to display values/formatted values inside the circles. | `true` |
| `minRadiusRatio` | Minimum radius of a child circle as a fraction of its parent. | `0.20` |
| `fontSizeFactor` | A multiplier to adjust the responsive font size globally. | `1.0` |

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
