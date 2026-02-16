# Challenge Database

## Problem
Participants can't share project ideas or find teammates before the hackathon. They waste time forming teams on event day.

## Goals
- Registered participants post challenge ideas (title, description, track, skills, contact info, team status)
- Anyone can browse/filter/search challenges without auth
- Lightweight team matching: each post includes Discord/email for off-site contact

## Non-Goals
No on-site messaging, no voting, no user profiles, no admin dashboard (v1)

## Access
- Anonymous: browse only
- Registered participant (magic link auth): browse + post + edit/delete own
- Organizer: moderate via backend

## Requirements
Browse: card grid on challenges.html (below tracks), filter by track/skills/team status, keyword search, pagination, empty state
Post: auth-gated form — title (5-100ch), description (20-1000ch), track (SHADOW/SENTINEL/ZERO/ROGUE), skills (1-5 from preset list), contact method (discord/email) + handle, team status (looking/open/full), team size (1-4)
Edit/Delete: own challenges only, confirmation on delete
Connect: copy contact handle to clipboard or open mailto/discord link
Auth: passwordless magic link, registration-linked emails only, persistent sessions

## UI
- New section in existing challenges.html, not a separate page
- Cyberpunk design system: track-colored borders, monospace, neon accents
- Filter bar above card grid
- Submission + auth as modal overlays
- Mobile: single-column cards, collapsed filters, full-screen modals, 44px touch targets
- GSAP animations matching page style
- Loading/error/empty states

## Edge Cases
Unregistered email → reject with register link. Backend down → static content still works, DB section shows unavailable. No delete undo in v1. Manual moderation for spam.

## Open Questions
1. Contact handles public or auth-gated?
2. Allow 'interested' replies on challenges?
3. Similar challenge detection on post?
4. Archive/lock after March 14?

## Files
challenges.html (new section + JS), Supabase backend (Postgres + auth + RLS)
