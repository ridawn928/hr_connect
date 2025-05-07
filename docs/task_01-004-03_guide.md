# Implementation Guide: Setting Up Initial Route Definitions with Placeholder Screens

## Task ID: 01-004-03 - Set up initial route definitions with placeholder screens

### 1. Introduction

This guide provides step-by-step instructions for setting up initial route definitions with placeholder screens in the HR Connect application. This task builds on the routing infrastructure established in previous tasks and allows for testing the navigation system before implementing the actual feature screens.

#### 1.1 Purpose

Setting up placeholder screens serves several important purposes in the development process:

- Validates the routing system without requiring full feature implementation
- Provides a visual confirmation that navigation is working correctly
- Allows testing of route guards and navigation patterns
- Creates a foundation for future feature development
- Simplifies testing and debugging of the navigation logic

#### 1.2 Relationship to Previous Tasks

This task builds directly on:
- Task 01-004-01: Create a core/routing/ directory for routing logic
- Task 01-004-02: Define the AppRouter class using auto_route or go_router

While the previous tasks established the routing infrastructure, this task focuses on creating the actual route definitions and connecting them to placeholder screens that will be used for testing.

### 2. Prerequisites

Before implementing the placeholder screens and route definitions, ensure:

1. Task 01-004-02 is completed and the AppRouterImpl class is properly implemented
2. The route constants are defined in route_constants.dart
3. The go_router dependency is properly added to the pubspec.yaml file
4. The routing system is registered with the dependency injection system

### 3. Creating the Placeholder Screens Structure

#### 3.1 Directory Organization

Create a directory structure for the placeholder screens that mirrors the feature organization:

```bash
mkdir -p lib/core/presentation/placeholders
mkdir -p lib/core/presentation/placeholders/core
mkdir -p lib/core/presentation/placeholders/attendance
mkdir -p lib/core/presentation/placeholders/time_management
mkdir -p lib/core/presentation/placeholders/employee
mkdir -p lib/core/presentation/placeholders/admin
```

This structure organizes the placeholder screens by feature area, following the Modified Vertical Slice Architecture (MVSA) approach.

#### 3.2 Base Placeholder Screen

First, create a base placeholder screen widget that will be reused for all placeholder screens:

```dart
// File: lib/core/presentation/placeholders/base_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';

/// Base widget for all placeholder screens in the application.
///
/// This widget provides a consistent layout and styling for all placeholder
/// screens, making it easy to identify which screen is being displayed and
/// providing navigation controls for testing.
class BasePlaceholderScreen extends StatelessWidget {
  /// The title of the screen.
  final String title;
  
  /// The color used for the screen header.
  final Color headerColor;
  
  /// Optional description of the screen's purpose.
  final String? description;
  
  /// Optional widget to display in the body of the screen.
  final Widget? body;
  
  /// Optional list of navigation buttons to display.
  final List<PlaceholderNavButton>? navigationButtons;
  
  /// Creates a new placeholder screen.
  const BasePlaceholderScreen({
    Key? key,
    required this.title,
    required this.headerColor,
    this.description,
    this.body,
    this.navigationButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: headerColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (description != null) _buildDescription(),
              if (body != null) Expanded(child: body!),
              const Spacer(),
              _buildNavigationSection(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the header section with the screen title.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: headerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: headerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.web_asset, color: headerColor),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Placeholder: $title',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds the description section.
  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        description!,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
  
  /// Builds the navigation section with buttons for testing navigation.
  Widget _buildNavigationSection() {
    if (navigationButtons == null || navigationButtons!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Navigation Testing',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: navigationButtons!,
        ),
      ],
    );
  }
}

/// A button for testing navigation between placeholder screens.
class PlaceholderNavButton extends StatelessWidget {
  /// The label to display on the button.
  final String label;
  
  /// The route to navigate to when the button is pressed.
  final String route;
  
  /// Optional arguments to pass to the route.
  final Object? arguments;
  
  /// Creates a new navigation button.
  const PlaceholderNavButton({
    Key? key,
    required this.label,
    required this.route,
    this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get navigation service from DI
    final navigationService = getIt<NavigationService>();
    
    return ElevatedButton(
      onPressed: () {
        navigationService.navigateTo(route, arguments: arguments);
      },
      child: Text(label),
    );
  }
}
```

### 4. Implementing Placeholder Screens

#### 4.1 Core Placeholder Screens

Create placeholder screens for the core routes (splash, login, home):

