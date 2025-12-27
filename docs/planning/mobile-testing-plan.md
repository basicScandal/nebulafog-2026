# Mobile Testing Plan
## NEBULA:FOG:PROTOCOL 2026

**Last Updated:** 2025-12-27
**Status:** Ready for Testing
**Branch:** claude/plan-mobile-testing-cjV33

---

## Executive Summary

This document outlines a comprehensive testing strategy for validating the mobile experience of the NEBULA:FOG:PROTOCOL 2026 hackathon website. The site uses a dual navigation system (desktop HUD + mobile nav), extensive GSAP animations, and mobile-first responsive design with a 768px breakpoint.

**Critical Issues Identified for Testing:**
1. Navigation position inconsistency (top on index.html, bottom on other pages)
2. Icon inconsistency in mobile nav across pages
3. Touch target size validation needed
4. Safe area handling for notched devices (iPhone X+)
5. Performance on lower-end devices

---

## 1. Testing Environments & Tools

### 1.1 Physical Devices

**Priority Tier 1 (Must Test):**
- iPhone 14/15 (iOS 17+) - Safari
- iPhone SE (small screen baseline)
- Samsung Galaxy S23/S24 (Android 14) - Chrome
- Google Pixel 7/8 (Android 14) - Chrome
- iPad Air/Pro (tablet viewport) - Safari

**Priority Tier 2 (Should Test):**
- OnePlus/Xiaomi (Android mid-range)
- Older iPhone (11/12) - iOS 15-16
- Samsung Galaxy A-series (budget Android)
- Amazon Fire Tablet (alternate Android)

### 1.2 Browser DevTools

**Desktop Browser Emulation:**
- Chrome DevTools - Device Mode
- Firefox Responsive Design Mode
- Safari Web Inspector - Responsive Design Mode
- Edge DevTools - Device Emulation

**Key viewports to test:**
- 320px (iPhone SE, small phones)
- 375px (iPhone standard)
- 390px (iPhone 14 Pro)
- 414px (iPhone Plus models)
- 428px (iPhone 14 Pro Max)
- 768px (tablet portrait, breakpoint boundary)
- 820px (iPad Air)
- 1024px (iPad landscape)

### 1.3 Remote Testing Tools

**Recommended Services:**
- BrowserStack (cross-device cloud testing)
- LambdaTest (real device testing)
- Safari Technology Preview (iOS simulator on Mac)
- Android Studio Emulators

### 1.4 Performance Testing Tools

- Chrome Lighthouse (mobile audit)
- WebPageTest (mobile profiles)
- GTmetrix (mobile testing)
- PageSpeed Insights (mobile scores)
- Chrome DevTools Network Throttling (3G/4G simulation)

---

## 2. Test Coverage Matrix

### 2.1 Pages to Test

| Page | URL | Mobile-Specific Features |
|------|-----|--------------------------|
| **Homepage** | `index.html` | Top mobile nav, breach sequence swipe-down, tap-to-decrypt cards, particle effects |
| **Mission** | `about.html` | Bottom mobile nav, feature grid layout, stats cards |
| **Challenges** | `challenges.html` | Bottom mobile nav, protocol cards, skill tags |
| **Schedule** | `schedule.html` | Bottom mobile nav, timeline animations, scroll-triggered events |
| **Register** | `register.html` | Bottom mobile nav, form validation, input focus handling |

### 2.2 Browser Coverage

| Browser | iOS | Android | Priority |
|---------|-----|---------|----------|
| Safari | ✓ (Default) | — | Critical |
| Chrome | ✓ | ✓ (Default) | Critical |
| Firefox | ✓ | ✓ | High |
| Edge | — | ✓ | Medium |
| Samsung Internet | — | ✓ | Medium |
| Brave | ✓ | ✓ | Low |

---

## 3. Functional Testing Scenarios

### 3.1 Navigation Testing

**Test Case 1: Navigation Position Consistency**
- **Issue:** Index.html has TOP mobile nav, other pages have BOTTOM nav
- **Steps:**
  1. Open index.html on mobile (< 768px width)
  2. Verify mobile nav is at TOP of page
  3. Navigate to about.html
  4. Verify mobile nav is at BOTTOM of page
  5. Navigate back to index.html
  6. Verify nav returns to TOP
