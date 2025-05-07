import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/logging/logging_service.dart';
import 'package:hr_connect/core/services/logging/default_logger_service.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Production environment specific logger implementation.
///
/// This logger is optimized for production use with minimal console output
/// and focuses on capturing critical errors for remote logging.
@Environment(Env.prod)
@LazySingleton(as: LoggingService)
class ProdLoggerService extends DefaultLoggerService {
  /// Creates a production environment logger.
  ProdLoggerService(ConfigService config) : super(config);
  
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    // In production, only log warnings and above to console
    if (level.index >= LogLevel.warning.index) {
      final timestamp = DateTime.now().toIso8601String();
      final prefix = getLevelPrefix(level);
      
      print('$timestamp $prefix [PROD]: $message');
      
      if (error != null) {
        print('$timestamp $prefix [PROD] ERROR: $error');
      }
    }
    
    // Always send to remote logging in production
    logToRemoteServer(level, message, error, stackTrace);
  }
  
  @override
  String getLevelPrefix(LogLevel level) {
    final basePrefix = super.getLevelPrefix(level);
    
    // Add emoji indicators based on severity
    switch (level) {
      case LogLevel.debug:
      case LogLevel.info:
        return basePrefix;
      case LogLevel.warning:
        return '⚠️ $basePrefix';
      case LogLevel.error:
      case LogLevel.critical:
        return '🔴 $basePrefix';
    }
  }
} 