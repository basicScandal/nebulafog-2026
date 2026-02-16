# Challenge Database — Product Requirements Spec

**Feature:** Challenge submission, browsing, and lightweight team-matching system
**Location:** `challenges.html` (extension of existing page)
**Status:** Draft
**Last updated:** 2026-02-15

---

## 1. Problem

Hackathon participants currently have no way to share project ideas or find teammates before the event. People show up on March 14 with vague intentions, waste time forming teams, and sometimes end up on projects they're lukewarm about. We want to fix that by letting people post ideas, browse what others are working on, and connect with potential teammates *before* the hackathon.

## 2. Goals

- Let registered participants **post challenge ideas** with a description, track, and skill needs.
- Let anyone **browse and filter** submitted challenges by track, skills, and team status.
- Provide **lightweight team matching** — each submission includes contact info (Discord/email) so people can reach out off-site.
- Maintain the existing cyberpunk aesthetic and page feel.
- Keep the architecture simple — the rest of the site stays static.

## 3. Non-Goals

- No on-site direct messaging or chat.
- No real-time collaboration tools (Google Docs, shared whiteboards, etc.).
- No voting/ranking system (v1).
- No full user profiles beyond what's on each submission.
- No admin dashboard (v1 — use Supabase dashboard directly).

---

## 4. Architecture

### 4.1 Backend: Supabase

Supabase provides Postgres, auth, Row Level Security (RLS), and a REST API — all free-tier eligible for this scale.

**Why Supabase over Firebase:**
- Postgres is familiar, queryable, and doesn't lock you in.
- RLS provides fine-grained security without cloud functions.
- JS client is lightweight (~8KB gzipped).
- Free tier: 500MB DB, 50K monthly active users, 5GB bandwidth — more than enough.

### 4.2 Auth: Registration-Linked

Participants authenticate via **email magic link** through Supabase Auth. The flow:

1. User clicks "Post a Challenge" on challenges.html.
2. Modal asks for their email (must match a registered participant).
3. Supabase sends a magic link to that email.
4. Clicking the link authenticates them and redirects back to challenges.html with a session.
5. Session persists via Supabase's built-in token management (localStorage).

**Registration linkage:** A `registered_participants` table (or column check) ensures only emails that have gone through the hackathon registration can post. This table is populated by organizers from the registration data (Luma export or manual).

### 4.3 Database Schema

```sql
-- Populated by organizers from registration export
create table registered_participants (
  email text primary key,
  display_name text not null,
  created_at timestamptz default now()
);

-- Core challenge submissions
create table challenges (
  id uuid primary key default gen_random_uuid(),
  author_email text references registered_participants(email),
  author_name text not null,
  title text not null check (char_length(title) between 5 and 100),
  description text not null check (char_length(description) between 20 and 1000),
  track text not null check (track in ('SHADOW', 'SENTINEL', 'ZERO', 'ROGUE')),
  skills text[] not null default '{}',
  contact_method text not null check (contact_method in ('discord', 'email')),
  contact_handle text not null,
  team_status text not null default 'looking' check (team_status in ('looking', 'open', 'full')),
  team_size int default 1 check (team_size between 1 and 4),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- RLS policies
-- Anyone can read challenges (no auth required to browse)
-- Only the author can insert/update/delete their own challenges
-- Only registered participants can insert
```

### 4.4 Row Level Security (RLS)

| Operation | Policy |
|-----------|--------|
| `SELECT` | Public — anyone can browse, no auth needed |
| `INSERT` | Authenticated user whose `auth.email()` exists in `registered_participants` |
| `UPDATE` | Authenticated user where `auth.email() = author_email` |
| `DELETE` | Authenticated user where `auth.email() = author_email` |

### 4.5 Client Integration

