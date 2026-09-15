#!/bin/sh
set -eu

VERSION="${1:?usage: package-release.sh VERSION [OUTPUT_DIR]}"
OUTPUT_DIR="${2:-dist}"
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PLUGIN_ROOT="$ROOT/plugin"

plugin_version="$(jq -r '.version' "$PLUGIN_ROOT/.claude-plugin/plugin.json")"
marketplace_version="$(jq -r '.plugins[] | select(.name == "hrg-flowfield") | .version' "$ROOT/.claude-plugin/marketplace.json")"

[ "$VERSION" = "$plugin_version" ] || {
  printf 'requested version %s does not match plugin manifest %s\n' "$VERSION" "$plugin_version" >&2
  exit 1
}
[ "$VERSION" = "$marketplace_version" ] || {
  printf 'marketplace version %s does not match plugin manifest %s\n' "$marketplace_version" "$plugin_version" >&2
  exit 1
}

mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(CDPATH= cd -- "$OUTPUT_DIR" && pwd)"
PLUGIN_ASSET="$OUTPUT_DIR/hrg-flowfield-v$VERSION.plugin"
ZIP_ASSET="$OUTPUT_DIR/hrg-flowfield-v$VERSION.zip"
rm -f "$PLUGIN_ASSET" "$ZIP_ASSET"

(
  cd "$PLUGIN_ROOT"
  zip -q "$PLUGIN_ASSET" \
    .claude-plugin/plugin.json \
    .mcp.json \
    skills/send-flowfield-feedback/SKILL.md \
    skills/using-hrg-flowfield/SKILL.md
)
cp "$PLUGIN_ASSET" "$ZIP_ASSET"

(
  cd "$OUTPUT_DIR"
  shasum -a 256 "$(basename "$PLUGIN_ASSET")" "$(basename "$ZIP_ASSET")"
)
