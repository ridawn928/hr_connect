# Dependency Injection

This document explains the dependency injection (DI) approach used in HR Connect, which is implemented using the `get_it` and `injectable` packages.

## Overview

Dependency injection is a design pattern that decouples the construction of dependencies from their usage. HR Connect uses dependency injection to:

- Improve testability by allowing dependencies to be mocked
- Facilitate the separation of concerns
- Enable the appropriate scoping of dependencies
- Support multiple environments (development, testing, production)

## DI Implementation

HR Connect uses a combination of two packages for dependency injection:

1. **get_it**: A simple service locator for managing singletons and factories
2. **injectable**: Code generation library that simplifies working with get_it

These packages work together to provide a robust DI solution with minimal boilerplate code.

## Core Structure

The dependency injection system is structured as follows:

```
lib/core/di/
  ├── injection.dart              # Public API for DI system
  ├── injection_config.dart       # Main configuration file
  ├── injection_config.config.dart # Generated file
  ├── service_locator.dart        # GetIt instance and setup
  ├── service_locator_extensions.dart # Extension methods
  ├── environment_config.dart     # Environment-specific configuration
  ├── core_module.dart            # Core dependencies registration
  ├── service_locator_test_helper.dart # Test utilities
  └── modules/                    # Feature-specific DI modules
      ├── auth_module.dart
      ├── network_module.dart
      └── storage_module.dart
```

## Service Locator

The `service_locator.dart` file defines the global GetIt instance and setup function:

```dart
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/environment_config.dart' as app_env;
import 'package:hr_connect/core/di/injection_config.dart';

/// Global instance of GetIt to be used throughout the application.
final GetIt getIt = GetIt.instance;

/// Initializes the service locator with all required dependencies.
Future<void> setupServiceLocator({
  required app_env.EnvironmentConfig config,
}) async {
  // Register the environment configuration itself first
  getIt.registerSingleton<app_env.EnvironmentConfig>(config);

  // Determine injectable environment based on config
  final injectableEnv = _environmentToString(config.environment);

  // Initialize auto-generated dependencies with environment
  await configureDependencies(
    getIt,
    environment: injectableEnv,
  );
  
  // Register any additional services not covered by auto-registration
  await _registerAdditionalServices();
}
```

## Injectable Configuration

The `injection_config.dart` file defines the configuration function:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_config.config.dart';

/// Environment constants used for conditional registration
abstract class Env {
  static const dev = 'dev';
  static const test = 'test';
  static const staging = 'staging';
  static const prod = 'prod';
}

/// Initializes dependencies using injectable's generated code
///
/// This function is called by setupServiceLocator in service_locator.dart
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies(
  GetIt getIt, {
  String? environment,
}) async =>
    await init(getIt, environment: environment);
```

## Registration Types

HR Connect uses several registration types for different scenarios:

### 1. Singleton

Used for services that should have a single instance throughout the application:

```dart
@singleton
class AuthenticationService {
  // ...
}
```

### 2. LazySingleton

Similar to singleton, but instances are created only when accessed for the first time:

```dart
@LazySingleton()
class QrCodeGenerator {
  // ...
}
```

### 3. Factory

Creates a new instance each time the dependency is requested:

```dart
@injectable
class UserRepository {
  // ...
}
```

### 4. Environment-specific Registration

Registers different implementations based on the current environment:

```dart
@Environment(Env.dev)
@LazySingleton(as: ApiClient)
class MockApiClient implements ApiClient {
  // Mock implementation for development
}

@Environment(Env.prod)
@LazySingleton(as: ApiClient)
class ProductionApiClient implements ApiClient {
  // Production implementation
}
```

## Feature Modules

Each feature can define its own module for registering dependencies:

```dart
@module
abstract class AuthModule {
  @lazySingleton
  AuthRepository provideAuthRepository(
    AuthLocalDataSource localDataSource,
    AuthRemoteDataSource remoteDataSource,
    NetworkInfo networkInfo,
  ) =>
      AuthRepositoryImpl(
        localDataSource,
        remoteDataSource,
        networkInfo,
      );
}
```

## Accessing Dependencies

To access a registered dependency, use the `getIt` instance:

```dart
final authService = getIt<AuthenticationService>();
```

In widgets, it's recommended to get dependencies during initialization rather than directly in the build method:

```dart
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthenticationService _authService;
  
  @override
  void initState() {
    super.initState();
    _authService = getIt<AuthenticationService>();
  }
  
  // ...
}
```

## Testing with DI

For testing, HR Connect provides a test helper that simplifies mocking dependencies:

```dart
import 'package:hr_connect/core/di/service_locator_test_helper.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthenticationService {}

void main() {
  late MockAuthService mockAuthService;
  
  setUp(() {
    mockAuthService = MockAuthService();
    setupTestServiceLocator((getIt) {
      getIt.registerSingleton<AuthenticationService>(mockAuthService);
    });
  });
  
  tearDown(() {
    resetServiceLocator();
  });
  
  // Tests...
}
```

## Environment Configuration

The `environment_config.dart` file defines environment-specific configurations:

```dart
enum Environment {
  development,
  test,
  staging,
  production,
}

class EnvironmentConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final int cacheLifetimeMinutes;
  
  const EnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.cacheLifetimeMinutes,
  });
  
  static EnvironmentConfig development() => EnvironmentConfig(
    environment: Environment.development,
    apiBaseUrl: 'https://dev-api.hrconnect.com',
    enableLogging: true,
    cacheLifetimeMinutes: 5,
  );
  
  static EnvironmentConfig production() => EnvironmentConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.hrconnect.com',
    enableLogging: false,
    cacheLifetimeMinutes: 60,
  );
  
  // Other environment configurations...
}
```

## Best Practices

When using dependency injection in HR Connect, follow these best practices:

1. **Register by Interface**: Register implementations against their interfaces to maintain abstraction
2. **Constructor Injection**: Prefer constructor injection for required dependencies
3. **Scoped Access**: Access dependencies as close to where they're used as possible
4. **Minimal Dependencies**: Keep the number of dependencies for each class minimal
5. **Environment-specific Behavior**: Use environment-specific registrations for different implementations in different environments
6. **Cleanup in Tests**: Always reset the service locator after tests to avoid cross-test pollution

## Example: Repository Pattern with DI

```dart
// Domain Layer: Interface
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
}

// Data Layer: Implementation
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    // Implementation...
  }
}

// Presentation Layer: Usage
class UserProfileScreen extends StatelessWidget {
  final String userId;
  
  UserProfileScreen({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    final userRepository = getIt<UserRepository>();
    
    // Use the repository...
  }
}
```

## Initialization in main.dart

The dependency injection system is initialized in `main.dart` before the app starts:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Determine current environment (could be based on build flags or env variables)
  final environment = Environment.development; // or production
  
  // Get appropriate config
  final config = environment == Environment.development
      ? EnvironmentConfig.development()
      : EnvironmentConfig.production();
  
  // Initialize the service locator
  await setupServiceLocator(config: config);
  
  // Run the app
  runApp(MyApp());
} 