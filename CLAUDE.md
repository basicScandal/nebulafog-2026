# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **📋 Quick Reference:** For comprehensive project documentation, see [PROJECT_INDEX.md](PROJECT_INDEX.md) (14KB, 69% more token-efficient than reading multiple docs)

## Project Overview

NEBULA:FOG:PRIME 2026 is a static hackathon website with an immersive cyberpunk aesthetic. It combines AI x Security themes with advanced interactive features including particle systems, 3D graphics, and an interactive terminal interface.

**Event:** AI x Security Hackathon
**Date:** March 14, 2026
**Theme:** Cyberpunk / Hacker Aesthetic

## Development

This is a static HTML/CSS/JS site with no build system. Development is done by directly editing the source files.

**Local Development:**
```bash
# Serve files locally (any static server works)
python3 -m http.server 8000
# or
npx serve .
```

**No package manager is used** - all libraries are loaded via CDN.

**Deployment:**
- `origin` and `deploy` remotes both point to github.com/basicScandal/nebulafog-2026
- GitHub Pages serves from the main branch
- Always use PRs to merge changes to main
- Push to both remotes after merge: `git push origin main && git push deploy main`

## File Structure

```
nebulafog-web/
├── index.html           # Homepage (3400+ lines) - Main entry point
├── about.html           # Mission/story page with anime.js-inspired storytelling
├── challenges.html      # Challenge tracks with 3D matrix (Three.js)
├── schedule.html        # Event timeline with GSAP animations
├── register.html        # Registration form with validation
├── partners.html        # Sponsors/partners page
├── code-of-conduct.html # Code of conduct
├── content/             # Markdown content files (reference only)
├── images/              # Image assets
├── docs/planning/       # Planning documents
└── .playwright-mcp/     # Playwright test screenshots
```

## Architecture

### Page Overview

| Page | Key Features | Libraries |
|------|--------------|-----------|
| `index.html` | Hero, Mission Debrief, Protocol Cards, Testimonials, Terminal | GSAP, ScrollTrigger |
| `about.html` | Animated story sections, builder stats, track overview | GSAP, Anime.js |
| `challenges.html` | 3D challenge matrix, skill tags | Three.js, GSAP |
| `schedule.html` | Animated timeline, phase cards | GSAP, ScrollTrigger |
| `register.html` | Form validation, animated inputs | GSAP |
| `partners.html` | Partner grid, CTA section | GSAP |
| `code-of-conduct.html` | Numbered sections, collapsible content | GSAP |

### Homepage Sections (index.html)

The homepage follows a narrative flow:

1. **Hero Section** (`#hero`)
   - Animated title with character-by-character reveal
   - Live stats: Trust Index, Days Countdown, Operatives Count
   - CTA buttons: Register, Watch Highlights

2. **Mission Debrief** (`#mission-debrief`)
   - 2025 retrospective stats (120 hackers, 4 tracks, 24 projects, 8 hours)
   - Animated counter on scroll
   - Video embed placeholder
   - 3 winning project showcases

3. **Protocol Cards** (`#protocols`)
   - 4 challenge tracks: SHADOW, SENTINEL, ZERO, ROGUE
   - Decrypt animation on scroll
   - Color-coded by classification

4. **Testimonials** (`#testimonials`)
   - Horizontal carousel with 4 testimonial cards
   - Dot navigation
   - Mobile swipeable

5. **Command Terminal** (`#command-section`)
   - Interactive terminal with commands: help, mission, challenges, schedule, register, partners, status, clear
   - Command history (arrow keys)
   - Suggestions on partial input

### Core JavaScript (`index.html` - CyberpunkInterface class)

The `CyberpunkInterface` class handles all interactive features:

```javascript
class CyberpunkInterface {
  // Initialization
  initCursor()              // Custom cursor with trail effect
  initParticles()           // WebGL/2D canvas particle system
  initHeroAnimations()      // GSAP hero reveal animations
  initScrollAnimations()    // ScrollTrigger-based animations
  initCommandLine()         // Terminal command processing
  initTestimonialCarousel() // Carousel dot navigation

  // Animations
  animateDebriefStats()     // Count-up animation for stats

  // Utilities
  initInactivityDetection() // Idle state detection
  initIntrusionDetection()  // Console tampering detection
  initEasterEggs()          // Konami code, etc.
  initSoundToggle()         // Sound on/off toggle
  initMobileEnhancements()  // Touch-specific handlers
  initVisibilityHandler()   // Pause when tab hidden
}
```

### CDN Libraries

| Library | Version | Usage |
|---------|---------|-------|
| GSAP | 3.12.5 | Core animations, ScrollTrigger |
| Three.js | r162 | 3D challenge matrix (challenges.html) |
| Anime.js | 3.2.2 | Story animations (about.html) |
| Font Awesome | 6.5.1 | Icons |
| Google Fonts | - | JetBrains Mono, Space Grotesk |

### Design System

