# SpotMe — User Stories: Authentication

> **Status:** Draft — To be refined in Phase 2

## Overview

Authentication enables users to create accounts, sign in, and establish their role (Trainer or Trainee). Firebase Auth handles identity; Firestore stores the user profile.

---

## User Stories

### US-AUTH-01: Sign Up with Email

**As a** new user  
**I want to** create an account with email and password  
**So that** I can access the app

**Acceptance Criteria:**
- [ ] User provides email, password, display name
- [ ] Password minimum 8 characters
- [ ] Email verification sent (optional for MVP — decide later)
- [ ] User profile document created in Firestore
- [ ] User is prompted to select role (Trainer or Trainee) after sign-up

---

### US-AUTH-02: Sign Up with Apple

**As a** new user  
**I want to** sign up using Apple Sign-In  
**So that** I can create an account without managing a password

**Acceptance Criteria:**
- [ ] Standard Apple Sign-In flow
- [ ] Display name pulled from Apple ID (if shared)
- [ ] User profile document created in Firestore
- [ ] User is prompted to select role after first sign-in

---

### US-AUTH-03: Sign In

**As a** returning user  
**I want to** sign in to my account  
**So that** I can access my data

**Acceptance Criteria:**
- [ ] Email/password sign-in works
- [ ] Apple Sign-In works
- [ ] Invalid credentials show clear error message
- [ ] After sign-in, user lands on their role-appropriate home screen

---

### US-AUTH-04: Role Selection

**As a** new user  
**I want to** choose whether I'm a Trainer or Trainee  
**So that** the app shows me the right experience

**Acceptance Criteria:**
- [ ] Shown once after first sign-up
- [ ] Two clear options: "I'm a Trainer" / "I'm a Trainee"
- [ ] Role stored in user profile document
- [ ] Role determines navigation structure and available features
- [ ] Role can be changed later in settings (edge case, low priority)

---

### US-AUTH-05: Sign Out

**As a** signed-in user  
**I want to** sign out  
**So that** I can switch accounts or secure my device

**Acceptance Criteria:**
- [ ] Sign out button in settings/profile
- [ ] Clears auth state, returns to sign-in screen
- [ ] Local Firestore cache is NOT cleared (offline data preserved)

---

## Open Questions

- Should email verification be required before using the app?
- Should we support "forgot password" flow in MVP?
- Can a user be both Trainer and Trainee? (e.g., trains someone but also has their own trainer)
