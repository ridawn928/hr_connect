# HR Connect: Task 01-002-02 Implementation Guide

## Task Information
- **Task ID**: 01-002-02
- **Task Title**: Create lib/features/ for feature-specific modules
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for creating the `lib/features/` directory structure in the HR Connect mobile workforce management solution. This task is a critical component of implementing the Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach as specified in the project requirements.

The `features` directory contains vertical slices of functionality, each representing a specific business capability in the HR Connect application. Unlike traditional layered architectures that organize code horizontally by technical concern (UI, business logic, data access), the MVSA approach organizes code vertically by feature, with each feature containing its own presentation, domain, and data layers.

This approach offers several benefits for the HR Connect project:
- **Independent feature development**: Teams can work on different business capabilities with minimal conflicts
- **Clear business alignment**: Code organization directly reflects business capabilities
- **Improved testability**: Features have clear boundaries, making them easier to test
- **Flexibility to change**: Changes to one feature have minimal impact on others
- **Faster delivery**: Features can be developed and delivered independently

This task focuses on creating the directory structure for the main business capabilities, while the internal layer organization will be addressed in the next task (01-002-03).

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Task 01-001-01 through 01-001-05: Initial project setup and validation
   - Task 01-002-01: Created lib/core/ for shared utilities, constants, and base classes

2. **Required Knowledge**:
   - Understanding of the Modified Vertical Slice Architecture (MVSA)
   - Familiarity with Clean Architecture principles
   - Knowledge of the HR Connect business domains
   - Basic understanding of Flutter project organization

3. **Development Environment**:
   - Flutter SDK 3.29+ installed
   - IDE (VS Code or Android Studio recommended)
   - Terminal/command-line access

## Features Directory Structure Overview

In the MVSA approach, the application is divided into:

1. **Core**: Shared infrastructure, utilities, and base classes (created in task 01-002-01)
2. **Features**: Vertical slices of business functionality

Each feature slice:
- Represents a distinct business capability
- Contains its own implementation of all architectural layers
- Uses shared infrastructure from the core directory
- Remains independent of other features
- Implements a clean architecture pattern internally

This approach combines the benefits of both vertical slice architecture (feature isolation) and clean architecture (separation of concerns within features).

## Business Capabilities in HR Connect

Based on the HR Connect PRD, we'll be creating directory structures for the following main business capabilities:

### 1. Attendance
The QR code attendance system that enables employees to check in and out using time-based QR codes. This is a core functionality of HR Connect, allowing for accurate time tracking even in offline environments.

**Key functionalities**:
- QR code generation with embedded timestamps
- QR code scanning and validation
- Attendance record management
- Status classification (ON_TIME, LATE, etc.)
- Offline validation capabilities

### 2. Time Management
The comprehensive time management system that handles leave requests, overtime, undertime, and remote work requests.

**Key functionalities**:
- Leave request creation and approval
- Overtime/undertime tracking
- Remote work request processing
- Team schedule visualization
- Approval workflows

### 3. Employee
The employee profile management system that handles employee data, documents, and performance metrics.

**Key functionalities**:
- Employee profile data management
- Document upload and management
- Performance metrics and goals
- Skills and certifications tracking
- Profile image handling

### 4. Admin
The administrative portals (Payroll Portal and HR Portal) that provide system management and configuration capabilities.

**Key functionalities**:
- QR code generation for locations
- System configuration
- User management
- Report generation
- Policy configuration

### 5. Authentication
The authentication and device management system that handles user login, token management, and device verification.

**Key functionalities**:
- JWT-based authentication
- Device registration and verification
- Multi-factor authentication
- Session management
- Password management

## Step-by-Step Implementation

Follow these steps to create the `lib/features/` directory structure:

### Step 1: Create the Main Features Directory

First, navigate to your project directory and create the main `features` directory inside the `lib` folder:

```bash
# Navigate to the project directory
cd path/to/hr_connect

# Create the features directory
mkdir -p lib/features
```

The `-p` flag ensures that parent directories are created if they don't exist.

### Step 2: Create Feature Subdirectories

Now, create subdirectories for each business capability:

```bash
# Create attendance feature directory
mkdir -p lib/features/attendance

# Create time management feature directory
mkdir -p lib/features/time_management

# Create employee feature directory
mkdir -p lib/features/employee

# Create admin feature directory
mkdir -p lib/features/admin

# Create authentication feature directory
mkdir -p lib/features/authentication
```

Alternatively, you can create all feature directories in a single command:

```bash
mkdir -p lib/features/{attendance,time_management,employee,admin,authentication}
```

### Step 3: Add Placeholder Files

Since Git doesn't track empty directories, add placeholder files to ensure the directory structure is properly tracked:

```bash
# Add .gitkeep files to each feature directory
touch lib/features/attendance/.gitkeep
touch lib/features/time_management/.gitkeep
touch lib/features/employee/.gitkeep
touch lib/features/admin/.gitkeep
touch lib/features/authentication/.gitkeep
```

### Step 4: Create README Files

Create README.md files to document the purpose of each feature directory:

```bash
# Create main features README
touch lib/features/README.md

# Create READMEs for each feature
touch lib/features/attendance/README.md
touch lib/features/time_management/README.md
touch lib/features/employee/README.md
touch lib/features/admin/README.md
touch lib/features/authentication/README.md
```

## Layer Organization Within Features

While the specific layer subdirectories will be created in the next task (01-002-03), it's important to understand how each feature will be organized internally:

### 1. Domain Layer

**Purpose**: Contains business logic, entities, and business rules.

**Components**:
- **Entities**: Core business objects (e.g., AttendanceRecord, LeaveRequest)
- **Repository Interfaces**: Define data access contracts (e.g., AttendanceRepository)
- **Use Cases**: Implement business logic (e.g., SubmitAttendanceUseCase)

**Key characteristic**: Has no dependencies on other layers.

### 2. Data Layer

**Purpose**: Implements data access and persistence.

**Components**:
- **Models**: Data transfer objects (e.g., AttendanceRecordModel)
- **Repository Implementations**: Concrete implementations of domain repositories
- **Data Sources**: Local and remote data sources

**Key characteristic**: Depends only on the domain layer.

### 3. Presentation Layer

**Purpose**: Handles UI components and user interaction.

**Components**:
- **Screens**: Full-screen UI components
- **Widgets**: Reusable UI components
- **State Management**: Riverpod providers and state classes

**Key characteristic**: Depends only on the domain layer, not on the data layer.

This internal organization follows Clean Architecture principles, ensuring proper separation of concerns within each feature.

## README Content Examples

Here are examples of content you should add to the README.md files:

### Main features/README.md

```markdown
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
```

### Feature-specific README.md (Example for attendance/)

```markdown
# Attendance Feature

This directory contains the QR code attendance system for the HR Connect application.

## Purpose

The attendance feature enables:
- QR code-based attendance tracking
- Offline validation of attendance records
- Status classification (ON_TIME, LATE, etc.)
- Attendance history management
- Geolocation verification

## Key Components

- Time-based QR codes with embedded timestamps
- Device-based verification
- Configurable time windows (15 minutes by default)
- Offline validation capabilities
- Nonce tracking to prevent replay attacks

## Technical Approach

This feature implements:
- QR code generation and scanning using mobile_scanner and qr_flutter
- Offline-first data persistence with Flutter Data and Drift
- Secure validation with digital signatures
- Clean Architecture with domain, data, and presentation layers
```

Create similar README.md files for each feature, explaining its purpose, key components, and technical approach.

## Verification Steps

After creating the directory structure, verify that everything is set up correctly:

### 1. Check Directory Structure

Run the following command to list the directory structure:

```bash
find lib/features -type d | sort
```

Expected output:
```
lib/features
lib/features/admin
lib/features/attendance
lib/features/authentication
lib/features/employee
lib/features/time_management
```

### 2. Verify Placeholder Files

Check that all placeholder files are created:

```bash
find lib/features -name ".gitkeep" | sort
```

Expected output:
```
lib/features/admin/.gitkeep
lib/features/attendance/.gitkeep
lib/features/authentication/.gitkeep
lib/features/employee/.gitkeep
lib/features/time_management/.gitkeep
```

### 3. Verify README Files

Check that all README files are created:

```bash
find lib/features -name "README.md" | sort
```

Expected output:
```
lib/features/README.md
lib/features/admin/README.md
lib/features/attendance/README.md
lib/features/authentication/README.md
lib/features/employee/README.md
lib/features/time_management/README.md
```

### 4. Commit Changes to Version Control

Once you've verified the structure, commit the changes to Git:

```bash
git add lib/features
git commit -m "Create features directory structure for business capabilities"
```

## Common Issues and Solutions

### Issue: Directories Not Tracked in Git

**Problem**: Empty directories are not tracked in Git.

**Solution**: Ensure you've added `.gitkeep` files to all directories:
```bash
find lib/features -type d -empty -exec touch {}/.gitkeep \;
```

### Issue: Inconsistent Feature Naming

**Problem**: Inconsistent naming conventions for feature directories.

**Solution**: Follow snake_case naming for all directories and ensure names clearly represent business capabilities, not technical concerns.

### Issue: Confusion Between Core and Features

**Problem**: Uncertainty about what should go in core vs. features.

**Solution**:
- Core: Shared infrastructure, utilities, and base classes
- Features: Business capability implementations, each with its own architecture layers
- When in doubt, ask: "Is this functionality specific to one business capability or shared across many?"

### Issue: Feature Interdependencies

**Problem**: Features becoming dependent on each other.

**Solution**: 
- Keep features independent by using core for shared functionality
- Use dependency injection to resolve dependencies
- Implement communication through domain events if necessary

## Next Steps

After successfully creating the features directory structure, proceed to:

1. **Task 01-002-03**: Within each feature folder, add subfolders for presentation, domain, and data layers

In subsequent tasks, you'll begin implementing the actual functionality for each feature, starting with:
- Setting up the domain layer entities and repositories
- Implementing data layer models and repositories
- Creating presentation layer screens and widgets

The directory structure you've created in this task will serve as the foundation for all business capabilities in the HR Connect application.

## References

- [HR Connect PRD Section 4.1: Modified Vertical Slice Architecture](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)
- [Vertical Slice Architecture](https://jimmybogard.com/vertical-slice-architecture/)
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Feature-Driven Development](https://en.wikipedia.org/wiki/Feature-driven_development)

---

*Note for Cursor AI: When implementing this task, create the directory structure exactly as specified in this guide. The feature names and organization pattern are critical for maintaining consistency with the HR Connect architecture. Each feature directory should have both a .gitkeep file (to ensure empty directories are tracked in version control) and a README.md file (to document the feature's purpose). The internal layer structure (domain, data, presentation) will be added in the next task (01-002-03).*
