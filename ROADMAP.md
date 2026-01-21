# WB Foto Manager - Entwicklungs-Roadmap

**Stand: Januar 2025**  
**Ziel: Professionelle Foto-Management-App für privaten Gebrauch**

---

## 🎯 Strategische Ausrichtung

### Vision
Eine leistungsstarke, Lightroom-ähnliche Foto-Management-App mit spezialisierten Workflows für Sport und Astrofotografie, optimiert für macOS und private Nutzung.

### Prioritäten
1. **Sport-Workflow** (Hauptfokus) - Schnell, effizient, tastaturgesteuert
2. **Lightroom-Features** (schrittweise) - Professionelle Bearbeitung
3. **Spezialisierte Features** (nach Bedarf) - Astrofotografie, etc.

---

## 📋 Phase 1: Sport-Workflow Optimierung (Priorität: HOCH)

### 1.1 Performance & Geschwindigkeit
- [ ] **Burst-Detection Optimierung**
  - Schnellere Gruppierung bei sehr großen Serien (1000+ Bilder)
  - Intelligente Vorschau-Generierung für Bursts
  - Memory-Optimierung für große Serien

- [ ] **Grid-View Performance**
  - Virtuelles Scrolling für sehr große Galerien (10.000+ Bilder)
  - Intelligentes Prefetching basierend auf Scroll-Richtung
  - Thumbnail-Cache-Optimierung

- [ ] **Keyboard-Navigation Verbesserungen**
  - Schnellere Reaktion auf Tastendrücke
  - Debouncing für wiederholte Tastenanschläge
  - Bessere Fokus-Verwaltung

### 1.2 Culling-Workflow
- [ ] **Smart Filters erweitern**
  - Filter nach Schärfe (Fokus-Peaking)
  - Filter nach Gesichtsausdruck (wenn AI verfügbar)
  - Filter nach Bewegungsunschärfe

- [ ] **Burst-Management**
  - Automatische Best-Shot-Erkennung in Bursts
  - Schneller Vergleich innerhalb von Bursts
  - Batch-Aktionen für ganze Bursts

- [ ] **Rating-System erweitern**
  - 0-10 Rating-Skala (optional)
  - Farb-Tags für verschiedene Kategorien
  - Kombinierte Filter (z.B. "4+ Sterne UND Grün")

### 1.3 Export & Workflow
- [ ] **Export-Presets erweitern**
  - Wasserzeichen-Templates
  - Automatische Größenanpassung für verschiedene Plattformen
  - Batch-Renaming mit Variablen

- [ ] **Upload-Integration**
  - Direkter Upload zu Fotoagenturen
  - FTP/SFTP Verbesserungen
  - Cloud-Sync (optional)

---

## 📋 Phase 2: Lightroom-Features (Priorität: MITTEL)

### 2.1 Adjustments erweitern
- [ ] **Texture & Clarity**
  - Texture-Slider (wie Lightroom)
  - Clarity-Verbesserungen
  - Dehaze-Optimierungen

- [ ] **HSL erweitern**
  - Luminance pro Farbe (bereits vorhanden, optimieren)
  - Saturation pro Farbe (bereits vorhanden, optimieren)
  - Hue-Shift pro Farbe

- [ ] **Tone Curve erweitern**
  - RGB-Kanal-Kurven (Rot, Grün, Blau separat)
  - Punkt-Kurven-Editor (visuell)
  - Preset-Kurven

### 2.2 Masking & Lokale Anpassungen
- [ ] **Gradient Masks**
  - Lineare Gradienten
  - Radiale Gradienten
  - Mehrere Gradienten pro Bild

- [ ] **Brush-Verbesserungen**
  - Flow & Density (wie Lightroom)
  - Auto-Mask (automatische Kantenerkennung)
  - Range Mask (Helligkeit/Farbe)

- [ ] **Mask-Overlay**
  - Farbige Overlay-Anzeige
  - Mask-Edit-Modus
  - Mask-Invert

### 2.3 Retouching erweitern
- [ ] **Healing Brush verbessern**
  - Content-Aware Fill
  - Source-Point-Auswahl
  - Mehrere Healing-Punkte gleichzeitig

- [ ] **Clone Stamp**
  - Source-Point-Markierung
  - Alignment-Modus
  - Opacity & Flow

### 2.4 Organisierung
- [ ] **Smart Collections erweitern**
  - Komplexere Regeln (UND/ODER)
  - Automatische Updates
  - Nested Collections

- [ ] **Keywords & Metadaten**
  - Hierarchische Keywords (bereits vorhanden, erweitern)
  - IPTC-Templates erweitern
  - EXIF-Editor

