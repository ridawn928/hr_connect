# Utilities

This directory contains shared helper functions, extensions, and utilities for the HR Connect application.

## Purpose

- Provides reusable utility functions and extensions
- Centralizes common functionality used across features
- Reduces code duplication
- Implements consistent formatting and validation

## Key Components

- `string_extensions.dart`: String manipulation utilities
- `date_utils.dart`: Date and time helpers for attendance tracking
- `validators.dart`: Input validation functions for employee forms
- `formatting.dart`: Text and number formatting utilities
- `common_widgets/`: Shared UI components used across features

## Usage

Import the required utility files in your code:

```dart
import 'package:hr_connect/core/utils/date_utils.dart';
import 'package:hr_connect/core/utils/string_extensions.dart';

// Using date utilities
final formattedDate = formatAttendanceDate(DateTime.now());

// Using string extensions
final sanitizedInput = userInput.sanitize();
```

## Notes

- Keep utilities focused and single-purpose
- Document each utility function with clear purpose and parameters
- Use extension methods where appropriate for cleaner code
- Properly test utility functions with unit tests
- Consider performance implications for frequently used utilities 