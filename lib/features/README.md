# Features Module

This directory contains feature-specific modules for the HR Connect application, following the Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach.

## Structure

- **attendance/**: QR code attendance system
- **time_management/**: Leave and request management
- **employee/**: Employee profile management
- **admin/**: Administrative portals
- **authentication/**: User authentication and device management

## Architecture

Each feature represents a vertical slice of the application with its own:
- Domain layer (entities, repositories, use cases)
- Data layer (models, repository implementations, data sources)
- Presentation layer (screens, widgets, state management)

Features depend on shared infrastructure in the core module but remain independent of each other.

## Development Guidelines

- Keep feature code isolated within its directory
- Use dependency injection to resolve dependencies
- Follow Clean Architecture principles within each feature
- Implement test-driven development as specified in the PRD 