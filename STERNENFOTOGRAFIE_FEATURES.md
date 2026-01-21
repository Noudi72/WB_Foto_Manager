# Sternenfotografie (Astrofotografie) - Feature-Plan

## Übersicht
Für professionelle Sternenfotografie benötigt die App spezielle Funktionen zum Stacking, Kalibrierung und Post-Processing von Astro-Bildern.

---

## 1. Kalibrierungs-Frames (Calibration Frames)

### 1.1 Dark Frames
- **Zweck**: Reduziert thermisches Rauschen und Hot Pixels
- **Aufnahme**: Deckel auf, gleiche ISO/Exposure wie Light Frames
- **Verarbeitung**: Median/Mean über mehrere Dark Frames → Master Dark
- **Anwendung**: Master Dark von jedem Light Frame subtrahieren

### 1.2 Flat Frames
- **Zweck**: Korrigiert Vignettierung, Staubflecken, ungleichmäßige Beleuchtung
- **Aufnahme**: Gleichmäßig beleuchtete weiße Fläche (T-Shirt, LED-Panel)
- **Verarbeitung**: Median/Mean über mehrere Flat Frames → Master Flat
- **Anwendung**: Light Frame durch Master Flat dividieren (normalisiert)

### 1.3 Bias Frames
- **Zweck**: Korrigiert Sensor-Offset-Rauschen
- **Aufnahme**: Kürzeste mögliche Belichtung (1/8000s), Deckel auf
- **Verarbeitung**: Median/Mean über mehrere Bias Frames → Master Bias
- **Anwendung**: Wird für Dark Frame Subtraction benötigt (Dark = Dark - Bias)

### 1.4 Dark Flat Frames (optional)
- **Zweck**: Korrigiert thermisches Rauschen in Flat Frames
- **Aufnahme**: Flat Frame Setup, aber Deckel auf
- **Verarbeitung**: Ähnlich wie Dark Frames

---

## 2. Star Alignment / Registration

### 2.1 Feature Detection
- **Stern-Erkennung**: 
  - Blob Detection (Helligkeitsschwellen)
  - Star Detection Algorithmus (z.B. StarNet, Source Extractor ähnlich)
  - Pattern Matching für Sternkonstellationen

### 2.2 Transformation
- **Translation**: Verschiebung (X, Y)
- **Rotation**: Drehung um Bildmitte
- **Scaling**: Skalierung (bei unterschiedlichen Brennweiten)
- **Affine Transformation**: Kombination aus Translation, Rotation, Scaling
- **Perspective Transformation**: Für Weitwinkel-Astro

### 2.3 Alignment-Methoden
- **Star-based**: Sterne als Referenzpunkte
- **Pattern Matching**: Sternkonstellationen matchen
- **Phase Correlation**: FFT-basiert (schnell, aber weniger präzise)
- **Sub-pixel Accuracy**: Interpolation für präzise Ausrichtung

---

## 3. Image Stacking / Integration

### 3.1 Stacking-Methoden
- **Mean (Average)**: 
  - Einfachste Methode
  - SNR verbessert sich um √N (N = Anzahl Bilder)
  - Gut für: Deep Sky Objects, Nebel

- **Median**:
  - Entfernt Outliers (Satelliten, Flugzeuge, Hot Pixels)
  - Weniger Rauschen als Mean
  - Gut für: Viele Frames, viele Störungen

- **Sigma Clipping**:
  - Entfernt Pixel die > N*Sigma vom Median abweichen
  - Kombiniert Vorteile von Mean und Median
  - Gut für: Beste Qualität, aber rechenintensiv

- **Kappa-Sigma Clipping**:
  - Erweiterte Version mit Kappa-Parameter
  - Mehr Kontrolle über Outlier-Entfernung

- **Percentile Clipping**:
  - Entfernt obere/untere Prozentwerte
  - Gut für: Sehr viele Frames

### 3.2 Weighted Stacking
- **SNR-basiert**: Gewichtung nach Signal-to-Noise Ratio
- **FWHM-basiert**: Gewichtung nach Sternschärfe
- **Exposure-basiert**: Gewichtung nach Belichtungszeit

---

## 4. Post-Processing für Astro

### 4.1 Stretching / Histogram-Anpassung
- **Linear Stretch**: Lineare Helligkeitsanpassung
- **Arcsinh Stretch**: Nicht-linear, gut für Nebel
- **Log Stretch**: Logarithmische Skalierung
- **Histogram Equalization**: Automatische Kontrastanpassung

### 4.2 Rauschreduzierung
- **Non-local Means**: Erhält Details, reduziert Rauschen
- **Wavelet Denoising**: Frequenz-basiert
- **Bilateral Filter**: Erhält Kanten
- **Astro-spezifisch**: Berücksichtigt Sternstrukturen

### 4.3 Stern-Enhancement
- **Star Masking**: Sterne isolieren
- **Star Reduction**: Große Sterne verkleinern (für Nebel)
- **Star Enhancement**: Schwache Sterne verstärken
- **Deconvolution**: Schärfung mit Point Spread Function

### 4.4 Farb-Kalibrierung
- **White Balance**: Für Astro angepasst
- **Color Calibration**: Referenzsterne nutzen
- **Saturation**: Vorsichtige Sättigung für Nebel

### 4.5 Gradient Removal
- **Background Extraction**: Gradienten entfernen
- **Light Pollution Removal**: Lichtverschmutzung reduzieren
- **Vignetting Correction**: Rest-Vignettierung korrigieren

