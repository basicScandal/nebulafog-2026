-- ============================================
-- NEBULA:FOG Content Moderation Migration
-- Run this in Supabase SQL Editor
-- ============================================

-- ============================================
-- 1a. Add moderation columns to challenges
-- ============================================
ALTER TABLE challenges ADD COLUMN moderation_status TEXT NOT NULL DEFAULT 'approved'
  CHECK (moderation_status IN ('approved', 'flagged', 'rejected'));
ALTER TABLE challenges ADD COLUMN moderation_reason TEXT;

-- ============================================
-- 1b. Reports table
-- ============================================
CREATE TABLE challenge_reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE NOT NULL,
  reporter_user_id UUID REFERENCES auth.users(id) NOT NULL,
  reason TEXT NOT NULL CHECK (reason IN ('spam', 'inappropriate', 'misleading', 'other')),
  details TEXT CHECK (char_length(details) <= 500),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(challenge_id, reporter_user_id)  -- one report per user per challenge
);

CREATE INDEX idx_reports_challenge ON challenge_reports(challenge_id);
ALTER TABLE challenge_reports ENABLE ROW LEVEL SECURITY;

-- Only auth'd users can report (not their own challenges)
CREATE POLICY "Auth insert reports" ON challenge_reports FOR INSERT
  WITH CHECK (auth.uid() = reporter_user_id AND
    auth.uid() != (SELECT user_id FROM challenges WHERE id = challenge_id));

-- Users can read their own reports (to know they already reported)
CREATE POLICY "Own reports read" ON challenge_reports FOR SELECT
  USING (auth.uid() = reporter_user_id);

-- ============================================
-- 1c. Auto-flag trigger (3+ reports)
-- ============================================
CREATE OR REPLACE FUNCTION auto_flag_reported() RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT count(*) FROM challenge_reports WHERE challenge_id = NEW.challenge_id) >= 3 THEN
    UPDATE challenges SET moderation_status = 'flagged',
      moderation_reason = 'Auto-flagged: 3+ user reports'
    WHERE id = NEW.challenge_id AND moderation_status = 'approved';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER flag_on_reports AFTER INSERT ON challenge_reports
  FOR EACH ROW EXECUTE FUNCTION auto_flag_reported();

-- ============================================
-- 1d. Update RLS — hide flagged from public, visible to owner
-- ============================================
DROP POLICY "Public read" ON challenges;
CREATE POLICY "Public read approved or own" ON challenges FOR SELECT
  USING (moderation_status = 'approved' OR auth.uid() = user_id);

-- ============================================
-- 1e. Server-side keyword filter trigger
-- ============================================
CREATE OR REPLACE FUNCTION check_content_keywords(content_text TEXT) RETURNS BOOLEAN AS $$
DECLARE
  blocklist TEXT[] := ARRAY[
    -- slurs/hate (with leet-speak variants)
    'n[i1]gg[e3]r', 'f[a4]gg[o0]t', 'ch[i1]nk', 'sp[i1]c', 'k[i1]k[e3]',
    -- spam patterns
    'buy now', 'click here', 'limited time offer', '100% free',
    'send bitcoin', 'gift card', 'make money fast',
    -- explicit content
    '\bporn\b', '\bxxx\b', '\bviagra\b'
  ];
  pattern TEXT;
BEGIN
  content_text := lower(content_text);
  FOREACH pattern IN ARRAY blocklist LOOP
    IF content_text ~* pattern THEN RETURN FALSE; END IF;
  END LOOP;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION enforce_keyword_filter() RETURNS TRIGGER AS $$
BEGIN
  IF NOT check_content_keywords(NEW.title || ' ' || NEW.description) THEN
    RAISE EXCEPTION 'Content contains prohibited terms. Please revise your submission.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_keywords BEFORE INSERT OR UPDATE ON challenges
  FOR EACH ROW EXECUTE FUNCTION enforce_keyword_filter();
