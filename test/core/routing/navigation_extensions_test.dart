// File: test/core/routing/navigation_extensions_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/routing/app_router.dart';
import 'package:hr_connect/core/routing/navigation_service.dart';
import 'package:hr_connect/core/routing/navigation_extensions.dart';
import 'package:hr_connect/core/routing/route_constants.dart';
import 'package:hr_connect/core/routing/route_arguments.dart';
import 'package:mockito/mockito.dart';

class MockAppRouter extends Mock implements AppRouter {}

void main() {
  late MockAppRouter mockRouter;
  late NavigationService navigationService;
  
  setUp(() {
    mockRouter = MockAppRouter();
    navigationService = NavigationService(mockRouter);
    
    // Set up default behaviors
    when(mockRouter.navigateTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
    when(mockRouter.replaceTo<dynamic>(any, arguments: anyNamed('arguments')))
        .thenAnswer((_) async => null);
  });
  
  group('NavigationServiceExtensions', () {
    test('toHome should navigate to home route', () async {
      // Act
      await navigationService.toHome();
      
      // Assert
      verify(mockRouter.navigateTo(RouteConstants.home)).called(1);
    });
    
    test('toQrScanner should navigate to QR scanner route', () async {
      // Act
      await navigationService.toQrScanner();
      
      // Assert
      verify(mockRouter.navigateTo(RouteConstants.qrScanner)).called(1);
    });
    
    test('toEmployeeProfile with ID should pass ID as argument', () async {
      // Arrange
      const employeeId = 'emp123';
      
      // Act
      await navigationService.toEmployeeProfile(employeeId: employeeId);
      
      // Assert
      verify(mockRouter.navigateTo(
        RouteConstants.employeeProfile,
        arguments: employeeId,
      )).called(1);
    });
    
    test('logout should replace with login route', () async {
      // Act
      await navigationService.logout();
      
      // Assert
      verify(mockRouter.replaceTo(RouteConstants.login)).called(1);
    });
  });
  
  group('NavigationWithResultsExtension', () {
    test('toLeaveRequestForResult should return result from navigation', () async {
      // Arrange
      const expectedResult = 'request123';
      when(mockRouter.navigateTo<String>(RouteConstants.leaveRequest))
          .thenAnswer((_) async => expectedResult);
      
      // Act
      final result = await navigationService.toLeaveRequestForResult();
      
      // Assert
      expect(result, equals(expectedResult));
      verify(mockRouter.navigateTo<String>(RouteConstants.leaveRequest)).called(1);
    });
  });
  
  group('ArgumentExtractionExtension', () {
    test('employeeProfileArgs should create correct arguments', () {
      // Arrange
      const employeeId = 'emp123';
      const showEditButton = false;
      
      // Act
      final args = navigationService.employeeProfileArgs(
        employeeId: employeeId,
        showEditButton: showEditButton,
      );
      
      // Assert
      expect(args, isA<EmployeeProfileArguments>());
      expect(args.employeeId, equals(employeeId));
      expect(args.showEditButton, equals(showEditButton));
    });
    
    test('attendanceDetailArgs should create correct arguments', () {
      // Arrange
      const attendanceId = 'att123';
      const allowEdit = true;
      
      // Act
      final args = navigationService.attendanceDetailArgs(
        attendanceId: attendanceId,
        allowEdit: allowEdit,
      );
      
      // Assert
      expect(args, isA<AttendanceDetailArguments>());
      expect(args.attendanceId, equals(attendanceId));
      expect(args.allowEdit, equals(allowEdit));
    });
  });
} 