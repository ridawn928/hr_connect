# Offline-First Architecture

This document explains the offline-first approach used in HR Connect, which allows users to continue working without an internet connection for up to 7 days (168 hours).

## Overview

HR Connect is designed as an offline-first application, meaning all core functionality works without an internet connection. This approach provides several benefits:

- Improved user experience in areas with poor connectivity
- Reduced data usage
- Better performance with local-first operations
- Ability to work continuously during intermittent connectivity
- Resilience against server outages

## Key Principles

The offline-first architecture follows these key principles:

1. **Local-First Data Access**: All data operations go through local storage first
2. **Background Synchronization**: Data is synchronized with the server when connectivity is available
3. **Conflict Resolution**: Clear strategies for handling conflicts between local and remote data
4. **Optimistic UI Updates**: Interface updates immediately before server confirmation
5. **Sync Status Indicators**: Clear visual feedback about synchronization status
6. **Prioritized Sync Queue**: Critical operations are synchronized first
7. **Time-Limited Offline Mode**: Support for up to 7 days offline operation

## Implementation Components

### 1. Storage Layer

HR Connect uses a multi-tiered storage approach:

#### Local Database (Drift)

Drift (SQLite ORM) provides the primary offline storage:

```dart
@DriftDatabase(
  tables: [
    Employees, 
    AttendanceRecords, 
    LeaveRequests, 
    SyncOperations
  ],
  daos: [
    EmployeeDao, 
    AttendanceDao, 
    LeaveRequestDao, 
    SyncOperationDao
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migration logic
    },
  );
}
```

#### Secure Storage

Flutter Secure Storage is used for sensitive information:

```dart
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  Future<void> storeEncryptionKey(String key) async {
    await _secureStorage.write(key: 'encryption_key', value: key);
  }
}
```

#### Cached Network Images

For efficient image handling:

```dart
class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final String employeeId;

  const ProfileImageWidget({
    required this.imageUrl,
    required this.employeeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.person),
      cacheKey: 'profile_$employeeId',
      cacheManager: CustomCacheManager.instance,
    );
  }
}

class CustomCacheManager {
  static const key = 'hRConnectCustomCache';
  static CacheManager? _instance;
  
  static CacheManager get instance {
    _instance ??= CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 100,
      ),
    );
    return _instance!;
  }
}
```

### 2. Repository Pattern

All data access is abstracted through repositories that handle both online and offline scenarios:

```dart
abstract class AttendanceRepository {
  Future<List<AttendanceRecord>> getAttendanceHistory(String employeeId);
  Future<Either<Failure, AttendanceRecord>> recordAttendance(QrCode qrCode);
  Future<Either<Failure, bool>> validateQrCode(QrCode qrCode);
  Stream<List<AttendanceRecord>> watchAttendanceHistory(String employeeId);
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource _localDataSource;
  final AttendanceRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final SyncQueueService _syncQueueService;

  AttendanceRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
    this._syncQueueService,
  );

  @override
  Future<Either<Failure, AttendanceRecord>> recordAttendance(QrCode qrCode) async {
    try {
      // Validate QR code locally first
      final validationResult = await validateQrCode(qrCode);
      
      if (validationResult.isLeft()) {
        return validationResult.fold(
          (failure) => Left(failure),
          (_) => throw Exception('Unexpected error'), // Should never reach here
        );
      }
      
      // Create a pending record
      final pendingRecord = AttendanceRecord.createPending(
        employeeId: qrCode.employeeId,
        timestamp: DateTime.now(),
        status: AttendanceStatus.pending,
        qrCodeId: qrCode.id,
      );
      
      // Save locally
      await _localDataSource.saveAttendanceRecord(pendingRecord);
      
      // Try to sync immediately if online
      if (await _networkInfo.isConnected) {
        try {
          final syncedRecord = await _remoteDataSource.submitAttendance(pendingRecord);
          await _localDataSource.updateAttendanceRecord(syncedRecord);
          return Right(syncedRecord);
        } on ServerException catch (e) {
          // Queue for later sync
          await _syncQueueService.addToQueue(
            SyncOperation.createAttendanceSync(pendingRecord.id),
          );
          return Right(pendingRecord);
        }
      } else {
        // Queue for later sync
        await _syncQueueService.addToQueue(
          SyncOperation.createAttendanceSync(pendingRecord.id),
        );
        return Right(pendingRecord);
      }
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
  
  // Other implementations...
}
```

