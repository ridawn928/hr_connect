import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/navigation_extensions.dart';

/// Placeholder for the home screen.
class HomePlaceholderScreen extends StatelessWidget {
  /// Creates a new home placeholder screen.
  const HomePlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Home Screen',
      headerColor: Colors.purple,
      description: 'This is a placeholder for the home/dashboard screen. '
          'In the actual implementation, this screen would show an overview '
          'of the application features and quick actions.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'QR Scanner',
          route: RouteConstants.qrScanner,
        ),
        PlaceholderNavButton(
          label: 'Attendance History',
          route: RouteConstants.attendanceHistory,
        ),
        PlaceholderNavButton(
          label: 'Leave Request',
          route: RouteConstants.leaveRequest,
        ),
        PlaceholderNavButton(
          label: 'Leave History',
          route: RouteConstants.leaveHistory,
        ),
        PlaceholderNavButton(
          label: 'Employee Profile',
          route: RouteConstants.employeeProfile,
        ),
        PlaceholderNavButton(
          label: 'Admin Dashboard',
          route: RouteConstants.adminDashboard,
        ),
      ],
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: const EdgeInsets.all(16),
        children: const [
          _DashboardTile(
            icon: Icons.qr_code_scanner,
            label: 'QR Attendance',
            color: Colors.indigo,
            route: RouteConstants.qrScanner,
          ),
          _DashboardTile(
            icon: Icons.history,
            label: 'Attendance History',
            color: Colors.blue,
            route: RouteConstants.attendanceHistory,
          ),
          _DashboardTile(
            icon: Icons.event_note,
            label: 'Leave Request',
            color: Colors.teal,
            route: RouteConstants.leaveRequest,
          ),
          _DashboardTile(
            icon: Icons.receipt_long,
            label: 'Leave History',
            color: Colors.green,
            route: RouteConstants.leaveHistory,
          ),
          _DashboardTile(
            icon: Icons.person,
            label: 'Profile',
            color: Colors.amber,
            route: RouteConstants.employeeProfile,
          ),
          _DashboardTile(
            icon: Icons.admin_panel_settings,
            label: 'Admin',
            color: Colors.red,
            route: RouteConstants.adminDashboard,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFeatureCard(
            'Authentication',
            'Login, registration, and account management',
            Icons.security,
            Colors.blue,
            onPressed: () => _showFeatureNotAvailable(context, 'Authentication'),
          ),
          _buildFeatureCard(
            'Profile Management',
            'View and edit employee profiles',
            Icons.person,
            Colors.green,
            onPressed: () => _showFeatureNotAvailable(context, 'Profile Management'),
          ),
          _buildFeatureCard(
            'QR Code Attendance',
            'Scan QR codes to mark attendance',
            Icons.qr_code,
            Colors.purple,
            onPressed: () => _showFeatureNotAvailable(context, 'QR Code Attendance'),
          ),
          _buildFeatureCard(
            'Time Management',
            'Leave requests and approvals',
            Icons.schedule,
            Colors.orange,
            onPressed: () => _showFeatureNotAvailable(context, 'Time Management'),
          ),
          _buildFeatureCard(
            'Routing Test',
            'Test screen for verifying app routing',
            Icons.route,
            Colors.amber,
            onPressed: () {
              // Navigate to the routing test screen
              final navigationService = getIt<NavigationService>();
              navigationService.toRoutingTest(testParam: 'From Home Screen');
            },
          ),
        ],
      ),
    );
  }

  void _showFeatureNotAvailable(BuildContext context, String feature) {
    // Implementation of _showFeatureNotAvailable method
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color, VoidCallback onPressed) {
    // Implementation of _buildFeatureCard method
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A dashboard tile with an icon and label.
class _DashboardTile extends StatelessWidget {
  /// The icon to display in the tile.
  final IconData icon;
  
  /// The label to display in the tile.
  final String label;
  
  /// The color of the tile.
  final Color color;
  
  /// The route to navigate to when the tile is tapped.
  final String route;
  
  /// Creates a new dashboard tile.
  const _DashboardTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 