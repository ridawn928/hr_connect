# Repository Pattern

This document explains the repository pattern implementation in HR Connect, which is used to abstract data access across the application.

## Overview

The repository pattern provides a clean separation between the domain layer and data access mechanisms. In HR Connect, it enables:

- Isolating the domain layer from data source implementation details
- Supporting multiple data sources (local database, remote API)
- Implementing offline-first functionality
- Centralizing data access logic and caching strategies
- Simplifying testing through dependency injection

## Repository Structure

Each repository in HR Connect follows this general structure:

```
features/
  feature_name/
    domain/
      repositories/
        feature_repository.dart    # Repository interface
    data/
      repositories/
        feature_repository_impl.dart  # Repository implementation
      datasources/
        feature_local_datasource.dart
        feature_remote_datasource.dart
```

## Repository Interface

Repository interfaces are defined in the domain layer and specify the contract that implementations must fulfill:

```dart
abstract class EmployeeRepository {
  /// Gets an employee by their ID.
  ///
  /// Returns a [Right] with the [Employee] if found,
  /// or a [Left] with a [Failure] if an error occurs.
  Future<Either<Failure, Employee>> getEmployee(String id);
  
  /// Gets all employees, optionally filtered by department.
  Future<Either<Failure, List<Employee>>> getEmployees({String? department});
  
  /// Creates or updates an employee.
  Future<Either<Failure, Unit>> saveEmployee(Employee employee);
  
  /// Deletes an employee by their ID.
  Future<Either<Failure, Unit>> deleteEmployee(String id);
  
  /// Returns a stream of all employees that updates when data changes.
  Stream<Either<Failure, List<Employee>>> watchEmployees({String? department});
}
```

## Data Sources

Repositories interact with data through data sources, which are responsible for communication with specific storage mechanisms:

### Local Data Source

Handles interaction with local storage (typically Drift database):

```dart
abstract class EmployeeLocalDataSource {
  Future<EmployeeModel> getEmployee(String id);
  Future<List<EmployeeModel>> getEmployees({String? department});
  Future<void> saveEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
  Stream<List<EmployeeModel>> watchEmployees({String? department});
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final AppDatabase _database;
  
  EmployeeLocalDataSourceImpl(this._database);
  
  @override
  Future<EmployeeModel> getEmployee(String id) async {
    try {
      final employee = await _database.employeeDao.getEmployeeById(id);
      return EmployeeModel.fromEntity(employee);
    } catch (e) {
      throw CacheException();
    }
  }
  
  // Other implementations...
}
```

### Remote Data Source

Handles interaction with remote APIs:

```dart
abstract class EmployeeRemoteDataSource {
  Future<EmployeeModel> getEmployee(String id);
  Future<List<EmployeeModel>> getEmployees({String? department});
  Future<void> saveEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio _dio;
  
  EmployeeRemoteDataSourceImpl(this._dio);
  
  @override
  Future<EmployeeModel> getEmployee(String id) async {
    try {
      final response = await _dio.get('/employees/$id');
      return EmployeeModel.fromJson(response.data);
    } on DioException {
      throw ServerException();
    }
  }
  
  // Other implementations...
}
```

## Repository Implementation

The repository implementation coordinates between local and remote data sources:

```dart
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource _localDataSource;
  final EmployeeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final SyncQueueService _syncQueueService;
  
  EmployeeRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
    this._syncQueueService,
  );
  
  @override
  Future<Either<Failure, Employee>> getEmployee(String id) async {
    try {
      // Always try local first for offline-first approach
      final localEmployee = await _localDataSource.getEmployee(id);
      
      // If online, attempt to get fresh data
      if (await _networkInfo.isConnected) {
        try {
          final remoteEmployee = await _remoteDataSource.getEmployee(id);
          
          // Cache the updated data locally
          await _localDataSource.saveEmployee(remoteEmployee);
          
          // Return the fresh data
          return Right(remoteEmployee.toDomain());
        } on ServerException {
          // If server fails but we have local data, return that
          return Right(localEmployee.toDomain());
        }
      }
      
      // If offline, return local data
      return Right(localEmployee.toDomain());
    } on CacheException {
      // No local data - try remote if online
      if (await _networkInfo.isConnected) {
        try {
          final remoteEmployee = await _remoteDataSource.getEmployee(id);
          
          // Cache for offline use
          await _localDataSource.saveEmployee(remoteEmployee);
          
          return Right(remoteEmployee.toDomain());
        } on ServerException {
          return Left(ServerFailure());
        }
      }
      
      // Offline and no local data
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, Unit>> saveEmployee(Employee employee) async {
    final employeeModel = EmployeeModel.fromDomain(employee);
    
    try {
      // Always save locally first
      await _localDataSource.saveEmployee(employeeModel);
      
      // Try to save remotely if online
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.saveEmployee(employeeModel);
          return const Right(unit);
        } on ServerException {
          // Queue for later sync if server fails
          await _syncQueueService.addToQueue(
            SyncOperation.createEmployeeSync(employee.id),
          );
          return const Right(unit);  // Return success since local save succeeded
        }
      } else {
        // If offline, queue for later sync
        await _syncQueueService.addToQueue(
          SyncOperation.createEmployeeSync(employee.id),
        );
        return const Right(unit);  // Return success since local save succeeded
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }
  
  // Other implementations...
}
```

