# Implementation Guide: Creating and Testing a Simple Service to Verify DI System

## Task ID: 01-003-05 - Create and test a simple service to verify the DI system works

### 1. Introduction

This guide provides step-by-step instructions for creating and testing a simple service to verify that the dependency injection system is properly set up in the HR Connect application. This task helps confirm that the previous dependency injection setup (tasks 01-003-01 through 01-003-04) is functioning correctly.

#### 1.1 Purpose

Creating a simple test service allows us to:

- Verify that the service registration works correctly with get_it and injectable
- Confirm that different registration types (singleton, lazySingleton, factory) function as expected
- Test environment-specific implementations
- Establish a pattern for future service implementation
- Ensure that the generated code correctly registers all services

By completing this task, you'll have confidence that the dependency injection framework is properly configured before moving on to implementing more complex features.

#### 1.2 Relationship to Previous Tasks

This task builds on the following previous tasks:
- Task 01-003-01: Create a core/di/ directory for dependency injection configuration
- Task 01-003-02: Implement the service locator using get_it
- Task 01-003-03: Integrate injectable and set up the initial injection configuration file with @InjectableInit
- Task 01-003-04: Set up build.yaml and run build_runner to generate DI code

While the previous tasks set up the infrastructure for dependency injection, this task creates an actual service to verify that the system works as expected.

### 2. Prerequisites

Before starting this task, ensure:

- Tasks 01-003-01 through 01-003-04 are completed
- The build.yaml file is configured correctly
- Code generation with build_runner has been run successfully
- The generated injection_config.config.dart file exists
- You're familiar with the HR Connect architecture and coding standards

### 3. Designing the Test Service

#### 3.1 Selecting an Appropriate Service

For this task, we'll implement a `LoggingService` that provides logging functionality for the application. A logging service is ideal for testing the DI system because:

- It's a simple service with clear functionality
- It would be used throughout the application
- It can have different implementations for different environments
- It's easy to test
- It demonstrates the singleton pattern typical for services

#### 3.2 Service Design Overview

We'll implement the following components:

1. **LoggingService Interface**: An abstract class defining the logging methods
2. **DefaultLoggerService**: A standard implementation for general use
3. **Environment-specific implementations**:
   - DevLoggerService: More verbose logging for development
   - ProdLoggerService: More restrictive logging for production
4. **ConfigService**: A dependency to demonstrate constructor injection
5. **Unit Tests**: To verify both service functionality and DI registration

### 4. Implementation Steps

#### 4.1 Create the LoggingService Interface

First, let's create the abstract interface for our logging service:

```dart
// File: lib/core/services/logging/logging_service.dart

import 'package:injectable/injectable.dart';

/// Severity levels for log messages.
enum LogLevel {
  /// Debug-level message (lowest severity)
  debug,
  
  /// Informational message
  info,
  
  /// Warning message
  warning,
  
  /// Error message
  error,
  
  /// Critical error message (highest severity)
  critical,
}

/// Abstract interface for logging services in the application.
///
/// This service provides unified logging capabilities across the app,
/// with support for different log levels and formatting options.
abstract class LoggingService {
  /// Logs a message with the specified level.
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a debug message.
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs an informational message.
  void info(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a warning message.
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs an error message.
  void error(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a critical error message.
  void critical(String message, [Object? error, StackTrace? stackTrace]);
}
```

#### 4.2 Create a Configuration Service

To demonstrate dependency injection, let's create a simple configuration service that the logger will depend on:

```dart
// File: lib/core/services/config/config_service.dart

import 'package:injectable/injectable.dart';

/// Configuration service for the application.
///
/// Provides access to application-wide configuration settings.
@singleton
class ConfigService {
  /// Whether verbose logging is enabled.
  final bool enableVerboseLogging;
  
  /// Whether to log to a remote server.
  final bool enableRemoteLogging;
  
  /// Remote logging endpoint URL (if remote logging is enabled).
  final String remoteLoggingUrl;
  
  /// Creates a new configuration service.
  ///
  /// In a real application, these values would be loaded from
  /// environment variables, a config file, or secure storage.
  ConfigService({
    this.enableVerboseLogging = false,
    this.enableRemoteLogging = false,
    this.remoteLoggingUrl = 'https://logging.hrconnect.example.com',
  });
}

/// Development environment specific configuration.
@Environment('dev')
@Singleton(as: ConfigService)
class DevConfigService extends ConfigService {
  /// Creates a development configuration with verbose logging enabled.
  DevConfigService()
      : super(
          enableVerboseLogging: true,
          enableRemoteLogging: false,
        );
}

/// Production environment specific configuration.
@Environment('prod')
@Singleton(as: ConfigService)
class ProdConfigService extends ConfigService {
  /// Creates a production configuration with remote logging enabled.
  ProdConfigService()
      : super(
          enableVerboseLogging: false,
          enableRemoteLogging: true,
        );
}
```

