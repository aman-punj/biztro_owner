# STRUCTURE.md

## Architecture
The project follows a feature-driven structure using **GetX** for state management, dependency injection, and routing.

### Layers
- **Core**: Contains app-wide services, network clients, storage, themes, and shared widgets.
- **Features**: Contains individual feature modules. Each feature typically has:
  - `bindings/`: Dependency injection configuration.
  - `controllers/`: State and logic using `GetxController`.
  - `data/`: Data layer (models and repositories).
  - `views/`: UI layer (widgets and pages).
  - `widgets/`: Feature-specific reusable widgets.

## Standards
- **State Management**: ALWAYS use GetX (`Obx`, `GetxController`, `Get.find`). NEVER use `setState`.
- **Dependency Injection**: ALWAYS use feature-specific `Bindings` classes.
- **Network Layer**:
  - Use `ApiClient` (Dio wrapper).
  - Repositories MUST return `AppResponse<T>`.
  - NEVER throw exceptions from repositories.
- **Storage**:
  - Use `StorageService` or `AuthStorage`.
  - NEVER call `SharedPreferences` directly in features.
- **Navigation**:
  - ALWAYS use named routes via `Get.toNamed`.
  - NEVER use `Navigator.push`.
- **Imports**: ALWAYS use package imports (e.g., `package:bizrato_owner/...`). NEVER use relative imports (e.g., `../../../`).

## Folder Structure
```
lib/
├── core/
│   ├── app_toast/
│   ├── constants/
│   ├── dependencies/
│   ├── network/
│   ├── services/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── [feature_name]/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   └── views/
└── routes/
    ├── app_pages.dart
    └── app_routes.dart
```
