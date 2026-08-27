#!/bin/sh
set -eu

VERSION="${1:?usage: package-release.sh VERSION [OUTPUT_DIR]}"
OUTPUT_DIR="${2:-dist}"
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

plugin_version="$(jq -r '.version' "$ROOT/.claude-plugin/plugin.json")"
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
PLUGIN_ASSET="$OUTPUT_DIR/hrg-flowfield-v$VERSION.plugin"
ZIP_ASSET="$OUTPUT_DIR/hrg-flowfield-v$VERSION.zip"
rm -f "$PLUGIN_ASSET" "$ZIP_ASSET"

(
  cd "$ROOT"
  zip -qr "$PLUGIN_ASSET" . \
    -x '.git/*' '.github/*' 'dist/*' 'tests/*' '*.DS_Store' '*.plugin' '*.zip'
)
cp "$PLUGIN_ASSET" "$ZIP_ASSET"

shasum -a 256 "$PLUGIN_ASSET" "$ZIP_ASSET"
