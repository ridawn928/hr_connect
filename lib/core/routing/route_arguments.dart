// File: lib/core/routing/route_arguments.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';

/// Base class for type-safe route arguments.
///
/// Extending this class for each route with specific parameters makes
/// navigation more type-safe and self-documenting.
abstract class RouteArguments {}

/// Arguments for the employee profile route.
class EmployeeProfileArguments extends RouteArguments {
  /// The ID of the employee to display.
  final String employeeId;
  
  /// Whether to show the edit button.
  final bool showEditButton;
  
  /// Creates arguments for the employee profile route.
  EmployeeProfileArguments({
    required this.employeeId,
    this.showEditButton = true,
  });
}

/// Arguments for the leave request route.
class LeaveRequestArguments extends RouteArguments {
  /// The initial leave type to select.
  final String? initialLeaveType;
  
  /// The initial start date.
  final DateTime? startDate;
  
  /// The initial end date.
  final DateTime? endDate;
  
  /// Creates arguments for the leave request route.
  LeaveRequestArguments({
    this.initialLeaveType,
    this.startDate,
    this.endDate,
  });
}

/// Arguments for the attendance detail route.
class AttendanceDetailArguments extends RouteArguments {
  /// The ID of the attendance record to display.
  final String attendanceId;
  
  /// Whether to show the edit options.
  final bool allowEdit;
  
  /// Creates arguments for the attendance detail route.
  AttendanceDetailArguments({
    required this.attendanceId,
    this.allowEdit = false,
  });
}

/// Extension for extracting route arguments from NavigationService.
extension ArgumentExtractionExtension on NavigationService {
  /// Gets type-safe arguments for the employee profile route.
  ///
  /// [employeeId] The ID of the employee to display.
  /// [showEditButton] Whether to show the edit button.
  EmployeeProfileArguments employeeProfileArgs({
    required String employeeId,
    bool showEditButton = true,
  }) {
    return EmployeeProfileArguments(
      employeeId: employeeId,
      showEditButton: showEditButton,
    );
  }
  
  /// Gets type-safe arguments for the leave request route.
  ///
  /// [initialLeaveType] The initial leave type to select.
  /// [startDate] The initial start date.
  /// [endDate] The initial end date.
  LeaveRequestArguments leaveRequestArgs({
    String? initialLeaveType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LeaveRequestArguments(
      initialLeaveType: initialLeaveType,
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  /// Gets type-safe arguments for the attendance detail route.
  ///
  /// [attendanceId] The ID of the attendance record to display.
  /// [allowEdit] Whether to show the edit options.
  AttendanceDetailArguments attendanceDetailArgs({
    required String attendanceId,
    bool allowEdit = false,
  }) {
    return AttendanceDetailArguments(
      attendanceId: attendanceId,
      allowEdit: allowEdit,
    );
  }
} 