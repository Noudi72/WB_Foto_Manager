#!/bin/bash
# Automatisches Setup-Skript für die WebApp
# Dieses Skript bereitet alles vor und zeigt dir, wie du es pushen kannst

set -e  # Stoppe bei Fehlern

echo "🚀 WB Foto Manager - WebApp Setup"
echo "=================================="
echo ""

# Prüfe ob wir im richtigen Verzeichnis sind
if [ ! -f "WebApp/index.html" ]; then
    echo "❌ Fehler: Bitte führe dieses Skript aus dem Hauptverzeichnis des Repositories aus!"
    echo "   cd ~/Desktop/WB_Foto_Manager"
    exit 1
fi

# Prüfe ob Git-Repository vorhanden
if [ ! -d ".git" ]; then
    echo "📦 Initialisiere Git-Repository..."
    git init
    git remote add origin https://github.com/noudi72/WB_Foto_Manager.git 2>/dev/null || true
fi

# Erstelle images/ Ordner falls nicht vorhanden
if [ ! -d "images" ]; then
    echo "📁 Erstelle images/ Ordner..."
    mkdir -p images
    echo "# Bilder-Ordner" > images/README.md
    echo "Lade deine Bilder hier hinein!" >> images/README.md
fi

# Prüfe ob Bilder vorhanden sind
IMAGE_COUNT=$(find images -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null | wc -l | tr -d ' ')

if [ "$IMAGE_COUNT" -eq 0 ]; then
    echo ""
    echo "⚠️  Keine Bilder im images/ Ordner gefunden!"
    echo ""
    echo "📝 So fügst du Bilder hinzu:"
    echo "   1. Kopiere deine Bilder in den Ordner: $(pwd)/images/"
    echo "   2. Führe dieses Skript erneut aus"
    echo ""
    echo "   Oder über GitHub Web-Interface:"
    echo "   1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager"
    echo "   2. Klicke auf 'Add file' → 'Upload files'"
    echo "   3. Im Upload-Dialog: Gib 'images/bild1.jpg' ein (mit 'images/' am Anfang!)"
    echo "   4. Ziehe deine Bilder hinein"
    echo "   5. Klicke auf 'Commit changes'"
    echo ""
    read -p "Drücke Enter, wenn du Bilder hinzugefügt hast, oder Ctrl+C zum Abbrechen..."
    IMAGE_COUNT=$(find images -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null | wc -l | tr -d ' ')
fi

if [ "$IMAGE_COUNT" -eq 0 ]; then
    echo "❌ Immer noch keine Bilder gefunden. Bitte füge Bilder hinzu und versuche es erneut."
    exit 1
fi

echo "✅ $IMAGE_COUNT Bilder gefunden!"
echo ""

# Generiere gallery.json
echo "📝 Generiere gallery.json..."

# Prüfe ob Python verfügbar ist
if command -v python3 &> /dev/null; then
    # Versuche Pillow zu importieren
    if python3 -c "import PIL" &> /dev/null 2>&1; then
        echo "   Verwende Python-Skript (mit Thumbnails)..."
        python3 WebApp/generate_gallery.py --images-dir images/ --output WebApp/gallery.json
    else
        echo "   Pillow nicht installiert. Installiere es mit: pip3 install Pillow"
        echo "   Verwende Shell-Skript (ohne Thumbnails)..."
        bash WebApp/generate_gallery.sh images/ WebApp/gallery.json
    fi
else
    echo "   Python nicht gefunden. Verwende Shell-Skript..."
    bash WebApp/generate_gallery.sh images/ WebApp/gallery.json
fi

if [ ! -f "WebApp/gallery.json" ]; then
    echo "❌ Fehler: gallery.json konnte nicht generiert werden!"
    exit 1
fi

echo "✅ gallery.json erfolgreich generiert!"
echo ""

# Zeige Status
echo "📊 Status:"
echo "   - Bilder: $IMAGE_COUNT"
echo "   - gallery.json: ✅"
echo ""

# Frage ob gepusht werden soll
echo "🚀 Bereit zum Pushen!"
echo ""
read -p "Möchtest du jetzt zu GitHub pushen? (j/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[JjYy]$ ]]; then
    echo ""
    echo "📤 Pushe zu GitHub..."
    
    # Füge alle Dateien hinzu
    git add images/ WebApp/gallery.json WebApp/index.html WebApp/*.py WebApp/*.sh 2>/dev/null || true
    
    # Prüfe ob es Änderungen gibt
    if git diff --staged --quiet; then
        echo "ℹ️  Keine Änderungen zum Committen."
    else
        git commit -m "WebApp: Bilder und gallery.json hinzugefügt" || echo "⚠️  Commit fehlgeschlagen (möglicherweise keine Änderungen)"
    fi
    
    # Pushe
    echo "   Pushe zu GitHub..."
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || {
        echo ""
        echo "⚠️  Push fehlgeschlagen. Mögliche Gründe:"
        echo "   1. Du bist nicht eingeloggt (verwende: git push -u origin main)"
        echo "   2. Du musst zuerst pullen (verwende: git pull origin main --rebase)"
        echo ""
        echo "📝 Manuelle Schritte:"
        echo "   git add images/ WebApp/gallery.json"
        echo "   git commit -m 'WebApp aktualisiert'"
        echo "   git push origin main"
    }
    
    echo ""
    echo "✅ Fertig! Warte 1-2 Minuten, dann sollte deine Galerie unter"
    echo "   https://noudi72.github.io/WB_Foto_Manager/ funktionieren! 🎉"
else
    echo ""
    echo "📝 Manuelle Schritte zum Pushen:"
    echo ""
    echo "   git add images/ WebApp/gallery.json"
    echo "   git commit -m 'WebApp aktualisiert'"
    echo "   git push origin main"
    echo ""
    echo "   Oder über GitHub Web-Interface:"
    echo "   1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager"
    echo "   2. Klicke auf 'Upload files'"
    echo "   3. Ziehe den images/ Ordner und WebApp/gallery.json hinein"
    echo "   4. Klicke auf 'Commit changes'"
fi

echo ""
echo "✨ Setup abgeschlossen!"
