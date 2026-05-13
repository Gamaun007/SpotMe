# SpotMe — Copilot Agent Context

## Project Overview

SpotMe is an iOS workout tracking app built around the **trainer–trainee relationship**. A trainer creates workout programs, assigns them to trainees, monitors active sessions in real time, and can edit sessions on behalf of the trainee.

Primary use case: A tech-savvy trainer coaching a non-tech-savvy family member who struggles with existing fitness apps.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Platform | iOS (iPhone) |
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Backend | Firebase (Firestore, Auth, Cloud Functions) |
| Package Manager | Swift Package Manager (SPM) |
| Auth | Firebase Auth (Apple Sign-In + Email/Password) |
| Real-time | Firestore snapshot listeners |
| Offline | Firestore offline persistence (built-in) |
| Minimum iOS | 17.0 |

## Architecture Principles

- **Thin client** — Business logic lives in Firebase Cloud Functions. Clients are UI + presentation logic only.
- **MVVM** — Views → ViewModels → Repositories → Firebase
- **Protocol-oriented** — Repositories behind protocols for testability
- **Client-agnostic data model** — Firestore schema has no iOS-specific assumptions (future: web, Android)
- **Offline-first** — Firestore persistence enabled; UI never blocks on network

## Project Structure

```
SpotMe/
├── App/                    — App entry point, dependency injection
├── Features/
│   ├── Auth/               — Authentication views + view models
│   ├── Programs/           — Workout program CRUD
│   ├── Relationships/      — Trainer-trainee linking
│   ├── Sessions/           — Active workout session
│   └── Monitoring/         — Real-time session monitoring (trainer)
├── Core/
│   ├── Models/             — Data models (Codable structs)
│   ├── Repositories/       — Firebase data access layer
│   ├── Services/           — Auth service, real-time service
│   └── Extensions/         — Swift/SwiftUI extensions
├── DesignSystem/           — Shared UI components, tokens, styles
└── Resources/              — Assets, localization
```

## Conventions

- Use `async/await` over Combine where possible
- Use `@Observable` (iOS 17+) for view models
- Firestore documents use `Codable` for serialization
- Error handling: throw typed errors, catch at ViewModel level, display in UI
- Naming: PascalCase types, camelCase properties/methods, descriptive names
- One file per type (View, ViewModel, Repository)

## Documentation

- Feature specs: `docs/specs/user-stories/`
- Data model: `docs/specs/data-model.md`
- Architecture details: `docs/infra/architecture.md`
- Design system: `docs/design/design-system.md`
- Architecture decisions: `docs/decisions/`

## Key Constraints

- Trainee UX must be extremely simple — minimal taps, large targets, clear feedback
- Real-time session sync must be <2s latency
- App must work offline (Firestore handles sync)
- Firebase free tier (Spark plan) — design for efficiency
- Solo developer — favor simplicity over abstraction
