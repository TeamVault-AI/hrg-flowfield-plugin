# Releasing HRG Flowfield

Claude marketplace updates are version-driven. Publish every plugin-owned
change through a merged pull request; do not use a direct push to `main` as the
release mechanism.

1. Create a release branch.
2. Make the plugin or skill change.
3. Bump the same semantic version in both:
   - `.claude-plugin/plugin.json`
   - `.claude-plugin/marketplace.json`
4. Run:

   ```bash
   jq -e . .claude-plugin/plugin.json .claude-plugin/marketplace.json .mcp.json
   sh tests/test-install-claude-code.sh
   claude plugin validate .
   ```

5. Open and merge the pull request.
6. Tag the merged commit `v<version>`.
7. Build and publish the fallback packages:

   ```bash
   scripts/package-release.sh <version> dist
   gh release create v<version> dist/* --title "HRG Flowfield v<version>"
   ```

8. In Claude, update the `flowfield-hrg` marketplace and then update HRG
   Flowfield. Begin a new session and verify that the connector still exposes
   exactly `hybrid_search` and `read_document`.

Server-side retrieval, identity, ACL, OAuth, and MCP behavior should be shipped
on `hrg.flowfield.inc`; those changes do not require a plugin version bump.
