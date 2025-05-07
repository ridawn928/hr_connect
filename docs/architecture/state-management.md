# State Management

This document explains the state management approach in HR Connect, which is implemented using Riverpod (version 2.6.1).

## Overview

HR Connect uses Riverpod for state management to provide a reactive, testable, and maintainable solution. Riverpod offers several advantages:

- Improved testing capabilities over other state management solutions
- Built-in dependency injection
- Type safety and compile-time verification
- Simplified code with less boilerplate
- Efficient rebuilds that only affect widgets watching specific state
- Proper handling of asynchronous operations

## Provider Types

HR Connect uses several types of providers from Riverpod, each serving a specific purpose:

### 1. Provider

Used for simple read-only dependencies or computed values:

```dart
final filteredTodoListProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case Filter.none:
      return todos;
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
    case Filter.uncompleted:
      return todos.where((todo) => !todo.completed).toList();
  }
});
```

### 2. StateProvider

For simple state that can be updated from the UI:

```dart
final sortTypeProvider = StateProvider<SortType>((ref) => SortType.name);

// Usage in UI
DropdownButton<SortType>(
  value: ref.watch(sortTypeProvider),
  onChanged: (value) => ref.read(sortTypeProvider.notifier).state = value!,
  items: const [
    DropdownMenuItem(value: SortType.name, child: Text('Sort by name')),
    DropdownMenuItem(value: SortType.price, child: Text('Sort by price')),
  ],
)
```

### 3. NotifierProvider

For complex state management with immutable state and custom logic:

```dart
class TodosNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void toggle(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id == todoId)
          todo.copyWith(completed: !todo.completed)
        else
          todo,
    ];
  }
}

final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(TodosNotifier.new);
```

### 4. AsyncNotifierProvider

For asynchronous state management with loading, error, and data states:

```dart
class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    // Initial data fetch
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final userRepository = ref.read(userRepositoryProvider);
    return userRepository.getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchUsers);
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(UsersNotifier.new);
```

### 5. FutureProvider

For one-time asynchronous operations without custom logic:

```dart
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUser(userId);
});
```

### 6. StreamProvider

For reactive streams of data:

```dart
final userPresenceProvider = StreamProvider.family<bool, String>((ref, userId) {
  final presenceService = ref.watch(presenceServiceProvider);
  return presenceService.userPresenceStream(userId);
});
```

## Provider Organization

Providers in HR Connect are organized following these principles:

### 1. Feature-Specific Organization

Each feature has its own providers in a dedicated directory:

```
features/
  authentication/
    presentation/
      providers/
        auth_provider.dart
        login_provider.dart
        registration_provider.dart
```

### 2. Provider Types

Providers are categorized by their purpose:

- **Repository Providers**: Provide data repositories
- **Service Providers**: Provide business logic services
- **State Providers**: Manage UI and application state
- **Computed Providers**: Derive state based on other providers

### 3. Dependencies Between Providers

Providers depend on each other to create a reactive graph of dependencies:

```dart
// Repository provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl(ref.watch(databaseProvider));
});

// Service provider that depends on repository
final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService(ref.watch(attendanceRepositoryProvider));
});

// State provider that depends on service
final attendanceProvider = FutureProvider.family<List<AttendanceRecord>, String>((ref, userId) {
  return ref.watch(attendanceServiceProvider).getAttendanceForUser(userId);
});
```

## Handling Asynchronous State

HR Connect uses Riverpod's `AsyncValue` pattern for asynchronous operations, which handles loading, error, and data states:

```dart
class AttendanceHistoryScreen extends ConsumerWidget {
  final String userId;
  
  const AttendanceHistoryScreen({required this.userId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider(userId));
    
    return attendanceAsync.when(
      data: (records) => AttendanceListView(records: records),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorDisplay(message: error.toString()),
    );
  }
}
```

## Offline-First State Management

The offline-first approach in HR Connect requires special state management considerations:

### 1. Optimistic UI Updates

Updates are shown immediately in the UI before being persisted to the backend:

```dart
Future<void> submitAttendance(QrCode code) async {
  // Show optimistic UI update immediately
  state = state.copyWith(
    attendanceRecords: [...state.attendanceRecords, AttendanceRecord.pending(code)]
  );

  // Attempt to submit in background
  try {
    final result = await _attendanceRepository.submit(code);
    // Update with actual result on success
    state = state.copyWith(
      attendanceRecords: state.attendanceRecords
          .map((record) => record.isPending ? result : record)
          .toList()
    );
  } catch (e) {
    // Handle error but keep optimistic update
    // Schedule for background sync
    await _syncService.scheduleSync(
      SyncOperation.submitAttendance(code)
    );
  }
}
```

### 2. Sync Status Indicators

UI components display the synchronization status:

```dart
class SyncStatusIndicator extends ConsumerWidget {
  final String entityId;
  
  const SyncStatusIndicator({required this.entityId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider(entityId));
    
    return Icon(
      syncStatus == SyncStatus.pending
          ? Icons.sync_pending
          : syncStatus == SyncStatus.inProgress
              ? Icons.sync
              : syncStatus == SyncStatus.error
                  ? Icons.sync_problem
                  : Icons.sync_completed,
      color: syncStatus == SyncStatus.error ? Colors.red : Colors.green,
    );
  }
}
```

## Domain Events

For cross-feature communication, HR Connect uses domain events:

