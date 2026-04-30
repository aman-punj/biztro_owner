# REFACTOR.md

## High Priority
- [x] **Remove `setState`**:
  - [x] `lib/features/business_edit/views/edit_business_details_view.dart`: Move local state to `EditBusinessDetailsController`.
  - [x] `lib/features/onboarding/widgets/business_information_stage.dart`: Move state to `OnboardingController`.
  - [ ] `lib/core/widgets/year_picker_dialog.dart`: Convert to a GetX-driven dialog or handle state internally without `setState` if possible.
- [ ] **Fix Relative Imports**:
  - `lib/features/auth/controllers/auth_controller.dart`
  - `lib/features/messages/views/chat_room_view.dart`
  - `lib/features/trusted_shield/views/live_identity_verification_view.dart`

## Technical Debt
- **AppTokens Audit**:
  - Replace raw hex values in `lib/core/theme/app_tokens.dart` (L63, L65, L66) with `AppColors` constants.
  - Move `warning`, `warningBackground`, `warningText` hex values to `AppColors` first.
- **Sizing Audit**:
  - Scan all files in `lib/` for raw double values and apply `.w`, `.h`, `.sp`, or `.r`.
- **Color Audit**:
  - Replace any remaining `Color(0xFF...)` in `lib/` with `AppTokens` references.

## Network & Data
- **Repository Return Types**: Ensure all repositories in `features/` return `AppResponse`.
- **Error Handling**: Replace raw error displays with `response.message` in controllers.
