# Implementation Guide: Integrating Injectable with Get_it

## Task ID: 01-003-03 - Integrate injectable and set up the initial injection configuration file with @InjectableInit

### 1. Introduction

This guide provides step-by-step instructions for integrating the injectable package with the previously implemented get_it service locator in the HR Connect application. This integration enables annotation-based dependency injection, reducing boilerplate code and improving maintainability.

#### 1.1 Purpose

Injectable extends get_it to provide code generation capabilities through annotations, offering several advantages:

- Reduces boilerplate code for dependency registration
- Makes dependency management more maintainable through annotations
- Decreases the chance of registration errors
- Facilitates modular dependency registration aligned with our MVSA architecture
- Supports environment-specific configurations (dev, test, prod)

#### 1.2 Relationship to Previous Task

This task builds directly on task 01-003-02 (Implement the service locator using get_it). While the previous task established the core service locator infrastructure, this task enhances it with code generation capabilities for easier dependency management.

### 2. Prerequisites

Before starting this task, ensure:

- Task 01-003-02 (Implement the service locator using get_it) is completed
- The injectable package (^2.1.2) is correctly added to dependencies in pubspec.yaml
- The injectable_generator package (^2.1.6) is added to dev_dependencies in pubspec.yaml
- build_runner (^2.4.8) is added to dev_dependencies for code generation
- You have a basic understanding of code generation concepts in Dart/Flutter

### 3. Implementation Steps

#### 3.1 Configure build.yaml

First, create or update the build.yaml file at the project root to configure how the injectable_generator works:

```yaml
# File: build.yaml

targets:
  $default:
    builders:
      injectable_generator:injectable_builder:
        options:
          # Enable auto register by default
          auto_register: true
          # Class name prefixes to auto-register
          class_name_pattern: 
            "Service$|Repository$|Datasource$|UseCase$"
          # File name suffixes to auto-register
          file_name_pattern: 
            "_service|_repository|_datasource|_use_case"
          # Generate for only specific directories
          include_paths: 
            - "lib/core/**.dart"
            - "lib/features/**.dart"
```

#### 3.2 Create the Injectable Configuration File

Create the injection_config.dart file in the core/di directory:

```dart
// File: lib/core/di/injection_config.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This will be generated after running build_runner
import 'injection_config.config.dart';

/// Configures the dependency injection using [Injectable].
///
/// The [environment] parameter can be used to conditionally register
/// dependencies based on the current environment (e.g., dev, test, prod).
///
/// [environmentFilter] controls which environments are considered active,
/// defaulting to only the specified environment.
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
  generateForDir: ['lib'], // specify the target directory
)
Future<void> configureDependencies(
  GetIt getIt, {
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
  // This will call the generated function to register all annotated dependencies
  await getIt.init(
    environment: environment,
    environmentFilter: environmentFilter,
  );
}

/// Environment constants for conditional dependency registration.
abstract class Env {
  /// Development environment.
  static const dev = 'dev';
  
  /// Test environment.
  static const test = 'test';
  
  /// Staging environment.
  static const staging = 'staging';
  
  /// Production environment.
  static const prod = 'prod';
}
```

#### 3.3 Update Service Locator to Use Injectable

Update the service_locator.dart file to use the injectable configuration:

```dart
// File: lib/core/di/service_locator.dart (updated)

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/di/service_locator_extensions.dart';

/// Global instance of GetIt to be used throughout the application.
final GetIt getIt = GetIt.instance;

/// Initializes the service locator with all required dependencies.
///
/// [config] specifies the environment configuration to use.
/// This should be called during app initialization before any services
/// are accessed.
Future<void> setupServiceLocator({
  required EnvironmentConfig config,
}) async {
  // Register the environment configuration itself first
  getIt.registerSingleton<EnvironmentConfig>(config);
  
  // Determine injectable environment based on config
  final String injectableEnv = _environmentToString(config.environment);
  
  // Use injectable to configure all annotated dependencies
  await configureDependencies(
    getIt,
    environment: injectableEnv,
    environmentFilter: EnvironmentFilter.ofEnvironment(injectableEnv),
  );
  
  // Register any dependencies that aren't handled by injectable
  _registerAdditionalServices(config);
}

/// Converts Environment enum to injectable environment string.
String _environmentToString(Environment environment) {
  switch (environment) {
    case Environment.development:
      return Env.dev;
    case Environment.test:
      return Env.test;
    case Environment.staging:
      return Env.staging;
    case Environment.production:
      return Env.prod;
  }
}

/// Registers additional services that aren't handled by injectable.
/// 
/// This is for services that require manual initialization or can't be
/// registered through annotations for any reason.
void _registerAdditionalServices(EnvironmentConfig config) {
  // Additional service registrations will be added as needed
}
```

#### 3.4 Create a Test Service with Injectable Annotations

Create a simple test service to verify the injectable setup:

```dart
// File: lib/core/services/logger_service.dart

import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';

/// Service for logging information within the application.
///
/// This is a simple service to test the injectable integration.
@injectable
class LoggerService {
  /// Creates a new logger service.
  LoggerService();
  
  /// Logs information to the console.
  void info(String message) {
    // In a real implementation, this would use proper logging system
    print('INFO: $message');
  }
  
  /// Logs errors to the console.
  void error(String message, [Object? error]) {
    // In a real implementation, this would use proper logging system
    print('ERROR: $message ${error != null ? '- $error' : ''}');
  }
}

/// A development-specific logger that adds debug information.
@Environment(Env.dev)
@LazySingleton(as: LoggerService)
class DevLoggerService implements LoggerService {
  /// Creates a new development logger service.
  DevLoggerService();
  
  @override
  void info(String message) {
    print('DEV INFO [${DateTime.now()}]: $message');
  }
  
  @override
  void error(String message, [Object? error]) {
    print('DEV ERROR [${DateTime.now()}]: $message ${error != null ? '- $error' : ''}');
  }
}

/// A production-specific logger that limits information.
@Environment(Env.prod)
@LazySingleton(as: LoggerService)
class ProdLoggerService implements LoggerService {
  /// Creates a new production logger service.
  ProdLoggerService();
  
  @override
  void info(String message) {
    // In production, might skip certain log levels or send to a service
    // This is a simplified example
    print('PROD: $message');
  }
  
  @override
  void error(String message, [Object? error]) {
    // In production, might send errors to a monitoring service
    // This is a simplified example
    print('PROD ERROR: $message ${error != null ? '- $error' : ''}');
  }
}
```

#### 3.5 Create a Test Module for Injectable

Create a core module that provides dependencies that can't be constructed directly:

```dart
// File: lib/core/di/core_module.dart

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// A module for registering core dependencies that can't be constructed with
/// a simple constructor or that require async initialization.
@module
abstract class CoreModule {
  /// Provides a singleton instance of SharedPreferences.
  ///
  /// This is a preemptive registration for a service we'll use later.
  /// Since SharedPreferences.getInstance() is async, we use @preResolve.
  @preResolve
  Future<SharedPreferences> get sharedPreferences => 
      SharedPreferences.getInstance();
      
  /// Provides an HTTP client for the application.
  ///
  /// This demonstrates how to register a third-party class that doesn't
  /// have an injectable annotation.
  @lazySingleton
  http.Client get httpClient => http.Client();
}
```

### 4. Running Code Generation

Now that you've set up all the necessary files, you need to run build_runner to generate the injection code:

```bash
# Run this command in your project root directory
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the `injection_config.config.dart` file in the same directory as `injection_config.dart`. The generated file will contain all the code needed to register your annotated dependencies.

After running the command, verify that the `injection_config.config.dart` file was generated correctly. It should contain registration code for the `LoggerService` and any other annotated services.

### 5. Testing the Injectable Setup

Create a test file to verify that the injectable setup works correctly:

```dart
// File: test/core/di/injectable_setup_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/di/service_locator_test_helper.dart';
import 'package:hr_connect/core/services/logger_service.dart';

