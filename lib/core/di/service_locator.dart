import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/environment_config.dart' as app_env;
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/app_router_impl.dart';
import 'package:hr_connect/core/routing/route_guards.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';

/// Global instance of GetIt to be used throughout the application.
///
/// This provides a centralized registry for all dependencies following
/// the service locator pattern. All features should register and obtain
/// their dependencies through this instance.
final GetIt getIt = GetIt.instance;

/// Initializes the service locator with all required dependencies.
///
/// [config] specifies the environment configuration to use.
/// This should be called during app initialization before any services
/// are accessed.
Future<void> setupServiceLocator({
  required app_env.EnvironmentConfig config,
}) async {
  // Register the environment configuration itself first
  getIt.registerSingleton<app_env.EnvironmentConfig>(config);

  // Determine injectable environment based on config
  final injectableEnv = _environmentToString(config.environment);

  // Initialize auto-generated dependencies with environment
  await configureDependencies(
    getIt,
    environment: injectableEnv,
  );
  
  // Register any additional services not covered by auto-registration
  await _registerAdditionalServices();
}

/// Registers additional services that aren't handled by Injectable.
Future<void> _registerAdditionalServices() async {
  // Register core services
  _registerCoreServices();
  
  // Register feature-specific services
  // These will be added as features are implemented
}

/// Registers core application services like routing and security
void _registerCoreServices() {
  // Register route guards
  getIt.registerLazySingleton<AuthGuard>(() => AuthGuard());
  getIt.registerLazySingleton<RoleGuard>(() => RoleGuard());
  
  // Register router and navigation service
  getIt.registerLazySingleton<NavigationService>(
    () => AppRouterImpl(
      authGuard: getIt<AuthGuard>(),
      roleGuard: getIt<RoleGuard>(),
    ),
  );
}

/// Converts Environment enum to injectable environment string.
String _environmentToString(app_env.Environment environment) {
  switch (environment) {
    case app_env.Environment.development:
      return Env.dev;
    case app_env.Environment.test:
      return Env.test;
    case app_env.Environment.staging:
      return Env.staging;
    case app_env.Environment.production:
      return Env.prod;
  }
} 