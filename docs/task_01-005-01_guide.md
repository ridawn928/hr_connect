# Implementation Guide: Main.dart with Proper Initialization Sequence

## Task ID: 01-005-01 - Implement the main.dart file with proper initialization sequence (DI setup, app config, initial routing)

### 1. Introduction

This guide provides step-by-step instructions for implementing the main entry point of the HR Connect application - the `main.dart` file. This file sets up the proper initialization sequence, including dependency injection setup, application configuration, and initial routing.

#### 1.1 Purpose

The `main.dart` file serves as the entry point for the entire application and is responsible for:

- Initializing Flutter bindings
- Setting up error handling and logging
- Configuring the environment (development, testing, production)
- Initializing the dependency injection system
- Applying the Material 3 design system
- Configuring the initial routing
- Launching the application with the correct configuration

#### 1.2 Relationship to Previous Tasks

This task builds on several previous tasks:
- Tasks 01-003-01 through 01-003-05: Dependency injection setup
- Tasks 01-004-01 through 01-004-05: Routing system implementation

The `main.dart` file brings together these components to create a cohesive application that follows the Modified Vertical Slice Architecture (MVSA) principles.

### 2. Prerequisites

Before implementing the `main.dart` file, ensure:

1. The dependency injection system (get_it and injectable) is properly set up
2. The routing system (go_router) is implemented and tested
3. The environment configuration system is in place
4. All necessary dependencies are added to pubspec.yaml

### 3. Main Function Implementation

The `main.dart` file starts with the `main()` function, which is the entry point for the application. Let's implement it with proper initialization sequence:

```dart
// File: lib/main.dart

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';

/// Application entry point.
///
/// This function initializes all necessary components before starting
/// the application, including Flutter bindings, dependency injection,
/// environment configuration, and error handling.
Future<void> main() async {
  // Catch any errors that occur during initialization
  await runZonedGuarded(() async {
    // Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations (optional)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set up the system UI (optional)
    await _setupSystemUI();
    
    // Setup service locator with appropriate environment
    // For development, use development environment
    final config = _getCurrentEnvironment();
    await setupServiceLocator(config: config);
    
    // Get the logging service and log app start
    final logger = getIt<LoggingService>();
    logger.info('Starting HR Connect application');
    
    // Run the application
    runApp(const MyApp());
  }, (error, stackTrace) {
    // Global error handler for uncaught exceptions
    developer.log(
      'Uncaught exception',
      error: error,
      stackTrace: stackTrace,
      name: 'hr_connect.main',
    );
    
    // In a real application, you might want to report the error
    // to a crash reporting service like Firebase Crashlytics
    // _reportError(error, stackTrace);
  });
}

/// Sets up the system UI appearance.
///
/// Configures the status bar and navigation bar appearance
/// for a consistent look across the application.
Future<void> _setupSystemUI() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  await SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

/// Determines the current environment to use.
///
/// In a real application, this might be determined by build flags,
/// environment variables, or other configuration mechanisms.
EnvironmentConfig _getCurrentEnvironment() {
  // For now, we'll use the development environment
  // In a real application, this could be based on build flags or env vars
  // const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  // Use development environment by default
  return EnvironmentConfig.development();
  
  // For other environments, use:
  // return EnvironmentConfig.test();
  // return EnvironmentConfig.staging();
  // return EnvironmentConfig.production();
}
```

### 4. Environment Configuration Access

The `_getCurrentEnvironment()` function determines which environment the application should use. In a real application, this might be determined by build flags or environment variables. For now, we're using the development environment.

You might want to add a more robust environment selection mechanism using build flags:

```dart
/// Determines the current environment based on build flags.
EnvironmentConfig _getCurrentEnvironment() {
  const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );
  
  switch (environment) {
    case 'prod':
      return EnvironmentConfig.production();
    case 'staging':
      return EnvironmentConfig.staging();
    case 'test':
      return EnvironmentConfig.test();
    case 'dev':
    default:
      return EnvironmentConfig.development();
  }
}
```

To use this with different environments, you would run the app with:

```bash
# For development
flutter run --dart-define=ENV=dev

# For production
flutter run --dart-define=ENV=prod
```

### 5. MyApp Widget Implementation

Now, let's implement the `MyApp` widget, which is the root widget of the application:

```dart
/// Root widget of the HR Connect application.
///
/// This widget sets up the application theme and router configuration.
class MyApp extends StatelessWidget {
  /// Creates a new app instance.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the router configuration from the service locator
    final router = getIt<AppRouter>();
    
    return MaterialApp.router(
      title: 'HR Connect',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system, // Use system theme mode
      routerConfig: router.config,
      builder: (context, child) {
        // Add any app-wide builders here
        return child ?? const SizedBox.shrink();
      },
    );
  }
  
  /// Builds the light theme for the application.
  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary blue color
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  /// Builds the dark theme for the application.
  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary blue color
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
```

### 6. Creating a Dedicated Theme File (Optional)

For better organization, you might want to extract the theme configuration to a dedicated file:

```dart
// File: lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

/// Provides theme data for the HR Connect application.
class AppTheme {
  /// Private constructor to prevent instantiation.
  const AppTheme._();
  
  /// Creates the light theme for the application.
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary blue color
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Rest of the light theme configuration...
    );
  }
  
  /// Creates the dark theme for the application.
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary blue color
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Rest of the dark theme configuration...
    );
  }
}
```

