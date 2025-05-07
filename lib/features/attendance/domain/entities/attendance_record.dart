import 'package:equatable/equatable.dart';
import 'package:hr_connect/features/attendance/domain/entities/qr_code.dart';
import 'package:uuid/uuid.dart';

/// Enum representing the synchronization status of an attendance record.
enum SyncStatus {
  /// Record is synced with the remote server
  synced,
  
  /// Record is pending synchronization
  pending,
  
  /// Synchronization failed
  failed,
}

/// Enum representing the attendance status.
enum AttendanceStatus {
  /// Employee arrived on time
  onTime,
  
  /// Employee arrived late
  late,
  
  /// Employee did not arrive (marked by system after cutoff)
  absent,
  
  /// Employee left early or arrived very late (partial day)
  halfDay,
  
  /// Employee was on approved leave
  approvedLeave,
}

/// Entity representing an attendance record.
class AttendanceRecord extends Equatable {
  /// Unique identifier for the record
  final String id;
  
  /// ID of the employee
  final String employeeId;
  
  /// ID of the location
  final String locationId;
  
  /// Timestamp when attendance was marked
  final DateTime timestamp;
  
  /// Status of the attendance record
  final AttendanceStatus status;
  
  /// Synchronization status
  final SyncStatus syncStatus;
  
  /// Optional comment or note
  final String? note;
  
  /// Optional reference to the QR code used
  final String? qrCodeId;
  
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.locationId,
    required this.timestamp,
    required this.status,
    required this.syncStatus,
    this.note,
    this.qrCodeId,
  });
  
  /// Creates a pending attendance record from a QR code.
  factory AttendanceRecord.pending(QrCode qrCode, {
    required String employeeId,
  }) {
    const uuid = Uuid();
    
    return AttendanceRecord(
      id: uuid.v4(),
      employeeId: employeeId,
      locationId: qrCode.locationId,
      timestamp: DateTime.now(),
      status: AttendanceStatus.onTime, // Initial status, will be determined later
      syncStatus: SyncStatus.pending,
      qrCodeId: qrCode.id,
    );
  }
  
  /// Creates a copy of this attendance record with modified fields.
  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    String? locationId,
    DateTime? timestamp,
    AttendanceStatus? status,
    SyncStatus? syncStatus,
    String? note,
    String? qrCodeId,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      locationId: locationId ?? this.locationId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      note: note ?? this.note,
      qrCodeId: qrCodeId ?? this.qrCodeId,
    );
  }
  
  /// Creates a synced copy of this attendance record.
  AttendanceRecord toSynced() {
    return copyWith(syncStatus: SyncStatus.synced);
  }
  
  /// Creates a failed-sync copy of this attendance record.
  AttendanceRecord toFailed() {
    return copyWith(syncStatus: SyncStatus.failed);
  }
  
  @override
  List<Object?> get props => [
    id,
    employeeId,
    locationId,
    timestamp,
    status,
    syncStatus,
    note,
    qrCodeId,
  ];
}
