import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/presentation/test/routing_test_screen.dart';

/// Implementation of [AppRouter] using go_router.
///
/// This class is responsible for configuring the router and handling
/// navigation throughout the application.
@Singleton(as: AppRouter)
class AppRouterImpl implements AppRouter, NavigationService {
  /// The authentication guard for protected routes.
  final AuthenticationGuard _authGuard;
  
  /// The admin guard for admin-only routes.
  final AdminGuard _adminGuard;
  
  /// The GoRouter instance that powers this implementation.
  late final GoRouter _router;
  
  /// The current route name.
  String _currentRoute = RouteConstants.splash;
  
  /// Creates a new AppRouter implementation.
  ///
  /// Requires [AuthenticationGuard] and [AdminGuard] instances.
  AppRouterImpl(this._authGuard, this._adminGuard) {
    _initializeRouter();
  }
  
  /// Initializes the GoRouter instance.
  void _initializeRouter() {
    _router = GoRouter(
      initialLocation: RouteConstants.splash,
      debugLogDiagnostics: true, // Set to false in production
      redirect: _handleRedirect,
      routes: _buildRoutes(),
      errorBuilder: _handleError,
      refreshListenable: _getAuthChangeNotifier(), // Will be implemented later
      observers: [_getNavigationObserver()], // For analytics
    );
  }
  
  /// Handles redirects for authentication and permissions.
  ///
  /// This method checks if the user is allowed to access the requested route
  /// and redirects to appropriate screens if not.
  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Update current route for tracking
    _currentRoute = state.matchedLocation;
    
    // Check authentication for protected routes
    // This is a simplified implementation - will be expanded later
    final requiresAuth = _routeRequiresAuth(state.matchedLocation);
    if (requiresAuth) {
      final canNavigate = await _authGuard.canNavigate(
        state.matchedLocation,
        state.extra,
      );
      
      if (!canNavigate) {
        return _authGuard.getFallbackRoute(state.matchedLocation, state.extra);
      }
    }
    
    // Check admin permissions for admin routes
    final requiresAdmin = _routeRequiresAdmin(state.matchedLocation);
    if (requiresAdmin) {
      final canNavigate = await _adminGuard.canNavigate(
        state.matchedLocation,
        state.extra,
      );
      
      if (!canNavigate) {
        return _adminGuard.getFallbackRoute(state.matchedLocation, state.extra);
      }
    }
    