#### 4.3 Create the Default Logger Implementation

Next, implement the default logging service:

```dart
// File: lib/core/services/logging/default_logger_service.dart

import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Default implementation of the [LoggingService] interface.
///
/// This implementation logs messages to the console with formatting
/// based on the log level. It can be configured to provide more or
/// less verbose output.
@Singleton(as: LoggingService)
class DefaultLoggerService implements LoggingService {
  /// Configuration for the logging service.
  final ConfigService _config;
  
  /// Creates a new default logger service.
  ///
  /// Requires a [ConfigService] to determine logging behavior.
  DefaultLoggerService(this._config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = _getLevelPrefix(level);
    
    // Basic console output - in a real app, this would be more sophisticated
    print('$timestamp $prefix: $message');
    
    if (error != null) {
      print('$timestamp $prefix ERROR: $error');
      
      if (stackTrace != null && _config.enableVerboseLogging) {
        print('$timestamp $prefix STACK TRACE: $stackTrace');
      }
    }
    
    // In a real app, we'd implement remote logging here if enabled
    if (_config.enableRemoteLogging) {
      _logToRemoteServer(level, message, error, stackTrace);
    }
  }
  
  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    // Skip debug logs unless verbose logging is enabled
    if (_config.enableVerboseLogging) {
      log(LogLevel.debug, message, error, stackTrace);
    }
  }
  
  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.info, message, error, stackTrace);
  }
  
  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.warning, message, error, stackTrace);
  }
  
  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.error, message, error, stackTrace);
  }
  
  @override
  void critical(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.critical, message, error, stackTrace);
  }
  
  /// Gets a prefix string for the given log level.
  String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }
  
  /// Simulates logging to a remote server.
  /// 
  /// In a real application, this would send the log data to a remote
  /// logging service.
  void _logToRemoteServer(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // This is just a placeholder - in a real app, implement actual remote logging
    if (_config.enableVerboseLogging) {
      print('REMOTE LOG: Would send to ${_config.remoteLoggingUrl}');
    }
  }
}
```

#### 4.4 Create Environment-Specific Logger Implementations

Create development and production specific logger implementations:

```dart
// File: lib/core/services/logging/dev_logger_service.dart

import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Development environment specific logger implementation.
///
/// This logger provides more detailed output including source file
/// information and line numbers for debugging purposes.
@Environment('dev')
@LazySingleton(as: LoggingService)
class DevLoggerService extends DefaultLoggerService {
  /// Creates a development environment logger.
  DevLoggerService(ConfigService config) : super(config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = _getLevelPrefix(level);
    
    // Add extra debugging info for development
    print('$timestamp $prefix [DEV]: $message');
    
    if (error != null) {
      print('$timestamp $prefix [DEV] ERROR: $error');
      
      // Always print stack trace in dev mode
      if (stackTrace != null) {
        print('$timestamp $prefix [DEV] STACK TRACE:');
        print(stackTrace);
      }
    }
  }
  
  @override
  String _getLevelPrefix(LogLevel level) {
    final basePrefix = super._getLevelPrefix(level);
    return '🔧 $basePrefix';
  }
}
```

