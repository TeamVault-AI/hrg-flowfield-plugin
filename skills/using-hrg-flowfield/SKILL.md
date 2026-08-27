---
name: using-hrg-flowfield
description: Search or read Honey Rock Group information through the authenticated HRG Flowfield connector. Use whenever an answer depends on HRG-owned documents, messages, people, decisions, projects, entities, evidence, or other ingested company knowledge.
---

# Use HRG Flowfield

Use the installed `hrg-flowfield` connector whenever the answer depends on
Honey Rock Group information. Verify current evidence through the connector
instead of relying on general knowledge, memory, a prior chat, or an
unattributed summary.

The connector intentionally exposes exactly two operations:

- `hybrid_search` finds relevant ACL-filtered evidence across the HRG corpus.
- `read_document` reads a specific result using the document identifier or
  locator returned by search.

Do not expect or request graph traversal, analytics, grep, timeline, guide,
access, or other legacy tools from this connector.

## Retrieval workflow

1. Translate the user's request into the smallest useful search query. Preserve
   distinctive names, project terms, dates, products, and quoted phrases.
2. Call `hybrid_search`. If the request has independent subquestions, search
   each one separately instead of overloading one vague query.
3. Read only the most relevant results with `read_document` when full context,
   exact wording, provenance, or disambiguation is needed.
4. If evidence is thin, refine the query with concrete entities or terminology
   found in the first results. Do not treat absence from one search as proof
   that the corpus contains no evidence.
5. Answer the business question first. Distinguish direct evidence from
   synthesis, and cite the returned source titles, dates, participants, and
   locators when they materially support the answer.

## Access boundary

Flowfield resolves the signed-in Microsoft user to a canonical HRG identity
and applies that person's source permissions on the server. Never ask the user
for a bearer token, password, or shared credential. Never claim that a missing
result exists but is hidden; say only that it was not present in the evidence
available to the signed-in user.

The connector is read-only. Do not imply that either operation can edit,
delete, send, approve, or mutate HRG source data.
