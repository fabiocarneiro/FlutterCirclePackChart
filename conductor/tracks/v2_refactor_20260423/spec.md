# Specification: Major Refactor (v2.0.0)

## Overview
This major release refactors the data model and rendering logic to support structured value display and dynamic visual effects based on data importance. It introduces breaking changes to `CircleNode` for a cleaner API.

## Functional Requirements
- **Data Model Refactor (`CircleNode`):**
    - Remove `upperLabel`.
    - Add `formattedValue` (String) for displaying custom-formatted data (currency, percentages, etc.).
    - Primary `label` remains for the descriptive name.
    - `value` (double) continues to drive sizing and legend totals.
- **Rendering Refinements:**
    - **Value Visibility Flag:** Add `showValue` flag to the widget to toggle displaying the value (preferring `formattedValue`) inside the circles.
    - **Dynamic Opacity:** Implement opacity scaling for children based on their relative values (larger items are more opaque, smaller items are more subtle).
    - **Independent Styling:** Maintain larger/bold styling for the value line when displayed in the circle.
- **Legend Update:** Sync with the new model, ensuring the value shown matches the numeric `value` or `formattedValue`.

## Breaking Changes
- `CircleNode` constructor parameters have changed.
- `secondaryLabel` / `upperLabel` are replaced by `formattedValue`.
