# HR Connect: Task 01-001-01 Implementation Guide

## Task Information
- **Task ID**: 01-001-01
- **Task Title**: Create a new Flutter project using Flutter 3.29+ and Dart 3.7+
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for creating the initial Flutter project for HR Connect, a comprehensive mobile workforce management solution. This task is the foundation for all subsequent development work and establishes the basic project structure that will be expanded upon with the Modified Vertical Slice Architecture (MVSA).

The HR Connect application will be built with Flutter 3.29+ and Dart 3.7+ to enable cross-platform functionality (Android, iOS, web) with a strong offline-first approach, making it ideal for organizations with distributed workforces operating in areas with unreliable internet connectivity.

## Prerequisites

Before starting this task, ensure you have:

1. **Development Environment**:
   - Flutter SDK 3.29 or higher installed
   - Dart SDK 3.7 or higher installed
   - A compatible IDE (VS Code or Android Studio recommended)
   - Git for version control

2. **Required Knowledge**:
   - Basic Flutter and Dart understanding
   - Familiarity with terminal/command-line operations
   - Understanding of the HR Connect architecture (as detailed in the PRD)

3. **Access Permissions**:
   - Access to the organization's repository (if applicable)

## Step-by-Step Instructions

### 1. Verify Flutter and Dart Versions

First, check your current Flutter and Dart versions to ensure they meet the requirements:

```bash
# Check Flutter version (should be 3.29 or higher)
flutter --version
```

If the installed version is lower than 3.29 or Dart is lower than 3.7, upgrade Flutter:

```bash
# Upgrade Flutter to latest stable version
flutter upgrade

# Alternatively, if using Flutter version management:
fvm install 3.29.0
fvm use 3.29.0
```

### 2. Create the New Flutter Project

Create the new project with the correct name following snake_case convention:

```bash
# Navigate to your desired parent directory
cd ~/Development/projects

# Create the new project
flutter create hr_connect --org=com.yourcompany --platforms=android,ios,web
```

Parameters explained:
- `hr_connect`: Project name using snake_case as per HR Connect guidelines
- `--org`: Organization name in reverse domain notation
- `--platforms`: Specifies target platforms (Android, iOS, and web as required in the PRD)

### 3. Navigate to the Project Directory

```bash
# Change directory to the newly created project
cd hr_connect
```

### 4. Verify the Project Structure

Examine the generated project structure to ensure it was created correctly:

```bash
# List all files and directories
ls -la
```

The default Flutter project structure should include:
- `android/`: Android project files
- `ios/`: iOS project files
- `lib/`: Main Dart source code
- `web/`: Web platform files
- `test/`: Test directory
- `pubspec.yaml`: Package dependencies
- Various configuration files (.gitignore, README.md, etc.)

### 5. Verify the Flutter and Dart Versions in the Project

Check that the project is using the correct Flutter and Dart versions:

```bash
# Check Flutter SDK version in the project
cat pubspec.lock | grep -A 2 "sdk: flutter"

# Check minimum Dart SDK version
grep "sdk:" pubspec.yaml
```

Ensure the Dart SDK constraint in `pubspec.yaml` includes version 3.7 or higher.

### 6. Run the Default App to Verify Setup

Run the default Flutter app to ensure everything is working correctly:

```bash
# Run the app (this will typically open in debug mode on a connected device or simulator)
flutter run

# Alternatively, to just verify that the code compiles without errors
flutter build --debug
```

## Validation Criteria

Your task is complete when:

1. A new Flutter project named `hr_connect` has been created
2. The project uses Flutter 3.29+ and Dart 3.7+
3. The default Flutter application builds and runs without errors
4. The project supports all required platforms (Android, iOS, web)

## Architecture Notes

This is just the initial project creation. In subsequent tasks, you will:

1. Restructure the project to follow the MVSA pattern with:
   ```
   lib/
     core/                 # Shared infrastructure
       di/                 # Dependency injection
       error/              # Error handling
       network/            # Network layer
       storage/            # Local storage
       utils/              # Utilities
       security/           # Security foundations
     features/             # Business capability slices
       attendance/         # QR attendance system
       time_management/    # Leave and request management
       employee/           # Employee profile management
       admin/              # Administrative portals
       authentication/     # Authentication feature
   ```

2. Configure the project to support the aggregate pattern with Employee as the primary aggregate root and related profile aggregates (AuthenticationProfile, DeviceProfile, etc.)

3. Set up the offline-first approach with appropriate storage and synchronization mechanisms

## Common Issues and Solutions

### Issue: Flutter Version Mismatch

**Problem**: The required Flutter version is not available or cannot be installed.

**Solutions**:
- Use Flutter version management tools like FVM: `dart pub global activate fvm`
- Check for conflicting environment variables: `echo $PATH | grep flutter`
- Update to the latest stable channel: `flutter channel stable && flutter upgrade`

### Issue: Project Creation Fails

**Problem**: The `flutter create` command fails or returns errors.

**Solutions**:
- Ensure you have sufficient permissions in the target directory
- Check for invalid characters in the project path
- Verify Flutter doctor shows no issues: `flutter doctor -v`
- Clear Flutter's cache: `flutter clean && flutter pub cache repair`

### Issue: Platform-specific Setup Problems

**Problem**: Android, iOS, or web configurations fail to initialize.

**Solutions**:
- Android: Ensure Android SDK is properly installed and ANDROID_HOME is set
- iOS: Verify Xcode is installed and configured (macOS only)
- Web: Check that Chrome is installed for debugging

## Next Steps

After completing this task, proceed to:

1. **Task 01-001-02**: Configure the pubspec.yaml with all required dependencies
2. **Task 01-001-03**: Run flutter pub get to install dependencies
3. **Task 01-001-04**: Set up version control

## References

- [Official Flutter Documentation](https://docs.flutter.dev/get-started/install)
- [Dart SDK Constraints](https://dart.dev/tools/pub/pubspec#sdk-constraints)
- [HR Connect Project Requirements Document](README.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)

---

*Note for Cursor AI: When implementing this task, ensure all commands and file paths are adapted to the specific development environment. Code generation should follow the exact versions specified (Flutter 3.29+ and Dart 3.7+) and adhere to the HR Connect architecture guidelines.*
