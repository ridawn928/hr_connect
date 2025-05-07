# Implementation Guide: Creating the core/routing/ Directory for Routing Logic

## Task ID: 01-004-01 - Create a core/routing/ directory for routing logic

### 1. Introduction

This guide provides step-by-step instructions for creating the `core/routing/` directory structure for the HR Connect application. This task establishes the foundation for the routing system, which will manage navigation between different screens within the application.

#### 1.1 Purpose

The routing system is a critical architectural component that:

- Manages navigation between different screens and features
- Centralizes route definitions and transitions
- Provides a clean API for navigating throughout the application
- Supports deep linking and URL-based navigation
- Enables route guards for authentication and permissions

Creating a dedicated directory for routing logic helps maintain separation of concerns and keeps the codebase organized according to the Modified Vertical Slice Architecture (MVSA) principles.

#### 1.2 Relationship to MVSA Architecture

In the MVSA architecture used by HR Connect:

- **Core Components**: The routing system is a core infrastructure component used across all feature slices
- **Feature Independence**: Features will define their own routes, but use the core routing infrastructure
- **Clean Architecture**: Routing provides a boundary between UI and business logic
- **Dependency Inversion**: Features depend on routing abstractions rather than concrete implementations

### 2. Prerequisites

Before starting this task, ensure:

- Task 01-003-05 (Create and test a simple service to verify the DI system works) is completed
- The project structure follows the HR Connect architecture guidelines
- You have a basic understanding of Flutter navigation and routing concepts

### 3. Directory Structure Setup

#### 3.1 Create the core/routing/ Directory

First, create the routing directory within the core folder:

```bash
mkdir -p lib/core/routing
```

This directory will contain all routing-related files for the application.

#### 3.2 File Structure Overview

Create the following files within the `lib/core/routing/` directory:

```bash
touch lib/core/routing/route_constants.dart
touch lib/core/routing/app_router.dart
touch lib/core/routing/navigation_service.dart
touch lib/core/routing/route_guards.dart
touch lib/core/routing/navigation_extensions.dart
touch lib/core/routing/README.md
```

Let's examine the purpose of each file:

| File | Purpose |
|------|---------|
| `route_constants.dart` | Defines constants for route names and paths |
| `app_router.dart` | Configures the main router (will be implemented in task 01-004-02) |
| `navigation_service.dart` | Provides an abstraction layer for navigation |
| `route_guards.dart` | Contains middleware for authentication and permissions |
| `navigation_extensions.dart` | Extension methods for easier navigation |
| `README.md` | Documents the routing architecture |

### 4. File Templates

The following are template implementations for each file. At this stage, we're creating the basic structure with placeholder implementations that will be completed in subsequent tasks.

#### 4.1 route_constants.dart

```dart
// File: lib/core/routing/route_constants.dart

/// Defines constants for route names and paths used throughout the application.
///
/// This centralizes all route definitions to avoid string duplication and
/// make route management easier. Routes are organized by feature.
class RouteConstants {
  /// Private constructor to prevent instantiation
  const RouteConstants._();

  // Core routes
  /// Route to the splash screen
  static const String splash = '/';
  
  /// Route to the login screen
  static const String login = '/login';
  
  /// Route to the home screen (dashboard)
  static const String home = '/home';
  
  // Attendance feature routes
  /// Route to the attendance QR scanner
  static const String qrScanner = '/attendance/scan';
  
  /// Route to the attendance history
  static const String attendanceHistory = '/attendance/history';
  
  // Time management feature routes
  /// Route to the leave request form
  static const String leaveRequest = '/time/leave-request';
  
  /// Route to the leave history
  static const String leaveHistory = '/time/leave-history';
  
  // Employee profile feature routes
  /// Route to the employee profile
  static const String employeeProfile = '/employee/profile';
  
  /// Route to the profile edit screen
  static const String editProfile = '/employee/profile/edit';
  
  // Admin feature routes
  /// Route to the admin dashboard
  static const String adminDashboard = '/admin/dashboard';
  
  /// Route to the admin settings
  static const String adminSettings = '/admin/settings';
}
```

#### 4.2 app_router.dart

```dart
// File: lib/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Central router configuration for the HR Connect application.
///
/// This class will be implemented in task 01-004-02 using either
/// auto_route or go_router. This file serves as a placeholder
/// with the expected interface.
abstract class AppRouter {
  /// Navigates to the given route.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> navigateTo<T>(String routeName, {Object? arguments});
  
  /// Replaces the current route with a new one.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> replaceTo<T>(String routeName, {Object? arguments});
  
  /// Pops the current route off the stack.
  ///
  /// [result] Optional result to return to the previous route.
  void pop<T>([T? result]);
  
  /// Pops all routes until the specified route.
  ///
  /// [routeName] The name of the route to pop to.
  void popUntil(String routeName);
  
  /// Gets the current route name.
  String get currentRoute;
  
  /// Resets the navigation stack to the initial route.
  void reset();
  
  /// Builds the router configuration.
  ///
  /// This will be used to create the router delegate and parser
  /// for the MaterialApp.router configuration.
  RouterConfig<Object> get config;
}

// Note: This is a placeholder that will be replaced with actual implementation
// in task 01-004-02. The implementation will likely use auto_route or go_router
// and will be registered with the DI system.
```

