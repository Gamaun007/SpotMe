# SpotMe — User Stories: Active Workout Sessions

> **Status:** Draft — To be refined in Phase 2

## Overview

The active session is where the actual workout happens. A trainee starts a session from their assigned program, logs completed sets (reps + weight), and ends the session when done. The trainer can also log sets on their behalf.

---

## User Stories

### US-SESS-01: Start Session (Trainee)

**As a** trainee  
**I want to** start a workout session from my assigned program  
**So that** I can begin tracking my workout

**Acceptance Criteria:**
- [ ] "Start Workout" button on assigned program
- [ ] Creates a new session document in Firestore
- [ ] Session is pre-populated with exercises from the assigned program
- [ ] Each exercise shows target sets/reps/weight
- [ ] Session status = "active"
- [ ] Timestamp recorded

---

### US-SESS-02: Log a Set (Trainee)

**As a** trainee  
**I want to** record that I completed a set  
**So that** my workout is tracked

**Acceptance Criteria:**
- [ ] For each exercise, trainee can log individual sets
- [ ] Each set records: actual reps, actual weight
- [ ] Pre-filled with target values (trainee can adjust)
- [ ] Single tap to confirm set (minimal interaction for non-tech user)
- [ ] Set appears as completed in the exercise list
- [ ] Data syncs to Firestore immediately (real-time for trainer)

---

### US-SESS-03: Complete Exercise

**As a** trainee  
**I want to** see when all sets for an exercise are done  
**So that** I know to move to the next exercise

**Acceptance Criteria:**
- [ ] Visual indicator when all target sets are logged
- [ ] Auto-advances to next exercise (or shows clear "next" action)
- [ ] Trainee can go back to previous exercises if needed

---

### US-SESS-04: End Session

**As a** trainee  
**I want to** finish my workout session  
**So that** it's saved as completed

**Acceptance Criteria:**
- [ ] "End Workout" button
- [ ] Session status changes to "completed"
- [ ] End timestamp recorded
- [ ] Summary shown: exercises done, total sets, duration
- [ ] Session saved to history

---

### US-SESS-05: Log Set on Behalf (Trainer)

**As a** trainer  
**I want to** log a set in my trainee's active session  
**So that** I can help them track when they're busy lifting

**Acceptance Criteria:**
- [ ] Trainer sees trainee's active session (from monitoring view)
- [ ] Trainer can tap to log a set for any exercise
- [ ] Same set data: reps + weight
- [ ] Set appears on trainee's device in real-time
- [ ] Set is marked as "logged by trainer" (metadata, not visible to trainee)

---

### US-SESS-06: View Session History

**As a** trainer or trainee  
**I want to** see past completed sessions  
**So that** I can track progress over time

**Acceptance Criteria:**
- [ ] List of past sessions with date and program name
- [ ] Tap to view full session detail (all exercises, sets, weights)
- [ ] Trainer can view any linked trainee's history
- [ ] Trainee sees only their own history

---

## Session Lifecycle

```
[No Session] → Start → [Active] → End → [Completed]
                           ↑
                    Trainee OR Trainer
                    can log sets while active
```

---

## Data Model (Preview)

```
Session {
  id: string
  traineeId: string
  trainerId: string
  programId: string
  status: "active" | "completed"
  startedAt: timestamp
  completedAt: timestamp?
  exercises: SessionExercise[]
}

SessionExercise {
  exerciseId: string
  name: string
  targetSets: number
  targetReps: number
  targetWeight: number?
  completedSets: SetRecord[]
}

SetRecord {
  id: string
  reps: number
  weight: number
  completedAt: timestamp
  loggedBy: "trainee" | "trainer"
}
```

---

## UX Considerations (Trainee)

- **Minimal taps** — Logging a set should be 1-2 taps max
- **Large touch targets** — Trainee may have sweaty hands, gym gloves
- **Clear visual feedback** — Set logged = immediate visual confirmation
- **No confusion** — Current exercise and set number always obvious
- **Works offline** — Sets log to local cache, sync when connected

---

## Open Questions

- Can a trainee have multiple active sessions? (Probably not — one at a time)
- Should there be a rest timer between sets?
- What happens if trainee force-quits app mid-session? (Session stays "active" until manually ended or auto-timeout)
- Should trainer be able to START a session on behalf of trainee?
