# Blaurock Sportpix Foto Manager App - Zusammenfassung

## Übersicht
Die **Blaurock Sportpix Foto Manager App** ist eine professionelle macOS-Anwendung für die Verwaltung, Bearbeitung und den Export von Fotos, speziell optimiert für Sportfotografie. Die App kombiniert Culling-Funktionen (Bewertung und Auswahl), Bildbearbeitung, IPTC-Metadaten-Verwaltung und Export-Workflows in einer benutzerfreundlichen Oberfläche.

---

## 📁 Projektstruktur

### Hauptanwendung
- **`Blaurock_Sportpix_Foto_Manager_AppApp.swift`** - App-Einstiegspunkt, Menü-Befehle, Tastaturkürzel
- **`RootView.swift`** (3544 Zeilen) - Hauptansicht mit CullingView, Filmstreifen, Grid-Ansicht, Bildbearbeitung

### Views
- **`CropView.swift`** - Zuschneide-Funktionalität mit interaktiven Handles
- **`ExportPanel.swift`** - Export-Dialog mit Preset-Auswahl
- **`ExportPresetEditView.swift`** - Editor für Export-Presets
- **`IPTCDraftEditorView.swift`** - Editor für IPTC-Draft (PhotoMechanic-Style)
- **`IPTCTemplateEditorView.swift`** - Editor für IPTC-Templates
- **`UploadSettingsView.swift`** - Konfiguration von Upload-Zielen

### Store (State Management)
- **`PhotoStore.swift`** (2020+ Zeilen) - Zentrale Datenverwaltung, ObservableObject
- **`AppSettingsView.swift`** - Einstellungsfenster für Content-Aware Crop, Wasserzeichen, Export

### Models
- **`PhotoItem.swift`** - Foto-Datenmodell (Rating, Tags, IPTC-Metadaten, Adjustments)
- **`PhotoAdjustments.swift`** - Bildbearbeitungsparameter (Exposure, Kontrast, Temperatur, etc.)
- **`ExportPreset.swift`** - Export-Presets (Dimensionen, Qualität, Wasserzeichen)
- **`ExportSettings.swift`** - Export-Einstellungen
- **`IPTCTemplate.swift`** - IPTC-Templates mit Token-System
- **`WatermarkSettings.swift`** - Wasserzeichen-Konfiguration
- **`CropAspectRatio.swift`** - Seitenverhältnisse für Cropping
- **`FolderItem.swift`** - Ordner-Hierarchie
- **`PreviewCacheKey.swift`** - Cache-Schlüssel für Previews

### Services
- **`EditEngine.swift`** - Bildbearbeitungs-Engine (CoreImage-basiert)
- **`ExportService.swift`** - Export-Funktionalität mit Presets
- **`IPTCMetadataService.swift`** - IPTC-Metadaten schreiben/laden
- **`RatingPersistenceService.swift`** - Rating in Bild-Metadaten speichern
- **`UploadService.swift`** - Upload zu verschiedenen Zielen
- **`AutoAdjustmentService.swift`** - AI-basierte Auto-Adjustments
- **`LogoLibrary.swift`** - Logo-Verwaltung für Wasserzeichen
- **`XMPPresetParser.swift`** - XMP-Preset-Import

---

## 🎯 Hauptfunktionen

### 1. Foto-Verwaltung & Culling

#### Ordner-Verwaltung
- **Ordner-Sidebar** (Finder-ähnlich) mit:
  - Standard-Ordner (Home, Desktop, Documents, Downloads, Pictures, Photos Library)
  - Zuletzt geöffnete Ordner (bis zu 10)
  - Favoriten-Ordner
  - Ordner-Hierarchie mit Expand/Collapse
  - Volume-Erkennung (externe Karten/SSDs)
  - Unterstützung für OneDrive-Ordner

#### Foto-Anzeige
- **Filmstreifen-Ansicht**: Horizontale Miniaturansicht mit automatischem Scrollen zum ausgewählten Bild
- **Grid-Ansicht**: Rasteransicht mit LazyVGrid
- **Detail-Ansicht**: Großes Bild mit Zoom (1.0x - 5.0x)
- **Before/After-Ansicht**: Split-View zum Vergleich vor/nach Bearbeitung
- **Layout-Modi**: Umschaltbar zwischen Filmstreifen und Grid

