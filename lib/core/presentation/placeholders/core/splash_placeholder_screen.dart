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
      navigationButtons: const [
        PlaceholderNavButton(
          label: 'Go to Login',
          route: RouteConstants.login,
        ),
        PlaceholderNavButton(
          label: 'Go to Home',
          route: RouteConstants.home,
        ),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'HR Connect',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Workforce Management Solution',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
} 