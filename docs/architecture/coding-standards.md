# Coding Standards

This document outlines the coding standards and conventions used in HR Connect to ensure consistency, readability, and maintainability across the codebase.

## Dart Style Guide

HR Connect follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) with additional project-specific conventions.

### Naming Conventions

- **Files and Directories**: Use `snake_case` for all file and directory names
  ```
  authentication_repository.dart
  user_profile_screen.dart
  ```

- **Classes and Enums**: Use `PascalCase` for class, enum, extension, and typedef names
  ```dart
  class EmployeeRepository { ... }
  enum AttendanceStatus { onTime, late, absent }
  extension StringExtension on String { ... }
  ```

- **Variables, Functions, and Parameters**: Use `camelCase` for variables, functions, methods, and parameters
  ```dart
  final employeeName = 'John Doe';
  void calculateSalary() { ... }
  ```

- **Constants**: Use `camelCase` for constants
  ```dart
  const defaultTimeout = Duration(seconds: 30);
  const apiBaseUrl = 'https://api.example.com';
  ```

- **Private Members**: Prefix private members with an underscore
  ```dart
  class UserService {
    final AuthenticationRepository _authRepository;
    void _handleError(Exception error) { ... }
  }
  ```

### Formatting Guidelines

- **Line Length**: Keep lines under 80 characters
- **Indentation**: Use 2 spaces for indentation (no tabs)
- **Trailing Commas**: Add trailing commas for multi-line structures
  ```dart
  final items = [
    'Item 1',
    'Item 2',
    'Item 3',
  ];
  ```
- **Curly Braces**: Use curly braces for all control flow statements, even single-line statements
  ```dart
  // Good
  if (isLoading) {
    return LoadingIndicator();
  }

  // Avoid
  if (isLoading) return LoadingIndicator();
  ```

### Type Safety

- **Explicit Types**: Always specify types for public APIs and function signatures
  ```dart
  // Good
  List<Employee> getEmployeesByDepartment(String department) { ... }

  // Avoid
  getEmployeesByDepartment(department) { ... }
  ```

- **Avoid Dynamic**: Avoid using `dynamic` type unless absolutely necessary
- **Prefer Final**: Use `final` for variables that don't change after initialization
- **Use Const**: Use `const` for compile-time constants

## Code Organization

### File Structure

Each file should be organized in the following order:

1. Imports (organized by category with a blank line separator)
   - Dart SDK imports
   - Package imports
   - Relative imports
2. Part declarations
3. Constants
4. Class declaration

Example:

```dart
// Dart SDK imports
import 'dart:async';
import 'dart:convert';

// Package imports
import 'package:flutter/material.dart';
import 'package:hr_connect/core/error/failures.dart';

// Relative imports
import '../repositories/authentication_repository.dart';
import '../models/user.dart';

part 'auth_event.dart';

const int maxLoginAttempts = 3;

class AuthenticationService {
  // Class implementation
}
```

### Import Organization

Organize imports alphabetically within each category:

```dart
// Correct
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

## Comments and Documentation

### Documentation Comments

Use documentation comments (`///`) for all public APIs:

```dart
/// Returns a list of employees belonging to the specified department.
///
/// If [includeInactive] is true, inactive employees are also included.
/// Throws a [NotFoundException] if the department doesn't exist.
List<Employee> getEmployeesByDepartment(
  String department, {
  bool includeInactive = false,
}) {
  // Implementation
}
```

### Class Documentation

Document all classes with a description of their purpose:

```dart
/// A service that manages employee attendance records.
///
/// This service handles QR code validation, attendance recording,
/// and status classification based on time and policy rules.
class AttendanceService {
  // Implementation
}
```

### TODO Comments

Mark incomplete code with TODO comments that include the owner:

```dart
// TODO(johndoe): Implement offline validation for QR codes.
```

## Error Handling

### Either Type for Results

Use the `Either` type from the dartz package for error handling:

