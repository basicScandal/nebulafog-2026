import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
const NOTIFY_EMAIL = "rob@nebulafog.ai";

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: Record<string, unknown> | null;
  old_record: Record<string, unknown> | null;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  try {
    const payload: WebhookPayload = await req.json();
    const { type, record, old_record } = payload;
    const challenge = record || old_record;

    if (!challenge) {
      return new Response("No record data", { status: 400 });
    }

    const title = (challenge.title as string) || "Unknown";
    const author = (challenge.author_name as string) || "Unknown";
    const track = (challenge.track as string) || "Unknown";

    const actionLabels: Record<string, string> = {
      INSERT: "New challenge posted",
      UPDATE: "Challenge updated",
      DELETE: "Challenge deleted",
    };
    const action = actionLabels[type] || type;

    const subject = `[NEBULA:FOG] ${action}: ${title}`;

    const details =
      type === "DELETE"
        ? `<p><strong>${author}</strong> deleted their challenge "<strong>${title}</strong>" (${track})</p>`
        : `<p><strong>${author}</strong> ${type === "INSERT" ? "posted a new" : "updated their"} challenge:</p>
      <table style="border-collapse:collapse;margin:16px 0;">
        <tr><td style="padding:4px 12px 4px 0;color:#666;">Title</td><td style="padding:4px 0;"><strong>${title}</strong></td></tr>
        <tr><td style="padding:4px 12px 4px 0;color:#666;">Track</td><td style="padding:4px 0;">${track}</td></tr>
        <tr><td style="padding:4px 12px 4px 0;color:#666;">Author</td><td style="padding:4px 0;">${author}</td></tr>
        <tr><td style="padding:4px 12px 4px 0;color:#666;">Team Status</td><td style="padding:4px 0;">${challenge.team_status || "—"}</td></tr>
        <tr><td style="padding:4px 12px 4px 0;color:#666;">Description</td><td style="padding:4px 0;">${challenge.description || "—"}</td></tr>
      </table>`;

    const html = `<div style="font-family:monospace;max-width:600px;">
      <h2 style="color:#00ff9f;margin:0 0 16px;">${action}</h2>
      ${details}
      <hr style="border:none;border-top:1px solid #333;margin:16px 0;">
      <p style="color:#666;font-size:12px;">NEBULA:FOG Challenge Database Notification</p>
    </div>`;

    const emailRes = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: "NEBULA:FOG <onboarding@resend.dev>",
        to: [NOTIFY_EMAIL],
        subject,
        html,
      }),
    });

    if (!emailRes.ok) {
      const err = await emailRes.text();
      console.error("Resend error:", emailRes.status, err);
      return new Response(JSON.stringify({ error: "Email send failed" }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ status: "sent" }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Notification function error:", err);
    return new Response(JSON.stringify({ error: "Function error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