```dart
// File: lib/core/presentation/placeholders/core/splash_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the splash screen.
class SplashPlaceholderScreen extends StatelessWidget {
  /// Creates a new splash placeholder screen.
  const SplashPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Splash Screen',
      headerColor: Colors.blue,
      description: 'This is a placeholder for the application splash screen. '
          'In the actual implementation, this screen would show a logo and '
          'handle initialization tasks.',
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Go to Login',
          route: RouteConstants.login,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/core/login_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the login screen.
class LoginPlaceholderScreen extends StatelessWidget {
  /// Creates a new login placeholder screen.
  const LoginPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Login Screen',
      headerColor: Colors.green,
      description: 'This is a placeholder for the login screen. '
          'In the actual implementation, this screen would include '
          'login forms and authentication logic.',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple mock login form
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username (placeholder)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password (placeholder)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login (placeholder)'),
            ),
          ],
        ),
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Go to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'Back to Splash',
          route: RouteConstants.splash,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/core/home_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the home/dashboard screen.
class HomePlaceholderScreen extends StatelessWidget {
  /// Creates a new home placeholder screen.
  const HomePlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Home Dashboard',
      headerColor: Colors.purple,
      description: 'This is a placeholder for the main dashboard. '
          'In the actual implementation, this screen would show summary data '
          'and navigation to different features.',
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          _buildFeatureTile(
            'Attendance',
            Icons.qr_code_scanner,
            Colors.orange,
          ),
          _buildFeatureTile(
            'Time Management',
            Icons.calendar_today,
            Colors.blue,
          ),
          _buildFeatureTile(
            'Employee Profile',
            Icons.person,
            Colors.green,
          ),
          _buildFeatureTile(
            'Admin Portal',
            Icons.admin_panel_settings,
            Colors.red,
          ),
        ],
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'QR Scanner',
          route: RouteConstants.qrScanner,
        ),
        const PlaceholderNavButton(
          label: 'Attendance History',
          route: RouteConstants.attendanceHistory,
        ),
        const PlaceholderNavButton(
          label: 'Leave Request',
          route: RouteConstants.leaveRequest,
        ),
        const PlaceholderNavButton(
          label: 'Employee Profile',
          route: RouteConstants.employeeProfile,
        ),
        const PlaceholderNavButton(
          label: 'Admin Dashboard',
          route: RouteConstants.adminDashboard,
        ),
        const PlaceholderNavButton(
          label: 'Logout',
          route: RouteConstants.login,
        ),
      ],
    );
  }
  
  /// Builds a feature tile for the dashboard grid.
  Widget _buildFeatureTile(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 4.2 Feature-Specific Placeholder Screens

Create placeholder screens for each feature:

```dart
// File: lib/core/presentation/placeholders/attendance/qr_scanner_placeholder_screen.dart

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
      headerColor: Colors.orange,
      description: 'This is a placeholder for the QR code scanner. '
          'In the actual implementation, this screen would use the device '
          'camera to scan attendance QR codes.',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 100,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Camera placeholder for QR scanning',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'Go to Attendance History',
          route: RouteConstants.attendanceHistory,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/attendance/attendance_history_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the attendance history screen.
class AttendanceHistoryPlaceholderScreen extends StatelessWidget {
  /// Creates a new attendance history placeholder screen.
  const AttendanceHistoryPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Attendance History',
      headerColor: Colors.teal,
      description: 'This is a placeholder for the attendance history screen. '
          'In the actual implementation, this screen would show a list of '
          'attendance records with dates, times, and status.',
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index));
          final status = index % 3 == 0
              ? 'ON_TIME'
              : index % 3 == 1
                  ? 'LATE'
                  : 'ABSENT';
          final statusColor = status == 'ON_TIME'
              ? Colors.green
              : status == 'LATE'
                  ? Colors.orange
                  : Colors.red;
                  
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor,
                child: Icon(
                  status == 'ON_TIME'
                      ? Icons.check
                      : status == 'LATE'
                          ? Icons.access_time
                          : Icons.close,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Date: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Status: $status'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'QR Scanner',
          route: RouteConstants.qrScanner,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/time_management/leave_request_placeholder_screen.dart

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
      headerColor: Colors.indigo,
      description: 'This is a placeholder for the leave request screen. '
          'In the actual implementation, this screen would include forms '
          'for submitting different types of leave requests.',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Leave',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Leave Type:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: ['Personal', 'Sick', 'Vacation', 'Emergency']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (_) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Start Date:'),
            const SizedBox(height: 8),
            TextFormField(
              enabled: false,
              initialValue: '2025-05-10',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            const Text('End Date:'),
            const SizedBox(height: 8),
            TextFormField(
              enabled: false,
              initialValue: '2025-05-12',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Reason:'),
            const SizedBox(height: 8),
            TextFormField(
              enabled: false,
              initialValue: 'Placeholder reason for leave request',
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter reason...',
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Submit Request (Placeholder)'),
              ),
            ),
          ],
        ),
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'View Leave History',
          route: RouteConstants.leaveHistory,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/time_management/leave_history_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the leave history screen.
