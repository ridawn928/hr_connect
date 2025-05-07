# Testing Approach

This document outlines the testing strategy and approach used in HR Connect, which follows Test-Driven Development (TDD) principles.

## Overview

HR Connect employs a comprehensive testing strategy across all layers of the application:

- **Unit Tests**: Testing individual components in isolation
- **Widget Tests**: Testing UI components
- **Integration Tests**: Testing interactions between components
- **End-to-End Tests**: Testing complete user flows

The application follows the Test-Driven Development (TDD) workflow:
1. Write a failing test that defines the expected behavior
2. Write the minimum code to make the test pass
3. Refactor while keeping tests passing

## Test Types and Structure

### Unit Tests

Unit tests verify the behavior of individual components in isolation with dependencies mocked. They are organized by feature and layer:

```
test/
  unit/
    core/
      utils/
      network/
      security/
    features/
      authentication/
        domain/
        data/
      attendance/
        domain/
        data/
      time_management/
        domain/
        data/
```

#### Domain Layer Tests

Tests for domain entities, use cases, and business rules:

```dart
void main() {
  group('QrCode entity', () {
    late QrCodeValidator validator;
    
    setUp(() {
      validator = QrCodeValidator();
    });
    
    test('should be valid when timestamp is within 15 minutes', () {
      // Arrange
      final timestamp = DateTime.now().subtract(Duration(minutes: 10));
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: timestamp,
        signature: 'valid-signature',
      );
      
      // Act
      final result = validator.validate(qrCode);
      
      // Assert
      expect(result.isRight(), true);
    });
    
    test('should be invalid when timestamp is older than 15 minutes', () {
      // Arrange
      final timestamp = DateTime.now().subtract(Duration(minutes: 20));
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: timestamp,
        signature: 'valid-signature',
      );
      
      // Act
      final result = validator.validate(qrCode);
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<QrCodeExpiredFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });
  });
}
```

#### Repository Tests

Tests for repository implementations with mocked data sources:

```dart
@GenerateMocks([AttendanceLocalDataSource, AttendanceRemoteDataSource, NetworkInfo, SyncQueueService])
void main() {
  late AttendanceRepositoryImpl repository;
  late MockAttendanceLocalDataSource mockLocalDataSource;
  late MockAttendanceRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockSyncQueueService mockSyncQueueService;
  
  setUp(() {
    mockLocalDataSource = MockAttendanceLocalDataSource();
    mockRemoteDataSource = MockAttendanceRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSyncQueueService = MockSyncQueueService();
    repository = AttendanceRepositoryImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
      mockNetworkInfo,
      mockSyncQueueService,
    );
  });
  
  group('recordAttendance', () {
    test('should return remote data when online', () async {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: DateTime.now(),
        signature: 'valid-signature',
      );
      final pendingRecord = AttendanceRecord.createPending(
        employeeId: 'employee-1',
        timestamp: DateTime.now(),
        status: AttendanceStatus.pending,
        qrCodeId: qrCode.id,
      );
      final syncedRecord = pendingRecord.copyWith(
        status: AttendanceStatus.approved,
      );
      
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.saveAttendanceRecord(any))
          .thenAnswer((_) async => {});
      when(mockRemoteDataSource.submitAttendance(any))
          .thenAnswer((_) async => syncedRecord);
      when(mockLocalDataSource.updateAttendanceRecord(any))
          .thenAnswer((_) async => {});
      
      // Act
      final result = await repository.recordAttendance(qrCode);
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right, got Left'),
        (record) => expect(record, equals(syncedRecord)),
      );
      
      // Verify interactions
      verify(mockLocalDataSource.saveAttendanceRecord(any));
      verify(mockRemoteDataSource.submitAttendance(any));
      verify(mockLocalDataSource.updateAttendanceRecord(syncedRecord));
      verifyNever(mockSyncQueueService.addToQueue(any));
    });
    
    test('should queue sync operation when offline', () async {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: DateTime.now(),
        signature: 'valid-signature',
      );
      
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.saveAttendanceRecord(any))
          .thenAnswer((_) async => {});
      when(mockSyncQueueService.addToQueue(any))
          .thenAnswer((_) async => {});
      
      // Act
      final result = await repository.recordAttendance(qrCode);
      
      // Assert
      expect(result.isRight(), true);
      
      // Verify interactions
      verify(mockLocalDataSource.saveAttendanceRecord(any));
      verifyNever(mockRemoteDataSource.submitAttendance(any));
      verify(mockSyncQueueService.addToQueue(any));
    });
  });
}
```

