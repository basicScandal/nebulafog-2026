// NEBULA:FOG 2026 - Custom Analytics Events
// Works with PostHog (initialized via posthog-init.js)
// Tracks: CTA clicks, outbound links, scroll depth, nav, track interest, terminal

(function () {
    'use strict';

    // Ensure posthog exists (graceful degradation)
    var ph = window.posthog || { capture: function () {} };

    var pageName = location.pathname.replace('.html', '').replace(/^\//, '') || 'index';

    // ─── Registration CTA Tracking ───────────────────────────
    document.querySelectorAll('a[href="register.html"], a[href="/register.html"]').forEach(function (link) {
        link.addEventListener('click', function (e) {
            var section = e.target.closest('[data-section]');
            ph.capture('register_cta_click', {
                page: pageName,
                section: section ? section.dataset.section : 'unknown'
            });
        });
    });

    // ─── Outbound Link Tracking ──────────────────────────────
    document.querySelectorAll('a[target="_blank"], a[href*="luma.com"], a[href*="dub.sh"]').forEach(function (link) {
        link.addEventListener('click', function () {
            var href = link.getAttribute('href') || '';
            var category = 'external';
            if (href.indexOf('luma.com') !== -1) category = 'luma_register';
            else if (href.indexOf('nf-afterparty') !== -1) category = 'afterparty';
            else if (href.indexOf('dub.sh') !== -1) category = 'shortlink';

            ph.capture('outbound_click', {
                page: pageName,
                category: category,
                url: href.substring(0, 120)
            });
        });
    });

    // ─── Scroll Depth Tracking ───────────────────────────────
    var depthsTracked = {};
    var pageStart = Date.now();
    var ticking = false;

    function checkScrollDepth() {
        var docHeight = document.documentElement.scrollHeight - window.innerHeight;
        if (docHeight <= 0) return;
        var pct = Math.round((window.scrollY / docHeight) * 100);
        var milestones = [25, 50, 75, 100];

        for (var i = 0; i < milestones.length; i++) {
            var m = milestones[i];
            if (pct >= m && !depthsTracked[m]) {
                depthsTracked[m] = true;
                ph.capture('scroll_depth', {
                    depth: m,
                    page: pageName,
                    seconds: Math.round((Date.now() - pageStart) / 1000)
                });
            }
        }
        ticking = false;
    }

    window.addEventListener('scroll', function () {
        if (!ticking) {
            ticking = true;
            requestAnimationFrame(checkScrollDepth);
        }
    }, { passive: true });

    // ─── Navigation Tracking ────────────────────────────────
    document.querySelectorAll('.hud-link, .mobile-nav a, .footer-links a').forEach(function (link) {
        link.addEventListener('click', function () {
            var dest = (link.getAttribute('href') || '').replace('.html', '').replace('/', '') || 'index';
            var nav = link.closest('.hud-nav') ? 'hud' :
                      link.closest('.mobile-nav') ? 'mobile' : 'footer';
            ph.capture('nav_click', {
                page: pageName,
                destination: dest,
                nav_type: nav
            });
        });
    });

    // ─── Track Interest Tracking ──────────────────────────────
    document.querySelectorAll('.protocol-card').forEach(function (card) {
        var title = card.querySelector('.protocol-title');
        var trackName = title ? title.textContent.trim() : 'unknown';
        var hoverTimer;

        card.addEventListener('mouseenter', function () {
            hoverTimer = setTimeout(function () {
                ph.capture('track_interest', {
                    track: trackName,
                    page: pageName,
                    action: 'hover'
                });
            }, 2000);
        });

        card.addEventListener('mouseleave', function () {
            clearTimeout(hoverTimer);
        });

        card.addEventListener('click', function () {
            clearTimeout(hoverTimer);
            ph.capture('track_interest', {
                track: trackName,
                page: pageName,
                action: 'click'
            });
        });
    });

    // ─── Sticky CTA: show on scroll + track clicks ─────────
    var stickyCta = document.getElementById('sticky-register-cta');
    if (stickyCta) {
        var badge = document.getElementById('sticky-days-left');
        if (badge) {
            var daysLeft = Math.ceil((new Date('2026-03-14T08:30:00-07:00') - new Date()) / 86400000);
            if (daysLeft > 0) badge.textContent = daysLeft + 'D LEFT';
        }

        var visible = false;
        window.addEventListener('scroll', function () {
            var show = window.scrollY > 400;
            if (show !== visible) {
                visible = show;
                stickyCta.classList.toggle('visible', show);
            }
        }, { passive: true });

        stickyCta.addEventListener('click', function () {
            ph.capture('sticky_cta_click', { page: pageName });
        });
    }
})();
