# HR Connect: Task 01-002-03 Implementation Guide

## Task Information
- **Task ID**: 01-002-03
- **Task Title**: Within each feature folder, add subfolders for presentation, domain, and data layers
- **Parent Task**: Project Setup and Architecture Foundation
- **Priority**: High

## Introduction

This guide provides step-by-step instructions for creating the internal layer structure within each feature folder of the HR Connect mobile workforce management solution. This task completes the directory structure setup for the Modified Vertical Slice Architecture (MVSA) by organizing each feature into Clean Architecture layers.

While the previous task (01-002-02) created the feature folders that represent vertical slices of business functionality, this task focuses on the horizontal layers within each feature:

- **Domain Layer**: Contains business logic, entities, and rules
- **Data Layer**: Implements data access and persistence
- **Presentation Layer**: Handles UI components and user interaction

This internal organization follows Clean Architecture principles, ensuring proper separation of concerns while maintaining the benefits of vertical slice architecture. The layer structure will facilitate:

- **Testability**: Each layer can be tested independently
- **Maintainability**: Clear separation of concerns makes code easier to understand and modify
- **Dependency control**: Business logic remains independent of framework details
- **Code organization**: Consistent structure across all features

## Prerequisites

Before starting this task, ensure you have:

1. **Completed Previous Tasks**:
   - Tasks 01-001-01 through 01-001-05: Initial project setup and validation
   - Task 01-002-01: Created lib/core/ for shared utilities, constants, and base classes
   - Task 01-002-02: Created lib/features/ for feature-specific modules

2. **Required Knowledge**:
   - Understanding of Clean Architecture principles
   - Familiarity with the dependency rule in Clean Architecture
   - Knowledge of the HR Connect feature modules (attendance, time_management, employee, admin, authentication)

3. **Development Environment**:
   - Flutter SDK 3.29+ installed
   - IDE (VS Code or Android Studio recommended)
   - Terminal/command-line access

## Clean Architecture Overview

Before implementing the layer structure, it's important to understand Clean Architecture principles and how they're applied in the HR Connect project.

### Key Principles

Clean Architecture organizes code into concentric layers, each with a specific responsibility:

1. **Inner layers**: Contain business logic and rules (domain layer)
2. **Middle layers**: Implement data access (data layer)
3. **Outer layers**: Handle UI and external frameworks (presentation layer)

### The Dependency Rule

The fundamental rule of Clean Architecture is that dependencies can only point inward:

- Inner layers know nothing about outer layers
- Outer layers depend on inner layers
- Domain layer has no dependencies on data or presentation layers
- Data layer depends only on domain layer
- Presentation layer depends only on domain layer (not data layer)

This one-way dependency flow ensures that business logic remains independent of UI and data access details, making the application more maintainable and testable.

### Clean Architecture in the MVSA Context

In the HR Connect MVSA approach:
- Each feature is a vertical slice representing a business capability
- Within each feature, code is organized horizontally by Clean Architecture layers
- Features depend on shared infrastructure in the core directory
- Features remain independent of each other

This combined approach provides the benefits of both vertical slice architecture (feature isolation) and Clean Architecture (separation of concerns).

## Layer Responsibilities and Components

Each layer in the Clean Architecture has specific responsibilities and contains particular types of components:

### Domain Layer

**Purpose**: Contains business logic, entities, and rules independent of any framework.

**Key characteristics**:
- Has no dependencies on data or presentation layers
- Contains only pure Dart code, no Flutter dependencies
- Knows nothing about the outer layers or frameworks

**Components**:

