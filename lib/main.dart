import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/error/error_handler.dart';

/// Application entry point.
///
/// This function initializes all necessary components before starting
/// the application, including Flutter bindings, dependency injection,
/// environment configuration, and error handling.
Future<void> main() async {
  // Catch any errors that occur during initialization
  await runZonedGuarded(() async {
    // Log start of initialization
    developer.log(
      'Starting application initialization',
      name: 'hr_connect.main',
    );
    
    // Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();
    developer.log(
      'Flutter bindings initialized',
      name: 'hr_connect.main',
    );
    
    // Configure global error handling
    ErrorHandler.configureErrorHandling();
    developer.log(
      'Error handling configured',
      name: 'hr_connect.main',
    );
    
    // Set preferred orientations (portrait only)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set up the system UI
    await _setupSystemUI();
    developer.log(
      'System UI configured',
      name: 'hr_connect.main',
    );
    
    // Set up the environment
    final config = _getCurrentEnvironment();
    developer.log(
      'Environment configured: ${config.environment}',
      name: 'hr_connect.main',
    );
    
    // Setup service locator
    await setupServiceLocator(config: config);
    developer.log(
      'Service locator initialized',
      name: 'hr_connect.main',
    );
    
    // Get the logging service and log app start
    final logger = getIt<LoggingService>();
    logger.info('Starting HR Connect application');
    
    // Run the application
    developer.log(
      'Launching application',
      name: 'hr_connect.main',
    );
    runApp(
      // Wrap the app with ProviderScope for Riverpod state management
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    // Global error handler for uncaught exceptions
    ErrorHandler.reportError(error, stackTrace);
  });
}

/// Sets up the system UI appearance.
///
/// Configures the status bar and navigation bar appearance
/// for a consistent look across the application.
Future<void> _setupSystemUI() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  await SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

/// Determines the current environment to use.
///
/// In a real application, this might be determined by build flags,
/// environment variables, or other configuration mechanisms.
EnvironmentConfig _getCurrentEnvironment() {
  // For a real application, this could be based on build flags:
  const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );
  
  switch (environment) {
    case 'prod':
      return EnvironmentConfig.production();
    case 'staging':
      return EnvironmentConfig.staging();
    case 'test':
      return EnvironmentConfig.test();
    case 'dev':
    default:
      return EnvironmentConfig.development();
  }
}
