# FlutterCirclePackChart

A powerful, interactive, and highly customizable Circle Pack Chart (Circular Treemap) library for Flutter. Built with performance and user experience in mind, it features immersive drill-down navigation and a responsive label system.

## 🌟 Features

- **🚀 Immersive Drill-Down:** Tapping a circle triggers a smooth, symmetric "breaking apart" animation where children emerge from the parent's center as the view zooms in.
- **♾️ Infinite Zoom Context:** Sibling nodes remain visible and partially overflow the square viewport during transitions, maintaining clear hierarchical context.
- **🔄 Bidirectional Navigation:** Seamlessly supports both drill-in (explosion) and drill-out (implosion) animations for a natural, physical feel.
- **📏 Professional Label System:**
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
Create a hierarchy of `CircleNode` objects:

```dart
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
      ],
    ),
  ],
);
```

### 2. Add the Widget
Place the `FlutterCirclePackChart` in your widget tree. Optionally use a `FlutterCirclePackChartController` for advanced navigation.

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
    // Add the dynamic legend
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
