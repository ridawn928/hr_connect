import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/app_router_impl.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';

// Simple test implementation of AuthenticationGuard
class TestAuthGuard implements AuthenticationGuard {
  @override
  Future<bool> canNavigate(String routeName, Object? arguments) async {
    return true;
  }
  
  @override
  String? getFallbackRoute(String routeName, Object? arguments) {
    return RouteConstants.login;
  }
}

// Simple test implementation of AdminGuard
class TestAdminGuard implements AdminGuard {
  @override
  Future<bool> canNavigate(String routeName, Object? arguments) async {
    return true;
  }
  
  @override
  String? getFallbackRoute(String routeName, Object? arguments) {
    return RouteConstants.home;
  }
}

void main() {
  late AuthenticationGuard authGuard;
  late AdminGuard adminGuard;
  late AppRouter router;
  
  setUp(() {
    authGuard = TestAuthGuard();
    adminGuard = TestAdminGuard();
    
    router = AppRouterImpl(authGuard, adminGuard);
  });
  
  group('AppRouterImpl', () {
    test('should initialize with splash as the current route', () {
      expect(router.currentRoute, equals(RouteConstants.splash));
    });
    
    test('should have a valid router configuration', () {
      expect(router.config, isNotNull);
    });
    
    // Additional tests will be added when route definitions
    // are implemented in task 01-004-03
  });
} 