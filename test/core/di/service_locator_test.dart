import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/di/service_locator_test_helper.dart';

void main() {
  setUp(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  tearDown(() async {
    await ServiceLocatorTestHelper.resetServiceLocator();
  });

  test('setupServiceLocator should register environment config', () async {
    // Arrange
    final config = EnvironmentConfig.test();

    // Act
    await setupServiceLocator(config: config);

    // Assert
    expect(getIt.isRegistered<EnvironmentConfig>(), true);
    expect(getIt<EnvironmentConfig>(), config);
  });
} 