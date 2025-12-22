# Xcode-Einstellungen für WB Foto Manager

## Wichtige Einstellungen für Dateizugriff

Die App benötigt spezielle Berechtigungen, um auf externe Laufwerke, OneDrive-Ordner und andere Verzeichnisse zugreifen zu können.

### 1. App Sandbox Einstellungen

In Xcode: **Target → Signing & Capabilities → App Sandbox**

**Wichtig:** Die folgenden Einstellungen sollten aktiviert sein:

- ✅ **User Selected File** → `Read/Write` (ermöglicht Zugriff auf vom Benutzer ausgewählte Dateien)
- ✅ **Downloads Folder** → `Read/Write` (für Downloads-Ordner)
- ✅ **Pictures Folder** → `Read/Write` (für Pictures-Ordner)
- ✅ **Outgoing Network Connections** (für Upload-Funktionen)
- ✅ **Incoming Network Connections** (für Upload-Funktionen)

### 2. Hardened Runtime

**Target → Signing & Capabilities → Hardened Runtime**

- ✅ **Hardened Runtime** sollte aktiviert sein
- ✅ **Runtime Exceptions** können für Debugging aktiviert werden

### 3. Info.plist Einstellungen (falls vorhanden)

Falls Sie eine Info.plist-Datei haben, sollten folgende Keys gesetzt sein:

```xml
<key>NSAppleEventsUsageDescription</key>
<string>Die App benötigt Zugriff auf Apple Events für Automatisierung.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Die App benötigt Zugriff auf Ihre Fotos.</string>
```

### 4. Berechtigungen beim ersten Start

Beim ersten Öffnen eines Ordners wird macOS nach Berechtigung fragen:
- **Klicken Sie auf "Öffnen"** im Dialog
- Die App speichert dann ein Security-Scoped Bookmark für persistente Zugriffe

### 5. Externe Laufwerke

Für externe Laufwerke (SSD, USB-Sticks, etc.):
- Die App erkennt diese automatisch in der Sidebar unter "Laufwerke"
- Sie können direkt darauf klicken oder den "Ordner öffnen"-Dialog verwenden

### 6. OneDrive / Netzwerk-Volumes

Für OneDrive und andere Netzwerk-Volumes:
- Stellen Sie sicher, dass das Volume im Finder gemountet ist
- Die App zeigt es automatisch unter "Laufwerke" an
- Sie können direkt darauf klicken

### 7. Debugging

Falls die App keinen Zugriff auf Ordner hat:
1. Prüfen Sie die Console für Fehlermeldungen
2. Stellen Sie sicher, dass `ENABLE_USER_SELECTED_FILES = readwrite` in den Build Settings gesetzt ist
3. Testen Sie mit einem Ordner im Home-Verzeichnis zuerst

## Aktuelle Build Settings

Die App hat bereits folgende Einstellungen:
- ✅ App Sandbox: Aktiviert
- ✅ User Selected Files: Read/Write
- ✅ Network Connections: Aktiviert
- ✅ Hardened Runtime: Aktiviert

Diese Einstellungen sollten ausreichen für den Zugriff auf:
- Standard-Ordner (Home, Desktop, Documents, etc.)
- Externe Laufwerke
- Netzwerk-Volumes (OneDrive, etc.)
- Benutzer-ausgewählte Ordner

