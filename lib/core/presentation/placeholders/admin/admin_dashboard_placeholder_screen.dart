import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the admin dashboard screen.
class AdminDashboardPlaceholderScreen extends StatelessWidget {
  /// Creates a new admin dashboard placeholder screen.
  const AdminDashboardPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Admin Dashboard',
      headerColor: Colors.red.shade800,
      description: 'This is a placeholder for the admin dashboard screen. '
          'In the actual implementation, this screen would provide administrative '
          'controls for HR and payroll staff.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Logout',
          route: RouteConstants.login,
        ),
        PlaceholderNavButton(
          label: 'Generate QR Code',
          route: RouteConstants.generateQr,
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildSectionHeader('Recent Activity'),
              _buildActivityList(),
              const SizedBox(height: 24),
              _buildSectionHeader('Quick Actions'),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildSectionHeader('Attendance Overview'),
              _buildAttendanceChart(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a grid of statistics cards.
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Total Employees',
          value: '352',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Present Today',
          value: '297',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'On Leave',
          value: '23',
          icon: Icons.event_busy,
          color: Colors.amber,
        ),
        _buildStatCard(
          title: 'Pending Requests',
          value: '18',
          icon: Icons.hourglass_empty,
          color: Colors.deepPurple,
        ),
      ],
    );
  }

  /// Builds a card displaying a statistic with title, value, and icon.
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a section header with a title.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds a list of recent activities.
  Widget _buildActivityList() {
    final activities = [
      _Activity(
        icon: Icons.person_add,
        title: 'New employee registered',
        description: 'David Johnson was added to Engineering department',
        time: '10 minutes ago',
        color: Colors.blue,
      ),
      _Activity(
        icon: Icons.approval,
        title: 'Leave request approved',
        description: 'Sarah Taylor\'s vacation request was approved',
        time: '45 minutes ago',
        color: Colors.green,
      ),
      _Activity(
        icon: Icons.timelapse,
        title: 'Overtime submitted',
        description: 'Michael Brown submitted 3.5 hours of overtime',
        time: '2 hours ago',
        color: Colors.orange,
      ),
      _Activity(
        icon: Icons.edit,
        title: 'Profile updated',
        description: 'Lisa Anderson updated her contact information',
        time: '3 hours ago',
        color: Colors.purple,
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: activity.color.withOpacity(0.2),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: 20,
              ),
            ),
            title: Text(activity.title),
            subtitle: Text(activity.description),
            trailing: Text(
              activity.time,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a grid of action buttons.
  Widget _buildActionButtons() {
    final actions = [
      _QuickAction(
        icon: Icons.qr_code,
        title: 'Generate QR',
        color: Colors.indigo,
      ),
      _QuickAction(
        icon: Icons.people,
        title: 'Manage Staff',
        color: Colors.teal,
      ),
      _QuickAction(
        icon: Icons.approval,
        title: 'Approve Requests',
        color: Colors.green,
      ),
      _QuickAction(
        icon: Icons.assessment,
        title: 'Reports',
        color: Colors.amber,
      ),
    ];

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: actions.map((action) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: action.color.withOpacity(0.2),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds a placeholder for an attendance chart.
  Widget _buildAttendanceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Attendance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'May 1 - May 7, 2025',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar('Mon', 0.95, Colors.green),
                  _buildChartBar('Tue', 0.92, Colors.green),
                  _buildChartBar('Wed', 0.88, Colors.green),
                  _buildChartBar('Thu', 0.91, Colors.green),
                  _buildChartBar('Fri', 0.85, Colors.green),
                  _buildChartBar('Sat', 0.45, Colors.orange),
                  _buildChartBar('Sun', 0.20, Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Present', Colors.green),
                _buildLegendItem('Late', Colors.orange),
                _buildLegendItem('Absent', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a bar for the chart with day label and value.
  Widget _buildChartBar(String day, double value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 160 * value,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Builds a legend item with color and label.
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Model class for an activity item.
class _Activity {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color color;

  _Activity({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
  });
}

/// Model class for a quick action button.
class _QuickAction {
  final IconData icon;
  final String title;
  final Color color;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
  });
} 