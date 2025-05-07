import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This will be auto-generated once we run the build_runner
import 'injection_config.config.dart';

/// Environment constants for conditional dependency registration.
abstract class Env {
  /// Development environment.
  static const dev = 'dev';

  /// Test environment.
  static const test = 'test';

  /// Staging environment.
  static const staging = 'staging';

  /// Production environment.
  static const prod = 'prod';
}

/// Initializes the GetIt dependency injection container using the
/// generated code from [build_runner].
///
/// Uses [environment] to conditionally register certain dependencies.
/// Returns the configured GetIt instance.
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<GetIt> configureDependencies(
  GetIt getIt, {
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
  return getIt.init(
    environment: environment,
    environmentFilter: environmentFilter,
  );
}

// Since we're not using Injectable's code generation at this point,
// we've simplified our approach to use a custom environment-based
// manual registration in the service_locator.dart file.
// 
// The EnvironmentFilter, @Environment annotations, and @InjectableInit
// annotations will be fully implemented in later tasks once we have
// a more stable dependency graph. 