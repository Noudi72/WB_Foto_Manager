# Sparkle Setup – Einfache Version

## 🎯 Ziel
Auto-Updates für interne/kollegiale Nutzung **ohne eigenen Server**.

---

## Option 1: GitHub Releases (Empfohlen – Am Einfachsten)

Wenn du ein GitHub-Repository hast, ist das die einfachste Lösung.

### Vorteile:
- ✅ Kein eigener Server nötig
- ✅ Kostenlos
- ✅ Automatisches HTTPS
- ✅ Einfaches Upload über GitHub Web-Interface

### Was du brauchst:
1. Ein GitHub-Repository (öffentlich oder privat)
2. Sparkle Tools (siehe unten)
3. 5 Minuten Zeit

---

## Schritt 1: Sparkle Tools herunterladen

1. Gehe zu: https://github.com/sparkle-project/Sparkle/releases
2. Lade die neueste **Sparkle 2.x** Version herunter (z.B. `Sparkle-2.5.0.tar.bz2`)
3. Entpacke das Archiv
4. Öffne den Ordner `Sparkle-2.x.x/bin/` im Finder

**Du brauchst nur diese Datei:**
- `generate_keys` (für Schritt 2)

---

## Schritt 2: Keys generieren (einmalig, 1 Minute)

1. Öffne das Terminal
2. Ziehe die Datei `generate_keys` in das Terminal (fügt automatisch den Pfad ein)
3. Drücke Enter

**Ausgabe:**
```
Public key: 3lK9j2kLmN8pQrS5tUvWxYzA1bC3dE5fG7hI9jK1lM3nO5pQ7rS9tUvWxYzA
Private key saved to: ./eddsa_private_key
```

**Wichtig:** 
- Kopiere den **Public Key** (die lange Zeichenkette) → für Schritt 3
- Die Datei `eddsa_private_key` bleibt im aktuellen Ordner (Finder zeigt den Pfad an)

---

## Schritt 3: Xcode konfigurieren (2 Minuten)

### So geht's:

1. **Xcode öffnen** → Projekt öffnen
2. **Links im Navigator:** Klicke auf **"WB Foto Manager"** (ganz oben, das blaue Icon)
3. **Mitte:** Wähle das Target **"WB Foto Manager"** (unter "TARGETS")
4. **Oben:** Tab **"Info"** klicken (neben "Build Settings")
5. **Unten:** Klicke auf **"+"** (neben "Custom macOS Application Target Properties")
6. **Zwei neue Einträge hinzufügen:**

**Eintrag 1:**
- **Key:** `SUFeedURL`
- **Type:** String
- **Value:** `https://github.com/DEIN-USERNAME/DEIN-REPO/releases/latest/download/appcast.xml`
  - Ersetze `DEIN-USERNAME` und `DEIN-REPO` mit deinen GitHub-Daten
  - Beispiel: `https://github.com/noelguyaz/wb-foto-manager/releases/latest/download/appcast.xml`

**Eintrag 2:**
- **Key:** `SUPublicEDKey`
- **Type:** String
- **Value:** Der Public Key aus Schritt 2 (einfach einfügen)

7. **Fertig!** → Build (⌘+B)

---

## Schritt 4: Update hochladen (bei jedem Update)

### 4.1 App bauen
- Normale Release-Build in Xcode
- Erstelle ZIP: Rechtsklick auf App → "Komprimieren" → umbenennen zu `WB Foto Manager 1.1.zip` (mit Versionsnummer)

### 4.2 GitHub Release erstellen

1. Gehe zu deinem GitHub Repository
2. Klicke auf **"Releases"** (rechts)
3. **"Create a new release"** klicken
4. **Tag:** `v1.1` (oder Versionsnummer)
5. **Title:** `Version 1.1` (oder wie du willst)
6. **Beschreibung:** Optional
7. **ZIP hochladen:** Ziehe deine `WB Foto Manager 1.1.zip` in den "Attach binaries" Bereich
8. **"Publish release"** klicken

### 4.3 Appcast generieren (2 Minuten)

**Option A: Mit GitHub Releases URL (Empfohlen)**

GitHub Releases hat bereits einen automatischen Download-Link. Du kannst den Appcast manuell erstellen:

