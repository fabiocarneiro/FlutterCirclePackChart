## 2.0.0

* **Breaking Change:** Refactored `CircleNode` data model. Renamed `upperLabel` to `displayValue` and reordered constructor arguments (`value` now comes before `displayValue`).
* **New Feature:** Added `showValue` and `showLabels` flags to `FlutterCirclePackChart` for granular display control.
* **New Feature:** Implemented **Dynamic Opacity**: Circles now automatically scale their opacity (0.85 - 1.0) based on their relative values to highlight data importance.
* **Typographic Refinement:** Implemented independent "anti-scaling" for value and label lines, ensuring perfect sharpness and a balanced visual hierarchy.
* Refactored example app with three distinct demo categories: Countries, Budget, and Stress Tests.

## 1.0.4

* Implemented "Deck of Cards" drawing order: larger circles now stay on top of smaller ones during all transitions.
* Enhanced animation aesthetics, allowing smaller circles to naturally emerge from or hide behind larger ones.

## 1.0.3

* Perfected symmetry of the implosion (drill-out) animation for a more natural feel.
* Fixed visual overlap during transitions by ensuring children merge fully before the parent reappears.

## 1.0.2

* Simplify installation instructions in README to be version-agnostic.

## 1.0.1

* Update README with official pub.dev installation instructions.
* Link to the live demo website in README.

## 1.0.0

* Initial release of FlutterCirclePackChart.
* Core recursive circle packing algorithm.
* Immersive drill-down and back-navigation interactivity.
* Symmetric explosion/implosion animations for smooth transitions.
* Professional label system with anti-scaling and uniform sizing.
* Built-in vertical legend component.
* Fully responsive layout supporting all screen resolutions.
