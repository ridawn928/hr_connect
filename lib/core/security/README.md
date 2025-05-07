# Security

This directory contains the security infrastructure for the HR Connect application, managing authentication, encryption, and other security concerns.

## Purpose

- Manages JWT authentication and token lifecycle
- Implements data encryption for sensitive employee information
- Provides biometric authentication integration
- Handles secure storage of credentials and tokens
- Enforces role-based access control

## Key Components

- `jwt_service.dart`: JWT token management and refresh logic
- `encryption.dart`: Data encryption utilities for employee PII
- `biometric_auth.dart`: Fingerprint/Face ID integration
- `certificate_pinning.dart`: Network security enhancements
- `role_based_access.dart`: Permission verification utilities

## Usage

Import the required security services in your code:

```dart
import 'package:hr_connect/core/security/jwt_service.dart';
import 'package:hr_connect/core/security/encryption.dart';

class AuthRepositoryImpl implements AuthRepository {
  final JwtService _jwtService;
  final EncryptionService _encryptionService;
  
  AuthRepositoryImpl(this._jwtService, this._encryptionService);
  
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final token = await _jwtService.authenticate(username, password);
      // Store and use the token
      return Right(User.fromToken(token));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> storeConfidentialData(String data) async {
    try {
      final encrypted = _encryptionService.encrypt(data);
      // Store the encrypted data
      return const Right(unit);
    } on EncryptionException catch (e) {
      return Left(SecurityFailure(e.message));
    }
  }
}
```

## Notes

- Follow security best practices for authentication and encryption
- Use proper salting and hashing techniques for passwords
- Store sensitive information only in Flutter Secure Storage
- Implement token refresh mechanisms
- Limit each employee to a maximum of 2 registered devices as per requirements 