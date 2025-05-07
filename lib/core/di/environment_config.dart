/// Defines the environment in which the application is running.
enum Environment {
  /// Development environment for local testing.
  development,

  /// Testing environment for automated tests.
  test,

  /// Staging environment for pre-production testing.
  staging,

  /// Production environment for released app.
  production,
}

/// Configuration class for environment-specific settings.
///
/// This class is used to configure services based on the current
/// environment (development, test, staging, production).
class EnvironmentConfig {
  /// The current environment.
  final Environment environment;

  /// Whether to enable detailed logging.
  final bool enableVerboseLogging;

  /// Base URL for API endpoints.
  final String apiBaseUrl;

  /// Whether to use mock services instead of real implementations.
  final bool useMockServices;

  /// Creates a new environment configuration.
  const EnvironmentConfig({
    required this.environment,
    required this.enableVerboseLogging,
    required this.apiBaseUrl,
    required this.useMockServices,
  });

  /// Creates a development environment configuration.
  factory EnvironmentConfig.development() {
    return const EnvironmentConfig(
      environment: Environment.development,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://dev-api.hrconnect.example.com',
      useMockServices: false,
    );
  }

  /// Creates a test environment configuration.
  factory EnvironmentConfig.test() {
    return const EnvironmentConfig(
      environment: Environment.test,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://test-api.hrconnect.example.com',
      useMockServices: true,
    );
  }

  /// Creates a staging environment configuration.
  factory EnvironmentConfig.staging() {
    return const EnvironmentConfig(
      environment: Environment.staging,
      enableVerboseLogging: true,
      apiBaseUrl: 'https://staging-api.hrconnect.example.com',
      useMockServices: false,
    );
  }

  /// Creates a production environment configuration.
  factory EnvironmentConfig.production() {
    return const EnvironmentConfig(
      environment: Environment.production,
      enableVerboseLogging: false,
      apiBaseUrl: 'https://api.hrconnect.example.com',
      useMockServices: false,
    );
  }
} 