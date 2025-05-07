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