# 🚀 Quick Start - WebApp zum Laufen bringen

Deine Seite ist bereits unter **https://noudi72.github.io/WB_Foto_Manager/** eingerichtet!

## Was du jetzt noch machen musst:

### 1️⃣ Bilder hochladen

**Über GitHub Web-Interface (einfachste Methode):**

1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager
2. Klicke auf **"Add file"** → **"Upload files"**
3. Erstelle einen Ordner `images/` (im Upload-Dialog)
4. Ziehe deine Bilder hinein
5. Klicke auf **"Commit changes"**

### 2️⃣ gallery.json erstellen

**Option A: Mit Python (empfohlen)**

```bash
cd ~/Desktop  # oder wo dein Repository ist
git clone https://github.com/noudi72/WB_Foto_Manager.git
cd WB_Foto_Manager

# Installiere Pillow
pip3 install Pillow

# Generiere gallery.json
python3 WebApp/generate_gallery.py --images-dir images/ --output WebApp/gallery.json
```

**Option B: Mit Shell-Skript (einfacher)**

```bash
cd ~/Desktop/WB_Foto_Manager
./WebApp/generate_gallery.sh images/ WebApp/gallery.json
```

**Option C: Manuell (falls Skripte nicht funktionieren)**

1. Öffne `WebApp/gallery.json`
2. Ersetze mit diesem Beispiel (passe die Dateinamen an):

```json
{
  "version": "2.0",
  "generated": "2026-01-14T20:00:00Z",
  "password": null,
  "images": [
    {
      "id": "img_1",
      "name": "bild1.jpg",
      "url": "./images/bild1.jpg",
      "uploadDate": "2026-01-14T20:00:00Z"
    },
    {
      "id": "img_2",
      "name": "bild2.jpg",
      "url": "./images/bild2.jpg",
      "uploadDate": "2026-01-14T20:00:00Z"
    }
  ]
}
```

### 3️⃣ gallery.json hochladen

**Über GitHub:**

1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager/tree/main/WebApp
2. Klicke auf `gallery.json` → Stift-Symbol (Edit)
3. Ersetze den Inhalt mit deiner generierten JSON
4. Klicke auf **"Commit changes"**

**Oder über Terminal:**

```bash
git add WebApp/gallery.json
git commit -m "gallery.json aktualisiert"
git push
```

### 4️⃣ Fertig!

Warte 1-2 Minuten, dann sollte deine Galerie unter https://noudi72.github.io/WB_Foto_Manager/ funktionieren! 🎉

---

## ❓ Hilfe benötigt?

- **Bilder werden nicht angezeigt?** → Prüfe die Browser-Konsole (F12)
- **Fehler beim Laden?** → Prüfe ob `gallery.json` korrekt ist: https://noudi72.github.io/WB_Foto_Manager/gallery.json
- **Skript funktioniert nicht?** → Verwende Option C (manuell)