### 3. Synchronization Mechanism

#### Sync Queue

The sync queue manages operations that need to be synchronized with the server:

```dart
@freezed
class SyncOperation with _$SyncOperation {
  const factory SyncOperation({
    required String id,
    required String entityId,
    required SyncEntityType entityType,
    required SyncOperationType operationType,
    required SyncPriority priority,
    required DateTime createdAt,
    DateTime? lastAttemptedAt,
    int? attemptCount,
    String? errorMessage,
    SyncStatus status,
  }) = _SyncOperation;
  
  factory SyncOperation.createAttendanceSync(String attendanceId) => 
    SyncOperation(
      id: Uuid().v4(),
      entityId: attendanceId,
      entityType: SyncEntityType.attendance,
      operationType: SyncOperationType.create,
      priority: SyncPriority.high,
      createdAt: DateTime.now(),
      status: SyncStatus.pending,
    );
}

enum SyncEntityType { attendance, leaveRequest, employee, notification }
enum SyncOperationType { create, update, delete }
enum SyncPriority { critical, high, medium, low }
enum SyncStatus { pending, inProgress, completed, failed }

class SyncQueueService {
  final SyncOperationDao _syncOperationDao;
  
  SyncQueueService(this._syncOperationDao);
  
  Future<void> addToQueue(SyncOperation operation) async {
    await _syncOperationDao.insertOperation(operation);
  }
  
  Future<List<SyncOperation>> getPendingOperations() async {
    return _syncOperationDao.getPendingOperations();
  }
  
  Future<List<SyncOperation>> getPendingOperationsByPriority(SyncPriority priority) async {
    return _syncOperationDao.getPendingOperationsByPriority(priority);
  }
  
  Future<void> markAsCompleted(String operationId) async {
    await _syncOperationDao.updateStatus(
      operationId, 
      SyncStatus.completed,
    );
  }
  
  Future<void> markAsFailed(String operationId, String errorMessage) async {
    final operation = await _syncOperationDao.getOperation(operationId);
    await _syncOperationDao.updateOperation(
      operation.copyWith(
        status: SyncStatus.failed,
        errorMessage: errorMessage,
        attemptCount: (operation.attemptCount ?? 0) + 1,
        lastAttemptedAt: DateTime.now(),
      ),
    );
  }
}
```

#### Background Sync Worker

WorkManager is used to perform background synchronization:

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize dependencies
    await initializeDependencies();
    
    switch (task) {
      case 'syncData':
        final syncService = getIt<SyncService>();
        await syncService.synchronize();
        break;
    }
    
    return true;
  });
}

class SyncService {
  final SyncQueueService _syncQueueService;
  final AttendanceRepository _attendanceRepository;
  final LeaveRequestRepository _leaveRequestRepository;
  final EmployeeRepository _employeeRepository;
  final NetworkInfo _networkInfo;
  
  SyncService(
    this._syncQueueService,
    this._attendanceRepository,
    this._leaveRequestRepository,
    this._employeeRepository,
    this._networkInfo,
  );
  
