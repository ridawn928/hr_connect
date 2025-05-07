# Implementation Guide: Navigation Helpers and Extension Methods

## Task ID: 01-004-04 - Implement navigation helpers and extension methods

### 1. Introduction

This guide provides step-by-step instructions for implementing navigation helpers and extension methods in the HR Connect application. These will enhance the routing system by providing a cleaner, more type-safe API for navigation throughout the application.

#### 1.1 Purpose

Navigation helpers and extension methods serve several important purposes:

- Simplify navigation code by reducing boilerplate
- Provide type safety for route parameters and arguments
- Make navigation more intuitive and less error-prone
- Centralize navigation patterns for consistency
- Improve code readability and maintainability
- Support the feature-based architecture by organizing navigation by feature

#### 1.2 Relationship to Previous Tasks

This task builds directly on:
- Task 01-004-01: Create a core/routing/ directory for routing logic
- Task 01-004-02: Define the AppRouter class using auto_route or go_router
- Task 01-004-03: Set up initial route definitions with placeholder screens

While the previous tasks established the routing infrastructure and basic navigation capabilities, this task enhances the developer experience by providing a more intuitive API for navigation.

### 2. Prerequisites

Before implementing navigation helpers and extension methods, ensure:

1. Task 01-004-03 is completed and the initial route definitions with placeholder screens are set up
2. The NavigationService is properly integrated with the AppRouter
3. The routing system is registered with the dependency injection system
4. You have a basic understanding of extension methods in Dart

### 3. Implementation Approach

#### 3.1 Overview

We'll implement three types of navigation enhancements:

1. **BuildContext Extensions**: To make navigation accessible from any widget
2. **NavigationService Extensions**: To provide type-safe methods for specific screens
3. **Navigation Helper Utilities**: For common navigation patterns and stack management

#### 3.2 Design Principles

Our implementation will follow these principles:

- **Type Safety**: Use strongly typed parameters and arguments
- **Discoverability**: Make navigation methods easy to find and use
- **Consistency**: Follow a consistent naming pattern for all methods
- **Simplicity**: Keep the API simple and intuitive
- **Feature Organization**: Group navigation methods by feature area

### 4. Implementing BuildContext Extensions

First, let's create extensions for BuildContext to make navigation accessible from any widget:

```dart
// File: lib/core/routing/context_extensions.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Extension methods for [BuildContext] to provide easy access to navigation.
///
/// These extensions make it possible to navigate from any widget without
/// explicitly injecting the NavigationService.
extension NavigationContextExtension on BuildContext {
  /// Gets the [NavigationService] from the service locator.
  NavigationService get navigationService => getIt<NavigationService>();
  
  /// Navigates to the specified route.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigationService.navigateTo<T>(routeName, arguments: arguments);
  }
  
  /// Replaces the current route with a new one.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  Future<T?> replaceTo<T>(String routeName, {Object? arguments}) {
    return navigationService.replaceTo<T>(routeName, arguments: arguments);
  }
  
  /// Pops the current route.
  ///
  /// [result] Optional result to return to the previous route.
  void pop<T>([T? result]) {
    navigationService.pop<T>(result);
  }
  
  /// Pops the current route if it can be popped.
  ///
  /// Returns true if the route was popped, false otherwise.
  bool maybePop<T>([T? result]) {
    if (Navigator.of(this).canPop()) {
      navigationService.pop<T>(result);
      return true;
    }
    return false;
  }
  
  /// Pops all routes until the specified route.
  ///
  /// [routeName] The name of the route to pop to.
  void popUntil(String routeName) {
    navigationService.popUntil(routeName);
  }
  
  /// Shows a dialog with the given dialog widget.
  ///
  /// Returns the result of the dialog.
  Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => dialog,
    );
  }
  
  /// Shows a bottom sheet with the given widget.
  ///
  /// Returns the result of the bottom sheet.
  Future<T?> showAppBottomSheet<T>({
    required Widget bottomSheet,
    bool isScrollControlled = true,
    Color? backgroundColor,
    double? elevation,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      elevation: elevation,
      builder: (context) => bottomSheet,
    );
  }
}
```

### 5. Implementing NavigationService Extensions

Next, let's enhance the navigation_extensions.dart file with more comprehensive type-safe methods:

```dart
// File: lib/core/routing/navigation_extensions.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Extension methods for [NavigationService] to provide type-safe navigation.
extension NavigationServiceExtensions on NavigationService {
  // ===== CORE NAVIGATION =====
  
  /// Navigates to the splash screen.
  Future<void> toSplash() {
    return navigateTo(RouteConstants.splash);
  }
  
  /// Navigates to the login screen.
  Future<void> toLogin() {
    return navigateTo(RouteConstants.login);
  }
  
  /// Navigates to the home dashboard.
  Future<void> toHome() {
    return navigateTo(RouteConstants.home);
  }
  
  /// Replaces the current screen with the home dashboard.
  Future<void> replaceWithHome() {
    return replaceTo(RouteConstants.home);
  }
  
  /// Replaces the current screen with the login screen.
  Future<void> replaceWithLogin() {
    return replaceTo(RouteConstants.login);
  }
  
  /// Logs out the user by navigating to the login screen and clearing history.
  Future<void> logout() {
    return replaceTo(RouteConstants.login);
  }
  
  // ===== ATTENDANCE FEATURE =====
  
  /// Navigates to the QR scanner screen.
  Future<void> toQrScanner() {
    return navigateTo(RouteConstants.qrScanner);
  }
  
  /// Navigates to the attendance history screen.
  Future<void> toAttendanceHistory() {
    return navigateTo(RouteConstants.attendanceHistory);
  }
  
  /// Navigates to the attendance detail screen.
  ///
  /// [attendanceId] The ID of the attendance record to view.
  Future<void> toAttendanceDetail(String attendanceId) {
    // In a real implementation, we would have a specific route for this
    return navigateTo(
      RouteConstants.attendanceHistory,
      arguments: {'attendanceId': attendanceId},
    );
  }
  
  // ===== TIME MANAGEMENT FEATURE =====
  
  /// Navigates to the leave request screen.
  Future<void> toLeaveRequest() {
    return navigateTo(RouteConstants.leaveRequest);
  }
  
  /// Navigates to the leave history screen.
  Future<void> toLeaveHistory() {
    return navigateTo(RouteConstants.leaveHistory);
  }
  
  /// Navigates to the leave detail screen.
  ///
  /// [leaveRequestId] The ID of the leave request to view.
  Future<void> toLeaveDetail(String leaveRequestId) {
    // In a real implementation, we would have a specific route for this
    return navigateTo(
      RouteConstants.leaveHistory,
      arguments: {'leaveRequestId': leaveRequestId},
    );
  }
  
  // ===== EMPLOYEE PROFILE FEATURE =====
  
  /// Navigates to the employee profile screen.
  ///
  /// [employeeId] Optional ID of the employee to view. If not provided,
  /// the current user's profile will be shown.
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
  
  // ===== ADMIN FEATURE =====
  
  /// Navigates to the admin dashboard.
  Future<void> toAdminDashboard() {
    return navigateTo(RouteConstants.adminDashboard);
  }
  
  /// Navigates to the admin settings screen.
  Future<void> toAdminSettings() {
    return navigateTo(RouteConstants.adminSettings);
  }
}

/// Extension methods for deeper navigation with results.
extension NavigationWithResultsExtension on NavigationService {
  /// Navigates to the leave request form and waits for a result.
  ///
  /// Returns the ID of the created leave request, or null if cancelled.
  Future<String?> toLeaveRequestForResult() async {
    return navigateTo<String>(RouteConstants.leaveRequest);
  }
  
  /// Navigates to the employee selector and waits for a selection.
  ///
  /// Returns the ID of the selected employee, or null if cancelled.
  Future<String?> toEmployeeSelectorForResult() async {
    // In a real implementation, we would have a specific route for this
    return navigateTo<String>(RouteConstants.employeeProfile);
  }
  
  /// Navigates to the date picker and waits for a selection.
  ///
  /// Returns the selected date, or null if cancelled.
  Future<DateTime?> toDatePickerForResult({DateTime? initialDate}) async {
    // This would use a showDatePicker dialog in a real implementation
    return Future.value(initialDate ?? DateTime.now());
  }
}
```

### 6. Implementing Navigation Helper Utilities

Now, let's create a separate file for navigation helper utilities:

