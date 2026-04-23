# Specification: Rename project to FlutterCirclePackChart

## Overview
The project is being renamed to "FlutterCirclePackChart" to explicitly indicate its compatibility with the Flutter framework. This involves updating the package name, file names, class names, and all documentation.

## Functional Requirements
- **Package Renaming:** Update `pubspec.yaml` `name` field to `flutter_circle_pack_chart`.
- **File Renaming:** Prefix all relevant library and test files with `flutter_`.
- **Class Renaming:** Prefix main classes (e.g., `CirclePackChart`) with `Flutter`.
- **Documentation:** Sync all `conductor/*.md` files and the root `README.md`.
- **Example App:** Update the example app to use the new package name and classes.

## Technical Constraints
- No breaking changes to the core logic (packing algorithm).
- Maintain 100% test pass rate after rename.
