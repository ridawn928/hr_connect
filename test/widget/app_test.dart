import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/service_locator.dart';
import 'package:mockito/mockito.dart';
import 'package:hr_connect/core/routing/app_router.dart';

// Mock AppRouter
class MockAppRouter extends Mock implements AppRouter {
  @override
  RouterConfig<Object> get config => MockRouterConfig();
}

class MockRouterConfig extends Mock implements RouterConfig<Object> {}

void main() {
  setUp(() {
    // Set up GetIt for testing
    getIt = GetItMock();
    when(getIt<AppRouter>()).thenReturn(MockAppRouter());
  });

  tearDown(() {
    // Clean up GetIt after tests
    reset(getIt);
  });

  testWidgets('MyApp initializes with correct configuration',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify MaterialApp was created
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

// Mock of GetIt for testing
class GetItMock extends Mock implements GetIt {
  final Map<Type, Object> _instances = {};

  @override
  T get<T extends Object>() {
    if (_instances.containsKey(T)) {
      return _instances[T] as T;
    }
    return super.get<T>();
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _instances[T] = instance;
  }
}

// We need to define these methods for the mock
class GetIt {
  T get<T extends Object>();
  void registerSingleton<T extends Object>(T instance);
} 