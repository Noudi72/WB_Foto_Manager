# Verbesserungspotenzial: Näher an Lightroom & Photoshop

## 🎯 Übersicht

Die App hat bereits sehr viele professionelle Features! Hier sind die wichtigsten Verbesserungen, um noch näher an Lightroom und Photoshop heranzukommen:

---

## 🔴 Hochpriorität (größter Impact)

### 1. **Perspective/Transform Correction** (Lightroom "Upright")
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐⭐⭐⭐ Sehr hoch

**Features:**
- **Auto Upright** (automatische Perspektivkorrektur)
- **Level** (nur horizontale Korrektur)
- **Vertical** (nur vertikale Korrektur)
- **Full** (beide Richtungen)
- **Manual Transform** mit Slidern:
  - Vertical Transform
  - Horizontal Transform
  - Rotate
  - Aspect Ratio
  - Scale
  - X/Y Offset

**Implementierung:**
- CoreImage Filter: `CIPerspectiveCorrection`, `CIAffineTransform`
- Vision Framework für Auto-Detection von Linien/Horizont

**Code-Referenz:**
- `EditEngine.swift` - Neue Funktion `applyPerspectiveCorrection()`
- `PhotoAdjustments.swift` - Neue Properties: `perspectiveTransform`, `uprightMode`
- `AdjustmentsSidebar.swift` - Neuer Abschnitt "Transform"

---

### 2. **Color Calibration Panel** (Lightroom Classic)
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐⭐⭐ Hoch

**Features:**
- **Shadows Tint** (Grün/Magenta)
- **Red Primary**: Hue & Saturation
- **Green Primary**: Hue & Saturation
- **Blue Primary**: Hue & Saturation

**Warum wichtig:**
- Präzise Farbkorrektur auf Kanalbasis
- Bessere Kontrolle über Hauttöne
- Profi-Workflow für Farbkorrektur

**Implementierung:**
- CoreImage Filter: `CIColorMatrix`, `CIColorCrossPolynomial`
- Neue Properties in `PhotoAdjustments.swift`:
  ```swift
  var colorCalibration: ColorCalibration = ColorCalibration()
  ```

---

### 3. **AI Auto Mask** (Lightroom "Select Subject/Sky/Background")
**Status:** ⚠️ Teilweise (Auto Masking existiert, aber nicht AI-basiert)  
**Impact:** ⭐⭐⭐⭐⭐ Sehr hoch

**Features:**
- **Select Subject** - Automatische Auswahl des Hauptmotivs
- **Select Sky** - Automatische Himmel-Auswahl
- **Select Background** - Automatische Hintergrund-Auswahl
- **Select People** - Personen-Auswahl (optional)

**Implementierung:**
- Vision Framework: `VNGeneratePersonSegmentationRequest`, `VNGenerateForegroundInstanceMaskRequest`
- CoreML Modelle für Sky/Subject Detection (können lokal geladen werden)
- Integration in `MaskingPanel.swift` als neue Mask-Typen

**Code-Referenz:**
- `MaskingPanel.swift` - Button "AI: Subject/Sky/Background"
- `LocalAdjustmentMask.swift` - Neuer `LocalMaskKind`: `.aiSubject`, `.aiSky`, `.aiBackground`

---

### 4. **Range Mask: Color Range** (Lightroom)
**Status:** ⚠️ Teilweise (nur Luminance/Saturation, keine Color Range)  
**Impact:** ⭐⭐⭐⭐ Hoch

**Aktuell vorhanden:**
- ✅ Luminance Range
- ✅ Saturation Range

**Fehlt:**
- ❌ **Color Range** - Maske basierend auf spezifischen Farbtönen
  - Color Picker für Ziel-Farbe
  - Hue Range (welche Farbtöne)
  - Saturation Range (wie gesättigt)
  - Luminance Range (wie hell/dunkel)

**Implementierung:**
- Erweitere `RangeMask` in `LocalAdjustmentMask.swift`:
  ```swift
  var colorRange: ColorRange? = nil
  
  struct ColorRange {
      var targetHue: Double // 0-360°
      var hueRange: Double // ±Winkel
      var saturationMin: Double?
      var saturationMax: Double?
      var luminanceMin: Double?
      var luminanceMax: Double?
  }
  ```

---

## 🟡 Mittelpriorität (nice-to-have)

### 5. **Mask Density vs. Opacity** (Lightroom)
**Status:** ⚠️ Nur Opacity vorhanden  
**Impact:** ⭐⭐⭐ Mittel

**Unterschied:**
- **Opacity**: Stärke der gesamten Maske (inkl. Feather)
- **Density**: Stärke der Maske **vor** Feather (für präzisere Kontrolle)

**Implementierung:**
- Neue Property in `LocalAdjustmentMask.swift`: `density: Double = 1.0`
- UI in `MaskingPanel.swift` - Zwei separate Slider

---

### 6. **Mask Operations** (Add/Subtract/Intersect)
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐⭐ Mittel

**Features:**
- **Add** - Maske hinzufügen (Standard)
- **Subtract** - Maske abziehen
- **Intersect** - Nur Überschneidung behalten

**Implementierung:**
- Neue Property in `LocalAdjustmentMask.swift`: `operation: MaskOperation = .add`
- CoreImage Blend Modes für Mask-Kombination

---

### 7. **Healing/Clone Stamp** (Photoshop-ähnlich)
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐⭐ Mittel

**Features:**
- **Healing Brush** - Intelligente Retusche (Content-Aware)
- **Clone Stamp** - Exaktes Kopieren
- **Spot Removal** - Einfache Flecken-Entfernung

**Implementierung:**
- CoreImage Filter: `CICloneStamp`, `CIHealingBrush` (falls verfügbar)
- Vision Framework für Content-Aware Fill
- Neue View: `HealingPanel.swift`

**Hinweis:** CoreImage hat keine direkten Healing-Filter. Mögliche Alternativen:
- Vision Framework `VNGenerateForegroundInstanceMaskRequest` + Inpainting
- Externe Bibliothek oder Custom Metal Shader

---

### 8. **HDR Merge** (Lightroom)
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐⭐ Mittel

**Features:**
- Mehrere Belichtungen (Bracketing) zu einem HDR kombinieren
- Auto-Alignment
- Tone Mapping

**Implementierung:**
- CoreImage Filter: `CIHDRToneMap`
- Alignment mit Vision Framework
- Neue View: `HDRMergeView.swift`

---

### 9. **Panorama Stitching** (Lightroom)
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐ Niedrig (nicht für alle relevant)

**Features:**
- Mehrere Bilder zu Panorama kombinieren
- Auto-Detection von Overlaps
- Projektion (Spherical/Cylindrical/Planar)

**Implementierung:**
- CoreImage Filter: `CIPerspectiveTransform` + Compositing
- Vision Framework für Feature Matching

---

## 🟢 Niedrigpriorität (polish)

### 10. **Enhanced Histogram**
**Status:** ✅ Vorhanden, aber erweiterbar  
**Impact:** ⭐⭐ Niedrig

**Verbesserungen:**
- **Clipping Indicators** - Zeige über-/unterbelichtete Bereiche
- **Color Channel Overlay** - RGB-Kanäle über Histogramm
- **Zone System** - Anzeige von Zonen (0-10)
- **Histogram in Mask View** - Zeige Histogramm nur für maskierte Bereiche

---

### 11. **Keyboard Shortcuts für Masking**
**Status:** ⚠️ Teilweise  
**Impact:** ⭐⭐ Niedrig

**Fehlende Shortcuts:**
- `B` - Brush Tool
- `G` - Gradient Tool
- `R` - Radial Tool
- `O` - Toggle Mask Overlay
- `\` - Toggle Mask Visibility

---

### 12. **Mask Presets**
**Status:** ❌ Fehlt  
**Impact:** ⭐⭐ Niedrig

**Features:**
- Speichere Mask-Formen als Presets
- Schnelles Anwenden von Standard-Masken (z.B. "Portrait Vignette", "Sky Gradient")

---

## 📊 Priorisierungs-Empfehlung

### Phase 1 (Sofort):
1. **Perspective/Transform Correction** - Sehr häufig benötigt
2. **AI Auto Mask** - Massive Zeitersparnis
3. **Color Calibration** - Profi-Feature

### Phase 2 (Nächste Version):
4. **Range Mask: Color Range** - Erweitert bestehende Funktionalität
5. **Mask Density** - Feine Kontrolle
6. **Mask Operations** - Mehr Flexibilität

### Phase 3 (Zukunft):
7. **Healing/Clone Stamp** - Retusche
8. **HDR Merge** - Spezial-Feature
9. **Panorama Stitching** - Spezial-Feature

---

## 💡 Quick Wins (schnell umsetzbar)

### 1. **Mask Density hinzufügen**
- ~30 Minuten Arbeit
- Großer Impact für Masking-Workflow

### 2. **Color Range in Range Mask**
- ~2 Stunden Arbeit
- Erweitert bestehende Funktionalität

### 3. **Keyboard Shortcuts für Masking**
- ~1 Stunde Arbeit
- Bessere Workflow-Integration

---

## 🔧 Technische Hinweise

### Vision Framework Integration
```swift
import Vision

// Subject Detection
let request = VNGenerateForegroundInstanceMaskRequest()
let handler = VNImageRequestHandler(ciImage: image)
try handler.perform([request])

// Sky Detection (benötigt Custom CoreML Model)
// Oder: Color-based Detection (Himmel ist meist blau)
```

### CoreImage Transform
```swift
// Perspective Correction
let filter = CIFilter(name: "CIPerspectiveCorrection")!
filter.setValue(image, forKey: kCIInputImageKey)
filter.setValue(CIVector(x: x1, y: y1), forKey: "inputTopLeft")
// ... weitere Eckpunkte

// Affine Transform
let transform = CGAffineTransform(...)
let filter = CIFilter(name: "CIAffineTransform")!
filter.setValue(image, forKey: kCIInputImageKey)
filter.setValue(NSValue(cgAffineTransform: transform), forKey: kCIInputTransformKey)
```

---

## 📝 Zusammenfassung

**Top 3 Features für maximale Verbesserung:**
1. ✅ **Perspective/Transform Correction** - Fehlt komplett, sehr wichtig
2. ✅ **AI Auto Mask** - Zeitersparnis, moderne Erwartung
3. ✅ **Color Calibration** - Profi-Feature, präzise Kontrolle

**Bereits sehr gut:**
- ✅ Masking-System (Brush, Linear, Radial, Range)
- ✅ Adjustments (sehr umfangreich)
- ✅ Histogram
- ✅ Tone Curve
- ✅ HSL/Color Grading
- ✅ Presets
- ✅ Before/After

Die App ist bereits sehr nah an Lightroom! Mit den Top 3 Features wäre sie auf Profi-Niveau. 🚀
