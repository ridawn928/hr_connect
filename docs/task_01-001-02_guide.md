# HR Connect: Task 01-001-02 Implementation Guide

## Task Information
- **Task ID**: 01-001-02
- **Task Title**: Configure the pubspec.yaml with all required dependencies (see PRD section 8)
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for configuring the `pubspec.yaml` file with all required dependencies for the HR Connect mobile workforce management solution. The `pubspec.yaml` file is a critical component of any Flutter project, as it defines project metadata, dependencies, assets, and other configuration settings.

Proper configuration of dependencies is essential for implementing the Modified Vertical Slice Architecture (MVSA) with an offline-first approach as specified in the HR Connect Product Requirements Document (PRD). This task establishes the foundation for all required functionalities including QR code attendance tracking, offline data synchronization, secure authentication, and Material Design 3 UI components.

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Task 01-001-01: Created a new Flutter project using Flutter 3.29+ and Dart 3.7+

2. **Required Knowledge**:
   - Understanding of Flutter package management
   - Familiarity with the `pubspec.yaml` file structure
   - Basic knowledge of version constraints in Dart/Flutter

3. **Development Environment**:
   - Flutter SDK 3.29+ installed
   - Dart SDK 3.7+ installed
   - Code editor with YAML syntax support

## Understanding pubspec.yaml

The `pubspec.yaml` file serves several important purposes:

1. **Project Metadata**: Defines name, description, and version
2. **SDK Constraints**: Specifies Flutter and Dart version requirements
3. **Dependencies**: Lists all external packages required by the application
4. **Dev Dependencies**: Lists packages needed for development (not included in the final app)
5. **Flutter-specific Configuration**: Configures assets, fonts, and other Flutter settings

For the HR Connect project, dependencies are organized by functional categories to maintain a clear structure aligned with the MVSA pattern.

## Implementation Instructions

Follow these steps to configure the `pubspec.yaml` file with all required dependencies:

### Step 1: Configure Basic Project Information

Start by setting up the basic project metadata:

```yaml
name: hr_connect
description: Comprehensive mobile workforce management solution with offline-first architecture
publish_to: 'none'  # Prevents accidental publishing to pub.dev
version: 1.0.0+1

environment:
  sdk: '>=3.7.0 <4.0.0'  # Ensures Dart 3.7+ as specified in requirements
```

### Step 2: Add Core Framework Dependencies

Add the core Flutter framework dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.2  # Provides iOS-style icons
```

### Step 3: Add Architecture & State Management Dependencies

Add the packages required for implementing the MVSA pattern and state management:

```yaml
  # Architecture and DI
  get_it: ^7.6.0           # Service locator for HR Connect's dependency injection system
  injectable: ^2.1.2       # Generates boilerplate for get_it to simplify DI
  dartz: ^0.10.1           # Implements Either type for error handling in payroll calculations
  equatable: ^2.0.5        # Ensures proper equality comparisons for Employee and Attendance models
  
  # State Management
  riverpod: ^2.6.1         # Core state management for HR Connect as specified in PRD
  flutter_riverpod: ^2.6.1 # Flutter UI integration with Riverpod for employee lists and forms
  riverpod_generator: ^2.6.5 # Generates Provider code to reduce boilerplate
  rxdart: ^0.27.7          # Handles complex attendance event streams
```

### Step 4: Add Local Storage & Offline First Dependencies

Add packages for implementing the offline-first approach and local storage:

```yaml
  # Database and Storage
  drift: ^2.26.1           # Primary HR Connect database for employees, attendance records
  drift_dev: ^2.26.1       # Generates database access code for HR Connect tables
  
  # Flutter Data - Offline First
  flutter_data: ^2.16.0    # Seamless data persistence framework with offline-first capability
  path_provider: ^2.1.1    # Manages paths for local attendance record storage
  
  # Security
  flutter_secure_storage: ^9.2.4  # Securely stores HR Connect authentication tokens
  encrypt: ^5.0.1          # Additional encryption layer for personal employee data
```

### Step 5: Add QR-based Attendance Tracking Dependencies

Add packages for implementing the QR code attendance system:

```yaml
  # QR and Scanning
  mobile_scanner: ^6.0.10  # Core attendance feature for scanning workplace QR codes
  qr_flutter: ^4.1.0       # Generates unique QR codes for each branch office
```

### Step 6: Add Background Processing & Connectivity Dependencies

Add packages for implementing background synchronization and connectivity monitoring:

```yaml
  # Background Processing
  workmanager: ^0.5.2      # Schedules background attendance data synchronization
  connectivity_plus: ^5.0.2 # Detects network state changes to trigger attendance sync
  internet_connection_checker: ^1.0.0+1  # Validates actual internet connectivity
