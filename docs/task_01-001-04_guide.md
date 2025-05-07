# HR Connect: Task 01-001-04 Implementation Guide

## Task Information
- **Task ID**: 01-001-04
- **Task Title**: Set up version control (e.g., initialize Git repository, add .gitignore)
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides comprehensive instructions for setting up version control for the HR Connect mobile workforce management solution. Version control is a critical component of any software development project, especially for a complex application like HR Connect that follows a Modified Vertical Slice Architecture (MVSA) with multiple team members potentially working on different features simultaneously.

Proper version control setup ensures:
- Code history tracking and change management
- Collaborative development workflows
- Feature branch isolation for the MVSA approach
- Safe experimentation and rollback capabilities
- Proper exclusion of generated files, build artifacts, and sensitive information

This task establishes the foundation for a robust Git workflow that will support the test-driven development approach specified in the HR Connect Product Requirements Document (PRD).

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Task 01-001-01: Created a new Flutter project using Flutter 3.29+ and Dart 3.7+
   - Task 01-001-02: Configured the pubspec.yaml with all required dependencies
   - Task 01-001-03: Run flutter pub get to install dependencies and verify the project builds

2. **Required Tools**:
   - Git installed on your development machine
   - Access to your organization's Git hosting service (GitHub, GitLab, Bitbucket, etc.) if applicable

3. **Required Knowledge**:
   - Basic understanding of Git commands and concepts
   - Familiarity with version control workflows
   - Understanding of which files should and shouldn't be tracked in a Flutter project

## Git Setup and Configuration

### Step 1: Verify Git Installation

First, confirm that Git is installed on your system:

```bash
git --version
```

Expected output:
```
git version 2.39.0 (or later)
```

