# SpotMe — User Stories: Real-Time Monitoring

> **Status:** Draft — To be refined in Phase 2

## Overview

Real-time monitoring is SpotMe's killer feature. The trainer can watch a trainee's active session as it happens — seeing sets completed, weights used, and progress through the workout. The trainer can also edit the session remotely.

---

## User Stories

### US-RT-01: See Active Sessions (Trainer Dashboard)

**As a** trainer  
**I want to** see which of my trainees are currently working out  
**So that** I can monitor them in real time

**Acceptance Criteria:**
- [ ] Trainer home/dashboard shows active session indicator per trainee
- [ ] "Live" badge or indicator for trainees with active sessions
- [ ] Tap to open live monitoring view
- [ ] Updates in real time (no manual refresh)

---

### US-RT-02: Monitor Live Session

**As a** trainer  
**I want to** view my trainee's active session in real time  
**So that** I can see their progress and help remotely

**Acceptance Criteria:**
- [ ] Shows same session data trainee sees: exercises, sets, weights
- [ ] Updates within 2 seconds of trainee logging a set
- [ ] Shows which exercise trainee is currently on
- [ ] Shows completed vs. remaining sets per exercise
- [ ] Scroll through all exercises in the session

---

### US-RT-03: Edit Session Remotely

**As a** trainer  
**I want to** log sets in my trainee's session from my device  
**So that** I can help them track when they're focused on lifting

**Acceptance Criteria:**
- [ ] Same logging interface as trainee (reps + weight per set)
- [ ] Logged set appears on trainee's device within 2 seconds
- [ ] No conflict if both log simultaneously (both sets are recorded)
- [ ] Trainer can modify weight/reps if trainee made an error

---

### US-RT-04: Session Completion Notification

**As a** trainer  
**I want to** know when my trainee finishes their session  
**So that** I can review and provide feedback

**Acceptance Criteria:**
- [ ] Monitoring view shows "Session Completed" state
- [ ] Shows session summary (total sets, duration)
- [ ] Transition is real-time (trainer doesn't need to refresh)

---

## Technical Implementation

### Firestore Listeners

```swift
// Trainer attaches listener to trainee's active session
db.collection("sessions")
  .whereField("traineeId", isEqualTo: traineeId)
  .whereField("status", isEqualTo: "active")
  .addSnapshotListener { snapshot, error in
      // Update UI with latest session state
  }
```

### Latency Target

- **Goal:** <2 seconds from write to display on other device
- **Firestore typical:** 500ms–1.5s for real-time listener updates
- **Offline:** Changes queue locally, sync when connection returns

### Conflict Resolution

- Both trainer and trainee can write simultaneously
- Firestore uses **last-write-wins** at the field level
- For set logging: both writes are **additive** (appending to array), not conflicting
- If both edit the same set's reps/weight: last write wins (acceptable — trainer's edit takes priority in practice)

---

## Data Flow

```
Trainee logs set
       │
       ▼
Firestore (session document updated)
       │
       ▼
Trainer's snapshot listener fires
       │
       ▼
Trainer's UI updates (< 2s total)
```

```
Trainer logs set on behalf
       │
       ▼
Firestore (session document updated)
       │
       ▼
Trainee's snapshot listener fires
       │
       ▼
Trainee's UI updates (< 2s total)
```

---

## Open Questions

- Should trainer receive a push notification when trainee starts a session? (P2)
- Should there be a "trainer is watching" indicator on trainee's screen?
- Can trainer add exercises to an active session? (Probably not for MVP)
- Should trainer be able to add notes/comments during the session?