class LeaveHistoryPlaceholderScreen extends StatelessWidget {
  /// Creates a new leave history placeholder screen.
  const LeaveHistoryPlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Leave History',
      headerColor: Colors.deepPurple,
      description: 'This is a placeholder for the leave history screen. '
          'In the actual implementation, this screen would show a list of '
          'leave requests with dates, types, and status.',
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index * 15));
          final types = ['Personal', 'Sick', 'Vacation', 'Emergency', 'Training'];
          final statuses = ['Approved', 'Pending', 'Rejected'];
          
          final type = types[index % types.length];
          final status = statuses[index % statuses.length];
          final statusColor = status == 'Approved'
              ? Colors.green
              : status == 'Pending'
                  ? Colors.orange
                  : Colors.red;
          
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Leave Type: $type',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dates: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} to '
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${(date.day + 2).toString().padLeft(2, '0')}',
                  ),
                  const SizedBox(height: 4),
                  Text('Duration: ${index + 1} day(s)'),
                  const SizedBox(height: 4),
                  const Text('Reason: Placeholder reason for leave request'),
                ],
              ),
            ),
          );
        },
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'New Leave Request',
          route: RouteConstants.leaveRequest,
        ),
      ],
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/employee/employee_profile_placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the employee profile screen.
class EmployeeProfilePlaceholderScreen extends StatelessWidget {
  /// The ID of the employee to display.
  final String? employeeId;
  
