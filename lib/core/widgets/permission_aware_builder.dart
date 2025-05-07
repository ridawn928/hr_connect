import 'package:flutter/material.dart';
import 'package:hr_connect/core/auth/user_role.dart';

/// A widget that adapts its child based on the user's role permissions.
///
/// This widget can be used to show or hide features based on the user's role,
/// ensuring that the UI respects the role-based access control system.
class PermissionAwareBuilder extends StatelessWidget {
  /// The child widget to display.
  final Widget child;
  
  /// The current user role.
  final UserRole userRole;
  
  /// Creates a new [PermissionAwareBuilder].
  const PermissionAwareBuilder({
    Key? key,
    required this.child,
    required this.userRole,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Here you can add global permission-based adaptations
    // For now, we just return the child
    return child;
    
    // In the future, you might add overlays or modify the child
    // based on permissions, for example:
    /*
    return Stack(
      children: [
        child,
        if (userRole == UserRole.branchManager)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Manager-specific action
              },
              tooltip: 'Manager Actions',
              child: const Icon(Icons.admin_panel_settings),
            ),
          ),
      ],
    );
    */
  }
} 