1. Öffne den Sparkle-Ordner `Sparkle-2.x.x/bin/` im Terminal
2. Erstelle eine einfache `appcast.xml` (siehe Vorlage unten)
3. Lade die `appcast.xml` als Release Asset hoch (zusätzlich zum ZIP)

**Oder:** Verwende `generate_appcast` Tool (wenn du mehrere Releases hochgeladen hast):

```bash
./generate_appcast \
  --download-url-prefix "https://github.com/DEIN-USERNAME/DEIN-REPO/releases/download/v" \
  --ed-key-file "./eddsa_private_key" \
  /Pfad/zu/deinen/Releases/
```

**Wichtig:** Für GitHub Releases musst du den Download-URL-Prefix anpassen:
- GitHub-Format: `https://github.com/USER/REPO/releases/download/vVERSION/Dateiname.zip`
- Der Prefix sollte enden mit `/v` (ohne Versionsnummer)

### Appcast XML Vorlage (für GitHub Releases):

```xml
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>WB Foto Manager</title>
    <description>WB Foto Manager Updates</description>
    <language>de</language>
    <item>
      <title>Version 1.1</title>
      <description><![CDATA[
        Neue Features und Bugfixes.
      ]]></description>
      <pubDate>Mon, 01 Jan 2025 12:00:00 +0000</pubDate>
      <enclosure url="https://github.com/DEIN-USERNAME/DEIN-REPO/releases/download/v1.1/WB%20Foto%20Manager%201.1.zip"
                 sparkle:version="1.1"
                 sparkle:shortVersionString="1.1"
                 type="application/zip"
                 sparkle:edSignature="HIER-KOMMT-DIE-SIGNATUR-REIN" />
    </item>
  </channel>
</rss>
```

**Für die Signatur:** Verwende das `sign_update` Tool oder lasse `generate_appcast` es automatisch machen.

---

## Option 2: Dropbox Public Folder (Noch Einfacher, aber weniger elegant)

Wenn du kein GitHub Repository hast:

1. **Dropbox-Ordner** erstellen (öffentlich freigegeben)
2. **Share-Link** kopieren
3. **Link anpassen:** `?dl=0` am Ende durch `?dl=1` ersetzen
4. Diese URL in `SUFeedURL` eintragen

**Nachteil:** Dropbox-Links sind lang und nicht so schön wie GitHub Releases.

---

## Option 3: Sparkle vorerst deaktivieren

Wenn das alles zu kompliziert ist, kannst du Sparkle auch vorerst **auskommentieren** und Updates manuell verteilen (z.B. per E-Mail, AirDrop, etc.).

Die App funktioniert auch ohne Sparkle-Konfiguration – das Menü "Nach Updates suchen…" findet dann einfach keine Updates (was OK ist).

---

## Zusammenfassung – Minimal Setup (GitHub)

1. ✅ Sparkle Tools herunterladen (1 Min)
2. ✅ Keys generieren: `./generate_keys` (1 Min)
3. ✅ Xcode: Zwei Einträge in "Info" Tab hinzufügen (2 Min)
4. ✅ Bei Updates: ZIP auf GitHub Releases hochladen + Appcast generieren (5 Min)

**Gesamtzeit:** ~10 Minuten fürs erste Setup, dann ~5 Minuten pro Update

---

## Hilfe bei Problemen

**"Nach Updates suchen" findet nichts:**
- Normal, solange noch kein Release auf GitHub ist
- Prüfe, ob `SUFeedURL` und `SUPublicEDKey` in Xcode gesetzt sind
- Baue die App neu (⌘+Shift+K, dann ⌘+B)

**Xcode "Info" Tab:**
- Falls du den "Info" Tab nicht siehst: Target auswählen → Tab "Info" (neben "Build Settings")
- Falls kein "+" Button: Klicke auf "Custom macOS Application Target Properties" Bereich

**GitHub Releases:**
- Repository muss existieren (kann auch privat sein)
- Release muss "Published" sein (nicht Draft)
- ZIP-Datei muss als Asset hochgeladen sein

---

## Noch einfacher?

Wenn du GitHub nicht nutzen willst, sag Bescheid – dann können wir eine noch einfachere Lösung finden (z.B. manuelle Updates per Download-Link) oder Sparkle vorerst deaktivieren.