  /// Creates a new employee profile placeholder screen.
  const EmployeeProfilePlaceholderScreen({
    Key? key,
    this.employeeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Employee Profile',
      headerColor: Colors.blue,
      description: 'This is a placeholder for the employee profile screen. '
          'In the actual implementation, this screen would show detailed '
          'information about the employee.\n'
          'Employee ID: ${employeeId ?? 'Current User'}',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Software Developer',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildInfoSection('Personal Information'),
            _buildInfoItem('Email', 'john.doe@example.com'),
            _buildInfoItem('Phone', '+1 234 567 8901'),
            _buildInfoItem('Date of Birth', '1990-01-01'),
            _buildInfoItem('Address', '123 Main St, Anytown, AN 12345'),
            const SizedBox(height: 16),
            _buildInfoSection('Employment Details'),
            _buildInfoItem('Employee ID', employeeId ?? 'EMP001'),
            _buildInfoItem('Department', 'Engineering'),
            _buildInfoItem('Join Date', '2023-01-15'),
            _buildInfoItem('Manager', 'Jane Smith'),
            const SizedBox(height: 16),
          ],
        ),
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        PlaceholderNavButton(
          label: 'Edit Profile',
          route: RouteConstants.editProfile,
          arguments: employeeId ?? 'EMP001',
        ),
      ],
    );
  }
  
  /// Builds a section header for the profile information.
  Widget _buildInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
  
  /// Builds an information item with label and value.
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
```

```dart
// File: lib/core/presentation/placeholders/admin/admin_dashboard_placeholder_screen.dart

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
      headerColor: Colors.red,
      description: 'This is a placeholder for the admin dashboard. '
          'In the actual implementation, this screen would show administrative '
          'controls and summary data for the organization.',
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          _buildAdminTile(
            'User Management',
            Icons.people,
            Colors.purple,
          ),
          _buildAdminTile(
            'Reports',
            Icons.bar_chart,
            Colors.orange,
          ),
          _buildAdminTile(
            'Settings',
            Icons.settings,
            Colors.blue,
          ),
          _buildAdminTile(
            'System Logs',
            Icons.list_alt,
            Colors.green,
          ),
        ],
      ),
      navigationButtons: [
        const PlaceholderNavButton(
          label: 'Back to Home',
          route: RouteConstants.home,
        ),
        const PlaceholderNavButton(
          label: 'Admin Settings',
          route: RouteConstants.adminSettings,
        ),
      ],
    );
  }
  
  /// Builds an admin feature tile for the dashboard grid.
  Widget _buildAdminTile(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 5. Updating the AppRouterImpl Class

Update the `app_router_impl.dart` file to include all route definitions with the placeholder screens:

```dart
// File: lib/core/routing/app_router_impl.dart (update)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';

// Import placeholder screens
import 'package:hr_connect/core/presentation/placeholders/core/splash_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/core/login_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/core/home_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/attendance/qr_scanner_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/attendance/attendance_history_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/time_management/leave_request_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/time_management/leave_history_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/employee/employee_profile_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/placeholders/admin/admin_dashboard_placeholder_screen.dart';

/// Implementation of [AppRouter] using go_router.
@Singleton(as: AppRouter)
class AppRouterImpl implements AppRouter {
  // [... Keep existing code from previous task ...]
  
  /// Builds the route configuration.
  List<RouteBase> _buildRoutes() {
    return [
      // Core routes
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
      
      // Attendance feature routes
      GoRoute(
        path: RouteConstants.qrScanner,
        name: 'qrScanner',
        builder: (context, state) => const QrScannerPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.attendanceHistory,
        name: 'attendanceHistory',
        builder: (context, state) => const AttendanceHistoryPlaceholderScreen(),
      ),
      
      // Time management feature routes
      GoRoute(
        path: RouteConstants.leaveRequest,
        name: 'leaveRequest',
        builder: (context, state) => const LeaveRequestPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.leaveHistory,
        name: 'leaveHistory',
        builder: (context, state) => const LeaveHistoryPlaceholderScreen(),
      ),
      
      // Employee profile feature routes
      GoRoute(
        path: RouteConstants.employeeProfile,
        name: 'employeeProfile',
        builder: (context, state) {
          final employeeId = state.extra as String?;
          return EmployeeProfilePlaceholderScreen(employeeId: employeeId);
        },
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        name: 'editProfile',
        builder: (context, state) {
          final employeeId = state.extra as String;
          // Using EmployeeProfilePlaceholderScreen as a placeholder for edit screen too
          return EmployeeProfilePlaceholderScreen(employeeId: employeeId);
        },
      ),
      
      // Admin feature routes
      GoRoute(
        path: RouteConstants.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardPlaceholderScreen(),
      ),
      GoRoute(
        path: RouteConstants.adminSettings,
        name: 'adminSettings',
        // Using AdminDashboardPlaceholderScreen as a placeholder for settings too
        builder: (context, state) => const AdminDashboardPlaceholderScreen(),
      ),
    ];
  }
  
  // [... Keep rest of the code from previous task ...]
}
```

### 6. Testing the Routes

#### 6.1 Run the Application

Run the application to test the routing:

```bash
flutter run
```

#### 6.2 Manual Testing Checklist

1. **Check Initial Route**: The application should start at the splash screen.
2. **Test Basic Navigation**: Use the navigation buttons on each placeholder screen to navigate between screens.
3. **Test Parameter Passing**: Verify that parameters are passed correctly (e.g., employee ID to profile screen).
4. **Test Route Guards**: Currently, the route guards are placeholders that allow all navigation. In a future task, these will be implemented properly.
5. **Test Error Handling**: Try invalid routes to test the error handling.

#### 6.3 Update Test Cases

Update the test for AppRouterImpl to include the new routes:

```dart
// File: test/core/routing/app_router_impl_test.dart (update)

// [... Keep existing code from previous task ...]

group('AppRouterImpl', () {
  // [... Keep existing tests from previous task ...]
  
  test('should have all expected routes defined', () {
    // Access the private _router field using reflection (for testing only)
    final routerConfig = router.config as GoRouter;
    
    // Check for presence of routes (simplified test)
    expect(routerConfig.routerDelegate.configuration.routes.length, greaterThanOrEqualTo(11));
    
    // Verify some specific routes exist
    expect(router.currentRoute, equals(RouteConstants.splash));
    
    // We can't directly test navigation in a unit test,
    // but we can verify the router has routes for all constants
    final routes = RouteConstants.runtimeType.toString();
    expect(routes.contains('splash'), isTrue);
    expect(routes.contains('login'), isTrue);
    expect(routes.contains('home'), isTrue);
    expect(routes.contains('qrScanner'), isTrue);
    expect(routes.contains('employeeProfile'), isTrue);
    expect(routes.contains('adminDashboard'), isTrue);
  });
});
```

### 7. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-004-04**: Implement navigation helpers and extension methods

This next task will involve enhancing the navigation system with helper methods and extensions to make navigation more type-safe and convenient.

In subsequent tasks, these placeholder screens will be replaced with actual feature implementations, but they provide a solid foundation for testing the routing system.

### 8. Conclusion

You have now set up initial route definitions with placeholder screens for the HR Connect application. This implementation:

- Creates a consistent structure for placeholder screens
- Provides a visual way to test navigation between screens
- Sets up the route definitions in the AppRouterImpl class
- Allows testing the routing system before implementing the actual features

This foundation will support the development of the actual feature screens in later tasks, while providing immediate validation of the routing infrastructure.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the routing system, particularly regarding proper typing, documentation, and architecture principles.