void main() {
  setUp(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  tearDown(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  group('Injectable setup', () {
    test('should register the correct LoggerService implementation for dev', () async {
      // Arrange
      final config = EnvironmentConfig.development();
      
      // Act
      await setupServiceLocator(config: config);
      
      // Assert
      expect(getIt.isRegistered<LoggerService>(), true);
      expect(getIt<LoggerService>(), isA<DevLoggerService>());
    });

    test('should register the correct LoggerService implementation for prod', () async {
      // Arrange
      final config = EnvironmentConfig.production();
      
      // Act
      await setupServiceLocator(config: config);
      
      // Assert
      expect(getIt.isRegistered<LoggerService>(), true);
      expect(getIt<LoggerService>(), isA<ProdLoggerService>());
    });
  });
}
```

### 6. Updating Main.dart to Use Injectable

Update the `main.dart` file to use the new service locator setup:

```dart
// File: lib/main.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up the environment configuration
  final config = EnvironmentConfig.development();
  
  // Setup service locator with the environment
  await setupServiceLocator(config: config);
  
  // Test that injectable worked by using the logger
  final logger = getIt<LoggerService>();
  logger.info('Starting HR Connect application');
  
  runApp(const MyApp());
}
```

### 7. Best Practices for Using Injectable

#### 7.1 Annotation Usage Guidelines

- **@injectable**: Use for regular classes that can be constructed with a simple constructor.
```dart
@injectable
class MyService {}
```

- **@lazySingleton**: For services that should be instantiated only once but lazily on first use.
```dart
@lazySingleton
class ExpensiveService {}
```

- **@singleton**: For services that should be instantiated immediately on registration.
```dart
@singleton
class CoreService {}
```

- **@factoryMethod**: For classes that require custom creation logic.
```dart
@injectable
class ComplexService {
  @factoryMethod
  static ComplexService create(DependencyA a, DependencyB b) {
    return ComplexService._internal(a, b);
  }
  
  ComplexService._internal(this._a, this._b);
  
  final DependencyA _a;
  final DependencyB _b;
}
```

- **@Environment**: For environment-specific implementations.
```dart
@Environment(Env.dev)
@injectable
class DevService implements BaseService {}
```

#### 7.2 Module Organization

1. **Organize by Feature**: Create modules for each feature slice in the MVSA architecture.

```dart
// Example structure for a feature module
// File: lib/features/authentication/di/auth_module.dart

@module
abstract class AuthModule {
  // Feature-specific dependencies
}
```

2. **Use Named Registration** for multiple implementations of the same interface:

```dart
@Named("cached")
@injectable
class CachedRepository implements Repository {}

@Named("remote")
@injectable
class RemoteRepository implements Repository {}

// Usage
@injectable
class SomeService {
  SomeService(@Named("cached") this.repository);
  final Repository repository;
}
```

3. **Lazy Loading Features**: Use GetIt's scope feature for feature modules that should be lazily loaded:

```dart
// To be implemented in future tasks when feature modules are added
```

### 8. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-003-04**: Set up build.yaml and run build_runner to generate DI code.

While you've already configured build.yaml and run build_runner as part of this task, the next task will involve setting up more comprehensive build configuration and potentially adding more injectable modules.

### 9. Conclusion

You have now integrated the injectable package with the get_it service locator in the HR Connect application. This integration provides:

- Annotation-based dependency registration to reduce boilerplate
- Environment-specific dependency implementations
- Code generation for error-free dependency registration
- Support for complex dependency registration scenarios
- A foundation for modular, feature-based DI aligned with MVSA

This implementation lays the groundwork for a maintainable dependency injection system that will scale with the application as more features are added.

Remember to follow the HR Connect Flutter Development Guidelines when implementing additional services and features, particularly regarding proper typing, documentation, and architecture principles.
