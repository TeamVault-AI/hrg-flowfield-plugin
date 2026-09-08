# Changelog

## 0.1.4

- Advertise the complete search/read/exact-search tool suite.
- Guide source/date filtering, exhaustive pagination and identity-safe testing.
- Preserve the existing authenticated endpoint and plugin identifiers.

## 0.1.3

- Emit portable release checksums using asset filenames rather than CI-runner
  absolute paths.
- Verify `SHA256SUMS` during release-package validation.

## 0.1.2

- Made the private `flowfieldai/flowfield` monorepo and its
  `flowfield-internal` marketplace the canonical source.
- Moved the credential-free public distribution repository to
  `flowfieldai/hrg-flowfield-plugin`.
- Added automatic canonical-to-public mirroring and public release packaging.

## 0.1.1

- Verified the GitHub marketplace update path through a merged release pull
  request and an isolated Claude installation.
- Preserved the existing `hrg.flowfield.inc` MCP and its exact two-tool
  `hybrid_search` / `read_document` contract.

## 0.1.0

- Initial HRG Flowfield marketplace, plugin, Microsoft OAuth connector, setup
  skill, and retrieval skill.
