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
          'In the actual implementation, this screen would contain '
          'login forms, authentication logic, and social login options.',
      navigationButtons: const [
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
              Icons.login,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            _buildTextField('Email', Icons.email),
            const SizedBox(height: 16),
            _buildTextField('Password', Icons.lock, isPassword: true),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a form text field with the given label and icon.
  Widget _buildTextField(String label, IconData icon, {bool isPassword = false}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          border: InputBorder.none,
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
} 