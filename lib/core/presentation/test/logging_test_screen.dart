import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';

/// A test screen to demonstrate the logging service in action.
class LoggingTestScreen extends StatelessWidget {
  /// Creates a new logging test screen.
  const LoggingTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the logging service from the service locator
    final logger = getIt<LoggingService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging Service Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logging Service Type:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              logger.runtimeType.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => logger.debug('Debug message from UI'),
              child: const Text('Log Debug'),
            ),
            ElevatedButton(
              onPressed: () => logger.info('Info message from UI'),
              child: const Text('Log Info'),
            ),
            ElevatedButton(
              onPressed: () => logger.warning('Warning message from UI'),
              child: const Text('Log Warning'),
            ),
            ElevatedButton(
              onPressed: () => logger.error('Error message from UI'),
              child: const Text('Log Error'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  // Intentionally throw an error
                  throw Exception('Test exception');
                } catch (e, stackTrace) {
                  logger.critical(
                    'Critical error from UI',
                    e,
                    stackTrace,
                  );
                }
              },
              child: const Text('Log Critical with Exception'),
            ),
          ],
        ),
      ),
    );
  }
} 