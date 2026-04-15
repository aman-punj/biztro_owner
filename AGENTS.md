
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

## Network Error Handling
- ALWAYS normalize no-internet, failed-host-lookup, connection-refused, and timeout failures in ApiClient/AppErrors before controllers or views consume them
- NEVER show raw DioException text in Festival, Course, Dashboard, Business Edit, or any other feature; use `response.message` or app-level toast/dialog messaging instead

## Server Image Preview
- For image previews backed by our server, follow the `lib/features/festival/views/festival_list_view.dart` pattern
- ALWAYS build the image URL in the controller with `buildImageUrl(...)`
- ALWAYS provide authenticated image headers from the controller with `buildImageHeaders()`
- Pass both `imageUrl` and `imageHeaders` into the widget that renders the preview instead of hardcoding URLs or fetching images directly in the view

## Business Edit UI
- ALWAYS wrap bottom action rows like Discard/Save in `SafeArea` so they stay above Android system navigation bars
- For social or settings link forms, use `AppImage` with asset paths declared in `AppAssets` instead of raw `Icon(...)` widgets when design-provided PNG/SVG assets are expected
- For stacked link inputs, place each field inside its own rounded background container to match the existing business-edit card treatment
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