#### Navigation
- **Tastatur-Navigation**:
  - `←` / `→`: Vorheriges/Nächstes Foto
  - `↑` / `↓`: In Grid-Ansicht (4 Fotos pro Schritt)
- **Mehrfachauswahl**:
  - `Cmd + Klick`: Einzelne Fotos auswählen/abwählen
  - `Shift + Klick`: Bereich auswählen
  - Mehrfachauswahl-Indikator im Filmstreifen

#### Filter & Sortierung
- **Rating-Filter**: Filtern nach 1-5 Sternen oder "Alle"
- **Rejected-Filter**: Abgelehnte Fotos ein-/ausblenden
- **Gefilterte Navigation**: Navigation nur innerhalb gefilterter Fotos

---

### 2. Bewertung & Markierung

#### Rating-System
- **1-5 Sterne**: Tastaturkürzel `1`-`5` oder `0` zum Löschen
- **Rejected-Markierung**: Fotos als abgelehnt markieren
- **Persistenz**: Rating wird in Bild-Metadaten gespeichert (IPTC Star Rating)

#### Tagging-System
- **Color Tags**: 8 Farben (Rot, Orange, Gelb, Grün, Blau, Lila, Pink, Grau)
- **Text Tags**: Freitext-Tags
- **Keywords**: IPTC-Keywords
- **Tags werden in Metadaten gespeichert**

---

### 3. Bildbearbeitung

#### Photo Adjustments
- **Basis-Adjustments**:
  - **Belichtung** (Exposure): -2.0 bis +2.0 EV
  - **Kontrast**: 0.5x bis 1.8x
  - **Temperatur**: -3000 bis +3000 Kelvin
  - **Tint**: -80 bis +80 (Magenta/Grün)
  - **Klarheit** (Clarity): 0.0 bis 1.0
  - **Vibrance**: -0.6 bis +1.0

- **Erweiterte Adjustments** (Lightroom Classic Style):
  - **Highlights**: -100 bis +100
  - **Shadows**: -100 bis +100
  - **Whites**: -100 bis +100
  - **Blacks**: -100 bis +100
  - **Saturation**: -100 bis +100
  - **Dehaze**: -100 bis +100
  - **Texture**: -100 bis +100

#### Presets
- **Anpassungs-Presets**: Vordefinierte Einstellungskombinationen
- **Preset-Gruppen**: Organisiert in Kategorien
- **Hover-Preview**: Vorschau beim Überfahren mit Maus
- **Preset-Import/Export**: XMP-Presets importieren, eigene Presets exportieren
- **Gruppen-Management**: Gruppen ein-/ausblenden, kollabieren/expandieren

#### Auto-Adjustments
- **AI-basierte Auto-Adjustments**: Automatische Optimierung mit einem Klick

#### Cropping & Rotation
- **Manuelles Cropping**: Interaktive Handles an allen 4 Ecken
- **Seitenverhältnisse**: Vordefinierte Ratios (1:1, 4:3, 16:9, etc.)
- **Rotation**: -180° bis +180°
- **Content-Aware Crop** (optional):
  - **Gesichtserkennung**: Automatisches Cropping auf Gesichter
  - **Zentrum**: Cropping auf Bildmitte mit Skalierung
  - Standardmäßig deaktiviert

#### Rendering
- **CoreImage-basiert**: Hochqualitative Bildverarbeitung
- **Farbraum-Konvertierung**: Optimiert für sRGB-Output
- **Preview-Caching**: Intelligentes Caching für Performance
- **Vollauflösung**: Export in Original-Auflösung möglich

---

### 4. IPTC-Metadaten

#### IPTC-Templates
- **Token-System**: Platzhalter für dynamische Werte
- **Allgemeine Tokens**: `{EVENT}`, `{LOCATION}`, `{VENUE}`, `{CITY}`, `{DATE}`, `{TIME}`, `{SUBJECT}`, `{ACTION}`, `{DESCRIPTION}`, `{PHOTOGRAPHER}`
- **Sport-spezifische Tokens**: `{TEAM_A}`, `{TEAM_B}`, `{LEAGUE}`, `{ARENA}`, `{PLAYER_NAME}`, `{PLAYER_NUMBER}`, `{SITUATION}`
- **Vordefinierte Templates**:
  - Allgemein - Event
  - Allgemein - Beschreibung
  - Eishockey Standard
  - Eishockey Spieler
  - Fussball Standard
  - Portrait

