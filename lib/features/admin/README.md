# Admin Feature

This directory contains the administrative portals (Payroll Portal and HR Portal) for the HR Connect application.

## Purpose

The admin feature enables:
- QR code generation for locations
- System configuration
- User management
- Report generation
- Policy configuration

## Key Components

- QR code generation interface
- System administration tools
- Role-based access control
- Multi-factor authentication for admin accounts
- Audit trails for administrative actions

## Technical Approach

This feature implements:
- Administrative tools using Clean Architecture
- Secure access control and authentication
- Offline-first data persistence with Flutter Data and Drift
- Riverpod for state management in the presentation layer 