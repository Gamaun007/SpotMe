# SpotMe — Tech Stack

## Summary

| Layer | Technology | Version |
|-------|-----------|---------|
| Platform | iOS (iPhone) | 17.0+ |
| Language | Swift | 5.9+ |
| UI Framework | SwiftUI | iOS 17+ APIs |
| Architecture | MVVM | — |
| Backend | Firebase | 11.x |
| Database | Cloud Firestore | — |
| Auth | Firebase Authentication | — |
| Serverless | Firebase Cloud Functions | Node.js 18 |
| Package Manager | Swift Package Manager | Built-in |
| IDE | Xcode | 15.0+ |
| VCS | Git + GitHub | — |

---

## Frontend — SwiftUI (Native iOS)

### Why SwiftUI over cross-platform (React Native / Flutter)?

1. **iOS-only target** — no cross-platform benefit to capture today
2. **watchOS + iPad future** — only possible with native Swift; RN/Flutter cannot target watchOS
3. **Offline + Real-time** — Firestore Swift SDK handles both natively, no wrapper overhead
4. **Apple Sign-In** — trivial in native (ASAuthorizationController), complex in cross-platform
5. **Accessibility** — SwiftUI's built-in VoiceOver support is superior for the non-tech-savvy trainee
6. **AI-assisted learning** — SwiftUI learning curve is manageable with Copilot/Claude assistance
7. **Performance** — no bridge layer (RN) or rendering engine (Flutter) between code and Metal

### Key SwiftUI Features We'll Use

- `@Observable` macro (iOS 17+) — simpler than ObservableObject/Published
- `NavigationStack` — type-safe navigation
- Swift Concurrency (`async/await`, `Task`, `AsyncStream`) — for Firebase operations
- `Codable` — Firestore document serialization
- Environment injection — dependency injection via SwiftUI environment

---

## Backend — Firebase (Google)

### Plan: Spark (Free) → Blaze (Pay-as-you-go)

Start on **Spark (free)** plan. Upgrade to Blaze only if limits are hit.

### Spark Plan Limits (relevant)

| Service | Free Limit | Our MVP Usage |
|---------|-----------|---------------|
| Firestore reads | 50,000/day | ~500/day (2 users) |
| Firestore writes | 20,000/day | ~200/day (2 users) |
| Firestore storage | 1 GiB | <10 MB |
| Auth users | Unlimited | 2 |
| Cloud Functions invocations | 2M/month | ~1,000/month |
| Cloud Functions compute | 400K GB-sec/month | Minimal |

**Verdict:** Free tier is more than sufficient for MVP and early growth (up to ~50 active users).

### Firebase Services Used

| Service | Purpose |
|---------|---------|
| **Authentication** | Apple Sign-In + Email/Password. Token management. |
| **Cloud Firestore** | Primary database. Real-time listeners. Offline persistence. |
| **Cloud Functions** | Invite code generation, relationship validation, session state management. |
| **Firebase Analytics** | Usage tracking (free, low effort to include). |

### Why Firebase over alternatives?

| Alternative | Why Not |
|-------------|---------|
| Supabase | PostgreSQL-based — real-time is less mature, offline support requires manual caching |
| Custom backend (Node/Nest.js) | Server management overhead, manual offline/sync, more code to maintain solo |
| AWS Amplify | More complex setup, overkill for this scale |
| CloudKit | Apple-only (blocks future web/Android), less flexible querying |

---

## Multi-Platform Strategy

Firebase is the **shared backend** for all future platforms:

```
                    ┌─── iOS (SwiftUI)           ← NOW
                    │
Firebase Backend ───┼─── Web (Angular)           ← 1+ year
(Firestore/Auth/    │
Cloud Functions)    ├─── Android (Kotlin)        ← if traction
                    │
                    └─── watchOS (SwiftUI)       ← far future
```

**Rule:** All business logic lives in Cloud Functions. Clients are thin UI layers. This ensures:
- No logic drift between platforms
- Adding a new client = build UI + call existing Functions
- Security rules enforced server-side regardless of client

---

## Dependencies (Swift Packages)

| Package | Purpose | Source |
|---------|---------|--------|
| firebase-ios-sdk | Firestore, Auth, Functions, Analytics | google/firebase-ios-sdk |

**Philosophy:** Minimize dependencies. Firebase SDK is the only external package for MVP. Add packages only when native solutions are insufficient.

---

## Development Tools

| Tool | Purpose |
|------|---------|
| Xcode 15+ | IDE, simulator, build |
| Firebase CLI | Deploy Cloud Functions, manage project |
| Firebase Emulator Suite | Local development without touching production |
| GitHub Actions | CI (build + test on push) — later |
| Fastlane | Automated TestFlight deploys — later |
