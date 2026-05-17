# SpotMe — Architecture

## System Overview

```
┌──────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                   │
├──────────────────────────────────────────────────────┤
│  Views (SwiftUI)                                      │
│    ↕                                                  │
│  ViewModels (@Observable)                             │
│    ↕                                                  │
│  Repositories (protocol-based)                        │
│    ↕                                                  │
│  Firebase SDK (Firestore, Auth)                       │
└──────────────────────────────────────────────────────┘
                         ↕
┌──────────────────────────────────────────────────────┐
│                  Firebase Backend                      │
├──────────────────────────────────────────────────────┤
│  Cloud Firestore     — data storage, real-time sync   │
│  Authentication      — user identity                  │
│  Cloud Functions     — business logic, validation     │
│  Security Rules      — access control                 │
└──────────────────────────────────────────────────────┘
```

---

## App Layer Architecture (MVVM)

### Layer Responsibilities

| Layer | Responsibility | Example |
|-------|---------------|---------|
| **View** | UI rendering, user input, animations | `SessionView.swift` |
| **ViewModel** | Presentation logic, state management, error handling | `SessionViewModel.swift` |
| **Repository** | Data access, Firebase SDK calls, caching | `SessionRepository.swift` |
| **Model** | Data structures, Codable conformance | `Session.swift` |
| **Service** | Cross-cutting concerns (auth state, real-time listeners) | `AuthService.swift` |

### Data Flow

```
User Action → View → ViewModel → Repository → Firestore
                                                   ↓
UI Update  ← View ← ViewModel ← Repository ← Listener/Response
```

### Rules

1. Views never import Firebase
2. ViewModels never access Firestore directly — always through Repository
3. Repositories are protocol-based (enables testing with mocks)
4. Models are plain structs — no Firebase dependencies
5. Business logic that affects multiple users → Cloud Function (not client)

---

## Dependency Injection

`DependencyContainer` is `@Observable` and created once in `SpotMeApp`. It is injected into the SwiftUI environment at root level. Views access it via `@Environment(DependencyContainer.self)` and pass services/repositories to ViewModels through their `init` parameters.

```swift
// SpotMeApp — create and inject
@State private var container = DependencyContainer()
WindowGroup {
    RootView()
        .environment(appState)
        .environment(container)
}

// View — access and inject into ViewModel
@Environment(DependencyContainer.self) private var container
viewModel = AuthViewModel(authService: container.authService, userRepository: container.userRepository)

// ViewModel — receives deps via init (no singleton, no Firebase import)
init(authService: AuthService, userRepository: any UserRepositoryProtocol)
```

No third-party DI framework. For MVP, this approach is sufficient and fully testable.

---

## Project Folder Structure

