# AGENTS.md

## Color Usage Rules
- NEVER use raw hex Color() values in widget files
- ALWAYS use AppTokens.xxx for semantic colors (e.g. AppTokens.textPrimary)
- AppColors is the palette file only — not for direct widget use
- If a color is missing from AppTokens, add it there first, then use it

## Sizing Rules
- ALWAYS use flutter_screenutil suffixes: .w .h .sp .r
- NEVER use raw double values for sizing in widgets

## State Management
- ALWAYS use GetX (Obx, GetxController, Get.find)
- NEVER use setState

## Network
- ALWAYS return AppResponse<T> from repositories
- NEVER throw exceptions from repositories or call sites
- NEVER call SharedPreferences directly — use AuthStorage or StorageService

## Navigation
- ALWAYS use named routes via Get.toNamed / Get.offAllNamed
- NEVER use Navigator.push directly

## Dependencies
- App-level services registered in AppDependencies with permanent: true
- Feature controllers registered in their own Bindings

## Imports
- Use package imports not relative imports
```

The more specific your rules, the less you clean up after Codex. Treat `AGENTS.md` like a senior dev's code review checklist that runs before every PR.

---

**Prompt for the token layer:**
```
Create lib/core/theme/app_tokens.dart as a semantic color token layer over AppColors.

Rules:
- AppTokens contains only static const references to AppColors values — no hex codes
- Group by: Backgrounds, Text, Brand, States, Borders, Component-specific
- Cover every color currently in AppColors
- Add a comment on each: what it's used for semantically

Then audit these files and replace any raw Color(0xFF...) hex values with the
correct AppTokens reference:
- lib/features/dashboard/controllers/dashboard_controller.dart
- Any widget file that imports dart:ui or uses Color(0xFF...) directly

Do NOT change AppColors.dart itself.
Do NOT change AppTheme.dart — it correctly references AppColors directly (that is fine for theme setup).