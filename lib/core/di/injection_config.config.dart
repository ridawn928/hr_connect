// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../routing/app_router.dart' as _i282;
import '../routing/app_router_impl.dart' as _i72;
import '../routing/navigation_service.dart' as _i693;
import '../routing/route_guards.dart' as _i129;
import '../services/config/config_service.dart' as _i291;
import '../services/config/dev_config_service.dart' as _i723;
import '../services/config/prod_config_service.dart' as _i240;
import '../services/logging/default_logger_service.dart' as _i701;
import '../services/logging/dev_logger_service.dart' as _i368;
import '../services/logging/logging_service.dart' as _i1022;
import '../services/logging/prod_logger_service.dart' as _i121;
import 'core_module.dart' as _i154;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i519.Client>(() => coreModule.httpClient);
    gh.singleton<_i291.ConfigService>(
      () => _i723.DevConfigService(),
      registerFor: {_dev},
    );
    gh.singleton<_i282.AppRouter>(
      () => _i72.AppRouterImpl(
        gh<_i129.AuthenticationGuard>(),
        gh<_i129.AdminGuard>(),
      ),
    );
    gh.lazySingleton<_i1022.LoggingService>(
      () => _i368.DevLoggerService(gh<_i291.ConfigService>()),
      registerFor: {_dev},
    );
    gh.factory<_i701.DefaultLoggerService>(
      () => _i701.DefaultLoggerService(gh<_i291.ConfigService>()),
    );
    gh.singleton<_i291.ConfigService>(
      () => _i240.ProdConfigService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i693.NavigationService>(
      () => _i693.NavigationService(gh<_i282.AppRouter>()),
    );
    gh.lazySingleton<_i1022.LoggingService>(
      () => _i121.ProdLoggerService(gh<_i291.ConfigService>()),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$CoreModule extends _i154.CoreModule {}
