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
  
  // Test routes
  /// Route to the routing test screen
  static const String routingTest = '/test/routing';
} 