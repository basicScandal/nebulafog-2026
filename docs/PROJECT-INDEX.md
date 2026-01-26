# NEBULA:FOG 2026 - Project Index

> AI x Security Hackathon Website | March 14, 2026 | San Francisco

---

## Quick Reference

| Item | Value |
|------|-------|
| **Type** | Static HTML/CSS/JS website |
| **Build** | None required - edit and deploy |
| **Server** | `python3 -m http.server 8000` |
| **Deploy** | GitHub Pages (main branch) |
| **Domain** | nebulafog.ai |
| **Remotes** | `origin` + `deploy` (both push to main) |

---

## Pages

| Page | Purpose | Key Features |
|------|---------|-----------------|
| [index.html](../index.html) | Homepage | Terminal interface, countdown, breach animation, testimonials |
| [about.html](../about.html) | Mission/Story | 3D effects, 2025 stats, photo gallery, video links |
| [challenges.html](../challenges.html) | Challenge tracks | 4 tracks, prize breakdown (auto-reveals 3/14/26) |
| [schedule.html](../schedule.html) | Event timeline | Animated schedule, logistics, phase cards |
| [register.html](../register.html) | Registration | Luma integration, countdown timer |
| [partners.html](../partners.html) | Sponsors | Partner grid, CTA section |
| [code-of-conduct.html](../code-of-conduct.html) | Policies | Community guidelines, collapsible sections |
| [404.html](../404.html) | Error page | Navigation back to home |

---

## Architecture

### File Structure

```
nebulafog-2026/
├── *.html                 # 8 pages (inline CSS/JS per page)
├── styles/
│   └── common.css         # Shared design system (334 lines)
├── images/
│   ├── 2025/hackathon/    # 26 event photos
│   ├── gallery/           # 8 gallery images
│   ├── demos/             # 4 demo screenshots
│   ├── og-image.png       # Open Graph image
│   └── og-image-new.svg   # OG image source
├── content/               # 11 markdown reference files
├── docs/                  # Planning & documentation
│   ├── PROJECT-INDEX.md   # This file
│   ├── prize-structure-2026.md
│   ├── ux-analysis-customer-journey.md
│   └── planning/          # Strategy docs
├── CLAUDE.md              # AI assistant instructions
├── README.md              # Project overview
├── favicon.svg            # Site favicon
├── sitemap.xml            # SEO sitemap
├── robots.txt             # Crawler directives
└── CNAME                  # GitHub Pages domain (nebulafog.ai)
```

### Design System

```css
/* Colors */
--color-bg: #030303           /* Dark background */
--color-bg-elevated: #0a0a0a  /* Elevated surfaces */
--color-primary: #00ff9f      /* Neon green */
--color-secondary: #ff0080    /* Neon pink */
--color-accent: #0ff          /* Cyan */
--color-warning: #ff3d00      /* Orange alerts */
--color-text: #ffffff
--color-text-muted: #666666
--color-text-dim: #333333

/* Track Colors */
SHADOW::VECTOR  → #ff4444 (red)
SENTINEL::MESH  → #4488ff (blue)
ZERO::PROOF     → #0ff (cyan)
ROGUE::AGENT    → #aa44ff (purple)

/* Typography */
--font-mono: 'JetBrains Mono'
--font-display: 'Space Grotesk'

/* Breakpoint */
Mobile: 768px
```

### Libraries (CDN)

| Library | Version | Usage |
|---------|---------|-------|
| GSAP | 3.12.5 | Animations, ScrollTrigger |
| Three.js | r162 | 3D challenge matrix |
| Anime.js | 3.2.2 | Story animations |
| Font Awesome | 6.5.1 | Icons |
| Plausible | - | Privacy-friendly analytics |

---

## Features

### Interactive Elements

- **Terminal** (index.html) - Commands: `help`, `mission`, `challenges`, `schedule`, `register`, `partners`, `status`, `clear`
- **Countdown Timer** - Live countdown to March 14, 2026
- **Breach Animation** - Boot sequence on homepage load
- **Custom Cursor** - Neon dot + ring (desktop only)
- **Particle System** - WebGL canvas (desktop only)
- **Testimonial Carousel** - Swipeable cards with dot navigation

### Hidden/Timed Content

