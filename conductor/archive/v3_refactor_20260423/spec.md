# Specification: "Widget as Root" Architecture (v3.0.0)

## Overview
This major release refactors the entry point of the library to remove the unnecessary and confusing "Root Node" data object. Instead of wrapping the entire hierarchy in a single `CircleNode`, the `FlutterCirclePackChart` widget will now act as the root, accepting a `title` and a top-level list of `children` directly.

## Functional Requirements
- **Data Model Refinement:**
    - `CircleNode` remains for all hierarchical items. (We may rename it to `CirclePackNode` for clarity, but the user prefers clean names).
    - The requirement for a single "Parent" node at the top level is removed.
- **Widget Refactor (`FlutterCirclePackChart`):**
    - Remove the `root` parameter.
    - Add `title` (String) parameter for the overall chart name.
    - Add `children` (List<CircleNode>) parameter for the top-level items.
- **Controller Refactor:**
    - Update `FlutterCirclePackChartController` to initialize with the top-level items.
    - The "Top" level in navigation will now represent the state where no child node is focused.
- **Internal Logic:**
    - The `CirclePacker` will be updated to pack the top-level `children` within the square viewport automatically.
    - The `Painter` will no longer rely on a single root node for the coordinate system entry point.

## Breaking Changes
- `FlutterCirclePackChart` constructor parameters `root` is removed.
- Users must now provide `title` and `children` directly to the widget.
- Navigation history logic in the controller is updated to handle the "virtual root" (the widget itself).
