# SpotMe — General Idea

## Problem

The creator of this project actively does bodybuilding and uses the iPhone app **HeavySet** to track workouts, repetitions, and progress in a training journal.

His mother (50 years old, zero prior gym experience) recently started training with him. He acts as her personal trainer. To ensure productive progress, she needs to maintain a workout journal so both of them know what she's doing, how much she should do next week, and how to progress.

**The core problem:** This journaling process is genuinely difficult for her. She is not comfortable with technology — navigating apps, logging workouts, and understanding records takes too much time during the session and is frustrating. The existing tools on the market are built for self-motivated, tech-savvy gym-goers, not for coached beginners.

## Solution

An iOS application called **SpotMe** — a workout tracking app built around the **trainer–trainee relationship**.

## User Roles

### Trainer
- Creates and stores workout programs in their account
- Shares programs with other users
- Establishes trainer–trainee relationships with other users
- Assigns workout programs to trainees
- Modifies assigned programs at any time
- Monitors a trainee's active workout session in real time
- Can edit/supplement a trainee's active session directly (e.g., log sets, reps, weights on their behalf)

### Trainee (Client)
- Receives assigned workout programs from their trainer
- Trains according to the assigned program
- Has their session managed/assisted by the trainer when needed
- Minimal interaction required — the app should be as simple as possible for this role

## Key Features

1. **Workout Program Builder** — Trainers can create, edit, and store custom workout programs
2. **Program Sharing** — Programs can be shared between users
3. **Trainer–Trainee Relationships** — Users can link accounts in a coach/client pairing
4. **Program Assignment** — Trainers assign specific programs to their trainees
5. **Active Session Monitoring** — Trainers can view a trainee's current workout session in real time
6. **Remote Session Editing** — Trainers can log sets, reps, and weights into a trainee's active session from their own device
7. **Simple Trainee UX** — The trainee-facing experience must be extremely accessible for non-tech-savvy users

## Target Platform

- **iOS** (iPhone) — primary and initial platform

## Tech Stack

- iOS 17+ / SwiftUI / Swift 5.9+
- Firebase (Firestore, Auth, Cloud Functions)
- Swift Package Manager

See `docs/infra/tech-stack.md` for full rationale and version details.

## Repository

- GitHub: https://github.com/Gamaun007/SpotMe (public)
- Owner: Gamaun007
