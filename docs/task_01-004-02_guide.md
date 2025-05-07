# Implementation Guide: Defining the AppRouter Class with go_router

## Task ID: 01-004-02 - Define the AppRouter class using auto_route or go_router

### 1. Introduction

This guide provides step-by-step instructions for implementing the `AppRouter` class using go_router for the HR Connect application. The `AppRouter` class is a critical component of the routing system, responsible for managing navigation between different screens.

#### 1.1 Purpose

The `AppRouter` class serves several important purposes in the application:

- Defines the relationship between routes and screens
- Manages navigation between screens
- Handles route parameters and arguments
- Implements route guards for authentication and permissions
- Supports deep linking and URL-based navigation
- Provides a clean API for navigation throughout the application

#### 1.2 Relationship to Previous Task

This task builds directly on task 01-004-01, which established the directory structure for routing and defined interfaces for the routing components. While the previous task created the foundation, this task involves implementing the actual router class.

### 2. Router Selection: go_router vs auto_route

#### 2.1 Comparison of Routing Libraries

Both go_router and auto_route are popular routing libraries for Flutter, each with their own strengths and weaknesses:

| Feature | go_router | auto_route |
|---------|-----------|------------|
| Maintained by | Flutter team | Community |
| Code generation | No | Yes |
| Type safety | Manual | Generated |
| Setup complexity | Lower | Higher |
| Nested navigation | Supported | Strong support |
| Deep linking | Built-in | Supported |
| Route guards | Supported via redirects | Built-in |
| Learning curve | Gentle | Steeper |

#### 2.2 Recommendation for HR Connect

For the HR Connect application, **go_router** is recommended for the following reasons:

1. **Official Flutter Support**: go_router is maintained by the Flutter team, ensuring long-term compatibility and support.
2. **Simpler Setup**: No code generation required, making it faster to implement and easier to maintain.
3. **Strong Deep Linking Support**: Essential for supporting QR-code based navigation in the attendance tracking feature.
4. **Sufficient Features**: Provides all the necessary routing capabilities required by HR Connect.
5. **Lower Learning Curve**: Easier for team members to understand and contribute to.

However, if your team has different priorities, such as stronger type safety or complex nested navigation, auto_route may be a better choice. This guide primarily focuses on go_router implementation, with a brief overview of the auto_route alternative.

### 3. Prerequisites

Before implementing the `AppRouter` class, ensure:

1. Task 01-004-01 (Create a core/routing/ directory for routing logic) is completed
2. The project structure follows the HR Connect architecture guidelines
3. The necessary dependencies are added to the pubspec.yaml file

#### 3.1 Add Dependencies to pubspec.yaml

Add the go_router dependency to your pubspec.yaml file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Other dependencies...
  go_router: ^10.0.0  # Use the latest stable version
```

Run `flutter pub get` to install the package.

### 4. Implementing AppRouter with go_router

#### A. Create the AppRouterImpl Class

First, we'll create the implementation of the `AppRouter` interface using go_router:

```dart
// File: lib/core/routing/app_router_impl.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';

/// Implementation of [AppRouter] using go_router.
///
/// This class is responsible for configuring the router and handling
/// navigation throughout the application.
@Singleton(as: AppRouter)
class AppRouterImpl implements AppRouter {
  /// The authentication guard for protected routes.
  final AuthenticationGuard _authGuard;
  
  /// The admin guard for admin-only routes.
  final AdminGuard _adminGuard;
  
  /// The GoRouter instance that powers this implementation.
  late final GoRouter _router;
  
  /// The current route name.
  String _currentRoute = RouteConstants.splash;
  
  /// Creates a new AppRouter implementation.
  ///
  /// Requires [AuthenticationGuard] and [AdminGuard] instances.
  AppRouterImpl(this._authGuard, this._adminGuard) {
    _initializeRouter();
  }
  
  /// Initializes the GoRouter instance.
  void _initializeRouter() {
    _router = GoRouter(
      initialLocation: RouteConstants.splash,
      debugLogDiagnostics: true, // Set to false in production
      redirect: _handleRedirect,
      routes: _buildRoutes(),
      errorBuilder: _handleError,
      refreshListenable: _getAuthChangeNotifier(), // Will be implemented later
      observers: [_getNavigationObserver()], // For analytics
    );
  }
  