```
SpotMe/
├── SpotMe/
│   ├── App/
│   │   ├── SpotMeApp.swift             — @main entry, Firebase init, emulator setup
│   │   ├── AppState.swift              — Global auth + role state (@Observable)
│   │   ├── DependencyContainer.swift   — All services/repos (@Observable, env-injected)
│   │   ├── RootView.swift              — Auth gate → role selection → home routing
│   │   ├── TrainerHomeView.swift       — Trainer tab container
│   │   └── TraineeHomeView.swift       — Trainee tab container
│   │
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── Views/
│   │   │   │   ├── SignInView.swift
│   │   │   │   ├── SignUpView.swift
│   │   │   │   └── RoleSelectionView.swift
│   │   │   └── ViewModels/
│   │   │       └── AuthViewModel.swift
│   │   │
│   │   ├── Programs/
│   │   │   ├── Views/
│   │   │   │   ├── ProgramListView.swift
│   │   │   │   ├── ProgramDetailView.swift
│   │   │   │   └── ProgramEditorView.swift
│   │   │   └── ViewModels/
│   │   │       └── ProgramViewModel.swift
│   │   │
│   │   ├── Relationships/
│   │   │   ├── Views/
│   │   │   │   ├── InviteCodeView.swift
│   │   │   │   └── TraineeListView.swift
│   │   │   └── ViewModels/
│   │   │       └── RelationshipViewModel.swift
│   │   │
│   │   ├── Sessions/
│   │   │   ├── Views/
│   │   │   │   ├── ActiveSessionView.swift
│   │   │   │   └── SessionHistoryView.swift
│   │   │   └── ViewModels/
│   │   │       └── SessionViewModel.swift
│   │   │
│   │   └── Monitoring/
│   │       ├── Views/
│   │       │   └── LiveSessionView.swift
│   │       └── ViewModels/
│   │           └── MonitoringViewModel.swift
│   │
│   ├── Core/
│   │   ├── Models/
│   │   │   ├── User.swift
│   │   │   ├── Program.swift
│   │   │   ├── Exercise.swift
│   │   │   ├── Session.swift
│   │   │   ├── SetRecord.swift
│   │   │   ├── Relationship.swift
│   │   │   ├── InviteCode.swift
│   │   │   └── AppError.swift          — AuthError, NetworkError, DataError, PermissionError
│   │   │
│   │   ├── Repositories/
│   │   │   ├── Protocols/
│   │   │   │   ├── UserRepositoryProtocol.swift
│   │   │   │   ├── ProgramRepositoryProtocol.swift
│   │   │   │   ├── SessionRepositoryProtocol.swift
│   │   │   │   └── RelationshipRepositoryProtocol.swift
│   │   │   ├── UserRepository.swift
│   │   │   ├── ProgramRepository.swift
│   │   │   ├── SessionRepository.swift
│   │   │   └── RelationshipRepository.swift
│   │   │
│   │   ├── Services/
│   │   │   ├── AuthService.swift
│   │   │   └── RealtimeService.swift
│   │   │
│   │   └── Extensions/
│   │       ├── Firestore+Codable.swift
│   │       └── View+Extensions.swift
│   │
│   ├── DesignSystem/
│   │   ├── Tokens/
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   ├── Spacing.swift
│   │   │   └── CornerRadius.swift
│   │   ├── Components/
│   │   │   ├── PrimaryButton.swift
│   │   │   ├── InputField.swift
│   │   │   └── Card.swift
│   │   └── Modifiers/
│   │       └── CardStyle.swift
│   │
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.strings
│
├── SpotMe.xcodeproj
├── firebase/
│   ├── firebase.json               — Emulator ports config
│   ├── firestore.rules             — Firestore security rules
│   ├── firestore.indexes.json      — Composite index definitions
│   └── functions/
│       ├── src/index.ts            — Cloud Functions (generateInviteCode, acceptInviteCode)
│       ├── package.json
│       └── tsconfig.json
├── docs/                           — All project documentation
└── CLAUDE.md                       — Agent context
```

---

## Real-time Architecture

### Active Session Sync

```
Trainee Device                    Firestore                    Trainer Device
     │                               │                              │
     │── writes set completion ──→   │                              │
     │                               │── pushes via listener ────→  │
     │                               │                              │
     │                               │←── trainer writes set ──────│
     │←── pushes via listener ──────│                              │
```

- Both devices attach a **snapshot listener** to the active session document
- Writes from either side propagate to the other in <2 seconds
- Offline writes queue locally, sync when connection returns
- Conflict resolution: last-write-wins (Firestore default) — acceptable for this use case

---

## Offline Strategy

1. Firestore offline persistence enabled at app start (one line of config)
2. All reads first check local cache (Firestore default behavior)
3. Writes go to local cache immediately, sync to server when online
4. UI shows data regardless of network state
5. Optional: subtle indicator when offline (non-blocking)

---

## Security Model

All access control enforced via **Firestore Security Rules** + **Cloud Functions**:

- Users can only read/write their own data
- Trainers can read/write trainee's session data IF a valid relationship exists
- Relationship creation requires valid invite code (validated in Cloud Function)
- Session documents are readable by both trainer and trainee in the relationship

---

## Error Handling Strategy

```
Firebase SDK throws → Repository catches → throws typed AppError →
ViewModel catches → sets error state → View displays alert/banner
```

Error types (all in `Core/Models/AppError.swift`):
- `AuthError` — sign-in failures, token expiry
- `NetworkError` — offline (handled gracefully)
- `DataError` — missing/corrupt documents
- `PermissionError` — security rule violations
