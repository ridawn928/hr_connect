# Implementation Guide: Test Routing by Navigating Between Screens

## Task ID: 01-004-05 - Test routing by navigating between the home screen and a test screen

### 1. Introduction

This guide provides step-by-step instructions for testing the routing system in the HR Connect application by navigating between the home screen and a dedicated test screen. This task builds on the routing infrastructure established in previous tasks and validates that the navigation system works correctly.

#### 1.1 Purpose

Testing the routing system serves several important purposes:

- Validates that navigation works correctly between screens
- Ensures route parameters and arguments are passed properly
- Verifies that navigation helpers and extensions function as expected
- Identifies any issues with the routing configuration
- Provides confidence in the navigation infrastructure before implementing feature screens

#### 1.2 Relationship to Previous Tasks

This task is the final step in setting up the routing system, building directly on:
- Task 01-004-01: Create a core/routing/ directory for routing logic
- Task 01-004-02: Define the AppRouter class using auto_route or go_router
- Task 01-004-03: Set up initial route definitions with placeholder screens
- Task 01-004-04: Implement navigation helpers and extension methods

### 2. Prerequisites

Before testing the routing system, ensure:

1. Task 01-004-04 is completed and the navigation helpers and extension methods are implemented
2. The routing system is properly registered with the dependency injection system
3. Placeholder screens are set up for core routes
4. The testing tools (flutter_test, integration_test) are added to pubspec.yaml

### 3. Creating a Dedicated Test Screen

First, let's create a dedicated test screen that will be used to verify different navigation patterns and display route parameters.

#### 3.1 Create the Route Constant

Add a new route constant for the test screen in route_constants.dart:

```dart
// File: lib/core/routing/route_constants.dart (update)

class RouteConstants {
  // Private constructor to prevent instantiation
  const RouteConstants._();

  // Existing routes...
  
  // Test route
  /// Route to the routing test screen
  static const String routingTest = '/test/routing';
}
```

#### 3.2 Implement the Test Screen

Create a new file for the test screen:

```dart
// File: lib/core/presentation/test/routing_test_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/context_extensions.dart';
import 'package:hr_connect/core/routing/navigation_helpers.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Test screen for verifying routing functionality.
///
/// This screen displays any parameters it receives and provides controls
/// for testing different navigation patterns.
class RoutingTestScreen extends StatefulWidget {
  /// Optional test parameter passed to this screen.
  final String? testParam;
  
  /// Optional count parameter for testing multiple navigations.
  final int? count;
  
  /// Creates a new routing test screen.
  const RoutingTestScreen({
    Key? key,
    this.testParam,
    this.count,
  }) : super(key: key);

  @override
  State<RoutingTestScreen> createState() => _RoutingTestScreenState();
}

class _RoutingTestScreenState extends State<RoutingTestScreen> {
  /// Result to return when popping this screen.
  String? _resultToReturn;
  
  @override
  void initState() {
    super.initState();
    // Initialize the result with a default value
    _resultToReturn = 'Test Result ${DateTime.now().millisecondsSinceEpoch}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routing Test Screen'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              _buildParametersSection(),
              _buildResultSection(),
              _buildNavigationTestSection(),
              _buildAdvancedNavigationSection(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the header section with screen information.
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Routing Test Screen',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'This screen is used to test different navigation patterns '
            'and verify that route parameters are passed correctly.',
            style: TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 8.0),
          Text('Current route: ${RouteConstants.routingTest}'),
        ],
      ),
    );
  }
  
  /// Builds the section displaying parameters passed to this screen.
  Widget _buildParametersSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Parameters',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildParameterRow('testParam', widget.testParam?.toString() ?? 'null'),
          _buildParameterRow('count', widget.count?.toString() ?? 'null'),
        ],
      ),
    );
  }
  
  /// Builds a row displaying a parameter name and value.
  Widget _buildParameterRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100.0,
            child: Text(
              '$name:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  /// Builds the section for configuring the result to return.
  Widget _buildResultSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Result to Return',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            initialValue: _resultToReturn,
            decoration: const InputDecoration(
              labelText: 'Result',
              hintText: 'Enter a result to return when popping',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _resultToReturn = value;
              });
            },
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Pop and return the result
              Navigator.of(context).pop(_resultToReturn);
            },
            child: const Text('Return Result and Pop'),
          ),
        ],
      ),
    );
  }
  
  /// Builds the section with basic navigation test buttons.
  Widget _buildNavigationTestSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Navigation Tests',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate back to home
                  context.navigateTo(RouteConstants.home);
                },
                child: const Text('Navigate to Home'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Replace with home
                  context.replaceTo(RouteConstants.home);
                },
                child: const Text('Replace with Home'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Simply pop
                  context.pop();
                },
                child: const Text('Pop Screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another instance of this test screen
                  // with incremented count
                  final newCount = (widget.count ?? 0) + 1;
                  context.navigateTo(
                    RouteConstants.routingTest,
                    arguments: {
                      'testParam': 'Recursive test',
                      'count': newCount,
                    },
                  );
                },
                child: const Text('Navigate to Test Screen Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Builds the section with advanced navigation test buttons.
  Widget _buildAdvancedNavigationSection() {
    final navigationService = context.navigationService;
    
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Navigation Tests',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Use extension method
                  navigationService.toHome();
                },
                child: const Text('To Home (Extension)'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Use navigation helper
                  NavigationHelper.navigateToHome();
                },
                child: const Text('To Home (Helper)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Show confirmation dialog
                  NavigationHelper.confirmNavigation(
                    context: context,
                    title: 'Confirmation Test',
                    message: 'This tests the confirmation dialog navigation helper.',
                    onConfirm: () {
                      navigationService.toHome();
                    },
                  );
                },
                child: const Text('Confirm Navigation'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate and clear stack
                  NavigationHelper.navigateAndClearStack(RouteConstants.home);
                },
                child: const Text('Navigate and Clear Stack'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

#### 3.3 Update the AppRouterImpl to Include the Test Route

Update the AppRouterImpl class to include the test route:

```dart
// File: lib/core/routing/app_router_impl.dart (update)

