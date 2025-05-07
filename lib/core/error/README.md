# Error Handling

This directory contains the error handling infrastructure for the HR Connect application using the Either type pattern from dartz.

## Purpose

- Provides a unified approach to error handling across the application
- Implements the Either type pattern for functional error handling
- Centralizes error types and failure classes
- Facilitates consistent error reporting and handling

## Key Components

- `failures.dart`: Base failure classes for domain layer errors
- `exceptions.dart`: Custom exception classes for data layer errors
- `app_error.dart`: Application-specific error types
- `result.dart`: Utility wrappers around the Either type

## Usage

Import the necessary files to use the error handling pattern:

```dart
import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';

// Return type indicating success or failure
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await userRepository.getUser(id);
    return Right(user);
  } on ServerException {
    return Left(ServerFailure());
  } on CacheException {
    return Left(CacheFailure());
  }
}
```

## Notes

- Always use Either<Failure, SuccessType> for operations that can fail
- Create specific Failure subclasses for different error types
- Handle errors at the appropriate level of abstraction
- Provide user-friendly error messages when presenting errors to users 