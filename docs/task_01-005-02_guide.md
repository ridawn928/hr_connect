# Implementation Guide: Create the MyApp Widget as the Root Application

## Task Information
- **Task ID**: 01-005-02
- **Title**: Create the MyApp widget as the root of the application
- **Dependencies**: Task 01-005-01 (main.dart implementation), Task 01-004-05 (routing tests), Task 01-003-05 (DI system test)
- **Priority**: High

## 1. Introduction

The MyApp widget serves as the entry point and foundational component for the HR Connect application. It is responsible for setting up the application's theme, localization, routing, and connecting to the dependency injection system. Creating a well-structured MyApp widget is critical as it establishes the architectural patterns that will be followed throughout the application.

This implementation guide provides step-by-step instructions for creating the MyApp widget according to the Modified Vertical Slice Architecture (MVSA) and HR Connect development guidelines.

## 2. Requirements Analysis

### 2.1 Technical Requirements

The MyApp widget must:

- Implement Material Design 3 with proper theming
- Support both light and dark themes
- Configure localization for multiple languages
- Integrate with the auto_route routing system
- Connect with the get_it dependency injection system
- Wrap the application with Riverpod's ProviderScope
- Include offline status indicators
- Support role-based UI adaptation based on user permissions
- Follow test-driven development practices

### 2.2 Dependencies

- **Flutter Framework**: Flutter 3.29+ with Dart 3.7+
- **State Management**: Riverpod (^2.6.1) and flutter_riverpod (^2.6.1)
- **Dependency Injection**: get_it (^7.6.0) and injectable (^2.1.6)
- **Routing**: auto_route or go_router (configured in Task 01-004-02)
- **Localization**: flutter_localizations and app-specific localization
- **Theming**: Material Design 3 components and theme system

## 3. Implementation Steps

### Step 1: Create the MyApp Class Structure

Start by creating the basic MyApp widget structure in the `lib/app.dart` file.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/core/navigation/app_router.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hr_connect/core/localization/app_localizations.dart';