```dart
// File: lib/core/routing/navigation_helpers.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Utility class for common navigation patterns.
///
/// This class provides static methods for navigation patterns that are
/// commonly used throughout the application.
class NavigationHelper {
  /// Private constructor to prevent instantiation.
  const NavigationHelper._();
  
  /// Gets the NavigationService instance from the service locator.
  static NavigationService get _navigationService => 
      getIt<NavigationService>();
  
  /// Navigates to a route and clears the navigation stack.
  ///
  /// This is useful for flows like logout or session expiration where
  /// you want to prevent the user from going back.
  ///
  /// [routeName] The name of the route to navigate to.
  /// [arguments] Optional arguments to pass to the route.
  static Future<T?> navigateAndClearStack<T>(
    String routeName, {
    Object? arguments,
  }) async {
    // First replace with the target route
    final result = await _navigationService.replaceTo<T>(
      routeName,
      arguments: arguments,
    );
    
    // Then clear any remaining history
    _navigationService.popUntil(routeName);
    
    return result;
  }
  
  /// Resets the navigation to the initial route.
  ///
  /// This is useful for resetting the app state or handling logout.
  static void resetToInitial() {
    _navigationService.reset();
  }
  
  /// Navigates to login screen when session expires.
  ///
  /// This is a specialized version of navigateAndClearStack for session expiration.
  static Future<void> handleSessionExpiration() async {
    // Show a message to the user
    // In a real implementation, this would show a dialog first
    await navigateAndClearStack(RouteConstants.login);
  }
  
  /// Navigates back to the home screen from any depth.
  ///
  /// This is useful for providing a consistent "home" button behavior.
  static void navigateToHome() {
    _navigationService.popUntil(RouteConstants.home);
  }
  
  /// Shows a confirmation dialog before performing navigation.
  ///
  /// This is useful for confirming potentially destructive actions.
  ///
  /// [context] The BuildContext of the current screen.
  /// [title] The title of the confirmation dialog.
  /// [message] The message to display in the dialog.
  /// [onConfirm] Callback to execute when the user confirms.
  static Future<void> confirmNavigation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      onConfirm();
    }
  }
  
  /// Navigates back if possible, or to home if at the root.
  ///
  /// This is useful for handling back button presses in a consistent way.
  ///
  /// [context] The BuildContext of the current screen.
  static void backOrHome(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      _navigationService.pop();
    } else {
      navigateToHome();
    }
  }
}
```

### 7. Creating Type-Safe Route Arguments

Let's also create a few helper classes for type-safe route arguments:

```dart
// File: lib/core/routing/route_arguments.dart

import 'package:flutter/material.dart';

/// Base class for type-safe route arguments.
///
/// Extending this class for each route with specific parameters makes
/// navigation more type-safe and self-documenting.
abstract class RouteArguments {}

/// Arguments for the employee profile route.
class EmployeeProfileArguments extends RouteArguments {
  /// The ID of the employee to display.
  final String employeeId;
  
  /// Whether to show the edit button.
  final bool showEditButton;
  
  /// Creates arguments for the employee profile route.
  EmployeeProfileArguments({
    required this.employeeId,
    this.showEditButton = true,
  });
}

/// Arguments for the leave request route.
class LeaveRequestArguments extends RouteArguments {
  /// The initial leave type to select.
  final String? initialLeaveType;
  
  /// The initial start date.
  final DateTime? startDate;
  
  /// The initial end date.
  final DateTime? endDate;
  
  /// Creates arguments for the leave request route.
  LeaveRequestArguments({
    this.initialLeaveType,
    this.startDate,
    this.endDate,
  });
}

/// Arguments for the attendance detail route.
class AttendanceDetailArguments extends RouteArguments {
  /// The ID of the attendance record to display.
  final String attendanceId;
  
  /// Whether to show the edit options.
  final bool allowEdit;
  
  /// Creates arguments for the attendance detail route.
  AttendanceDetailArguments({
    required this.attendanceId,
    this.allowEdit = false,
  });
}

/// Extension for extracting route arguments from NavigationService.
extension ArgumentExtractionExtension on NavigationService {
  /// Gets type-safe arguments for the employee profile route.
  ///
  /// [employeeId] The ID of the employee to display.
  /// [showEditButton] Whether to show the edit button.
  EmployeeProfileArguments employeeProfileArgs({
    required String employeeId,
    bool showEditButton = true,
  }) {
    return EmployeeProfileArguments(
      employeeId: employeeId,
      showEditButton: showEditButton,
    );
  }
  
  /// Gets type-safe arguments for the leave request route.
  ///
  /// [initialLeaveType] The initial leave type to select.
  /// [startDate] The initial start date.
  /// [endDate] The initial end date.
  LeaveRequestArguments leaveRequestArgs({
    String? initialLeaveType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LeaveRequestArguments(
      initialLeaveType: initialLeaveType,
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  /// Gets type-safe arguments for the attendance detail route.
  ///
  /// [attendanceId] The ID of the attendance record to display.
  /// [allowEdit] Whether to show the edit options.
  AttendanceDetailArguments attendanceDetailArgs({
    required String attendanceId,
    bool allowEdit = false,
  }) {
    return AttendanceDetailArguments(
      attendanceId: attendanceId,
      allowEdit: allowEdit,
    );
  }
}
```

