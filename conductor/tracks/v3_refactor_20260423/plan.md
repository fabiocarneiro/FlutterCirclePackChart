# Implementation Plan - v3.0.0 "Widget as Root" Refactor

## Phase 1: Controller & Navigation Logic
- [~] Task: Refactor `FlutterCirclePackChartController`
    - [ ] Support initialization with a list of top-level nodes instead of a single root.
    - [ ] Update navigation stack to handle the "virtual root" (no node focused).
    - [ ] Ensure `goBack` and `drillDown` correctly manage the new state.

## Phase 2: Widget & Internal Engine
- [ ] Task: Refactor `FlutterCirclePackChart` Widget
    - [ ] Update constructor to accept `title` and `children`.
    - [ ] Refactor internal `_packedNode` state initialization.
- [ ] Task: Refactor `CirclePacker`
    - [ ] Create a new entry point that packs a list of nodes within a given radius, without needing a parent node.
- [ ] Task: Update `FlutterCirclePackChartPainter`
    - [ ] Update drawing logic to start from the top-level list.

## Phase 3: Tests & Integration
- [ ] Task: Update all Unit Tests
- [ ] Task: Update all Widget Tests
- [ ] Task: Refactor Example App
    - [ ] Update Countries, Budget, and Stress Tests to the new API.
- [ ] Task: Update README
- [ ] Task: Conductor - Final Manual Verification (Protocol in workflow.md)
