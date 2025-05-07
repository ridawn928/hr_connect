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
- **AppRouter**: Configures the router using go_router
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

- Task 01-004-02: Define the AppRouter class using go_router
- Task 01-004-03: Set up initial route definitions with placeholder screens
- Task 01-004-04: Implement navigation helpers and extension methods
- Task 01-004-05: Test routing by navigating between the home screen and a test screen 