```dart
// Event definitions
abstract class DomainEvent {}

class AttendanceRecordedEvent extends DomainEvent {
  final String employeeId;
  final DateTime timestamp;

  AttendanceRecordedEvent(this.employeeId, this.timestamp);
}

// Event provider
final domainEventsProvider = StateProvider<List<DomainEvent>>((ref) => []);

// Publishing an event
void recordAttendance(String employeeId) {
  // ... business logic

  // Publish the event
  final currentEvents = ref.read(domainEventsProvider);
  ref.read(domainEventsProvider.notifier).state = [
    ...currentEvents,
    AttendanceRecordedEvent(employeeId, DateTime.now()),
  ];
}

// Subscribing to events
ref.listen<List<DomainEvent>>(domainEventsProvider, (previous, current) {
  final newEvents = previous == null
      ? current 
      : current.skip(previous.length).toList();

  for (final event in newEvents) {
    if (event is AttendanceRecordedEvent) {
      // Handle the event
      updateAttendanceSummary(event.employeeId);
    }
  }
});
```

## Provider Auto-Disposal

HR Connect uses Riverpod's auto-disposal feature to clean up resources automatically:

```dart
// Provider will be disposed when no longer in use
final userDetailsProvider = FutureProvider.autoDispose.family<UserDetails, String>((ref, userId) async {
  // Prevent disposal for 5 minutes even if no listeners
  ref.keepAlive();
  
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserDetails(userId);
});
```

## Performance Optimization

### 1. Selectors for Fine-grained Control

Use `select` to watch only specific parts of state:

```dart
// Instead of watching the entire user
// final user = ref.watch(userProvider);
// final userName = user.name;

// Watch only the name property
final userName = ref.watch(userProvider.select((user) => user.name));
```

### 2. Minimizing Rebuild Scopes

Use smaller widgets to minimize the scope of rebuilds:

```dart
// Bad: Entire screen rebuilds when user changes
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Column(
      children: [
        Text(user.name),
        ExpensiveWidget(),
      ],
    );
  }
}

// Good: Only the UserNameWidget rebuilds when name changes
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserNameWidget(),
        ExpensiveWidget(),
      ],
    );
  }
}

class UserNameWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProvider.select((user) => user.name));
    return Text(userName);
  }
}
```

## Integration with Widgets

### 1. ConsumerWidget

For StatelessWidgets that need to watch providers:

```dart
class UserProfileCard extends ConsumerWidget {
  final String userId;
  
  const UserProfileCard({required this.userId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userId));
    
    return user.when(
      data: (user) => UserCard(user: user),
      loading: () => const UserCardSkeleton(),
      error: (error, stack) => UserCardError(error: error),
    );
  }
}
```

### 2. ConsumerStatefulWidget

For StatefulWidgets that need to watch providers:

```dart
class EditProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  
  const EditProfileScreen({required this.userId, Key? key}) : super(key: key);
  
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    
    // Initialize with current user data
    final user = ref.read(userProvider(widget.userId));
    user.whenData((user) {
      _nameController.text = user.name;
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Watch for changes or errors
    final userState = ref.watch(userProvider(widget.userId));
    
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: userState.when(
        data: (user) => ProfileForm(
          nameController: _nameController,
          onSave: () => _saveProfile(),
        ),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(message: error.toString()),
      ),
    );
  }
  
  Future<void> _saveProfile() async {
    final userService = ref.read(userServiceProvider);
    await userService.updateName(widget.userId, _nameController.text);
    
    // Refresh user data
    ref.refresh(userProvider(widget.userId));
  }
}
```

### 3. ProviderScope

The root provider scope is defined in the app entry point:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

For testing or overriding providers, use overrides:

```dart
@override
Widget build(BuildContext context) {
  return ProviderScope(
    overrides: [
      userProvider.overrideWithValue(mockUser),
    ],
    child: MaterialApp(
      home: UserProfileScreen(),
    ),
  );
}
```

## Testing Providers

Riverpod provides excellent testing capabilities:

```dart
void main() {
  test('filteredTodoListProvider filters correctly', () {
    final container = ProviderContainer(
      overrides: [
        todoListProvider.overrideWithValue([
          Todo(id: '1', title: 'Test 1', completed: true),
          Todo(id: '2', title: 'Test 2', completed: false),
        ]),
        filterProvider.overrideWithValue(Filter.completed),
      ],
    );
    
    // Access the provider
    final filteredTodos = container.read(filteredTodoListProvider);
    
    // Verify the result
    expect(filteredTodos.length, 1);
    expect(filteredTodos.first.id, '1');
    
    // Clean up
    container.dispose();
  });
}
```

## Best Practices

When using Riverpod in HR Connect, follow these best practices:

1. **Avoid Provider Imports in Widgets**: Access providers through the `ref` parameter
2. **Keep State Minimal**: Store only what's needed; derive the rest
3. **Use AsyncValue**: For consistent handling of loading, error, and data states
4. **Optimize Rebuilds**: Use `select` and small widgets to minimize rebuilds
5. **Test Providers in Isolation**: Test business logic separately from UI
6. **Handle Errors Gracefully**: Use `AsyncValue.guard` or try-catch blocks
7. **Follow Feature-Based Organization**: Keep providers organized by feature
8. **Use Domain Events**: For cross-feature communication
9. **Document Providers**: Add clear documentation to explain each provider's purpose
10. **Clean Up Resources**: Use `ref.onDispose` to clean up resources when a provider is disposed 