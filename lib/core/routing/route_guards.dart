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