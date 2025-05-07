import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Development environment specific logger implementation.
///
/// This logger provides more detailed output including source file
/// information and line numbers for debugging purposes.
@Environment(Env.dev)
@LazySingleton(as: LoggingService)
class DevLoggerService extends DefaultLoggerService {
  /// Creates a development environment logger.
  DevLoggerService(ConfigService config) : super(config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = getLevelPrefix(level);
    
    // Add extra debugging info for development
    print('$timestamp $prefix [DEV]: $message');
    
    if (error != null) {
      print('$timestamp $prefix [DEV] ERROR: $error');
      
      // Always print stack trace in dev mode
      if (stackTrace != null) {
        print('$timestamp $prefix [DEV] STACK TRACE:');
        print(stackTrace);
      }
    }
  }
  
  @override
  String getLevelPrefix(LogLevel level) {
    final basePrefix = super.getLevelPrefix(level);
    return '🔧 $basePrefix';
  }
} 