Then update the `MyApp` widget to use the theme file:

```dart
// File: lib/main.dart (updated MyApp)

import 'package:hr_connect/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    
    return MaterialApp.router(
      title: 'HR Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router.config,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
```

### 7. Handling Initialization Errors

For better error handling during initialization, you can create a dedicated error handler:

```dart
// File: lib/core/error/error_handler.dart

import 'dart:developer' as developer;

/// Handles global application errors.
class ErrorHandler {
  /// Private constructor to prevent instantiation.
  const ErrorHandler._();
  
  /// Reports an error to logging and crash reporting services.
  static void reportError(Object error, StackTrace stackTrace) {
    // Log the error
    developer.log(
      'Error',
      error: error,
      stackTrace: stackTrace,
      name: 'hr_connect.error',
    );
    
    // In a real application, you would report the error to a
    // crash reporting service like Firebase Crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
```

Then update the `main()` function to use the error handler:

```dart
// File: lib/main.dart (updated main function)

import 'package:hr_connect/core/error/error_handler.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    // Initialization code...
  }, (error, stackTrace) {
    // Use the dedicated error handler
    ErrorHandler.reportError(error, stackTrace);
  });
}
```

### 8. Initialization Logging

To better understand the initialization process, you can add more detailed logging:

```dart
// File: lib/main.dart (updated main function with logging)

Future<void> main() async {
  await runZonedGuarded(() async {
    // Log start of initialization
    developer.log(
      'Starting application initialization',
      name: 'hr_connect.main',
    );
    
    // Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();
    developer.log(
      'Flutter bindings initialized',
      name: 'hr_connect.main',
    );
    
    // Set up the environment
    final config = _getCurrentEnvironment();
    developer.log(
      'Environment configured: ${config.environment}',
      name: 'hr_connect.main',
    );
    
    // Setup service locator
    await setupServiceLocator(config: config);
    developer.log(
      'Service locator initialized',
      name: 'hr_connect.main',
    );
    
    // Get the logging service and log app start
    final logger = getIt<LoggingService>();
    logger.info('Starting HR Connect application');
    
    // Run the application
    developer.log(
      'Launching application',
      name: 'hr_connect.main',
    );
    runApp(const MyApp());
  }, (error, stackTrace) {
    // Global error handler
    ErrorHandler.reportError(error, stackTrace);
  });
}
```

### 9. Testing the Implementation

#### 9.1 Manual Testing

To manually test the implementation, run the application and verify:

1. The application starts without errors
2. The correct theme is applied
3. The initial route is displayed correctly
4. You can navigate between screens

```bash
flutter run
```

#### 9.2 Environment Testing

Test the application with different environments:

```bash
# Development environment
flutter run --dart-define=ENV=dev

# Production environment
flutter run --dart-define=ENV=prod
```

#### 9.3 Unit Testing

Create a unit test for the `MyApp` widget:

```dart
// File: test/core/app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/main.dart';
import 'package:mockito/mockito.dart';

class MockAppRouter extends Mock implements AppRouter {}

void main() {
  late MockAppRouter mockRouter;
  
  setUp(() {
    mockRouter = MockAppRouter();
    
    // Mock routerConfig to return an empty RouterConfig
    when(mockRouter.config).thenReturn(
      RouterConfig<Object>(routerDelegate: MockRouterDelegate()),
    );
    
    // Register the mock with GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppRouter>()) {
      getIt.unregister<AppRouter>();
    }
    getIt.registerSingleton<AppRouter>(mockRouter);
  });
  
  tearDown(() {
    // Reset GetIt
    final getIt = GetIt.instance;
    getIt.reset();
  });
  
  testWidgets('MyApp should use Material 3', (tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    
    // Get the MaterialApp
    final MaterialApp app = tester.widget(find.byType(MaterialApp.router));
    
    // Verify Material 3 is enabled
    expect(app.theme?.useMaterial3, isTrue);
  });
}

// Mock classes for testing
class MockRouterDelegate extends Mock implements RouterDelegate<Object> {}
```

### 10. Troubleshooting Common Issues

#### 10.1 Dependency Injection Errors

If you encounter errors related to dependency injection:

1. Verify that all required dependencies are registered
2. Check that the environment configuration is correct
3. Ensure that injectable is properly set up

#### 10.2 Routing Errors

If you encounter routing errors:

1. Verify that the AppRouter is correctly registered with the service locator
2. Check that the route constants are defined correctly
3. Ensure that all required routes are configured in the AppRouterImpl

#### 10.3 Initialization Order Errors

If you encounter errors related to initialization order:

1. Ensure Flutter bindings are initialized first
2. Verify that services are accessed only after they are registered
3. Check that async operations are properly awaited

### 11. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-005-02**: Create the MyApp widget as the root of the application (already completed as part of this task)
- **Task 01-005-03**: Develop comprehensive architecture documentation

### 12. Conclusion

You have now implemented the main.dart file with proper initialization sequence for the HR Connect application. This implementation:

- Sets up the correct initialization order for Flutter components
- Configures the environment for the application
- Initializes the dependency injection system
- Sets up the Material 3 theme
- Configures the initial routing
- Provides robust error handling

This foundation will support the development of the HR Connect application, with all necessary components properly initialized and configured.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the application, particularly regarding proper typing, documentation, and architecture principles.
