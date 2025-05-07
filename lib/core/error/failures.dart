import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Server failures
class ServerFailure extends Failure {
  final String? message;
  
  ServerFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Cache failures
class CacheFailure extends Failure {
  final String? message;
  
  CacheFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Network failures
class NetworkFailure extends Failure {
  final String? message;
  
  NetworkFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Authentication failures
class AuthenticationFailure extends Failure {
  final String? message;
  
  AuthenticationFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Validation failures
class ValidationFailure extends Failure {
  final String? message;
  
  ValidationFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Synchronization failures
class SyncFailure extends Failure {
  final String? message;
  
  SyncFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

// Permission failures
class PermissionFailure extends Failure {
  final String? message;
  
  PermissionFailure({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}
