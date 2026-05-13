# SpotMe — MVP Feature Overview

## Prioritization

- **P0** — Must have for MVP. App is unusable without it.
- **P1** — Important for MVP. Core value proposition.
- **P2** — Nice to have. Can ship without, add soon after.

---

## P0 — Foundation

| # | Feature | Description |
|---|---------|-------------|
| 1 | Authentication | Apple Sign-In + Email/Password. User profile with role selection. |
| 2 | Workout Program Builder | Trainer creates programs: name, exercises, sets/reps/weight templates. |
| 3 | Trainer–Trainee Relationship | Trainer generates invite code. Trainee enters code to link accounts. |
| 4 | Program Assignment | Trainer assigns a program to a linked trainee. |
| 5 | Active Workout Session | Trainee starts a session from assigned program. Logs sets/reps/weight. |

## P1 — Core Value

| # | Feature | Description |
|---|---------|-------------|
| 6 | Real-time Session Monitoring | Trainer sees trainee's active session live (sets completed, weights used). |
| 7 | Remote Session Editing | Trainer can log sets/reps/weight into trainee's active session from their own device. |
| 8 | Session History | Both trainer and trainee can view past completed sessions. |
| 9 | Program Management | Edit, duplicate, delete programs. Reorder exercises. |

## P2 — Post-MVP

| # | Feature | Description |
|---|---------|-------------|
| 10 | Push Notifications | "Trainee started session", "Trainer is watching", session reminders. |
| 11 | Progress Tracking | Charts/graphs showing weight/rep progression over time. |
| 12 | Multiple Trainees | Trainer manages multiple trainee relationships. |
| 13 | Program Sharing | Share programs between users (not just assignment). |
| 14 | Exercise Library | Pre-built exercise database with descriptions/images. |
| 15 | Rest Timer | Configurable rest timer between sets. |

---

## MVP User Flows (High Level)

### Trainer Flow
1. Sign up / Sign in
2. Create a workout program (exercises, sets, reps, weight targets)
3. Generate invite code → share with trainee
4. Assign program to linked trainee
5. See trainee's active session in real time
6. Optionally log sets/reps on trainee's behalf

### Trainee Flow
1. Sign up / Sign in
2. Enter trainer's invite code → link accounts
3. See assigned program
4. Start workout session
5. Log sets as completed (or trainer does it for them)
6. End session

---

## Success Criteria for MVP

- [ ] Trainer can create a program and assign it to a trainee
- [ ] Trainee can execute a workout session from the assigned program
- [ ] Trainer can see trainee's session in real time (<2s latency)
- [ ] Trainer can edit trainee's active session remotely
- [ ] App works offline for trainee (syncs when back online)
- [ ] Non-tech-savvy user (trainee) can complete a session without help