---

## 📋 Phase 3: Spezialisierte Features (Priorität: NIEDRIG)

### 3.1 Astrofotografie (bereits begonnen)
- [x] Grundlegende Stacking-Funktionen
- [x] Master Frame Generation
- [ ] **Post-Processing für Astro**
  - Histogram Stretching (Arcsinh, Log)
  - Gradient Removal (Background Extraction)
  - Star Enhancement
  - Color Calibration für Astro

- [ ] **FITS-Support**
  - FITS-Dateien lesen/schreiben
  - FITS-Metadaten anzeigen
  - FITS-Stacking

### 3.2 Weitere Spezialisierungen
- [ ] **HDR-Merge**
  - Automatische HDR-Erstellung
  - Tone Mapping
  - Ghost Removal

- [ ] **Panorama (bereits vorhanden, erweitern)**
  - Bessere Blending-Modi
  - Automatische Crop-Vorschläge
  - 360° Panoramen

---

## 📋 Phase 4: UI/UX Verbesserungen (Priorität: MITTEL)

### 4.1 Konsistenz
- [ ] **Design-System erweitern**
  - Einheitliche Button-Styles
  - Konsistente Spacing
  - Dark/Light Mode vollständig

- [ ] **Sidebar-Optimierungen**
  - Anpassbare Tab-Reihenfolge (bereits vorhanden)
  - Collapsible Sections
  - Quick-Actions

### 4.2 Workflow-Verbesserungen
- [ ] **Shortcuts erweitern**
  - Mehr Tastenkürzel
  - Customizable Shortcuts
  - Shortcut-Hilfe verbessern

- [ ] **Multi-Monitor Support**
  - Separate Fenster für verschiedene Views
  - Loupe auf zweitem Monitor
  - Grid auf Hauptmonitor

---

## 📋 Phase 5: Performance & Stabilität (Priorität: HOCH)

### 5.1 Memory Management
- [ ] **Memory-Optimierung**
  - Besseres Caching
  - Memory-Warnings behandeln
  - Cleanup bei großen Bildmengen

### 5.2 Fehlerbehandlung
- [ ] **Robustheit**
  - Bessere Fehlerbehandlung
  - Recovery bei Crashes
  - Backup-System für Catalog

### 5.3 Testing
- [ ] **Qualitätssicherung**
  - Unit Tests für kritische Funktionen
  - Performance-Tests
  - Memory-Leak-Detection

---

## 🎯 Kurzfristige Ziele (Nächste 2-4 Wochen)

1. **Sport-Workflow Performance**
   - Grid-View Optimierung
   - Burst-Detection schneller machen
   - Keyboard-Navigation verbessern

2. **Lightroom-Features (Essentials)**
   - Texture & Clarity
   - Gradient Masks
   - Brush Flow & Density

3. **UI-Konsistenz**
   - Einheitliches Design-System
   - Alle Panels konsistent stylen

---

## 📊 Feature-Priorisierung Matrix

### Must-Have (P0)
- Sport-Workflow Performance
- Stabilität & Fehlerbehandlung
- Basis-Lightroom-Features

### Should-Have (P1)
- Erweiterte Masking-Features
- HSL/Tone Curve Verbesserungen
- Export-Optimierungen

### Nice-to-Have (P2)
- Astro Post-Processing
- HDR-Merge
- Erweiterte AI-Features

### Future (P3)
- Plugin-System
- Cloud-Sync
- Mobile Companion App

---

## 🔄 Iterativer Ansatz

### Sprint-Planung (2-Wochen-Sprints)
1. **Sprint 1-2**: Sport-Workflow Performance
2. **Sprint 3-4**: Lightroom Essentials (Texture, Gradient Masks)
3. **Sprint 5-6**: Masking-Verbesserungen
4. **Sprint 7-8**: Astro Post-Processing

### Feedback-Loop
- Nach jedem Sprint: Testen & Feedback
- Prioritäten anpassen basierend auf Nutzung
- Fokus auf Features, die wirklich gebraucht werden

---

## 📝 Notizen

- **Privater Gebrauch**: Kein Druck für kommerzielle Features
- **macOS-First**: Optimiert für macOS, keine Cross-Platform-Kompromisse
- **Performance über Features**: Lieber weniger, aber schnell
- **Tastatur-First**: Workflow sollte hauptsächlich über Tastatur funktionieren

---

*Diese Roadmap ist ein lebendes Dokument und wird basierend auf Feedback und Nutzung angepasst.*
