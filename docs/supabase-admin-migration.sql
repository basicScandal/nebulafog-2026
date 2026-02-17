-- ============================================
-- NEBULA:FOG Admin Dashboard RLS Policies
-- Run this in Supabase SQL Editor
-- ============================================
-- Grants admin access for reviewing flagged content,
-- updating moderation status, and managing challenges.
--
-- NOTE: Uses auth.jwt() ->> 'email' instead of querying auth.users
-- to avoid permission errors for the anon role (which can't SELECT
-- from auth.users, causing 42501 errors on public challenge reads).

-- ============================================
-- 1. Admin read all challenges (including flagged/rejected)
-- ============================================
CREATE POLICY "Admin read all challenges" ON challenges FOR SELECT
  USING (auth.jwt() ->> 'email' IN ('rob@nebulafog.ai'));

-- ============================================
-- 2. Admin update challenges (change moderation_status)
-- ============================================
CREATE POLICY "Admin update challenges" ON challenges FOR UPDATE
  USING (auth.jwt() ->> 'email' IN ('rob@nebulafog.ai'));

-- ============================================
-- 3. Admin delete challenges
-- ============================================
CREATE POLICY "Admin delete challenges" ON challenges FOR DELETE
  USING (auth.jwt() ->> 'email' IN ('rob@nebulafog.ai'));

-- ============================================
-- 4. Admin read all reports
-- ============================================
CREATE POLICY "Admin read all reports" ON challenge_reports FOR SELECT
  USING (auth.jwt() ->> 'email' IN ('rob@nebulafog.ai'));
