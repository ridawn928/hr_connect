import 'dart:developer' as developer;

import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:flutter/foundation.dart';

/// Handles global application errors.
///
/// This class provides centralized error handling for the entire application,
/// ensuring consistent error logging and reporting.
class ErrorHandler {
  /// Private constructor to prevent instantiation.
  const ErrorHandler._();
  
  /// Reports an error to logging and crash reporting services.
  ///
  /// This method logs the error with appropriate context and can be
  /// extended to integrate with crash reporting services like Firebase
  /// Crashlytics or Sentry.
  /// 
  /// [error] The error object.
  /// [stackTrace] The stack trace of the error.
  /// [context] Optional context information for the error.
  static Future<void> reportError(
    Object error,
    StackTrace stackTrace, {
    String? context,
  }) async {
    try {
      // Log to console in debug mode
      developer.log(
        'ERROR: ${error.toString()}',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
      
      // Log to logging service
      final loggingService = ServiceLocator.get<LoggingService>();
      await loggingService.logError(
        error: error,
        stackTrace: stackTrace,
        context: context,
      );
      
      // Additional error reporting services could be integrated here:
      // - Firebase Crashlytics
      // - Sentry
      // - App Center
    } catch (e, s) {
      // Fallback if error reporting itself fails
      developer.log(
        'Error reporting failed: ${e.toString()}',
        name: 'ErrorHandler',
        error: e,
        stackTrace: s,
      );
    }
  }
  
  /// Configures the global Flutter error handlers to use [reportError].
  ///
  /// This should be called during application initialization to ensure
  /// that all unhandled errors are properly reported.
  static void configureErrorHandling() {
    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      reportError(
        details.exception,
        details.stack ?? StackTrace.current,
        context: 'Flutter framework error',
      );
    };
    
    // Set up Dart error handling for errors outside Flutter
    // (like isolates or futures outside Flutter's zone)
    Error.stackTraceProcessor = (StackTrace stackTrace) {
      return stackTrace;
    };
  }

  /// Handles errors during service initialization.
  /// 
  /// This method provides specialized error handling during the
  /// initialization phase, which may have different requirements.
  /// 
  /// [error] The error object.
  /// [stackTrace] The stack trace of the error.
  /// [service] The name of the service that failed to initialize.
  static void handleInitializationError(
    Object error, 
    StackTrace stackTrace, 
    String service
  ) {
    developer.log(
      'Initialization error in $service',
      error: error,
      stackTrace: stackTrace,
      name: 'hr_connect.init',
    );
    
    // Depending on the service, we might want to take different actions
    // For example, retry initialization or use a fallback service
  }
} 