```dart
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await _repository.getUser(id);
    return Right(user);
  } on ServerException {
    return Left(ServerFailure());
  } on CacheException {
    return Left(CacheFailure());
  }
}
```

### Specific Exceptions

Create specific exception classes for different error scenarios:

```dart
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}
```

## Architecture-Specific Standards

### Domain Layer

- Use `Entity` suffix for domain entities
- Use `Repository` suffix for repository interfaces
- Use `UseCase` suffix for use case classes
- Place value objects in a `value_objects` directory

```dart
// Entity
class EmployeeEntity { ... }

// Repository interface
abstract class EmployeeRepository { ... }

// Use case
class GetEmployeeUseCase { ... }

// Value object
class EmailAddress { ... }
```

### Data Layer

- Use `Model` suffix for data models
- Use `RepositoryImpl` suffix for repository implementations
- Use `DataSource` suffix for data sources

```dart
// Data model
class EmployeeModel { ... }

// Repository implementation
class EmployeeRepositoryImpl implements EmployeeRepository { ... }

// Data source
abstract class EmployeeLocalDataSource { ... }
```

### Presentation Layer

- Use `Screen` suffix for screens
- Use `Widget` suffix for reusable widgets
- Use `Provider`, `Notifier`, or `Controller` suffix for state management classes

```dart
// Screen
class EmployeeProfileScreen extends StatelessWidget { ... }

// Widget
class AttendanceCardWidget extends StatelessWidget { ... }

// Provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});
```

## Dependencies and Packages

### Version Constraints

Specify explicit version constraints in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  dio: ^5.5.0
```

### Usage Guidelines

- **Dio**: Use for HTTP requests
- **Flutter Riverpod**: Use for state management
- **Drift**: Use for local database
- **Flutter Secure Storage**: Use for sensitive data storage
- **WorkManager**: Use for background processing
- **Freezed**: Use for immutable classes and sealed unions
- **GetIt & Injectable**: Use for dependency injection

## Testing Guidelines

### Test File Organization

Name test files with `_test` suffix and place them in a mirrored directory structure:

```
lib/features/authentication/domain/use_cases/login_use_case.dart
test/features/authentication/domain/use_cases/login_use_case_test.dart
```

### Test Structure

Structure tests using the Arrange-Act-Assert pattern:

```dart
test('should return user when login credentials are valid', () async {
  // Arrange
  when(mockAuthRepository.login(any, any))
      .thenAnswer((_) async => Right(tUser));
  
  // Act
  final result = await useCase(LoginParams(email: 'test@example.com', password: 'password123'));
  
  // Assert
  expect(result, Right(tUser));
  verify(mockAuthRepository.login('test@example.com', 'password123'));
  verifyNoMoreInteractions(mockAuthRepository);
});
```

### Mock Naming

Prefix mock class names with `Mock`:

```dart
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}
```

## Performance Guidelines

- Use `const` constructors for widgets when possible
- Avoid unnecessary rebuilds in the widget tree
- Keep business logic out of the UI layer
- Use pagination for large lists
- Minimize use of global state
- Profile and optimize CPU-intensive operations

## Accessibility Guidelines

- Ensure proper contrast ratios for text
- Add meaningful labels for screen reader support
- Support keyboard navigation
- Implement proper focus management
- Test with screen readers

## Security Guidelines

- Never store sensitive data (passwords, tokens) in plain text
- Use encrypted storage for sensitive data
- Validate all user inputs
- Avoid hard-coded credentials
- Implement proper authentication token management
- Apply field-level encryption for sensitive user data

## Code Review Checklist

Before submitting code for review, ensure:

- [ ] Code follows the style guidelines
- [ ] All tests pass
- [ ] New code has adequate test coverage
- [ ] Documentation is updated
- [ ] No debugging code is left in
- [ ] Error cases are handled
- [ ] Performance considerations are addressed
- [ ] Security considerations are addressed 