### 8. Testing the Implementation

#### 8.1 Update the Placeholder Screens to Use the New Navigation APIs

Let's update one of the placeholder screens to use our new navigation extensions:

```dart
// File: lib/core/presentation/placeholders/core/home_placeholder_screen.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/context_extensions.dart';
import 'package:hr_connect/core/routing/navigation_helpers.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the home/dashboard screen.
class HomePlaceholderScreen extends StatelessWidget {
  /// Creates a new home placeholder screen.
  const HomePlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Home Dashboard',
      headerColor: Colors.purple,
      description: 'This is a placeholder for the main dashboard. '
          'In the actual implementation, this screen would show summary data '
          'and navigation to different features.',
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          _buildFeatureTile(
            context,
            'Attendance',
            Icons.qr_code_scanner,
            Colors.orange,
            () => context.navigateTo(RouteConstants.qrScanner),
          ),
          _buildFeatureTile(
            context,
            'Time Management',
            Icons.calendar_today,
            Colors.blue,
            () => context.navigateTo(RouteConstants.leaveRequest),
          ),
          _buildFeatureTile(
            context,
            'Employee Profile',
            Icons.person,
            Colors.green,
            () => context.navigateTo(RouteConstants.employeeProfile),
          ),
          _buildFeatureTile(
            context,
            'Admin Portal',
            Icons.admin_panel_settings,
            Colors.red,
            () => context.navigateTo(RouteConstants.adminDashboard),
          ),
        ],
      ),
      navigationButtons: [
        // Using the enhanced PlaceholderNavButton
        EnhancedPlaceholderNavButton(
          label: 'QR Scanner',
          onTap: (context) => context.navigationService.toQrScanner(),
        ),
        EnhancedPlaceholderNavButton(
          label: 'Attendance History',
          onTap: (context) => context.navigationService.toAttendanceHistory(),
        ),
        EnhancedPlaceholderNavButton(
          label: 'Leave Request',
          onTap: (context) => context.navigationService.toLeaveRequest(),
        ),
        EnhancedPlaceholderNavButton(
          label: 'Employee Profile',
          onTap: (context) => context.navigationService.toEmployeeProfile(),
        ),
        EnhancedPlaceholderNavButton(
          label: 'Admin Dashboard',
          onTap: (context) => context.navigationService.toAdminDashboard(),
        ),
        EnhancedPlaceholderNavButton(
          label: 'Logout',
          onTap: (context) => NavigationHelper.confirmNavigation(
            context: context,
            title: 'Confirm Logout',
            message: 'Are you sure you want to logout?',
            onConfirm: () => context.navigationService.logout(),
          ),
        ),
      ],
    );
  }
  
  /// Builds a feature tile for the dashboard grid.
  Widget _buildFeatureTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An enhanced version of PlaceholderNavButton that uses the BuildContext extension.
class EnhancedPlaceholderNavButton extends StatelessWidget {
  /// The label to display on the button.
  final String label;
  
  /// The callback to execute when the button is tapped.
  final void Function(BuildContext) onTap;
  
  /// Creates a new enhanced navigation button.
  const EnhancedPlaceholderNavButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(context),
      child: Text(label),
    );
  }
}
```

#### 8.2 Create Unit Tests

Create unit tests for the navigation extensions:

```dart
// File: test/core/routing/navigation_extensions_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/navigation_extensions.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:mockito/mockito.dart';

class MockAppRouter extends Mock implements AppRouter {}

void main() {
  late MockAppRouter mockRouter;
  late NavigationService navigationService;
  
  setUp(() {
    mockRouter = MockAppRouter();
    navigationService = NavigationService(mockRouter);
    
    // Set up default behaviors
    when(mockRouter.navigateTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
    when(mockRouter.replaceTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
  });
  
  group('NavigationServiceExtensions', () {
    test('toHome should navigate to home route', () async {
      // Act
      await navigationService.toHome();
      
      // Assert
      verify(mockRouter.navigateTo(RouteConstants.home)).called(1);
    });
    
    test('toQrScanner should navigate to QR scanner route', () async {
      // Act
      await navigationService.toQrScanner();
      
      // Assert
      verify(mockRouter.navigateTo(RouteConstants.qrScanner)).called(1);
    });
    
    test('toEmployeeProfile with ID should pass ID as argument', () async {
      // Arrange
      const employeeId = 'emp123';
      
      // Act
      await navigationService.toEmployeeProfile(employeeId: employeeId);
      
      // Assert
      verify(mockRouter.navigateTo(
        RouteConstants.employeeProfile,
        arguments: employeeId,
      )).called(1);
    });
    
    test('logout should replace with login route', () async {
      // Act
      await navigationService.logout();
      
      // Assert
      verify(mockRouter.replaceTo(RouteConstants.login)).called(1);
    });
  });
  
  group('NavigationWithResultsExtension', () {
    test('toLeaveRequestForResult should return result from navigation', () async {
      // Arrange
      const expectedResult = 'request123';
      when(mockRouter.navigateTo<String>(RouteConstants.leaveRequest))
          .thenAnswer((_) async => expectedResult);
      
      // Act
      final result = await navigationService.toLeaveRequestForResult();
      
      // Assert
      expect(result, equals(expectedResult));
      verify(mockRouter.navigateTo<String>(RouteConstants.leaveRequest)).called(1);
    });
  });
}
```

