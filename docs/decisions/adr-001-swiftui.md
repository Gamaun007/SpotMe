# ADR-001: Native SwiftUI over Cross-Platform

## Status

**Accepted** — 2025-05-13

## Context

The developer has a web background (Angular + Nest.js) and no prior iOS experience. The app targets iOS only for MVP, with potential future expansion to web (Angular), Android, and watchOS.

Options considered:
1. **React Native** — Closest to existing JS/TS skills
2. **Flutter** — Cross-platform with good tooling
3. **Native SwiftUI** — Apple-native, new language to learn

## Decision

We chose **Native SwiftUI** for the iOS client.

## Rationale

### For SwiftUI

1. **iOS-only target** — No cross-platform benefit to capture today
2. **watchOS is only possible natively** — Flutter/RN cannot target watchOS at all
3. **iPad support is trivial** — SwiftUI adaptive layouts, same codebase
4. **Firestore Swift SDK** — First-class offline persistence + real-time listeners, no wrapper overhead
5. **Apple Sign-In** — Native implementation is 2 lines; cross-platform requires libraries and bridging
6. **Accessibility** — SwiftUI's built-in VoiceOver support is critical for the non-tech-savvy trainee
7. **AI-assisted development** — SwiftUI has extensive training data; Claude/Copilot can effectively pair-program
8. **No bridge/engine overhead** — Direct Metal rendering, optimal performance and battery life
9. **Future web is Angular anyway** — "Code sharing" benefit of RN/Flutter is moot since web client will be Angular

### Against alternatives

- **React Native**: JS bridge adds latency, no watchOS, worse offline story, community fragmentation
- **Flutter**: Dart ecosystem is smaller, no watchOS, would still need separate web solution (Angular preferred)

### Risk: Learning curve

Mitigated by:
- AI pair-programming (Copilot + Claude)
- SwiftUI is declarative (similar mental model to Angular templates)
- Firebase SDK abstracts most complexity
- Solo developer = no team alignment cost

## Consequences

- Developer must learn Swift + SwiftUI (aided by AI)
- Android version (if needed) will be a separate Kotlin codebase
- All business logic stays in Firebase Cloud Functions (shared across all future clients)
- Web client will be built in Angular (developer's strength) pointing at same Firebase project
