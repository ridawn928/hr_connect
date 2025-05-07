# HR Connect: Task 01-001-03 Implementation Guide

## Task Information
- **Task ID**: 01-001-03
- **Task Title**: Run flutter pub get to install dependencies and verify the project builds
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for running `flutter pub get` to install all the dependencies specified in the `pubspec.yaml` file and verifying that the HR Connect project builds correctly. 

While this task may seem straightforward, it's a critical step in the project setup process. Properly installing and verifying dependencies ensures that all required packages for implementing the Modified Vertical Slice Architecture (MVSA) with an offline-first approach are available to the development team. This includes essential packages for state management (Riverpod), local storage (Drift), offline synchronization (Flutter Data), QR code functionality, and Firebase integration.

Successful completion of this task establishes the technical foundation for all subsequent development work on the HR Connect mobile workforce management solution.

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Task 01-001-01: Created a new Flutter project using Flutter 3.29+ and Dart 3.7+
   - Task 01-001-02: Configured the pubspec.yaml with all required dependencies

2. **Development Environment**:
   - Flutter SDK 3.29+ installed and properly configured
   - Dart SDK 3.7+ installed
   - A compatible IDE (VS Code or Android Studio recommended)
   - Working internet connection to download packages
   - Terminal/command-line access

3. **Required Knowledge**:
   - Basic understanding of Flutter package management
   - Familiarity with command-line operations
   - Understanding of dependency management concepts

## Understanding flutter pub get

Before executing the command, it's important to understand what `flutter pub get` does and how it works in the context of the HR Connect project:

### What the Command Does

The `flutter pub get` command:

1. **Resolves Dependencies**: Reads the `pubspec.yaml` file and calculates the complete dependency graph, including both direct dependencies (those explicitly listed in the pubspec.yaml) and transitive dependencies (dependencies of your dependencies).

2. **Downloads Packages**: Retrieves all required packages from pub.dev or other specified sources and stores them in the system-wide cache (.pub-cache directory).

3. **Creates pubspec.lock**: Generates or updates the `pubspec.lock` file, which locks the specific versions of all dependencies to ensure consistent builds across development environments.

4. **Configures Project**: Updates the project's package configuration in the `.dart_tool` directory.

### Why It's Important for HR Connect

For the HR Connect project, this step is particularly important because:

- The project relies on numerous dependencies for its offline-first approach and MVSA architecture
- Many packages require code generation (like Drift, Injectable, and Flutter Data)
- Firebase integration requires proper initialization of multiple packages
- The QR code functionality depends on specific scanning and generation packages
- State management with Riverpod requires proper installation and configuration

## Step-by-Step Implementation

Follow these steps to run `flutter pub get` and verify the project builds correctly:

### Step 1: Navigate to the Project Directory

First, ensure you're in the root directory of the HR Connect project:

```bash
# Navigate to the project directory
C:\Users\Darwin\Desktop\hr_connect
```

Verify you're in the correct directory by checking for the presence of the `pubspec.yaml` file:

```bash
# List files in the current directory
ls
```

You should see `pubspec.yaml` in the output.

### Step 2: Run flutter pub get

Execute the Flutter package get command:

```bash
flutter pub get
```

Expected output:

```
Running "flutter pub get" in hr_connect...
Resolving dependencies...
  _fe_analyzer_shared 65.0.0
  analyzer 6.3.0
  args 2.4.2
  async 2.11.0
  ...
  [many more dependencies will be listed]
  ...
  yaml 3.1.2
Got dependencies!
```

The command will fetch all dependencies specified in your `pubspec.yaml` file, including those required for the HR Connect architecture such as:
- Riverpod for state management
- Drift for local database
- Flutter Data for offline-first framework
- Firebase packages for cloud integration
- QR code packages for attendance tracking

### Step 3: Alternative Ways to Run flutter pub get

If you prefer using an IDE instead of the command line, you can:

**In VS Code**:
1. Open the `pubspec.yaml` file
2. Click on "Get Packages" at the top of the file, or
3. Press `Ctrl+S` to save the file, which automatically triggers `flutter pub get`

**In Android Studio/IntelliJ IDEA**:
1. Open the `pubspec.yaml` file
2. Click on "Pub get" in the action ribbon at the top of the editor, or
3. Right-click on the `pubspec.yaml` file in the project view and select "Flutter > Pub Get"

### Step 4: Check for Success Indicators

After running the command, verify that:

1. The terminal output ends with "Got dependencies!" without any errors
2. A `pubspec.lock` file has been created/updated in the project root
3. The `.dart_tool` directory has been created/updated in the project root

## Verification Process

After running `flutter pub get`, it's essential to verify that all dependencies were installed correctly and that the project builds successfully.

### Step 1: Verify the pubspec.lock File

Check that the `pubspec.lock` file has been created and contains entries for all required dependencies:

```bash
# Check if pubspec.lock exists
ls -la pubspec.lock

# View the contents of pubspec.lock (optional)
cat pubspec.lock | grep -E "riverpod|flutter_data|drift|firebase|mobile_scanner|qr_flutter"
```

