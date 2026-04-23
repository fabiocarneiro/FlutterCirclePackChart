# Specification: Implement core circular treemap layout and drill-down visualization

## Overview
This track focuses on the foundational components of the Circular Treemap library. It includes the data model, the recursive packing algorithm, the rendering engine using `CustomPainter`, and the core drill-down interactivity.

## User Stories
- As a developer, I want to define hierarchical data structures easily.
- As a user, I want to see a clear visualization of nested data as circles within circles.
- As a user, I want to tap a circle to drill down into its contents with smooth animations.

## Functional Requirements
- **Data Model:** A `CircleNode` class representing a node in the hierarchy, containing a label, a value, an optional color, and a list of children.
- **Packing Algorithm:** A `CirclePacker` class that implements a recursive algorithm to calculate positions $(x, y)$ and radius $r$ for each node.
- **Rendering:** A `CircularTreemapPainter` that draws circles and labels on a `Canvas`.
- **Interactivity:** A `CircularTreemap` widget that handles tap gestures to update the "focused" node.
- **Animations:** Use `AnimatedBuilder` logic to transition between different focus states.

## Technical Constraints
- Must maintain 60fps during transitions.
- No third-party state management (use `ValueNotifier`).
- Use `vector_math` for geometry calculations.