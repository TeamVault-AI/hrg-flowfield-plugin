---
name: setup-hrg-flowfield
description: Install, update, authenticate, repair, or verify the HRG Flowfield plugin and connector. Use for first-time setup, Microsoft sign-in, missing HRG tools, a newly installed plugin, or a request to test the HRG Flowfield connection.
---

# Set up HRG Flowfield

Use supported Claude plugin and MCP controls only. Never edit Claude's plugin
registry, cache, or OAuth token storage directly.

## Claude Code

1. Run `claude plugin list --json` and confirm that
   `hrg-flowfield@flowfield-hrg` is installed and enabled.
2. If the plugin was installed or updated during the current session, tell the
   user to run `/reload-plugins` or start a new session.
3. Run `claude mcp list`. The expected connector identifier is
   `plugin:hrg-flowfield:hrg-flowfield`.
4. If authentication is required, run this in an interactive terminal:

   ```bash
   claude mcp login 'plugin:hrg-flowfield:hrg-flowfield'
   ```

   Let Claude open the Flowfield authorization page. The user must choose and
   approve their Honey Rock Group Microsoft account. Never request their
   password, hard-code an authorization URL, or paste a token into chat.
5. Verify that the connector advertises `hybrid_search`, `read_document`, `search_text`, and `get_source_status`.
   Discover the live schemas; do not reject future tools merely because this guide predates them.
6. Run one harmless HRG search, read one returned document, and find a literal phrase from that document with `search_text`. Do not report
   setup complete until the search/read/text calls and a `get_source_status` call succeed under the signed-in identity.

## Claude Desktop, Cowork, and Chat

Install HRG Flowfield from the Flowfield HRG marketplace. Open the plugin's
connector and select **Connect**, then complete Microsoft sign-in on the hosted
Flowfield page. Organization-managed plugins may also be installed or required
by an HRG Claude administrator.

## Completion report

Report the plugin version, enabled state, connector state, the advertised tools, and whether the harmless search/read test passed. Do not expose
tokens, internal identity claims, or source content merely to prove setup.
