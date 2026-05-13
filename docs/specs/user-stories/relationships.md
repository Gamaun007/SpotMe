# SpotMe — User Stories: Trainer-Trainee Relationships

> **Status:** Draft — To be refined in Phase 2

## Overview

The relationship system enables trainers and trainees to link their accounts. A trainer generates an invite code; the trainee enters it to establish the connection.

---

## User Stories

### US-REL-01: Generate Invite Code (Trainer)

**As a** trainer  
**I want to** generate an invite code  
**So that** I can share it with my trainee to link our accounts

**Acceptance Criteria:**
- [ ] Trainer taps "Invite Trainee" button
- [ ] System generates a unique, short code (6 characters, alphanumeric)
- [ ] Code displayed on screen with option to copy/share
- [ ] Code expires after 24 hours (or configurable)
- [ ] Code is single-use (consumed after one trainee links)
- [ ] Code generation handled by Cloud Function (server-validated)

---

### US-REL-02: Enter Invite Code (Trainee)

**As a** trainee  
**I want to** enter my trainer's invite code  
**So that** we can connect our accounts

**Acceptance Criteria:**
- [ ] Trainee has "Connect to Trainer" option on home screen
- [ ] Simple input field for the code
- [ ] On submit: validates code exists and is not expired
- [ ] If valid: creates relationship, shows trainer's name as confirmation
- [ ] If invalid/expired: clear error message
- [ ] After linking, trainee sees assigned programs from this trainer

---

### US-REL-03: View Linked Trainees (Trainer)

**As a** trainer  
**I want to** see all my linked trainees  
**So that** I can manage who I'm coaching

**Acceptance Criteria:**
- [ ] List of all trainees linked to this trainer
- [ ] Shows trainee display name
- [ ] Tap trainee → see their assigned program, session history
- [ ] Active session indicator (if trainee is currently working out)

---

### US-REL-04: View Trainer (Trainee)

**As a** trainee  
**I want to** see who my trainer is  
**So that** I know the connection is established

**Acceptance Criteria:**
- [ ] Trainee profile/settings shows linked trainer name
- [ ] Option to disconnect (with confirmation)

---

### US-REL-05: Remove Relationship

**As a** trainer or trainee  
**I want to** disconnect from the other person  
**So that** I can end the coaching relationship

**Acceptance Criteria:**
- [ ] Either party can initiate disconnect
- [ ] Confirmation prompt
- [ ] Relationship document marked as inactive
- [ ] Historical session data is preserved
- [ ] Active program assignment is removed

---

## Data Model (Preview)

```
Relationship {
  id: string
  trainerId: string
  traineeId: string
  status: "active" | "inactive"
  createdAt: timestamp
}

InviteCode {
  code: string
  trainerId: string
  createdAt: timestamp
  expiresAt: timestamp
  used: boolean
  usedBy: string?
}
```

---

## Open Questions

- Can a trainee have multiple trainers?
- Can a trainer be a trainee to someone else simultaneously?
- Should the invite flow support deep links (trainee taps a link instead of typing code)?
