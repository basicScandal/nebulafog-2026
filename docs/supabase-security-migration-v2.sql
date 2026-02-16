-- ============================================
-- NEBULA:FOG Challenge Database — Security Migration v2
-- Run this in Supabase SQL Editor
-- Addresses pentest findings: challenge spam + archive date
-- ============================================

-- 1. Per-user challenge limit (max 10) — prevents spam via direct API calls
-- Uses a trigger instead of CHECK constraint because CHECK can't query other rows
CREATE OR REPLACE FUNCTION enforce_challenge_limit()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT count(*) FROM challenges WHERE user_id = NEW.user_id) >= 10 THEN
    RAISE EXCEPTION 'Challenge limit reached (max 10 per user)';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_challenge_limit
  BEFORE INSERT ON challenges
  FOR EACH ROW EXECUTE FUNCTION enforce_challenge_limit();

-- 2. Archive date — prevent new challenges after March 14, 2026
-- Server-side enforcement (client-side date check is easily bypassed)
CREATE OR REPLACE FUNCTION enforce_archive_date()
RETURNS TRIGGER AS $$
BEGIN
  IF now() > '2026-03-14T23:59:59Z'::timestamptz THEN
    RAISE EXCEPTION 'Challenge submissions are closed';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_archive_date
  BEFORE INSERT ON challenges
  FOR EACH ROW EXECUTE FUNCTION enforce_archive_date();
