# HR Connect: Task 01-002-01 Implementation Guide

## Task Information
- **Task ID**: 01-002-01
- **Task Title**: Create lib/core/ for shared utilities, constants, and base classes
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for creating the `lib/core/` directory structure in the HR Connect mobile workforce management solution. This task is a critical foundation for implementing the Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach as specified in the project requirements.

The `core` directory contains shared infrastructure, utilities, constants, and base classes that will be used across multiple features in the application. Properly organizing this directory is essential for:

- Maintaining separation of concerns
- Enabling code reuse across features
- Supporting the offline-first approach
- Facilitating dependency injection
- Implementing proper error handling
- Establishing security foundations

This task focuses on creating the directory structure itself, while the actual implementation of the core functionality will be addressed in subsequent tasks.

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Task 01-001-01: Created a new Flutter project using Flutter 3.29+ and Dart 3.7+
   - Task 01-001-02: Configured the pubspec.yaml with all required dependencies
   - Task 01-001-03: Run flutter pub get to install dependencies
   - Task 01-001-04: Set up version control (Git repository and .gitignore)
   - Task 01-001-05: Validated initial project setup with a basic widget test

2. **Required Knowledge**:
   - Understanding of the Modified Vertical Slice Architecture (MVSA)
   - Familiarity with Flutter project structure
   - Basic knowledge of Clean Architecture principles
   - Understanding of dependency injection concepts

3. **Development Environment**:
   - Flutter SDK 3.29+ installed
   - IDE (VS Code or Android Studio recommended)
   - Terminal/command-line access

## Core Directory Structure Overview

In the HR Connect application, we follow a Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach:

- **Core**: Contains shared infrastructure, utilities, and base classes used across multiple features
- **Features**: Contains vertical slices of business functionality, each cutting across all architectural layers

This separation allows us to:
- Keep shared code in one place to avoid duplication
- Isolate feature-specific code for better maintainability
- Balance cross-cutting concerns with feature isolation
- Support the offline-first approach with centralized infrastructure

The core directory plays a crucial role in providing the foundation for all features, without creating tight coupling between them.

## Step-by-Step Implementation

Follow these steps to create the `lib/core/` directory structure:

### Step 1: Create the Main Core Directory

First, navigate to your project directory and create the main `core` directory inside the `lib` folder:

```bash
# Navigate to the project directory
cd path/to/hr_connect

# Create the core directory
mkdir -p lib/core
```

The `-p` flag ensures that parent directories are created if they don't exist.

### Step 2: Create Core Subdirectories

Now, create the following subdirectories within the `core` directory:

```bash
# Create dependency injection directory
mkdir -p lib/core/di

# Create error handling directory
mkdir -p lib/core/error

# Create network layer directory
mkdir -p lib/core/network

# Create storage directory
mkdir -p lib/core/storage

# Create utilities directory
mkdir -p lib/core/utils

# Create security foundations directory
mkdir -p lib/core/security
```

Alternatively, you can create all directories in a single command:

```bash
mkdir -p lib/core/{di,error,network,storage,utils,security}
```

### Step 3: Add Placeholder Files

Since Git doesn't track empty directories, add placeholder files to ensure the directory structure is properly tracked:

```bash
# Add .gitkeep files to each directory
touch lib/core/di/.gitkeep
touch lib/core/error/.gitkeep
touch lib/core/network/.gitkeep
touch lib/core/storage/.gitkeep
touch lib/core/utils/.gitkeep
touch lib/core/security/.gitkeep
```

### Step 4: Create README Files

Create README.md files to document the purpose of each directory:

```bash
# Create main core README
touch lib/core/README.md

# Create READMEs for each subdirectory
touch lib/core/di/README.md
touch lib/core/error/README.md
touch lib/core/network/README.md
touch lib/core/storage/README.md
touch lib/core/utils/README.md
touch lib/core/security/README.md
```

## Directory Descriptions and Responsibilities

Now, let's detail what each directory is responsible for and what types of files will eventually be placed in them:

### 1. core/di/ (Dependency Injection)

**Purpose**: Manages dependency injection using get_it and injectable to facilitate loose coupling and improve testability.

