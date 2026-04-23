# Implementation Plan - Implement core circular treemap layout and drill-down visualization

## Phase 1: Foundation & Data Model [checkpoint: 36bce31]
- [x] Task: Define Hierarchical Data Model [4eb6776]
    - [x] Create `CircleNode` class with properties for label, value, color, and children.
    - [x] Implement a factory or utility to convert a `Map` or `JSON` to `CircleNode`.
    - [x] Write unit tests for data model validation.
- [x] Task: Implement recursive circle packing algorithm [3e47928]
    - [x] Create `CirclePacker` class.
    - [x] Implement the core packing logic (calculate local $x, y, r$ for a list of siblings).
    - [x] Implement recursive calculation for the entire tree.
    - [x] Write unit tests to verify packing correctness and non-overlapping constraints.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Foundation & Data Model' (Protocol in workflow.md) [36bce31]

## Phase 2: Rendering & Visualization
- [x] Task: Implement CustomPainter for circle rendering [6eb0d96]
    - [x] Create `CircularTreemapPainter` to draw circles and basic text labels.
    - [x] Write widget tests for `CustomPainter` rendering.
- [x] Task: Create basic CircularTreemap widget [ec20cc6]
    - [x] Create `CircularTreemap` widget that takes a `CircleNode` root.
    - [x] Integrate the `CirclePacker` and `CircularTreemapPainter`.
    - [x] Write widget tests for initial rendering.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Rendering & Visualization' (Protocol in workflow.md)

## Phase 3: Interaction & Animation [checkpoint: d6851ca]
- [x] Task: Implement drill-down state management [08654be]
    - [x] Create `TreemapController` using `ValueNotifier` to track the current focused node.
    - [x] Add navigation logic (drill down to child, move up to parent).
    - [x] Write unit tests for state transitions.
- [x] Task: Add zoom/transform animations for drill-down [535443f]
    - [x] Implement view transformation logic (calculate scale and offset to focus on a node).
    - [x] Wrap the painter in an `AnimatedBuilder` to animate the transformation.
    - [x] Write widget tests for animation triggers and state updates.
- [x] Task: Conductor - User Manual Verification 'Phase 3: Interaction & Animation' (Protocol in workflow.md) [d6851ca]

## Phase 4: Legend & Polish
- [~] Task: Implement dynamic legend widget
    - [ ] Create `TreemapLegend` widget that listens to the `TreemapController`.
    - [ ] Implement logic to display items within the currently focused level.
    - [ ] Write widget tests for legend updates.
- [ ] Task: Refinement & Documentation
    - [ ] Add documentation comments to all public APIs.
    - [ ] Create a sample `main.dart` demonstrating the library usage.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Legend & Polish' (Protocol in workflow.md)