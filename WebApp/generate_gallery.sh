#!/bin/bash
# Einfaches Shell-Skript zum Generieren von gallery.json (ohne Thumbnails)
# Für macOS/Linux Benutzer ohne Python

IMAGES_DIR="${1:-images/}"
OUTPUT_FILE="${2:-gallery.json}"
PASSWORD="${3:-}"

echo "Generiere gallery.json aus $IMAGES_DIR..."

# Prüfe ob images/ Ordner existiert
if [ ! -d "$IMAGES_DIR" ]; then
    echo "Fehler: Ordner $IMAGES_DIR existiert nicht!"
    exit 1
fi

# Erstelle JSON-Array
echo "{" > "$OUTPUT_FILE"
echo "  \"version\": \"2.0\"," >> "$OUTPUT_FILE"
echo "  \"generated\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"," >> "$OUTPUT_FILE"

if [ -n "$PASSWORD" ]; then
    echo "  \"password\": \"$PASSWORD\"," >> "$OUTPUT_FILE"
else
    echo "  \"password\": null," >> "$OUTPUT_FILE"
fi

echo "  \"images\": [" >> "$OUTPUT_FILE"

# Zähle Bilder
count=0
first=true

# Finde alle Bilddateien
for file in "$IMAGES_DIR"/*.{jpg,jpeg,png,gif,webp,JPG,JPEG,PNG,GIF,WEBP} 2>/dev/null; do
    if [ -f "$file" ]; then
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_FILE"
        fi
        
        filename=$(basename "$file")
        url="./images/$filename"
        upload_date=$(date -u -r "$file" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
        
        echo "    {" >> "$OUTPUT_FILE"
        echo "      \"id\": \"img_$((count + 1))\"," >> "$OUTPUT_FILE"
        echo "      \"name\": \"$filename\"," >> "$OUTPUT_FILE"
        echo "      \"url\": \"$url\"," >> "$OUTPUT_FILE"
        echo "      \"uploadDate\": \"$upload_date\"" >> "$OUTPUT_FILE"
        echo -n "    }" >> "$OUTPUT_FILE"
        
        count=$((count + 1))
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "  ]" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo ""
echo "✓ gallery.json erfolgreich generiert!"
echo "  - $count Bilder gefunden"
echo "  - Ausgabedatei: $OUTPUT_FILE"
echo ""
echo "Hinweis: Dieses Skript erstellt keine Thumbnails."
echo "Für Thumbnails verwenden Sie: python3 generate_gallery.py"
