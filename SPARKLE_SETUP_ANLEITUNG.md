# Sparkle Auto-Updates Setup – Schritt-für-Schritt Anleitung

## Übersicht

Sparkle ist bereits in die App integriert. Um Updates zu aktivieren, musst du:

1. **EdDSA Keys generieren** (einmalig)
2. **Xcode Build Settings konfigurieren** (Feed URL + Public Key)
3. **Update-System einrichten** (Appcast generieren, Hosting)

---

## Schritt 1: Sparkle Tools herunterladen

Die Sparkle Tools werden benötigt, um Updates zu signieren und den Appcast zu generieren.

1. Gehe zu: https://github.com/sparkle-project/Sparkle/releases
2. Lade die neueste **Sparkle 2.x** Version herunter (z.B. `Sparkle-2.x.x.tar.bz2`)
3. Entpacke das Archiv
4. Du findest die Tools im Ordner (z.B. `Sparkle-2.x.x/bin/`):
   - `generate_keys` – generiert Signatur-Keys
   - `sign_update` – signiert einzelne Updates
   - `generate_appcast` – generiert den Appcast (XML-Feed)

---

## Schritt 2: EdDSA Keys generieren (einmalig)

Die Keys dienen zur kryptographischen Signatur der Updates.

1. Öffne das Terminal
2. Navigiere zum Ordner mit den Sparkle Tools (z.B. `cd ~/Downloads/Sparkle-2.x.x/bin/`)
3. Führe aus:

```bash
./generate_keys
```

**Wichtig:** Du bekommst zwei Keys:
- **Public Key** (öffentlich) → kommt in die App (Xcode Build Settings)
- **Private Key** (geheim) → bleibt bei dir lokal (zum Signieren der Updates)

**Sicherheit:** Bewahre den Private Key sicher auf! Ohne ihn kannst du keine Updates signieren.

**Ausgabe sieht etwa so aus:**

```
Generating Ed25519 key pair...
Public key: 3lK9j2kL... (lange Zeichenkette)
Private key saved to: ./eddsa_private_key
```

Kopiere den **Public Key** (die lange Zeichenkette) – du brauchst ihn für Xcode.

---

## Schritt 3: Xcode Build Settings konfigurieren

Die Feed URL und der Public Key müssen in Xcode eingetragen werden.

### 3.1 Xcode öffnen

1. Öffne das Projekt in Xcode
2. Wähle das **Target "WB Foto Manager"** (links im Navigator)
3. Gehe zum Tab **"Build Settings"**
4. Suche nach **"Info.plist"** (Suchfeld oben rechts) oder scroll nach unten

### 3.2 Feed URL eintragen

1. Finde **"Info.plist Values"** oder suche nach `INFOPLIST_KEY_SUFeedURL`
2. Falls der Eintrag nicht existiert:
   - Klicke auf **"+"** (oben links)
   - Wähle **"Add User-Defined Setting"**
   - Name: `INFOPLIST_KEY_SUFeedURL`
3. Setze den Wert auf deine Appcast-URL (z.B. `https://dein-server.com/updates/appcast.xml`)

**Beispiel:**
```
INFOPLIST_KEY_SUFeedURL = https://example.com/wb-foto-manager/appcast.xml
```

⚠️ **Wichtig:** Die URL muss **HTTPS** verwenden (nicht HTTP)!

### 3.3 Public Key eintragen

1. Suche nach `INFOPLIST_KEY_SUPublicEDKey` (oder erstelle den Eintrag wie oben)
2. Setze den Wert auf deinen **Public Key** (den du in Schritt 2 generiert hast)

**Beispiel:**
```
INFOPLIST_KEY_SUPublicEDKey = 3lK9j2kLmN8pQrS5tUvWxYzA1bC3dE5fG7hI9jK1lM3nO5pQ7rS9tUvWxYzA
```

### 3.4 Optionale Einstellungen (empfohlen)

Füge diese Einstellungen hinzu für automatische Update-Checks:

1. **`INFOPLIST_KEY_SUEnableAutomaticChecks`** = `YES`
   - Aktiviert automatische Update-Prüfungen im Hintergrund

2. **`INFOPLIST_KEY_SUScheduledCheckInterval`** = `86400`
   - Intervall in Sekunden (86400 = 1 Tag)
   - Die App prüft dann täglich auf Updates

### 3.5 Build Settings für Debug vs. Release

**Wichtig:** Diese Einstellungen sollten für **beide Konfigurationen** (Debug und Release) gesetzt werden, oder nur für Release, wenn du Updates nur für Release-Builds bereitstellen willst.

