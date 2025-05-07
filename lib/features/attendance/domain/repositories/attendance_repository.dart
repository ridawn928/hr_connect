import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/domain/entities/attendance_record.dart';
import 'package:hr_connect/features/attendance/domain/entities/qr_code.dart';

/// Repository interface for attendance-related operations.
abstract class AttendanceRepository {
  /// Submits attendance using a QR code.
  /// 
  /// Returns a [Right] with the created [AttendanceRecord] on success,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, AttendanceRecord>> submitAttendance(QrCode qrCode);
  
  /// Gets attendance records for a specific employee.
  /// 
  /// Returns a [Right] with a list of [AttendanceRecord] on success,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceForEmployee(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Gets attendance records for a specific location.
  /// 
  /// Returns a [Right] with a list of [AttendanceRecord] on success,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceForLocation(
    String locationId, {
    DateTime? date,
  });
  
  /// Gets pending attendance records that need synchronization.
  /// 
  /// Returns a [Right] with a list of [AttendanceRecord] that need to be synced,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, List<AttendanceRecord>>> getPendingAttendanceRecords();
  
  /// Synchronizes pending attendance records with the server.
  /// 
  /// Returns a [Right] with a list of synchronized [AttendanceRecord] on success,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, List<AttendanceRecord>>> syncAttendanceRecords();
  
  /// Validates a QR code for attendance marking.
  /// 
  /// Returns a [Right] with a [ValidationResult] indicating whether the QR code is valid,
  /// or a [Left] with an appropriate [Failure] on error.
  Future<Either<Failure, ValidationResult>> validateQrCode(QrCode qrCode);
  
  /// Watches attendance records for a specific employee as a stream.
  /// 
  /// Returns a [Stream] of [Either] containing either a [Failure] or 
  /// a list of [AttendanceRecord].
  Stream<Either<Failure, List<AttendanceRecord>>> watchAttendanceForEmployee(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}
