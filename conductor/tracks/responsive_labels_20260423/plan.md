# Implementation Plan - Implement responsive label scaling

## Phase 1: Core Implementation
- [x] Task: Update CircularTreemapPainter for dynamic font size
    - [x] Add `baseFontSize` parameter to constructor.
    - [x] Use `baseFontSize` in `_drawLabel` anti-scaling logic.
    - [x] Update tests to reflect new constructor.
- [x] Task: Implement responsive logic in CircularTreemap widget
    - [x] Add `fontSizeFactor` parameter to widget (default 1.0).
    - [x] Calculate `responsiveFontSize` in `build` method based on constraints.
    - [x] Pass calculated size to the painter.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Core Implementation' (Protocol in workflow.md) [df36ffe]

## Phase 2: Refinement & Demo
- [x] Task: Update Example App [df36ffe]
    - [x] Add a slider or toggle in the example app to demonstrate font scaling (optional).
    - [x] Verify look on simulated large screens.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Refinement & Demo' (Protocol in workflow.md) [df36ffe]