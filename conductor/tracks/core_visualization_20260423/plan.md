# Implementation Plan - Implement core circular treemap layout and drill-down visualization

## Phase 1: Foundation & Data Model
- [ ] Task: Define Hierarchical Data Model
    - [ ] Create `CircleNode` class with properties for label, value, color, and children.
    - [ ] Implement a factory or utility to convert a `Map` or `JSON` to `CircleNode`.
    - [ ] Write unit tests for data model validation.
- [ ] Task: Implement recursive circle packing algorithm
    - [ ] Create `CirclePacker` class.
    - [ ] Implement the core packing logic (calculate local $x, y, r$ for a list of siblings).
    - [ ] Implement recursive calculation for the entire tree.
    - [ ] Write unit tests to verify packing correctness and non-overlapping constraints.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Foundation & Data Model' (Protocol in workflow.md)

## Phase 2: Rendering & Visualization
- [ ] Task: Implement CustomPainter for circle rendering
    - [ ] Create `CircularTreemapPainter` to draw circles and basic text labels.
    - [ ] Write widget tests for `CustomPainter` rendering.
- [ ] Task: Create basic CircularTreemap widget
    - [ ] Create `CircularTreemap` widget that takes a `CircleNode` root.
    - [ ] Integrate the `CirclePacker` and `CircularTreemapPainter`.
    - [ ] Write widget tests for initial rendering.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Rendering & Visualization' (Protocol in workflow.md)

## Phase 3: Interaction & Animation
- [ ] Task: Implement drill-down state management
    - [ ] Create `TreemapController` using `ValueNotifier` to track the current focused node.
    - [ ] Add navigation logic (drill down to child, move up to parent).
    - [ ] Write unit tests for state transitions.
- [ ] Task: Add zoom/transform animations for drill-down
    - [ ] Implement view transformation logic (calculate scale and offset to focus on a node).
    - [ ] Wrap the painter in an `AnimatedBuilder` to animate the transformation.
    - [ ] Write widget tests for animation triggers and state updates.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Interaction & Animation' (Protocol in workflow.md)

## Phase 4: Legend & Polish
- [ ] Task: Implement dynamic legend widget
    - [ ] Create `TreemapLegend` widget that listens to the `TreemapController`.
    - [ ] Implement logic to display items within the currently focused level.
    - [ ] Write widget tests for legend updates.
- [ ] Task: Refinement & Documentation
    - [ ] Add documentation comments to all public APIs.
    - [ ] Create a sample `main.dart` demonstrating the library usage.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Legend & Polish' (Protocol in workflow.md)