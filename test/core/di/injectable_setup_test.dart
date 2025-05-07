import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/di/service_locator_test_helper.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/dev_logger_service.dart';
import 'package:hr_connect/core/services/logging/prod_logger_service.dart';

void main() {
  setUp(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  tearDown(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  group('Dependency Injection Setup', () {
    test('should register the correct LoggingService implementation for dev', () async {
      // Arrange
      final config = EnvironmentConfig.development();

      // Act
      await setupServiceLocator(config: config);

      // Assert
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<DevLoggerService>());
    });

    test('should register the correct LoggingService implementation for prod', () async {
      // Arrange
      final config = EnvironmentConfig.production();

      // Act
      await setupServiceLocator(config: config);

      // Assert
      expect(getIt.isRegistered<LoggingService>(), true);
      expect(getIt<LoggingService>(), isA<ProdLoggerService>());
    });
  });
} 