/// The root widget of the HR Connect application.
///
/// This widget sets up the application-wide configurations including
/// theming, routing, and localization. It follows the Material Design 3
/// guidelines and supports both light and dark themes.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get router instance from DI container
    final AppRouter _appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      title: 'HR Connect',
      debugShowCheckedModeBanner: false,
      
      // To be implemented in the following steps
    );
  }
}
```

### Step 2: Integrate Dependency Injection

Ensure that the MyApp widget correctly integrates with the dependency injection system. The router instance should be retrieved from the GetIt service locator.

```dart
// In app.dart
@override
Widget build(BuildContext context) {
  // Get router instance from DI container
  final AppRouter _appRouter = getIt<AppRouter>();
  
  return MaterialApp.router(
    // Router configuration
    routerDelegate: _appRouter.delegate(),
    routeInformationParser: _appRouter.defaultRouteParser(),
    // Other configurations...
  );
}
```

### Step 3: Set Up Material 3 Theming

Implement theming using Material Design 3 guidelines. Create an AppTheme class in `lib/core/theme/app_theme.dart` to define light and dark themes.

```dart
// In core/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Provides theming for the HR Connect application following Material Design 3.
///
/// Contains definitions for both light and dark themes, ensuring consistent 
/// visual appearance throughout the application.
class AppTheme {
  /// Creates the light theme for the application.
  ///
  /// Follows Material Design 3 guidelines with a customized color scheme
  /// based on the primary brand color.
  static ThemeData lightTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary brand color
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
    );
  }
  
  /// Creates the dark theme for the application.
  ///
  /// Follows Material Design 3 guidelines with a customized color scheme
  /// optimized for dark mode viewing.
  static ThemeData darkTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // Primary brand color
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
      ),
    );
  }
}
```

Then integrate theming in the MyApp widget:

```dart
// In app.dart, update the build method
return MaterialApp.router(
  title: 'HR Connect',
  debugShowCheckedModeBanner: false,
  
  // Theme configuration
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.system, // Uses system preference
  
  // Router configuration
  routerDelegate: _appRouter.delegate(),
  routeInformationParser: _appRouter.defaultRouteParser(),
);
```

### Step 4: Configure Localization Support

Add localization support to the application by setting up delegates and supported locales.

First, create the localization infrastructure in `lib/core/localization/app_localizations.dart`. For this guide, we'll assume this file has been set up in a previous task.

Then update the MyApp widget:

```dart
// In app.dart, update the build method
return MaterialApp.router(
  title: 'HR Connect',
  debugShowCheckedModeBanner: false,
  
  // Theme configuration
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.system,
  
  // Localization configuration
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en', ''), // English
    Locale('es', ''), // Spanish
    // Add more supported locales as needed
  ],
  
  // Router configuration
  routerDelegate: _appRouter.delegate(),
  routeInformationParser: _appRouter.defaultRouteParser(),
);
```

### Step 5: Integrate with Riverpod

Ensure the application is wrapped with Riverpod's ProviderScope. This should be done in the main.dart file:

```dart
// In main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(); // This initializes the GetIt container
  
  runApp(
    // Wrap the entire app with ProviderScope for Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### Step 6: Add Offline Status Indicator

Implement an offline status indicator using a builder function in MaterialApp:

```dart
// First, create an offline status provider in lib/core/providers/connectivity_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

// Then, in app.dart, update the build method
@override
Widget build(BuildContext context) {
  final AppRouter _appRouter = getIt<AppRouter>();
  
  return Consumer(
    builder: (context, ref, child) {
      final connectivity = ref.watch(connectivityProvider);
      
      return MaterialApp.router(
        title: 'HR Connect',
        debugShowCheckedModeBanner: false,
        
        // Theme configuration
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        
        // Localization configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('es', ''), // Spanish
        ],
        
        // Router configuration
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        
        // Add offline indicator and other global UI enhancements
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              // Display offline indicator when connectivity is lost
              if (connectivity.value == ConnectivityResult.none)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      'You are offline. Some features may be limited.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }
  );
}
```

### Step 7: Permission-Aware UI Adaptation

Implement a mechanism to adapt the UI based on user permissions:

```dart
// In lib/core/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/auth/user_role.dart';

final userRoleProvider = StateProvider<UserRole>((ref) {
  // Default to Employee role until authentication is completed
  return UserRole.employee;
});

// Then, in app.dart, update the builder function
builder: (context, child) {
  final userRole = ref.watch(userRoleProvider);
  
  return Stack(
    children: [
      // Add role-based UI adaptation if needed
      PermissionAwareBuilder(
        child: child!,
        userRole: userRole,
      ),
      
      // Display offline indicator when connectivity is lost
      if (connectivity.value == ConnectivityResult.none)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Text(
              'You are offline. Some features may be limited.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
    ],
  );
},
```

Create the `PermissionAwareBuilder` widget in `lib/core/widgets/permission_aware_builder.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hr_connect/core/auth/user_role.dart';

/// A widget that adapts its child based on the user's role permissions.
///
/// This widget can be used to show or hide features based on the user's role,
/// ensuring that the UI respects the role-based access control system.
class PermissionAwareBuilder extends StatelessWidget {
  /// The child widget to display.
  final Widget child;
  
  /// The current user role.
  final UserRole userRole;
  
  /// Creates a new [PermissionAwareBuilder].
  const PermissionAwareBuilder({
    Key? key,
    required this.child,
    required this.userRole,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Here you can add global permission-based adaptations
    // For now, we just return the child
    return child;
    
    // In the future, you might add overlays or modify the child
    // based on permissions, for example:
    /*
    return Stack(
      children: [
        child,
        if (userRole == UserRole.branchManager)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Manager-specific action
              },
              tooltip: 'Manager Actions',
              child: const Icon(Icons.admin_panel_settings),
            ),
          ),
      ],
    );
    */
  }
}
```

## 4. Testing Approach

Follow the TDD approach by creating tests before implementing the MyApp widget.

### 4.1 Widget Test for MyApp

Create a widget test in `test/widget/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:mockito/mockito.dart';
import 'package:hr_connect/core/navigation/app_router.dart';

// Mock AppRouter
class MockAppRouter extends Mock implements AppRouter {
  @override
  RouteInformationParser get defaultRouteParser => 
      MockRouteInformationParser();
      
  @override
  RouterDelegate get delegate => MockRouterDelegate();
}

class MockRouteInformationParser extends Mock 
    implements RouteInformationParser {}
    
class MockRouterDelegate extends Mock 
    implements RouterDelegate {}

void main() {
  setUp(() {
    // Set up GetIt for testing
    getIt.registerSingleton<AppRouter>(MockAppRouter());
  });

  tearDown(() {
    // Clean up GetIt after tests
    getIt.reset();
  });

  testWidgets('MyApp initializes with correct theme and configuration',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify MaterialApp.router was created
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // You cannot easily test for specific theme properties
    // in widget tests, so focus on structure and presence
    
    // More specific tests can be added here
  });
}
```

### 4.2 Advanced Testing Recommendations

- Test theme switching behavior
- Test localization features
- Test offline status indicator appearance
- Test role-based UI adaptation

## 5. Best Practices and Guidelines

### 5.1 Code Organization

- Keep the MyApp widget focused on application configuration
- Move theme definitions to a separate file (AppTheme)
- Maintain clear separation of concerns
- Avoid business logic in the MyApp widget

### 5.2 Documentation

- Add proper documentation comments to the MyApp class
- Clearly explain the purpose of each configuration section
- Document any non-obvious implementation details

### 5.3 Error Handling

Consider adding error boundaries to catch and handle errors gracefully:

```dart
// Add a simple error boundary widget to your application
class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'An unexpected error occurred: ${details.exception}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      );
    };

    return child;
  }
}

// Then, in the app.dart builder:
builder: (context, child) {
  return ErrorBoundary(
    child: Stack(
      children: [
        child!,
        // Rest of your UI...
      ],
    ),
  );
},
```

### 5.4 Performance Considerations

- Initialize services asynchronously where possible
- Defer non-critical initialization to improve startup time
- Ensure UI remains responsive during initialization

## 6. Integration with Other Components

### 6.1 Relationship with main.dart (Task 01-005-01)

The main.dart file should:
1. Call `WidgetsFlutterBinding.ensureInitialized()`
2. Initialize the dependency injection system
3. Perform other initializations (Firebase, etc.)
4. Create the `ProviderScope` and `MyApp` instances

### 6.2 Relationship with Routing (Tasks 01-004-*)

The MyApp widget:
1. Gets the AppRouter instance from the DI container
2. Configures the MaterialApp.router with the router
3. Sets up deep link handling if needed

### 6.3 Relationship with Dependency Injection (Tasks 01-003-*)

The MyApp widget:
1. Uses the global GetIt instance to retrieve dependencies
2. Does not directly instantiate services
3. Follows the dependency inversion principle

## 7. Troubleshooting

### 7.1 Common Issues and Solutions

1. **Black/blank screen on startup**
   - Check if the router configuration is correct
   - Ensure the initial route is properly defined

2. **Theme not applying correctly**
   - Verify MaterialApp.theme and MaterialApp.darkTheme are set
   - Check if ThemeData has useMaterial3 set to true

3. **Localization not working**
   - Ensure all localization delegates are properly registered
   - Verify supportedLocales includes the desired locales

4. **Offline indicator not showing**
   - Check if the connectivity_plus package is properly installed
   - Verify the provider is correctly watching connectivity changes

### 7.2 Debugging Tips

- Use `debugPrint` to log initialization steps
- Add key properties to widgets for easier debugging
- Start with a minimal implementation and add features incrementally

## 8. Final Review Checklist

Before considering this task complete, ensure:

- [ ] The MyApp widget is properly structured with Material 3 theming
- [ ] Light and dark themes are correctly implemented
- [ ] Localization is configured with appropriate delegates
- [ ] The routing system is properly integrated
- [ ] Offline status indicator is implemented
- [ ] Role-based UI adaptation mechanism is in place
- [ ] All tests are passing
- [ ] Documentation is complete and accurate
- [ ] The code follows HR Connect development guidelines
- [ ] The implementation works with the rest of the application

## 9. Next Steps

After completing this task, proceed to:
- Task 01-005-03: Develop comprehensive architecture documentation
- Task 01-005-04: Place documentation in a /docs folder at the project root
- Task 01-005-05: Review and validate documentation for completeness and clarity
