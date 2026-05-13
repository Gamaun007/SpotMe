# SpotMe — Data Model

> **Status:** Draft — To be refined after user stories are finalized

## Overview

Firestore NoSQL database. Collections organized around core entities. Schema designed to be client-agnostic (no iOS-specific assumptions).

---

## Collections

### `users`

```
users/{userId}
{
  id: string                    // Firebase Auth UID
  email: string
  displayName: string
  role: "trainer" | "trainee"
  createdAt: timestamp
  updatedAt: timestamp
}
```

### `programs`

```
programs/{programId}
{
  id: string
  trainerId: string             // owner
  name: string
  description: string | null
  exercises: [                  // embedded array (not subcollection)
    {
      id: string
      name: string
      targetSets: number
      targetReps: number
      targetWeight: number | null
      order: number
    }
  ]
  createdAt: timestamp
  updatedAt: timestamp
}
```

### `relationships`

```
relationships/{relationshipId}
{
  id: string
  trainerId: string
  traineeId: string
  status: "active" | "inactive"
  createdAt: timestamp
  updatedAt: timestamp | null
}
```

### `inviteCodes`

```
inviteCodes/{code}
{
  code: string                  // 6-char alphanumeric
  trainerId: string
  createdAt: timestamp
  expiresAt: timestamp
  used: boolean
  usedBy: string | null
}
```

### `sessions`

```
sessions/{sessionId}
{
  id: string
  traineeId: string
  trainerId: string             // from relationship
  programId: string
  programName: string           // denormalized for display
  status: "active" | "completed"
  startedAt: timestamp
  completedAt: timestamp | null
  exercises: [
    {
      exerciseId: string
      name: string
      targetSets: number
      targetReps: number
      targetWeight: number | null
      completedSets: [
        {
          id: string
          reps: number
          weight: number
          completedAt: timestamp
          loggedBy: "trainee" | "trainer"
        }
      ]
    }
  ]
}
```

---

## Design Decisions

### Embedded arrays vs. subcollections

| Choice | Rationale |
|--------|-----------|
| Exercises IN program document | Always read together, <100 exercises per program, avoids extra reads |
| Sets IN session document | Always read together, real-time listener on single doc is simpler |

**Trade-off:** Document size limit is 1 MiB. A session with 10 exercises × 5 sets = 50 set records. Even with 200 bytes/set, that's 10 KB — well within limits.

### Denormalization

- `programName` stored in session (avoid extra read when displaying history)
- `trainerId` stored in session (enables trainer's session query without joining)

### Indexes Required

| Collection | Fields | Type |
|-----------|--------|------|
| sessions | traineeId + status | Composite |
| sessions | trainerId + status | Composite |
| sessions | traineeId + completedAt | Composite (for history) |
| relationships | trainerId + status | Composite |
| relationships | traineeId + status | Composite |
| inviteCodes | code + used + expiresAt | Composite |

---

## Security Rules (Overview)

```
users/{userId}:
  - read/write: only if request.auth.uid == userId

programs/{programId}:
  - read/write: only if request.auth.uid == resource.data.trainerId

relationships/{relId}:
  - read: if auth.uid == trainerId OR auth.uid == traineeId
  - create: via Cloud Function only (invite code validation)
  - update: if auth.uid == trainerId OR auth.uid == traineeId

sessions/{sessionId}:
  - read: if auth.uid == traineeId OR auth.uid == trainerId (with active relationship)
  - write: if auth.uid == traineeId OR auth.uid == trainerId (with active relationship)

inviteCodes/{code}:
  - read/write: via Cloud Function only
```

---

## Open Questions

- Should sessions be a subcollection under users? (`users/{id}/sessions/{id}`)  
  → Probably not — both trainer and trainee need to query them
- Should we store exercise history separately for quick progress lookups?
- Do we need a `assignments` collection or just store `assignedProgramId` on the relationship?