#### 4.3 navigation_service.dart

```dart
// File: lib/core/routing/navigation_service.dart

import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/app_router.dart';

/// Service that provides navigation capabilities throughout the app.
///
/// This service abstracts the actual routing implementation from the
/// rest of the application. Features should use this service for
/// navigation rather than directly using the router.
@lazySingleton
class NavigationService {
  /// The router implementation
  final AppRouter _router;
  
  /// Creates a new navigation service.
  ///
  /// Requires an [AppRouter] instance which will be injected via DI.
  NavigationService(this._router);
  
  /// Navigates to the given route.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return _router.navigateTo<T>(routeName, arguments: arguments);
  }
  
  /// Replaces the current route with a new one.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> replaceTo<T>(String routeName, {Object? arguments}) {
    return _router.replaceTo<T>(routeName, arguments: arguments);
  }
  
  /// Pops the current route off the stack.
  ///
  /// [result] Optional result to return to the previous route.
  void pop<T>([T? result]) {
    _router.pop<T>(result);
  }
  
  /// Pops all routes until the specified route.
  ///
  /// [routeName] The name of the route to pop to.
  void popUntil(String routeName) {
    _router.popUntil(routeName);
  }
  
  /// Gets the current route name.
  String get currentRoute => _router.currentRoute;
  
  /// Resets the navigation stack to the initial route.
  void reset() {
    _router.reset();
  }
}

// Note: The actual implementation of NavigationService will be completed after
// the AppRouter is implemented in task 01-004-02. This is a placeholder that
// defines the expected interface.
```

#### 4.4 route_guards.dart

```dart
// File: lib/core/routing/route_guards.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Base interface for all route guards in the application.
///
/// Route guards are used to control access to routes based on
/// conditions like authentication status, permissions, etc.
abstract class RouteGuard {
  /// Checks if navigation to the route should be allowed.
  ///
  /// [routeName] The name of the route being navigated to.
  /// [arguments] The arguments being passed to the route.
  ///
  /// Returns a [Future] that resolves to true if navigation should
  /// be allowed, or false if it should be prevented.
  Future<bool> canNavigate(String routeName, Object? arguments);
  
  /// Gets the fallback route if navigation is prevented.
  ///
  /// [routeName] The name of the route that was prevented.
  /// [arguments] The arguments that were passed to the route.
  ///
  /// Returns the name of the route to redirect to, or null if
  /// no redirection should occur.
  String? getFallbackRoute(String routeName, Object? arguments);
}

/// Guard that checks if the user is authenticated.
///
/// This is a placeholder that will be implemented when authentication
/// is added to the application.
class AuthenticationGuard implements RouteGuard {
  @override
  Future<bool> canNavigate(String routeName, Object? arguments) async {
    // This is a placeholder - implementation will be added later
    // when authentication is implemented
    return true;
  }
  
  @override
  String? getFallbackRoute(String routeName, Object? arguments) {
    return RouteConstants.login;
  }
}

/// Guard that checks if the user has admin permissions.
///
/// This is a placeholder that will be implemented when role-based
/// access control is added to the application.
class AdminGuard implements RouteGuard {
  @override
  Future<bool> canNavigate(String routeName, Object? arguments) async {
    // This is a placeholder - implementation will be added later
    // when RBAC is implemented
    return true;
  }
  
  @override
  String? getFallbackRoute(String routeName, Object? arguments) {
    return RouteConstants.home;
  }
}

// Note: Additional guards will be added as needed when implementing
// the application's security features.
```

#### 4.5 navigation_extensions.dart

