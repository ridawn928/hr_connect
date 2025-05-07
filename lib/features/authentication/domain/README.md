# Domain Layer

This directory contains the domain layer for the authentication feature. The domain layer represents the core business logic and rules, independent of any frameworks or implementation details.

## Structure

- **entities/**: Business objects and models
  - Pure Dart classes with no dependencies on other layers
  - Represent core concepts in the authentication domain (User, AuthToken, DeviceInfo, etc.)

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