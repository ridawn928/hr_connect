/// Represents the different user roles in the HR Connect application.
///
/// Each role has different permissions and access levels within the application.
enum UserRole {
  /// Regular employee with basic access to attendance and leave management.
  employee,
  
  /// Branch manager with additional permissions for approvals and team management.
  branchManager,
  
  /// Payroll portal administrator with access to attendance data and payroll processing.
  payrollPortal,
  
  /// HR portal administrator with complete system administration access.
  hrPortal,
}

/// Defines the actions a user can perform on resources.
enum PermissionAction {
  /// Permission to view a resource.
  view,
  
  /// Permission to create a new resource.
  create,
  
  /// Permission to edit an existing resource.
  edit,
  
  /// Permission to delete a resource.
  delete,
  
  /// Permission to approve requests.
  approve,
}

/// Extension methods for UserRole to check permissions.
extension UserRoleExtension on UserRole {
  /// Checks if this role has permission to perform the specified action on the resource.
  bool hasPermission(String resource, PermissionAction action) {
    // Implementation will be expanded in the future with a proper permission system.
    // For now, we'll use a simplified approach:
    
    switch (this) {
      case UserRole.hrPortal:
        // HR Portal has full access to everything
        return true;
        
      case UserRole.payrollPortal:
        // Payroll Portal has access to attendance and payroll resources
        if (resource.startsWith('attendance') || resource.startsWith('payroll')) {
          return true;
        }
        return action == PermissionAction.view;
        
      case UserRole.branchManager:
        // Branch Manager can view most resources, approve requests, and edit some resources
        if (action == PermissionAction.view || action == PermissionAction.approve) {
          return true;
        }
        if (action == PermissionAction.edit && 
            (resource.startsWith('team') || resource.startsWith('leave'))) {
          return true;
        }
        return false;
        
      case UserRole.employee:
        // Employee can only view resources or edit their own profile
        if (action == PermissionAction.view) {
          return true;
        }
        if (action == PermissionAction.edit && resource == 'profile') {
          return true;
        }
        if (action == PermissionAction.create && resource == 'leave.request') {
          return true;
        }
        return false;
    }
  }
} 