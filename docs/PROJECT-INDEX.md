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

---

## Pages

| Page | Purpose | Key Features |
|------|---------|--------------|
| [index.html](../index.html) | Homepage | Terminal interface, countdown, breach animation |
| [about.html](../about.html) | Mission/Story | 3D effects, 2025 stats, photo gallery |
| [challenges.html](../challenges.html) | Challenge tracks | 4 tracks, prize breakdown (hidden until 3/14) |
| [schedule.html](../schedule.html) | Event timeline | Animated schedule, logistics |
| [register.html](../register.html) | Registration | Luma integration, countdown |
| [partners.html](../partners.html) | Sponsors | Partner CTA |
| [code-of-conduct.html](../code-of-conduct.html) | Policies | Community guidelines |
| [404.html](../404.html) | Error page | Navigation back |

---

## Architecture

### File Structure

```
nebulafog-2026/
├── *.html                 # 8 pages (inline CSS/JS)
├── styles/
│   └── common.css         # Shared design system (335 lines)
├── images/
│   ├── 2025/hackathon/    # 24 event photos
│   ├── gallery/           # Gallery images
│   └── demos/             # Demo screenshots
├── content/               # Markdown reference files
├── docs/                  # Planning & documentation
├── CLAUDE.md              # AI assistant instructions
├── README.md              # Project overview
├── sitemap.xml            # SEO sitemap
├── robots.txt             # Crawler directives
└── CNAME                  # GitHub Pages domain
```

### Design System

```css
/* Colors */
--color-bg: #030303           /* Dark background */
--color-primary: #00ff9f      /* Neon green */
--color-secondary: #ff0080    /* Neon pink */
--color-accent: #0ff          /* Cyan */

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
| GSAP | 3.12.5 | Animations |
| ScrollTrigger | 3.12.5 | Scroll effects |
| Three.js | r128 | 3D effects |
| Font Awesome | 6.5.1 | Icons |
| Plausible | - | Analytics |

---

## Features

### Interactive Elements

- **Terminal** (index.html) - Commands: `help`, `mission`, `challenges`, `schedule`, `register`, `partners`, `status`, `clear`
- **Countdown Timer** - Live countdown to March 14, 2026
- **Breach Animation** - Boot sequence on homepage load
- **Custom Cursor** - Neon dot + ring (desktop only)
- **Particle System** - WebGL canvas (desktop only)

### Hidden/Timed Content

| Content | Location | Trigger |
|---------|----------|---------|
| Prize Breakdown | challenges.html | Auto-reveals March 14, 2026 |

### Accessibility

- Skip navigation links
- ARIA labels on interactive elements
- `prefers-reduced-motion` support
- Focus states on all interactive elements
- 44px minimum touch targets (WCAG AAA)

### SEO

- JSON-LD Event schema (homepage)
- Open Graph meta tags (all pages)
- Twitter card tags
- sitemap.xml + robots.txt

---

## Content Updates

### Update 2025 Stats
- **about.html:1087** - Trust bar ("120+ builders")
- **about.html:1198** - Origin stats (120 Operatives)

### Update Event Details
- **index.html** - Countdown target date
- **schedule.html** - Timeline items
- **register.html** - Luma link

### Add Sponsors
- **partners.html** - Add logo images and links

### Prize Structure
- **docs/prize-structure-2026.md** - Planning document
- **challenges.html:542** - Hidden section (display:none until 3/14)

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

# Push & deploy
git push origin main
git push deploy main
```

### Testing
- Desktop: Chrome DevTools
- Mobile: DevTools device emulation (375px)
- Screenshots: `.playwright-mcp/` directory

---

## Planning Documents

| Document | Purpose |
|----------|---------|
| [prize-structure-2026.md](prize-structure-2026.md) | Prize distribution plan |
| [planning/storytelling-improvement-plan.md](planning/storytelling-improvement-plan.md) | Content strategy |
| [ux-analysis-customer-journey.md](ux-analysis-customer-journey.md) | User journey mapping |

---

## Recent Changes (Jan 2026)

- Cleaned up "24+ projects shipped" link styling
- Added hidden prize breakdown (reveals 3/14/26)
- Made all 4-item sections 2x2 grids
- Removed hardcoded registration numbers
- Fixed 2025 stats (120 builders, no cash prizes)
- Comprehensive QA fixes (a11y, SEO, content)

---

*Last updated: January 26, 2026*
