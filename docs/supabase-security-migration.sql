-- ============================================
-- NEBULA:FOG Challenge Database — Security Migration
-- Run this in Supabase SQL Editor
-- Hardens schema after initial deployment
-- ============================================

-- 1. Add length constraint to author_name
ALTER TABLE challenges ADD CONSTRAINT chk_author_name_length
  CHECK (char_length(author_name) BETWEEN 1 AND 50);

-- 2. Add length constraint to contact_handle
ALTER TABLE challenges ADD CONSTRAINT chk_contact_handle_length
  CHECK (char_length(contact_handle) BETWEEN 2 AND 100);

-- 3. Fix UPDATE RLS policy — add WITH CHECK to prevent user_id transfer
DROP POLICY IF EXISTS "Owner update" ON challenges;
CREATE POLICY "Owner update" ON challenges FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 4. Skills validation function (restricts to allowed skill values)
CREATE OR REPLACE FUNCTION validate_skills(skills TEXT[])
RETURNS BOOLEAN AS $$
DECLARE
  allowed TEXT[] := ARRAY[
    'Prompt Injection','Agent Exploitation','Trust Manipulation','Adversarial AI',
    'Red Teaming','Detection Systems','Self-Healing','Architecture Hardening',
    'Monitoring','Zero-Knowledge Proofs','Trust Anchors','Privacy Engineering',
    'Encrypted Inference','Novel Research','AI Security Tooling','Agent Alignment',
    'LLM Security','Cryptography','Web Security','Machine Learning',
    'Python','JavaScript','Rust','Go'
  ];
  s TEXT;
BEGIN
  FOREACH s IN ARRAY skills LOOP
    IF NOT s = ANY(allowed) THEN RETURN FALSE; END IF;
  END LOOP;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 5. Add skills validation constraint
ALTER TABLE challenges ADD CONSTRAINT chk_valid_skills
  CHECK (validate_skills(skills));
