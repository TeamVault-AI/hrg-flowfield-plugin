#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/hrg-flowfield-package-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

version="$(jq -r '.version' "$ROOT/plugin/.claude-plugin/plugin.json")"
"$ROOT/scripts/package-release.sh" "$version" "$TEST_ROOT/dist" >"$TEST_ROOT/checksums"

cat >"$TEST_ROOT/expected-files" <<'EOF'
.claude-plugin/plugin.json
.mcp.json
skills/send-flowfield-feedback/SKILL.md
skills/using-hrg-flowfield/SKILL.md
EOF

for archive in "$TEST_ROOT/dist/hrg-flowfield-v$version.plugin" "$TEST_ROOT/dist/hrg-flowfield-v$version.zip"; do
  unzip -Z1 "$archive" | LC_ALL=C sort >"$TEST_ROOT/actual-files"
  diff -u "$TEST_ROOT/expected-files" "$TEST_ROOT/actual-files"

  extract_dir="$TEST_ROOT/extracted-$(basename "$archive")"
  mkdir "$extract_dir"
  unzip -q "$archive" -d "$extract_dir"
  while IFS= read -r relative_file; do
    cmp "$ROOT/plugin/$relative_file" "$extract_dir/$relative_file"
  done <"$TEST_ROOT/expected-files"
done

(
  cd "$TEST_ROOT/dist"
  shasum -a 256 -c "$TEST_ROOT/checksums"
)

printf '%s\n' "HRG Flowfield release package inventory tests passed."
