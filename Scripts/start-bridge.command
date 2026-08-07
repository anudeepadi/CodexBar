#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Starting CodexBar local usage bridge on http://127.0.0.1:8787"
BIN_PATH="$(pwd)/.build/release/CodexBarCLI"
if [ ! -f "$BIN_PATH" ]; then
    echo "Building CodexBarCLI release binary (one-time; may take a minute)..."
    swift build -c release --product CodexBarCLI
else
    echo "Using existing binary (skipping rebuild to preserve Keychain trust)."
fi
echo "Binary: $BIN_PATH"

CLI_TIMEOUT_SECONDS="${CODEXBAR_CLI_TIMEOUT:-60}"
echo "Using CLI timeout: ${CLI_TIMEOUT_SECONDS}s (override with CODEXBAR_CLI_TIMEOUT)"

echo "Bridge ready. Test with: curl http://127.0.0.1:8787/api/usage/summary?range=weekly"
python3 Scripts/usage_api_server.py --port 8787 --binary "$BIN_PATH" --timeout "$CLI_TIMEOUT_SECONDS"
