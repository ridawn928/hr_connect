// File: lib/core/routing/navigation_extensions.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_arguments.dart';

/// Extension methods for [NavigationService] to provide type-safe
/// navigation to specific screens.
///
/// This simplifies navigation calls and provides better type safety by
/// defining methods for each destination instead of using strings.
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
    return showDatePicker(
      context: _getCurrentContext()!,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
  }
  
  /// Gets the current context from the navigation key.
  ///
  /// Returns null if no context is available.
  BuildContext? _getCurrentContext() {
    // This would need a global navigation key in a real implementation
    // For now, it's a placeholder
    return null;
  }
}

/// Extension methods for test screen navigation.
extension TestNavigationExtension on NavigationService {
  /// Navigates to the routing test screen.
  ///
  /// [testParam] Optional test parameter to pass to the screen.
  /// [count] Optional count parameter for testing recursive navigation.
  Future<void> toRoutingTest({String? testParam, int? count}) {
    final Map<String, dynamic> args = {};
    if (testParam != null) args['testParam'] = testParam;
    if (count != null) args['count'] = count;
    
    return navigateTo(
      RouteConstants.routingTest,
      arguments: args.isNotEmpty ? args : null,
    );
  }
  
  /// Navigates to the routing test screen and waits for a result.
  ///
  /// Returns the result string returned from the test screen.
  Future<String?> toRoutingTestForResult({String? testParam}) async {
    return navigateTo<String>(
      RouteConstants.routingTest,
      arguments: testParam != null ? {'testParam': testParam} : null,
    );
  }
}

// Note: These extensions will be expanded as more screens are added to the application.
// The actual parameter types will be updated based on the requirements of each screen. 