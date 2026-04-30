# UI.md

## Standards
- **Sizing**: ALWAYS use `flutter_screenutil` suffixes:
  - `.w`: Width
  - `.h`: Height
  - `.sp`: Font size
  - `.r`: Radius
- **Colors**:
  - ALWAYS use `AppTokens` for semantic colors.
  - NEVER use raw hex `Color(0xFF...)` in widget files.
  - `AppColors` is for the palette only.
- **Widgets**:
  - Use `AppImage` for assets.
  - Wrap bottom action rows in `SafeArea`.
  - Use `AppPageShell` or `AppScaffoldAppBar` for consistency.

## Current Violations & Technical Debt
- **setState Usage**: Found in several files (e.g., `EditBusinessDetailsView`, `BusinessInformationStage`).
- **Raw Sizing**: Many widgets still use raw double values without `screenutil` suffixes.
- **Raw Colors**: Some files might still contain hardcoded `Color` values.
- **Relative Imports**: Found in `AuthController`, `ChatRoomView`, etc.

## Guidelines
- **Bottom Bars**: Ensure all fixed bottom bars are wrapped in `SafeArea` for modern gesture-based navigation support.
- **Input Fields**: Use `AppTextField` and ensure consistent padding/radius.
- **Images**: Use `AppImage` which handles SVG, PNG, and network images with proper caching/placeholders.