```dart
// File: lib/core/services/logging/prod_logger_service.dart

import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Production environment specific logger implementation.
///
/// This logger is optimized for production use with minimal console output
/// and focuses on capturing critical errors for remote logging.
@Environment('prod')
@LazySingleton(as: LoggingService)
class ProdLoggerService extends DefaultLoggerService {
  /// Creates a production environment logger.
  ProdLoggerService(ConfigService config) : super(config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    // In production, only log warnings and above to console
    if (level.index >= LogLevel.warning.index) {
      final timestamp = DateTime.now().toIso8601String();
      final prefix = _getLevelPrefix(level);
      
      print('$timestamp $prefix [PROD]: $message');
      
      if (error != null) {
        print('$timestamp $prefix [PROD] ERROR: $error');
      }
    }
    
    // Always send to remote logging in production
    _logToRemoteServer(level, message, error, stackTrace);
  }
  
  @override
  String _getLevelPrefix(LogLevel level) {
    final basePrefix = super._getLevelPrefix(level);
    
    // Add emoji indicators based on severity
    switch (level) {
      case LogLevel.debug:
      case LogLevel.info:
        return basePrefix;
      case LogLevel.warning:
        return '⚠️ $basePrefix';
      case LogLevel.error:
      case LogLevel.critical:
        return '🔴 $basePrefix';
    }
  }
}
```

#### 4.5 Generate DI Code

Run build_runner to generate the DI code with your new services:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will update the generated `injection_config.config.dart` file to include registration for your new services.

### 5. Creating Unit Tests

Now let's create comprehensive tests to verify both the service functionality and the DI system:

```dart
// File: test/core/services/logging/logging_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/config/config_service.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/logging/dev_logger_service.dart';
import 'package:hr_connect/core/services/logging/prod_logger_service.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock for the ConfigService
class MockConfigService extends Mock implements ConfigService {}

void main() {
  late MockConfigService mockConfig;
  
  setUp(() {
    mockConfig = MockConfigService();
    // Configure the mock
    when(() => mockConfig.enableVerboseLogging).thenReturn(true);
    when(() => mockConfig.enableRemoteLogging).thenReturn(false);
    when(() => mockConfig.remoteLoggingUrl).thenReturn('https://test.example.com');
  });
  
  group('DefaultLoggerService', () {
    late DefaultLoggerService logger;
    
    setUp(() {
      logger = DefaultLoggerService(mockConfig);
    });
    
    test('should log messages at the appropriate level', () {
      // This is a basic test to ensure the logger functions without errors
      // In a real test, you'd use a more sophisticated approach to capture output
      
      // Should not throw
      logger.debug('This is a debug message');
      logger.info('This is an info message');
      logger.warning('This is a warning message');
      logger.error('This is an error message');
      logger.critical('This is a critical message');
    });
    
    test('should respect verbose logging configuration', () {
      // Reconfigure mock for this test
      when(() => mockConfig.enableVerboseLogging).thenReturn(false);
      
      // Debug logs should be skipped when verbose logging is disabled
      // In a real test, you'd verify this with output capture
      logger.debug('This should be skipped');
      logger.info('This should still be logged');
    });
  });
  
  group('DI Registration', () {
    tearDown(() async {
      // Reset GetIt after each test
      await GetIt.instance.reset();
    });
    
    test('should register LoggingService as DefaultLoggerService by default', () async {
      // Set up with default environment
      final config = EnvironmentConfig.development();
      await setupServiceLocator(config: config);
      
      // Verify registration
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<DevLoggerService>());
    });
    
    test('should register LoggingService as DevLoggerService in dev environment', () async {
      // Set up with dev environment
      final config = EnvironmentConfig.development();
      await setupServiceLocator(config: config);
      
      // Verify registration
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<DevLoggerService>());
      
      // Verify ConfigService is also registered correctly
      expect(getIt.isRegistered<ConfigService>(), true);
      expect(getIt<ConfigService>(), isA<DevConfigService>());
    });
    
    test('should register LoggingService as ProdLoggerService in prod environment', () async {
      // Set up with prod environment
      final config = EnvironmentConfig.production();
      await setupServiceLocator(config: config);
      
      // Verify registration
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<ProdLoggerService>());
      
      // Verify ConfigService is also registered correctly
      expect(getIt.isRegistered<ConfigService>(), true);
      expect(getIt<ConfigService>(), isA<ProdConfigService>());
    });
  });
}
```

### 6. Create a Simple UI Example

To demonstrate how to use the service in a UI component, let's create a simple test screen:

