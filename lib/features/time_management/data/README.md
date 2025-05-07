# Data Layer

This directory contains the data layer for the time management feature. The data layer implements data access and persistence logic for the domain layer.

## Structure

- **models/**: Data transfer objects (DTOs)
  - Extend domain entities with serialization logic
  - Handle JSON conversion and database mapping

- **repositories/**: Implementations of domain repository interfaces
  - Implement interfaces defined in the domain layer
  - Coordinate between data sources

- **datasources/**: Local and remote data sources
  - Local: Handles database operations (Drift)
  - Remote: Handles API communication (Dio)

- **mappers/**: Convert between models and entities
  - Isolate conversion logic

## Dependencies

The data layer:
- Can depend ONLY on the domain layer and the core module
- Cannot depend on the presentation layer
- Can use external packages for data access and persistence

## Usage Guidelines

- Keep repository implementations focused on the interface contract
- Separate network and database concerns into respective data sources
- Handle caching and offline persistence appropriately
- Implement the repository pattern for proper separation of concerns 