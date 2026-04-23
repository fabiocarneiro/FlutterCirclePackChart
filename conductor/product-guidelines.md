# Product Guidelines - Circular Treemap Library

## Prose Style
- **Technical & Concise:** All documentation, API references, and internal comments must be clear, direct, and focused on technical accuracy. Avoid conversational filler; prioritize information density for developers.

## Branding and Visual Design
- **Material 3 Standard:** The library will adhere to Material Design 3 principles.
    - **Color System:** Use the Material 3 color system (Primary, Secondary, Tertiary, Surface) for default themes.
    - **Typography:** Follow Material 3 typographic scales for labels and legends.
    - **Shapes:** Utilize standard corner radii and elevation patterns defined by M3.

## User Experience (UX) Principles
- **Performance & Fluidity:** Every transition, especially drill-down zooming, must aim for 60fps (or higher) to ensure a premium, lag-free experience.
- **Visual Hierarchy:** Clearly communicate the importance of data through size (circle area) and color intensity. The layout should immediately guide the eye to the most significant data points.

## Interaction and Feedback
- **Fluid Visual Animations:** All state changes (zooming, panning, filtering) must use smooth, non-linear interpolation (e.g., Curves.easeInOutCubic) to feel natural and responsive.
- **Continuous Feedback:** The user should feel in control during the transition, with visual cues indicating the current level of depth.