  /// Handles redirects for authentication and permissions.
  ///
  /// This method checks if the user is allowed to access the requested route
  /// and redirects to appropriate screens if not.
  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Update current route for tracking
    _currentRoute = state.matchedLocation;
    
    // Check authentication for protected routes
    // This is a simplified implementation - will be expanded later
    final requiresAuth = _routeRequiresAuth(state.matchedLocation);
    if (requiresAuth) {
      final canNavigate = await _authGuard.canNavigate(
        state.matchedLocation,
        state.extra,
      );
      
      if (!canNavigate) {
        return _authGuard.getFallbackRoute(state.matchedLocation, state.extra);
      }
    }
    
    // Check admin permissions for admin routes
    final requiresAdmin = _routeRequiresAdmin(state.matchedLocation);
    if (requiresAdmin) {
      final canNavigate = await _adminGuard.canNavigate(
        state.matchedLocation,
        state.extra,
      );
      
      if (!canNavigate) {
        return _adminGuard.getFallbackRoute(state.matchedLocation, state.extra);
      }
    }
    
    // No redirection needed
    return null;
  }
  
  /// Builds the route configuration.
  ///
  /// This is a placeholder for the actual route configuration that will be
  /// implemented in task 01-004-03. For now, we'll just define a minimal
  /// configuration to make the router work.
  List<RouteBase> _buildRoutes() {
    // This will be expanded in task 01-004-03 with actual routes
    return [
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
    ];
  }
  
  /// Handles routing errors.
  ///
  /// This method is called when a route is not found or when there's
  /// an error during navigation.
  Widget _handleError(BuildContext context, GoRouterState state) {
    // Placeholder for error screen - will be implemented later
    return const Scaffold(
      body: Center(
        child: Text('Route not found'),
      ),
    );
  }
  
  /// Creates a notifier for authentication state changes.
  ///
  /// This is a placeholder that will be replaced when authentication
  /// is implemented. The notifier is used to refresh the router when
  /// the user's authentication state changes.
  ChangeNotifier _getAuthChangeNotifier() {
    // This will be replaced with a real auth change notifier later
    return _DummyChangeNotifier();
  }
  
  /// Creates a navigation observer for analytics.
  ///
  /// This is a placeholder that will be replaced when analytics
  /// is implemented.
  NavigatorObserver _getNavigationObserver() {
    // This will be replaced with a real observer later
    return NavigatorObserver();
  }
  
  /// Checks if a route requires authentication.
  ///
  /// This is a simplified implementation that will be expanded later.
  bool _routeRequiresAuth(String route) {
    // For now, only login and splash don't require auth
    return route != RouteConstants.login && route != RouteConstants.splash;
  }
  
  /// Checks if a route requires admin permissions.
  ///
  /// This is a simplified implementation that will be expanded later.
  bool _routeRequiresAdmin(String route) {
    // Check if the route is an admin route
    return route.startsWith('/admin');
  }
  
  // Implementation of AppRouter interface
  
  @override
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) async {
    if (!_router.canPop() && routeName == _currentRoute) {
      // Already on this route and can't pop, do nothing
      return null;
    }
    
    return _router.pushNamed<T>(
      routeName,
      extra: arguments,
    );
  }
  
  @override
  Future<T?> replaceTo<T>(String routeName, {Object? arguments}) async {
    return _router.replaceNamed<T>(
      routeName,
      extra: arguments,
    );
  }
  
  @override
  void pop<T>([T? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    }
  }
  
  @override
  void popUntil(String routeName) {
    while (_router.canPop() && _currentRoute != routeName) {
      _router.pop();
    }
  }
  
  @override
  String get currentRoute => _currentRoute;
  
  @override
  void reset() {
    _router.go(RouteConstants.splash);
  }
  
  @override
  RouterConfig<Object> get config => _router;
}

/// Temporary change notifier for authentication state.
///
/// This is a placeholder that will be replaced when authentication
/// is implemented.
class _DummyChangeNotifier extends ChangeNotifier {}
```

#### B. Registering with Dependency Injection

Update the `core/di/service_locator.dart` file to register the router implementation:

```dart
// File: lib/core/di/service_locator.dart (update)

// ...existing imports
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/app_router_impl.dart';
import 'package:hr_connect/core/routing/route_guards.dart';

// ...existing code

