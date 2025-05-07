import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the leave request screen.
class LeaveRequestPlaceholderScreen extends StatelessWidget {
  /// Creates a new leave request placeholder screen.
  const LeaveRequestPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Leave Request',
      headerColor: Colors.teal,
      description: 'This is a placeholder for the leave request screen. '
          'In the actual implementation, this screen would contain forms '
          'for requesting different types of leave with date selection.',
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        PlaceholderNavButton(
          label: 'View Leave History',
          route: RouteConstants.leaveHistory,
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Leave Type'),
              _buildLeaveTypeDropdown(),
              const SizedBox(height: 20),
              _buildSectionTitle('Duration'),
              _buildDateRangeRow(),
              const SizedBox(height: 20),
              _buildSectionTitle('Reason'),
              _buildReasonTextField(),
              const SizedBox(height: 30),
              _buildRemainingLeaveSummary(),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showSuccessDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'SUBMIT REQUEST',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section title with the given text.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds a dropdown for selecting leave type.
  Widget _buildLeaveTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Personal Leave',
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'Personal Leave',
              child: Text('Personal Leave'),
            ),
            DropdownMenuItem(
              value: 'Sick Leave',
              child: Text('Sick Leave'),
            ),
            DropdownMenuItem(
              value: 'Vacation',
              child: Text('Vacation'),
            ),
            DropdownMenuItem(
              value: 'Emergency Leave',
              child: Text('Emergency Leave'),
            ),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }

  /// Builds a row for selecting date range.
  Widget _buildDateRangeRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField('From Date', '10/05/2025'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField('To Date', '12/05/2025'),
        ),
      ],
    );
  }

  /// Builds a date field with the given label and value.
  Widget _buildDateField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              const Icon(Icons.calendar_today, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a text field for entering the reason for leave.
  Widget _buildReasonTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Please enter reason for leave...',
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// Builds a summary of remaining leave balances.
  Widget _buildRemainingLeaveSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Remaining Leave Balance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildLeaveBalanceRow('Personal Leave', 12, 30),
            _buildLeaveBalanceRow('Sick Leave', 7, 15),
            _buildLeaveBalanceRow('Vacation', 20, 30),
            _buildLeaveBalanceRow('Emergency Leave', 3, 5),
          ],
        ),
      ),
    );
  }

  /// Builds a row showing a leave type's remaining and total days.
  Widget _buildLeaveBalanceRow(String leaveType, int remaining, int total) {
    final double percentage = remaining / total;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leaveType),
              Text('$remaining/$total days'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade300,
            color: Colors.teal,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  /// Shows a success dialog when the leave request is submitted.
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Submitted'),
        content: const Text(
          'Your leave request has been submitted successfully. '
          'You will be notified when it is approved.',
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