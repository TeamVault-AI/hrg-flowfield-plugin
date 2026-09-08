# Releasing HRG Flowfield

The canonical source is `plugins/hrg-flowfield` in the private
`flowfieldai/flowfield` repository. The public
`flowfieldai/hrg-flowfield-plugin` repository is a generated distribution
mirror and must not be edited directly.

Claude marketplace updates are version-driven. Publish every plugin-owned
change through a merged pull request in the canonical repository; do not use a
direct push to either repository as the release mechanism.

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

5. Open and merge the canonical pull request.
6. The canonical publish workflow validates and opens a version-bump pull request in the
   public repository using the encrypted repository secret
   `HRG_FLOWFIELD_PLUGIN_PUBLISH_TOKEN`. Rotate that credential without
   changing plugin source when its GitHub authorization changes.
7. Review and merge the generated public version-bump PR; direct pushes are not permitted. The public mirror workflow creates tag `v<version>` plus `.plugin`, `.zip`,
   and checksum release assets when that version does not already exist.
8. In Claude, update the `flowfield-hrg` marketplace and then update HRG
   Flowfield. Begin a new session and verify that the connector still exposes
   `hybrid_search`, `read_document`, and `search_text`.

Server-side retrieval, identity, ACL, OAuth, and MCP behavior should be shipped
on `hrg.flowfield.inc`; those changes do not require a plugin version bump.
