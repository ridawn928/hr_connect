import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';

/// Configuration service for the application.
///
/// Provides access to application-wide configuration settings.
abstract class ConfigService {
  /// Whether verbose logging is enabled.
  bool get enableVerboseLogging;
  
  /// Whether to log to a remote server.
  bool get enableRemoteLogging;
  
  /// Remote logging endpoint URL (if remote logging is enabled).
  String get remoteLoggingUrl;
}