| Content | Location | Trigger |
|---------|----------|---------|
| Prize Breakdown | challenges.html | Auto-reveals March 14, 2026 via JS date check |
| Sponsor Logos | partners.html | Reveals when `SPONSORS` object has entries |
| Sponsor Challenges | challenges.html | Reveals when `SPONSOR_CHALLENGES` array has entries |
| Judges/Speakers | schedule.html | Reveals when `JUDGES` array has entries |
| Venue Details | schedule.html | Reveals when `VENUE` object has data |

**To populate hidden sections:** Edit the data arrays/objects at the top of each page's `<script>` section.

### Accessibility

- Skip navigation links
- ARIA labels on interactive elements
- `prefers-reduced-motion` support
- Focus states on all interactive elements
- 44px minimum touch targets (WCAG AAA)
- Language improvements for screen readers

### SEO

- JSON-LD Event schema (homepage)
- Open Graph meta tags (all pages)
- Twitter card tags
- sitemap.xml + robots.txt
- Plausible analytics (privacy-friendly)

---

## Content Updates

### Update 2025 Stats
- **about.html** - Trust bar ("120+ builders")
- **about.html** - Origin stats section

### Update Event Details
- **index.html** - Countdown target date
- **schedule.html** - Timeline items
- **register.html** - Luma embed link

### Add Sponsors
- **partners.html** - Add logo images and links

### Prize Structure
- **docs/prize-structure-2026.md** - Planning document
- **challenges.html** - Hidden section (`display:none` until 3/14)

### Video Links
- **about.html** - "24+ projects shipped" links to YouTube (@NEBULAFOG)

---

## Development

### Local Server
```bash
python3 -m http.server 8000
# or
npx serve .
```

### Git Workflow
```bash
# Feature branch
git checkout -b feature/name

# Commit
git add . && git commit -m "message"

# Push & deploy (both remotes)
git push origin main && git push deploy main
```

### Testing
- Desktop: Chrome DevTools
- Mobile: DevTools device emulation (375px)
- Screenshots: `.playwright-mcp/` directory

---

## Planning Documents

| Document | Purpose |
|----------|---------|
| [prize-structure-2026.md](prize-structure-2026.md) | Prize distribution ($5,000+ pool) |
| [ux-analysis-customer-journey.md](ux-analysis-customer-journey.md) | User journey mapping |
| [planning/storytelling-improvement-plan.md](planning/storytelling-improvement-plan.md) | Content strategy |
| [planning/luma-registration-copy.md](planning/luma-registration-copy.md) | Registration copy |
| [planning/website-faq-content.md](planning/website-faq-content.md) | FAQ content |

---

## Recent Changes (Jan 2026)

### Latest Session
- Added hidden sections for data-dependent content:
  - Sponsor logos (partners.html)
  - Sponsor challenges (challenges.html)
  - Judges/speakers (schedule.html)
  - Venue details (schedule.html)
- Added project index documentation
- Removed hardcoded registration numbers
- Cleaned up "24+ projects shipped" quote styling
- Made video links more apparent with play icons
- Made "What You'll Leave With" 2x2 grid
- Added hidden prize breakdown (auto-reveals 3/14/26)
- Added prize structure planning document

### Earlier in January
- Comprehensive QA fixes (a11y, SEO, content)
- Fixed 2025 stats (120 builders, no cash prizes)
- Updated Code of Conduct layout
- Changed Evaluation Protocol to 2x2 grid
- Removed View Tracks button from homepage
- Added language improvements for accessibility
- Integrated Luma for registration
- Reordered hero CTAs

---

## Commit History (Recent)

```
e36a957 Add hidden sections that reveal when data is available
f38df2b Update project index with accurate counts and recent commits
93d137a Add project index documentation
98baef4 Remove hardcoded registration numbers
722c4ee Clean up '24+ projects shipped' quote styling
5ade351 Make '24 projects shipped' links more apparent
0b2ba57 Make 'What You'll Leave With' section 2x2 grid
b3167fa Add hidden prize breakdown section (reveals 3/14/26)
2cb5bdb Add prize structure planning document for 2026
85c3249 Comprehensive QA fixes across content, code, a11y, SEO
3e70b10 Fix 2025 stats: 120 builders, no cash prizes
be7431b Update Code of Conduct layout and remove from nav
```

---

*Last updated: January 26, 2026*
