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
cd firebase && firebase emulators:start
```

## Architecture

MVVM with protocol-based repositories. Strict layer boundaries:

```
View → ViewModel → Repository (protocol) → Firebase SDK
```

- Views never import Firebase
- ViewModels never access Firestore directly — always via Repository
- Business logic that affects multiple users → Cloud Function, not client
- Models are plain `Codable` structs with no Firebase dependencies

See `docs/infra/architecture.md` for full layer diagram and data flow.

## Project Structure

```
SpotMe/
├── App/              — @main entry, AppState, DependencyContainer
├── Features/
│   ├── Auth/         — Sign-in/sign-up views + AuthViewModel
│   ├── Programs/     — Program CRUD views + ProgramViewModel
│   ├── Relationships/— Invite code + trainee list views
│   ├── Sessions/     — Active session + history views
│   └── Monitoring/   — Real-time trainer view of trainee session
├── Core/
│   ├── Models/       — Codable structs (User, Program, Session, etc.)
│   ├── Repositories/ — Firebase data access; protocol + implementation per entity
│   ├── Services/     — AuthService, RealtimeService
│   └── Extensions/   — Firestore+Codable, View+Extensions
├── DesignSystem/     — Tokens (Colors, Typography, Spacing), Components, Modifiers
└── Resources/        — Assets.xcassets, Localizable.strings
```

## Conventions

- `async/await` over Combine everywhere
- `@Observable` (iOS 17+) for all ViewModels — no `ObservableObject`/`@Published`
- `Codable` for all Firestore document serialization
- One file per type — `SessionView.swift`, `SessionViewModel.swift`, `SessionRepository.swift`
- Typed errors thrown from Repository, caught at ViewModel, displayed in View as alert/banner
- Error types: `AuthError`, `NetworkError`, `DataError`, `PermissionError`
- No third-party DI — manual injection via SwiftUI environment
- Naming: PascalCase types, camelCase properties/methods

## Key Constraints

- Trainee UX must be extremely simple — minimal taps, large targets, clear feedback
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
