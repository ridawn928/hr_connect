# Folder Structure

This document details the organization of the HR Connect codebase, which follows the Modified Vertical Slice Architecture (MVSA) pattern.

## Root Structure

The top-level structure of the project is organized as follows:

```
hr_connect/
  ├── lib/              # Dart source code
  ├── test/             # Test files
  ├── assets/           # Static assets (images, fonts, etc.)
  ├── android/          # Android-specific code
  ├── ios/              # iOS-specific code
  ├── web/              # Web-specific code
  ├── docs/             # Documentation
  ├── build/            # Build output (generated)
  ├── .dart_tool/       # Dart tools directory (generated)
  ├── pubspec.yaml      # Project dependencies
  └── README.md         # Project overview
```

## Library Structure

The `lib` directory is structured according to the MVSA pattern with a clear separation between core components and feature slices:

```
lib/
  ├── main.dart                # Application entry point
  ├── app.dart                 # Main app widget
  ├── core/                    # Shared infrastructure
  └── features/                # Business capability slices
```

## Core Directory

The `core` directory contains shared infrastructure used across all features:

```
core/
  ├── di/                      # Dependency injection
  │   ├── injection.dart
  │   ├── injection_config.dart
  │   ├── service_locator.dart
  │   └── modules/             # Feature-specific DI modules
  │
  ├── error/                   # Error handling
  │   ├── failures.dart
  │   ├── exceptions.dart
  │   └── error_handler.dart
  │
  ├── network/                 # Network communication
  │   ├── api_client.dart
  │   ├── interceptors/
  │   └── connectivity/
  │
  ├── storage/                 # Local storage
  │   ├── database/
  │   ├── secure_storage/
  │   └── preferences/
  │
  ├── auth/                    # Authentication
  │   ├── token_manager.dart
  │   ├── user_role.dart
  │   └── auth_service.dart
  │
  ├── security/                # Security utilities
  │   ├── encryption_service.dart
  │   ├── key_manager.dart
  │   └── biometrics_service.dart
  │
  ├── routing/                 # Navigation
  │   ├── app_router.dart
  │   ├── app_router_impl.dart
  │   ├── navigation_service.dart
  │   └── route_guards.dart
  │
  ├── providers/               # Global state providers
  │   ├── auth_provider.dart
  │   └── connectivity_provider.dart
  │
  ├── theme/                   # Styling and theming
  │   ├── app_theme.dart
  │   ├── colors.dart
  │   └── text_styles.dart
  │
  ├── widgets/                 # Shared UI components
  │   ├── error_display.dart
  │   ├── loading_indicator.dart
  │   └── offline_indicator.dart
  │
  ├── utils/                   # Utilities
  │   ├── date_utils.dart
  │   ├── string_utils.dart
  │   ├── validators.dart
  │   └── logger.dart
  │
  ├── localization/            # Internationalization
  │   ├── app_localizations.dart
  │   └── languages/
  │
  └── presentation/            # Shared presentation logic
      ├── base_screen.dart
      └── mixins/
```

## Features Directory

The `features` directory contains vertical slices for each business capability:

```
features/
  ├── authentication/          # Authentication feature
  │   ├── domain/              # Domain layer
  │   │   ├── entities/
  │   │   ├── repositories/
  │   │   └── use_cases/
  │   ├── data/                # Data layer
  │   │   ├── models/
  │   │   ├── repositories/
  │   │   └── datasources/
  │   └── presentation/        # UI layer
  │       ├── screens/
  │       ├── widgets/
  │       └── providers/
  │
  ├── attendance/              # QR attendance feature
  │   ├── domain/
  │   ├── data/
  │   └── presentation/
  │
  ├── time_management/         # Leave and time tracking
  │   ├── domain/
  │   ├── data/
  │   └── presentation/
  │
  ├── employee/                # Employee profiles
  │   ├── domain/
  │   ├── data/
  │   └── presentation/
  │
  └── admin/                   # Admin portals
      ├── domain/
      ├── data/
      └── presentation/
```

## Test Directory

The test directory mirrors the structure of the lib directory with test files for each component:

```
test/
  ├── unit/                    # Unit tests
  │   ├── core/                # Core component tests
  │   │   ├── di/
  │   │   ├── network/
  │   │   └── ...
  │   └── features/            # Feature-specific tests
  │       ├── authentication/
  │       ├── attendance/
  │       └── ...
  │
  ├── widget/                  # Widget tests
  │   ├── core/
  │   └── features/
  │
  ├── integration/             # Integration tests
  │   └── features/
  │
  └── e2e/                     # End-to-end tests
```

## Documentation Directory

The documentation directory contains architecture documentation and development guides:

```
docs/
  ├── architecture/            # Architecture documentation
  │   ├── README.md
  │   ├── mvsa-overview.md
  │   ├── folder-structure.md
  │   ├── dependency-injection.md
  │   ├── state-management.md
  │   ├── coding-standards.md
  │   └── diagrams/
  │
  └── task_guides/             # Task implementation guides
```

## File Naming Conventions

HR Connect follows these file naming conventions:

- All files use **snake_case** for names (e.g., `user_repository.dart`)
- Feature-specific files include the feature name as a prefix (e.g., `auth_service.dart`)
- Interface files are named as nouns (e.g., `repository.dart`)
- Implementation files include a suffix like `_impl` (e.g., `repository_impl.dart`)
- Test files include `_test` suffix (e.g., `user_repository_test.dart`)

## Directory Structure Benefits

This directory structure provides several benefits:

1. **Clear Organization**: The separation between core and features makes it easy to locate code
2. **Feature Isolation**: Each feature has its own directory structure, enabling independent development
3. **Layer Separation**: The domain, data, and presentation layers are clearly separated within each feature
4. **Testability**: The structure facilitates unit testing of individual components
5. **Scalability**: New features can be added by creating additional feature directories

## Recommended Practices

When working with this folder structure:

1. **Respect Module Boundaries**: Avoid direct imports between features; use core components or domain events instead
2. **Keep Core Minimal**: Add to core only when functionality is needed by multiple features
3. **Clean Architecture**: Maintain the separation between domain, data, and presentation layers
4. **Dependency Direction**: Ensure dependencies only point inward (toward domain) within each feature
5. **Feature Completeness**: Each feature directory should contain all the code needed for that business capability 