import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const MODERATION_PROMPT = `You are a content moderator for a cybersecurity hackathon challenge board (NEBULA:FOG 2026).

CONTEXT: This is an AI x Security hackathon. Participants post challenge ideas about topics like:
- Prompt injection, adversarial AI, red teaming
- Attack vectors, exploit frameworks, vulnerability research
- Zero-knowledge proofs, cryptography, trust systems
- Agent security, LLM security, detection evasion (in defensive context)

These security terms are EXPECTED and ALLOWED. Do NOT flag content just because it mentions attacks, exploits, injections, adversarial techniques, or hacking — that is the entire purpose of this event.

ONLY flag content that contains:
1. Hate speech, slurs, or discrimination
2. Sexual or explicit content
3. Spam, scams, or commercial solicitation
4. Doxxing or sharing personal information
5. Content completely unrelated to cybersecurity/AI (e.g., selling products, political rants)

Respond with EXACTLY one of:
- "approved" — content is appropriate for a security hackathon
- "flagged: <reason>" — content violates the guidelines above

Be LENIENT. When in doubt, approve. Security research language is expected here.`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
    });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const { challenge_id } = await req.json();
    if (!challenge_id) {
      return new Response(
        JSON.stringify({ error: "challenge_id required" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    // Fetch challenge with service role (bypasses RLS)
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const { data: challenge, error: fetchError } = await supabase
      .from("challenges")
      .select("id, title, description, moderation_status")
      .eq("id", challenge_id)
      .single();

    if (fetchError || !challenge) {
      return new Response(
        JSON.stringify({ error: "Challenge not found" }),
        { status: 404, headers: { "Content-Type": "application/json" } },
      );
    }

    // Skip if already flagged/rejected (e.g., by user reports)
    if (challenge.moderation_status !== "approved") {
      return new Response(
        JSON.stringify({ status: challenge.moderation_status, skipped: true }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    // Call Claude API for moderation
    const anthropicResponse = await fetch(
      "https://api.anthropic.com/v1/messages",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ANTHROPIC_API_KEY,
          "anthropic-version": "2023-06-01",
        },
        body: JSON.stringify({
          model: "claude-haiku-4-5-20251001",
          max_tokens: 100,
          messages: [
            {
              role: "user",
              content: `${MODERATION_PROMPT}\n\n---\nTitle: ${challenge.title}\nDescription: ${challenge.description}`,
            },
          ],
        }),
      },
    );

    if (!anthropicResponse.ok) {
      console.error(
        "Anthropic API error:",
        anthropicResponse.status,
        await anthropicResponse.text(),
      );
      // Graceful degradation: don't flag on API failure
      return new Response(
        JSON.stringify({ status: "approved", reason: "moderation_api_error" }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    const result = await anthropicResponse.json();
    const verdict =
      result.content?.[0]?.text?.trim().toLowerCase() || "approved";

    if (verdict.startsWith("flagged")) {
      const reason = verdict.replace(/^flagged:\s*/, "") || "LLM flagged";
      await supabase
        .from("challenges")
        .update({
          moderation_status: "flagged",
          moderation_reason: reason,
        })
        .eq("id", challenge_id)
        .eq("moderation_status", "approved"); // Only flag if still approved

      return new Response(
        JSON.stringify({ status: "flagged", reason }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ status: "approved" }),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    console.error("Moderation function error:", err);
    // Graceful degradation
    return new Response(
      JSON.stringify({ status: "approved", reason: "function_error" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }
});
