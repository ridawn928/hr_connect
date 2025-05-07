# Implementation Guide: Setting up build.yaml and Running build_runner

## Task ID: 01-003-04 - Set up build.yaml and run build_runner to generate DI code

### 1. Introduction

This guide provides comprehensive instructions for configuring the `build.yaml` file and running `build_runner` to generate dependency injection code for the HR Connect application. This task builds on the previous dependency injection setup (tasks 01-003-01 through 01-003-03) and focuses on enabling code generation for the `injectable` package.

#### 1.1 Purpose

The `build.yaml` file is a configuration file used by the `build_runner` package to customize code generation behavior. For the HR Connect application, it allows us to:

- Configure how `injectable_generator` identifies and processes classes for dependency injection
- Set up auto-registration rules based on naming conventions
- Specify which directories and files should be included in code generation
- Control additional generation options to align with our MVSA architecture

Properly configuring build.yaml ensures that our dependency injection system works efficiently and consistently across the entire application.

#### 1.2 Relationship to Previous Tasks

This task is a direct continuation of task 01-003-03 (Integrate injectable and set up the initial injection configuration file with @InjectableInit). While the previous task established the basic injectable structure, this task focuses on the configuration needed to actually generate the dependency registration code.

### 2. Prerequisites

Before starting this task, ensure:

- Task 01-003-03 (Integrate injectable and set up the initial injection configuration file) is completed
- The `build_runner` package (^2.4.8) is added to dev_dependencies in pubspec.yaml
- The `injectable_generator` package (^2.1.6) is added to dev_dependencies in pubspec.yaml
- You have a basic understanding of code generation in Dart/Flutter

### 3. Understanding build.yaml Configuration

#### 3.1 What is build.yaml?

The `build.yaml` file is a configuration file for the `build_runner` package that controls how code generation works in Dart projects. It allows customizing the behavior of different code generators, including `injectable_generator`, which we're using for dependency injection.

#### 3.2 Structure of build.yaml

The basic structure of a `build.yaml` file includes:

- **targets**: Define build targets (typically `$default` for the entire package)
- **builders**: Configure specific code generators
- **options**: Custom options for each builder

For `injectable_generator`, the configuration typically looks like:

```yaml
targets:
  $default:
    builders:
      injectable_generator:injectable_builder:
        options:
          # Options specific to injectable_generator
```

#### 3.3 Available Options for injectable_generator

The `injectable_generator` supports several configuration options:

- **auto_register**: Enable/disable automatic registration of classes
- **class_name_pattern**: Regex pattern for class names to auto-register
- **file_name_pattern**: Regex pattern for file names to auto-register
- **generate_for_dirs**: Directories to include in code generation
- **include_paths**: Specific file patterns to include
- **ignore_paths**: Specific file patterns to ignore

### 4. Step-by-step Implementation

#### 4.1 Create/Update build.yaml File

Create a `build.yaml` file in the root of your project with the following content:

```yaml
# File: build.yaml

targets:
  $default:
    builders:
      # Configuration for injectable_generator
      injectable_generator:injectable_builder:
        options:
          # Enable auto-register for classes matching certain patterns
          auto_register: true
          # Register classes with these name suffixes (using regex)
          class_name_pattern: 
            "Service$|Repository$|Datasource$|UseCase$|Controller$|Bloc$|Cubit$"
          # Register classes in files with these name patterns (using regex)
          file_name_pattern: 
            "_service|_repository|_datasource|_use_case|_controller|_bloc|_cubit"
          # Directories to include (relative to lib/)
          generate_for_dirs:
            - "lib/core"
            - "lib/features"
          # More specific include paths with glob patterns
          include_paths:
            - "lib/core/**.dart"
            - "lib/features/**.dart"
          # Paths to ignore even if they match include patterns
          ignore_paths:
            - "**.g.dart"
            - "**.freezed.dart"
            - "**.config.dart"
            - "**/test/**"
```

#### 4.2 Understanding the Configuration Options

Let's break down the configuration:

