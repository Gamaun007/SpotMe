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

## Project Folder Structure

```
SpotMe/
├── SpotMe/
│   ├── App/
│   │   ├── SpotMeApp.swift             — @main entry point
│   │   ├── AppState.swift              — Global app state (auth status, role)
│   │   └── DependencyContainer.swift   — Service/repository initialization
│   │
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── Views/
│   │   │   │   ├── SignInView.swift
│   │   │   │   └── SignUpView.swift
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
│   │   │   └── Relationship.swift
│   │   │
│   │   ├── Repositories/
│   │   │   ├── Protocols/
│   │   │   │   ├── ProgramRepositoryProtocol.swift
│   │   │   │   ├── SessionRepositoryProtocol.swift
│   │   │   │   └── RelationshipRepositoryProtocol.swift
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
│   │   │   └── Spacing.swift
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
├── docs/                               — Documentation (this folder)
├── firebase/
│   ├── functions/                      — Cloud Functions source
│   │   ├── src/
│   │   │   └── index.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── firestore.rules                 — Security rules
│   └── firebase.json                   — Firebase project config
└── .github/
    └── copilot-instructions.md         — Agent context
```

---

## Dependency Injection

Simple approach using SwiftUI's environment system:

```swift
// DependencyContainer creates all services/repositories once
// App injects them into the environment at root level
// ViewModels receive dependencies via init parameters
```

No third-party DI framework. For MVP, manual injection is sufficient.

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

Error types:
- `AuthError` — sign-in failures, token expiry
- `NetworkError` — offline (handled gracefully)
- `DataError` — missing/corrupt documents
- `PermissionError` — security rule violations
