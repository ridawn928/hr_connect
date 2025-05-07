import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Will add this dependency later
import 'package:http/http.dart' as http;

/// A module for registering core dependencies that can't be constructed with
/// a simple constructor or that require async initialization.
@module
abstract class CoreModule {
  /// Provides a singleton instance of SharedPreferences.
  ///
  /// This is a preemptive registration for a service we'll use later.
  /// Since SharedPreferences.getInstance() is async, we use @factoryMethod.
  // @factoryMethod
  // Future<SharedPreferences> sharedPreferences() => SharedPreferences.getInstance();

  /// Provides an HTTP client for the application.
  ///
  /// This demonstrates how to register a third-party class that doesn't
  /// have an injectable annotation.
  @lazySingleton
  http.Client get httpClient => http.Client();
} 