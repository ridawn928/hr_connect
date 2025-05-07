# Attendance Feature

This directory contains the QR code attendance system for the HR Connect application.

## Purpose

The attendance feature enables:
- QR code-based attendance tracking
- Offline validation of attendance records
- Status classification (ON_TIME, LATE, etc.)
- Attendance history management
- Geolocation verification

## Key Components

- Time-based QR codes with embedded timestamps
- Device-based verification
- Configurable time windows (15 minutes by default)
- Offline validation capabilities
- Nonce tracking to prevent replay attacks

## Technical Approach

This feature implements:
- QR code generation and scanning using mobile_scanner and qr_flutter
- Offline-first data persistence with Flutter Data and Drift
- Secure validation with digital signatures
- Clean Architecture with domain, data, and presentation layers 