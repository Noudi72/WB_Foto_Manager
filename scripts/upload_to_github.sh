#!/bin/bash

# Script zum automatischen Upload von Bildern und gallery.json zu GitHub
# Verwendung: ./scripts/upload_to_github.sh [Bild-Ordner]

set -e  # Beende bei Fehlern

# Farben für Ausgabe
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prüfe ob wir im richtigen Verzeichnis sind
if [ ! -f "gallery.json" ]; then
    echo -e "${RED}Fehler: gallery.json nicht gefunden. Bitte im Projekt-Root ausführen.${NC}"
    exit 1
fi

# Bild-Ordner (Standard: images/)
IMAGE_DIR="${1:-images}"

if [ ! -d "$IMAGE_DIR" ]; then
    echo -e "${RED}Fehler: Ordner '$IMAGE_DIR' nicht gefunden.${NC}"
    exit 1
fi

echo -e "${GREEN}=== WB Foto Manager - GitHub Upload ===${NC}"
echo ""

# Prüfe Git-Status
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Fehler: Kein Git-Repository gefunden.${NC}"
    exit 1
fi

# Zeige Status
echo -e "${YELLOW}1. Prüfe Git-Status...${NC}"
git status --short

echo ""
echo -e "${YELLOW}2. Füge Bilder hinzu...${NC}"

# Zähle neue/geänderte Bilder
NEW_IMAGES=$(git status --porcelain "$IMAGE_DIR" | grep -c "^??" || true)
MODIFIED_IMAGES=$(git status --porcelain "$IMAGE_DIR" | grep -c "^ M" || true)

if [ "$NEW_IMAGES" -gt 0 ] || [ "$MODIFIED_IMAGES" -gt 0 ]; then
    echo "  - Neue Bilder: $NEW_IMAGES"
    echo "  - Geänderte Bilder: $MODIFIED_IMAGES"
    git add "$IMAGE_DIR/"
    echo -e "${GREEN}  ✓ Bilder zum Staging hinzugefügt${NC}"
else
    echo -e "${YELLOW}  ⚠ Keine neuen oder geänderten Bilder gefunden${NC}"
fi

# Prüfe ob gallery.json geändert wurde
if git diff --quiet gallery.json && git diff --cached --quiet gallery.json; then
    echo -e "${YELLOW}  ⚠ gallery.json wurde nicht geändert${NC}"
else
    echo -e "${YELLOW}3. Füge gallery.json hinzu...${NC}"
    git add gallery.json
    echo -e "${GREEN}  ✓ gallery.json zum Staging hinzugefügt${NC}"
fi

# Zeige was committed wird
echo ""
echo -e "${YELLOW}4. Änderungen die committed werden:${NC}"
git status --short

# Frage nach Commit
echo ""
read -p "Möchten Sie diese Änderungen committen und zu GitHub pushen? (j/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[JjYy]$ ]]; then
    echo -e "${YELLOW}Abgebrochen.${NC}"
    exit 0
fi

# Commit-Message
COMMIT_MSG="WebApp: Bilder und gallery.json aktualisiert"
if [ "$NEW_IMAGES" -gt 0 ]; then
    COMMIT_MSG="$COMMIT_MSG ($NEW_IMAGES neue Bilder)"
fi

echo ""
echo -e "${YELLOW}5. Committe Änderungen...${NC}"
git commit -m "$COMMIT_MSG"
echo -e "${GREEN}  ✓ Commit erstellt${NC}"

echo ""
echo -e "${YELLOW}6. Pushe zu GitHub...${NC}"
if git push origin main; then
    echo -e "${GREEN}  ✓ Erfolgreich zu GitHub gepusht${NC}"
    echo ""
    echo -e "${GREEN}✓ Fertig! Die Änderungen sollten in 1-2 Minuten auf GitHub Pages sichtbar sein.${NC}"
    echo -e "${YELLOW}URL: https://noudi72.github.io/WB_Foto_Manager/${NC}"
else
    echo -e "${RED}  ✗ Fehler beim Pushen zu GitHub${NC}"
    echo -e "${YELLOW}  Versuchen Sie: git pull origin main --no-rebase${NC}"
    exit 1
fi