#### IPTC-Draft (PhotoMechanic-Style)
- **Vorbereitung für Upload**: Metadaten vorbereiten ohne sofort zu speichern
- **Token-Werte**: Manuelle Eingabe von Token-Werten
- **Batch-Anwendung**: Auf mehrere Fotos gleichzeitig anwenden

#### Metadaten-Verwaltung
- **Caption**: Beschreibungstext
- **Keywords**: Schlagwörter
- **Rating**: Sterne-Bewertung
- **Color Tags**: Farbige Tags (als JSON in Metadaten)
- **IPTC-Felder**: Alle Standard-IPTC-Felder unterstützt
- **XMP-Kompatibilität**: Keywords auch in XMP dc:subject

#### Speicherung
- **Persistenz**: Metadaten werden direkt in Bilddateien geschrieben
- **Atomare Operationen**: Sichere Speicherung ohne Datenverlust
- **Metadaten-Erhaltung**: Bestehende Metadaten werden beibehalten

---

### 5. Export & Speichern

#### Export-Presets
- **Vordefinierte Presets**:
  - **Agentur**: 3500px, Qualität 90%, kein Wasserzeichen
  - **Social**: 2048px, Qualität 85%, mit Wasserzeichen
  - **Webshop Pictrs**: 1920px, Qualität 80%, kein Wasserzeichen
- **Anpassbare Presets**: Eigene Presets erstellen/bearbeiten
- **Preset-Parameter**:
  - Maximale Dimension (längste Kante)
  - Qualität (JPEG 0.0-1.0)
  - Format (JPEG/PNG)
  - Wasserzeichen-Einstellungen
  - Upload-Targets

#### Export-Funktionen
- **Einzelfoto-Export**: Aktuelles Foto mit Preset exportieren
- **Batch-Export**: Mehrere Fotos gleichzeitig exportieren
- **Export-Queue**: Automatischer Export basierend auf Rating (min. 4 Sterne)
- **Fortschrittsanzeige**: Export-Progress wird angezeigt

#### Speichern
- **Original speichern**: Adjustments direkt ins Original schreiben (mit Bestätigung)
- **Als Kopie speichern**: Bearbeitete Version als neue Datei speichern
- **Metadaten-Erhaltung**: Alle Metadaten bleiben erhalten

---

### 6. Wasserzeichen

#### Wasserzeichen-Typen
- **Text**: Anpassbarer Text
- **Logo**: Bild-Logo
- **Beides**: Text + Logo kombiniert

#### Konfiguration
- **Position**: Oben Links/Rechts, Unten Links/Rechts, Mitte
- **Größe**: Relativ zur Bildgröße (5%-50%)
- **Text-Größe**: Relativ zur Bildgröße
- **Logo-Bibliothek**: Mehrere Logos verwalten
- **Vorschau**: Wasserzeichen in Preview sichtbar (optional)

---

### 7. Upload

#### Upload-Targets
- **Konfigurierbare Ziele**: Mehrere Upload-Ziele einrichten
- **Automatischer Upload**: Nach Export automatisch hochladen
- **Batch-Upload**: Mehrere Dateien gleichzeitig
- **Fortschrittsanzeige**: Upload-Progress wird angezeigt

---

### 8. Performance & Optimierung

#### Caching
- **Preview-Cache**: Intelligentes Caching von bearbeiteten Previews
- **Thumbnail-Cache**: Schnelle Miniaturansichten
- **Cache-Invalidierung**: Automatische Invalidierung bei Änderungen

#### Rendering
- **Asynchrones Rendering**: Non-blocking Bildverarbeitung
- **Debouncing**: Slider-Änderungen werden debounced für Performance
- **Lazy Loading**: Thumbnails werden nach Bedarf geladen

---

## ⌨️ Tastaturkürzel

