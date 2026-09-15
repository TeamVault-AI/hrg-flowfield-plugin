---
name: send-flowfield-feedback
description: "Send conversation feedback to Flowfield when the user says send feedback, report this conversation, submit feedback to Flowfield, or otherwise asks to share the current Claude exchange with the Flowfield team. Capture the visible conversation verbatim and use the dedicated feedback tool."
---

# Send feedback to Flowfield

Use `submit_feedback` only when the user explicitly asks to send or submit
feedback. The request authorizes creation of one restricted Flowfield feedback
record. It does not authorize editing any HRG source system.

## Capture the transcript

By default, copy every visible user and assistant turn from the start of the
conversation through the user's feedback request into `transcript_turns`, in
the original order. Preserve the exact visible text, including spelling,
punctuation, whitespace, and formatting. Do not summarize, correct, normalize,
or reconstruct missing text.

The transcript must contain at least two turns and must include both a user
turn and an assistant turn. Use:

- `transcript_scope: full_visible_conversation` by default.
- `context_status: complete_visible_context` only when the conversation start
  and every intervening turn are available in the current context.
- `context_status: possibly_truncated_context` when earlier content may have
  been summarized, compacted, or removed. Never claim unseen text was captured.
- `transcript_scope: selected_exchange` and `context_status: selected_excerpt`
  only when the user explicitly asks to send a smaller exchange.

If the visible transcript exceeds the tool limit, do not silently truncate it.
Tell the user that the full visible conversation is too large and ask which
exchange to submit.

## Ask for the optional note

If the feedback request already explains the problem or desired improvement,
use that explanation as `feedback_message` and do not ask again. If the user
only says something like “send feedback,” ask exactly once:

> What would you like to see improved, or should I send it without an extra note?

The note is optional. “Send it,” “no note,” or an equivalent response means
omit `feedback_message` and proceed immediately. Do not ask for another
confirmation.

## Submit

Call `submit_feedback` with:

- `prompt_origin`: the human request that triggered this submission, verbatim.
- the transcript fields described above.
- `feedback_message` only when the user supplied one.

After success, state that the feedback was stored and include the returned
`feedback_id`. If the tool fails, report the error and do not imply that the
feedback was received.