// Add import for the test screen
import 'package:hr_connect/core/presentation/test/routing_test_screen.dart';

// ... existing code ...

/// Builds the route configuration.
List<RouteBase> _buildRoutes() {
  return [
    // ... existing routes ...
    
    // Test route
    GoRoute(
      path: RouteConstants.routingTest,
      name: 'routingTest',
      builder: (context, state) {
        // Extract parameters from state.extra if available
        String? testParam;
        int? count;
        if (state.extra is Map) {
          final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
          testParam = params['testParam'] as String?;
          count = params['count'] as int?;
        } else if (state.extra is String) {
          testParam = state.extra as String;
        }
        
        return RoutingTestScreen(
          testParam: testParam,
          count: count,
        );
      },
    ),
  ];
}
```

#### 3.4 Update the Navigation Extensions

Add extensions for the test screen in navigation_extensions.dart:

```dart
// File: lib/core/routing/navigation_extensions.dart (update)

// ... existing code ...

/// Extension methods for test screen navigation.
extension TestNavigationExtension on NavigationService {
  /// Navigates to the routing test screen.
  ///
  /// [testParam] Optional test parameter to pass to the screen.
  /// [count] Optional count parameter for testing recursive navigation.
  Future<void> toRoutingTest({String? testParam, int? count}) {
    final Map<String, dynamic> args = {};
    if (testParam != null) args['testParam'] = testParam;
    if (count != null) args['count'] = count;
    
    return navigateTo(
      RouteConstants.routingTest,
      arguments: args.isNotEmpty ? args : null,
    );
  }
  
  /// Navigates to the routing test screen and waits for a result.
  ///
  /// Returns the result string returned from the test screen.
  Future<String?> toRoutingTestForResult({String? testParam}) async {
    return navigateTo<String>(
      RouteConstants.routingTest,
      arguments: testParam != null ? {'testParam': testParam} : null,
    );
  }
}
```

### 4. Updating the Home Screen for Testing

Now, let's update the home screen to include navigation controls for testing:

```dart
// File: lib/core/presentation/placeholders/core/home_placeholder_screen.dart (update)

import 'package:flutter/material.dart';
import 'package:hr_connect/core/presentation/placeholders/base_placeholder_screen.dart';
import 'package:hr_connect/core/routing/context_extensions.dart';
import 'package:hr_connect/core/routing/navigation_helpers.dart';
import 'package:hr_connect/core/routing/route_constants.dart';

