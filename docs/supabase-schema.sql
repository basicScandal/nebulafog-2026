-- ============================================
-- NEBULA:FOG Challenge Database Schema
-- Run this in Supabase SQL Editor
-- ============================================

-- Challenges table
CREATE TABLE challenges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  author_name TEXT NOT NULL CHECK (char_length(author_name) BETWEEN 1 AND 50),
  title TEXT NOT NULL CHECK (char_length(title) BETWEEN 5 AND 100),
  description TEXT NOT NULL CHECK (char_length(description) BETWEEN 20 AND 1000),
  track TEXT NOT NULL CHECK (track IN ('SHADOW','SENTINEL','ZERO','ROGUE')),
  skills TEXT[] NOT NULL CHECK (array_length(skills, 1) BETWEEN 1 AND 5),
  contact_method TEXT NOT NULL CHECK (contact_method IN ('discord','email')),
  contact_handle TEXT NOT NULL CHECK (char_length(contact_handle) BETWEEN 2 AND 100),
  team_status TEXT NOT NULL CHECK (team_status IN ('looking','open','full')),
  team_size INT NOT NULL CHECK (team_size BETWEEN 1 AND 4),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX idx_challenges_track ON challenges(track);
CREATE INDEX idx_challenges_status ON challenges(team_status);
CREATE INDEX idx_challenges_created ON challenges(created_at DESC);

-- Row Level Security
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Anyone can read
CREATE POLICY "Public read" ON challenges FOR SELECT USING (true);

-- Authenticated users can insert (user_id must match)
CREATE POLICY "Auth insert" ON challenges FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own (WITH CHECK prevents user_id transfer)
CREATE POLICY "Owner update" ON challenges FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own
CREATE POLICY "Owner delete" ON challenges FOR DELETE
  USING (auth.uid() = user_id);

-- Skills validation function
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

-- Auto-update timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at BEFORE UPDATE ON challenges
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