The output should show version information for these key packages, indicating they've been resolved successfully.

### Step 2: Verify the .dart_tool Directory

Check that the `.dart_tool` directory has been created:

```bash
# Check if .dart_tool directory exists
ls -la .dart_tool
```

This directory contains configuration files generated by the Flutter tools.

### Step 3: Run Flutter Doctor

Run Flutter doctor to ensure your environment is correctly configured:

```bash
flutter doctor -v
```

All checks should pass, or at least not show any critical issues that would prevent the project from building.

### Step 4: Check if the Project Builds

Run a build check to verify that the project compiles successfully:

```bash
# For a general build check
flutter build --debug --flavor development

# Or, for a quick check without building a complete app
flutter analyze
```

### Step 5: Run the Project

Start the app in debug mode to ensure it runs correctly:

```bash
flutter run
```

This should start the basic app scaffold. At this point, it will be the default Flutter counter app, as we haven't implemented any HR Connect features yet.

### Step 6: Verify Key Dependencies

For HR Connect-specific verification, check that the key architectural dependencies are correctly resolved:

```bash
# Check for Riverpod (state management)
flutter pub deps | grep -E "riverpod"

# Check for Flutter Data (offline-first framework)
flutter pub deps | grep -E "flutter_data"

# Check for Drift (local database)
flutter pub deps | grep -E "drift"

# Check for Firebase packages
flutter pub deps | grep -E "firebase"

# Check for QR code packages
flutter pub deps | grep -E "mobile_scanner|qr_flutter"
```

Each command should return information about the respective packages, confirming they're properly included in the dependency tree.

## Troubleshooting Common Issues

### Network and Connectivity Issues

**Problem**: Flutter can't download packages due to network issues.

**Solutions**:
- Verify your internet connection
- Check if you're behind a proxy and configure Flutter accordingly:
  ```bash
  export HTTP_PROXY=http://your-proxy-server:port
  export HTTPS_PROXY=https://your-proxy-server:port
  ```
- Try using a different network connection
- If behind a corporate firewall, ensure pub.dev and GitHub are accessible

### Package Resolution Conflicts

**Problem**: Dependency version conflicts or incompatible constraints.

**Solutions**:
- Check the error messages for specific conflict information
- Update the version constraints in pubspec.yaml to be compatible
- Run `flutter pub outdated` to see which packages have newer versions
- Try running with the `--no-precompile` flag:
  ```bash
  flutter pub get --no-precompile
  ```

### Cache Corruption Issues

**Problem**: The Flutter package cache becomes corrupted.

**Solutions**:
- Clear the pub cache:
  ```bash
  flutter pub cache clean
  ```
- For more persistent issues, try:
  ```bash
  flutter pub cache repair
  ```
- As a last resort, delete the `.pub-cache` directory (usually in your home directory) and try again

### Platform-Specific Issues

**Problem**: Platform-specific plugins fail to resolve or install.

**Solutions**:
- Ensure you have the required platform tools installed:
  - For Android: Android SDK and platform tools
  - For iOS: Xcode and CocoaPods
- Run `flutter doctor` to identify missing dependencies
- Try specifying platform:
  ```bash
  flutter pub get --no-android
  # or
  flutter pub get --no-ios
  ```

### Large Dependency Tree Issues

**Problem**: The HR Connect project has many dependencies, which might cause slow resolution or memory issues.

**Solutions**:
- Be patient during the first run, as it may take several minutes
- Increase available memory for Dart processes:
  ```bash
  export DART_VM_OPTIONS=--old_gen_heap_size=2048
  ```
- Run with verbose output to see progress:
  ```bash
  flutter pub get -v
  ```

## Next Steps

After successfully running `flutter pub get` and verifying that the project builds correctly, proceed to:

1. **Task 01-001-04**: Set up version control (e.g., initialize Git repository, add .gitignore)

In subsequent tasks, you'll begin implementing the actual features and architecture of the HR Connect application. Successfully completing this dependency installation task ensures that all the required packages are available for development.

### Additional Recommendations

Before moving on, consider:

1. **Documenting Dependencies**: Update project documentation with notes about any dependency issues encountered and how they were resolved
2. **Creating a Dependency Diagram**: For complex projects like HR Connect, create a visual representation of the dependency graph to better understand package relationships
3. **Setting Up Code Generation**: Many of the HR Connect dependencies require code generation, which will be set up in later tasks

## References

- [Flutter Package Management Documentation](https://docs.flutter.dev/packages-and-plugins/using-packages)
- [Dart Package Manager (pub) Commands](https://dart.dev/tools/pub/cmd)
- [Resolving Package Dependencies](https://dart.dev/tools/pub/dependencies)
- [HR Connect Project Requirements Document](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)

---

*Note for Cursor AI: When implementing this task, execute the commands in the project root directory created in task 01-001-01 with the pubspec.yaml configured in task 01-001-02. Ensure all verification steps are performed to confirm proper installation of dependencies before proceeding to the next task.*