```dart
// File: lib/core/presentation/test/logging_test_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';

/// A test screen to demonstrate the logging service in action.
class LoggingTestScreen extends StatelessWidget {
  /// Creates a new logging test screen.
  const LoggingTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the logging service from the service locator
    final logger = getIt<LoggingService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging Service Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logging Service Type:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              logger.runtimeType.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => logger.debug('Debug message from UI'),
              child: const Text('Log Debug'),
            ),
            ElevatedButton(
              onPressed: () => logger.info('Info message from UI'),
              child: const Text('Log Info'),
            ),
            ElevatedButton(
              onPressed: () => logger.warning('Warning message from UI'),
              child: const Text('Log Warning'),
            ),
            ElevatedButton(
              onPressed: () => logger.error('Error message from UI'),
              child: const Text('Log Error'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  // Intentionally throw an error
                  throw Exception('Test exception');
                } catch (e, stackTrace) {
                  logger.critical(
                    'Critical error from UI',
                    e,
                    stackTrace,
                  );
                }
              },
              child: const Text('Log Critical with Exception'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7. Integration in Main.dart

Update the `main.dart` file to demonstrate using the logging service:

```dart
// File: lib/main.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/presentation/test/logging_test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup service locator with development environment
  final config = EnvironmentConfig.development();
  await setupServiceLocator(config: config);
  
  // Get the logger from DI and log app start
  final logger = getIt<LoggingService>();
  logger.info('Starting HR Connect application');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoggingTestScreen(), // Use our test screen for now
    );
  }
}
```

### 8. Verifying the Implementation

#### 8.1 Running Tests

Run the unit tests to verify the service and DI system:

```bash
flutter test test/core/services/logging/logging_service_test.dart
```

All tests should pass, confirming that the LoggingService is correctly implemented and registered with the DI system.

#### 8.2 Manual Testing

1. Run the application:
```bash
flutter run
```

2. The LoggingTestScreen should appear, showing the runtime type of the LoggingService.

3. Press the buttons to log messages at different levels and check the console output.

4. You should see properly formatted log messages with the appropriate prefixes based on the environment.

### 9. Common Issues and Solutions

#### 9.1 Service Not Registered

**Issue**: The LoggingService is not registered in the DI container.

**Solution**:
- Verify that build_runner has been run after creating the service
- Check that the @injectable, @singleton, or @lazySingleton annotation is present
- Ensure that the class pattern matches the auto_register patterns in build.yaml
- Verify that the file is in a directory included in generate_for_dirs in build.yaml

#### 9.2 Wrong Implementation Registered

**Issue**: The wrong implementation is being used for the environment.

**Solution**:
- Check that the @Environment annotation is correctly applied
- Verify that the environment string in @Environment matches the environment used in setupServiceLocator
- Make sure that the as: parameter is correctly specified in the annotation

#### 9.3 Dependency Injection Failing

**Issue**: The service is failing to inject dependencies.

**Solution**:
- Ensure all dependencies are properly registered with the DI container
- Check constructor parameter types match exactly with registered types
- Use getIt.get<T>() with explicit type for debugging

### 10. Best Practices

#### 10.1 Service Design Guidelines

1. **Interface Segregation**: Define interfaces with focused methods
2. **Dependency Injection**: Always use constructor injection for dependencies
3. **Environment-Specific Implementations**: Use the @Environment annotation for different environments
4. **Documentation**: Document all public APIs clearly
5. **Error Handling**: Handle errors appropriately within the service

#### 10.2 Testing Guidelines

1. **Isolate Tests**: Use GetIt.reset() between tests to avoid test pollution
2. **Mock Dependencies**: Use Mocktail or Mockito for mocking dependencies
3. **Test All Environments**: Verify that environment-specific implementations work correctly
4. **Test Edge Cases**: Include tests for error conditions and edge cases

### 11. Next Steps

After completing this task, you'll be ready to move on to the next tasks in the architecture setup:

- Implementing the routing system
- Setting up the main.dart file with proper initialization
- Adding more core services following the pattern established in this task

### 12. Conclusion

You have now created and tested a simple LoggingService to verify that the dependency injection system works correctly. This implementation:

- Demonstrates using get_it and injectable for dependency injection
- Shows how to create interface and implementation classes
- Illustrates environment-specific implementations
- Provides a pattern for future service implementation
- Verifies that the DI system is properly configured

This foundation will support the development of more complex features and services in the HR Connect application, ensuring that dependency management remains clean and maintainable.
