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