- **auto_register: true**: Enables automatic registration of classes based on patterns
- **class_name_pattern**: Any class ending with "Service", "Repository", "Datasource", "UseCase", "Controller", "Bloc", or "Cubit" will be auto-registered
- **file_name_pattern**: Files containing "_service", "_repository", etc. in their names will be included
- **generate_for_dirs**: Code generation will run on files in lib/core and lib/features
- **include_paths**: More specific glob patterns for files to include
- **ignore_paths**: Excludes generated files and test files from code generation

This configuration aligns with the HR Connect MVSA architecture by focusing on core services, repositories, and feature-specific components.

#### 4.3 Customizing for Your Project Structure

If you need to adapt the configuration for specific project needs, here are some examples:

**Example 1: Adding Environment-Specific Configuration**

```yaml
injectable_generator:injectable_builder:
  options:
    # Other options remain the same
    # Add environment filtering
    include_environments:
      - dev
      - test
      - prod
```

**Example 2: Disabling Auto-Registration for Specific Components**

```yaml
injectable_generator:injectable_builder:
  options:
    # Disable auto-registration
    auto_register: false
    # Other options remain the same
```

#### 4.4 Configuration for Other Generators

If your project uses other code generators (like json_serializable, freezed, etc.), you can configure them in the same build.yaml file:

```yaml
targets:
  $default:
    builders:
      # Injectable configuration (as above)
      injectable_generator:injectable_builder:
        options: 
          # ... injectable options ...
      
      # Example json_serializable configuration
      json_serializable:json_serializable:
        options:
          create_to_json: true
          create_factory: true
          explicit_to_json: true
          field_rename: snake
```

### 5. Running Code Generation

Once you've set up the build.yaml file, you can run code generation using the build_runner package.

#### 5.1 Basic Build Command

For a one-time code generation:

```bash
flutter pub run build_runner build
```

This command will scan your project for classes annotated with injectable annotations and generate the appropriate registration code.

#### 5.2 Handling Conflicts

If you encounter conflicts with existing generated files, use:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This command will overwrite any conflicting generated files.

#### 5.3 Continuous Generation During Development

During active development, you can use the watch command to automatically regenerate code whenever files change:

```bash
flutter pub run build_runner watch
```

This is particularly useful when you're adding or modifying injectable services.

#### 5.4 Cleaning Generated Files

To clean all generated files and start fresh:

```bash
flutter pub run build_runner clean
```

You might need to run this if you encounter persistent issues with code generation.

### 6. Understanding Generated Code

#### 6.1 Location and Structure of Generated Files

After running build_runner, you should find a generated file:

- `lib/core/di/injection_config.config.dart` - Generated from injection_config.dart

The generated file will contain automatic registration code for all services annotated with @injectable, @lazySingleton, etc.

Example of generated code structure:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// imports for all your registered classes...

extension GetItInjectableX on _i1.GetIt {
  // This is the function called by the setup method
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    
    // Registration for all your services
    gh.lazySingleton<_i3.LoggerService>(() => _i3.DevLoggerService());
    // ... many more registrations
    
    return this;
  }
}
```

#### 6.2 Reviewing Generated Code

When reviewing the generated code, check for:

1. All expected services are registered
2. The registration type is correct (singleton, lazySingleton, factory)
3. Environment-specific services are registered with the correct environment filter
4. Dependencies are properly injected

#### 6.3 Common Issues and Solutions

**Issue 1: Missing Service Registrations**
- Verify the class is annotated with @injectable, @singleton, etc.
- Check that the file and class name match your build.yaml patterns
- Ensure the file is in a directory included in generate_for_dirs or include_paths

**Issue 2: Circular Dependencies**
- The generated code may show errors for circular dependencies
- Resolve by restructuring your dependencies or using @factoryMethod

**Issue 3: Errors in Generated Code**
- If you see errors in the generated code, check that all dependencies are properly imported
- Make sure all parameters in constructors can be resolved by the DI system

### 7. Integration with Existing Code

#### 7.1 Verify Service Locator Setup

Update the `service_locator.dart` file to ensure it uses the generated code:

```dart
// File: lib/core/di/service_locator.dart (update if needed)

