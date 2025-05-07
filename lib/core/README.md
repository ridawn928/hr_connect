# Core Module

This directory contains shared infrastructure, utilities, constants, and base classes used across the HR Connect application. It follows the Modified Vertical Slice Architecture (MVSA) with a "Core + Features" approach.

## Structure

- **di/**: Dependency injection configuration using get_it and injectable
- **error/**: Error handling with the Either type pattern from dartz
- **network/**: API communication and offline synchronization
- **storage/**: Local database and secure storage
- **utils/**: Shared utilities and extension methods
- **security/**: Authentication and encryption

## Purpose

The core module centralizes shared functionality that is used across multiple features, promoting code reuse and separation of concerns while still allowing for the isolation of feature-specific code in vertical slices.

## Usage Guidelines

- Place code here only if it's truly shared across multiple features
- Keep feature-specific code in its respective feature directory
- Follow Clean Architecture principles for proper layering
- Document all components with clear purpose statements 