```

### Step 7: Add Authentication & Security Dependencies

Add packages for implementing authentication and security features:

```yaml
  # Authentication
  dart_jsonwebtoken: ^3.2.0  # Implements JWT tokens for HR Connect authentication
  local_auth: ^2.1.6         # Secures access to sensitive employee information
```

### Step 8: Add Cloud Storage & Firebase Integration Dependencies

Add packages for cloud storage and Firebase integration:

```yaml
  # Firebase Core
  firebase_core: ^3.13.0       # Core Firebase functionality for HR Connect
  
  # Cloud Firestore
  cloud_firestore: ^5.6.6      # Primary cloud database for HR Connect employee records
  
  # Firebase Storage
  firebase_storage: ^12.4.5    # Cloud storage solution for HR Connect documents
  
  # Firebase Authentication (Complementary to JWT)
  firebase_auth: ^5.5.2        # Optional cloud authentication provider
  
  # Flutter Data Firestore Adapter
  flutter_data_firestore: ^1.5.0  # Connects Flutter Data to Firebase Firestore
```

### Step 9: Add UI Components & Internationalization Dependencies

Add packages for implementing Material Design 3 UI and internationalization:

```yaml
  # UI Components
  material_design_icons_flutter: ^7.0.7296  # Provides consistent iconography
  data_table_2: ^2.5.6       # Powers employee management tables in admin dashboard
  syncfusion_flutter_charts: ^23.1.36  # Creates attendance trend visualization 
  flutter_form_builder: ^9.1.0  # Handles employee data entry with validation
  table_calendar: ^3.0.9     # Displays employee attendance calendar view
  
  # Internationalization
  intl: ^0.20.2              # Provides multilingual support as required in PRD
```

### Step 10: Add Networking & API Integration Dependencies

Add packages for implementing network communication and API integration:

```yaml
  # Networking
  dio: ^5.3.3                # Primary HTTP client for HR Connect API communication
  http: ^1.1.0               # Secondary HTTP client for simple API calls
```

### Step 11: Add Data Modeling & Serialization Dependencies

Add packages for data modeling and serialization:

```yaml
  # Data Modeling
  freezed_annotation: ^2.2.0  # Creates immutable models for Employee and Attendance entities
  json_annotation: ^4.8.1     # Handles serialization of employee records for API communication
  uuid: ^3.0.7                # Generates unique IDs for attendance records
  
  # Financial Calculations 
  decimal: ^3.2.1             # Provides precise decimal calculations for payroll
  money2: ^6.0.0              # Manages currency formatting and conversion
```

### Step 12: Add Logging & Utilities Dependencies

Add packages for logging and utility functions:

```yaml
  logger: ^2.0.2+1            # Provides structured logging for attendance tracking events
```

### Step 13: Add Development Dependencies

Add packages required for development but not included in the final app:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Linting and Analysis
  flutter_lints: ^3.0.1        # Enforces HR Connect coding standards
  
  # Code Generation
  build_runner: ^2.4.8         # Runs code generation for database, models, and providers
  injectable_generator: ^2.1.6 # Generates dependency injection code for HR services
  freezed: ^2.3.5              # Generates immutable model classes for HR entities
  json_serializable: ^6.7.0    # Generates JSON serialization for API responses
  
  # Testing (TDD approach)
  test: ^1.24.9                # Core testing framework for domain logic
  mockito: ^5.4.4              # Creates mocks for API and database dependencies
  mocktail: ^1.0.1             # Provides simplified mocking for repository testing
  riverpod_test: ^2.3.4        # Tests state management for attendance features
  golden_toolkit: ^1.0.0       # Validates UI appearance against reference designs
  bloc_test: ^9.1.4            # Tests state transitions in feature workflows
  patrol: ^2.3.1               # Performs end-to-end testing of complete workflows
  integration_test:            # Tests full employee attendance workflows
    sdk: flutter
    
  # Deployment Tools
  change_app_package_name: ^1.1.0  # Updates package identifiers for deployment
  envied_generator: ^0.5.2          # Handles environment-specific configuration
```

### Step 14: Configure Flutter-specific Settings

Add Flutter-specific configurations for assets, fonts, and other settings:

```yaml
flutter:
  uses-material-design: true  # Enables Material Design for consistent HR Connect UI
  assets:
    - assets/images/          # Contains employee avatars and company logos
    - assets/icons/           # Stores custom HR-specific icons and attendance status indicators
    - assets/config/          # Holds environment configuration files
    - assets/translations/     # Contains localization files for multilingual support
    
  fonts:
    - family: Roboto          # Primary font family for HR Connect interface
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf  # Standard text in employee listings
        - asset: assets/fonts/Roboto-Medium.ttf   # Section headers and list titles
          weight: 500
        - asset: assets/fonts/Roboto-Bold.ttf     # Important information and confirmations
          weight: 700
```

