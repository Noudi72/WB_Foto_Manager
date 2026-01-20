# Schritt-für-Schritt: WebApp zum Laufen bringen

Deine Seite ist bereits unter https://noudi72.github.io/WB_Foto_Manager/ eingerichtet! 🎉

Jetzt musst du nur noch:

## ✅ Schritt 1: Bilder vorbereiten

1. Erstelle einen Ordner auf deinem Mac (z.B. `~/Desktop/galerie-bilder/`)
2. Kopiere deine Bilder dorthin
3. **Wichtig**: 
   - Bilder sollten nicht zu groß sein (max. 5-10 MB pro Bild)
   - Dateinamen ohne Leerzeichen (z.B. `bild1.jpg` statt `bild 1.jpg`)

## ✅ Schritt 2: Repository klonen (falls noch nicht geschehen)

```bash
cd ~/Desktop
git clone https://github.com/noudi72/WB_Foto_Manager.git
cd WB_Foto_Manager
```

## ✅ Schritt 3: Bilder hochladen

### Option A: Über GitHub Web-Interface (einfachste Methode)

1. Gehe zu https://github.com/noudi72/WB_Foto_Manager
2. Klicke auf "Add file" → "Upload files"
3. Erstelle einen neuen Ordner `images/` (klicke auf "Add file" → "Create new file", dann `images/.gitkeep` erstellen)
4. Oder: Klicke direkt auf "Add file" → "Upload files" und erstelle den Ordner `images/` im Upload-Dialog
5. Ziehe deine Bilder in den Upload-Bereich
6. Scrolle nach unten, schreibe "Bilder hinzugefügt" als Commit-Message
7. Klicke auf "Commit changes"

### Option B: Über Terminal (wenn du Git verwendest)

```bash
# Im Repository-Ordner
mkdir -p images
cp ~/Desktop/galerie-bilder/*.jpg images/  # Passe den Pfad an
git add images/
git commit -m "Bilder hinzugefügt"
git push
```

## ✅ Schritt 4: gallery.json generieren

### Option A: Mit Python (empfohlen - erstellt Thumbnails)

```bash
# Im Repository-Ordner
cd ~/Desktop/WB_Foto_Manager

# Installiere Pillow falls nötig
pip3 install Pillow

# Generiere gallery.json
python3 WebApp/generate_gallery.py --images-dir images/ --output WebApp/gallery.json
```

### Option B: Mit Shell-Skript (einfacher, keine Thumbnails)

```bash
# Im Repository-Ordner
cd ~/Desktop/WB_Foto_Manager
./WebApp/generate_gallery.sh images/ WebApp/gallery.json
```

### Option C: Manuell (falls Skripte nicht funktionieren)

1. Öffne `WebApp/gallery.json` in einem Texteditor
2. Ersetze den Inhalt mit:

```json
{
  "version": "2.0",
  "generated": "2026-01-14T20:00:00Z",
  "password": null,
  "images": [
    {
      "id": "img_1",
      "name": "DEIN_BILDNAME.jpg",
      "url": "./images/DEIN_BILDNAME.jpg",
      "uploadDate": "2026-01-14T20:00:00Z"
    }
  ]
}
```

3. Füge für jedes Bild ein neues Objekt im `images` Array hinzu
4. Passe die Dateinamen an

## ✅ Schritt 5: gallery.json hochladen

### Über GitHub Web-Interface:

1. Gehe zu https://github.com/noudi72/WB_Foto_Manager
2. Navigiere zu `WebApp/gallery.json`
3. Klicke auf das Stift-Symbol (Edit)
4. Ersetze den Inhalt mit deiner generierten `gallery.json`
5. Scrolle nach unten, schreibe "gallery.json aktualisiert" als Commit-Message
6. Klicke auf "Commit changes"

### Über Terminal:

```bash
# Im Repository-Ordner
git add WebApp/gallery.json
git commit -m "gallery.json aktualisiert"
git push
```

## ✅ Schritt 6: Warten und prüfen

1. Warte 1-2 Minuten (GitHub Pages braucht etwas Zeit)
2. Gehe zu https://noudi72.github.io/WB_Foto_Manager/
3. Die Galerie sollte jetzt deine Bilder anzeigen! 🎉

## 🔍 Troubleshooting

### "Fehler beim Laden der Bilder"

**Problem**: Die `gallery.json` ist nicht korrekt oder die Bild-URLs stimmen nicht.

**Lösung**:
1. Öffne die Browser-Konsole (F12 → Console)
2. Schaue nach Fehlermeldungen
3. Prüfe, ob `gallery.json` korrekt ist:
   - Gehe zu https://noudi72.github.io/WB_Foto_Manager/gallery.json
   - Die JSON sollte gültig sein
4. Prüfe, ob die Bild-URLs stimmen:
   - Gehe zu https://noudi72.github.io/WB_Foto_Manager/images/DEIN_BILDNAME.jpg
   - Das Bild sollte laden

### "Keine Bilder gefunden"

**Problem**: Die `gallery.json` ist leer oder existiert nicht.

**Lösung**:
1. Prüfe, ob `gallery.json` im `WebApp/` Ordner ist
2. Prüfe, ob die JSON-Struktur korrekt ist (siehe Option C oben)
3. Stelle sicher, dass die Bild-URLs mit `./images/` beginnen

### Bilder werden nicht angezeigt

**Problem**: Die Bilder sind zu groß oder die URLs sind falsch.

**Lösung**:
1. Komprimiere große Bilder (z.B. mit ImageOptim oder TinyPNG)
2. Prüfe die Dateinamen (keine Leerzeichen, keine Sonderzeichen)
3. Stelle sicher, dass die Bilder im `images/` Ordner sind (nicht in `WebApp/images/`)

## 📝 Checkliste

- [ ] Bilder in `images/` Ordner hochgeladen
- [ ] `gallery.json` generiert/aktualisiert
- [ ] `gallery.json` auf GitHub hochgeladen
- [ ] 1-2 Minuten gewartet
- [ ] Seite neu geladen (Strg+Shift+R / Cmd+Shift+R)

## 🎯 Schnellstart (wenn alles lokal ist)

```bash
# 1. Repository klonen/öffnen
cd ~/Desktop/WB_Foto_Manager

# 2. Bilder kopieren
mkdir -p images
cp ~/Pfad/zu/deinen/bildern/*.jpg images/

# 3. gallery.json generieren
python3 WebApp/generate_gallery.py --images-dir images/ --output WebApp/gallery.json

# 4. Alles committen und pushen
git add images/ WebApp/gallery.json
git commit -m "Galerie aktualisiert"
git push
```

Fertig! 🎉
