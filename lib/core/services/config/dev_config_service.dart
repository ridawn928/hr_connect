import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Development environment implementation of ConfigService.
///
/// This version is configured for development needs with
/// verbose logging enabled.
@Environment(Env.dev)
@Singleton(as: ConfigService)
class DevConfigService implements ConfigService {
  @override
  final bool enableVerboseLogging = true;
  
  @override
  final bool enableRemoteLogging = false;
  
  @override
  final String remoteLoggingUrl = 'https://dev-logging.hrconnect.example.com';
} 