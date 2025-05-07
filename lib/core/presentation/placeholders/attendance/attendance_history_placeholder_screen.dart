import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the attendance history screen.
class AttendanceHistoryPlaceholderScreen extends StatelessWidget {
  /// Creates a new attendance history placeholder screen.
  const AttendanceHistoryPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample attendance data for demonstration
    final attendanceRecords = [
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 0)),
        checkInTime: '09:02 AM',
        checkOutTime: '05:30 PM',
        status: 'ON TIME',
        statusColor: Colors.green,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 1)),
        checkInTime: '09:15 AM',
        checkOutTime: '05:45 PM',
        status: 'LATE',
        statusColor: Colors.orange,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 2)),
        checkInTime: '08:55 AM',
        checkOutTime: '05:30 PM',
        status: 'ON TIME',
        statusColor: Colors.green,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 3)),
        checkInTime: '10:20 AM',
        checkOutTime: '06:10 PM',
        status: 'LATE',
        statusColor: Colors.red,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 4)),
        checkInTime: 'N/A',
        checkOutTime: 'N/A',
        status: 'APPROVED LEAVE',
        statusColor: Colors.blue,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 5)),
        checkInTime: '09:00 AM',
        checkOutTime: '05:30 PM',
        status: 'ON TIME',
        statusColor: Colors.green,
      ),
      _AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 6)),
        checkInTime: '08:58 AM',
        checkOutTime: '05:25 PM',
        status: 'ON TIME',
        statusColor: Colors.green,
      ),
    ];

    return BasePlaceholderScreen(
      title: 'Attendance History',
      headerColor: Colors.blue,
      description: 'This is a placeholder for the attendance history screen. '
          'In the actual implementation, this screen would show a list of '
          'attendance records with filtering and sorting options.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        PlaceholderNavButton(
          label: 'Scan QR Code',
          route: RouteConstants.qrScanner,
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Present', '15', Colors.green),
                    _buildSummaryItem('Late', '3', Colors.orange),
                    _buildSummaryItem('Absent', '1', Colors.red),
                    _buildSummaryItem('Leave', '2', Colors.blue),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceRecords[index];
                return _buildAttendanceCard(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a summary item with a label, value, and color.
  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  /// Builds a card for displaying an attendance record.
  Widget _buildAttendanceCard(_AttendanceRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${record.date.day}/${record.date.month}/${record.date.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: record.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    record.status,
                    style: TextStyle(
                      color: record.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.login, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Check In: ${record.checkInTime}'),
                const SizedBox(width: 16),
                const Icon(Icons.logout, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Check Out: ${record.checkOutTime}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A data class representing an attendance record.
class _AttendanceRecord {
  /// The date of the attendance record.
  final DateTime date;
  
  /// The check-in time (as a string).
  final String checkInTime;
  
  /// The check-out time (as a string).
  final String checkOutTime;
  
  /// The status of the attendance (e.g., ON TIME, LATE).
  final String status;
  
  /// The color representing the status.
  final Color statusColor;
  
  /// Creates a new attendance record.
  const _AttendanceRecord({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
    required this.statusColor,
  });
} 