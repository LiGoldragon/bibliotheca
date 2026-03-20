#!/usr/bin/env bash
# Launch the annas-archive MCP server with the API key from gopass.
# The key is injected into the child process environment only —
# it does not appear in this script's env, logs, or MCP config.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BINARY="$SCRIPT_DIR/target/debug/annas-archive"

if [ ! -f "$BINARY" ]; then
  echo "error: binary not found — run 'cargo build' first" >&2
  exit 1
fi

exec env \
  ANNAS_ARCHIVE_API_KEY="$(gopass show -o annas-archive.gl/secret-key)" \
  RUST_LOG="${RUST_LOG:-info}" \
  "$BINARY"