## Complete pubspec.yaml Reference

Below is the complete `pubspec.yaml` configuration with all required dependencies for the HR Connect project:

```yaml
# HR Connect - Comprehensive mobile workforce management solution
name: hr_connect
description: Comprehensive mobile workforce management solution with offline-first architecture
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.7.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.2

  # Architecture and DI
  get_it: ^7.6.0           # Service locator for HR Connect's dependency injection system
  injectable: ^2.1.2       # Generates boilerplate for get_it to simplify DI in HR Connect
  dartz: ^0.10.1           # Implements Either type for error handling in payroll calculations
  equatable: ^2.0.5        # Ensures proper equality comparisons for Employee and Attendance models
  
  # State Management
  riverpod: ^2.6.1         # Core state management for HR Connect as specified in PRD
  flutter_riverpod: ^2.6.1 # Flutter UI integration with Riverpod for employee lists and forms
  riverpod_generator: ^2.6.5 # Generates Provider code to reduce boilerplate in payroll and reports
  rxdart: ^0.27.7          # Handles complex attendance event streams 

  # Database and Storage
  drift: ^2.26.1           # Primary HR Connect database for employees, attendance records
  drift_dev: ^2.26.1       # Generates database access code for HR Connect tables
  
  # Flutter Data - Offline First
  flutter_data: ^2.16.0    # Seamless data persistence framework with offline-first capability
  path_provider: ^2.1.1    # Manages paths for local attendance record storage
  
  # Security
  flutter_secure_storage: ^9.2.4  # Securely stores HR Connect authentication tokens
  encrypt: ^5.0.1          # Additional encryption layer for personal employee data

  # QR and Scanning
  mobile_scanner: ^6.0.10  # Core attendance feature for scanning workplace QR codes
  qr_flutter: ^4.1.0       # Generates unique QR codes for each branch office
  
  # Background Processing
  workmanager: ^0.5.2      # Schedules background attendance data synchronization
  connectivity_plus: ^5.0.2 # Detects network state changes to trigger attendance sync
  internet_connection_checker: ^1.0.0+1  # Validates actual internet connectivity

  # Authentication
  dart_jsonwebtoken: ^3.2.0  # Implements JWT tokens for HR Connect authentication
  local_auth: ^2.1.6         # Secures access to sensitive employee information
                             
  # Firebase Core
  firebase_core: ^3.13.0       # Core Firebase functionality for HR Connect
  
  # Cloud Firestore
  cloud_firestore: ^5.6.6      # Primary cloud database for HR Connect employee records
  
  # Firebase Storage
  firebase_storage: ^12.4.5    # Cloud storage solution for HR Connect documents
  
  # Firebase Authentication (Complementary to JWT)
  firebase_auth: ^5.5.2        # Optional cloud authentication provider
  
  # Flutter Data Firestore Adapter
  flutter_data_firestore: ^1.5.0  # Connects Flutter Data to Firebase Firestore

  # UI Components
  material_design_icons_flutter: ^7.0.7296  # Provides consistent iconography as specified in PRD
  data_table_2: ^2.5.6       # Powers employee management tables in admin dashboard
  syncfusion_flutter_charts: ^23.1.36  # Creates attendance trend visualization 
  flutter_form_builder: ^9.1.0  # Handles employee data entry with validation
  table_calendar: ^3.0.9     # Displays employee attendance calendar view
  
  # Internationalization
  intl: ^0.20.2              # Provides multilingual support as required in PRD

  # Networking
  dio: ^5.3.3                # Primary HTTP client for HR Connect API communication
  http: ^1.1.0               # Secondary HTTP client for simple API calls

  # Data Modeling
  freezed_annotation: ^2.2.0  # Creates immutable models for Employee and Attendance entities
  json_annotation: ^4.8.1     # Handles serialization of employee records for API communication
  uuid: ^3.0.7                # Generates unique IDs for attendance records
  
  # Financial Calculations 
  decimal: ^3.2.1             # Provides precise decimal calculations for payroll as specified in PRD
  money2: ^6.0.0              # Manages currency formatting and conversion

  # Logging & Utilities
  logger: ^2.0.2+1            # Provides structured logging for attendance tracking events

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Linting and Analysis
  flutter_lints: ^3.0.1        # Enforces HR Connect coding standards
  
  # Code Generation
  build_runner: ^2.4.8         # Runs code generation for database, models, and providers
  injectable_generator: ^2.1.6 # Generates dependency injection code for HR services
  freezed: ^2.3.5              # Generates immutable model classes for HR entities
  json_serializable: ^6.7.0    # Generates JSON serialization for API responses
  
  # Testing (TDD approach)
  test: ^1.24.9                # Core testing framework for domain logic
  mockito: ^5.4.4              # Creates mocks for API and database dependencies
  mocktail: ^1.0.1             # Provides simplified mocking for repository testing
  riverpod_test: ^2.3.4        # Tests state management for attendance features
  golden_toolkit: ^1.0.0       # Validates UI appearance against reference designs
  bloc_test: ^9.1.4            # Tests state transitions in feature workflows
  patrol: ^2.3.1               # Performs end-to-end testing of complete workflows
  integration_test:            # Tests full employee attendance workflows
    sdk: flutter
    
  # Deployment Tools
  change_app_package_name: ^1.1.0  # Updates package identifiers for deployment
  envied_generator: ^0.5.2          # Handles environment-specific configuration

flutter:
  uses-material-design: true  # Enables Material Design for consistent HR Connect UI
  assets:
    - assets/images/          # Contains employee avatars and company logos
    - assets/icons/           # Stores custom HR-specific icons and attendance status indicators
    - assets/config/          # Holds environment configuration files
    - assets/translations/    # Contains localization files for multilingual support
    
  fonts:
    - family: Roboto          # Primary font family for HR Connect interface
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf  # Standard text in employee listings
        - asset: assets/fonts/Roboto-Medium.ttf   # Section headers and list titles
          weight: 500
        - asset: assets/fonts/Roboto-Bold.ttf     # Important information and confirmations
          weight: 700
```

