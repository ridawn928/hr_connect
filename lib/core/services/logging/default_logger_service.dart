import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Default implementation of the [LoggingService] interface.
///
/// This implementation logs messages to the console with formatting
/// based on the log level. It can be configured to provide more or
/// less verbose output.
/// 
/// This class is not registered directly with the DI container
/// as it serves as a base implementation for environment-specific loggers.
class DefaultLoggerService implements LoggingService {
  /// Configuration for the logging service.
  final ConfigService _config;
  
  /// Creates a new default logger service.
  ///
  /// Requires a [ConfigService] to determine logging behavior.
  DefaultLoggerService(this._config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = getLevelPrefix(level);
    
    // Basic console output - in a real app, this would be more sophisticated
    print('$timestamp $prefix: $message');
    
    if (error != null) {
      print('$timestamp $prefix ERROR: $error');
      
      if (stackTrace != null && _config.enableVerboseLogging) {
        print('$timestamp $prefix STACK TRACE: $stackTrace');
      }
    }
    
    // In a real app, we'd implement remote logging here if enabled
    if (_config.enableRemoteLogging) {
      logToRemoteServer(level, message, error, stackTrace);
    }
  }
  
  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    // Skip debug logs unless verbose logging is enabled
    if (_config.enableVerboseLogging) {
      log(LogLevel.debug, message, error, stackTrace);
    }
  }
  
  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.info, message, error, stackTrace);
  }
  
  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.warning, message, error, stackTrace);
  }
  
  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.error, message, error, stackTrace);
  }
  
  @override
  void critical(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogLevel.critical, message, error, stackTrace);
  }
  
  /// Gets a prefix string for the given log level.
  String getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }
  
  /// Simulates logging to a remote server.
  /// 
  /// In a real application, this would send the log data to a remote
  /// logging service.
  void logToRemoteServer(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // This is just a placeholder - in a real app, implement actual remote logging
    if (_config.enableVerboseLogging) {
      print('REMOTE LOG: Would send to ${_config.remoteLoggingUrl}');
    }
  }
} 