  Future<void> initializeBackgroundSync() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    
    await Workmanager().registerPeriodicTask(
      'syncData',
      'syncData',
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        batteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
    );
  }
  
  Future<void> synchronize() async {
    if (!await _networkInfo.isConnected) {
      return;
    }
    
    // Process operations in order of priority
    for (final priority in SyncPriority.values) {
      final operations = await _syncQueueService.getPendingOperationsByPriority(priority);
      
      for (final operation in operations) {
        await _processOperation(operation);
      }
    }
  }
  
  Future<void> _processOperation(SyncOperation operation) async {
    try {
      // Update status to in progress
      await _syncQueueService.updateStatus(operation.id, SyncStatus.inProgress);
      
      switch (operation.entityType) {
        case SyncEntityType.attendance:
          await _processAttendanceOperation(operation);
          break;
        case SyncEntityType.leaveRequest:
          await _processLeaveRequestOperation(operation);
          break;
        case SyncEntityType.employee:
          await _processEmployeeOperation(operation);
          break;
        default:
          throw Exception('Unknown entity type: ${operation.entityType}');
      }
      
      // Mark as completed
      await _syncQueueService.markAsCompleted(operation.id);
    } catch (e) {
      // Mark as failed with error message
      await _syncQueueService.markAsFailed(operation.id, e.toString());
    }
  }
  
  Future<void> _processAttendanceOperation(SyncOperation operation) async {
    switch (operation.operationType) {
      case SyncOperationType.create:
        final record = await _attendanceRepository.getLocalAttendanceRecord(operation.entityId);
        await _attendanceRepository.syncAttendanceRecord(record);
        break;
      // Other cases...
    }
  }
  
  // Other process methods...
}
```

### 4. Conflict Resolution

HR Connect implements various conflict resolution strategies:

#### Last-Write-Wins Strategy

For simple non-critical data:

```dart
Future<void> resolveEmployeeProfileConflict(
  EmployeeProfile localProfile,
  EmployeeProfile remoteProfile,
) async {
  // Compare timestamps
  if (localProfile.updatedAt.isAfter(remoteProfile.updatedAt)) {
    // Local changes are newer, push to server
    await _employeeRemoteDataSource.updateProfile(localProfile);
  } else {
    // Remote changes are newer, update local
    await _employeeLocalDataSource.updateProfile(remoteProfile);
  }
}
```

#### Field-Level Merging

For complex objects with multiple independently updatable fields:

```dart
Future<EmployeeProfile> mergeEmployeeProfiles(
  EmployeeProfile localProfile,
  EmployeeProfile remoteProfile,
) async {
  // Create a merged profile with latest data from each field
  return EmployeeProfile(
    id: localProfile.id,
    name: _resolveField(
      localProfile.name,
      remoteProfile.name,
      localProfile.nameUpdatedAt,
      remoteProfile.nameUpdatedAt,
    ),
    email: _resolveField(
      localProfile.email,
      remoteProfile.email,
      localProfile.emailUpdatedAt,
      remoteProfile.emailUpdatedAt,
    ),
    // Other fields...
    updatedAt: DateTime.now(),
  );
}

T _resolveField<T>(
  T localValue,
  T remoteValue,
  DateTime localUpdatedAt,
  DateTime remoteUpdatedAt,
) {
  return localUpdatedAt.isAfter(remoteUpdatedAt)
      ? localValue
      : remoteValue;
}
```

#### Business Rule-Based Resolution

For complex business entities like leave requests:

```dart
Future<LeaveRequest> resolveLeaveRequestConflict(
  LeaveRequest localRequest,
  LeaveRequest remoteRequest,
) async {
  // If the remote request has been approved or rejected, that takes precedence
  if (remoteRequest.status == LeaveStatus.approved ||
      remoteRequest.status == LeaveStatus.rejected) {
    return remoteRequest;
  }
  
  // If local request has been updated with new information, merge with remote status
  if (localRequest.updatedAt.isAfter(remoteRequest.updatedAt)) {
    return localRequest.copyWith(
      status: remoteRequest.status,
      reviewerNotes: remoteRequest.reviewerNotes,
    );
  }
  
  return remoteRequest;
}
```

### 5. Offline Time Limit

HR Connect enforces a 7-day offline limit:

```dart
class OfflineLimitService {
  final SecureStorageService _secureStorageService;
  
  OfflineLimitService(this._secureStorageService);
  
  Future<bool> isOfflineLimitExceeded() async {
    final lastSyncTimeString = await _secureStorageService.getLastSyncTime();
    
    if (lastSyncTimeString == null) {
      // First time use, not exceeded
      return false;
    }
    
    final lastSyncTime = DateTime.parse(lastSyncTimeString);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(lastSyncTime);
    
    // Check if more than 7 days (168 hours) have passed
    return difference.inHours > 168;
  }
  
  Future<void> updateLastSyncTime() async {
    await _secureStorageService.saveLastSyncTime(
      DateTime.now().toIso8601String(),
    );
  }
}
```

### 6. UI Synchronization Status

HR Connect provides clear indicators for sync status:

```dart
class SyncStatusProvider extends StateNotifier<Map<String, SyncStatus>> {
  final SyncQueueService _syncQueueService;
  
