# TASKS.md

## Task List: Improvement & Refactoring

- [ ] **T1: Clean up Imports**
  - Convert all relative imports to package imports across the project.
- [ ] **T2: Standardize Colors**
  - Move missing colors from `AppTokens` to `AppColors`.
  - Replace raw hex in `AppTokens` with `AppColors` references.
  - Audit widgets for raw `Color` usage and replace with `AppTokens`.
- [ ] **T3: Standardize Sizing**
  - Audit all widgets for raw double values.
  - Apply `.w`, `.h`, `.sp`, `.r` suffixes where missing.
- [ ] **T4: Eliminate `setState`**
  - Refactor `EditBusinessDetailsView` to use GetX controller.
  - Refactor `BusinessInformationStage` to use GetX controller.
  - Refactor `YearPickerDialog` to use GetX or standardized state.
- [ ] **T5: Repository & Network Audit**
  - Verify all repositories return `AppResponse`.
  - Ensure controllers handle `AppResponse.message` for error toasts/dialogs.
- [ ] **T6: UI Consistency**
  - Verify `SafeArea` usage for bottom action bars.
  - Ensure `AppImage` is used for all asset-based icons/images.
- [ ] **T7: Documentation**
  - Keep `STRUCTURE.md`, `UI.md`, and `REFACTOR.md` updated as changes are made.
