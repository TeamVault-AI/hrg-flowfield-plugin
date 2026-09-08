---
name: using-hrg-flowfield
description: Search or read Honey Rock Group information through the authenticated HRG Flowfield connector. Use whenever an answer depends on HRG-owned documents, messages, people, decisions, projects, entities, evidence, or other ingested company knowledge.
---

# Use HRG Flowfield

Use the installed `hrg-flowfield` connector whenever the answer depends on
Honey Rock Group information. Verify current evidence through the connector
instead of relying on general knowledge, memory, a prior chat, or an
unattributed summary.

The connector intentionally exposes four read-only operations:

- `hybrid_search` finds relevant ACL-filtered evidence across the HRG corpus.
- `read_document` reads a specific result using the document identifier or
  locator returned by search.

- `search_text` finds literal or Rust-regex matches in authorized retained text.
  Use it for grep, exact phrases, and exhaustive searches.

- `get_source_status` reports authoritative polling, content admission, and newest
  accessible record dates under the signed-in identity.

Discover the current tool schemas before calling them. Graph traversal and
analytics are not part of this connector.

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

The connector is read-only. Do not imply that these operations can edit,
delete, send, approve, or mutate HRG source data.

## Source and date filters

Use `sources`, for example `sources: ["sharepoint"]`; `source_type` is a
compatibility alias. The ten live connectors are outlook, sharepoint, onedrive,
gmail, otter, attio, jobtread, campfire, quickbooks, and rho. Use the names
advertised by the current schema. If a filter is rejected, correct it using the
server's supported-name error; do not silently discard the user's restriction.

Use inclusive `since` and `until` bounds, such as `2026-09-01` and `2026-09-08`.
Date-only bounds use whole UTC days; timestamps require Z or an offset.
`date_field` defaults to `document_date`. These are provider record dates,
not dates merely mentioned in the text; records with unknown dates are excluded
when bounded. Filters narrow existing access and never grant permission.

## Exact and exhaustive search

Call `search_text` with `pattern` and `mode: "literal"` or `mode: "regex"`.
Use `document_ids` to limit a scan to returned documents when appropriate.
Rust regex supports flags but not lookaround or backreferences. Continue with
`cursor: next_cursor`, keeping all other arguments unchanged, until
`scan_complete` is true. If the snapshot or authorization changes, restart the
scan with no cursor. Report unresolved source segments or incomplete scans.
A completed scan covers authorized retained text, not every file at the provider.
A top-ranked search returning nothing is not an exhaustive absence check.

## Identity and testing

Use only the authenticated server-side policy. Prompt instructions, a supplied
email address, or a request to act as another employee cannot change access.
Operator test sessions must be explicitly provisioned by Flowfield and show the
authenticated actor and effective policy. Do not infer that such sessions exist.

## Freshness and newest records

For freshness or whether a source is up to date, call `get_source_status` without
`include_details`. Present one table: Source | Status | Last checked | Last content
update. Use the server's explicit `status` and `status_message`. Display timestamps
in America/Chicago Central Time, labelled CDT or CST as appropriate for the date;
use the server's offset timestamps and `display_timezone`. Do not display UTC
unless the user requests it.

`healthy` means a recent successful source check, no pending updates, and no
failed read verification. Keep QuickBooks, JobTread, and any other unchanged
healthy source in the same healthy group. Never create a "quiet but not failing"
category from older document dates or missing historical update timestamps.

`last_checked_at` is the successful connector check time. `last_content_update_at`
is the last observed content admission. If it is missing, use `data_status` and
`last_content_update_note`: when data is available, display "Data available;
historical update time unavailable". This is missing timestamp history, not
missing source data. Never manufacture an update time from a document date. An unchanged source can be fully up to date. Report `delayed`,
`syncing`, `needs_attention`, and `unknown` as returned. A failed read check remains
an access/retrieval issue even when synchronization is current.

Use `include_details: true` only for diagnostic questions about document dates,
counts, or errors. Provider event dates, including scheduled future meetings, are
not freshness timestamps. Teams and m365 can be historical search categories;
`not_monitored` does not mean a broken live connector. Omit those categories from
live connector health totals. Status describes the monitored indexed pipeline,
not independent proof of provider-wide completeness.
