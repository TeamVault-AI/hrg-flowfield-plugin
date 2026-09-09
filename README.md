# Flowfield: HRG plugin

Official Claude plugin for Honey Rock Group's Flowfield knowledge connector.

The plugin connects Claude to `https://hrg.flowfield.inc/mcp`. It contains no
customer data, passwords, tokens, or shared credentials. Each HRG user signs in
with Microsoft, and Flowfield applies that person's canonical identity and
source permissions on the server.

The connector intentionally exposes three read-only tools:

- `hybrid_search`
- `read_document`
- `search_text` (literal/regex search with exhaustive pagination)

## Install in Claude Desktop, Cowork, or Chat

1. Open **Customize** → **Plugins**.
2. Choose **Add marketplace** → **Add from a repository**.
3. Enter `flowfieldai/hrg-flowfield-plugin`.
4. Install **Flowfield: HRG**.
5. Open its connector, choose **Connect**, and sign in with your Honey Rock
   Group Microsoft account.

For an HRG Team or Enterprise organization, an administrator can add the same
repository as an organization marketplace and make Flowfield: HRG available,
installed by default, or required.

## Install in Claude Code

Run:

```bash
curl --proto '=https' --tlsv1.2 -fsS https://raw.githubusercontent.com/flowfieldai/hrg-flowfield-plugin/v0.1.4/install-claude-code.sh | sh
```

Then start a new Claude Code session or run `/reload-plugins`.

## Test after installation

Ask Claude:

> Use Flowfield: HRG to search for Honey Rock Group information, read the most relevant result, and confirm that the connector exposes hybrid_search, read_document, and search_text.

## Updates

Flowfield server, retrieval, identity, ACL, and tool-description improvements
take effect immediately without a plugin update. Changes to the plugin's local
skills or connector package are released by bumping both manifest versions and
merging a release pull request. Claude then surfaces the marketplace update;
users apply it from **Customize** → **Plugins** and begin a new session.

Direct pushes are not the release path. Flowfield publishes versioned changes
through merged pull requests because that is the update trigger proven with the
Cleves marketplace.

## Security

- OAuth and ACL enforcement remain on `hrg.flowfield.inc`.
- The package contains no secrets or customer content.
- Microsoft handles account authentication; the plugin never receives a user
  password.
- All connector operations are read-only.

Copyright Flowfield. All rights reserved.

## Connector display name

When adding the custom connector, use **Flowfield: HRG** as the name and
`https://hrg.flowfield.inc/mcp` as the URL. The plugin title is distributed in
the manifest; custom connector names are saved separately in Claude. Existing
connections keep their saved name after a plugin update.

## Connector setup compatibility

No custom headers are required. If an older plugin populated an
`X-Flowfield-Plugin-Version` row in Claude's connector setup, remove that entire
row with its × button before adding the connector. Keep the name
**Flowfield: HRG**, URL `https://hrg.flowfield.inc/mcp`, and normal OAuth sign-in.
Version telemetry is optional on the server and is not required to connect.
