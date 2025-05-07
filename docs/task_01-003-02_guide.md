# Implementation Guide: Service Locator using get_it

## Task ID: 01-003-02 - Implement the service locator using get_it

### 1. Introduction

This guide provides step-by-step instructions for implementing the service locator pattern using the get_it package in the HR Connect application. This implementation follows the Modified Vertical Slice Architecture (MVSA) and prepares the foundation for dependency injection throughout the application.

#### 1.1 Purpose

The service locator pattern helps manage dependencies between components, making the codebase more maintainable, testable, and flexible. In HR Connect's context, the service locator will:

- Provide a single point of access for application services
- Facilitate the implementation of the Repository pattern
- Enable easier testing through dependency substitution
- Support the offline-first approach by managing data sources

#### 1.2 Role in MVSA Architecture

In our Modified Vertical Slice Architecture, get_it serves as the central hub for dependency management across vertical feature slices. It will register both core infrastructure services and feature-specific dependencies.

### 2. Prerequisites

Before starting this task, ensure:

- Task 01-003-01 (Create a core/di/ directory for dependency injection configuration) is completed
- The get_it package (^7.6.0) is correctly added in pubspec.yaml
- You have a basic understanding of dependency injection concepts
- You are familiar with the HR Connect application architecture

### 3. Implementation Steps

#### 3.1 Create the Service Locator File

First, create the main service locator file in the DI directory:

```dart
// File: lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';

/// Global instance of GetIt to be used throughout the application.
/// 
/// This provides a centralized registry for all dependencies following
/// the service locator pattern. All features should register and obtain
/// their dependencies through this instance.
final GetIt getIt = GetIt.instance;

/// Initializes the service locator with all required dependencies.
/// 
/// This should be called during app initialization before any services
/// are accessed. The function will register all core services and
/// prepare the application for feature-specific registrations.
/// 
/// Call this method in main.dart before running the app.
Future<void> setupServiceLocator() async {
  // Register core services
  _registerCoreServices();
  
  // Register feature services - to be expanded as features are implemented
  _registerFeatureServices();
}

/// Registers all core infrastructure services.
void _registerCoreServices() {
  // Network services will be added as part of other tasks
  
  // Storage services will be added as part of other tasks
  
  // Security services will be added as part of other tasks
}

/// Registers feature-specific services.
void _registerFeatureServices() {
  // Feature services will be added as their respective features are implemented
}
```

#### 3.2 Create Extension Methods for Cleaner Registration

Add extension methods to improve readability and consistency:

```dart
// File: lib/core/di/service_locator_extensions.dart

import 'package:get_it/get_it.dart';

/// Extension methods for GetIt to provide more readable registration syntax.
extension GetItExtensions on GetIt {
  /// Registers a singleton instance that is created on first access.
  /// 
  /// Use this for services that are expensive to create but aren't
  /// needed right at startup. The instance will be created once and
  /// reused for all subsequent requests.
  void registerLazySingletonService<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  /// Registers a factory function that creates a new instance each time.
  /// 
  /// Use this for services where a new instance is needed on each request,
  /// such as use cases or transient operations.
  void registerFactoryService<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    registerFactory<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  /// Registers an already-created singleton instance.
  /// 
  /// Use this for services that are already instantiated or when
  /// manual control over the instance creation is required.
  void registerSingletonService<T extends Object>(
    T instance, {
    String? instanceName,
    bool? dispose,
  }) {
    registerSingleton<T>(
      instance,
      instanceName: instanceName,
      dispose: dispose,
    );
  }
}
```

#### 3.3 Create Service Locator Test Helper

To facilitate testing with the service locator, create a test helper:

```dart
// File: lib/core/di/service_locator_test_helper.dart

import 'package:get_it/get_it.dart';

/// Helper class for resetting the service locator during tests.
/// 
/// This provides utilities to reset GetIt between tests and register
/// mock implementations for services.
class ServiceLocatorTestHelper {
  /// Resets the entire GetIt instance.
  /// 
  /// Call this in the setUp or tearDown of your tests to ensure
  /// a clean state between test runs.
  static Future<void> resetServiceLocator() async {
    final GetIt getIt = GetIt.instance;
    await getIt.reset();
  }

  /// Registers a mock implementation for a service.
  /// 
  /// Example:
  /// ```dart
  /// final mockAuthService = MockAuthService();
  /// ServiceLocatorTestHelper.registerMockService<AuthService>(mockAuthService);
  /// ```
  static void registerMockService<T extends Object>(T mockImplementation) {
    final GetIt getIt = GetIt.instance;
    
    // Check if already registered and unregister if needed
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    
    getIt.registerSingleton<T>(mockImplementation);
  }
}
```

#### 3.4 Set Up Environment Configuration for Different Contexts

Create an environment configuration for different contexts (dev, test, prod):

```dart
// File: lib/core/di/environment_config.dart

/// Defines the environment in which the application is running.
enum Environment {
  /// Development environment for local testing.
  development,
  
  /// Testing environment for automated tests.
  test,
  
  /// Staging environment for pre-production testing.
  staging,
  