CSS custom properties define the cyberpunk theme (consistent across all pages):

```css
:root {
  /* Colors */
  --color-bg: #030303;
  --color-bg-elevated: #0a0a0a;
  --color-primary: #00ff9f;      /* Neon green - main accent */
  --color-secondary: #ff0080;    /* Neon pink - secondary accent */
  --color-accent: #0ff;          /* Cyan - tertiary accent */
  --color-warning: #ff3d00;      /* Orange - alerts */
  --color-text: #ffffff;
  --color-text-muted: #666666;
  --color-text-dim: #333333;

  /* Typography */
  --font-mono: 'JetBrains Mono', 'SF Mono', 'Consolas', monospace;
  --font-display: 'Space Grotesk', system-ui, sans-serif;

  /* Animation */
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-out-back: cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

### Track Color Coding

| Track | Classification | Color |
|-------|---------------|-------|
| SHADOW::VECTOR | RED | `#ff4444` |
| SENTINEL::MESH | BLUE | `#4488ff` |
| ZERO::PROOF | CIPHER | `#0ff` (cyan) |
| ROGUE::AGENT | UNBOUND | `#aa44ff` |

## Key Implementation Notes

### Inline Styles
All CSS is embedded in `<style>` tags within each HTML file - there are no external CSS files. When modifying styles, edit the `<style>` section in the relevant HTML file.

### Mobile Responsiveness
- Breakpoint: `768px`
- Desktop: HUD-style navigation, custom cursor
- Mobile: Bottom tab navigation, native cursor, particles disabled
- Touch: Swipe gestures for carousels, tap to decrypt cards

### Accessibility
- Skip links for keyboard navigation
- ARIA labels on interactive elements
- `prefers-reduced-motion` media query support
- Focus states on all interactive elements
- Semantic HTML structure

### Performance Optimizations
- `defer` attribute on GSAP scripts
- Page Visibility API to pause animations when hidden
- Particle system disabled on mobile
- DNS prefetch for CDN resources
- Font preconnect hints

### Sound System
- Toggle button in bottom-right corner
- Sound effects: hover, click, decrypt, terminal typing
- Muted by default, user opt-in

### Terminal Commands

| Command | Action |
|---------|--------|
| `help` | Show available commands |
| `mission` | Navigate to about.html |
| `challenges` | Show challenge tracks |
| `schedule` | Navigate to schedule.html |
| `register` | Navigate to register.html |
| `partners` | Navigate to partners.html |
| `status` | Show system status |
| `clear` | Clear terminal output |

## Content Updates

### Updating Stats
Hero stats are in `index.html` around line 1665:
```html
<span class="hero-stat-value" id="trust-index" data-value="73.4">0</span>
<span class="hero-stat-value" id="days-countdown" data-value="0">0</span>
```

### Updating Testimonials
Testimonial cards are in `index.html` around line 1830-1875. Each card follows this structure:
```html
<div class="testimonial-card">
  <p class="testimonial-quote">Quote text here</p>
  <div class="testimonial-author">
    <div class="testimonial-avatar">XX</div>
    <div class="testimonial-info">
      <span class="testimonial-name">Name</span>
      <span class="testimonial-role">Role</span>
    </div>
  </div>
</div>
```

### Updating Project Showcases
Project cards in Mission Debrief are around line 1730-1755:
```html
<article class="project-card">
  <span class="project-track" data-track="SHADOW">SHADOW::VECTOR</span>
  <h3 class="project-name">Project Name</h3>
  <p class="project-desc">Description</p>
  <p class="project-team">Team: Names</p>
  <p class="project-quote">"Quote"</p>
</article>
```

## Common Tasks

### Adding a New Page
1. Copy an existing page as template (e.g., `partners.html`)
2. Update `<title>` and meta tags
3. Keep the same nav structure (HUD nav + mobile nav)
4. Keep the same footer
5. Add page-specific styles in `<style>` section
6. Add to navigation in all pages

### Modifying Animations
- GSAP animations are in the `<script>` section at the bottom of each page
- Use `ScrollTrigger` for scroll-based animations
- Respect `prefers-reduced-motion` media query

### Testing Mobile
```bash
# Start server
python3 -m http.server 8000

# Test with Playwright (375px viewport)
# Or use browser DevTools device emulation
```

## Git Workflow

1. Create feature branch: `git checkout -b feature/name`
2. Make changes
3. Commit with descriptive message
4. Push: `git push -u origin feature/name`
5. Create PR via `gh pr create`
6. After merge: `git checkout main && git pull && git push deploy main`

## Troubleshooting

### Animations not working
- Check if GSAP is loaded (browser console)
- Check ScrollTrigger registration: `gsap.registerPlugin(ScrollTrigger)`
- Verify element exists before animation

### Mobile nav not showing
- Check `@media (max-width: 768px)` styles
- Verify `.mobile-nav` display property

### Terminal not responding
- Check for JavaScript errors in console
- Verify `CyberpunkInterface` class initialization
