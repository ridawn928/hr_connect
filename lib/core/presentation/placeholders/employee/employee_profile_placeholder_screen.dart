import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the employee profile screen.
class EmployeeProfilePlaceholderScreen extends StatelessWidget {
  /// Creates a new employee profile placeholder screen.
  const EmployeeProfilePlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Employee Profile',
      headerColor: Colors.orange,
      description: 'This is a placeholder for the employee profile screen. '
          'In the actual implementation, this screen would show personal '
          'information, employment details, and profile management options.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        PlaceholderNavButton(
          label: 'Edit Profile',
          route: RouteConstants.editProfile,
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildInfoSection('Personal Information', [
                _buildInfoRow(Icons.person, 'Name', 'Jane Smith'),
                _buildInfoRow(Icons.email, 'Email', 'jane.smith@company.com'),
                _buildInfoRow(Icons.phone, 'Phone', '+1 (555) 123-4567'),
                _buildInfoRow(Icons.cake, 'Date of Birth', '15 April 1988'),
                _buildInfoRow(Icons.home, 'Address', '123 Main St, City, Country'),
              ]),
              const SizedBox(height: 24),
              _buildInfoSection('Employment Details', [
                _buildInfoRow(Icons.business, 'Department', 'Engineering'),
                _buildInfoRow(Icons.work, 'Position', 'Senior Developer'),
                _buildInfoRow(Icons.date_range, 'Start Date', '10 January 2020'),
                _buildInfoRow(Icons.supervisor_account, 'Reports To', 'John Manager'),
                _buildInfoRow(Icons.location_on, 'Office Location', 'North Building, Floor 3'),
              ]),
              const SizedBox(height: 24),
              _buildInfoSection('Documents', [
                _buildDocumentRow('ID Card', '12 Feb 2023'),
                _buildDocumentRow('Contract', '10 Jan 2020'),
                _buildDocumentRow('Resume', '15 Dec 2019'),
                _buildDocumentRow('Certifications', '05 Mar 2022'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the profile header with avatar and name.
  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Jane Smith',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Employee ID: EMP-00123',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Chip(
          label: const Text('Active'),
          backgroundColor: Colors.green.shade100,
          labelStyle: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds a section with a title and list of information rows.
  Widget _buildInfoSection(String title, List<Widget> children) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Builds a row with an icon, label, and value.
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a row for a document with name and upload date.
  Widget _buildDocumentRow(String documentName, String uploadDate) {
    return ListTile(
      leading: const Icon(
        Icons.description,
        color: Colors.orange,
      ),
      title: Text(documentName),
      subtitle: Text('Uploaded: $uploadDate'),
      trailing: const Icon(Icons.download),
      contentPadding: EdgeInsets.zero,
    );
  }
} 