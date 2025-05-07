import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hr_connect/core/localization/app_localizations.dart';
import 'package:hr_connect/core/providers/auth_provider.dart';
import 'package:hr_connect/core/providers/connectivity_provider.dart';
import 'package:hr_connect/core/widgets/error_boundary.dart';
import 'package:hr_connect/core/widgets/offline_status_indicator.dart';
import 'package:hr_connect/core/widgets/permission_aware_builder.dart';

/// The root widget of the HR Connect application.
///
/// This widget sets up the application-wide configurations including
/// theming, routing, and localization. It follows the Material Design 3
/// guidelines and supports both light and dark themes.
class MyApp extends ConsumerWidget {
  /// Creates a new instance of [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get router instance from DI container
    final AppRouter appRouter = getIt<AppRouter>();
    
    // Watch current user role for permission-aware UI
    final userRole = ref.watch(userRoleProvider);
    
    return ErrorBoundary(
      child: MaterialApp.router(
        title: 'HR Connect',
        debugShowCheckedModeBanner: false,
        
        // Theme configuration
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system, // Uses system preference
        
        // Localization configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('es', ''), // Spanish
        ],
        
        // Router configuration
        routerConfig: appRouter.config,
        
        // Add global UI enhancements
        builder: (context, child) {
          // Wrap the app with the offline indicator and permission-aware builder
          return OfflineStatusIndicator(
            child: PermissionAwareBuilder(
              userRole: userRole,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
} 