- In Xcode Build Settings kannst du die Konfiguration auswählen (Debug/Release)
- Setze die Werte für die gewünschte(n) Konfiguration(en)

---

## Schritt 4: Build & Test (ohne Updates)

1. Baue die App in Xcode (⌘+B)
2. Die App sollte jetzt Sparkle unterstützen
3. Im Menü **"WB Foto Manager"** → **"Nach Updates suchen…"** sollte erscheinen
4. Ohne Feed-URL wird es noch keine Updates finden (das ist normal)

---

## Schritt 5: Update-System einrichten (für echte Updates)

### 5.1 App bauen & signieren

1. Baue eine **Release-Version** der App
2. Signiere und notarisiere die App (wie gewohnt mit deinen Scripts)
3. Erstelle ein ZIP oder DMG (z.B. `WB Foto Manager 1.0.zip`)

### 5.2 Update signieren & Appcast generieren

1. Kopiere die gebaute App (oder das ZIP) in einen Release-Ordner
2. Benenne die Datei mit Versionsnummer (z.B. `WB Foto Manager 1.0.zip`)
3. Verwende die Sparkle Tools:

```bash
# Beispiel-Pfad anpassen!
./generate_appcast \
  --download-url-prefix "https://dein-server.com/updates/" \
  --ed-key-file "./eddsa_private_key" \
  /Pfad/zu/deinem/Release-Ordner/
```

Dies erzeugt:
- `appcast.xml` – der Feed, den Sparkle abruft
- Signierte Metadaten für die Update-Dateien

### 5.3 Hosting einrichten

1. Lade `appcast.xml` auf deinen Server hoch (HTTPS!)
2. Lade die Update-Dateien (ZIP/DMG) hoch
3. Stelle sicher, dass beide über HTTPS erreichbar sind

**Beispiel-Struktur:**
```
https://dein-server.com/updates/
  ├── appcast.xml
  └── WB Foto Manager 1.0.zip
```

### 5.4 Testen

1. Öffne die **alte Version** der App (z.B. Version 1.0)
2. Klicke auf **"WB Foto Manager"** → **"Nach Updates suchen…"**
3. Sparkle sollte die neue Version finden und zum Installieren anbieten

---

## Zusammenfassung: Was du in Xcode setzen musst

In **Xcode → Target "WB Foto Manager" → Build Settings → Info.plist Values**:

| Key | Wert (Beispiel) | Erklärung |
|-----|-----------------|-----------|
| `INFOPLIST_KEY_SUFeedURL` | `https://dein-server.com/updates/appcast.xml` | URL zum Appcast-Feed (HTTPS!) |
| `INFOPLIST_KEY_SUPublicEDKey` | `3lK9j2kLmN8pQ...` | Dein Public Key (aus Schritt 2) |
| `INFOPLIST_KEY_SUEnableAutomaticChecks` | `YES` | (Optional) Automatische Checks aktivieren |
| `INFOPLIST_KEY_SUScheduledCheckInterval` | `86400` | (Optional) Check-Intervall in Sekunden |

---

## Troubleshooting

### "Nach Updates suchen" funktioniert nicht

- Prüfe, ob `INFOPLIST_KEY_SUFeedURL` und `INFOPLIST_KEY_SUPublicEDKey` gesetzt sind
- Baue die App neu (Clean Build Folder: ⌘+Shift+K, dann ⌘+B)
- Prüfe in der Konsole (Console.app), ob Fehler erscheinen

### Updates werden nicht gefunden

- Prüfe, ob die Feed URL korrekt ist und über HTTPS erreichbar ist
- Prüfe, ob die `appcast.xml` gültiges XML ist
- Prüfe, ob die Versionsnummern korrekt sind (neue Version muss höher sein)

### Signatur-Fehler

- Stelle sicher, dass der Private Key korrekt verwendet wird
- Prüfe, ob der Public Key in Xcode korrekt eingetragen ist (keine Leerzeichen am Anfang/Ende)

---

## Weitere Ressourcen

- Sparkle Dokumentation: https://sparkle-project.org/documentation/
- Sparkle GitHub: https://github.com/sparkle-project/Sparkle

---

## Notizen für später

- Für interne/Test-Builds: Du kannst auch eine lokale URL verwenden (z.B. für Tests)
- Für Produktion: Verwende einen zuverlässigen HTTPS-Server
- Versionsnummern: Sparkle vergleicht `CFBundleVersion` (CURRENT_PROJECT_VERSION in Xcode)