**Will contain**:
- Service locator setup
- Module registration
- Injectable configuration
- Factory methods for repositories and services

**Example files**:
- `injection.dart`: Main injection configuration
- `injection.config.dart`: Generated injection configuration
- `modules/`: Directory for feature-specific injection modules

**How it supports MVSA**:
Allows features to depend on abstractions rather than concrete implementations, facilitating the separation of concerns while still enabling shared functionality.

### 2. core/error/ (Error Handling)

**Purpose**: Provides a unified approach to error handling using the Either type pattern from dartz.

**Will contain**:
- Base failure classes
- Custom exceptions
- Result types using Either
- Error utilities and helpers

**Example files**:
- `failures.dart`: Base failure classes
- `exceptions.dart`: Custom exception classes
- `app_error.dart`: Application-specific error types

**How it supports MVSA**:
Standardizes error handling across features, allowing consistent error representation and handling without tight coupling.

### 3. core/network/ (Network Layer)

**Purpose**: Manages API communication with offline-first capabilities.

**Will contain**:
- Dio client configuration
- Network interceptors (auth, logging, etc.)
- Connection checkers
- Base API clients
- Request/response models

**Example files**:
- `api_client.dart`: Base API client setup
- `interceptors/`: Custom Dio interceptors
- `connectivity_checker.dart`: Network connectivity utilities

**How it supports MVSA**:
Provides centralized network infrastructure that can be used by all features while supporting offline-first capabilities.

### 4. core/storage/ (Local Storage)

**Purpose**: Manages data persistence for offline-first functionality.

**Will contain**:
- Drift database configuration
- Flutter Data setup
- Secure storage wrappers
- Database migrations
- Base repository interfaces

**Example files**:
- `database.dart`: Drift database setup
- `secure_storage.dart`: Flutter Secure Storage wrapper
- `app_database.g.dart`: Generated database code

**How it supports MVSA**:
Enables the offline-first approach by providing centralized storage infrastructure that can be used across features.

### 5. core/utils/ (Utilities)

**Purpose**: Provides shared helper functions, extensions, and utilities.

**Will contain**:
- String extensions
- Date formatting utilities
- Validation helpers
- Platform-specific utilities
- Common widgets

**Example files**:
- `string_extensions.dart`: String manipulation utilities
- `date_utils.dart`: Date and time helpers
- `validators.dart`: Input validation functions

**How it supports MVSA**:
Promotes code reuse by centralizing common utilities that can be used across multiple features.

### 6. core/security/ (Security Foundations)

**Purpose**: Manages authentication, encryption, and security concerns.

**Will contain**:
- JWT handling
- Encryption utilities
- Biometric authentication
- Secure storage wrappers
- Certificate pinning

**Example files**:
- `jwt_service.dart`: JWT token management
- `encryption.dart`: Data encryption utilities
- `biometric_auth.dart`: Fingerprint/Face ID integration

**How it supports MVSA**:
Centralizes security concerns, ensuring that all features adhere to the same security standards without duplicating code.

## README Content Examples

Here are examples of content you should add to the README.md files:

### Main core/README.md

```markdown
# Core Module

This directory contains shared infrastructure, utilities, constants, and base classes used across the HR Connect application. It follows the Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach.

## Structure

- **di/**: Dependency injection configuration using get_it and injectable
- **error/**: Error handling with the Either type pattern from dartz
- **network/**: API communication and offline synchronization
- **storage/**: Local database and secure storage
- **utils/**: Shared utilities and extension methods
- **security/**: Authentication and encryption

## Purpose

The core module centralizes shared functionality that is used across multiple features, promoting code reuse and separation of concerns while still allowing for the isolation of feature-specific code in vertical slices.

## Usage Guidelines

- Place code here only if it's truly shared across multiple features
- Keep feature-specific code in its respective feature directory
- Follow Clean Architecture principles for proper layering
- Document all components with clear purpose statements
```

### Subdirectory README.md (Example for di/)

