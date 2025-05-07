# Architecture Overview Diagrams

This file contains diagrams illustrating the high-level architecture of HR Connect.

## Modified Vertical Slice Architecture (MVSA)

```mermaid
graph TD
    A[HR Connect Architecture] --> B[Core]
    A --> C[Features]
    
    B --> B1[DI]
    B --> B2[Network]
    B --> B3[Storage]
    B --> B4[Utils]
    B --> B5[Security]
    B --> B6[Routing]
    B --> B7[Error]
    
    C --> C1[Authentication]
    C --> C2[Attendance]
    C --> C3[Time Management]
    C --> C4[Employee]
    C --> C5[Admin]
    
    subgraph "Vertical Slice (Example)"
        C1 --> D1[Domain Layer]
        C1 --> D2[Data Layer]
        C1 --> D3[Presentation Layer]
        
        D1 --> D1_1[Entities]
        D1 --> D1_2[Repositories]
        D1 --> D1_3[Use Cases]
        
        D2 --> D2_1[Models]
        D2 --> D2_2[Repository Impl]
        D2 --> D2_3[Data Sources]
        
        D3 --> D3_1[Screens]
        D3 --> D3_2[Widgets]
        D3 --> D3_3[Providers]
    end
```

## Aggregate Pattern

```mermaid
graph TD
    A[Employee] --> B[AuthenticationProfile]
    A --> C[DeviceProfile]
    A --> D[AttendanceProfile]
    A --> E[RequestProfile]
    A --> F[EmploymentProfile]
    A --> G[PerformanceProfile]
    A --> H[NotificationProfile]
    A --> I[SyncProfile]
```

## Repository Pattern

```mermaid
graph TD
    Domain[Domain Layer] --> Interface[Repository Interface]
    
    Implementation[Repository Implementation] --> Interface
    Implementation --> LocalDataSource[Local Data Source]
    Implementation --> RemoteDataSource[Remote Data Source]
    Implementation --> NetworkInfo[Network Info]
    Implementation --> SyncService[Sync Queue Service]
    
    LocalDataSource --> LocalDB[Local Database]
    RemoteDataSource --> API[Remote API]
    
    subgraph "Data Layer"
        Implementation
        LocalDataSource
        RemoteDataSource
        NetworkInfo
        SyncService
        LocalDB
        API
    end
    
    subgraph "Domain Layer"
        Domain
        Interface
    end
```

## Offline-First Data Flow

```mermaid
sequenceDiagram
    participant UI as UI Layer
    participant UC as Use Case
    participant REPO as Repository
    participant LDS as Local Data Source
    participant RDS as Remote Data Source
    participant SYNC as Sync Queue
    
    UI->>UC: Request Data
    UC->>REPO: Get Data
    REPO->>LDS: Get Local Data
    
    alt Local Data Exists
        LDS-->>REPO: Return Local Data
        REPO->>UC: Return Data
        UC->>UI: Display Data
        
        REPO->>+SYNC: Check Network Status
        
        alt Is Online
            SYNC-->>-REPO: Online
            REPO->>RDS: Get Fresh Data
            RDS-->>REPO: Return Remote Data
            REPO->>LDS: Update Local Cache
            REPO->>UC: Return Fresh Data
            UC->>UI: Update UI
        end
    else No Local Data
        LDS-->>REPO: Cache Miss
        
        REPO->>+SYNC: Check Network Status
        
        alt Is Online
            SYNC-->>-REPO: Online
            REPO->>RDS: Get Remote Data
            RDS-->>REPO: Return Remote Data
            REPO->>LDS: Cache Data
            REPO->>UC: Return Data
            UC->>UI: Display Data
        else Is Offline
            SYNC-->>-REPO: Offline
            REPO->>UC: Return Error
            UC->>UI: Show Error
        end
    end
```

## State Management

```mermaid
graph TD
    A[UI Layer] --> |Watches| B[Providers]
    B --> |Depends on| C[Repositories]
    C --> |Uses| D[Data Sources]
    
    subgraph "State Management Flow"
        B1[State Providers] --> |Manages UI State| A1[UI Components]
        B2[Repository Providers] --> |Provides Repository Access| B1
        B3[Service Providers] --> |Provides Business Logic| B1
        B4[Computed Providers] --> |Derives State| B1
    end
    
    subgraph "State Update Flow"
        A2[User Action] --> |Triggers| E[Provider State Update]
        E --> |Updates| F[State]
        F --> |Notifies| G[Watchers]
        G --> |Rebuilds| H[UI]
    end
```

## Dependency Injection

```mermaid
graph TD
    A[GetIt Service Locator] --> B[Core Module]
    A --> C[Feature Modules]
    
    B --> B1[Network Module]
    B --> B2[Storage Module]
    B --> B3[Auth Module]
    
    C --> C1[Auth Feature Module]
    C --> C2[Attendance Feature Module]
    C --> C3[Time Management Feature Module]
    
    subgraph "Registration Types"
        D1[Singleton]
        D2[LazySingleton]
        D3[Factory]
        D4[EnvironmentFactory]
    end
    
    subgraph "Initialization Flow"
        E1[main.dart] --> |Initializes| E2[Service Locator]
        E2 --> |Registers| E3[Core Dependencies]
        E2 --> |Registers| E4[Feature Dependencies]
        E3 --> |Available via| E5[GetIt.get()]
        E4 --> |Available via| E5
    end
``` 