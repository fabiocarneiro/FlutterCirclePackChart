# Specification: Implement responsive label scaling

## Overview
Currently, labels have a fixed visual size of 12.0. While this works on mobile, it appears too small on high-resolution or ultra-wide displays. This track will introduce responsive logic to scale the base font size according to the available viewport area.

## User Stories
- As a user on a large monitor, I want the treemap labels to be large and clear enough to read without squinting.
- As a mobile user, I want the labels to remain appropriately small to fit the compact screen.

## Functional Requirements
- **Responsive Font Calculation:** The `CircularTreemap` widget must calculate a `baseFontSize` that scales proportionally with the viewport's smallest dimension (e.g., $12.0 + (\text{minDimension} / 100)$ with sane bounds).
- **Painter Update:** The `CircularTreemapPainter` must accept this dynamic `baseFontSize` instead of using a hardcoded value.
- **Customization:** Add a `fontSizeFactor` or similar parameter to the `CircularTreemap` widget to allow users to tune the overall text size.

## Technical Constraints
- Must maintain consistent visual size during zoom animations (anti-scaling must still work relative to the dynamic base).
- No breaking changes to existing `CircleNode` or `CirclePacker` logic.