void _registerCoreServices(EnvironmentConfig config) {
  // ...existing registrations
  
  // Register route guards
  getIt.registerLazySingleton<AuthenticationGuard>(() => AuthenticationGuard());
  getIt.registerLazySingleton<AdminGuard>(() => AdminGuard());
  
  // Register router
  getIt.registerSingleton<AppRouter>(
    AppRouterImpl(
      getIt<AuthenticationGuard>(),
      getIt<AdminGuard>(),
    ),
  );
}
```

#### C. Implementing the MaterialApp Configuration

Update the `main.dart` file to use the router configuration:

```dart
// File: lib/main.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup service locator with development environment
  final config = EnvironmentConfig.development();
  await setupServiceLocator(config: config);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the router configuration from the service locator
    final router = getIt<AppRouter>();
    
    return MaterialApp.router(
      title: 'HR Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router.config,
    );
  }
}
```

### 5. Testing the AppRouter Implementation

Create a simple test to verify the router configuration:

```dart
// File: test/core/routing/app_router_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/app_router_impl.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';
import 'package:mockito/mockito.dart';

class MockAuthGuard extends Mock implements AuthenticationGuard {}
class MockAdminGuard extends Mock implements AdminGuard {}

void main() {
  late MockAuthGuard mockAuthGuard;
  late MockAdminGuard mockAdminGuard;
  late AppRouter router;
  
  setUp(() {
    mockAuthGuard = MockAuthGuard();
    mockAdminGuard = MockAdminGuard();
    
    // Set up guard behavior
    when(mockAuthGuard.canNavigate(any, any))
        .thenAnswer((_) async => true);
    when(mockAdminGuard.canNavigate(any, any))
        .thenAnswer((_) async => true);
    
    router = AppRouterImpl(mockAuthGuard, mockAdminGuard);
  });
  
  group('AppRouterImpl', () {
    test('should initialize with splash as the current route', () {
      expect(router.currentRoute, equals(RouteConstants.splash));
    });
    
    test('should have a valid router configuration', () {
      expect(router.config, isNotNull);
    });
    
    // Additional tests will be added when route definitions
    // are implemented in task 01-004-03
  });
}
```

### 6. Alternative: Using auto_route

If you prefer to use auto_route instead of go_router, here's how you would approach it:

#### 6.1 Add Dependencies for auto_route

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Other dependencies...
  auto_route: ^7.0.0  # Use the latest stable version

dev_dependencies:
  # Other dev dependencies...
  auto_route_generator: ^7.0.0
  build_runner: ^2.4.8
```

#### 6.2 Create Auto Route Configuration

```dart
// File: lib/core/routing/app_router.dart (auto_route implementation)

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

// This annotation will trigger code generation
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    // Define routes here - will be expanded in task 01-004-03
    AutoRoute(path: '/', page: SplashPage, initial: true),
    AutoRoute(path: '/login', page: LoginPage),
    AutoRoute(path: '/home', page: HomePage),
    // More routes will be added
  ],
)
class $AppRouter {}

// The implementation would be generated by auto_route_generator
// and registered with dependency injection
@Singleton(as: AppRouter)
class AppRouterImpl extends _$AppRouter implements AppRouter {
  AppRouterImpl();
  
  // Implement the AppRouter interface methods here
  // The actual implementation would be completed when the 
  // generated code is available
}
```

#### 6.3 Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 6.4 Key Differences from go_router

When using auto_route:

1. Routes are defined declaratively with annotations
2. Code generation creates type-safe navigation methods
3. Navigation is done with more explicit type parameters
4. Guards are defined as part of the route declaration
5. The setup requires build_runner for code generation

### 7. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-004-03**: Set up initial route definitions with placeholder screens

This next task will involve defining the actual routes and connecting them to placeholder screens to verify the routing system works correctly.

### 8. Conclusion

You have now implemented the `AppRouter` class using go_router for the HR Connect application. This implementation:

- Provides a clean interface for navigation
- Supports route guards for authentication and permissions
- Handles route parameters and arguments
- Integrates with the dependency injection system
- Sets up error handling for navigation

This foundation will support the development of feature-specific routes and more complex navigation patterns in subsequent tasks. The router implementation follows the Modified Vertical Slice Architecture (MVSA) principles and provides a flexible solution for the application's routing needs.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the routing system, particularly regarding proper typing, documentation, and architecture principles.
