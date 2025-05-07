/// Severity levels for log messages.
enum LogLevel {
  /// Debug-level message (lowest severity)
  debug,
  
  /// Informational message
  info,
  
  /// Warning message
  warning,
  
  /// Error message
  error,
  
  /// Critical error message (highest severity)
  critical,
}

/// Abstract interface for logging services in the application.
///
/// This service provides unified logging capabilities across the app,
/// with support for different log levels and formatting options.
abstract class LoggingService {
  /// Logs a message with the specified level.
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a debug message.
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs an informational message.
  void info(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a warning message.
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs an error message.
  void error(String message, [Object? error, StackTrace? stackTrace]);
  
  /// Logs a critical error message.
  void critical(String message, [Object? error, StackTrace? stackTrace]);
} 