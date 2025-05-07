// File: lib/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/presentation/placeholders/admin/admin_dashboard_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/attendance/attendance_history_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/attendance/qr_scanner_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/core/home_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/core/login_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/core/splash_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/employee/employee_profile_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/time_management/leave_request_placeholder_screen.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';

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

/// Router configuration for the application.
///
/// This class encapsulates the GoRouter configuration for the app,
/// defining all routes and navigation handling.
class AppRouter {
  final AuthGuard _authGuard;
  final RoleGuard _roleGuard;

  /// Creates a new AppRouter with the required guards for route protection.
  AppRouter({
    required AuthGuard authGuard,
    required RoleGuard roleGuard,
  })  : _authGuard = authGuard,
        _roleGuard = roleGuard;

  /// The configured GoRouter instance to use for routing.
  late final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: true,
    navigatorKey: NavigationKeys.rootNavigator,
    routes: _buildRoutes(),
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error 404',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page ${state.uri.path} was not found.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go(RouteConstants.home),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    },
    redirect: _guardRoutes,
  );

  /// Builds the application routes.
  List<RouteBase> _buildRoutes() {
    return [
      // Core routes
      GoRoute(
        path: RouteConstants.splash,
        name: RouteConstants.splash,
        builder: (context, state) => const SplashPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: RouteConstants.login,
        builder: (context, state) => const LoginPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        name: RouteConstants.home,
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
      
      // Attendance routes
      GoRoute(
        path: RouteConstants.qrScanner,
        name: RouteConstants.qrScanner,
        builder: (context, state) => const QrScannerPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.attendanceHistory,
        name: RouteConstants.attendanceHistory,
        builder: (context, state) => const AttendanceHistoryPlaceholderScreen(),
      ),
      
      // Time management routes
      GoRoute(
        path: RouteConstants.leaveRequest,
        name: RouteConstants.leaveRequest,
        builder: (context, state) => const LeaveRequestPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.leaveHistory,
        name: RouteConstants.leaveHistory,
        builder: (context, state) {
          // TODO: Implement leave history placeholder
          return Scaffold(
            appBar: AppBar(title: const Text('Leave History')),
            body: const Center(child: Text('Leave History Placeholder')),
          );
        },
      ),
      
      // Employee routes
      GoRoute(
        path: RouteConstants.employeeProfile,
        name: RouteConstants.employeeProfile,
        builder: (context, state) => const EmployeeProfilePlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        name: RouteConstants.editProfile,
        builder: (context, state) {
          // TODO: Implement edit profile placeholder
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Profile')),
            body: const Center(child: Text('Edit Profile Placeholder')),
          );
        },
      ),
      
      // Admin routes
      GoRoute(
        path: RouteConstants.adminDashboard,
        name: RouteConstants.adminDashboard,
        builder: (context, state) => const AdminDashboardPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.generateQr,
        name: RouteConstants.generateQr,
        builder: (context, state) {
          // TODO: Implement QR generation placeholder
          return Scaffold(
            appBar: AppBar(title: const Text('Generate QR')),
            body: const Center(child: Text('QR Generation Placeholder')),
          );
        },
      ),
      
      // Add more routes as needed for other placeholders
    ];
  }

  /// Applies route guards to redirect users if needed.
  String? _guardRoutes(BuildContext context, GoRouterState state) {
    // Public routes that don't require authentication
    final publicRoutes = [
      RouteConstants.splash,
      RouteConstants.login,
    ];
    
    // Admin-only routes
    final adminRoutes = [
      RouteConstants.adminDashboard,
      RouteConstants.generateQr,
    ];
    
    // Check if the route is public
    final isPublicRoute = publicRoutes.contains(state.matchedLocation);
    
    // If not authenticated and route requires authentication, redirect to login
    if (!_authGuard.isAuthenticated && !isPublicRoute) {
      return RouteConstants.login;
    }
    
    // If trying to access admin routes without admin role, redirect to home
    if (adminRoutes.contains(state.matchedLocation) && 
        !_roleGuard.hasRequiredRole(Role.admin)) {
      return RouteConstants.home;
    }
    
    // If authenticated but trying to access login or splash, redirect to home
    if (_authGuard.isAuthenticated && isPublicRoute) {
      return RouteConstants.home;
    }
    
    // No redirection needed
    return null;
  }
}

// Note: This is a placeholder that will be replaced with actual implementation
// in task 01-004-02. The implementation will likely use go_router
// and will be registered with the DI system. 