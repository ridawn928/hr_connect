# Presentation Layer

This directory contains the presentation layer for the attendance feature. The presentation layer handles UI components and user interaction.

## Structure

- **screens/**: Full-page UI components
  - Complete screens composed of multiple widgets
  - Handle layout and screen-level state

- **widgets/**: Reusable UI components
  - Smaller, focused components
  - Reusable across different screens

- **providers/**: Riverpod state management
  - State providers and notifiers
  - Connect domain use cases to UI

- **pages/**: Page routes and navigation
  - Route definitions
  - Navigation logic

## Dependencies

The presentation layer:
- Can depend ONLY on the domain layer and the core module
- Cannot depend on the data layer
- Can use Flutter widgets and UI packages

## Usage Guidelines

- Keep UI components focused on presentation concerns
- Use providers to handle state management
- Call domain use cases directly, not repositories
- Follow Flutter's composition pattern for widget construction 