  SyncStatusProvider(this._syncQueueService) : super({}) {
    _initialize();
  }
  
  Future<void> _initialize() async {
    final operations = await _syncQueueService.getAllOperations();
    final statusMap = <String, SyncStatus>{};
    
    for (final operation in operations) {
      statusMap[operation.entityId] = operation.status;
    }
    
    state = statusMap;
    
    // Listen for changes
    _syncQueueService.operationsStream.listen((operations) {
      final updatedMap = Map<String, SyncStatus>.from(state);
      
      for (final operation in operations) {
        updatedMap[operation.entityId] = operation.status;
      }
      
      state = updatedMap;
    });
  }
  
  SyncStatus getStatusForEntity(String entityId) {
    return state[entityId] ?? SyncStatus.completed;
  }
}

final syncStatusProvider = StateNotifierProvider<SyncStatusProvider, Map<String, SyncStatus>>(
  (ref) => SyncStatusProvider(ref.watch(syncQueueServiceProvider)),
);

// Usage in UI
class SyncIndicator extends ConsumerWidget {
  final String entityId;
  
  const SyncIndicator({
    required this.entityId,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(
      syncStatusProvider.select((state) => state[entityId] ?? SyncStatus.completed)
    );
    
    return _buildIndicator(syncStatus);
  }
  
  Widget _buildIndicator(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return const Icon(Icons.pending_outlined, color: Colors.orange);
      case SyncStatus.inProgress:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SyncStatus.failed:
        return const Icon(Icons.sync_problem, color: Colors.red);
      case SyncStatus.completed:
        return const Icon(Icons.sync, color: Colors.green);
    }
  }
}
```

## Offline-First Challenges and Solutions

### 1. Data Consistency

**Challenge**: Maintaining data consistency between local and remote databases.

**Solution**: HR Connect uses a version tracking approach:

```dart
class VersionedEntity {
  final String id;
  final int version;
  final DateTime updatedAt;
  
  VersionedEntity({
    required this.id,
    required this.version,
    required this.updatedAt,
  });
  
