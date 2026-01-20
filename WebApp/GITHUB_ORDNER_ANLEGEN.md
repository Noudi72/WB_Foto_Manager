# 📁 Ordner in GitHub anlegen - So geht's!

## Methode 1: Über "Upload files" (EINFACHSTE METHODE) ✅

**Du musst keinen Ordner extra anlegen!** GitHub erstellt den Ordner automatisch, wenn du Dateien hochlädst.

### Schritt-für-Schritt:

1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager
2. Klicke auf **"Add file"** → **"Upload files"**
3. **WICHTIG**: Im Upload-Dialog, gib einfach `images/` vor dem Dateinamen ein!
   - Statt `bild1.jpg` → gib ein: `images/bild1.jpg`
   - GitHub erstellt den `images/` Ordner automatisch!
4. Ziehe deine Bilder in den Upload-Bereich
5. Klicke auf **"Commit changes"**

**Fertig!** Der `images/` Ordner wird automatisch erstellt! 🎉

---

## Methode 2: Über "Create new file"

1. Gehe zu: https://github.com/noudi72/WB_Foto_Manager
2. Klicke auf **"Add file"** → **"Create new file"**
3. Gib ein: `images/.gitkeep` (oder `images/README.md`)
4. Scrolle nach unten
5. Klicke auf **"Commit new file"**
6. Jetzt kannst du weitere Dateien in `images/` hochladen

---

## Methode 3: Automatisch mit dem Setup-Skript

Führe einfach das Setup-Skript aus - es erstellt alles automatisch:

```bash
cd ~/Desktop/WB_Foto_Manager
bash WebApp/setup_und_push.sh
```

Das Skript:
- ✅ Erstellt den `images/` Ordner automatisch
- ✅ Generiert die `gallery.json`
- ✅ Bereitet alles für Git vor
- ✅ Zeigt dir, wie du es pushen kannst

---

## 💡 Tipp

**Am einfachsten**: Verwende Methode 1! Du musst nur `images/` vor dem Dateinamen eingeben, und GitHub erstellt den Ordner automatisch.

Beispiel:
- Datei: `mein-bild.jpg`
- Im Upload-Dialog eingeben: `images/mein-bild.jpg`
- → GitHub erstellt automatisch den `images/` Ordner! ✨
