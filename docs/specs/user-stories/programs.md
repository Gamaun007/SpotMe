# SpotMe — User Stories: Workout Programs

> **Status:** Draft — To be refined in Phase 2

## Overview

The workout program is the core content unit. Trainers build programs (collections of exercises with set/rep/weight templates), store them in their library, and assign them to trainees.

---

## User Stories

### US-PROG-01: Create Program

**As a** trainer  
**I want to** create a workout program  
**So that** I can structure my trainee's workouts

**Acceptance Criteria:**
- [ ] Program has: name, optional description
- [ ] Program contains ordered list of exercises
- [ ] Each exercise has: name, target sets, target reps, optional target weight
- [ ] Can add/remove/reorder exercises
- [ ] Program is saved to trainer's library

---

### US-PROG-02: View Program Library

**As a** trainer  
**I want to** see all my saved programs  
**So that** I can manage and assign them

**Acceptance Criteria:**
- [ ] List of all programs created by this trainer
- [ ] Shows program name and exercise count
- [ ] Tap to view full program details

---

### US-PROG-03: Edit Program

**As a** trainer  
**I want to** edit an existing program  
**So that** I can adjust it based on trainee progress

**Acceptance Criteria:**
- [ ] Can edit name, description
- [ ] Can add/remove/reorder exercises
- [ ] Can modify set/rep/weight targets per exercise
- [ ] Changes save immediately (or on explicit save — decide)
- [ ] If program is currently assigned, changes reflect for trainee

---

### US-PROG-04: Delete Program

**As a** trainer  
**I want to** delete a program I no longer need  
**So that** my library stays clean

**Acceptance Criteria:**
- [ ] Confirmation prompt before deletion
- [ ] If assigned to a trainee, warn trainer
- [ ] Program removed from library
- [ ] Historical sessions that used this program retain their data

---

### US-PROG-05: Assign Program to Trainee

**As a** trainer  
**I want to** assign a program to my trainee  
**So that** they know what to do in the gym

**Acceptance Criteria:**
- [ ] Select program from library
- [ ] Select linked trainee
- [ ] Trainee sees assigned program on their home screen
- [ ] Only one active assignment per trainee (or allow multiple — decide)
- [ ] Trainer can change assignment at any time

---

### US-PROG-06: View Assigned Program (Trainee)

**As a** trainee  
**I want to** see my assigned workout program  
**So that** I know what exercises to do today

**Acceptance Criteria:**
- [ ] Trainee home screen shows current assigned program
- [ ] Lists exercises with target sets/reps/weight
- [ ] Clear "Start Workout" button
- [ ] If no program assigned, shows friendly empty state

---

## Data Model (Preview)

```
Program {
  id: string
  trainerId: string
  name: string
  description: string?
  exercises: Exercise[]
  createdAt: timestamp
  updatedAt: timestamp
}

Exercise {
  id: string
  name: string
  targetSets: number
  targetReps: number
  targetWeight: number?
  order: number
}
```

---

## Open Questions

- Can a trainee have multiple assigned programs (e.g., "Push Day", "Pull Day", "Legs")?
- Should programs support supersets or circuit formats?
- Should exercises have categories/muscle groups?