  /// Production environment for released app.
  production,
}

/// Configuration class for environment-specific settings.
/// 
/// This class is used to configure services based on the current
/// environment (development, test, staging, production).
class EnvironmentConfig {
  /// The current environment.
  final Environment environment;

  /// Whether to enable detailed logging.
  final bool enableVerboseLogging;

  /// Base URL for API endpoints.
  final String apiBaseUrl;

  /// Whether to use mock services instead of real implementations.
  final bool useMockServices;

  /// Creates a new environment configuration.
  const EnvironmentConfig({
    required this.environment,
    required this.enableVerboseLogging,
    required this.apiBaseUrl,
    required this.useMockServices,
  });

  /// Creates a development environment configuration.
  factory EnvironmentConfig.development() {
    return const EnvironmentConfig(
      environment: Environment.development,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://dev-api.hrconnect.example.com',
      useMockServices: false,
    );
  }

  /// Creates a test environment configuration.
  factory EnvironmentConfig.test() {
    return const EnvironmentConfig(
      environment: Environment.test,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://test-api.hrconnect.example.com',
      useMockServices: true,
    );
  }

  /// Creates a staging environment configuration.
  factory EnvironmentConfig.staging() {
    return const EnvironmentConfig(
      environment: Environment.staging,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://staging-api.hrconnect.example.com',
      useMockServices: false,
    );
  }

  /// Creates a production environment configuration.
  factory EnvironmentConfig.production() {
    return const EnvironmentConfig(
      environment: Environment.production,
      enableVerboseLogging: false,
      apiBaseUrl: 'https://api.hrconnect.example.com',
      useMockServices: false,
    );
  }
}
```

#### 3.5 Update the Service Locator to Support Environments

Modify the service_locator.dart file to support environment configuration:

```dart
// File: lib/core/di/service_locator.dart (updated)

import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/environment_config.dart';
// Additional imports will be added in other tasks

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
  
  // Register core services
  _registerCoreServices(config);
  
  // Register feature services
  _registerFeatureServices(config);
}

/// Registers all core infrastructure services.
void _registerCoreServices(EnvironmentConfig config) {
  // Core registrations will be added in future tasks
}

/// Registers feature-specific services.
void _registerFeatureServices(EnvironmentConfig config) {
  // Feature-specific registrations will be added as features are implemented
}
```

### 4. Testing the Implementation

Create a basic test to verify the service locator works correctly:

```dart
// File: test/core/di/service_locator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/di/service_locator_test_helper.dart';

void main() {
  setUp(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  tearDown(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  test('setupServiceLocator should register environment config', () async {
    // Arrange
    final config = EnvironmentConfig.test();
    
    // Act
    await setupServiceLocator(config: config);
    
    // Assert
    expect(getIt.isRegistered<EnvironmentConfig>(), true);
    expect(getIt<EnvironmentConfig>(), config);
  });
}
```

### 5. Integration in Main.dart

Add the service locator initialization to the main.dart file:

```dart
// File: lib/main.dart (add the following)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup service locator with appropriate environment
  // For development, use development environment
  await setupServiceLocator(
    config: EnvironmentConfig.development(),
  );
  
  runApp(const MyApp());
}
```

### 6. Using the Service Locator

Example of how to use the service locator in a feature component:

```dart
// Sample usage in a repository implementation (for illustration)

import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/features/authentication/domain/repositories/auth_repository.dart';

class SomeFeatureService {
  final AuthRepository _authRepository;
  
  // Constructor injection (preferred for testability)
  SomeFeatureService({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;
  
  // Alternative: Service locator direct usage
  factory SomeFeatureService.fromServiceLocator() {
    return SomeFeatureService(
      authRepository: getIt<AuthRepository>(),
    );
  }
  
  // Methods...
}
```

### 7. Best Practices for Using get_it

1. **Prefer Constructor Injection**: Whenever possible, use constructor injection instead of directly accessing the service locator in your classes.

2. **Register by Interface**: Register services by their interface type rather than concrete implementation.

3. **Isolate Registration Code**: Keep all registration code in dedicated modules per feature.

4. **Late Initialization**: Use lazy singletons for services that aren't needed at startup.

5. **Register in the Right Scope**: Core services in core registration, feature services in feature registration.

6. **Reset in Tests**: Always reset the service locator in setUp/tearDown to ensure clean test state.

### 8. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-003-03**: Integrate injectable and set up the initial injection configuration file with @InjectableInit.

The injectable package will build on top of the get_it infrastructure you've created here to provide annotation-based dependency injection.

### 9. Conclusion

You have now implemented the service locator pattern using get_it in the HR Connect application. This lays the foundation for dependency injection throughout the application and supports the Modified Vertical Slice Architecture (MVSA) approach.

The service locator provides:
- A centralized registry for all dependencies
- Support for different environments (development, test, staging, production)
- Extension methods for cleaner registration syntax
- Testing utilities for proper test isolation

Remember to follow the HR Connect Flutter Development Guidelines, particularly regarding proper typing, documentation, and architecture principles as you continue to build on this foundation.
