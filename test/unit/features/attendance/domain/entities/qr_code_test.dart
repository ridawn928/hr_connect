import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/features/attendance/domain/entities/qr_code.dart';

void main() {
  group('QrCode entity', () {
    test('should reject QR code when timestamp is older than 15 minutes', () {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        signature: 'test-signature',
        locationId: 'test-location',
        nonce: 'test-nonce',
      );
      
      // Act
      final result = qrCode.isValid();
      
      // Assert
      expect(result, false);
    });
    
    test('should accept QR code when timestamp is within 15 minutes', () {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        signature: 'test-signature',
        locationId: 'test-location',
        nonce: 'test-nonce',
      );
      
      // Act
      final result = qrCode.isValid();
      
      // Assert
      expect(result, true);
    });
    
    test('should encode and decode QR code correctly', () {
      // Arrange
      final originalQrCode = QrCode(
        id: 'test-id',
        timestamp: DateTime(2025, 5, 7, 10, 30, 0),
        signature: 'test-signature',
        locationId: 'test-location',
        nonce: 'test-nonce',
      );
      
      // Act
      final encodedString = originalQrCode.encode();
      final decodedQrCode = QrCode.decode(encodedString);
      
      // Assert
      expect(decodedQrCode.id, originalQrCode.id);
      expect(decodedQrCode.timestamp, originalQrCode.timestamp);
      expect(decodedQrCode.signature, originalQrCode.signature);
      expect(decodedQrCode.locationId, originalQrCode.locationId);
      expect(decodedQrCode.nonce, originalQrCode.nonce);
    });
    
    test('should throw FormatException when decoding invalid string', () {
      // Arrange
      const invalidString = 'invalid-qr-code-string';
      
      // Act & Assert
      expect(
        () => QrCode.decode(invalidString),
        throwsA(isA<FormatException>()),
      );
    });
    
    test('should create QR code with current timestamp', () {
      // Arrange
      const locationId = 'test-location';
      final now = DateTime.now();
      
      // Act
      final qrCode = QrCode.withTimestamp(locationId: locationId);
      
      // Assert
      expect(qrCode.locationId, locationId);
      
      // Check that timestamp is within 1 second of now
      final difference = qrCode.timestamp.difference(now).inMilliseconds.abs();
      expect(difference, lessThan(1000));
      
      // Check that ID and nonce were generated
      expect(qrCode.id.isNotEmpty, true);
      expect(qrCode.nonce.isNotEmpty, true);
    });
  });
}