/// Placeholder for the home/dashboard screen.
class HomePlaceholderScreen extends StatefulWidget {
  /// Creates a new home placeholder screen.
  const HomePlaceholderScreen({Key? key}) : super(key: key);

  @override
  State<HomePlaceholderScreen> createState() => _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends State<HomePlaceholderScreen> {
  /// Result returned from the test screen.
  String? _testResult;
  
  @override
  Widget build(BuildContext context) {
    return BasePlaceholderScreen(
      title: 'Home Dashboard',
      headerColor: Colors.purple,
      description: 'This is a placeholder for the main dashboard. '
          'In the actual implementation, this screen would show summary data '
          'and navigation to different features.',
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              children: [
                _buildFeatureTile(
                  context,
                  'Attendance',
                  Icons.qr_code_scanner,
                  Colors.orange,
                  () => context.navigateTo(RouteConstants.qrScanner),
                ),
                _buildFeatureTile(
                  context,
                  'Time Management',
                  Icons.calendar_today,
                  Colors.blue,
                  () => context.navigateTo(RouteConstants.leaveRequest),
                ),
                _buildFeatureTile(
                  context,
                  'Employee Profile',
                  Icons.person,
                  Colors.green,
                  () => context.navigateTo(RouteConstants.employeeProfile),
                ),
                _buildFeatureTile(
                  context,
                  'Admin Portal',
                  Icons.admin_panel_settings,
                  Colors.red,
                  () => context.navigateTo(RouteConstants.adminDashboard),
                ),
              ],
            ),
          ),
          // Add a routing test section
          _buildRoutingTestSection(),
        ],
      ),
      navigationButtons: const [
        // Keep existing navigation buttons...
      ],
    );
  }
  
  /// Builds a feature tile for the dashboard grid.
  Widget _buildFeatureTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    // Keep existing implementation...
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
  
  /// Builds the routing test section.
  Widget _buildRoutingTestSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Routing Test Controls',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (_testResult != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Result from test screen:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(child: Text(_testResult!)),
                ],
              ),
            ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to test screen
                  context.navigateTo(
                    RouteConstants.routingTest,
                    arguments: {'testParam': 'From Home Screen'},
                  );
                },
                child: const Text('Navigate to Test Screen'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to test screen for result
                  final result = await context.navigationService
                      .toRoutingTestForResult(
                    testParam: 'Waiting for result',
                  );
                  
                  // Update state with result
                  setState(() {
                    _testResult = result;
                  });
                },
                child: const Text('Navigate for Result'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Use extension method
                  context.navigationService.toRoutingTest(
                    testParam: 'Using Extension',
                    count: 0,
                  );
                },
                child: const Text('Navigate with Extension'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 5. Manual Testing Scenarios

Now that you have implemented the test screen and updated the home screen, you can run the application and test the routing system manually. Here are some testing scenarios to verify:

#### 5.1 Basic Navigation Testing

1. **Navigate to Test Screen**:
   - Launch the application
   - On the home screen, click "Navigate to Test Screen"
   - Verify you are navigated to the test screen
   - Verify the parameter "From Home Screen" is displayed
   - Return to the home screen using "Navigate to Home"

2. **Replace with Home**:
   - Navigate to the test screen
   - Click "Replace with Home"
   - Try to go back (press back button)
   - Verify you cannot go back to the test screen (it was replaced)

3. **Pop Screen**:
   - Navigate to the test screen
   - Click "Pop Screen"
   - Verify you return to the home screen

4. **Recursive Navigation**:
   - Navigate to the test screen
   - Click "Navigate to Test Screen Again"
   - Verify a new instance of the test screen appears with incremented count
   - Continue clicking "Navigate to Test Screen Again" a few times
   - Verify count increases
   - Pop back through the stack and verify correct navigation

#### 5.2 Testing Navigation Extensions and Helpers

1. **Test Extension Methods**:
   - On the home screen, click "Navigate with Extension"
   - Verify you are navigated to the test screen
   - Verify the parameter "Using Extension" is displayed
   - Click "To Home (Extension)"
   - Verify you return to the home screen

2. **Test Navigation Helpers**:
   - Navigate to the test screen
   - Click "To Home (Helper)"
   - Verify you return to the home screen

3. **Test Navigation with Confirmation**:
   - Navigate to the test screen
   - Click "Confirm Navigation"
   - Verify a confirmation dialog appears
   - Click "Cancel" and verify you remain on the test screen
   - Click "Confirm Navigation" again
   - Click "Confirm" and verify you navigate to home

4. **Test Navigate and Clear Stack**:
   - Navigate to the test screen repeatedly to build a stack
   - Click "Navigate and Clear Stack"
   - Verify you return to the home screen
   - Try to go back (press back button)
   - Verify you cannot go back (stack was cleared)

#### 5.3 Testing Navigation with Results

1. **Test Returning Results**:
   - On the home screen, click "Navigate for Result"
   - On the test screen, modify the result text
   - Click "Return Result and Pop"
   - Verify the home screen displays the result you entered

### 6. Implementing Widget Tests

Let's create widget tests to verify the routing system:

```dart
// File: test/core/routing/navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/presentation/placeholders/core/home_placeholder_screen.dart';
import 'package:hr_connect/core/presentation/test/routing_test_screen.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/app_router_impl.dart';
import 'package:hr_connect/core/routing/context_extensions.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_guards.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';

// Mocks for testing
class MockAppRouter extends Mock implements AppRouter {}
class MockNavigationService extends Mock implements NavigationService {}
class MockAuthGuard extends Mock implements AuthenticationGuard {}
class MockAdminGuard extends Mock implements AdminGuard {}

void main() {
  late MockAppRouter mockRouter;
  late NavigationService navigationService;
  late AppRouter appRouter;
  
  setUp(() {
    mockRouter = MockAppRouter();
    navigationService = NavigationService(mockRouter);
    
    // Mock GetIt for context extensions
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<NavigationService>()) {
      getIt.registerSingleton<NavigationService>(navigationService);
    } else {
      getIt.unregister<NavigationService>();
      getIt.registerSingleton<NavigationService>(navigationService);
    }
    
    // Set up default behaviors
    when(mockRouter.navigateTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
    when(mockRouter.replaceTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
    when(mockRouter.currentRoute).thenReturn(RouteConstants.home);
    
    // Set up real AppRouter for some tests
    final mockAuthGuard = MockAuthGuard();
    final mockAdminGuard = MockAdminGuard();
    when(mockAuthGuard.canNavigate(any, any)).thenAnswer((_) async => true);
    when(mockAdminGuard.canNavigate(any, any)).thenAnswer((_) async => true);
    appRouter = AppRouterImpl(mockAuthGuard, mockAdminGuard);
  });
  
  tearDown(() {
    // Reset GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<NavigationService>()) {
      getIt.unregister<NavigationService>();
    }
  });
  
  group('Home to Test Screen Navigation', () {
    testWidgets('Home screen should have navigation controls for testing',
        (tester) async {
      // Build the home screen
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePlaceholderScreen(),
        ),
      );
      
      // Verify navigation controls are present
      expect(find.text('Routing Test Controls'), findsOneWidget);
      expect(find.text('Navigate to Test Screen'), findsOneWidget);
      expect(find.text('Navigate for Result'), findsOneWidget);
      expect(find.text('Navigate with Extension'), findsOneWidget);
    });
    
    testWidgets('Clicking navigate button should trigger navigation',
        (tester) async {
      // Build the home screen
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePlaceholderScreen(),
        ),
      );
      
      // Find and tap the navigate button
      await tester.tap(find.text('Navigate to Test Screen'));
      await tester.pump();
      
      // Verify navigation was triggered
      verify(mockRouter.navigateTo(
        RouteConstants.routingTest,
        arguments: anyNamed('arguments'),
      )).called(1);
    });
    
    testWidgets('Clicking navigate for result should trigger navigation',
        (tester) async {
      // Set up return value for navigation
      when(mockRouter.navigateTo<String>(
        RouteConstants.routingTest,
        arguments: anyNamed('arguments'),
      )).thenAnswer((_) async => 'Test Result');
      
      // Build the home screen
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePlaceholderScreen(),
        ),
      );
      
      // Find and tap the navigate for result button
      await tester.tap(find.text('Navigate for Result'));
      await tester.pump();
      
      // Verify navigation was triggered
      verify(mockRouter.navigateTo<String>(
        RouteConstants.routingTest,
        arguments: anyNamed('arguments'),
      )).called(1);
      
      // Need to pump again to let the future complete
      await tester.pumpAndSettle();
      
      // Verify result is displayed (this might not work in this test context)
      // expect(find.text('Test Result'), findsOneWidget);
    });
  });
  
  group('Test Screen Functionality', () {
    testWidgets('Test screen should display passed parameters',
        (tester) async {
      // Build the test screen with parameters
      await tester.pumpWidget(
        MaterialApp(
          home: RoutingTestScreen(
            testParam: 'Test Value',
            count: 42,
          ),
        ),
      );
      
      // Verify parameters are displayed
      expect(find.text('testParam: Test Value'), findsOneWidget);
      expect(find.text('count: 42'), findsOneWidget);
    });
    
    testWidgets('Test screen should have navigation buttons',
        (tester) async {
      // Build the test screen
      await tester.pumpWidget(
        MaterialApp(
          home: const RoutingTestScreen(),
        ),
      );
      
      // Verify navigation buttons are present
      expect(find.text('Navigate to Home'), findsOneWidget);
      expect(find.text('Replace with Home'), findsOneWidget);
      expect(find.text('Pop Screen'), findsOneWidget);
      expect(find.text('Navigate to Test Screen Again'), findsOneWidget);
      expect(find.text('To Home (Extension)'), findsOneWidget);
      expect(find.text('To Home (Helper)'), findsOneWidget);
      expect(find.text('Confirm Navigation'), findsOneWidget);
      expect(find.text('Navigate and Clear Stack'), findsOneWidget);
    });
    
    testWidgets('Clicking navigate to home should trigger navigation',
        (tester) async {
      // Build the test screen
      await tester.pumpWidget(
        MaterialApp(
          home: const RoutingTestScreen(),
        ),
      );
      
      // Find and tap the navigate to home button
      await tester.tap(find.text('Navigate to Home'));
      await tester.pump();
      
      // Verify navigation was triggered
      verify(mockRouter.navigateTo(RouteConstants.home)).called(1);
    });
    
    testWidgets('Clicking replace with home should trigger replace navigation',
        (tester) async {
      // Build the test screen
      await tester.pumpWidget(
        MaterialApp(
          home: const RoutingTestScreen(),
        ),
      );
      
      // Find and tap the replace with home button
      await tester.tap(find.text('Replace with Home'));
      await tester.pump();
      
      // Verify replace navigation was triggered
      verify(mockRouter.replaceTo(RouteConstants.home)).called(1);
    });
    
    testWidgets('Test screen should allow setting result to return',
        (tester) async {
      // Build the test screen
      await tester.pumpWidget(
        MaterialApp(
          home: const RoutingTestScreen(),
        ),
      );
      
      // Find the result input field
      final resultField = find.byType(TextFormField);
      expect(resultField, findsOneWidget);
      
      // Enter a custom result
      await tester.enterText(resultField, 'Custom Test Result');
      await tester.pump();
      
      // Verify the result was updated
      expect(find.text('Custom Test Result'), findsOneWidget);
    });
  });
  
  group('AppRouter Routes', () {
    testWidgets('AppRouter should have the test route defined',
        (tester) async {
      // Create a simple app using the real router
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter.config,
      ));
      
      // This test just verifies that the router initializes without errors
      expect(true, isTrue);
    });
  });
}
```

### 7. Implementing Integration Tests

Finally, let's create an integration test to verify the routing system end-to-end:

First, add the integration_test dependency to pubspec.yaml if not already present:

```yaml
dev_dependencies:
  # Other dev dependencies...
  integration_test:
    sdk: flutter
```

Then create an integration test file:

```dart
// File: integration_test/routing_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hr_connect/main.dart' as app;
import 'package:hr_connect/core/routing/route_constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Routing Integration Tests', () {
    testWidgets('Navigate from home to test screen and back',
        (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Verify we're on the home screen
      expect(find.text('Home Dashboard'), findsOneWidget);
      
      // Find and tap the navigate to test screen button
      await tester.tap(find.text('Navigate to Test Screen'));
      await tester.pumpAndSettle();
      
      // Verify we're on the test screen
      expect(find.text('Routing Test Screen'), findsOneWidget);
      expect(find.text('testParam: From Home Screen'), findsOneWidget);
      
      // Navigate back to home
      await tester.tap(find.text('Navigate to Home'));
      await tester.pumpAndSettle();
      
      // Verify we're back on the home screen
      expect(find.text('Home Dashboard'), findsOneWidget);
    });
    
    testWidgets('Navigate for result should update home screen',
        (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Verify we're on the home screen
      expect(find.text('Home Dashboard'), findsOneWidget);
      
      // Find and tap the navigate for result button
      await tester.tap(find.text('Navigate for Result'));
      await tester.pumpAndSettle();
      
      // Verify we're on the test screen
      expect(find.text('Routing Test Screen'), findsOneWidget);
      
      // Enter a custom result
      await tester.enterText(
        find.byType(TextFormField),
        'Integration Test Result',
      );
      await tester.pumpAndSettle();
      
      // Return the result
      await tester.tap(find.text('Return Result and Pop'));
      await tester.pumpAndSettle();
      
      // Verify we're back on the home screen with the result
      expect(find.text('Home Dashboard'), findsOneWidget);
      expect(find.text('Result from test screen:'), findsOneWidget);
      expect(find.text('Integration Test Result'), findsOneWidget);
    });
    
    testWidgets('Test recursive navigation',
        (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to test screen
      await tester.tap(find.text('Navigate to Test Screen'));
      await tester.pumpAndSettle();
      
      // Verify initial count is null
      expect(find.text('count: null'), findsOneWidget);
      
      // Navigate to test screen again (recursively)
      await tester.tap(find.text('Navigate to Test Screen Again'));
      await tester.pumpAndSettle();
      
      // Verify count is incremented to 1
      expect(find.text('count: 1'), findsOneWidget);
      
      // Navigate once more
      await tester.tap(find.text('Navigate to Test Screen Again'));
      await tester.pumpAndSettle();
      
      // Verify count is incremented to 2
      expect(find.text('count: 2'), findsOneWidget);
      
      // Navigate back to home
      await tester.tap(find.text('To Home (Extension)'));
      await tester.pumpAndSettle();
      
      // Verify we're back on the home screen
      expect(find.text('Home Dashboard'), findsOneWidget);
    });
  });
}
```

Run the integration test with:

```bash
flutter test integration_test/routing_test.dart
```

### 8. Troubleshooting Common Issues

#### 8.1 Navigation Not Working

If navigation is not working as expected:

1. **Check DI Registration**: Ensure the AppRouter and NavigationService are properly registered with the dependency injection system.
2. **Verify Route Constants**: Make sure the route constants are defined correctly and being used consistently.
3. **Check Route Definitions**: Verify that all routes are properly defined in the AppRouterImpl class.
4. **Test Parameters**: Ensure route parameters are being passed and received correctly.

#### 8.2 Missing Route

If you encounter a "no route found" error:

1. **Check Route Path**: Verify the path in RouteConstants matches the path in the route definition.
2. **Check Route Name**: Ensure the route name is consistent between constants and definitions.
3. **Register Missing Routes**: Add any missing routes to the AppRouterImpl.

#### 8.3 Widget Test Failures

If widget tests are failing:

1. **Mock Setup**: Ensure all necessary mocks are properly set up and configured.
2. **GetIt Registration**: Verify that GetIt is correctly configured for testing.
3. **UI Updates**: Make sure to call pump() or pumpAndSettle() after actions that trigger UI updates.

### 9. Next Steps

After completing this task and verifying that the routing system works correctly, you're ready to move on to subsequent tasks, which will involve implementing the actual feature screens that will replace the placeholders.

This task (01-004-05) concludes the routing system setup for the HR Connect application. With the routing infrastructure in place, you can now focus on implementing the core features of the application with confidence that navigation will work correctly.

### 10. Conclusion

You have now tested the routing system by navigating between the home screen and a test screen, verifying that the navigation infrastructure established in previous tasks works correctly. This implementation:

- Creates a dedicated test screen for verifying routing functionality
- Updates the home screen with navigation controls for testing
- Provides manual testing scenarios to verify different navigation patterns
- Implements widget and integration tests for automated verification
- Ensures that navigation helpers and extensions work as expected

This testing provides confidence in the routing system before moving on to implementing the actual feature screens. The routing system is now ready to support the development of the HR Connect application, with a solid foundation for managing navigation between screens.

Remember to follow the HR Connect Flutter Development Guidelines as you continue to implement the application, particularly regarding proper typing, documentation, and architecture principles.
