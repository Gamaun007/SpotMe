# SpotMe — Development Environment Setup

## Prerequisites

| Tool | Version | Installation |
|------|---------|-------------|
| macOS | 14.0+ (Sonoma) | — |
| Xcode | 15.0+ | Mac App Store |
| Node.js | 18+ | `brew install node` |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| Git | Latest | Pre-installed on macOS |
| Apple Developer Account | Free or Paid | developer.apple.com |

> **Note:** Free Apple Developer account is sufficient for simulator testing. Paid ($99/year) required for device testing and App Store.

---

## Initial Setup Steps

### 1. Clone Repository

```bash
git clone https://github.com/Gamaun007/SpotMe.git
cd SpotMe
```

### 2. Create Xcode Project

```
File → New → Project → iOS → App
- Product Name: SpotMe
- Team: (your Apple ID)
- Organization Identifier: com.gamaun.spotme
- Interface: SwiftUI
- Language: Swift
- Storage: None
- Include Tests: Yes
```

### 3. Add Firebase SDK via SPM

```
Xcode → File → Add Package Dependencies
URL: https://github.com/firebase/firebase-ios-sdk
Version: Up to Next Major (11.0.0)

Select products:
- FirebaseAuth
- FirebaseFirestore
- FirebaseFunctions
- FirebaseAnalytics
```

### 4. Firebase Project Setup

```bash
# Login to Firebase
firebase login

# Initialize Firebase in the project
cd firebase/
firebase init

# Select:
# - Firestore
# - Functions (TypeScript)
# - Emulators (Auth, Firestore, Functions)
```

### 5. Firebase Console Configuration

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project: "SpotMe"
3. Add iOS app:
   - Bundle ID: `com.gamaun.spotme`
   - Download `GoogleService-Info.plist`
   - Add to Xcode project (drag into SpotMe/ folder)
4. Enable Authentication:
   - Email/Password → Enable
   - Apple → Enable (requires Apple Developer enrollment)
5. Create Firestore database:
   - Start in test mode (will add rules later)
   - Location: `us-central1` (or nearest region)

### 6. Firebase Emulator Suite (Local Development)

```bash
cd firebase/
firebase emulators:start

# Runs locally:
# - Firestore: localhost:8080
# - Auth: localhost:9099
# - Functions: localhost:5001
# - Emulator UI: localhost:4000
```

---

## Xcode Configuration

### Build Settings

| Setting | Value |
|---------|-------|
| iOS Deployment Target | 17.0 |
| Swift Language Version | 5.9 |
| Build Configuration (Debug) | Use Firebase Emulator |
| Build Configuration (Release) | Use Production Firebase |

### Schemes

- **SpotMe (Debug)** — Points to Firebase Emulator
- **SpotMe (Release)** — Points to production Firebase

### Environment Variables (Debug scheme)

```
USE_FIREBASE_EMULATOR = 1
FIRESTORE_EMULATOR_HOST = localhost:8080
AUTH_EMULATOR_HOST = localhost:9099
```

---

## Git Workflow

- `main` — stable, deployable
- `feature/*` — feature branches
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`)

### .gitignore (key entries)

```
# Xcode
*.xcuserdata/
DerivedData/
.build/

# Firebase
firebase/functions/node_modules/
firebase/functions/lib/

# Secrets
GoogleService-Info.plist   ← add to .gitignore if repo is public
```

> **Security Note:** If the repo stays public, `GoogleService-Info.plist` should NOT be committed. Use a `.plist.example` with placeholder values and document setup in this file.

---

## Testing Setup

### Unit Tests
- Target: `SpotMeTests`
- Test ViewModels with mocked repositories
- Test repositories with Firebase Emulator

### UI Tests
- Target: `SpotMeUITests`
- Critical flows only: sign-in, start session, complete set

### Running Tests

```bash
# From Xcode: Cmd + U

# From CLI:
xcodebuild test -scheme SpotMe -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Useful Commands

```bash
# Firebase
firebase deploy --only functions     # Deploy Cloud Functions
firebase deploy --only firestore     # Deploy security rules
firebase emulators:start             # Start local emulators

# Xcode (CLI)
xcodebuild build -scheme SpotMe      # Build from terminal
xcrun simctl boot "iPhone 15"        # Boot simulator
```