Load the Supabase JS client via CDN (consistent with the project's no-build-system approach):

```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js"></script>
```

Initialize with the project's public anon key (safe to expose — RLS does the protection):

```javascript
const supabase = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
```

---

## 5. User Flows

### 5.1 Browse Challenges (Unauthenticated)

```
User visits challenges.html
  → Existing track cards render as before
  → Below tracks: new "CHALLENGE DATABASE" section appears
  → Challenges load from Supabase (paginated, 12 per page)
  → User can filter by: track, skills, team status
  → User can search by keyword (title/description)
  → Each card shows: title, track badge, description excerpt,
    skills tags, team status, author name, contact method
  → Click card → expands inline or opens detail view
```

### 5.2 Post a Challenge (Authenticated)

```
User clicks "Post a Challenge" button
  → If not authenticated:
    → Modal: "Enter your registered email"
    → Supabase sends magic link
    → User clicks link in email → redirected back, now authenticated
  → If authenticated:
    → Submission form appears (modal or inline section)
    → Fields: title, description, track (dropdown), skills (multi-select),
      contact method (discord/email), contact handle, team status
    → Submit → writes to Supabase → card appears in list
    → Success confirmation with cyberpunk flair
```

### 5.3 Edit/Delete Own Challenge (Authenticated)

```
Authenticated user sees "Edit" and "Delete" buttons on their own cards
  → Edit opens pre-filled form
  → Delete shows confirmation dialog
  → Changes reflected immediately
```

### 5.4 Connect with a Team

```
User sees a challenge they like
  → Card shows contact method icon (Discord or Email)
  → Click "Connect" → copies contact handle to clipboard
    OR opens mailto:/discord link
  → Toast notification: "Discord handle copied — reach out!"
```

---

## 6. UI Design

### 6.1 Page Layout Change

The existing challenges.html stays intact. The Challenge Database is inserted as a **new section** between the existing "SELECT YOUR PATH" section and the "BOUNTIES" section. Structure:

```
[Existing] Protocol Cards (4 tracks)
[Existing] SELECT YOUR PATH
[NEW]      ── CHALLENGE DATABASE ──
              Filter bar
              Challenge card grid
              Pagination / Load more
[Existing] BOUNTIES
[Existing] Judging Criteria
...
```

### 6.2 Section Header

Follows existing pattern — section tag + title + subtitle:

```
[CHALLENGE_DB // LIVE]
CHALLENGE DATABASE
Post your idea. Find your squad. Build something dangerous.
[+ Post a Challenge]  [Filter ▾]  [Search ▾]
```

### 6.3 Challenge Card Design

Each card follows the cyberpunk aesthetic established by the protocol cards:

```
┌─────────────────────────────────────────┐
│ [SHADOW]                    🟢 Looking  │
│                                         │
│ Adversarial Prompt Injection Toolkit    │
│                                         │
│ Build a framework for testing LLM       │
│ robustness against prompt injection...  │
│                                         │
│ [Python] [NLP] [Red Team]              │
│                                         │
│ ── Agent_K  ·  1/4 operatives ──────── │
│                              [Connect]  │
└─────────────────────────────────────────┘
```

**Visual details:**
- Border: 1px solid `var(--color-text-dim)` with track-colored left border (4px).
- Track badge: colored pill matching track color system (RED/BLUE/CYAN/PURPLE).
- Team status indicator: green dot = looking, yellow = open, grey = full.
- Skills: styled like existing `.skill-tag` elements on protocol cards.
- Hover: subtle border glow in track color, slight translateY lift.
- Author line: monospace, muted, with operative count.

### 6.4 Filter Bar

Horizontal bar above the card grid:

```
[All Tracks ▾]  [All Skills ▾]  [Status: All ▾]  [🔍 Search...]  [+ Post]
```

- **Track filter:** dropdown — All / SHADOW / SENTINEL / ZERO / ROGUE
- **Skills filter:** multi-select dropdown — populated from available skills across submissions
- **Status filter:** All / Looking / Open / Full
- **Search:** text input, debounced 300ms, searches title + description
- **Post button:** primary green CTA, triggers auth flow if needed

Styling: dark background bar (`var(--color-bg-elevated)`), inputs with monospace font, neon-green focus states.

### 6.5 Submission Form

Modal overlay (consistent with how the existing "Challenge Database" button placeholder works):

```
┌──── POST CHALLENGE ────────────────────┐
│                                         │
│  TITLE                                  │
│  [________________________________]     │
│                                         │
│  DESCRIPTION                            │
│  [________________________________]     │
│  [________________________________]     │
│  [________________________________]     │
│                                         │
│  TRACK              TEAM STATUS         │
│  [SHADOW ▾]         [Looking ▾]         │
│                                         │
│  SKILLS (select up to 5)                │
│  [Python] [ML] [+Add]                  │
│                                         │
│  CONTACT METHOD     HANDLE              │
│  [Discord ▾]        [@agent_k]          │
│                                         │
│  [──── SUBMIT CHALLENGE ────]           │
│                                         │
└─────────────────────────────────────────┘
```

Modal styling: dark background with scanline overlay, neon-green border top, backdrop blur.

### 6.6 Auth Modal

Appears when unauthenticated user tries to post:

```
┌──── VERIFY OPERATIVE ──────────────────┐
│                                         │
│  Enter your registered email to post.   │
│  We'll send a magic link — no password. │
│                                         │
│  EMAIL                                  │
│  [________________________________]     │
│                                         │
│  [──── SEND MAGIC LINK ────]           │
│                                         │
│  Not registered? [Register here →]      │
│                                         │
└─────────────────────────────────────────┘
```

After sending: "Check your inbox. Click the link to verify."

### 6.7 Empty State

When no challenges have been posted yet:

```
┌─────────────────────────────────────────┐
│                                         │
│         NO CHALLENGES YET               │
│                                         │
│   Be the first operative to post.       │
│   Your idea could become the winning    │
│   project on March 14.                  │
│                                         │
│      [+ Post the First Challenge]       │
│                                         │
└─────────────────────────────────────────┘
```

### 6.8 Mobile Layout

- Filter bar stacks vertically or collapses into a "Filters" toggle button.
- Cards go single-column, full-width.
- Submission form becomes full-screen modal.
- Touch-friendly: all tap targets ≥ 44px.

---

## 7. Skills Taxonomy

Predefined skill tags (matches and extends existing skill tags on protocol cards):

**Technical:** Python, JavaScript, Rust, Go, C++, Solidity, SQL
**AI/ML:** Machine Learning, NLP, Computer Vision, LLMs, Reinforcement Learning, Fine-tuning
**Security:** Red Team, Blue Team, Cryptography, Reverse Engineering, Fuzzing, Pen Testing
**Domain:** Privacy, ZK Proofs, Smart Contracts, DevSecOps, Threat Modeling
**Other:** UI/UX, Hardware, Research, Writing

Users select from this list (no freeform entry in v1 to keep filtering clean).

---

## 8. Data Flow

```
                    ┌─────────────┐
                    │  Supabase   │
                    │  (Postgres) │
                    └──────┬──────┘
                           │ REST API
                           │ (auto-generated)
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   [Browse]           [Post/Edit]         [Auth]
   GET /challenges    POST /challenges    Magic Link
   (public, no auth)  (requires auth)     (email verify)
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────┴──────┐
                    │ challenges  │
                    │   .html     │
                    │ (JS client) │
                    └─────────────┘
```

---

## 9. Implementation Plan

### Phase 1: Supabase Setup
- Create Supabase project.
- Create `registered_participants` and `challenges` tables.
- Configure RLS policies.
- Enable email auth with magic links.
- Populate `registered_participants` from Luma export.

### Phase 2: Browse UI
- Add Challenge Database section to challenges.html.
- Build card grid with loading states.
- Implement filtering (track, skills, status).
- Implement search with debounce.
- Add pagination (load more button).
- Empty state.

### Phase 3: Auth Flow
- Add Supabase JS client.
- Build auth modal (email input → magic link).
- Handle redirect back with session.
- Show auth state in UI (logged in as X, logout).

### Phase 4: Submission Flow
- Build submission form modal.
- Client-side validation (matching schema constraints).
- Submit to Supabase.
- Optimistic UI update (card appears immediately).
- Success/error feedback.

### Phase 5: Edit/Delete
- Show edit/delete controls on own cards.
- Pre-filled edit form.
- Delete confirmation dialog.
- Optimistic updates.

### Phase 6: Polish
- GSAP animations on card entry (staggered reveal matching page style).
- Skeleton loading states.
- Responsive testing.
- Error handling and retry logic.
- Rate limiting (Supabase built-in or client-side throttle).

---

## 10. Edge Cases & Constraints

| Scenario | Handling |
|----------|----------|
| User posts but isn't registered | Supabase RLS rejects insert; UI shows "Email not found in registration list" |
| Magic link expires | Links expire after 1 hour (Supabase default). UI shows "Link expired, request a new one" |
| User tries to post >1 challenge | Allowed — no limit in v1, but monitor for spam |
| Very long description | Hard limit at 1000 chars (DB constraint + client validation) |
| Offensive content | Manual moderation via Supabase dashboard. Add "Report" button in v2 |
| Supabase outage | Graceful degradation — existing static content still renders, DB section shows "temporarily unavailable" |
| User deletes then regrets | No soft delete in v1. Could add `deleted_at` column later |

---

## 11. Success Metrics

- **Adoption:** ≥30% of registered participants post or browse challenges before March 14.
- **Team formation:** ≥10 teams form through the challenge database (self-reported or inferred from matching team names at event).
- **Page engagement:** Challenge Database section has >2min average time-on-section.

---

## 12. Open Questions

1. **Skill tag curation:** Should organizers be able to add/remove skill tags dynamically, or is the fixed list sufficient for v1?
2. **Challenge comments:** Should others be able to leave public comments on challenges (e.g., "I'm interested!")? Adds complexity but improves signal.
3. **Duplicate ideas:** What if multiple people post very similar challenges? Surface a "similar challenges" nudge during submission?
4. **Post-event:** Should the database persist after March 14, or archive/lock it?
5. **Contact privacy:** Show contact handle publicly to all visitors, or only to authenticated users?

---

## 13. Files Affected

| File | Changes |
|------|---------|
| `challenges.html` | New section, Supabase client, auth/submission/browse JS, new CSS |
| (new) `supabase-config.js` | Supabase URL + anon key (optional — could inline) |
| (new) `docs/supabase-setup.md` | Setup instructions for Supabase project + tables |

No other existing pages need changes. The challenge database is self-contained within challenges.html.
