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
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
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