-- ============================================
-- NEBULA:FOG 2026 — Seed Challenges
-- Organizer-posted challenges to kickstart the database
-- Run in Supabase SQL Editor
-- Contact: rob@nebulafog.ai
-- ============================================

-- First, get or create the organizer user ID
-- (Replace with actual organizer user_id after auth setup)
-- For now, we use a DO block to insert with a known organizer account

DO $$
DECLARE
  org_id UUID;
BEGIN
  -- Look up the organizer's auth user by email
  SELECT id INTO org_id FROM auth.users WHERE email = 'rob@nebulafog.ai' LIMIT 1;

  IF org_id IS NULL THEN
    RAISE NOTICE 'Organizer user rob@nebulafog.ai not found in auth.users. Create the account first, then re-run.';
    RETURN;
  END IF;

  -- ============================================
  -- SHADOW::VECTOR (Offensive / Red Team)
  -- ============================================

  INSERT INTO challenges (title, description, track, skills, contact_method, contact_handle, team_status, team_size, author_name, user_id)
  VALUES
  (
    'LLM Jailbreak Arena',
    'Build a framework that systematically discovers jailbreak vectors in production LLMs. Test across multiple model families (GPT, Claude, Gemini, Llama) and categorize bypass techniques by type — prompt injection, context manipulation, role-play escalation, and multi-turn chains. The goal is a reusable red-team toolkit, not just one-off prompts.',
    'SHADOW',
    ARRAY['Prompt Injection', 'Red Teaming', 'LLM Security', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Adversarial Patch Generator for Vision Models',
    'Create adversarial patches that fool state-of-the-art vision models (CLIP, SAM 2, GPT-4V) into misclassifying objects in real-world photos. Go beyond digital-only attacks — design patches that remain effective when printed and photographed under varying lighting and angles. Measure transferability across model architectures.',
    'SHADOW',
    ARRAY['Adversarial AI', 'Machine Learning', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Agent Hijacking via Tool Poisoning',
    'Demonstrate how AI agents that use external tools (web search, code execution, API calls) can be hijacked through poisoned tool outputs. Build a proof-of-concept showing indirect prompt injection through search results, API responses, or file contents that causes the agent to exfiltrate data or take unauthorized actions.',
    'SHADOW',
    ARRAY['Agent Exploitation', 'Prompt Injection', 'Red Teaming', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Trust Score Manipulation Attack',
    'Many AI systems now use trust/reputation scores to weight inputs or grant permissions. Build an attack that manipulates these trust mechanisms — whether through Sybil attacks on feedback loops, gradual trust escalation, or exploiting score aggregation logic. Show how a low-trust actor can elevate to high-trust status.',
    'SHADOW',
    ARRAY['Trust Manipulation', 'Red Teaming', 'Web Security', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),

  -- ============================================
  -- SENTINEL::MESH (Defensive / Blue Team)
  -- ============================================

  (
    'Real-Time Prompt Injection Firewall',
    'Build a detection layer that sits between users and an LLM API, analyzing prompts in real-time to flag injection attempts before they reach the model. Must handle direct injections, indirect injections embedded in user-supplied documents, and multi-turn escalation patterns. Target <50ms latency overhead.',
    'SENTINEL',
    ARRAY['Detection Systems', 'LLM Security', 'Python', 'Machine Learning'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Self-Healing AI Pipeline Monitor',
    'Design a monitoring system for ML inference pipelines that detects anomalies (data drift, adversarial inputs, model degradation) and automatically triggers remediation — rollback to a previous model version, input filtering, or alerting. Demonstrate on a live pipeline with injected failures.',
    'SENTINEL',
    ARRAY['Self-Healing', 'Monitoring', 'Machine Learning', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'AI-Powered PII Scanner for Training Data',
    'Build a tool that scans large datasets (text, images, PDFs) for personally identifiable information before they are used for model training or fine-tuning. Go beyond regex — use NER models, context analysis, and image OCR to catch PII in unstructured formats. Generate a compliance report with redaction suggestions.',
    'SENTINEL',
    ARRAY['Detection Systems', 'Privacy Engineering', 'Machine Learning', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Model Supply Chain Integrity Checker',
    'Models downloaded from Hugging Face, Ollama, or other registries could be tampered with. Build a verification tool that checks model integrity — hash validation, weight analysis for backdoor signatures, and provenance tracking. Bonus: detect fine-tuning-based backdoors that pass standard hash checks.',
    'SENTINEL',
    ARRAY['Architecture Hardening', 'AI Security Tooling', 'Python', 'Machine Learning'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),

  -- ============================================
  -- ZERO::PROOF (Privacy / Cryptography)
  -- ============================================

  (
    'ZK-Verified Model Inference',
    'Prove that a specific AI model produced a specific output for a given input — without revealing the model weights or full input. Use zero-knowledge proofs (RISC Zero, SP1, or custom circuits) to create verifiable inference receipts. Focus on small models (MLP, decision trees) to keep proving time practical.',
    'ZERO',
    ARRAY['Zero-Knowledge Proofs', 'Cryptography', 'Rust', 'Machine Learning'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Encrypted Inference Gateway',
    'Build a gateway that lets users submit encrypted queries to an AI model and receive encrypted results — the server never sees plaintext inputs or outputs. Explore fully homomorphic encryption (FHE) or secure multi-party computation (MPC) approaches. Benchmark latency vs. plaintext inference.',
    'ZERO',
    ARRAY['Encrypted Inference', 'Privacy Engineering', 'Cryptography', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Privacy-Preserving Federated Threat Intel',
    'Multiple organizations want to share threat intelligence (IOCs, attack patterns) without exposing their internal data. Build a federated learning or secure aggregation system where each org contributes to a shared threat model while keeping their raw data private. Use differential privacy or MPC.',
    'ZERO',
    ARRAY['Privacy Engineering', 'Machine Learning', 'Cryptography', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Trustless AI Audit Trail',
    'Create an on-chain or cryptographically verifiable audit trail for AI decision-making. Every inference, fine-tuning run, or data access should produce a tamper-proof log entry. Use Merkle trees, blockchain anchoring, or trusted timestamps. Demo with a loan approval or content moderation scenario.',
    'ZERO',
    ARRAY['Trust Anchors', 'Cryptography', 'Zero-Knowledge Proofs', 'JavaScript'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),

  -- ============================================
  -- ROGUE::AGENT (Autonomous Agents)
  -- ============================================

  (
    'Autonomous Red Team Agent',
    'Build an AI agent that autonomously performs security assessments — scanning for vulnerabilities, crafting exploits, and generating a pentest report. The agent should use tool-calling to run nmap, nuclei, or custom scripts, chain findings together, and prioritize by severity. Test against intentionally vulnerable targets (DVWA, Juice Shop).',
    'ROGUE',
    ARRAY['Agent Exploitation', 'Red Teaming', 'AI Security Tooling', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Multi-Agent Incident Response Team',
    'Design a system of cooperating AI agents that handle security incidents end-to-end — one triages alerts, another investigates logs, a third contains threats, and a coordinator synthesizes the response. Demonstrate on a simulated breach scenario with realistic log data.',
    'ROGUE',
    ARRAY['Agent Alignment', 'Detection Systems', 'Monitoring', 'Python'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Agent Alignment Sandbox',
    'Build a sandbox environment that tests whether AI agents stay within their defined boundaries. Create scenarios where an agent is tempted to exceed its permissions — accessing unauthorized files, making unscoped API calls, or ignoring safety constraints. Score agents on alignment and report violations.',
    'ROGUE',
    ARRAY['Agent Alignment', 'AI Security Tooling', 'Python', 'JavaScript'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  ),
  (
    'Autonomous Vulnerability Patcher',
    'Create an AI agent that reads CVE advisories, identifies affected code in a repository, generates patches, runs tests, and opens pull requests — all autonomously. Focus on dependency vulnerabilities (npm, pip, cargo) where the fix is often a version bump plus compatibility adjustments. Measure fix rate and patch quality.',
    'ROGUE',
    ARRAY['Novel Research', 'AI Security Tooling', 'Python', 'Go'],
    'email',
    'rob@nebulafog.ai',
    'looking',
    1,
    'Rob (Organizer)',
    org_id
  );

  RAISE NOTICE 'Seeded 16 challenges across all 4 tracks.';

END $$;
