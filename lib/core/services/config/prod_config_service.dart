import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/di/injection_config.dart';
import 'package:hr_connect/core/services/config/config_service.dart';

/// Production environment implementation of ConfigService.
///
/// This version is configured for production with minimal
/// logging and remote logging enabled.
@Environment(Env.prod)
@Singleton(as: ConfigService)
class ProdConfigService implements ConfigService {
  @override
  final bool enableVerboseLogging = false;
  
  @override
  final bool enableRemoteLogging = true;
  
  @override
  final String remoteLoggingUrl = 'https://logging.hrconnect.example.com';
} 