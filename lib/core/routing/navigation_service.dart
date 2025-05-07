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