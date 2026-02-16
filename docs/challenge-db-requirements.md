# Challenge Database — Requirements

**Feature:** Challenge submission, browsing, and lightweight team-matching system
**Status:** Draft
**Last updated:** 2026-02-15

---

## 1. Problem

Hackathon participants have no way to share project ideas or find teammates before the event. People show up on March 14 with vague intentions, waste time forming teams, and end up on projects they're lukewarm about.

## 2. Goals

- Let registered participants **post challenge ideas** with a description, track, and skill needs.
- Let anyone **browse and filter** submitted challenges by track, skills, and team status.
- Provide **lightweight team matching** — each submission includes contact info (Discord/email) so people can reach out off-site.
- Maintain the existing cyberpunk aesthetic and page feel.

## 3. Non-Goals

- No on-site direct messaging or chat.
- No real-time collaboration tools.
- No voting/ranking system (v1).
- No full user profiles beyond what's on each submission.
- No admin dashboard (v1).

---

## 4. Users & Access

| Role | Can browse | Can post | Can edit/delete own | Can moderate |
|------|-----------|----------|---------------------|-------------|
| Anonymous visitor | Yes | No | No | No |
| Registered participant (authenticated) | Yes | Yes | Yes | No |
| Organizer | Yes | Yes | Yes | Yes (via backend) |

Authentication must be tied to hackathon registration — only people who have registered for the event can post challenges. Browsing is open to everyone with no login required.

---

## 5. Functional Requirements

### 5.1 Browse Challenges

- **FR-1:** The challenge database section appears on the existing challenges.html page, below the track descriptions.
- **FR-2:** Challenges display as a card grid showing: title, track badge, description excerpt, skill tags, team status, author name, and contact method.
- **FR-3:** Users can filter challenges by track (SHADOW / SENTINEL / ZERO / ROGUE).
- **FR-4:** Users can filter by skill tags.
- **FR-5:** Users can filter by team status (Looking / Open / Full).
- **FR-6:** Users can search challenges by keyword across title and description.
- **FR-7:** Results are paginated or use infinite scroll.
- **FR-8:** An empty state is shown when no challenges exist yet, encouraging the first submission.
- **FR-9:** Browsing requires no authentication.

### 5.2 Post a Challenge

- **FR-10:** Only authenticated, registered participants can post.
- **FR-11:** Unauthenticated users who click "Post" are prompted to authenticate first.
- **FR-12:** Submission form collects: title, description, track, skills (from predefined list, up to 5), contact method (Discord or email), contact handle, and team status.
- **FR-13:** Title must be 5–100 characters. Description must be 20–1,000 characters.
- **FR-14:** The newly posted challenge appears in the list immediately after submission.
- **FR-15:** A participant may post multiple challenges.

### 5.3 Edit / Delete Own Challenge

- **FR-16:** Authenticated users see edit and delete controls on their own challenge cards only.
- **FR-17:** Editing opens a pre-filled version of the submission form.
- **FR-18:** Deleting requires a confirmation step.
- **FR-19:** A user cannot edit or delete another user's challenge.

### 5.4 Connect with a Team

- **FR-20:** Each challenge card has a "Connect" action that surfaces the poster's contact handle.
- **FR-21:** Clicking "Connect" copies the handle to clipboard or opens a mailto/Discord link.
- **FR-22:** A confirmation toast notifies the user that the handle was copied.

### 5.5 Authentication

- **FR-23:** Authentication uses passwordless email verification (magic link).
- **FR-24:** Only emails that appear in the hackathon registration list are accepted.
- **FR-25:** If an unregistered email is entered, the user sees a clear error with a link to register.
- **FR-26:** Sessions persist so returning users don't need to re-authenticate each visit.
- **FR-27:** A logged-in indicator and logout option are visible when authenticated.

---

## 6. Data Model (Logical)

Each challenge submission contains:

| Field | Required | Constraints |
|-------|----------|------------|
| Title | Yes | 5–100 characters |
| Description | Yes | 20–1,000 characters |
| Track | Yes | One of: SHADOW, SENTINEL, ZERO, ROGUE |
| Skills | Yes | 1–5 selections from predefined taxonomy |
| Contact method | Yes | Discord or Email |
| Contact handle | Yes | Free text |
| Team status | Yes | Looking, Open, or Full |
| Current team size | Yes | 1–4 |
| Author name | Yes | From registration data |
| Author email | Yes | From authentication, not displayed publicly |
| Created timestamp | Auto | — |
| Updated timestamp | Auto | — |

---

## 7. Skills Taxonomy

Predefined skill tags grouped by category:

- **Technical:** Python, JavaScript, Rust, Go, C++, Solidity, SQL
- **AI/ML:** Machine Learning, NLP, Computer Vision, LLMs, Reinforcement Learning, Fine-tuning
- **Security:** Red Team, Blue Team, Cryptography, Reverse Engineering, Fuzzing, Pen Testing
- **Domain:** Privacy, ZK Proofs, Smart Contracts, DevSecOps, Threat Modeling
- **Other:** UI/UX, Hardware, Research, Writing

No freeform tags in v1 to keep filtering clean.

---

## 8. UI Requirements

- **UI-1:** The database section integrates into the existing challenges.html page (not a separate page).
- **UI-2:** Challenge cards use the existing cyberpunk design system — track colors, monospace type, dark backgrounds, neon accents.
- **UI-3:** A horizontal filter/search bar sits above the card grid.
- **UI-4:** The submission form appears as a modal overlay.
- **UI-5:** The auth prompt appears as a modal overlay.
- **UI-6:** Cards display a colored left border matching the track color (red/blue/cyan/purple).
- **UI-7:** Team status shows as a color-coded indicator: green = looking, yellow = open, grey = full.
- **UI-8:** On mobile (≤768px), cards stack single-column, filters collapse, and the submission form goes full-screen.
- **UI-9:** All interactive elements meet ≥44px touch targets on mobile.
- **UI-10:** Page animations match the existing GSAP-based reveal pattern.
- **UI-11:** Loading, error, and empty states are all handled with appropriate feedback.

---

## 9. Edge Cases

| Scenario | Expected behavior |
|----------|-------------------|
| User posts but email isn't in registration list | Reject with clear error: "Email not found — register first" |
| Magic link expires | Show "Link expired" with option to request a new one |
| Multiple challenges from same user | Allowed, no limit in v1 |
| Backend unavailable | Existing static page content renders normally; database section shows "temporarily unavailable" |
| Offensive or spam content | Manual moderation by organizers via backend dashboard |
| User deletes a challenge | Permanent in v1 (no undo) |

---

## 10. Success Metrics

- **Adoption:** ≥30% of registered participants post or browse challenges before March 14.
- **Team formation:** ≥10 teams form through the database (self-reported at event).
- **Engagement:** >2 min average time-on-section in analytics.

---

## 11. Open Questions

1. **Contact privacy:** Show contact handles publicly to everyone, or only to authenticated users?
2. **Comments:** Should others be able to leave "I'm interested!" replies on challenges?
3. **Duplicate detection:** Surface "similar challenges" when someone is posting a new one?
4. **Post-event:** Archive or lock the database after March 14?
5. **Skill tag management:** Fixed list only, or let organizers add/remove tags over time?
