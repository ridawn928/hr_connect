import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize with development configuration
  final config = EnvironmentConfig.development();
  await setupServiceLocator(config: config);
  
  // Log application start
  final logger = getIt<LoggingService>();
  logger.info('Application started');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Connect Logger Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoggingTestScreen(),
    );
  }
}

class LoggingTestScreen extends StatelessWidget {
  const LoggingTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggingService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap the buttons to test the logger:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                logger.debug('This is a debug message');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debug log sent - check console')),
                );
              },
              child: const Text('Debug Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.info('This is an info message');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Info log sent - check console')),
                );
              },
              child: const Text('Info Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.warning('This is a warning message');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Warning log sent - check console')),
                );
              },
              child: const Text('Warning Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.error('This is an error message');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error log sent - check console')),
                );
              },
              child: const Text('Error Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.critical('This is a critical message');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Critical log sent - check console')),
                );
              },
              child: const Text('Critical Log'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                try {
                  throw Exception('Test exception for error logging');
                } catch (e, stackTrace) {
                  logger.error('Exception caught', e, stackTrace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error with exception logged - check console')),
                  );
                }
              },
              child: const Text('Log Exception'),
            ),
          ],
        ),
      ),
    );
  }
} 