import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/di/injection_config.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator({
  required EnvironmentConfig config,
}) async {
  // Register the environment configuration
  getIt.registerSingleton<EnvironmentConfig>(config);
  
  // Get the injectable environment string
  final String injectableEnv = _environmentToString(config.environment);
  
  // This calls the generated init method from injection_config.config.dart
  await getIt.init(
    environment: injectableEnv,
    environmentFilter: EnvironmentFilter.ofEnvironment(injectableEnv),
  );
  
  // Any additional manual registrations
}
```

#### 7.2 Test Service Registration

Create a simple test to verify the DI system works with the generated code:

```dart
// File: test/core/di/service_locator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/di/environment_config.dart';
import 'package:hr_connect/core/di/service_locator.dart';
// Import your service classes
import 'package:hr_connect/core/services/logger_service.dart';

void main() {
  setUp(() async {
    // Reset GetIt before each test
    await GetIt.instance.reset();
  });

  test('setupServiceLocator should register all services properly', () async {
    // Arrange
    final config = EnvironmentConfig.development();
    
    // Act
    await setupServiceLocator(config: config);
    
    // Assert - check a few services to verify registration
    expect(getIt.isRegistered<LoggerService>(), true);
    // Add assertions for other expected services
  });
}
```

### 8. Best Practices

#### 8.1 Managing build.yaml as the Project Grows

As your project grows, follow these best practices:

1. **Update build.yaml for New Patterns**: Add new naming patterns as you introduce new types of services or components.

2. **Review Generation Performance**: If code generation becomes slow, consider more specific include_paths to limit the files scanned.

3. **Separate Configuration for Different Environments**: Use the include_environments option to control which services are registered in different environments.

4. **Version Control**: Keep build.yaml in version control to ensure consistent code generation across the team.

#### 8.2 Continuous Integration Setup

For CI/CD pipelines, add a step to verify code generation:

```yaml
# Example CI step
- name: "Generate DI code"
  run: flutter pub run build_runner build --delete-conflicting-outputs

# Optionally verify no changes (all generated code is committed)
- name: "Verify no changes in generated files"
  run: git diff --exit-code
```

#### 8.3 Code Organization for Generated Files

Follow these guidelines for generated files:

1. **Never Edit Generated Files**: All changes should be made to the source files and configurations.

2. **Include Generated Files in Version Control**: This ensures consistent builds and makes it easier to track changes.

3. **Use .gitignore Selectively**: Don't ignore all .g.dart files; instead, be specific about what should be ignored.

### 9. Advanced Topics

#### 9.1 Custom Builders Configuration

For advanced users, you can configure how the builder runs:

```yaml
# File: build.yaml (advanced section)

global_options:
  injectable_generator:injectable_builder:
    # Run before other builders
    runs_before: ["json_serializable"]
    # Only run in specific build phases
    build_to: source
    # Apply builder to a subset of targets
    applies_builders: ["source_gen"]
```

#### 9.2 Environment-Specific Code Generation

To generate code for specific environments only:

```yaml
# File: build.yaml (environment section)

injectable_generator:injectable_builder:
  options:
    # Include only certain environments
    include_environments:
      - dev
      - test
    # Exclude certain environments
    exclude_environments:
      - prod
```

#### 9.3 Modular Code Generation

For large projects, you can split code generation into modules:

```yaml
# File: build.yaml (modular section)

targets:
  $default:
    builders:
      injectable_generator:injectable_builder:
        options:
          # General options
      
  # Separate target for a specific feature
  features:core:
    builders:
      injectable_generator:injectable_builder:
        options:
          # Core-specific options
```

### 10. Next Steps

After completing this task, you'll be ready to move on to the next task:
- **Task 01-003-05**: Create and test a simple service to verify the DI system works.

This next task will involve creating a practical example of a service that uses the dependency injection system you've configured.

### 11. Conclusion

You have now set up the build.yaml configuration file and generated the dependency injection code using build_runner. This configuration supports the HR Connect application's MVSA architecture and provides:

- Automated registration of services based on naming conventions
- Controlled code generation for specific directories and files
- Foundation for environment-specific dependency injection
- Integration with the service locator system

This implementation lays the groundwork for efficient dependency management across all features of the application, supporting both core services and feature-specific components.

Remember to follow the HR Connect Flutter Development Guidelines when creating new services, particularly regarding proper typing, documentation, naming conventions, and the use of appropriate annotations for dependency injection.