## Validation Steps

After configuring the `pubspec.yaml` file, validate your configuration by following these steps:

### 1. Check YAML Syntax

Ensure the YAML syntax is valid. Most code editors will highlight syntax errors automatically. Common issues include:
- Incorrect indentation
- Missing colons after keys
- Improper list formatting

### 2. Verify Dependencies

Run the following command to verify that all dependencies can be resolved:

```bash
# Validate pubspec.yaml without actually downloading dependencies
flutter pub get --dry-run
```

If there are any issues with dependency resolution, the command will output error messages.

### 3. Check For Version Conflicts

Look for warning messages about version constraints that might conflict. These usually appear as:
```
Warning: The package X requires Dart SDK version >=X.X.X <Y.Y.Y...
```

## Troubleshooting Guide

### Common Issues and Solutions

#### Issue: Syntax Errors in YAML

**Problem**: The YAML format is sensitive to whitespace and indentation.

**Solution**:
- Ensure proper indentation (2 spaces per level)
- Check for missing colons after property names
- Verify that all string values are properly formatted

#### Issue: Dependency Version Conflicts

**Problem**: Dependencies might have incompatible version requirements.

**Solutions**:
- Check the Flutter and Dart SDK constraints of conflicting packages
- Try adjusting version constraints to find compatible ranges
- Check each package's GitHub repository or pub.dev page for compatibility notes

#### Issue: Assets Directory Not Found

**Problem**: The `pubspec.yaml` references asset directories that don't exist.

**Solution**:
- Create the required directories (assets/images, assets/icons, etc.)
- Add placeholder files (e.g., .gitkeep) to maintain empty directories
- Alternatively, comment out the assets until they are needed

#### Issue: Font Files Not Found

**Problem**: The font files referenced in the `pubspec.yaml` are missing.

**Solution**:
- Download the required font files (e.g., Roboto)
- Create the assets/fonts directory
- Place the font files in the correct location
- Alternatively, comment out the font section until the fonts are added

## Next Steps

After successfully configuring the `pubspec.yaml` file, proceed to:

1. **Task 01-001-03**: Run flutter pub get to install dependencies and verify the project builds.
2. **Task 01-001-04**: Set up version control (e.g., initialize Git repository, add .gitignore).

The completion of this task establishes the foundation for implementing the HR Connect features according to the Modified Vertical Slice Architecture (MVSA) pattern and offline-first approach.

## References

- [Dart Package Management Documentation](https://dart.dev/guides/packages)
- [pub.dev - Dart and Flutter Package Repository](https://pub.dev/)
- [HR Connect Project Requirements Document](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)

---

*Note for Cursor AI: When implementing this task, ensure all dependencies and versions match exactly as specified in this guide. The pubspec.yaml file should be created at the root of the Flutter project created in task 01-001-01. Pay special attention to indentation and formatting as YAML is whitespace-sensitive.*