### Navigation
- `←` / `→`: Vorheriges/Nächstes Foto
- `↑` / `↓`: In Grid-Ansicht (4 Fotos pro Schritt)

### Culling
- `1`-`5`: Rating setzen (1-5 Sterne)
- `0`: Rating löschen

### Speichern/Export
- `Cmd + S`: Original speichern
- `Cmd + E`: Als Kopie speichern

### Einstellungen
- `Cmd + ,`: Einstellungen öffnen

---

## 🎨 Benutzeroberfläche

### Layout
- **3-Spalten-Layout**:
  - **Links**: Ordner-Sidebar (220px)
  - **Mitte**: Hauptbild + Filmstreifen/Grid
  - **Rechts**: Presets & Adjustments Sidebar (280px)
- **Dark Mode**: Optimiert für Dark Mode
- **Anpassbare Sidebars**: Links/Rechts ein-/ausblenden

### Farben
- **Dark Background**: `#1C1C1F` (RGB: 28, 28, 31)
- **Dark Sidebar**: `#262629` (RGB: 38, 38, 41)
- **Dark Panel**: `#212122` (RGB: 33, 33, 34)

### Top-Tabbar
- **Speichern**: Original speichern / Als Kopie speichern
- **Export**: Export mit Presets
- **Upload**: Upload-Funktionen
- **Wasserzeichen**: Wasserzeichen-Konfiguration
- **IPTC**: IPTC-Panel
- **Ansicht**: Normal/Grid/Filmstreifen

---

## 📋 Unterstützte Dateiformate

### Eingabe
- **JPEG** (.jpg, .jpeg)
- **PNG** (.png)
- **HEIC** (.heic)
- **Photos Library** (.photoslibrary)

### Ausgabe
- **JPEG** (anpassbare Qualität)
- **PNG** (verlustfrei)

---

## 🔧 Technische Details

### Frameworks
- **SwiftUI**: Moderne UI-Framework
- **AppKit**: macOS-spezifische Funktionen
- **CoreImage**: Bildverarbeitung
- **ImageIO**: Metadaten-Verwaltung
- **Combine**: Reactive Programming
- **UniformTypeIdentifiers**: Dateityp-Erkennung

### Architektur
- **MVVM-ähnlich**: PhotoStore als zentraler State-Manager
- **Service-basiert**: Getrennte Services für verschiedene Funktionen
- **ObservableObject**: SwiftUI-Reactive State Management

### Speicherung
- **UserDefaults**: Einstellungen, Presets, Templates
- **Bookmarks**: Sichere Zugriffe auf Ordner (Security-Scoped Resources)
- **Metadaten**: Direkt in Bilddateien

---

## 🎯 Zielgruppe

Die App ist speziell für **Sportfotografen** entwickelt, die:
- Große Mengen von Fotos schnell bewerten müssen (Culling)
- Professionelle Bildbearbeitung benötigen
- IPTC-Metadaten für Agenturen verwalten müssen
- Verschiedene Export-Formate für verschiedene Zwecke benötigen
- Einen effizienten Workflow für Sportveranstaltungen brauchen

---

## 🚀 Workflow-Beispiel

1. **Ordner öffnen**: Fotos aus einem Ordner laden
2. **Culling**: Mit Pfeiltasten durch Fotos navigieren, Rating vergeben (1-5)
3. **Bearbeitung**: Presets anwenden oder manuell anpassen
4. **IPTC**: Metadaten mit Templates vorbereiten
5. **Export**: Mit Preset exportieren (z.B. "Agentur" für 3500px)
6. **Upload**: Automatisch zu konfigurierten Zielen hochladen

---

## 📝 Notizen

- Die App unterstützt **OneDrive-Ordner** mit spezieller Behandlung
- **Content-Aware Crop** ist standardmäßig deaktiviert (kann Artefakte verursachen)
- **.rrdata-Dateien** (RawTherapee) werden automatisch ignoriert
- **Filmstreifen scrollt automatisch** zum ausgewählten Bild
- **Preview-Caching** sorgt für flüssige Performance auch bei vielen Fotos

---

*Erstellt: Dezember 2025*
*Version: Aktuelle Entwicklungsversion*
