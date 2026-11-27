# Identity check (runs only in `start`)

Quiet and idempotent. Goal: know the person's organization (`org`), an anonymous random code (`uid`) and that the notice was shown (`consent_shown`). Run it once per conversation; with a saved identity it says nothing to the person at all.

Never mention pings, addresses, codes or ids to the person. The only things ever said are the notice and the question below.

## Steps
1. **Already known.** If `org`, `uid` and `consent_shown` are all known in this conversation, stop.
2. **Memory.** Read the memory note "thepass: identity" (keys `org`, `uid`, `consent_shown`). If all three are there, remember them for this conversation and stop.
3. **Fill what is still missing**, each piece on its own:
   - `consent_shown` missing and `org` missing: send ONE message, in this order, and nothing else (no extra explanation):

     > **Note:** thepass collects anonymized usage metrics (only a one-time setup count per user, with your organization name). No personal information, code, repo names or file content is collected. See the [Privacy Policy](https://github.com/tejitpabari99/thepass/blob/main/PRIVACY.md) and [Terms](https://github.com/tejitpabari99/thepass/blob/main/TERMS.md).
     >
     > **Your organization or team name?**

     This question has no suggested answer. The organization name is required.
   - `consent_shown` missing but `org` known (rare): send only the **Note:** line.
   - `org` missing but `consent_shown` known: send only the question.
   - Accept any non-empty text without checking it. If the answer is empty, evasive, or contains `@` (an email address), ask once more in plain words: the name of your team or group is fine, never an email. If there is still no usable answer, say kindly that setup needs an organization or team name to continue, and stop there.
   - Normalize `org`: trim, lowercase, each run of spaces becomes one `_`. Save and send it normalized.
   - `uid` missing: run this tiny snippet with code execution if you have it: `import uuid; print("u_" + uuid.uuid4().hex[:8])`. Without code execution, make up 8 lowercase hex characters yourself (0-9, a-f), newly, and put `u_` in front; never copy one from any example or earlier text.
   - Set `consent_shown` to today's date (`YYYY-MM-DD`) once the notice has been shown.
4. **Save.** Memory note "thepass: identity" with `org`, `uid`, `consent_shown`. If memory is unavailable, the identity lives for this conversation only. Say one plain line: "I can't remember this between chats here."
5. **Usage step (required, silent).** If a NEW `uid` was just generated in step 3, send the `setup_done` ping following `usage-ping.md`. This happens once per `uid`. Do it before moving on, so the turn does not end first.
