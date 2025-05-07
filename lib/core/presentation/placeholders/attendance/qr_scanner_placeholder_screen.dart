import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the QR scanner screen.
class QrScannerPlaceholderScreen extends StatelessWidget {
  /// Creates a new QR scanner placeholder screen.
  const QrScannerPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'QR Scanner',
      headerColor: Colors.indigo,
      description: 'This is a placeholder for the QR scanner screen. '
          'In the actual implementation, this screen would use the camera '
          'to scan QR codes for attendance tracking.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        PlaceholderNavButton(
          label: 'View Attendance History',
          route: RouteConstants.attendanceHistory,
        ),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Camera view would appear here',
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Position the QR code within the frame to scan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showSuccessDialog(context);
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Simulate Successful Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a success dialog when the QR code is scanned.
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            SizedBox(height: 16),
            Text('Attendance recorded successfully!'),
            SizedBox(height: 8),
            Text(
              'Status: ON TIME',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 