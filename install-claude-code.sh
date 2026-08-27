#!/bin/sh
set -eu

MARKETPLACE_NAME="flowfield-hrg"
MARKETPLACE_SOURCE="${FLOWFIELD_MARKETPLACE_SOURCE:-TeamVault-AI/hrg-flowfield-plugin}"
PLUGIN_ID="hrg-flowfield@flowfield-hrg"
MCP_ID="plugin:hrg-flowfield:hrg-flowfield"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"

say() {
  printf '%s\n' "$*"
}

fail() {
  printf 'HRG Flowfield installer: %s\n' "$*" >&2
  exit 1
}

command -v "$CLAUDE_BIN" >/dev/null 2>&1 || fail "Claude Code is not installed or is not on PATH. Install it from https://claude.com/download and retry."

say "HRG Flowfield: using $($CLAUDE_BIN --version)"

marketplaces="$($CLAUDE_BIN plugin marketplace list --json)"
if printf '%s\n' "$marketplaces" | grep -Eq '"name"[[:space:]]*:[[:space:]]*"flowfield-hrg"'; then
  say "Updating the Flowfield HRG plugin source..."
  "$CLAUDE_BIN" plugin marketplace update "$MARKETPLACE_NAME"
else
  say "Adding the official Flowfield HRG plugin source..."
  "$CLAUDE_BIN" plugin marketplace add "$MARKETPLACE_SOURCE" --scope user
fi

installed="$($CLAUDE_BIN plugin list --json)"
if printf '%s\n' "$installed" | grep -Eq '"id"[[:space:]]*:[[:space:]]*"hrg-flowfield@flowfield-hrg"'; then
  say "Updating the HRG Flowfield plugin..."
  "$CLAUDE_BIN" plugin update "$PLUGIN_ID" --scope user
else
  say "Installing the HRG Flowfield plugin for this user..."
  "$CLAUDE_BIN" plugin install "$PLUGIN_ID" --scope user
fi

if [ "${FLOWFIELD_INSTALLER_SKIP_OAUTH:-0}" = "1" ]; then
  say "Skipping OAuth because FLOWFIELD_INSTALLER_SKIP_OAUTH=1."
else
  say "Opening Flowfield sign-in. Choose your HRG Microsoft account in the browser; this installer never receives your password."
  if [ -t 1 ] && [ -r /dev/tty ]; then
    "$CLAUDE_BIN" mcp login "$MCP_ID" </dev/tty
  else
    "$CLAUDE_BIN" mcp login "$MCP_ID"
  fi
fi

status="$($CLAUDE_BIN mcp list 2>&1 || true)"
say "$status"

connector_status="$(printf '%s\n' "$status" | grep -F "$MCP_ID" || true)"
if [ "${FLOWFIELD_INSTALLER_SKIP_OAUTH:-0}" != "1" ] && printf '%s\n' "$connector_status" | grep -Eiq 'needs authentication|failed|error'; then
  fail "Flowfield is installed but authentication is not complete. Run: claude mcp login '$MCP_ID'"
fi

say ""
say "HRG Flowfield installation completed."
say "If Claude Code is already open, run /reload-plugins. Otherwise start a new session."
say "Then ask an HRG question or run /hrg-flowfield:setup-hrg-flowfield to verify setup."
