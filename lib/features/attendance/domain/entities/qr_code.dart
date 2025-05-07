import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class QrCode extends Equatable {
  final String id;
  final DateTime timestamp;
  final String signature;
  final String locationId;
  final String nonce;
  
  const QrCode({
    required this.id,
    required this.timestamp,
    required this.signature,
    required this.locationId,
    required this.nonce,
  });
  
  /// Creates a QR code with the current timestamp
  factory QrCode.withTimestamp({
    required String locationId,
    String? signature,
  }) {
    final now = DateTime.now();
    const uuid = Uuid();
    
    return QrCode(
      id: uuid.v4(),
      timestamp: now,
      signature: signature ?? 'unsigned',
      locationId: locationId,
      nonce: uuid.v4(),
    );
  }
  
  /// Checks if the QR code is still valid based on a time window
  bool isValid({Duration validityWindow = const Duration(minutes: 15)}) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    return difference.inMilliseconds < validityWindow.inMilliseconds;
  }
  
  /// Encodes the QR code data for generation
  String encode() {
    return '$id|$locationId|${timestamp.toIso8601String()}|$nonce|$signature';
  }
  
  /// Decodes a string into a QR code object
  factory QrCode.decode(String encodedData) {
    final parts = encodedData.split('|');
    
    if (parts.length != 5) {
      throw const FormatException('Invalid QR code format');
    }
    
    return QrCode(
      id: parts[0],
      locationId: parts[1],
      timestamp: DateTime.parse(parts[2]),
      nonce: parts[3],
      signature: parts[4],
    );
  }
  
  @override
  List<Object> get props => [id, timestamp, signature, locationId, nonce];
}

enum QrValidationError {
  expired,
  invalidSignature,
  invalidFormat,
  locationMismatch,
  replayAttempt,
}

class ValidationResult {
  final bool isValid;
  final QrValidationError? errorCode;
  final String? errorMessage;
  
  const ValidationResult({
    required this.isValid,
    this.errorCode,
    this.errorMessage,
  });
  
  factory ValidationResult.valid() {
    return const ValidationResult(isValid: true);
  }
  
  factory ValidationResult.invalid(
    QrValidationError errorCode, {
    String? errorMessage,
  }) {
    return ValidationResult(
      isValid: false,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }
}