    // No redirection needed
    return null;
  }
  
  /// Builds the route configuration.
  ///
  /// This is a placeholder for the actual route configuration that will be
  /// implemented in task 01-004-03. For now, we'll just define a minimal
  /// configuration to make the router work.
  List<RouteBase> _buildRoutes() {
    // This will be expanded in task 01-004-03 with actual routes
    return [
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const SizedBox(), // Placeholder
      ),
      GoRoute(
        path: RouteConstants.routingTest,
        name: 'routingTest',
        builder: (context, state) {
          // Extract parameters from state
          final Map<String, dynamic> params = state.extra as Map<String, dynamic>? ?? {};
          final String? testParam = params['testParam'] as String?;
          final int? count = params['count'] as int?;
          
          // Return the routing test screen with parameters
          return RoutingTestScreen(
            testParam: testParam,
            count: count,
          );
        },
      ),
    ];
  }
  
  /// Handles routing errors.
  ///
  /// This method is called when a route is not found or when there's
  /// an error during navigation.
  Widget _handleError(BuildContext context, GoRouterState state) {
    // Placeholder for error screen - will be implemented later
    return const Scaffold(
      body: Center(
        child: Text('Route not found'),
      ),
    );
  }
  
  /// Creates a notifier for authentication state changes.
  ///
  /// This is a placeholder that will be replaced when authentication
  /// is implemented. The notifier is used to refresh the router when
  /// the user's authentication state changes.
  ChangeNotifier _getAuthChangeNotifier() {
    // This will be replaced with a real auth change notifier later
    return _DummyChangeNotifier();
  }
  
  /// Creates a navigation observer for analytics.
  ///
  /// This is a placeholder that will be replaced when analytics
  /// is implemented.
  NavigatorObserver _getNavigationObserver() {
    // This will be replaced with a real observer later
    return NavigatorObserver();
  }
  
  /// Checks if a route requires authentication.
  ///
  /// This is a simplified implementation that will be expanded later.
  bool _routeRequiresAuth(String route) {
    // For now, only login and splash don't require auth
    return route != RouteConstants.login && route != RouteConstants.splash;
  }
  
  /// Checks if a route requires admin permissions.
  ///
  /// This is a simplified implementation that will be expanded later.
  bool _routeRequiresAdmin(String route) {
    // Check if the route is an admin route
    return route.startsWith('/admin');
  }
  
  // Implementation of AppRouter interface
  
  @override
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) async {
    if (!_router.canPop() && routeName == _currentRoute) {
      // Already on this route and can't pop, do nothing
      return null;
    }
    
    return _router.pushNamed<T>(
      routeName,
      extra: arguments,
    );
  }
  
  @override
  Future<T?> replaceTo<T>(String routeName, {Object? arguments}) async {
    return _router.replaceNamed<T>(
      routeName,
      extra: arguments,
    );
  }
  
  @override
  void pop<T>([T? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    }
  }
  
  @override
  void popUntil(String routeName) {
    while (_router.canPop() && _currentRoute != routeName) {
      _router.pop();
    }
  }
  
  @override
  String get currentRoute => _currentRoute;
  
  @override
  void reset() {
    _router.go(RouteConstants.splash);
  }
  
  @override
  RouterConfig<Object> get config => _router;
  
  late final AppRouter _appRouter;
  
  /// Creates a new AppRouterImpl.
  ///
  /// This will initialize the Go Router with the required guards.
  AppRouterImpl({
    required AuthGuard authGuard,
    required RoleGuard roleGuard,
  }) {
    _appRouter = AppRouter(
      authGuard: authGuard,
      roleGuard: roleGuard,
    );
  }
  
  @override
  void navigateTo(String routeName, {Map<String, dynamic>? params, Object? extra}) {
    final context = NavigationKeys.rootNavigator.currentContext;
    if (context == null) {
      debugPrint('Navigation error: No valid context for navigation');
      return;
    }
    
    // Use named navigation with go_router
    _appRouter.router.goNamed(
      routeName,
      pathParameters: params ?? {},
      extra: extra,
    );
  }
  
  @override
  void pop<T>([T? result]) {
    final context = NavigationKeys.rootNavigator.currentContext;
    if (context == null) {
      debugPrint('Navigation error: No valid context for pop');
      return;
    }
    
    // Use the router's pop method
    _appRouter.router.pop(result);
  }
  
  @override
  void navigateBack() {
    final context = NavigationKeys.rootNavigator.currentContext;
    if (context == null) {
      debugPrint('Navigation error: No valid context for navigation back');
      return;
    }
    
    // Navigate back
    if (_appRouter.router.canPop()) {
      _appRouter.router.pop();
    }
  }
  
  @override
  Future<T?> navigateWithResult<T>(String routeName, {Map<String, dynamic>? params, Object? extra}) async {
    final context = NavigationKeys.rootNavigator.currentContext;
    if (context == null) {
      debugPrint('Navigation error: No valid context for navigation with result');
      return null;
    }
    
    // Use go_router for navigation with result
    return await _appRouter.router.pushNamed<T>(
      routeName,
      pathParameters: params ?? {},
      extra: extra,
    );
  }
  
  @override
  void replaceWith(String routeName, {Map<String, dynamic>? params, Object? extra}) {
    final context = NavigationKeys.rootNavigator.currentContext;
    if (context == null) {
      debugPrint('Navigation error: No valid context for replace navigation');
      return;
    }
    
    // Use go_router's replace navigation
    _appRouter.router.goNamed(
      routeName,
      pathParameters: params ?? {},
      extra: extra,
    );
  }
}

/// Temporary change notifier for authentication state.
///
/// This is a placeholder that will be replaced when authentication
/// is implemented.
class _DummyChangeNotifier extends ChangeNotifier {} 