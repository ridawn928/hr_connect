import 'package:get_it/get_it.dart';

/// Helper class for resetting the service locator during tests.
///
/// This provides utilities to reset GetIt between tests and register
/// mock implementations for services.
class ServiceLocatorTestHelper {
  /// Resets the entire GetIt instance.
  ///
  /// Call this in the setUp or tearDown of your tests to ensure
  /// a clean state between test runs.
  static Future<void> resetServiceLocator() async {
    final GetIt getIt = GetIt.instance;
    await getIt.reset();
  }

  /// Registers a mock implementation for a service.
  ///
  /// Example:
  /// ```dart
  /// final mockAuthService = MockAuthService();
  /// ServiceLocatorTestHelper.registerMockService<AuthService>(mockAuthService);
  /// ```
  static void registerMockService<T extends Object>(T mockImplementation) {
    final GetIt getIt = GetIt.instance;

    // Check if already registered and unregister if needed
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }

    getIt.registerSingleton<T>(mockImplementation);
  }
} 