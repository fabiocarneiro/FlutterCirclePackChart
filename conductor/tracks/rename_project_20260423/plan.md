# Implementation Plan - Rename project to CirclePackChart

## Phase 1: Package & Code Rename
- [x] Task: Update pubspec.yaml and core files
    - [x] Rename package in `pubspec.yaml`.
    - [x] Rename `lib/circular_treemap.dart` to `lib/circle_pack_chart.dart`.
    - [x] Update internal imports and doc comments in all `lib/` files.
- [x] Task: Update Tests
    - [x] Update all imports in `test/` directory.
    - [x] Rename test files if they reference the old package name.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Package & Code Rename' (Protocol in workflow.md)

## Phase 2: Documentation & Example Rename
- [x] Task: Update Documentation
    - [x] Update `conductor/product.md`, `conductor/tech-stack.md`, and `conductor/index.md`.
    - [x] Update root `README.md`.
- [x] Task: Update Example App
    - [x] Update `example/pubspec.yaml` dependency name.
    - [x] Update imports in `example/lib/main.dart`.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Documentation & Example Rename' (Protocol in workflow.md) [b59108a]