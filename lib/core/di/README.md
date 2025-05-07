# Dependency Injection Module

This directory contains the dependency injection configuration for the HR Connect application using get_it and injectable.

## Purpose

The dependency injection module:
- Provides a service locator pattern for resolving dependencies
- Generates boilerplate code for dependency registration
- Facilitates loose coupling between components
- Enables easier testing through dependency substitution

## Structure

- `injection.dart`: Injectable configuration entry point
- `injection.config.dart`: Generated configuration (don't edit manually)
- `service_locator.dart`: Service locator implementation using get_it
- `service_locator_extensions.dart`: Extension methods for cleaner registration
- `service_locator_test_helper.dart`: Utilities for testing with the service locator
- `environment_config.dart`: Environment-specific configuration
- `modules/`: Feature-specific dependency registration modules

## Usage

### Registering a Dependency

To register a dependency, you have two options:

#### 1. Using Injectable (preferred)

Add the `@injectable` annotation to the class:

```dart
import 'package:injectable/injectable.dart';

@injectable
class MyService {
  // Implementation
}
```

For different registration types:

```dart
@singleton  // Single instance for the app lifetime
class DatabaseService {
  // Implementation
}

@lazySingleton  // Created only when first requested
class AuthService {
  // Implementation
}

@factoryMethod  // New instance each time
class ConfigService {
  // Implementation
}
```

#### 2. Using Service Locator Extensions

For manual registration, use the extension methods:

```dart
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/di/service_locator_extensions.dart';

// In your registration code
getIt.registerLazySingletonService<AuthRepository>(() => AuthRepositoryImpl());
getIt.registerFactoryService<GetUserUseCase>(() => GetUserUseCase(getIt<AuthRepository>()));
getIt.registerSingletonService<LoggingService>(LoggingService());
```

### Using a Dependency

To use a registered dependency:

```dart
import 'package:hr_connect/core/di/service_locator.dart';

// In your code
final myService = getIt<MyService>();
```

### Environment Configuration

The service locator supports different environments (development, test, staging, production)
through the `EnvironmentConfig` class:

```dart
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';

// In main.dart
await setupServiceLocator(
  config: EnvironmentConfig.development(),
);
```

### Testing with the Service Locator

Use the test helper to reset the service locator and register mock implementations:

```dart
import 'package:hr_connect/core/di/service_locator_test_helper.dart';

void main() {
  setUp(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
    
    // Register mocks
    final mockRepository = MockAuthRepository();
    ServiceLocatorTestHelper.registerMockService<AuthRepository>(mockRepository);
  });

  // Tests...
}
```

## Notes

- Run `flutter pub run build_runner build` after adding or modifying injectable annotations
- Always register implementations against their interfaces for proper abstraction
- Use environment annotations for environment-specific dependencies 