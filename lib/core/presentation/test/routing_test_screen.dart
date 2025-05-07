// File: lib/core/presentation/test/routing_test_screen.dart

import 'package:flutter/material.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/di/service_locator.dart';
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
  final NavigationService _navigationService = getIt<NavigationService>();
  final TextEditingController _paramController = TextEditingController();
  String? _navigationResult;

  @override
  void initState() {
    super.initState();
    _paramController.text = widget.testParam ?? '';
    
    // For testing recursive navigation
    if (widget.count != null && widget.count! > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigationService.toRoutingTest(
          testParam: 'Recursive navigation ${widget.count}',
          count: widget.count! - 1,
        );
      });
    }
  }

  @override
  void dispose() {
    _paramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routing Test Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildNavigationControls(),
            if (_navigationResult != null) _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Parameters:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('testParam: ${widget.testParam ?? 'null'}'),
            Text('count: ${widget.count ?? 'null'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Navigation Tests:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paramController,
              decoration: const InputDecoration(
                labelText: 'Test Parameter',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateBasic,
                    child: const Text('Simple Navigation'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateForResult,
                    child: const Text('Navigation For Result'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateRecursive,
                    child: const Text('Recursive Navigation (3 levels)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Return value from test screen'),
                    child: const Text('Return Result & Pop'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _navigateToHome,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Go To Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Card(
      color: Colors.lightGreen[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Navigation Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(_navigationResult!),
          ],
        ),
      ),
    );
  }

  void _navigateBasic() {
    _navigationService.toRoutingTest(
      testParam: _paramController.text.isNotEmpty ? _paramController.text : null,
    );
  }

  Future<void> _navigateForResult() async {
    final result = await _navigationService.toRoutingTestForResult(
      testParam: _paramController.text.isNotEmpty ? _paramController.text : null,
    );
    
    setState(() {
      _navigationResult = result ?? 'No result returned';
    });
  }

  void _navigateRecursive() {
    _navigationService.toRoutingTest(
      testParam: _paramController.text.isNotEmpty ? _paramController.text : 'Recursive test',
      count: 3,
    );
  }

  void _navigateToHome() {
    _navigationService.navigateTo(RouteConstants.home);
  }
} 