import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/auth/user_role.dart';

/// Provider for the current user's role in the application.
///
/// Defaults to the [UserRole.employee] role until authentication is completed.
/// This provider will be updated by the authentication service when a user logs in.
final userRoleProvider = StateProvider<UserRole>((ref) {
  // Default to Employee role until authentication is completed
  return UserRole.employee;
});

/// Provider to check if the current user has a specific permission.
///
/// This provider takes a resource name and action, then checks if the current user's
/// role has permission to perform that action on the resource.
final userHasPermissionProvider = Provider.family<bool, ({String resource, PermissionAction action})>((ref, params) {
  final userRole = ref.watch(userRoleProvider);
  
  // Use the permission system defined in UserRoleExtension
  return userRole.hasPermission(params.resource, params.action);
}); 