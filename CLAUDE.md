# SpotMe

iOS workout tracking app built around the **trainer–trainee relationship**. A trainer creates programs, assigns them to trainees, monitors active sessions in real time, and can edit sessions remotely on the trainee's behalf.

Primary use case: tech-savvy trainer coaching a non-tech-savvy family member who finds existing fitness apps too complex.

## Build & Run

```bash
# Open in Xcode
open SpotMe/SpotMe.xcodeproj

# Build from CLI
xcodebuild build -scheme SpotMe -destination 'platform=iOS Simulator,name=iPhone 16'

# Run tests
xcodebuild test -scheme SpotMe -destination 'platform=iOS Simulator,name=iPhone 16'

# Start Firebase emulators (local dev)
cd firebase && firebase emulators:start --project demo-spotme
```

## Architecture

MVVM with protocol-based repositories. Strict layer boundaries:

```
View → ViewModel → Repository (protocol) → Firebase SDK
```

- Views never import Firebase
- ViewModels never access Firestore directly — always via Repository
- ViewModels receive dependencies via init parameters (injected from `DependencyContainer` via SwiftUI environment)
- Business logic that affects multiple users → Cloud Function, not client
- Models are plain `Codable` structs with no Firebase dependencies

See `docs/infra/architecture.md` for full layer diagram and data flow.

## Project Structure

```
SpotMe/
├── App/
│   ├── SpotMeApp.swift         — @main entry, Firebase setup, emulator config
│   ├── AppState.swift          — Global auth + role state (@Observable)
│   ├── DependencyContainer.swift — All services/repositories, injected via SwiftUI env
│   ├── RootView.swift          — Root navigation (auth → role selection → home)
│   ├── TrainerHomeView.swift   — Trainer tab container
│   └── TraineeHomeView.swift   — Trainee tab container
├── Features/
│   ├── Auth/
│   │   ├── Views/              — SignInView, SignUpView, RoleSelectionView
│   │   └── ViewModels/         — AuthViewModel
│   ├── Programs/
│   │   ├── Views/              — ProgramListView, ProgramDetailView, ProgramEditorView
│   │   └── ViewModels/         — ProgramViewModel
│   ├── Relationships/
│   │   ├── Views/              — InviteCodeView, TraineeListView
│   │   └── ViewModels/         — RelationshipViewModel
│   ├── Sessions/
│   │   ├── Views/              — ActiveSessionView, SessionHistoryView
│   │   └── ViewModels/         — SessionViewModel
│   └── Monitoring/
│       ├── Views/              — LiveSessionView
│       └── ViewModels/         — MonitoringViewModel
├── Core/
│   ├── Models/                 — User, Program, Exercise, Session, SetRecord, Relationship, InviteCode, AppError
│   ├── Repositories/
│   │   ├── Protocols/          — UserRepositoryProtocol, ProgramRepositoryProtocol, SessionRepositoryProtocol, RelationshipRepositoryProtocol
│   │   └── (implementations)  — UserRepository, ProgramRepository, SessionRepository, RelationshipRepository
│   ├── Services/               — AuthService, RealtimeService
│   └── Extensions/             — Firestore+Codable, View+Extensions
├── DesignSystem/
│   ├── Tokens/                 — Colors, Typography, Spacing, CornerRadius
│   ├── Components/             — PrimaryButton, InputField, Card
│   └── Modifiers/              — CardStyle
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

## Firebase Setup

**Local development** uses Firebase Emulator Suite with a demo project — no real Firebase project required.

```
Auth emulator:      localhost:9099
Firestore emulator: localhost:8080
Functions emulator: localhost:5001
Emulator UI:        localhost:4000
```

The app auto-connects to emulators in `DEBUG` builds via programmatic `FirebaseOptions` with `projectID = "demo-spotme"`. Release builds require a real `GoogleService-Info.plist` (not committed — see `.gitignore`).

Firebase config lives in `firebase/`:
```
firebase/
├── firebase.json           — Emulator port config
├── firestore.rules         — Security rules
├── firestore.indexes.json  — Composite indexes
└── functions/
    └── src/index.ts        — Cloud Functions (generateInviteCode, acceptInviteCode)
```

## Conventions

- `async/await` over Combine everywhere
- `@Observable` (iOS 17+) for all ViewModels — no `ObservableObject`/`@Published`
- `Codable` for all Firestore document serialization
- One file per type — `SessionView.swift`, `SessionViewModel.swift`, `SessionRepository.swift`
- Typed errors thrown from Repository, caught at ViewModel, displayed in View as alert/banner
- Error types: `AuthError`, `NetworkError`, `DataError`, `PermissionError` (all in `Core/Models/AppError.swift`)
- DI: `DependencyContainer` is `@Observable`, injected at root via `.environment(container)`, accessed in Views via `@Environment(DependencyContainer.self)`
- ViewModels take services/repositories as init parameters — no singleton access
- Naming: PascalCase types, camelCase properties/methods

## Key Constraints

- Trainee UX must be extremely simple — minimal taps, large targets (min 44pt, prefer 56pt+ for primary actions), clear feedback
- Real-time session sync must be <2s latency (Firestore snapshot listeners)
- App must work offline — Firestore persistence enabled, UI never blocks on network
- Firebase Spark (free) plan — design for efficiency, avoid unnecessary reads/writes
- Solo developer — favor simplicity over abstraction; no premature generalization

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Platform | iOS 17.0+ |
| Language | Swift 5.9+ |
| UI | SwiftUI |
| Backend | Firebase (Firestore, Auth, Cloud Functions) |
| Package Manager | Swift Package Manager |
| Auth | Firebase Auth — Apple Sign-In + Email/Password |
| Real-time | Firestore snapshot listeners |
| Offline | Firestore offline persistence (built-in) |

## Documentation

- Feature specs & user stories: `docs/specs/`
- Data model (Firestore schema): `docs/specs/data-model.md`
- Architecture details: `docs/infra/architecture.md`
- Tech stack rationale: `docs/infra/tech-stack.md`
- Dev environment setup: `docs/infra/dev-environment.md`
- Design system: `docs/design/design-system.md`
- Architecture decisions: `docs/decisions/`
