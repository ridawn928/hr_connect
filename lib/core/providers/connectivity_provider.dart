import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provides a stream of network connectivity state changes.
///
/// This provider exposes the device's connectivity status, which can be used
/// to show offline indicators or modify app behavior when connectivity is lost.
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  // Get initial state and subsequent state changes
  return Connectivity().onConnectivityChanged;
});

/// Checks if the device currently has network connectivity.
///
/// This provider returns true if there is either WiFi or mobile data connectivity,
/// and false if the device is completely offline.
final isConnectedProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  
  return connectivity.maybeWhen(
    data: (connectionState) => 
        connectionState != ConnectivityResult.none,
    // Default to optimistic assumption when loading
    orElse: () => true,
  );
}); 