  VersionedEntity incrementVersion() {
    return copyWith(
      version: version + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  VersionedEntity copyWith({
    String? id,
    int? version,
    DateTime? updatedAt,
  }) {
    return VersionedEntity(
      id: id ?? this.id,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 2. Complex Business Rules

**Challenge**: Enforcing business rules consistently offline and online.

**Solution**: All business rules are implemented in the domain layer and applied both locally and remotely:

```dart
@injectable
class ValidateLeaveRequestUseCase {
  Future<Either<Failure, bool>> call(LeaveRequest request) async {
    // Check for overlapping leave requests
    if (await _hasOverlappingRequests(request)) {
      return Left(ValidationFailure('Overlapping leave request exists'));
    }
    
    // Check for minimum notice period
    if (request.type == LeaveType.personal && 
        request.startDate.difference(DateTime.now()).inDays < 7) {
      return Left(ValidationFailure('Personal leave requires 7 days notice'));
    }
    
    // Check available leave balance
    if (!await _hasEnoughLeaveBalance(request)) {
      return Left(ValidationFailure('Insufficient leave balance'));
    }
    
    return Right(true);
  }
  
  // Rule implementations...
}
```

### 3. Data Security

**Challenge**: Securing sensitive data during offline operation.

**Solution**: Field-level encryption for sensitive data:

```dart
class EncryptionService {
  final EncryptionKey _key;
  final IV _iv;
  late final Encrypter _encrypter;
  
  EncryptionService(this._key, this._iv) {
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
  }
  
  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }
  
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

class EmployeeRepository {
  final EncryptionService _encryptionService;
  
  // Other dependencies...
  
  Future<Employee> getEmployee(String id) async {
    final encryptedEmployee = await _localDataSource.getEmployee(id);
    
    // Decrypt sensitive fields
    return Employee(
      id: encryptedEmployee.id,
      name: encryptedEmployee.name,
      email: encryptedEmployee.email,
      phone: _encryptionService.decrypt(encryptedEmployee.phone),
      nationalId: _encryptionService.decrypt(encryptedEmployee.nationalId),
      // Other fields...
    );
  }
  
  Future<void> saveEmployee(Employee employee) async {
    // Encrypt sensitive fields
    final encryptedEmployee = EmployeeEntity(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      phone: _encryptionService.encrypt(employee.phone),
      nationalId: _encryptionService.encrypt(employee.nationalId),
      // Other fields...
    );
    
    await _localDataSource.saveEmployee(encryptedEmployee);
    
    // Sync if online
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.saveEmployee(encryptedEmployee);
      } catch (e) {
        await _syncQueueService.addToQueue(
          SyncOperation.createEmployeeSync(employee.id),
        );
      }
    } else {
      await _syncQueueService.addToQueue(
        SyncOperation.createEmployeeSync(employee.id),
      );
    }
  }
}
```

### 4. Network Efficiency

**Challenge**: Optimizing network usage when returning online.

**Solution**: Delta syncing to only transmit changes:

```dart
class DeltaSyncService {
  final SyncQueueService _syncQueueService;
  final LastSyncTimeRepository _lastSyncTimeRepository;
  
  DeltaSyncService(
    this._syncQueueService,
    this._lastSyncTimeRepository,
  );
  
  Future<void> performDeltaSync() async {
    final lastSyncTime = await _lastSyncTimeRepository.getLastSyncTime();
    
    if (lastSyncTime == null) {
      // First sync, perform full sync
      await _performFullSync();
      return;
    }
    
    // Get changes since last sync
    final remoteChanges = await _fetchRemoteChangesSince(lastSyncTime);
    final localChanges = await _fetchLocalChangesSince(lastSyncTime);
    
    // Resolve conflicts and apply changes
    await _resolveAndApplyChanges(remoteChanges, localChanges);
    
    // Update last sync time
    await _lastSyncTimeRepository.saveLastSyncTime(DateTime.now());
  }
  
  // Implementation details...
}
```

### 5. Large Data Sets

**Challenge**: Handling large datasets with limited device storage.

**Solution**: Incremental loading and data pruning:

```dart
class DataPruningService {
  final AppDatabase _database;
  
  DataPruningService(this._database);
  
  Future<void> pruneOldData() async {
    // Keep attendance records for the last 3 months
    final cutoffDate = DateTime.now().subtract(Duration(days: 90));
    await _database.attendanceDao.deleteRecordsBefore(cutoffDate);
    
    // Keep completed leave requests for the last 6 months
    final leaveRequestCutoff = DateTime.now().subtract(Duration(days: 180));
    await _database.leaveRequestDao.deleteCompletedRequestsBefore(leaveRequestCutoff);
    
    // Keep notifications for the last 30 days
    final notificationCutoff = DateTime.now().subtract(Duration(days: 30));
    await _database.notificationDao.deleteNotificationsBefore(notificationCutoff);
  }
  
  Future<void> pruneAttachments() async {
    // Get all attachment paths still referenced in the database
    final referencedAttachments = await _database.attachmentDao.getAllReferencedAttachmentPaths();
    
    // Get all files in the attachments directory
    final directory = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${directory.path}/attachments');
    final files = attachmentsDir.listSync();
    
    // Delete unreferenced files
    for (final file in files) {
      if (file is File && !referencedAttachments.contains(file.path)) {
        await file.delete();
      }
    }
  }
}
```

## Best Practices

When implementing the offline-first approach in HR Connect, follow these best practices:

1. **Always Access Data Through Repositories**: Never bypass the repository layer
2. **Handle All Error Cases**: Account for both network and local storage errors
3. **Show Clear Sync Status**: Always indicate synchronization status to users
4. **Implement Business Rules Consistently**: Apply the same validation online and offline
5. **Minimize Network Usage**: Use delta syncing and compression where possible
6. **Protect Sensitive Data**: Use encryption for sensitive information
7. **Test Offline Scenarios**: Thoroughly test application behavior in offline mode
8. **Manage Device Storage**: Implement data pruning to prevent excessive storage use
9. **Prioritize Critical Operations**: Sync high-priority operations first
10. **Design for Conflict Resolution**: Plan conflict resolution strategies upfront 