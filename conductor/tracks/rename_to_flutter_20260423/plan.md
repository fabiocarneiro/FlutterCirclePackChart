# Implementation Plan - Rename project to FlutterCirclePackChart

## Phase 1: Codebase Rename
- [ ] Task: Update pubspec.yaml
    - [ ] Change name to `flutter_circle_pack_chart`.
- [ ] Task: Rename Library Files
    - [ ] `lib/circle_pack_chart.dart` -> `lib/flutter_circle_pack_chart.dart`.
    - [ ] `lib/circle_pack_chart_painter.dart` -> `lib/flutter_circle_pack_chart_painter.dart`.
    - [ ] `lib/circle_pack_chart_widget.dart` -> `lib/flutter_circle_pack_chart_widget.dart`.
    - [ ] `lib/circle_pack_chart_controller.dart` -> `lib/flutter_circle_pack_chart_controller.dart`.
    - [ ] `lib/circle_pack_chart_legend.dart` -> `lib/flutter_circle_pack_chart_legend.dart`.
- [ ] Task: Update Class Names and References
    - [ ] `CirclePackChart` -> `FlutterCirclePackChart`.
    - [ ] `CirclePackChartPainter` -> `FlutterCirclePackChartPainter`.
    - [ ] `CirclePackChartController` -> `FlutterCirclePackChartController`.
    - [ ] `CirclePackChartLegend` -> `FlutterCirclePackChartLegend`.
- [ ] Task: Update Tests
    - [ ] Rename test files and update all imports and class references.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Codebase Rename' (Protocol in workflow.md)

## Phase 2: Docs & Example App
- [ ] Task: Update Documentation
    - [ ] Sync `conductor/product.md`, `conductor/index.md`, and root `README.md`.
- [ ] Task: Update Example App
    - [ ] Update `example/pubspec.yaml` and `example/lib/main.dart`.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Docs & Example App' (Protocol in workflow.md)
