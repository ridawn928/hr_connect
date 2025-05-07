import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/localization/app_localizations.dart';
import 'package:hr_connect/core/providers/connectivity_provider.dart';

/// A widget that displays an indicator when the device is offline.
///
/// This widget can be used to show a prominent notification to the user
/// when internet connectivity is lost, ensuring they are aware of limited
/// functionality.
class OfflineStatusIndicator extends ConsumerWidget {
  /// The child widget to display below the indicator.
  final Widget? child;
  
  /// How long to animate the indicator when appearing/disappearing.
  final Duration animationDuration;
  
  /// Creates a new [OfflineStatusIndicator].
  const OfflineStatusIndicator({
    Key? key,
    this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    
    return Column(
      children: [
        AnimatedSwitcher(
          duration: animationDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: connectivity.maybeWhen(
            data: (status) => status == ConnectivityResult.none
                ? _buildOfflineIndicator(context)
                : const SizedBox.shrink(),
            // Show nothing while loading or on error
            orElse: () => const SizedBox.shrink(),
          ),
        ),
        if (child != null)
          Expanded(child: child!),
      ],
    );
  }
  
  Widget _buildOfflineIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      color: theme.colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              size: 16,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context).translate('offline_notice'),
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 