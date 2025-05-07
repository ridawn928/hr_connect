# HR Connect Architecture Documentation

## Overview

HR Connect is a Flutter-based mobile workforce management solution designed with a Modified Vertical Slice Architecture (MVSA) and an offline-first approach. This documentation provides comprehensive information about the architectural decisions, patterns, and implementation guidelines used throughout the project.

The architecture follows these core principles:
- **Modified Vertical Slice Architecture** for business-capability-centered organization
- **Clean Architecture** within each vertical slice
- **Aggregate Pattern** with Employee as the primary aggregate root
- **Offline-first** approach with robust synchronization
- **Repository Pattern** for data access abstraction
- **Functional Error Handling** using the Either pattern from dartz

## Documentation Structure

This documentation is organized into several sections, each focusing on a specific aspect of the architecture:

1. [MVSA Overview](./mvsa-overview.md) - Explanation of the Modified Vertical Slice Architecture pattern
2. [Folder Structure](./folder-structure.md) - Project organization and directory layout
3. [Dependency Injection](./dependency-injection.md) - DI implementation with get_it and injectable
4. [State Management](./state-management.md) - Riverpod implementation for reactive state
5. [Repository Pattern](./repository-pattern.md) - Implementation of the Repository pattern for data access
6. [Offline-First Architecture](./offline-first.md) - Offline capabilities and synchronization mechanisms
7. [Testing Approach](./testing-approach.md) - Test-driven development and testing strategies
8. [Coding Standards](./coding-standards.md) - Development conventions and best practices

## Key Features

HR Connect includes several business capabilities implemented as vertical slices:

- **Authentication and Device Management** - JWT-based authentication with device limitation
- **QR Code Attendance** - Time-based QR codes with validation
- **Employee Profile Management** - Complete CRUD operations with offline support
- **Comprehensive Time Management** - Leave types, approvals, and time tracking
- **Administrative Portals** - Role-based portals for different administrative tasks

## Core Technologies

The application is built using:

- **Flutter 3.29+** and **Dart 3.7+**
- **Riverpod 2.6.1** for state management
- **get_it** and **injectable** for dependency injection
- **Drift 2.26.1** for local database
- **auto_route** for navigation
- **dartz** for functional error handling
- **Flutter Secure Storage** for sensitive data
- **WorkManager** for background synchronization

## Getting Started

For new developers joining the project, we recommend starting with:

1. Review the [MVSA Overview](./mvsa-overview.md) to understand the architectural approach
2. Examine the [Folder Structure](./folder-structure.md) to get familiar with the codebase organization
3. Study the [Dependency Injection](./dependency-injection.md) to understand how services are registered and accessed
4. Learn the [State Management](./state-management.md) approach to understand how application state is handled
5. Understand the [Repository Pattern](./repository-pattern.md) to see how data access is abstracted

## Contributing

When contributing to this codebase, please adhere to the [Coding Standards](./coding-standards.md) and follow the architectural patterns established in this documentation. 