If Git is not installed, follow the installation instructions for your operating system:
- **Windows**: Download from [git-scm.com](https://git-scm.com/download/win)
- **macOS**: Install via Homebrew with `brew install git`
- **Linux**: Install via your package manager, e.g., `sudo apt install git`

### Step 2: Configure Git Identity

Set up your Git identity for commit attribution:

```bash
git config --global user.name "ridawn"
git config --global user.email "ridawn@gmail.com"
```

For project-specific configuration (optional):

```bash
# Navigate to the project directory
cd path/to/hr_connect

# Set repository-specific configuration
git config user.name "ridawn928"
git config user.email "ridawn@gmail.com"
```

### Step 3: Configure Line Ending Behavior

Set up consistent line ending behavior (especially important for cross-platform development):

```bash
# On Windows
git config --global core.autocrlf true

# On macOS/Linux
git config --global core.autocrlf input
```

## Repository Initialization

### Step 1: Navigate to the Project Directory

Ensure you're in the root directory of the HR Connect project:

```bash
C:\Users\Darwin\Desktop\hr_connect
```

### Step 2: Initialize the Git Repository

Create a new Git repository in the project directory:

```bash
git init
```

Expected output:
```
Initialized empty Git repository in /path/to/hr_connect/.git/
```

This creates a hidden `.git` directory that contains all the information necessary for Git to track changes to your project.

## .gitignore Configuration

A properly configured `.gitignore` file is essential for Flutter projects, especially for HR Connect with its many generated files from packages like Drift, Flutter Data, and build_runner.

### Step 1: Create a .gitignore File

Create a `.gitignore` file in the root of your project:

```bash
touch .gitignore
```

### Step 2: Add Flutter-specific Ignore Patterns

Open the `.gitignore` file in your text editor and add the following comprehensive patterns for Flutter projects:

```
# Flutter/Dart specific
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
coverage/
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code related
.vscode/
.classpath
.project
.settings/

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.*
**/android/key.properties
*.jks

# iOS/XCode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/Flutter/flutter_export_environment.sh
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Web related
**/web/**/lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# HR Connect specific
# Generated files from Drift
**/*.g.dart
lib/**/generated/

# Generated files from Injectable, Riverpod, etc.
**/*.freezed.dart
**/*.config.dart

# Generated files from Flutter Data
lib/**/adapters.dart
lib/**/data_offline_queue.hive
lib/**/data_offline_queue.lock

# Environment and secrets
.env
.env.*
**/google-services.json
**/GoogleService-Info.plist
**/firebase_options.dart

# Local test data
**/test_assets/local/

# Temporary files
*.temp
*.tmp
.temp/
.tmp/
```

The patterns above are specifically tailored for the HR Connect project, considering:
- Generated code files from packages like Drift, Injectable, Riverpod, and Flutter Data
- Platform-specific build files for Android, iOS, and web
- Environment files that might contain sensitive information
- IDE-specific files
- Temporary files and test data

### Step 3: Verify the .gitignore File

Ensure the `.gitignore` file is properly created:

```bash
cat .gitignore
```

This should display the content you added to the file.

## Initial Commit

Now that the repository is initialized and the `.gitignore` file is configured, it's time to make the initial commit.

### Step 1: Check Repository Status

Check which files are ready to be committed:

```bash
git status
```

This will show all files that are not excluded by the `.gitignore` file.

### Step 2: Stage Files for Commit

Add all relevant files to the staging area:

```bash
git add .
```

This command adds all files in the current directory and its subdirectories to the staging area, except those specified in the `.gitignore` file.

### Step 3: Create the Initial Commit

Create the initial commit with a descriptive message:

```bash
git commit -m "Initial commit: HR Connect project setup with Flutter 3.29+ and MVSA architecture"
```

Expected output:
```
[main (root-commit) abcd123] Initial commit: HR Connect project setup with Flutter 3.29+ and MVSA architecture
 X files changed, Y insertions(+)
 create mode 100644 ...
 ...
```

### Step 4: Verify the Commit

Check that the commit was created successfully:

```bash
git log
```

This should show your initial commit with the message, author, date, and commit hash.

## Remote Repository Setup (Optional)

If you're using a remote Git hosting service like GitHub, GitLab, or Bitbucket, follow these steps to link your local repository.

### Step 1: Create a Remote Repository

Create a new repository on your Git hosting service. Do not initialize it with a README, .gitignore, or license file, as we've already set these up locally.

### Step 2: Link Remote Repository

Add the remote repository to your local Git configuration:

```bash
git remote add origin https://github.com/ridawn928/hr_connect.git
```

Replace the URL with the actual URL of your remote repository.

### Step 3: Verify Remote Configuration

Confirm that the remote repository is correctly configured:

```bash
git remote -v
```

Expected output:
```
origin  https://github.com/ridawn928/hr_connect.git (fetch)
origin  https://github.com/ridawn928/hr_connect.git (push)
```

### Step 4: Push to Remote Repository

Push your local commits to the remote repository:

```bash
git push -u origin main
```

Note: If your default branch is named differently (e.g., `master`), replace `main` with your branch name.

## Branch Strategy for HR Connect

For the HR Connect project with its Modified Vertical Slice Architecture, a structured branching strategy is recommended.

### Step 1: Create a Development Branch

Create a development branch for ongoing work:

```bash
git checkout -b development
```

This creates and switches to a new branch named `development`.

### Step 2: Understand Branch Naming Conventions

For the HR Connect project, follow these branch naming conventions:

- **Feature branches**: `feature/feature-name`
- **Bug fix branches**: `bugfix/bug-description`
- **Release branches**: `release/version-number`
- **Hotfix branches**: `hotfix/issue-description`

When implementing vertical slices of functionality, consider naming feature branches according to the business capability they implement, for example:
- `feature/qr-attendance`
- `feature/leave-management`
- `feature/employee-profile`

### Step 3: Push the Development Branch (Optional)

If using a remote repository, push the development branch:

```bash
git push -u origin development
```

## Verification Steps

After setting up version control, verify that everything is working as expected.

### Step 1: Check Repository Status

Ensure the repository is clean:

```bash
git status
```

Expected output:
```
On branch main
nothing to commit, working tree clean
```

### Step 2: Verify .gitignore Functionality

Test that the `.gitignore` file is working correctly:

```bash
# Create a test file that should be ignored
touch .dart_tool/test_file

# Check if it appears in git status
git status
```

The test file should not appear in the output, indicating that the `.gitignore` file is working correctly.

### Step 3: Verify Branch Creation

List all branches to confirm they were created correctly:

```bash
git branch
```

Expected output:
```
* main
  development
```

The asterisk (`*`) indicates the current branch.

## Troubleshooting Common Issues

### Issue: Files Not Being Ignored

**Problem**: Files that should be ignored by `.gitignore` are still appearing in `git status`.

**Solutions**:
- Ensure the file wasn't already tracked before adding it to `.gitignore`:
  ```bash
  git rm --cached <file>
  ```
- Check for syntax errors in the `.gitignore` file
- Make sure the path patterns match your project structure

### Issue: Authentication Problems with Remote Repository

**Problem**: Unable to push to or pull from the remote repository.

**Solutions**:
- Check your credentials and authentication method
- For HTTPS, consider using a credential helper:
  ```bash
  git config --global credential.helper cache
  ```
- For SSH, verify your SSH key is set up correctly:
  ```bash
  ssh -T git@github.com
  ```

### Issue: Line Ending Problems

**Problem**: Git shows changes in files you haven't modified, often due to line ending differences.

**Solution**:
- Configure line ending behavior as mentioned earlier
- For existing repositories, normalize line endings:
  ```bash
  # Check out all files
  git add --renormalize .
  ```

### Issue: Large Files Causing Problems

**Problem**: Attempting to commit large files (like binary assets) causes Git operations to slow down.

**Solutions**:
- Add large file patterns to `.gitignore`
- Consider using Git LFS (Large File Storage) for necessary large files:
  ```bash
  git lfs install
  git lfs track "*.psd"
  ```

## Next Steps

After successfully setting up version control, proceed to the next tasks in the Project Setup and Architecture Foundation phase:

1. Create the core directory structure that follows the MVSA pattern
2. Set up dependency injection
3. Configure routing
4. Implement the base application structure

Consider these additional recommendations for effective version control with the HR Connect project:

1. **Create a README.md file**: Document the project setup, architecture, and development workflow
2. **Set up a CONTRIBUTING.md file**: Define contribution guidelines for team members
3. **Configure branch protection rules**: If using GitHub or similar platforms, set up protection for main branches
4. **Integrate with CI/CD**: Consider setting up continuous integration to run tests automatically

## References

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Documentation](https://docs.github.com/en)
- [Flutter Version Control Best Practices](https://docs.flutter.dev/development/tools/sdk/releases)
- [HR Connect Project Requirements Document](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)

---

*Note for Cursor AI: When implementing this task, execute the Git commands in the project root directory created in task 01-001-01. Ensure proper configuration of the .gitignore file to exclude generated files, especially those created by code generation packages that HR Connect relies on. The branching strategy should support the Modified Vertical Slice Architecture (MVSA) approach of the project.*