```markdown
# Dependency Injection

This directory contains the dependency injection configuration for the HR Connect application using get_it and injectable.

## Purpose

- Provides a service locator pattern for resolving dependencies
- Generates boilerplate code for dependency registration
- Facilitates loose coupling between components
- Enables easier testing through dependency substitution

## Key Components

- `injection.dart`: Main injection configuration
- `injection.config.dart`: Generated configuration (don't edit manually)
- Module files for specific feature sets

## Usage

Import the injection.dart file to access the service locator instance:

```dart
import 'package:hr_connect/core/di/injection.dart';

// Later in code
final myService = getIt<MyService>();
```

## Notes

- Use @injectable annotations on classes that should be registered
- Run build_runner to generate the injection.config.dart file
- Follow naming conventions for consistent registration
```

Create similar README.md files for each subdirectory, explaining its purpose, key components, and usage guidelines.

## Verification Steps

After creating the directory structure, verify that everything is set up correctly:

### 1. Check Directory Structure

Run the following command to list the directory structure:

```bash
find lib/core -type d | sort
```

Expected output:
```
lib/core
lib/core/di
lib/core/error
lib/core/network
lib/core/security
lib/core/storage
lib/core/utils
```

### 2. Verify Placeholder Files

Check that all placeholder files are created:

```bash
find lib/core -name ".gitkeep" | sort
```

Expected output:
```
lib/core/di/.gitkeep
lib/core/error/.gitkeep
lib/core/network/.gitkeep
lib/core/security/.gitkeep
lib/core/storage/.gitkeep
lib/core/utils/.gitkeep
```

### 3. Verify README Files

Check that all README files are created:

```bash
find lib/core -name "README.md" | sort
```

Expected output:
```
lib/core/README.md
lib/core/di/README.md
lib/core/error/README.md
lib/core/network/README.md
lib/core/security/README.md
lib/core/storage/README.md
lib/core/utils/README.md
```

### 4. Commit Changes to Version Control

Once you've verified the structure, commit the changes to Git:

```bash
git add lib/core
git commit -m "Create core directory structure for shared infrastructure"
```

## Common Issues and Solutions

### Issue: Directories Not Tracked in Git

**Problem**: Empty directories are not tracked in Git.

**Solution**: Ensure you've added `.gitkeep` files to all directories:
```bash
find lib/core -type d -empty -exec touch {}/.gitkeep \;
```

### Issue: Inconsistent Directory Structure

**Problem**: Directory structure doesn't match the MVSA pattern.

**Solution**: Follow the exact naming conventions specified in this guide and the HR Connect guidelines. Use lowercase with underscores for directory names.

### Issue: IDE Not Showing New Directories

**Problem**: Your IDE doesn't show newly created directories.

**Solution**: Refresh your project in the IDE or restart it. In VS Code, you can right-click the Explorer and select "Refresh".

### Issue: Confusion About Directory Purposes

**Problem**: Uncertainty about what goes in each directory.

**Solution**: Refer to the detailed directory descriptions above and consult the HR Connect guidelines. When in doubt, check if the code is truly shared (belongs in core) or feature-specific (belongs in features).

## Next Steps

After successfully creating the core directory structure, proceed to:

1. **Task 01-002-02**: Create lib/features/ for feature-specific modules
2. **Task 01-002-03**: Within each feature folder, add subfolders for presentation, domain, and data layers

In subsequent tasks, you'll begin implementing actual functionality within this directory structure, including:
- Setting up dependency injection
- Creating error handling infrastructure
- Configuring the network layer
- Setting up local storage
- Implementing security features

The directories you've created in this task will serve as the foundation for all shared functionality in the HR Connect application.

## References

- [HR Connect PRD Section 4.1: Modified Vertical Slice Architecture](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)
- [Clean Architecture Principles in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [get_it and injectable Documentation](https://pub.dev/packages/injectable)
- [Dart Package Organization Best Practices](https://dart.dev/guides/libraries/create-library-packages)

---

*Note for Cursor AI: When implementing this task, create the directory structure exactly as specified in this guide. The naming conventions and organization pattern are critical for maintaining consistency with the HR Connect architecture. Each directory should have both a .gitkeep file (to ensure empty directories are tracked in version control) and a README.md file (to document the directory's purpose). Future tasks will involve adding actual code files to these directories.*
