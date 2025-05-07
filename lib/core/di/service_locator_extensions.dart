import 'package:get_it/get_it.dart';

/// Extension methods for GetIt to provide more readable registration syntax.
extension GetItExtensions on GetIt {
  /// Registers a singleton instance that is created on first access.
  ///
  /// Use this for services that are expensive to create but aren't
  /// needed right at startup. The instance will be created once and
  /// reused for all subsequent requests.
  void registerLazySingletonService<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  /// Registers a factory function that creates a new instance each time.
  ///
  /// Use this for services where a new instance is needed on each request,
  /// such as use cases or transient operations.
  void registerFactoryService<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    registerFactory<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  /// Registers an already-created singleton instance.
  ///
  /// Use this for services that are already instantiated or when
  /// manual control over the instance creation is required.
  void registerSingletonService<T extends Object>(
    T instance, {
    String? instanceName,
    void Function(T)? disposingFunction,
  }) {
    registerSingleton<T>(
      instance,
      instanceName: instanceName,
      dispose: disposingFunction,
    );
  }
} 