1. **entities/**: Business objects representing the core concepts of the application
   - Example: `AttendanceRecord`, `LeaveRequest`, `EmployeeProfile`
   - Pure Dart classes with properties and business logic
   - No framework dependencies

2. **repositories/**: Interfaces defining data access contracts
   - Example: `AttendanceRepository`, `LeaveRequestRepository`
   - Contains only abstract classes/interfaces
   - Defines methods that will be implemented in the data layer

3. **usecases/**: Application services that implement business logic
   - Example: `SubmitAttendanceUseCase`, `ApproveLeaveRequestUseCase`
   - Each use case typically performs a single business operation
   - Uses repository interfaces to access data

4. **failures/**: Business-specific failure types
   - Example: `AttendanceFailure`, `AuthenticationFailure`
   - Represents domain-specific error cases
   - Used with Either type from dartz for error handling

### Data Layer

**Purpose**: Implements data access and persistence logic.

**Key characteristics**:
- Depends only on the domain layer
- Implements interfaces defined in the domain layer
- Handles all data-related concerns (API communication, local storage)

**Components**:

1. **models/**: Data transfer objects (DTOs) that map to/from entities
   - Example: `AttendanceRecordModel`, `LeaveRequestModel`
   - Extensions of domain entities with serialization logic
   - Usually extends/implements a domain entity

2. **repositories/**: Concrete implementations of domain repository interfaces
   - Example: `AttendanceRepositoryImpl`, `LeaveRequestRepositoryImpl`
   - Implements the interfaces defined in domain layer
   - Coordinates between data sources to fulfill business requirements

3. **datasources/**: Local and remote data sources
   - Example: `AttendanceLocalDataSource`, `AttendanceRemoteDataSource`
   - Handles direct interaction with databases, APIs, etc.
   - Local sources manage offline storage (Drift, Flutter Data)
   - Remote sources handle API calls (Dio, HTTP)

4. **mappers/**: Classes that convert between models and entities
   - Example: `AttendanceMapper`, `EmployeeProfileMapper`
   - Handles conversion between domain entities and data models
   - Isolates conversion logic from repositories and data sources

### Presentation Layer

**Purpose**: Handles UI components and user interaction.

**Key characteristics**:
- Depends only on the domain layer, not on the data layer
- Manages UI state and user interaction
- Coordinates between UI components and domain use cases

**Components**:

1. **screens/**: Full-page UI components
   - Example: `AttendanceScanScreen`, `LeaveRequestFormScreen`
   - Contains the main page widgets
   - Composes multiple smaller widgets into a complete UI

2. **widgets/**: Reusable UI components
   - Example: `QrScannerWidget`, `LeaveRequestCard`
   - Smaller, reusable UI components
   - Used by screens and other widgets

3. **providers/**: Riverpod state providers and notifiers
   - Example: `AttendanceProvider`, `LeaveRequestNotifier`
   - Manages UI state using Riverpod
   - Connects domain use cases to UI components

4. **pages/**: Page routes and navigation
   - Example: `AppPages`, `AuthenticationRoutes`
   - Defines routes and navigation logic
   - Maps routes to screens

## Step-by-Step Implementation

Follow these steps to create the layer directories within each feature folder:

### Step 1: Create Basic Layer Directories

First, create the three main layer directories within each feature:

```bash
# Navigate to the project directory
cd path/to/hr_connect

# Create layer directories for attendance feature
mkdir -p lib/features/attendance/{domain,data,presentation}

# Create layer directories for time_management feature
mkdir -p lib/features/time_management/{domain,data,presentation}

# Create layer directories for employee feature
mkdir -p lib/features/employee/{domain,data,presentation}

# Create layer directories for admin feature
mkdir -p lib/features/admin/{domain,data,presentation}

# Create layer directories for authentication feature
mkdir -p lib/features/authentication/{domain,data,presentation}
```

### Step 2: Create Component Subdirectories

Now, create subdirectories within each layer to organize the different components:

#### 2.1 Domain Layer Components

```bash
# Create domain subdirectories for attendance feature
mkdir -p lib/features/attendance/domain/{entities,repositories,usecases,failures}

# Create domain subdirectories for time_management feature
mkdir -p lib/features/time_management/domain/{entities,repositories,usecases,failures}

# Create domain subdirectories for employee feature
mkdir -p lib/features/employee/domain/{entities,repositories,usecases,failures}

# Create domain subdirectories for admin feature
mkdir -p lib/features/admin/domain/{entities,repositories,usecases,failures}

# Create domain subdirectories for authentication feature
mkdir -p lib/features/authentication/domain/{entities,repositories,usecases,failures}
```

#### 2.2 Data Layer Components

```bash
# Create data subdirectories for attendance feature
mkdir -p lib/features/attendance/data/{models,repositories,datasources,mappers}

# Create data subdirectories for time_management feature
mkdir -p lib/features/time_management/data/{models,repositories,datasources,mappers}

# Create data subdirectories for employee feature
mkdir -p lib/features/employee/data/{models,repositories,datasources,mappers}

# Create data subdirectories for admin feature
mkdir -p lib/features/admin/data/{models,repositories,datasources,mappers}

# Create data subdirectories for authentication feature
mkdir -p lib/features/authentication/data/{models,repositories,datasources,mappers}
```

#### 2.3 Presentation Layer Components

```bash
# Create presentation subdirectories for attendance feature
mkdir -p lib/features/attendance/presentation/{screens,widgets,providers,pages}

# Create presentation subdirectories for time_management feature
mkdir -p lib/features/time_management/presentation/{screens,widgets,providers,pages}

# Create presentation subdirectories for employee feature
mkdir -p lib/features/employee/presentation/{screens,widgets,providers,pages}

# Create presentation subdirectories for admin feature
mkdir -p lib/features/admin/presentation/{screens,widgets,providers,pages}

# Create presentation subdirectories for authentication feature
mkdir -p lib/features/authentication/presentation/{screens,widgets,providers,pages}
```

### Step 3: Add Placeholder Files

Since Git doesn't track empty directories, add placeholder files to ensure the directory structure is properly tracked:

```bash
# Add .gitkeep files to each lowest-level directory
find lib/features -type d -empty -exec touch {}/.gitkeep \;
```

### Step 4: Create README Files for Layers

Create README.md files to document the purpose of each layer:

```bash
# Create domain layer README files
touch lib/features/attendance/domain/README.md
touch lib/features/time_management/domain/README.md
touch lib/features/employee/domain/README.md
touch lib/features/admin/domain/README.md
touch lib/features/authentication/domain/README.md

# Create data layer README files
touch lib/features/attendance/data/README.md
touch lib/features/time_management/data/README.md
touch lib/features/employee/data/README.md
touch lib/features/admin/data/README.md
touch lib/features/authentication/data/README.md

# Create presentation layer README files
touch lib/features/attendance/presentation/README.md
touch lib/features/time_management/presentation/README.md
touch lib/features/employee/presentation/README.md
touch lib/features/admin/presentation/README.md
touch lib/features/authentication/presentation/README.md
```

### Alternative: Script for Creating the Entire Structure

For convenience, you can create a shell script to generate the entire directory structure at once:

```bash
# Create a shell script
touch create_structure.sh
chmod +x create_structure.sh
```

Add the following content to the script:

```bash
#!/bin/bash

# Features array
features=("attendance" "time_management" "employee" "admin" "authentication")

# Domain components
domain_components=("entities" "repositories" "usecases" "failures")

# Data components
data_components=("models" "repositories" "datasources" "mappers")

# Presentation components
presentation_components=("screens" "widgets" "providers" "pages")

# Create directory structure
for feature in "${features[@]}"; do
  # Create layer directories
  mkdir -p "lib/features/$feature/domain"
  mkdir -p "lib/features/$feature/data"
  mkdir -p "lib/features/$feature/presentation"
  
  # Create domain components
  for component in "${domain_components[@]}"; do
    mkdir -p "lib/features/$feature/domain/$component"
    touch "lib/features/$feature/domain/$component/.gitkeep"
  done
  
  # Create data components
  for component in "${data_components[@]}"; do
    mkdir -p "lib/features/$feature/data/$component"
    touch "lib/features/$feature/data/$component/.gitkeep"
  done
  
  # Create presentation components
  for component in "${presentation_components[@]}"; do
    mkdir -p "lib/features/$feature/presentation/$component"
    touch "lib/features/$feature/presentation/$component/.gitkeep"
  done
  
  # Create README files
  touch "lib/features/$feature/domain/README.md"
  touch "lib/features/$feature/data/README.md"
  touch "lib/features/$feature/presentation/README.md"
done

echo "Directory structure created successfully!"
```

Then run the script:

```bash
./create_structure.sh
```

## Feature-Specific Layer Examples

Let's look at concrete examples of what each layer will contain for specific features:

### Attendance Feature

#### Domain Layer
- **entities/**: `AttendanceRecord`, `QrCode`, `AttendanceStatus` (enum)
- **repositories/**: `AttendanceRepository` (interface)
- **usecases/**: `ScanQrCodeUseCase`, `ValidateAttendanceUseCase`, `GetAttendanceHistoryUseCase`
- **failures/**: `AttendanceFailure`

#### Data Layer
- **models/**: `AttendanceRecordModel`, `QrCodeModel`
- **repositories/**: `AttendanceRepositoryImpl`
- **datasources/**: `AttendanceLocalDataSource`, `AttendanceRemoteDataSource`
- **mappers/**: `AttendanceMapper`, `QrCodeMapper`

#### Presentation Layer
- **screens/**: `QrScannerScreen`, `AttendanceHistoryScreen`
- **widgets/**: `QrScannerWidget`, `AttendanceRecordCard`
- **providers/**: `AttendanceProvider`, `QrScannerState`
- **pages/**: `AttendancePages`

### Time Management Feature

#### Domain Layer
- **entities/**: `LeaveRequest`, `OvertimeRequest`, `RemoteWorkRequest`
- **repositories/**: `LeaveRequestRepository`, `TimeManagementRepository`
- **usecases/**: `SubmitLeaveRequestUseCase`, `ApproveLeaveRequestUseCase`
- **failures/**: `TimeManagementFailure`

#### Data Layer
- **models/**: `LeaveRequestModel`, `OvertimeRequestModel`
- **repositories/**: `LeaveRequestRepositoryImpl`, `TimeManagementRepositoryImpl`
- **datasources/**: `TimeManagementLocalDataSource`, `TimeManagementRemoteDataSource`
- **mappers/**: `LeaveRequestMapper`, `OvertimeRequestMapper`

#### Presentation Layer
- **screens/**: `LeaveRequestFormScreen`, `LeaveApprovalScreen`
- **widgets/**: `LeaveCalendarWidget`, `RequestStatusBadge`
- **providers/**: `LeaveRequestProvider`, `TimeManagementState`
- **pages/**: `TimeManagementPages`

### Authentication Feature

#### Domain Layer
- **entities/**: `User`, `AuthToken`, `DeviceInfo`
- **repositories/**: `AuthenticationRepository`, `DeviceRepository`
- **usecases/**: `LoginUseCase`, `RefreshTokenUseCase`, `RegisterDeviceUseCase`
- **failures/**: `AuthenticationFailure`, `DeviceFailure`

#### Data Layer
- **models/**: `UserModel`, `AuthTokenModel`, `DeviceInfoModel`
- **repositories/**: `AuthenticationRepositoryImpl`, `DeviceRepositoryImpl`
- **datasources/**: `AuthLocalDataSource`, `AuthRemoteDataSource`
- **mappers/**: `UserMapper`, `TokenMapper`

#### Presentation Layer
- **screens/**: `LoginScreen`, `DeviceRegistrationScreen`
- **widgets/**: `LoginForm`, `BiometricAuthButton`
- **providers/**: `AuthProvider`, `LoginState`
- **pages/**: `AuthPages`

## README Content Examples

Here are examples of content you should add to the README.md files:

### Domain Layer README.md

```markdown
# Domain Layer

This directory contains the domain layer for the attendance feature. The domain layer represents the core business logic and rules, independent of any frameworks or implementation details.

## Structure

- **entities/**: Business objects and models
  - Pure Dart classes with no dependencies on other layers
  - Represent core concepts in the attendance domain

- **repositories/**: Interfaces defining data access contracts
  - Abstract classes only (no implementations)
  - Depend on domain entities

- **usecases/**: Application services implementing business logic
  - Each class represents a single business operation
  - Uses repositories to access data
  - Follows the Either pattern for error handling

- **failures/**: Business-specific failure types
  - Represent domain-specific error cases
  - Used with Either for error handling

## Dependencies

The domain layer:
- Has NO dependencies on the data or presentation layers
- Can depend ONLY on pure Dart packages and the core module
- Cannot import Flutter-specific packages

## Usage Guidelines

- Keep entities focused on business concepts, not technical details
- Use value objects for validated values
- Define repository methods based on business needs, not data structure
- Create specific use cases for each business operation
```

### Data Layer README.md

```markdown
# Data Layer

This directory contains the data layer for the attendance feature. The data layer implements data access and persistence logic for the domain layer.

## Structure

- **models/**: Data transfer objects (DTOs)
  - Extend domain entities with serialization logic
  - Handle JSON conversion and database mapping

- **repositories/**: Implementations of domain repository interfaces
  - Implement interfaces defined in the domain layer
  - Coordinate between data sources

- **datasources/**: Local and remote data sources
  - Local: Handles database operations (Drift)
  - Remote: Handles API communication (Dio)

- **mappers/**: Convert between models and entities
  - Isolate conversion logic

## Dependencies

The data layer:
- Can depend ONLY on the domain layer and the core module
- Cannot depend on the presentation layer
- Can use external packages for data access and persistence

## Usage Guidelines

- Keep repository implementations focused on the interface contract
- Separate network and database concerns into respective data sources
- Handle caching and offline persistence appropriately
- Implement the repository pattern for proper separation of concerns
```

### Presentation Layer README.md

```markdown
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
```

## Verification Steps

After creating the directory structure, verify that everything is set up correctly:

### 1. Check Full Directory Structure

Run the following command to list the complete directory structure:

```bash
find lib/features -type d | sort
```

Expected output (partial):
```
lib/features
lib/features/admin
lib/features/admin/data
lib/features/admin/data/datasources
lib/features/admin/data/mappers
lib/features/admin/data/models
lib/features/admin/data/repositories
lib/features/admin/domain
lib/features/admin/domain/entities
lib/features/admin/domain/failures
lib/features/admin/domain/repositories
lib/features/admin/domain/usecases
lib/features/admin/presentation
lib/features/admin/presentation/pages
lib/features/admin/presentation/providers
lib/features/admin/presentation/screens
lib/features/admin/presentation/widgets
...
```

### 2. Verify Placeholder Files

Check that placeholder files are present in the leaf directories:

```bash
find lib/features -name ".gitkeep" | wc -l
```

The output should match the total number of leaf directories created.

### 3. Verify README Files

Check that README files are created for all layers:

```bash
find lib/features -name "README.md" | sort
```

Expected output:
```
lib/features/admin/data/README.md
lib/features/admin/domain/README.md
lib/features/admin/presentation/README.md
lib/features/attendance/data/README.md
lib/features/attendance/domain/README.md
lib/features/attendance/presentation/README.md
...
```

### 4. Commit Changes to Version Control

Once you've verified the structure, commit the changes to Git:

```bash
git add lib/features
git commit -m "Create internal layer structure within feature folders"
```

## Common Issues and Solutions

### Issue: Dependency Rule Violations

**Problem**: Code in inner layers depends on outer layers, violating Clean Architecture principles.

**Solution**: 
- Ensure domain layer has no imports from data or presentation layers
- Use dependency injection to invert dependencies when needed
- Create interfaces in the domain layer that are implemented in outer layers

### Issue: Inconsistent Layer Organization

**Problem**: Different features organize their layers differently.

**Solution**:
- Follow the structure described in this guide consistently across all features
- Use the same component names and organization in each feature
- When in doubt, refer to the code organization section in the HR Connect guidelines

### Issue: Missing Files in Git

**Problem**: Empty directories aren't tracked in Git.

**Solution**:
- Ensure you've added `.gitkeep` files to all empty directories
- Run `find lib/features -type d -empty -exec touch {}/.gitkeep \;`

### Issue: Confusion About Component Placement

**Problem**: Uncertainty about where specific components should go.

**Solution**:
- **Domain Layer**: Business logic, entities, interfaces
- **Data Layer**: API communication, persistence, repository implementations
- **Presentation Layer**: UI components, state management
- Ask "Does this depend on Flutter or external frameworks?" If yes, it doesn't belong in the domain layer.

## Next Steps

After successfully creating the layer structure within each feature, you've completed the architecture foundation for the HR Connect project. The next steps will involve:

1. Implementing the actual code within this structure, starting with:
   - Domain entities and repositories
   - Core infrastructure setup
   - Feature-specific implementations

2. Following the test-driven development approach specified in the PRD:
   - Writing entity tests before implementation
   - Creating use case tests that verify business workflows
   - Testing repository implementations with mocked data sources

3. Implementing the specific features in this order (as recommended in the PRD):
   - Authentication (User authentication and device management)
   - QR Attendance System
   - Time Management
   - Employee Profile Management
   - Administrative Portals

This directory structure you've created provides the foundation for all subsequent development work on the HR Connect project, following both Clean Architecture principles and the Modified Vertical Slice Architecture approach.

## References

- [HR Connect PRD Section 4.1: Modified Vertical Slice Architecture](docs/requirements.md)
- [HR Connect PRD Section 6.1: Test-Driven Development (TDD) Approach](docs/requirements.md)
- [HR Connect Flutter Development Guidelines](docs/guidelines.md)
- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Reso Coder's Flutter TDD Clean Architecture Course](https://resocoder.com/flutter-clean-architecture-tdd/)

---

*Note for Cursor AI: When implementing this task, create the directory structure exactly as specified in this guide. The organization pattern follows Clean Architecture principles within the Modified Vertical Slice Architecture (MVSA) approach. Each feature should have the same internal structure with domain, data, and presentation layers, each containing the specified component subdirectories. Add .gitkeep files to ensure empty directories are tracked in version control, and create README.md files to document the purpose of each layer.*
