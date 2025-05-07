# Code Examples

This document provides code examples for common patterns used in HR Connect.

## Domain Entity

```dart
/// An employee in the system.
class Employee extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final Department department;
  final EmployeeStatus status;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.department,
    this.status = EmployeeStatus.active,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    Department? department,
    EmployeeStatus? status,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, department, status];
}

enum EmployeeStatus { active, inactive, onLeave }
```

## Repository Interface

```dart
/// Repository interface for employee data access.
abstract class EmployeeRepository {
  /// Gets an employee by their ID.
  Future<Either<Failure, Employee>> getEmployee(String id);
  
  /// Gets all employees, optionally filtered by department.
  Future<Either<Failure, List<Employee>>> getEmployees({
    String? departmentId,
    bool includeInactive = false,
  });
  
  /// Creates or updates an employee.
  Future<Either<Failure, Unit>> saveEmployee(Employee employee);
  
  /// Deletes an employee by their ID.
  Future<Either<Failure, Unit>> deleteEmployee(String id);
  
  /// Returns a stream of employees that updates when data changes.
  Stream<Either<Failure, List<Employee>>> watchEmployees({
    String? departmentId,
    bool includeInactive = false,
  });
}
```

## Use Case

```dart
class GetEmployeeUseCase {
  final EmployeeRepository _repository;

  GetEmployeeUseCase(this._repository);

  Future<Either<Failure, Employee>> call(String id) async {
    return await _repository.getEmployee(id);
  }
}

class SaveEmployeeUseCase {
  final EmployeeRepository _repository;

  SaveEmployeeUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Employee employee) async {
    return await _repository.saveEmployee(employee);
  }
}
```

## Data Model

```dart
/// Data model class for employee data transfer.
class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String departmentId;
  final String status;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.departmentId,
    required this.status,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      departmentId: json['department_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department_id': departmentId,
      'status': status,
    };
  }

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      phone: employee.phone,
      departmentId: employee.department.id,
      status: employee.status.toString().split('.').last,
    );
  }

  Employee toDomain(Department department) {
    return Employee(
      id: id,
      name: name,
      email: email,
      phone: phone,
      department: department,
      status: _mapStatus(status),
    );
  }

  EmployeeStatus _mapStatus(String status) {
    switch (status) {
      case 'active':
        return EmployeeStatus.active;
      case 'inactive':
        return EmployeeStatus.inactive;
      case 'onLeave':
        return EmployeeStatus.onLeave;
      default:
        return EmployeeStatus.active;
    }
  }
}
```

## Riverpod State Management

```dart
// Repository provider
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return ref.watch(employeeRepositoryImplProvider);
});

// Use case provider
final getEmployeeUseCaseProvider = Provider<GetEmployeeUseCase>((ref) {
  return GetEmployeeUseCase(ref.watch(employeeRepositoryProvider));
});

// State notifier
class EmployeeNotifier extends StateNotifier<AsyncValue<Employee>> {
  final GetEmployeeUseCase _getEmployeeUseCase;
  final SaveEmployeeUseCase _saveEmployeeUseCase;

  EmployeeNotifier(this._getEmployeeUseCase, this._saveEmployeeUseCase) 
      : super(const AsyncValue.loading());

  Future<void> getEmployee(String id) async {
    state = const AsyncValue.loading();
    final result = await _getEmployeeUseCase(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (employee) => AsyncValue.data(employee),
    );
  }

  Future<bool> saveEmployee(Employee employee) async {
    state = const AsyncValue.loading();
    final result = await _saveEmployeeUseCase(employee);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = AsyncValue.data(employee);
        return true;
      },
    );
  }
}

// State notifier provider
final employeeNotifierProvider = StateNotifierProvider.family<
    EmployeeNotifier, AsyncValue<Employee>, String>(
  (ref, id) {
    return EmployeeNotifier(
      ref.watch(getEmployeeUseCaseProvider),
      ref.watch(saveEmployeeUseCaseProvider),
    )..getEmployee(id);
  },
);

// Usage in UI
class EmployeeProfileScreen extends ConsumerWidget {
  final String id;

  const EmployeeProfileScreen({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeNotifierProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Profile')),
      body: employeeState.when(
        data: (employee) => EmployeeProfileView(employee: employee),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(message: error.toString()),
      ),
    );
  }
}
```

## Dependency Injection

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

## Error Handling

```dart
// Base failure class
abstract class Failure extends Equatable {
  final String message;
  
  const Failure([this.message = 'An unexpected error occurred']);
  
  @override
  List<Object> get props => [message];
}

// Specific failure types
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) 
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) 
      : super(message);
}

// Using Either for result type
Future<Either<Failure, Employee>> getEmployee(String id) async {
  try {
    final employee = await _localDataSource.getEmployee(id);
    return Right(employee.toDomain());
  } on CacheException {
    if (await _networkInfo.isConnected) {
      try {
        final employee = await _remoteDataSource.getEmployee(id);
        await _localDataSource.cacheEmployee(employee);
        return Right(employee.toDomain());
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(CacheFailure());
  }
}
``` 