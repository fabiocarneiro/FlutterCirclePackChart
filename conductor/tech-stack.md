# Tech Stack - FlutterCirclePackChart

## Core Technologies
- **Language:** [Dart](https://dart.dev/) (3.x) - Leverages sound null safety and efficient compilation.
- **Framework:** [Flutter](https://flutter.dev/) (Stable Channel) - For cross-platform high-performance 2D rendering.

## Architecture & State Management
- **State Management:** `ValueNotifier` and `ListenableBuilder` - Built-in Flutter solutions for managing drill-down depth and view transformations.
- **Pattern:** Model-View-Controller (MVC) - Decoupling the hierarchical data model (`CircleNode`) from the rendering logic (`FlutterCirclePackChartPainter`) and navigation logic (`FlutterCirclePackChartController`).

## Rendering & Graphics
- **Rendering Engine:** `CustomPainter` - Direct access to the low-level Canvas API for maximum performance during complex circle packing and "explosion/implosion" animations.
- **Animation Framework:** Flutter's `AnimationController` and `CurvedAnimation` - Ensuring smooth 800ms transitions with immersive zooming.
- **Anti-Scaling Logic:** Specialized math to maintain constant visual font sizes for labels regardless of the camera zoom level.

## Dependencies (Added via `pub`)
- `vector_math`: Essential for complex geometric calculations and 3D transformation matrices (`Matrix4`).
- `google_fonts`: For professional, consistent typography across charts and legends.
- `flutter_lints`: To maintain code quality and follow Flutter best practices (Dev Dependency).