---

## 5. Workflow-Integration

### 5.1 Astro-Workflow-Modus
- **Dedicated Mode**: Spezieller Modus für Astro-Bearbeitung
- **Frame-Kategorisierung**: 
  - Light Frames (Hauptbilder)
  - Dark Frames
  - Flat Frames
  - Bias Frames
  - Dark Flat Frames

### 5.2 Batch-Processing
- **Master Frame Generation**: 
  - Master Dark aus mehreren Darks
  - Master Flat aus mehreren Flats
  - Master Bias aus mehreren Bias

- **Calibration Pipeline**:
  1. Light Frames kalibrieren (Dark/Flat/Bias)
  2. Alignieren
  3. Stacken
  4. Post-Processing

### 5.3 UI-Komponenten
- **Astro-Panel**: Neue Sidebar-Sektion
- **Frame-Manager**: Übersicht über alle Frame-Typen
- **Stacking-Dialog**: Konfiguration für Stacking
- **Progress-Tracking**: Für lange Stacking-Jobs

---

## 6. Technische Implementierung

### 6.1 CoreImage / Metal
- **Metal Kernels**: Für schnelle Pixel-Operationen
- **Accelerate Framework**: Für FFT, Matrix-Operationen
- **vImage**: Für Bildverarbeitung
- **CoreImage Filter**: Für Standard-Operationen

### 6.2 Star Detection
- **Vision Framework**: Für Feature Detection (optional)
- **Custom Algorithm**: Blob Detection + Thresholding
- **StarNet Integration**: ML-basierte Stern-Erkennung (optional)

### 6.3 Performance
- **GPU-Acceleration**: Metal für Stacking
- **Multi-threading**: Parallel Processing
- **Memory Management**: Effiziente Speichernutzung für große Stacks
- **Progress Updates**: Für lange Operationen

### 6.4 Dateiformate
- **RAW Support**: Für unverarbeitete Astro-Bilder
- **FITS Support**: Standard-Format für Astrofotografie (optional)
- **32-bit Processing**: Für HDR-Astro-Bilder

---

## 7. Empfohlene Implementierungs-Reihenfolge

### Phase 1: Grundlagen
1. ✅ Frame-Kategorisierung (Light/Dark/Flat/Bias)
2. ✅ Master Frame Generation (Mean/Median)
3. ✅ Dark Frame Subtraction
4. ✅ Flat Frame Division

### Phase 2: Alignment
5. ✅ Star Detection
6. ✅ Translation/Rotation Detection
7. ✅ Image Alignment
8. ✅ Sub-pixel Accuracy

### Phase 3: Stacking
9. ✅ Mean Stacking
10. ✅ Median Stacking
11. ✅ Sigma Clipping
12. ✅ Weighted Stacking

### Phase 4: Post-Processing
13. ✅ Histogram Stretching
14. ✅ Rauschreduzierung
15. ✅ Gradient Removal
16. ✅ Farb-Kalibrierung

### Phase 5: UI/UX
17. ✅ Astro-Workflow-Modus
18. ✅ Frame-Manager UI
19. ✅ Stacking-Dialog
20. ✅ Progress-Tracking

---

## 8. Beispiel-Workflow

```
1. Bilder importieren
   ├─ Light Frames (z.B. 50x 2min ISO 1600)
   ├─ Dark Frames (z.B. 20x 2min ISO 1600)
   ├─ Flat Frames (z.B. 20x 1/100s ISO 1600)
   └─ Bias Frames (z.B. 20x 1/8000s ISO 1600)

2. Master Frames erstellen
   ├─ Master Dark = Median(Dark Frames) - Master Bias
   ├─ Master Flat = Median(Flat Frames) - Master Dark Flat
   └─ Master Bias = Median(Bias Frames)

3. Light Frames kalibrieren
   └─ Calibrated Light = (Light - Master Dark) / (Master Flat - Master Dark Flat)

4. Alignieren
   └─ Alle kalibrierten Light Frames auf Referenz ausrichten

5. Stacken
   └─ Stacked = Sigma Clipping(Aligned Lights, sigma=3, iterations=3)

6. Post-Processing
   ├─ Histogram Stretch
   ├─ Rauschreduzierung
   ├─ Gradient Removal
   └─ Farb-Kalibrierung
```

---

## 9. Technische Herausforderungen

### 9.1 Memory Management
- **Problem**: Viele große RAW-Bilder gleichzeitig im Speicher
- **Lösung**: 
  - Tiles/Chunks verarbeiten
  - Memory-Mapped Files
  - Progressive Loading

### 9.2 Performance
- **Problem**: Stacking von 50+ Bildern kann sehr lange dauern
- **Lösung**:
  - GPU-Acceleration (Metal)
  - Multi-threading
  - Optimierte Algorithmen

### 9.3 Präzision
- **Problem**: Sub-pixel Alignment erfordert Interpolation
- **Lösung**:
  - Lanczos/Bicubic Interpolation
  - 32-bit Float Processing
  - Präzise Transformationen

---

## 10. Referenzen / Inspiration

- **Siril**: Open-Source Astro-Stacking Software
- **DeepSkyStacker**: Windows-basierte Lösung
- **PixInsight**: Professionelle Astro-Software
- **AstroPixelProcessor**: Kommerzielle Lösung

---

*Stand: Januar 2025*