### Widget Tests

Widget tests verify UI component behavior and are organized by feature:

```
test/
  widget/
    core/
      widgets/
    features/
      authentication/
      attendance/
      time_management/
```

Example of widget testing:

```dart
void main() {
  testWidgets('AttendanceQrScannerScreen shows success on valid QR code', 
      (WidgetTester tester) async {
    // Set up providers
    final qrValidatorProvider = MockQrValidatorProvider();
    final attendanceRepositoryProvider = MockAttendanceRepositoryProvider();
    
    // Configure mock behavior
    when(qrValidatorProvider.validate(any))
        .thenAnswer((_) => Right(true));
    when(attendanceRepositoryProvider.recordAttendance(any))
        .thenAnswer((_) async => Right(
          AttendanceRecord(
            id: 'record-1',
            employeeId: 'employee-1',
            timestamp: DateTime.now(),
            status: AttendanceStatus.approved,
          )
        ));
    
    // Build widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          qrValidatorProvider.overrideWithValue(qrValidatorProvider),
          attendanceRepositoryProvider.overrideWithValue(attendanceRepositoryProvider),
        ],
        child: MaterialApp(
          home: AttendanceQrScannerScreen(),
        ),
      ),
    );
    
    // Simulate a successful QR scan
    await tester.tap(find.byType(QrScanButton));
    await tester.pumpAndSettle();
    
    // Verify UI shows success message
    expect(find.text('Attendance recorded successfully'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
```

### Integration Tests

Integration tests verify interactions between different components and are organized by feature:

```
test/
  integration/
    features/
      authentication/
      attendance/
      time_management/
```

Example of integration testing:

```dart
@GenerateMocks([AuthenticationRepository, SecurityService])
void main() {
  late AuthenticationService authService;
  late MockAuthenticationRepository mockRepository;
  late MockSecurityService mockSecurityService;
  
  setUp(() {
    mockRepository = MockAuthenticationRepository();
    mockSecurityService = MockSecurityService();
    authService = AuthenticationService(
      mockRepository,
      mockSecurityService,
    );
  });
  
  test('login flow should complete successfully', () async {
    // Arrange
    const username = 'testuser';
    const password = 'password123';
    final authToken = AuthToken(
      token: 'jwt-token',
      refreshToken: 'refresh-token',
      expiresAt: DateTime.now().add(Duration(hours: 1)),
    );
    final user = User(
      id: 'user-1',
      name: 'Test User',
      email: 'test@example.com',
      role: UserRole.employee,
    );
    
    // Mock responses
    when(mockSecurityService.hashPassword(password))
        .thenReturn('hashed-password');
    when(mockRepository.login(username, 'hashed-password'))
        .thenAnswer((_) async => Right(authToken));
    when(mockRepository.getCurrentUser())
        .thenAnswer((_) async => Right(user));
    when(mockSecurityService.storeToken(authToken))
        .thenAnswer((_) async => {});
    
    // Act
    final result = await authService.login(username, password);
    
    // Assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right, got Left'),
      (loggedInUser) => expect(loggedInUser, equals(user)),
    );
    
    // Verify repository interactions
    verify(mockSecurityService.hashPassword(password));
    verify(mockRepository.login(username, 'hashed-password'));
    verify(mockSecurityService.storeToken(authToken));
    verify(mockRepository.getCurrentUser());
  });
}
```

### End-to-End Tests

End-to-end tests verify complete user flows and are implemented using Patrol for Flutter:

```
test/
  e2e/
    authentication_flow_test.dart
    attendance_flow_test.dart
    leave_request_flow_test.dart
```

Example of end-to-end testing:

```dart
void main() {
  patrolTest('user can login and record attendance', (PatrolTester $) async {
    // Setup any test fixtures/data
    
    // Start from the login screen
    await $.pumpWidget(MyApp());
    
    // Login flow
    await $(TextField).withHint('Username').enterText('testuser');
    await $(TextField).withHint('Password').enterText('password123');
    await $(ElevatedButton).withText('Login').tap();
    
    // Wait for home screen to appear
    await $.pumpAndSettle();
    expect($(HomePage), findsOneWidget);
    
    // Navigate to attendance screen
    await $(IconButton).withIcon(Icons.qr_code_scanner).tap();
    await $.pumpAndSettle();
    
    // Simulate scanning QR code
    await $(FloatingActionButton).withIcon(Icons.camera_alt).tap();
    await $.pumpAndSettle();
    
    // Mock the QR scan result
    await $.mockQrScan('valid-qr-code');
    await $.pumpAndSettle();
    
    // Verify success
    expect($(Text).withText('Attendance recorded successfully'), findsOneWidget);
  });
}
```

## Test Mocks and Fakes

HR Connect uses the following approaches for test doubles:

### Mockito for Mocks

Mockito is used to create mock objects with configurable behaviors:

```dart
@GenerateMocks([EmployeeRepository])
void main() {
  late MockEmployeeRepository mockRepository;
  late GetEmployeeUseCase useCase;
  
  setUp(() {
    mockRepository = MockEmployeeRepository();
    useCase = GetEmployeeUseCase(mockRepository);
  });
  
  test('should return employee when repository succeeds', () async {
    // Arrange
    const employeeId = 'employee-1';
    final employee = Employee(
      id: employeeId,
      name: 'John Doe',
      email: 'john@example.com',
    );
    
    when(mockRepository.getEmployee(employeeId))
        .thenAnswer((_) async => Right(employee));
    
    // Act
    final result = await useCase(employeeId);
    
    // Assert
    expect(result, Right(employee));
    verify(mockRepository.getEmployee(employeeId));
  });
}
```

### Fake Implementations

For complex objects, fake implementations are used:

```dart
class FakeSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};
  
  @override
  Future<void> write({
    required String key,
    required String value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage[key] = value;
  }
  
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }
  
  // Implement other methods...
}
```

### Riverpod Testing Utilities

For testing Riverpod providers:

```dart
void main() {
  test('filteredEmployeeProvider filters by department', () {
    // Create a container with overrides
    final container = ProviderContainer(
      overrides: [
        employeeListProvider.overrideWithValue([
          Employee(id: '1', name: 'Alice', department: 'Engineering'),
          Employee(id: '2', name: 'Bob', department: 'HR'),
          Employee(id: '3', name: 'Carol', department: 'Engineering'),
        ]),
        selectedDepartmentProvider.overrideWithValue('Engineering'),
      ],
    );
    
    // Read the provider
    final filteredEmployees = container.read(filteredEmployeeProvider);
    
    // Verify filtered result
    expect(filteredEmployees.length, 2);
    expect(filteredEmployees[0].name, 'Alice');
    expect(filteredEmployees[1].name, 'Carol');
    
    // Cleanup
    container.dispose();
  });
}
```

## Test Coverage

HR Connect aims for high test coverage across the codebase:

- **Domain Layer**: 90-100% coverage
- **Data Layer**: 80-90% coverage
- **Presentation Layer**: 70-80% coverage

Coverage is tracked using the `flutter_test_coverage` package:

```dart
// Run tests with coverage
flutter test --coverage

// Generate coverage report
flutter_test_coverage
```

## Best Practices

Follow these testing best practices for HR Connect:

1. **Write Tests First**: Follow the TDD workflow
2. **Keep Tests Independent**: Each test should run in isolation
3. **Mock External Dependencies**: Use mocks for external systems
4. **Test Error Cases**: Verify proper error handling
5. **Use Descriptive Test Names**: Clear test names that describe what's being tested
6. **Arrange-Act-Assert**: Structure tests in AAA pattern
7. **Test Business Rules Thoroughly**: Comprehensive testing of domain rules
8. **Limit Use of Actual UI Widget Testing**: Use `testWidgets` judiciously
9. **Group Related Tests**: Organize tests logically with `group`
10. **Maintain Test Coverage**: Don't let test coverage drop below targets 