```dart
// File: lib/core/routing/navigation_extensions.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Extension methods for [NavigationService] to provide type-safe
/// navigation to specific screens.
///
/// This simplifies navigation calls and provides better type safety by
/// defining methods for each destination instead of using strings.
extension NavigationServiceExtensions on NavigationService {
  // Core navigation extensions
  
  /// Navigates to the home screen.
  Future<void> toHome() {
    return navigateTo(RouteConstants.home);
  }
  
  /// Navigates to the login screen.
  Future<void> toLogin() {
    return navigateTo(RouteConstants.login);
  }
  
  // Attendance feature extensions
  
  /// Navigates to the QR scanner screen.
  Future<void> toQRScanner() {
    return navigateTo(RouteConstants.qrScanner);
  }
  
  /// Navigates to the attendance history screen.
  Future<void> toAttendanceHistory() {
    return navigateTo(RouteConstants.attendanceHistory);
  }
  
  // Time management feature extensions
  
  /// Navigates to the leave request screen.
  Future<void> toLeaveRequest() {
    return navigateTo(RouteConstants.leaveRequest);
  }
  
  /// Navigates to the leave history screen.
  Future<void> toLeaveHistory() {
    return navigateTo(RouteConstants.leaveHistory);
  }
  
  // Employee profile feature extensions
  
  /// Navigates to the employee profile screen.
  ///
  /// [employeeId] The ID of the employee to view.
  Future<void> toEmployeeProfile({String? employeeId}) {
    return navigateTo(
      RouteConstants.employeeProfile,
      arguments: employeeId,
    );
  }
  
  /// Navigates to the profile edit screen.
  ///
  /// [employeeId] The ID of the employee to edit.
  Future<void> toEditProfile({required String employeeId}) {
    return navigateTo(
      RouteConstants.editProfile,
      arguments: employeeId,
    );
  }
  
  // Admin feature extensions
  
  /// Navigates to the admin dashboard.
  Future<void> toAdminDashboard() {
    return navigateTo(RouteConstants.adminDashboard);
  }
  
  /// Navigates to the admin settings.
  Future<void> toAdminSettings() {
    return navigateTo(RouteConstants.adminSettings);
  }
}

// Note: These extensions will be expanded as more screens are added to the application.
// The actual parameter types will be updated based on the requirements of each screen.
```

#### 4.6 README.md

```markdown
# HR Connect Routing Architecture

This directory contains the routing infrastructure for the HR Connect application, following the Modified Vertical Slice Architecture (MVSA).

## Overview

The routing system in HR Connect is designed to provide:

- Centralized route definitions
- Type-safe navigation
- Authentication and permission guards
- Feature-specific routes
- Support for deep linking

## Components

- **RouteConstants**: Defines string constants for all routes in the application
- **AppRouter**: Configures the router using either auto_route or go_router
- **NavigationService**: Provides an abstraction layer for navigating through the app
- **RouteGuards**: Middleware for authentication and permission checks
- **NavigationExtensions**: Extension methods for type-safe navigation

## Usage

### Basic Navigation

```dart
// Inject NavigationService in your widget or service
final NavigationService _navigationService;

// Navigate to a specific route
_navigationService.navigateTo(RouteConstants.home);

// Navigate with arguments
_navigationService.navigateTo(
  RouteConstants.employeeProfile,
  arguments: employeeId,
);
```

### Using Extensions

```dart
// Using type-safe extension methods
_navigationService.toHome();
_navigationService.toEmployeeProfile(employeeId: 'emp123');
```

### Defining Feature Routes

Feature modules should define their routes in the `RouteConstants` class. Routes should follow this naming convention:

- Core routes: `/routeName`
- Feature routes: `/feature/routeName`

## Implementation Notes

This directory currently contains placeholder implementations that will be fully implemented in subsequent tasks:

- Task 01-004-02: Define the AppRouter class using auto_route or go_router
- Task 01-004-03: Set up initial route definitions with placeholder screens
- Task 01-004-04: Implement navigation helpers and extension methods
- Task 01-004-05: Test routing by navigating between the home screen and a test screen
```

### 5. Integration with Dependency Injection System

When the routing implementation is completed in subsequent tasks, the router and navigation service will need to be registered with the dependency injection system. Add a placeholder for this in your `core/di/service_locator.dart` file:

```dart
// This will be added when implementing task 01-004-02
// void _registerRoutingServices() {
//   getIt.registerSingleton<AppRouter>(AppRouterImpl());
//   getIt.registerLazySingleton<NavigationService>(() => NavigationService(getIt()));
// }
```

### 6. Verifying the Directory Structure

After creating all the files, your directory structure should look like this:

```
lib/
├── core/
│   ├── di/
│   └── routing/
│       ├── README.md
│       ├── app_router.dart
│       ├── navigation_extensions.dart
│       ├── navigation_service.dart
│       ├── route_constants.dart
│       └── route_guards.dart
```

You can verify the structure was created correctly with:

```bash
find lib/core/routing -type f | sort
```

### 7. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-004-02**: Define the AppRouter class using auto_route or go_router

This next task will involve implementing the actual router configuration using either auto_route or go_router, building on the structure you've just created.

### 8. Conclusion

You have now created the core/routing/ directory structure for the HR Connect application. This structure provides the foundation for the routing system that will be implemented in subsequent tasks. The placeholder files you've created define the interfaces and expected behavior of the routing components, which will make the actual implementation more straightforward.

The routing architecture you've set up follows the Modified Vertical Slice Architecture (MVSA) and supports the application's needs for navigation, deep linking, and route guards. This foundation will enable clean navigation between different features while maintaining separation of concerns.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the routing system, particularly regarding proper typing, documentation, and architecture principles.
