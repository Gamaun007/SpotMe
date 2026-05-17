# SpotMe — Development Environment Setup

## Current Machine State

| Tool | Version | Status |
|------|---------|--------|
| macOS | Sequoia 15+ | ✅ |
| Xcode | 26.5 | ✅ |
| Swift | 5.9.2 | ✅ |
| Node.js | 26.x | ✅ |
| Firebase CLI | 15.x | ✅ |
| Homebrew | 5.x | ✅ |
| gh (GitHub CLI) | 2.x | ✅ |

---

## Repository

Already cloned at:
```
~/Documents/Repositories/SpotMe/
```

Xcode project:
```
~/Documents/Repositories/SpotMe/SpotMe/SpotMe.xcodeproj
```

---

## Firebase SDK (SPM)

Add via Xcode: **File → Add Package Dependencies...**

```
URL: https://github.com/firebase/firebase-ios-sdk
Version: Up to Next Major (11.0.0)

Required products:
- FirebaseAuth
- FirebaseFirestore
- FirebaseFunctions
```

> **Note:** `GoogleService-Info.plist` is NOT needed for local development. The app uses programmatic `FirebaseOptions` in `DEBUG` builds pointing to the local emulator with `projectID = "demo-spotme"`. The plist is only needed when connecting to a real Firebase project (production).

---

## Firebase Emulator Setup

The `firebase/` directory is already configured. Run the emulators from the repo root:

```bash
cd firebase
npm install --prefix functions   # first time only — installs Cloud Functions deps
firebase emulators:start --project demo-spotme
```

Emulator ports:
| Service | Port | URL |
|---------|------|-----|
| Auth | 9099 | — |
| Firestore | 8080 | — |
| Functions | 5001 | — |
| Emulator UI | 4000 | http://localhost:4000 |

The iOS app automatically connects to these ports in `DEBUG` builds (configured in `SpotMeApp.swift`).

---

## Xcode Configuration

### Adding Source Files

The following folders exist on disk but must be added to the Xcode project once:

1. In Xcode, right-click the **SpotMe** source group in Project Navigator
2. Select **Add Files to "SpotMe"...**
3. Select these folders (inside `SpotMe/SpotMe/`):
   - `App`
   - `Core`
   - `Features`
   - `DesignSystem`
   - `Resources`
4. Ensure **Add to targets: SpotMe** is checked → click **Add**
5. Delete the default `ContentView.swift` (right-click → Delete → Move to Trash)

### Build Settings

| Setting | Value |
|---------|-------|
| iOS Deployment Target | 17.0 |
| Swift Language Version | 5.9 |

### Schemes

- **SpotMe (Debug)** — Connects to Firebase Emulator (auto-configured in code)
- **SpotMe (Release)** — Connects to production Firebase (requires `GoogleService-Info.plist`)

---

## Production Firebase (when ready)

When ready to go live:

1. Create project at [Firebase Console](https://console.firebase.google.com)
   - Project name: `SpotMe`
   - Bundle ID: `com.gamaun.SpotMe`
2. Enable **Authentication**: Email/Password + Apple Sign-In
3. Create **Firestore** database (start in test mode, add rules after)
4. Download `GoogleService-Info.plist` → add to Xcode project (do NOT commit — it's in `.gitignore`)
5. Deploy rules and functions:
   ```bash
   cd firebase
   firebase use <your-project-id>
   firebase deploy --only firestore,functions
   ```

---

## Git Workflow

- `main` — stable, always buildable
- `feature/*` — feature branches
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`)
- Push directly to main for solo development (no PR required)

### .gitignore key entries

```
GoogleService-Info.plist   ← secret, never commit
.claude/settings.local.json
DerivedData/
*.xcuserdata/
firebase/functions/node_modules/
```

---

## Useful Commands

```bash
# Firebase
cd firebase
firebase emulators:start --project demo-spotme    # Start local emulators
firebase deploy --only functions                  # Deploy Cloud Functions
firebase deploy --only firestore                  # Deploy security rules

# Xcode (CLI)
xcodebuild build -scheme SpotMe -destination 'platform=iOS Simulator,name=iPhone 16'
xcodebuild test -scheme SpotMe -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Testing Setup

### Unit Tests
- Target: `SpotMeTests` (add via Xcode: File → New → Target → Unit Testing Bundle)
- Test ViewModels with mock repositories (protocols enable easy mocking)
- Test repositories against Firebase Emulator

### UI Tests
- Target: `SpotMeUITests` (add via Xcode: File → New → Target → UI Testing Bundle)
- Critical flows only: sign-in, start session, complete set
