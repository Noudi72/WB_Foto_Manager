#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PROJECT_PATH="$ROOT_DIR/WB Foto Manager/WB Foto Manager.xcodeproj"
SCHEME="WB Foto Manager"

DERIVED_DATA_PATH="$ROOT_DIR/build/DerivedData"
DEFAULT_APP_PATH="$DERIVED_DATA_PATH/Build/Products/Release/WB Foto Manager.app"

DIST_DIR="$ROOT_DIR/dist"
DMG_PATH="$DIST_DIR/WB Foto Manager.dmg"

APP_PATH=""

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [--app "/path/to/WB Foto Manager.app"]

If --app is not provided, the script builds a Release app via xcodebuild and packages it.

Output:
  $DMG_PATH
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)
      APP_PATH="${2:-}"
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

mkdir -p "$DIST_DIR"

if [[ -z "$APP_PATH" ]]; then
  echo "▶︎ Building Release app…"
  mkdir -p "$DERIVED_DATA_PATH"
  xcodebuild \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -configuration Release \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build

  APP_PATH="$DEFAULT_APP_PATH"
fi

if [[ ! -d "$APP_PATH" ]]; then
  echo "❌ App not found: $APP_PATH"
  exit 1
fi

echo "▶︎ Packaging DMG…"
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

cp -R "$APP_PATH" "$TMP_DIR/"
ln -s /Applications "$TMP_DIR/Applications"

rm -f "$DMG_PATH"
hdiutil create \
  -volname "WB Foto Manager" \
  -srcfolder "$TMP_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "✅ DMG created:"
echo "   $DMG_PATH"


