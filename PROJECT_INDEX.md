# NEBULA:FOG 2026 - Project Index

**AI x Security Hackathon Website**
**Generated:** 2026-01-28
**Domain:** [nebulafog.ai](https://nebulafog.ai)
**Event Date:** March 14, 2026

---

## 🎯 Quick Reference

| Property | Value |
|----------|-------|
| **Type** | Static HTML/CSS/JS website (no build system) |
| **Pages** | 8 HTML pages + 404 |
| **Lines of Code** | ~10,160 lines (HTML) |
| **Assets** | 41 images (13MB), 1 CSS file |
| **Deployment** | GitHub Pages (main branch) |
| **Domain** | nebulafog.ai (CNAME configured) |
| **Analytics** | Plausible (privacy-friendly) |
| **Local Server** | `python3 -m http.server 8000` |

---

## 📁 Repository Structure

```
nebulafog-2026/
├── 📄 HTML Pages (8 main + 1 error)
│   ├── index.html              # Homepage with terminal interface
│   ├── about.html              # Mission/story with photo gallery
│   ├── challenges.html         # 4 challenge tracks + 3D matrix
│   ├── schedule.html           # Event timeline with animations
│   ├── register.html           # Registration (Luma integration)
│   ├── partners.html           # Sponsors/partners CTA
│   ├── code-of-conduct.html    # Community guidelines
│   └── 404.html                # Error page
│
├── 🎨 Assets
│   ├── images/
│   │   ├── 2025/hackathon/     # 26 event photos (2025)
│   │   ├── gallery/            # 8 gallery images
│   │   ├── demos/              # 4 demo screenshots
│   │   ├── og-image.png        # Open Graph image
│   │   └── og-image-new.svg    # OG source file
│   ├── styles/common.css       # Shared design system (334 lines)
│   └── favicon.svg             # Site favicon
│
├── 📝 Content (Reference)
│   └── content/                # 11 markdown files (not rendered)
│       ├── about.md
│       ├── challenges.md
│       ├── home.md
│       ├── schedule.md
│       └── ... (7 more)
│
├── 📚 Documentation
│   ├── docs/
│   │   ├── PROJECT-INDEX.md    # (Old index - this replaces it)
│   │   ├── prize-structure-2026.md
│   │   ├── ux-analysis-customer-journey.md
│   │   └── planning/           # Strategy docs (4 files)
│   ├── CLAUDE.md               # AI assistant instructions
│   └── README.md               # Project overview
│
└── ⚙️ Configuration
    ├── CNAME                   # GitHub Pages domain (nebulafog.ai)
    ├── sitemap.xml             # SEO sitemap
    └── robots.txt              # Crawler directives
```

---

## 🚀 Entry Points

### Primary Pages

| Page | Purpose | Key Features | Lines |
|------|---------|--------------|-------|
| **index.html** | Homepage | Terminal, countdown, testimonials, breach animation | 3,400+ |
| **about.html** | Mission/Story | Photo gallery, 2025 stats, track overview, video links | 4,300+ |
| **challenges.html** | Challenge Tracks | 4 tracks, 3D matrix (Three.js), prize structure (hidden) | 2,100+ |
| **schedule.html** | Event Timeline | Animated schedule, logistics, after-party info | 1,500+ |
| **register.html** | Registration | Countdown timer, Luma integration, FAQ | 1,400+ |
| **partners.html** | Sponsors | Partner grid, partnership CTA | 1,000+ |
| **code-of-conduct.html** | Guidelines | Community standards, reporting contact | 1,100+ |
| **404.html** | Error Page | Navigation back to home | 270 |

### Navigation Flow
```
index.html (hero) → register.html (CTA)
                  → about.html (learn more)
                  → challenges.html (view tracks)
                  → schedule.html (event details)
                  → partners.html (sponsorship)
```

---

## 🎨 Design System

### Color Palette (CSS Custom Properties)

```css
/* Core Colors */
--color-bg: #030303              /* Near-black background */
--color-bg-elevated: #0a0a0a     /* Elevated surfaces */
--color-primary: #00ff9f         /* Neon green (main accent) */
--color-secondary: #ff0080       /* Neon pink (secondary) */
--color-accent: #0ff             /* Cyan (tertiary) */
--color-warning: #ff3d00         /* Orange (alerts) */

/* Text Colors */
--color-text: #ffffff
--color-text-muted: #666666
--color-text-dim: #333333

/* Track Colors */
SHADOW::VECTOR  → #ff4444 (red)
SENTINEL::MESH  → #4488ff (blue)
ZERO::PROOF     → #0ff (cyan)
ROGUE::AGENT    → #aa44ff (purple)
```

### Typography

```css
--font-mono: 'JetBrains Mono', 'SF Mono', 'Consolas', monospace
--font-display: 'Space Grotesk', system-ui, sans-serif
```

### Animation Easings

```css
--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1)
--ease-out-back: cubic-bezier(0.34, 1.56, 0.64, 1)
```

### Responsive Breakpoint
- **Mobile:** ≤ 768px
- **Desktop:** > 768px

---

## 🔧 Interactive Features

### CyberpunkInterface Class (index.html)

Core JavaScript class handling all interactions:

```javascript
class CyberpunkInterface {
  // Visual Effects
  initCursor()              // Custom cursor with trail (desktop only)
  initParticles()           // WebGL/2D canvas particles (desktop only)

  // Animations
  initHeroAnimations()      // GSAP hero reveal with character typing
  initScrollAnimations()    // ScrollTrigger-based scroll animations
  animateDebriefStats()     // Count-up animation for stats

  // Interactions
  initCommandLine()         // Terminal command processing
  initTestimonialCarousel() // Horizontal carousel with dot nav

  // Utilities
  initInactivityDetection() // Idle state detection
  initIntrusionDetection()  // Console tampering alerts
  initEasterEggs()          // Konami code & hidden features
  initSoundToggle()         // Sound effects on/off
  initMobileEnhancements()  // Touch gestures
  initVisibilityHandler()   // Pause animations when tab hidden
}
```

### Terminal Commands (index.html)

Interactive command-line interface with history:

| Command | Action |
|---------|--------|
| `help` | Show available commands |
| `mission` | Navigate to about.html |
| `challenges` | Show challenge tracks info |
| `schedule` | Navigate to schedule.html |
| `register` | Navigate to register.html |
| `partners` | Navigate to partners.html |
| `status` | Show system status |
| `clear` | Clear terminal output |

**Features:**
- Arrow key history navigation
- Auto-suggestions on partial input
- Command aliases

### Countdown Timers

1. **Registration Countdown** (register.html)
   - Target: March 4, 2026 23:59:59 PST
   - Format: DD:HH:MM:SS
   - Updates every second

2. **Event Countdown** (index.html hero)
   - Target: March 14, 2026
   - Live days remaining

### Hidden/Timed Content

Content that auto-reveals based on date or data:

| Content | Location | Trigger |
|---------|----------|---------|
| Prize Breakdown | challenges.html | Auto-reveals March 14, 2026 |
| Sponsor Logos | partners.html | Reveals when `SPONSORS` array populated |
| Sponsor Challenges | challenges.html | Reveals when `SPONSOR_CHALLENGES` has entries |
| Judges/Speakers | schedule.html | Reveals when `JUDGES` array has data |
| Venue Details | schedule.html | Reveals when `VENUE` object has location |

---

## 📦 Dependencies (CDN)

All libraries loaded via CDN - no package manager:

| Library | Version | Usage | Pages |
|---------|---------|-------|-------|
| **GSAP** | 3.12.5 | Core animations, ScrollTrigger | All pages |
| **Three.js** | r162 | 3D challenge matrix | challenges.html |
| **Anime.js** | 3.2.2 | Story section animations | about.html |
| **Font Awesome** | 6.5.1 | Icons | All pages |
| **Google Fonts** | - | JetBrains Mono, Space Grotesk | All pages |
| **Plausible** | latest | Privacy-friendly analytics | All pages |

---

## 🎯 Key Sections by Page

### index.html
1. **Hero Section** - Animated title, live stats, CTA buttons
2. **Mission Debrief** - 2025 retrospective (120 hackers, 24 projects)
3. **Protocol Cards** - 4 challenge tracks with decrypt animation
4. **Testimonials** - Horizontal carousel (4 cards)
5. **Command Terminal** - Interactive CLI interface

### about.html
1. **Hero** - AI × Security collision point
2. **Mission Statement** - Builders & breakers only
3. **2025 Proof** - Photo gallery (26 images), video links
4. **Track Overview** - 4 challenge tracks explained
5. **FAQ** - First-time hackathon participant guide

### challenges.html
1. **3D Matrix** - Three.js rotating challenge grid
2. **4 Challenge Tracks** - Detailed descriptions
3. **Prize Structure** - Hidden until March 14, 2026
4. **Evaluation Criteria** - 2×2 grid of judging factors

### schedule.html
1. **Event Timeline** - 13 time blocks (8:30am - 8:00pm)
2. **Logistics** - Gear checklist, fuel provided, infrastructure
3. **After-Party Section** - RSVP link, DJ info

### register.html
1. **Registration Countdown** - 10 days before event (March 4)
2. **Luma Integration** - External registration link
3. **Benefits List** - What registration grants
4. **FAQ** - 9 common questions answered

---

## 📧 Contact Information

All emails consolidated to: **admin@nebulafog.ai**

| Context | Usage |
|---------|-------|
| General questions | about.html |
| Code of conduct reports | code-of-conduct.html |
| Partnership inquiries | partners.html |

---

## 🔗 External Links

| Link | Purpose | Location |
|------|---------|----------|
| `https://dub.sh/nf-register` | Luma registration | register.html |
| `https://dub.sh/nf-afterparty` | After-party RSVP | schedule.html, register.html |
| `https://www.youtube.com/@NEBULAFOG` | 2025 demo videos | about.html |
| `https://synthetix.bandcamp.com/album/ominous-data` | DJ music link | schedule.html |

---

## 🚀 Development Workflow

### Local Development

```bash
# Start local server
python3 -m http.server 8000
# or
npx serve .

# View site
open http://localhost:8000
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/name

# Make changes, commit
git add .
git commit -m "Descriptive message"

# Push to origin
git push -u origin feature/name

# Create PR
gh pr create

# After merge, deploy
git checkout main && git pull
git push deploy main  # Triggers GitHub Pages rebuild
```

### Remotes Configuration

```bash
origin  → github.com/basicScandal/nebulafog-2026 (fetch + push)
deploy  → github.com/basicScandal/nebulafog-2026 (push only)
```

**Note:** Both remotes point to same repository. Push to `deploy` triggers GitHub Pages rebuild.

---

## 🧪 Testing

### Manual Testing Checklist

- [ ] Desktop: Chrome DevTools (1920×1080)
- [ ] Mobile: DevTools device emulation (375×667)
- [ ] Animations: Check scroll-triggered reveals
- [ ] Terminal: Test all 8 commands
- [ ] Countdown: Verify March 4, 2026 target
- [ ] Links: Verify all dub.sh and external links
- [ ] Forms: Test Luma registration redirect

### Screenshots

Playwright screenshots saved to: `.playwright-mcp/`

---

## ♿ Accessibility Features

- ✅ Skip navigation links
- ✅ ARIA labels on interactive elements
- ✅ `prefers-reduced-motion` support
- ✅ Focus states on all interactive elements
- ✅ 44px minimum touch targets (WCAG AAA)
- ✅ Semantic HTML structure
- ✅ Language improvements for screen readers

---

## 🔍 SEO Implementation

- ✅ JSON-LD Event schema (homepage)
- ✅ Open Graph meta tags (all pages)
- ✅ Twitter card tags (all pages)
- ✅ `sitemap.xml`
- ✅ `robots.txt`
- ✅ Descriptive meta descriptions
- ✅ Plausible analytics (privacy-friendly, no cookies)

---

## 📝 Content Management

### Update 2025 Stats
- **Location:** about.html
- **Elements:** Trust bar ("120+ builders"), origin stats section

### Update Event Details
- **index.html:** Countdown target date (hero section)
- **schedule.html:** Timeline items (13 time blocks)
- **register.html:** Luma embed link

### Add Sponsors
- **partners.html:** Edit `SPONSORS` array in `<script>`
- **Auto-reveals:** Logo grid when array has entries

### Prize Structure
- **Planning:** docs/prize-structure-2026.md
- **Implementation:** challenges.html (hidden section, reveals 3/14/26)

---

## 📋 Recent Changes

### Latest Update (Jan 28, 2026)
- ✅ Registration countdown moved to March 4 (10 days before event)
- ✅ After-party RSVP links added across site
- ✅ All emails consolidated to admin@nebulafog.ai

### Previous Updates (Jan 2026)
- Hidden sections for data-dependent content
- Project index documentation
- Removed hardcoded registration numbers
- Fixed 2025 stats (120 builders, no cash prizes)
- Comprehensive QA fixes (a11y, SEO, content)
- Integrated Luma for registration
- Performance improvements (particles CLS fix, LCP optimization)

---

## 🎛️ Configuration Files

| File | Purpose |
|------|---------|
| `CNAME` | GitHub Pages custom domain (nebulafog.ai) |
| `sitemap.xml` | SEO sitemap for search engines |
| `robots.txt` | Crawler directives (allow all) |
| `CLAUDE.md` | AI assistant instructions (9.6KB) |
| `.gitignore` | Git ignore rules |

---

## 📊 Token Efficiency

**This index replaces:**
- CLAUDE.md (9,666 bytes)
- docs/PROJECT-INDEX.md (10,540 bytes)
- Multiple file reads per session

**Estimated savings:**
- **Before:** ~8,000 tokens per session (reading multiple docs)
- **After:** ~2,500 tokens (this index only)
- **Savings:** 69% reduction per session

---

## 🔗 Quick Links

- **Live Site:** https://nebulafog.ai
- **Repository:** github.com/basicScandal/nebulafog-2026
- **YouTube:** @NEBULAFOG (2025 demos)
- **Registration:** dub.sh/nf-register
- **After Party:** dub.sh/nf-afterparty

---

## 🎯 Core Functionality Summary

**Static Site:**
- No build system required
- Direct HTML/CSS/JS editing
- CDN-loaded dependencies

**Interactive Features:**
- Custom cursor with trail effect
- WebGL particle system (desktop)
- Terminal command interface
- Testimonial carousel
- Multiple countdown timers
- Scroll-triggered animations (GSAP)
- 3D challenge matrix (Three.js)

**Content Strategy:**
- Cyberpunk/hacker aesthetic
- Mission-driven narrative
- 2025 proof of concept
- Clear call-to-action flow

**Deployment:**
- GitHub Pages (main branch)
- Custom domain (nebulafog.ai)
- Automatic rebuild on push

---

**Last Updated:** 2026-01-28
**Index Version:** 2.0 (replaces docs/PROJECT-INDEX.md)
