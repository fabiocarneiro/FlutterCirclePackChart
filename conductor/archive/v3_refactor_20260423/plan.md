# Implementation Plan - v3.0.0 "Widget as Root" Refactor [checkpoint: 6b6d245]

## Phase 1: Controller & Navigation Logic [checkpoint: 6b6d245]
- [x] Task: Refactor `FlutterCirclePackChartController` fa93a2b
    - [x] Support initialization with a list of top-level nodes instead of a single root.
    - [x] Update navigation stack to handle the "virtual root" (no node focused).
    - [x] Ensure `goBack` and `drillDown` correctly manage the new state.

## Phase 2: Widget & Internal Engine [checkpoint: 6b6d245]
- [x] Task: Refactor `FlutterCirclePackChart` Widget fa93a2b
    - [x] Update constructor to accept `title` and `children`.
    - [x] Refactor internal `_packedNode` state initialization.
- [x] Task: Refactor `CirclePacker` fa93a2b
    - [x] Create a new entry point that packs a list of nodes within a given radius, without needing a parent node.
- [x] Task: Update `FlutterCirclePackChartPainter` fa93a2b
    - [x] Update drawing logic to start from the top-level list.

## Phase 3: Tests & Integration [checkpoint: 6b6d245]
- [x] Task: Update all Unit Tests fa93a2b
- [x] Task: Update all Widget Tests fa93a2b
- [x] Task: Refactor Example App fa93a2b
    - [x] Update Countries, Budget, and Stress Tests to the new API.
- [x] Task: Update README 0d556f4
- [x] Task: Conductor - Final Manual Verification (Protocol in workflow.md) 6b6d245