- **Expected:** Navigation should be consistently positioned (decide on top or bottom for all pages)
- **Files:** `index.html:1077-1087`, all other pages
- **Priority:** HIGH

**Test Case 2: Icon Consistency**
- **Issue:** Schedule.html uses different icon for Challenges
- **Steps:**
  1. Open all pages in mobile view
  2. Check mobile nav icons match:
     - HOME: fa-home
     - MISSION: fa-info-circle
     - CHALLENGES: fa-trophy (schedule.html uses fa-shield-alt ❌)
     - SCHEDULE: fa-calendar-alt
     - ACCESS: fa-user-plus
- **Expected:** All pages use identical icon set
- **Files:** `schedule.html:632`
- **Priority:** MEDIUM

**Test Case 3: Active State Indication**
- **Steps:**
  1. Open each page on mobile
  2. Verify correct nav item highlighted with `color: var(--color-primary)`
  3. Check active state persists on scroll
- **Expected:** Current page always highlighted correctly
- **Priority:** HIGH

**Test Case 4: Navigation Tap Targets**
- **Steps:**
  1. Open any page on actual mobile device
  2. Tap each mobile nav item with thumb
  3. Measure tap target using Chrome DevTools (should be ≥44x44px iOS, ≥48x48px Android)
- **Expected:** No mis-taps, comfortable spacing
- **Priority:** HIGH

### 3.2 Touch Interactions

**Test Case 5: Tap to Decrypt Protocol Cards (index.html)**
- **Location:** `index.html:1786-1798`
- **Steps:**
  1. Open index.html on mobile
  2. Scroll to protocol cards section
  3. Tap each "CLASSIFIED" card
  4. Verify card decrypts with glitch animation
  5. Verify sound plays (if enabled)
- **Expected:** Smooth decrypt animation, no double-tap required
- **Priority:** CRITICAL

**Test Case 6: Swipe Down to Skip Breach Sequence**
- **Location:** `index.html:1800-1841`
- **Steps:**
  1. Open index.html on mobile
  2. Wait for breach overlay to appear
  3. Swipe down ≥150px
  4. Verify overlay fades out and content appears
  5. Test swipe up (should not trigger)
  6. Test horizontal swipe (should not trigger)
- **Expected:** Clean swipe detection, no false positives
- **Priority:** HIGH

**Test Case 7: Touch Feedback on Buttons**
- **Location:** `index.html:1843-1853`
- **Steps:**
  1. Tap any CTA button on mobile
  2. Verify scale(0.98) visual feedback
  3. Verify click sound plays
  4. Check response feels immediate
- **Expected:** No delay, clear tactile feedback
- **Priority:** MEDIUM

**Test Case 8: Pull-to-Refresh Prevention**
- **Location:** `index.html:1855`
- **Steps:**
  1. Open index.html on mobile browser
  2. Scroll to top of page
  3. Pull down from top edge
  4. Verify browser pull-to-refresh is blocked
- **Expected:** No accidental page reload
- **Priority:** MEDIUM

### 3.3 Form Testing (register.html)

**Test Case 9: Input Focus & Keyboard Handling**
- **Steps:**
  1. Open register.html on mobile
  2. Tap into email input
  3. Verify keyboard appears and page scrolls input into view
  4. Check bottom nav doesn't overlap keyboard
  5. Test on iOS Safari (notoriously problematic)
- **Expected:** Input fully visible above keyboard
- **Priority:** CRITICAL

**Test Case 10: Form Validation on Mobile**
- **Steps:**
  1. Submit empty form
  2. Verify error messages appear
  3. Check error text readable on small screens
  4. Fill form with invalid email
  5. Verify inline validation works
- **Expected:** Clear error feedback, no text overflow
- **Priority:** HIGH

**Test Case 11: Select Dropdowns**
- **Steps:**
  1. Tap experience level dropdown
  2. Verify native mobile picker appears
  3. Select option and verify it's reflected
- **Expected:** Native mobile UI, smooth selection
- **Priority:** MEDIUM