## Dependency Injection

Repositories are registered using dependency injection with get_it and injectable:

```dart
@module
abstract class RepositoryModule {
  @lazySingleton
  EmployeeRepository provideEmployeeRepository(
    EmployeeLocalDataSource localDataSource,
    EmployeeRemoteDataSource remoteDataSource,
    NetworkInfo networkInfo,
    SyncQueueService syncQueueService,
  ) =>
      EmployeeRepositoryImpl(
        localDataSource,
        remoteDataSource,
        networkInfo,
        syncQueueService,
      );
}
```

## Offline-First Strategy

HR Connect's repository implementation follows these offline-first principles:

1. **Local-First Reading**: Always attempt to read from local storage first
2. **Background Synchronization**: Queue changes for sync when offline
3. **Cache Remote Data**: Store remote data locally for offline access
4. **Optimistic Updates**: Return success for local operations even when offline
5. **Sync Status Tracking**: Track synchronization status of entities

## Testing Repositories

Repositories are tested with mocked data sources:

```dart
void main() {
  late EmployeeRepositoryImpl repository;
  late MockEmployeeLocalDataSource mockLocalDataSource;
  late MockEmployeeRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockSyncQueueService mockSyncQueueService;
  
  setUp(() {
    mockLocalDataSource = MockEmployeeLocalDataSource();
    mockRemoteDataSource = MockEmployeeRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSyncQueueService = MockSyncQueueService();
    repository = EmployeeRepositoryImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
      mockNetworkInfo,
      mockSyncQueueService,
    );
  });
  
  // Tests for different scenarios...
}
```

## Common Repository Patterns

### Aggregate Repositories

For each aggregate in the domain model, HR Connect implements a corresponding repository:

- `EmployeeRepository`: Primary aggregate root
- `AuthenticationProfileRepository`: Authentication credentials and status
- `DeviceProfileRepository`: Registered devices
- `AttendanceProfileRepository`: Attendance records
- `RequestProfileRepository`: Leave requests and approvals
- `EmploymentProfileRepository`: Job details and organizational placement
- `PerformanceProfileRepository`: Goals, KPIs, and reviews
- `NotificationProfileRepository`: User notifications
- `SyncProfileRepository`: Synchronization status

### Caching Strategies

Repositories implement caching strategies appropriate to their data:

- **Time-Based Expiry**: For data that needs periodic refreshing
- **Entity-Version Tracking**: For data that changes frequently
- **Never Expire**: For reference data that rarely changes
- **Manual Refresh**: For user-initiated refresh operations

### Background Syncing

Repositories work with the `SyncQueueService` to manage offline changes:

1. When offline changes are made, a sync operation is queued
2. The background sync service processes these operations when online
3. The repository handles conflict resolution when syncing

## Best Practices

Follow these repository pattern best practices in HR Connect:

1. **Repository Naming**: Use clear, domain-focused names for repositories
2. **Single Responsibility**: Each repository should focus on a single aggregate
3. **Domain-Centric Interface**: Repository interfaces should use domain entities, not data models
4. **Error Handling**: Use the Either type for consistent error handling
5. **Caching Strategy**: Implement appropriate caching based on data characteristics
6. **Test Coverage**: Ensure comprehensive testing of offline and online scenarios
7. **Documentation**: Document the purpose and behavior of each repository method 