# Network Layer

This directory contains the network infrastructure for the HR Connect application, supporting API communication with offline-first capabilities.

## Purpose

- Manages API communication with remote services
- Implements offline-first network strategies
- Provides network connectivity checking
- Handles common network concerns like authentication, logging, and error handling
- Facilitates synchronization of local and remote data

## Key Components

- `api_client.dart`: Base API client setup using Dio
- `interceptors/`: Custom Dio interceptors for authentication, logging, etc.
- `connectivity_checker.dart`: Network connectivity utilities
- `models/`: Base request and response models
- `endpoints.dart`: API endpoint constants

## Usage

Import the API client to use in repository implementations:

```dart
import 'package:hr_connect/core/network/api_client.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiClient _apiClient;
  
  EmployeeRepositoryImpl(this._apiClient);
  
  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      final response = await _apiClient.get('/employees');
      final employees = response.data.map((e) => Employee.fromJson(e)).toList();
      return Right(employees);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
```

## Notes

- Use the provided ApiClient instead of direct Dio or http usage
- Handle offline scenarios appropriately
- Implement proper error handling for network operations
- Consider implementing retry mechanisms for flaky connections 