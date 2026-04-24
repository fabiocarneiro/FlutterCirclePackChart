# Implementation Plan - v2.0.0 Refactor

## Phase 1: Breaking Data Model Changes
- [x] Task: Refactor `CircleNode`
    - [x] Rename `upperLabel` to `formattedValue`.
    - [x] Update `fromMap` factory.
    - [x] Update all library files and tests to use new field names.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Breaking Data Model Changes' (Protocol in workflow.md)

## Phase 2: Painter & Rendering Logic
- [x] Task: Implement Dynamic Opacity [df36ffe]
    - [x] Calculate relative opacity in `_drawNode` based on child values.
    - [x] Blend with animation opacity.
- [x] Task: Implement Value Visibility Flag [df36ffe]
    - [x] Add `showValue` to `FlutterCirclePackChart` and `FlutterCirclePackChartPainter`.
    - [x] Update `_drawLabel` to respect the flag and prefer `formattedValue`.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Painter & Rendering Logic' (Protocol in workflow.md)

## Phase 3: Sync & Examples
- [~] Task: Update Legend and Examples
    - [ ] Update `FlutterCirclePackChartLegend` to use `formattedValue`.
    - [ ] Refactor all 3 examples to use the new API.
- [ ] Task: Update README and Documentation
    - [ ] Document breaking changes and new features.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Sync & Examples' (Protocol in workflow.md)
