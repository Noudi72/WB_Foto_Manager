# 📤 Bilder zu GitHub hochladen - Anleitung

## 🚀 Schnellstart (Automatisch)

Das einfachste ist, das automatische Script zu verwenden:

```bash
./scripts/upload_to_github.sh
```

Das Script:
- ✅ Prüft welche Bilder neu/geändert sind
- ✅ Fügt Bilder automatisch zu Git hinzu
- ✅ Fügt `gallery.json` hinzu (falls geändert)
- ✅ Erstellt einen Commit
- ✅ Pusht alles zu GitHub

## 📋 Manueller Workflow

Falls Sie lieber manuell arbeiten möchten:

### 1. Bilder vorbereiten

Stellen Sie sicher, dass alle Bilder im `images/` Ordner sind:

```bash
# Prüfen welche Bilder vorhanden sind
ls -la images/
```

### 2. Bilder zu Git hinzufügen

```bash
# Alle neuen Bilder hinzufügen
git add images/

# Oder nur bestimmte Bilder
git add images/2J4A0331.JPG images/2J4A0354.JPG
```

### 3. gallery.json hinzufügen

```bash
git add gallery.json
```

### 4. Commit erstellen

```bash
git commit -m "WebApp: Neue Bilder hinzugefügt"
```

### 5. Zu GitHub pushen

```bash
git push origin main
```

## ⚠️ Wichtige Hinweise

### Dateigröße
- GitHub hat ein Limit von **100 MB pro Datei**
- Große Bilder sollten vorher komprimiert werden
- Empfohlen: JPEG mit Qualität 85-90%

### Viele Bilder auf einmal
Wenn Sie viele Bilder auf einmal hochladen:

```bash
# Schrittweise vorgehen (z.B. 20 Bilder pro Commit)
git add images/2J4A*.JPG
git commit -m "WebApp: Erste 20 Bilder"
git push origin main

# Dann nächste Batch
git add images/2J4B*.JPG
git commit -m "WebApp: Nächste 20 Bilder"
git push origin main
```

### Thumbnails
Thumbnails werden automatisch erstellt, wenn Sie `generate_gallery.py` verwenden:

```bash
cd WebApp
python3 generate_gallery.py --gallery-name "Meine Galerie" images/
```

## 🔍 Troubleshooting

### "Updates were rejected"
```bash
# Zuerst remote Änderungen holen
git pull origin main --no-rebase

# Dann nochmal pushen
git push origin main
```

### "File too large"
- Komprimieren Sie die Bilder
- Oder verwenden Sie Git LFS (Large File Storage)

### Bilder werden nicht angezeigt
1. Prüfen Sie ob die Dateinamen in `gallery.json` korrekt sind
2. Prüfen Sie ob die Bilder wirklich im `images/` Ordner auf GitHub sind
3. Warten Sie 1-2 Minuten (GitHub Pages Cache)

## 📝 Workflow-Zusammenfassung

1. **Admin-Seite öffnen**: https://noudi72.github.io/WB_Foto_Manager/admin.html
2. **Galerie erstellen/bearbeiten**: Drag-and-Drop für Dateinamen
3. **gallery.json herunterladen**: Button klicken
4. **Bilder hochladen**: 
   - Script: `./scripts/upload_to_github.sh`
   - Oder manuell: `git add images/ && git commit && git push`
5. **gallery.json hochladen**: `git add gallery.json && git commit && git push`

## 🎯 Tipps

- **Thumbnails automatisch erstellen**: Verwenden Sie `generate_gallery.py`
- **Batch-Upload**: Verwenden Sie das Script für mehrere Bilder
- **Prüfen vor Push**: `git status` zeigt was geändert wird
- **Backup**: Vor großen Änderungen `git stash` verwenden
