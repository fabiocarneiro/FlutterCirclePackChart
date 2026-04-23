# FlutterCirclePackChart

A powerful, interactive, and highly customizable Circle Pack Chart (Circular Treemap) library for Flutter. Built with performance and user experience in mind, it features immersive drill-down navigation and a responsive, structured label system.

## 🌟 Features

- **🚀 Immersive Drill-Down:** Tapping a circle triggers a smooth, symmetric "breaking apart" animation where children emerge from the parent's center as the view zooms in.
- **♾️ Infinite Zoom Context:** Sibling nodes remain visible and partially overflow the square viewport during transitions, maintaining clear hierarchical context.
- **🔄 Bidirectional Navigation:** Seamlessly supports both drill-in (explosion) and drill-out (implosion) animations for a natural, physical feel.
- **📏 Professional Label System:**
  - **Structured Data:** Use `label` for the name and `upperLabel` for monetary values or subtitles (rendered larger and bold).
  - **Guaranteed Visibility:** Enforces a minimum circle size to ensure every item has a legible label.
  - **Anti-Scaled Consistency:** Labels maintain a constant visual size on screen regardless of the zoom level.
  - **Clean Aesthetic:** Flat, normal-weight text with automatic single-line ellipsis for long names.
- **📋 Dynamic Legend:** Includes a built-in vertical legend component that automatically updates to reflect the items, colors, and values of the currently focused level.
- **🎨 Highly Customizable:** Adjust animation speed, minimum radius ratios, font size factors, and colors to match your app's brand.

## 📦 Installation

Add `flutter_circle_pack_chart` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_pack_chart:
    git:
      url: https://github.com/fabiocarneiro/FlutterCirclePackChart.git
```

## 🚀 Getting Started

### 1. Define your data
Create a hierarchy of `CircleNode` objects. You can use both `label` and `secondaryLabel` to display structured data on two lines:

```dart
final root = CircleNode(
  label: 'Monthly Budget',
  color: Colors.blueGrey,
  children: [
    CircleNode(
      label: 'Needs',
      secondaryLabel: '\$2500',
      color: Colors.orange,
      children: [
        CircleNode(label: 'Rent', secondaryLabel: '\$1500', value: 1500.0),
        CircleNode(label: 'Groceries', secondaryLabel: '\$400', value: 400.0),
      ],
    ),
    CircleNode(
      label: 'Wants',
      secondaryLabel: '\$1100',
      color: Colors.pink,
      children: [
        CircleNode(label: 'Dining', secondaryLabel: '\$300', value: 300.0),
      ],
    ),
  ],
);
```

### 2. Add the Widget
Place the `FlutterCirclePackChart` in your widget tree. Optionally use a `FlutterCirclePackChartController` for advanced navigation and legend support.

```dart
// Initialize the controller
final controller = FlutterCirclePackChartController(root: root);

// In your build method
Column(
  children: [
    Expanded(
      child: FlutterCirclePackChart(
        root: root,
        controller: controller,
      ),
    ),
    // Add the dynamic legend (shows primary labels only)
    FlutterCirclePackChartLegend(controller: controller),
  ],
)
```

## 🛠️ Customization

| Property | Description | Default |
| :--- | :--- | :--- |
| `minRadiusRatio` | Minimum radius of a child circle as a fraction of its parent. | `0.20` |
| `fontSizeFactor` | A multiplier to adjust the responsive font size globally. | `1.0` |
| `controller` | Custom controller to manage focus and navigation state. | `Auto-generated` |

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
