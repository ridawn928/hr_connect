# Storage

This directory contains the data persistence infrastructure for the HR Connect application, supporting offline-first functionality.

## Purpose

- Manages local data persistence using Drift and Flutter Data
- Secures sensitive information with Flutter Secure Storage
- Handles database migrations and schemas
- Provides base repository interfaces
- Implements caching strategies for offline use

## Key Components

- `database.dart`: Drift database setup and configuration
- `secure_storage.dart`: Flutter Secure Storage wrapper
- `database_migrations/`: Database version migration handlers
- `tables/`: Drift table definitions
- `daos/`: Data Access Objects for database operations

## Usage

Import the database to use in repository implementations:

```dart
import 'package:hr_connect/core/storage/database.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AppDatabase _database;
  
  AttendanceRepositoryImpl(this._database);
  
  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceRecords(String employeeId) async {
    try {
      final records = await _database.attendanceDao.getByEmployeeId(employeeId);
      return Right(records);
    } on DriftException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

## Notes

- Use transactions for operations that modify multiple tables
- Implement proper error handling for database operations
- Consider performance implications for large datasets
- Follow the data model structure defined in the domain layer
- Respect the 7-day offline limit for data persistence 