### 3.4 Scroll & Animation Testing

**Test Case 12: GSAP Scroll Animations**
- **Steps:**
  1. Open any page on mobile
  2. Scroll slowly through page
  3. Verify elements fade/slide in at correct positions
  4. Check animations don't jank or lag
  5. Test rapid scroll (shouldn't cause stutter)
- **Expected:** Smooth 60fps animations
- **Priority:** HIGH

**Test Case 13: Page Visibility API**
- **Location:** All pages with GSAP
- **Steps:**
  1. Start scrolling on any page
  2. Switch to another app/tab
  3. Return to browser
  4. Verify animations resume correctly
- **Expected:** Animations paused when hidden, resume on return
- **Priority:** MEDIUM

**Test Case 14: Reduced Motion Support**
- **Steps:**
  1. Enable "Reduce Motion" in device settings
     - iOS: Settings > Accessibility > Motion > Reduce Motion
     - Android: Settings > Accessibility > Remove animations
  2. Open any page
  3. Verify animations are minimal/instant
  4. Check breach overlay is hidden (index.html)
- **Expected:** Accessible experience for motion-sensitive users
- **Priority:** HIGH (accessibility)

---

## 4. Visual & Layout Testing

### 4.1 Responsive Breakpoint Testing

**Test Case 15: 768px Breakpoint Boundary**
- **Steps:**
  1. Open any page in Chrome DevTools
  2. Set viewport to 769px width
  3. Verify desktop HUD nav visible, mobile nav hidden
  4. Resize to 768px width
  5. Verify mobile nav appears, desktop nav hidden
  6. Test edge case: exactly 768px
- **Expected:** Clean switch, no overlap or flash
- **Priority:** HIGH

**Test Case 16: Sub-768px Layout Adjustments**
- **Steps:**
  1. Verify at 768px:
     - Protocol cards: single column
     - Stats grid: single column
     - Form rows: single column
     - Footer: centered, stacked
  2. Check no horizontal scroll
  3. Verify text remains readable
- **Expected:** Clean single-column layout
- **Priority:** MEDIUM

### 4.2 Typography & Readability

**Test Case 17: Fluid Typography**
- **Steps:**
  1. Test `clamp()` values across viewports:
     - 320px: minimum size
     - 375px: typical phone
     - 768px: maximum mobile
  2. Verify no text overflow
  3. Check line-height adequate for reading
- **Expected:** Smooth font scaling, always legible
- **Priority:** MEDIUM

**Test Case 18: Long Text Wrapping**
- **Steps:**
  1. Test breach sequence lines (index.html)
  2. Verify `word-break: break-word` works
  3. Check no text extends beyond viewport
- **Expected:** Clean wrapping, no horizontal scroll
- **Priority:** LOW

### 4.3 Visual Effects on Mobile

**Test Case 19: Effects Disabled on Mobile**
- **Steps:**
  1. Open any page on mobile (< 768px)
  2. Verify these are hidden:
     - Custom cursor
     - Particle animations
     - Noise texture overlay (index.html)
  3. Verify these are reduced:
     - Scanline opacity (0.15 → 0.05)
- **Expected:** Cleaner UI, better performance
- **Priority:** MEDIUM

**Test Case 20: Backdrop Filter Performance**
- **Issue:** Other pages retain `backdrop-filter: blur(15px)` on mobile
- **Steps:**
  1. Open about.html, challenges.html, schedule.html, register.html on mobile
  2. Check if backdrop blur causes lag
  3. Test on older devices (iPhone 11, Android mid-range)
- **Expected:** Smooth scrolling, no jank
- **Priority:** HIGH

### 4.4 Safe Area & Notch Handling

**Test Case 21: Notched Device Safe Areas**
- **Issue:** No `env(safe-area-inset-*)` detected in code
- **Steps:**
  1. Open all pages on iPhone with notch (X, 11, 12, 13, 14, 15)
  2. Check mobile nav doesn't overlap bottom gesture area
  3. Verify content not hidden by notch/Dynamic Island
  4. Test landscape orientation (notch on side)
- **Expected:** Full content visibility, no overlap
- **Priority:** CRITICAL (for iPhone users)

**Test Case 22: Bottom Nav Overlap**
- **Issue:** Main content has `padding-bottom: 100-120px` for nav clearance
- **Steps:**
  1. Scroll to bottom of each page
  2. Verify footer fully visible above mobile nav
  3. Check no content hidden on devices with gesture bars
- **Expected:** No content obscured
- **Priority:** HIGH

---

## 5. Performance Testing

### 5.1 Load Performance

**Test Case 23: Initial Page Load**
- **Steps:**
  1. Open Lighthouse in Chrome DevTools
  2. Run mobile audit for each page
  3. Target metrics:
     - FCP (First Contentful Paint): < 2.5s
     - LCP (Largest Contentful Paint): < 4.0s
     - TBT (Total Blocking Time): < 300ms
     - CLS (Cumulative Layout Shift): < 0.1
  4. Test on throttled 3G connection
- **Expected:** All scores > 80/100
- **Priority:** HIGH

**Test Case 24: CDN Resource Loading**
- **Steps:**
  1. Open Network tab in DevTools
  2. Throttle to "Slow 3G"
  3. Reload page
  4. Verify critical resources load first:
     - Google Fonts
     - GSAP (deferred)
     - Font Awesome
  5. Check DNS prefetch working
- **Expected:** Progressive enhancement, usable before fully loaded
- **Priority:** MEDIUM

### 5.2 Runtime Performance

**Test Case 25: Scroll Performance**
- **Steps:**
  1. Open Performance tab in Chrome DevTools
  2. Record while scrolling entire page on mobile profile
  3. Check for:
     - Frame drops (should be < 5%)
     - Long tasks (> 50ms)
     - Layout thrashing
  4. Verify 60fps maintained
- **Expected:** Smooth scrolling, minimal jank
- **Priority:** HIGH

**Test Case 26: Animation Performance**
- **Issue:** GSAP animations run without frame rate limiting
- **Steps:**
  1. Test on lower-end device (e.g., iPhone SE 2nd gen)
  2. Trigger all animations (scroll, touch, etc.)
  3. Monitor FPS using DevTools
  4. Check for dropped frames
- **Expected:** ≥ 30fps on budget devices, ≥ 60fps on modern
- **Priority:** MEDIUM

**Test Case 27: Memory Usage**
- **Steps:**
  1. Open Memory tab in Chrome DevTools
  2. Take heap snapshot on page load
  3. Navigate between all 5 pages
  4. Take another snapshot
  5. Check for memory leaks
- **Expected:** No significant growth, GSAP timelines cleaned up
- **Priority:** LOW

---

## 6. Cross-Browser Testing

### 6.1 Safari (iOS)

**Test Case 28: Safari-Specific Issues**
- **Steps:**
  1. Test on actual iPhone (Safari only allows real device testing for some features)
  2. Check for:
     - `backdrop-filter` support (should work iOS 9+)
     - Viewport height with browser chrome (`vh` issues)
     - Form input zoom prevention (font-size ≥ 16px)
     - Touch delay (should be prevented)
  3. Test private browsing mode
- **Expected:** Feature parity with Chrome
- **Priority:** CRITICAL (primary iOS browser)

**Test Case 29: iOS Safari Viewport Heights**
- **Issue:** No `dvh` units used, could cause issues with dynamic browser chrome
- **Steps:**
  1. Open any page on iOS Safari
  2. Scroll down (browser chrome shrinks)
  3. Verify full viewport still visible
  4. Test landscape orientation
- **Expected:** No clipping or overlap
- **Priority:** MEDIUM

### 6.2 Chrome (Android)

**Test Case 30: Chrome Mobile Gestures**
- **Steps:**
  1. Test swipe gestures don't conflict:
     - Swipe from left edge (back navigation)
     - Swipe from bottom (home gesture)
     - Swipe down on index.html (skip breach)
  2. Verify no accidental navigation
- **Expected:** Site gestures don't interfere with system
- **Priority:** HIGH

### 6.3 Samsung Internet

**Test Case 31: Samsung Browser Compatibility**
- **Steps:**
  1. Open all pages on Samsung Internet (common on Galaxy devices)
  2. Test all touch interactions
  3. Verify font rendering
  4. Check reader mode compatibility
- **Expected:** Full functionality maintained
- **Priority:** MEDIUM

---

## 7. Accessibility Testing

### 7.1 Screen Reader Testing

**Test Case 32: Mobile Screen Readers**
- **Steps:**
  1. Enable VoiceOver (iOS) or TalkBack (Android)
  2. Navigate through each page
  3. Verify:
     - ARIA labels announced correctly
     - Mobile nav items readable
     - Form inputs properly labeled
     - Images have alt text
  4. Test form submission with screen reader
- **Expected:** Full navigation via screen reader
- **Priority:** HIGH (WCAG AA requirement)

### 7.2 Touch Target Sizes

**Test Case 33: WCAG Touch Target Compliance**
- **Reference:** WCAG 2.5.5 (AAA) = 44x44px minimum
- **Steps:**
  1. Measure all interactive elements:
     - Mobile nav items
     - CTA buttons
     - Protocol cards
     - Form inputs
     - Links in footer
  2. Use Chrome DevTools ruler
  3. Document any < 44x44px targets
- **Expected:** All targets ≥ 44x44px
- **Priority:** HIGH

### 7.3 Color Contrast

**Test Case 34: Mobile Contrast Ratios**
- **Steps:**
  1. Use Lighthouse accessibility audit
  2. Test color combinations:
     - Primary (#00ff9f) on dark background
     - Secondary (#ff0080) on dark background
     - Text (#ffffff) on background (#030303)
     - Muted text (#666666) on background
  3. Verify WCAG AA compliance (4.5:1 normal, 3:1 large)
- **Expected:** All text passes AA standards
- **Priority:** HIGH

---

## 8. Edge Cases & Error Scenarios

### 8.1 Network Conditions

**Test Case 35: Offline Behavior**
- **Steps:**
  1. Load page on mobile
  2. Enable airplane mode
  3. Attempt navigation
  4. Verify error messaging
- **Expected:** Graceful degradation, clear error
- **Priority:** LOW

**Test Case 36: Slow Connection (3G)**
- **Steps:**
  1. Throttle to 3G in DevTools
  2. Load each page
  3. Verify progressive enhancement:
     - Text appears first
     - Animations degrade gracefully
     - No broken layouts during load
- **Expected:** Usable at each stage of loading
- **Priority:** MEDIUM

### 8.2 Edge Cases

**Test Case 37: Rapid Navigation**
- **Steps:**
  1. Rapidly tap between nav items
  2. Verify no race conditions
  3. Check GSAP timelines don't overlap
  4. Verify sound effects don't stack
- **Expected:** Smooth transitions, no crashes
- **Priority:** MEDIUM

**Test Case 38: Extreme Viewport Sizes**
- **Steps:**
  1. Test at 320px (smallest common phone)
  2. Test at 280px (edge case)
  3. Verify layout doesn't break
  4. Check no horizontal scroll
- **Expected:** Graceful degradation
- **Priority:** LOW

**Test Case 39: Landscape Orientation**
- **Steps:**
  1. Rotate device to landscape on all pages
  2. Verify mobile nav still accessible
  3. Check hero sections fit viewport height
  4. Test form usability in landscape
- **Expected:** Fully functional in landscape
- **Priority:** MEDIUM

---

## 9. Testing Checklist

### Pre-Testing Setup
- [ ] Local server running (`python3 -m http.server 8000`)
- [ ] Testing devices charged and connected
- [ ] BrowserStack/cloud testing account ready
- [ ] Screen recording software installed (for bug reports)
- [ ] Accessibility testing tools installed

### Per-Page Testing (Repeat for all 5 pages)
- [ ] Desktop to mobile breakpoint transition (768px)
- [ ] Mobile navigation visible and functional
- [ ] Active nav state correct
- [ ] Touch targets ≥ 44x44px
- [ ] No horizontal scroll at any width
- [ ] Footer fully visible above nav
- [ ] Typography readable (clamp values work)
- [ ] GSAP animations smooth (no jank)
- [ ] Reduced motion respected
- [ ] Safe area compliance (notched devices)
- [ ] Lighthouse mobile score > 80

### Index.html Specific
- [ ] Mobile nav positioned at TOP (not bottom)
- [ ] Tap to decrypt protocol cards works
- [ ] Swipe down to skip breach sequence
- [ ] Pull-to-refresh prevented
- [ ] Touch feedback on buttons
- [ ] Particle effects hidden on mobile
- [ ] Noise texture hidden on mobile

### Register.html Specific
- [ ] Form inputs don't get covered by keyboard
- [ ] Validation messages visible on small screens
- [ ] Select dropdowns use native mobile UI
- [ ] Submit button accessible above mobile nav

### Cross-Browser Testing
- [ ] Safari (iOS) - all features work
- [ ] Chrome (Android) - all features work
- [ ] Firefox (mobile) - all features work
- [ ] Samsung Internet - basic functionality
- [ ] Edge (Android) - basic functionality

### Performance Benchmarks
- [ ] Lighthouse Performance > 80
- [ ] Lighthouse Accessibility > 95
- [ ] FCP < 2.5s on 3G
- [ ] LCP < 4.0s on 3G
- [ ] CLS < 0.1
- [ ] No memory leaks after multi-page navigation

### Accessibility Compliance
- [ ] VoiceOver/TalkBack full navigation
- [ ] All images have alt text
- [ ] Form labels properly associated
- [ ] Color contrast WCAG AA
- [ ] Touch targets WCAG AAA (44x44px)
- [ ] Reduced motion support working

---

## 10. Bug Reporting Template

When filing bugs, use this format:

```markdown
### [BUG] Brief Description

**Severity:** Critical / High / Medium / Low
**Page:** index.html / about.html / challenges.html / schedule.html / register.html
**Device:** iPhone 14, iOS 17.2, Safari
**Viewport:** 390x844px

**Steps to Reproduce:**
1. Open page on device
2. Perform action X
3. Observe behavior Y

**Expected Behavior:**
Description of what should happen

**Actual Behavior:**
Description of what actually happens

**Screenshots/Video:**
[Attach recording]

**Related Code:**
`filename.html:line_number`

**Suggested Fix:**
Optional: proposed solution
```

---

## 11. Known Issues to Verify

Based on codebase exploration, prioritize testing these issues:

### P0 (Critical - Test First)
1. **Navigation Position Inconsistency**
   - File: `index.html:1077-1087`
   - Issue: Top nav on index, bottom nav on others
   - Test: User confusion when navigating between pages

2. **Safe Area Insets Missing**
   - Files: All pages
   - Issue: No `env(safe-area-inset-*)` usage
   - Test: Content overlap on iPhone X+ notched devices

3. **Form Keyboard Overlap**
   - File: `register.html`
   - Issue: No iOS keyboard handling detected
   - Test: Input visibility when keyboard appears

### P1 (High - Test Second)
4. **Icon Inconsistency**
   - File: `schedule.html:632`
   - Issue: Challenges icon differs (fa-shield-alt vs fa-trophy)
   - Test: Visual consistency across pages

5. **Backdrop Filter Performance**
   - Files: `about.html`, `challenges.html`, `schedule.html`, `register.html`
   - Issue: Blur kept on mobile, could impact performance
   - Test: Scroll smoothness on older devices

6. **Touch Target Sizes**
   - Files: All pages, mobile nav
   - Issue: Nav uses small padding (0.5rem) and font (0.6-0.65rem)
   - Test: Minimum 44x44px compliance

### P2 (Medium - Test Third)
7. **Viewport Height Units**
   - Files: All pages
   - Issue: Uses `vh` instead of `dvh` (dynamic viewport height)
   - Test: iOS Safari with dynamic browser chrome

8. **Animation Frame Rate**
   - Files: All pages with GSAP
   - Issue: No frame rate limiting on mobile
   - Test: Performance on budget devices

---

## 12. Success Criteria

Testing is complete when:

✅ **All P0 issues resolved or documented**
✅ **All 5 pages tested on iOS Safari + Android Chrome**
✅ **Lighthouse mobile scores > 80 for all pages**
✅ **Zero WCAG AA violations**
✅ **Zero horizontal scroll issues**
✅ **All forms functional with mobile keyboard**
✅ **Smooth 60fps scroll on modern devices, 30fps on budget**
✅ **Navigation consistent across all pages**
✅ **Safe area compliance verified on notched devices**
✅ **Touch targets meet 44x44px minimum**

---

## 13. Timeline & Responsibilities

### Phase 1: Automated Testing (Est. 2 hours)
- [ ] Run Lighthouse audits on all 5 pages
- [ ] Run WebPageTest mobile profiles
- [ ] Use DevTools responsive mode to test breakpoints
- [ ] Document automated test results

### Phase 2: Real Device Testing (Est. 4 hours)
- [ ] Test on iOS devices (iPhone, iPad)
- [ ] Test on Android devices (various manufacturers)
- [ ] Document device-specific issues
- [ ] Screen record bugs

### Phase 3: Accessibility Audit (Est. 2 hours)
- [ ] VoiceOver testing (iOS)
- [ ] TalkBack testing (Android)
- [ ] Color contrast verification
- [ ] Touch target measurements

### Phase 4: Cross-Browser Testing (Est. 3 hours)
- [ ] Safari (iOS)
- [ ] Chrome (Android)
- [ ] Firefox (mobile)
- [ ] Samsung Internet
- [ ] Edge (Android)

### Phase 5: Fixes & Retesting (Est. varies)
- [ ] Fix P0 issues
- [ ] Fix P1 issues
- [ ] Retest affected areas
- [ ] Final validation

**Total Estimated Time:** 11+ hours (excluding fixes)

---

## 14. Tools & Resources

### Testing Tools
- [Chrome DevTools - Device Mode](https://developer.chrome.com/docs/devtools/device-mode/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [WebPageTest](https://www.webpagetest.org/)
- [BrowserStack](https://www.browserstack.com/)
- [WAVE Accessibility Tool](https://wave.webaim.org/)

### Documentation
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [iOS Safari Web Content Guide](https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/)
- [Android Chrome Best Practices](https://developer.chrome.com/docs/android/)
- [Mobile Touch Targets](https://web.dev/accessible-tap-targets/)

### Viewport Reference
- [iOS Device Sizes](https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)
- [Android Device Metrics](https://material.io/resources/devices/)

---

## 15. Next Steps

1. **Review this plan** with stakeholders
2. **Prioritize** which devices/browsers to focus on based on analytics
3. **Set up** testing environment (devices, accounts, tools)
4. **Execute** testing phases sequentially
5. **Document** all findings in GitHub Issues
6. **Fix** P0 and P1 issues before launch
7. **Retest** after fixes applied
8. **Monitor** real-world metrics post-launch

---

## Appendix A: Quick Reference - Mobile Breakpoints

```css
/* Primary Breakpoint: 768px */
@media (max-width: 768px) {
    /* Mobile styles */
}

/* Test Viewports */
- 320px  - iPhone SE (smallest)
- 375px  - iPhone standard
- 390px  - iPhone 14 Pro
- 414px  - iPhone Plus
- 428px  - iPhone 14 Pro Max
- 768px  - iPad portrait (breakpoint)
```

## Appendix B: Mobile Nav Comparison

| Page | Nav Position | Special Handling |
|------|-------------|------------------|
| index.html | TOP | Overridden in media query at line 1077 |
| about.html | BOTTOM | Default positioning |
| challenges.html | BOTTOM | Default positioning |
| schedule.html | BOTTOM | Default positioning |
| register.html | BOTTOM | Default positioning |

**Recommendation:** Standardize to BOTTOM for all pages for consistency.

## Appendix C: Performance Budget

Target metrics for mobile (3G connection):

| Metric | Target | Max |
|--------|--------|-----|
| FCP | < 1.8s | 2.5s |
| LCP | < 2.5s | 4.0s |
| TBT | < 200ms | 300ms |
| CLS | < 0.05 | 0.1 |
| Speed Index | < 3.0s | 4.0s |
| Time to Interactive | < 3.5s | 5.0s |

---

**Document Version:** 1.0
**Created:** 2025-12-27
**Branch:** claude/plan-mobile-testing-cjV33
