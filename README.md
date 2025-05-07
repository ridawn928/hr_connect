# HR Connect

A comprehensive mobile workforce management solution with offline-first architecture.

## Project Overview

HR Connect is a mobile workforce management application designed to streamline HR processes including attendance tracking via QR codes, leave management, employee profiles, and administrative functions. It features a robust offline-first architecture that allows for full functionality even without an internet connection for up to 7 days.

## Key Features

- **QR Code Attendance System**: Time-based QR codes with embedded timestamps and digital signatures
- **Comprehensive Time Management**: Leave requests, overtime tracking, and approval workflows
- **Employee Profile Management**: CRUD operations, document upload, and performance tracking
- **Administrative Portals**: Payroll Portal and HR Portal with role-based access
- **Offline-First Architecture**: Complete functionality without internet for up to 7 days
- **Robust Synchronization**: Background syncing with conflict resolution

## Architecture

HR Connect follows a Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach:
- **Core Module**: Shared infrastructure, utilities, and base classes
- **Features Module**: Business capabilities organized in vertical slices

Each feature implements Clean Architecture with three layers:
- **Domain Layer**: Business logic, entities, and rules
- **Data Layer**: Data access and persistence
- **Presentation Layer**: UI components and user interaction

## Directory Structure

```
lib/
  ├── core/                 # Shared infrastructure
  │   ├── di/               # Dependency injection
  │   ├── error/            # Error handling
  │   ├── network/          # Network layer
  │   ├── storage/          # Local storage
  │   ├── utils/            # Utilities
  │   └── security/         # Security foundations
  └── features/             # Business capability slices
      ├── attendance/       # QR attendance system
      ├── time_management/  # Leave and request management
      ├── employee/         # Employee profile management
      ├── admin/            # Administrative portals
      └── authentication/   # Authentication feature
```

Each feature follows the same layer structure:
```
feature/
  ├── domain/               # Business logic
  │   ├── entities/         # Business objects
  │   ├── repositories/     # Repository interfaces
  │   ├── usecases/         # Business operations
  │   └── failures/         # Domain-specific errors
  ├── data/                 # Data access
  │   ├── models/           # Data transfer objects
  │   ├── repositories/     # Repository implementations
  │   ├── datasources/      # Data sources (local/remote)
  │   └── mappers/          # Entity-model mappers
  └── presentation/         # User interface
      ├── screens/          # Full-page UI
      ├── widgets/          # Reusable UI components
      ├── providers/        # State management
      └── pages/            # Navigation
```

## Getting Started

### Prerequisites
- Flutter 3.29+
- Dart 3.7+
- Firebase account for backend services

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/your-organization/hr_connect.git
   cd hr_connect
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the build_runner for code generation
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the application
   ```bash
   flutter run
   ```

## Development Guidelines

### Coding Standards
- Follow the [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use statically typed variables (avoid 'dynamic' type)
- Keep methods small and focused
- Write comprehensive documentation
- Follow TDD workflow (write tests before implementation)

### Git Workflow
- Use feature branches for all new features and bug fixes
- Make pull requests for all changes
- Require code reviews before merging
- Keep commits atomic and well-described

### Testing
- Maintain high test coverage (minimum 80%)
- Write tests at all levels (unit, widget, integration)
- Test offline functionality thoroughly
- Validate all business rules with appropriate tests

## License

This project is proprietary and confidential. © 2023-2025 Your Organization.
