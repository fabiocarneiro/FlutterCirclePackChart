# Specification: Rename project to CirclePackChart

## Overview
The user has chosen "CirclePackChart" as the permanent name for the project. This track involves renaming the Flutter package, its files, and all associated documentation to reflect this change consistently.

## Functional Requirements
- **Package Renaming:** Update `pubspec.yaml` `name` field to `circle_pack_chart`.
- **Primary Entry Point:** Rename `lib/circular_treemap.dart` to `lib/circle_pack_chart.dart`.
- **Internal References:** Update all imports, class names (if necessary/appropriate), and documentation comments.
- **Conductor Artifacts:** Replace all occurrences of "Circular Treemap" or the old package name in `conductor/*.md` files.
- **Example App:** Update `example/pubspec.yaml` to depend on `circle_pack_chart` and fix imports in `example/lib/main.dart`.

## Technical Constraints
- Ensure the project still builds and tests pass after the rename.
- Maintain the Git history of renamed files where possible.