### 9. Usage Examples

#### 9.1 Using BuildContext Extensions in Widgets

```dart
class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Use context extension to navigate
        context.navigateTo(RouteConstants.qrScanner);
      },
      child: const Text('Scan QR Code'),
    );
  }
}
```

#### 9.2 Using NavigationService Extensions in Service Classes

```dart
class AttendanceService {
  final NavigationService _navigationService;
  
  AttendanceService(this._navigationService);
  
  Future<void> startAttendanceFlow() async {
    // Use type-safe extension method
    await _navigationService.toQrScanner();
  }
  
  Future<void> viewAttendanceHistory() async {
    // Use type-safe extension method
    await _navigationService.toAttendanceHistory();
  }
}
```

#### 9.3 Using Navigation Helpers for Complex Navigation

```dart
class AuthenticationService {
  Future<void> handleLogout(BuildContext context) async {
    // Use navigation helper for confirmation and complex flow
    NavigationHelper.confirmNavigation(
      context: context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to logout?',
      onConfirm: () {
        // Clear credentials and navigate to login
        // clearCredentials();
        NavigationHelper.navigateAndClearStack(RouteConstants.login);
      },
    );
  }
  
  void handleSessionExpiration() {
    // Use specialized helper for this specific use case
    NavigationHelper.handleSessionExpiration();
  }
}
```

#### 9.4 Using Type-Safe Route Arguments

```dart
class EmployeeListItem extends StatelessWidget {
  final String employeeId;
  final String name;
  
  const EmployeeListItem({
    required this.employeeId,
    required this.name,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        // Get navigationService from context
        final navigationService = context.navigationService;
        
        // Create type-safe arguments
        final args = navigationService.employeeProfileArgs(
          employeeId: employeeId,
          showEditButton: false,
        );
        
        // Navigate with type-safe arguments
        navigationService.navigateTo(
          RouteConstants.employeeProfile,
          arguments: args,
        );
      },
    );
  }
}
```

### 10. Best Practices

#### 10.1 Navigation in MVSA Architecture

In the Modified Vertical Slice Architecture (MVSA):

1. **Presentation Layer**: Use BuildContext extensions for direct navigation from widgets.
2. **Domain Layer**: Use NavigationService for navigation from use cases or services.
3. **Data Layer**: Avoid direct navigation, pass events to the domain layer instead.

#### 10.2 Organizing Navigation Extensions

1. **Core vs. Feature-Specific**: Keep core navigation extensions separate from feature-specific ones.
2. **Naming Conventions**: Use a consistent prefix like `to[ScreenName]` for navigation methods.
3. **Parameter Types**: Use strongly typed parameters whenever possible.
4. **Documentation**: Document all navigation methods clearly, especially parameters.

#### 10.3 Error Handling

Always handle potential navigation errors:

```dart
try {
  await context.navigationService.toQrScanner();
} catch (e) {
  // Handle navigation error
  print('Navigation failed: $e');
  // Show error message to user
}
```

### 11. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-004-05**: Test routing by navigating between the home screen and a test screen

This next task will involve comprehensive testing of the routing system, including the navigation helpers and extension methods implemented in this task.

### 12. Conclusion

You have now implemented navigation helpers and extension methods for the HR Connect application. These enhancements provide:

- Type-safe navigation throughout the application
- Context extensions for easy access to navigation from any widget
- Helper methods for common navigation patterns
- Type-safe route arguments for better data passing

This implementation follows the HR Connect architecture principles and provides a clean, intuitive API for navigation. By using these extensions and helpers, developers can navigate between screens more easily and with fewer errors, improving the overall quality and maintainability of the codebase.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the application, particularly regarding proper typing, documentation, and architecture principles.
