#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DMG_PATH="$ROOT_DIR/dist/WB Foto Manager.dmg"
PROFILE=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") --profile <keychain-profile> [--dmg "/path/to/file.dmg"]

This submits the DMG to Apple Notary Service and staples the ticket.

One-time setup (creates a Keychain profile):
  xcrun notarytool store-credentials "<profile-name>" \\
    --apple-id "<apple-id@email>" \\
    --team-id "<TEAMID>" \\
    --password "<app-specific-password>"

Run:
  ./scripts/notarize_dmg.sh --profile "<profile-name>"

Notes:
  - Requires a Developer ID-capable Apple Developer account
  - Requires network access
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --dmg)
      DMG_PATH="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  echo "❌ Missing --profile"
  usage
  exit 2
fi

if [[ ! -f "$DMG_PATH" ]]; then
  echo "❌ DMG not found: $DMG_PATH"
  exit 1
fi

echo "▶︎ Submitting to Notary Service…"
xcrun notarytool submit "$DMG_PATH" --keychain-profile "$PROFILE" --wait

echo "▶︎ Stapling ticket…"
xcrun stapler staple "$DMG_PATH"

echo "▶︎ Validating staple…"
xcrun stapler validate "$DMG_PATH"

echo "✅ Notarized + stapled:"
echo "   $DMG_PATH"


