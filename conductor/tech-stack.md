# Tech Stack - Circle Pack Chart Library

## Core Technologies
- **Language:** [Dart](https://dart.dev/) (3.x) - Leverages sound null safety and efficient compilation.
- **Framework:** [Flutter](https://flutter.dev/) (Stable Channel) - For cross-platform high-performance 2D rendering.

## Architecture & State Management
- **State Management:** `ChangeNotifier` and `ValueListenableBuilder` - Built-in Flutter solutions for managing drill-down depth and view transformations without external dependencies.
- **Pattern:** Model-View-Controller (MVC) - Decoupling the layout algorithm (Model) from the rendering logic (View) and user interactions (Controller).

## Rendering & Graphics
- **Rendering Engine:** `CustomPainter` - Direct access to the low-level Canvas API for maximum performance during complex circle packing and zooming animations.
- **Animation Framework:** Flutter's `AnimationController` and `Tweens` - Ensuring smooth 60fps transitions for the drill-down effect.

## Dependencies (To be added via `pub`)
- `vector_math`: Essential for complex geometric calculations required by the recursive packing algorithm.
- `google_fonts`: For consistent typography in legends and labels.
- `flutter_lints`: To maintain code quality and follow Flutter best practices (Dev Dependency).