import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/config/config_service.dart';
import 'package:hr_connect/core/services/config/dev_config_service.dart';
import 'package:hr_connect/core/services/config/prod_config_service.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/logging/dev_logger_service.dart';
import 'package:hr_connect/core/services/logging/prod_logger_service.dart';
import 'package:mockito/mockito.dart';

// Create mock for the ConfigService
class MockConfigService extends Mock implements ConfigService {
  @override
  bool enableVerboseLogging = true;
  
  @override
  bool enableRemoteLogging = false;
  
  @override
  String get remoteLoggingUrl => 'https://test.example.com';
}

void main() {
  late MockConfigService mockConfig;
  
  setUp(() {
    mockConfig = MockConfigService();
  });
  
  group('DefaultLoggerService', () {
    late DefaultLoggerService logger;
    
    setUp(() {
      logger = DefaultLoggerService(mockConfig);
    });
    
    test('should log messages at the appropriate level', () {
      // This is a basic test to ensure the logger functions without errors
      // In a real test, you'd use a more sophisticated approach to capture output
      
      // Should not throw
      logger.debug('This is a debug message');
      logger.info('This is an info message');
      logger.warning('This is a warning message');
      logger.error('This is an error message');
      logger.critical('This is a critical message');
    });
    
    test('should respect verbose logging configuration', () {
      // Reconfigure mock for this test
      mockConfig.enableVerboseLogging = false;
      
      // Debug logs should be skipped when verbose logging is disabled
      logger.debug('This should be skipped');
      logger.info('This should still be logged');
      
      // No easy way to verify output capture in this simple test
      // In a full test suite, you would use a testing logger that captures output
    });
  });
  
  group('DI Registration', () {
    tearDown(() async {
      // Reset GetIt after each test
      await GetIt.instance.reset();
    });
    
    test('should register LoggingService as DevLoggerService in dev environment', () async {
      // Set up with dev environment
      final config = EnvironmentConfig.development();
      await setupServiceLocator(config: config);
      
      // Verify registration
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<DevLoggerService>());
      
      // Verify ConfigService is also registered correctly
      expect(getIt.isRegistered<ConfigService>(), true);
      expect(getIt<ConfigService>(), isA<DevConfigService>());
    });
    
    test('should register LoggingService as ProdLoggerService in prod environment', () async {
      // Set up with prod environment
      final config = EnvironmentConfig.production();
      await setupServiceLocator(config: config);
      
      // Verify registration
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<ProdLoggerService>());
      
      // Verify ConfigService is also registered correctly
      expect(getIt.isRegistered<ConfigService>(), true);
      expect(getIt<ConfigService>(), isA<ProdConfigService>());
    });
  });
} 