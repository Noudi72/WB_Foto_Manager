# WB Foto Manager (Blaurock Sportpix) – Zusammenfassung

## Überblick
Der **WB Foto Manager** ist eine macOS‑App für **Sport‑Culling** (schnell auswählen/bewerten), **Editing** (Lightroom‑ähnlich, nicht-destruktiv) und **Export/Upload** inkl. robuster Job‑Queue. Schwerpunkt: **Tastatur‑First** Workflow, hohe Vorschau‑Performance, sichere Metadaten‑Writes.

---

## Kern-Workflows

### Sport‑Culling (Turbo)
- **Grid / Detail / Compare / Survey**: View‑Modi per Toolbar und Shortcut.
- **Pick/Reject/Unflag + Auto‑Advance**: schnelle Selektion (optional).
- **Keepers‑Workflow**: Smart‑Filter **Alle → Picks → Unflagged → Rejects** (Shortcut: `K`).
- **Loupe (Schärfecheck)**: 100%‑Loupe **unter Maus**, Toggle `Z` (Detail, Fullscreen, Compare).
- **Burst/Serie Finder** (Default): Gruppen nach Zeitfenster; Aktionen: *Open in Compare*, *Reject Rest* (optional Trash), *Move to Trash*.
- **Skip Rejects**: Navigation kann Rejects überspringen (Einstellung).

### Editing (Lightroom‑Essentials)
- **Nicht-destruktive Bearbeitung**: Adjustments + Crop/Rotation + Local Masks persistiert im Catalog.
- **Copy / Paste / Sync**: Einstellungen kopieren/einfügen/synchronisieren (instant + Scope‑Dialog).
- **History / Snapshots**: Snapshots erstellen/benennen/anwenden/umbenennen/löschen (pro Foto).
- **Masking Workflow**: lineare/radiale Masken + **Pinsel** (Brush), inkl. zuverlässigem Commit beim Tabwechsel.
- **Before/After**: Vergleich per Toggle (u.a. Slider und **Nebeneinander** je nach Ansicht).

---

## Export / Upload / Jobs
- **Activity Center**: Fortschritt, Logs, Fehlerkarten.
- **Retry‑All Job**: Re‑queue von Export‑Failures + Upload‑Failures, inkl. Progress/Logs.
- **Persistente Export‑Queue**: Queue‑State wird gespeichert; nach Restart werden laufende Jobs als „unterbrochen“ markiert und beim Ordner‑Öffnen (wo möglich) fortgesetzt.
- **Upload Retry/Resume**: robuster Retry mit Attempts, Next‑Retry‑At (Backoff) und Fehlerkategorien.
- **Queue‑Status**: UI Hinweis „Queue wartet auf Ordner…“ wenn Pending Items existieren, Ordner aber nicht offen ist.

---

## Metadaten (Rating / Pick / IPTC)
- **Zentraler Writer**: `MetadataWriteQueue` (Debounce, per‑File Locking, Retries, Logs) – verhindert Race Conditions/Datenverlust.
- **PickState in XMP**: Pick/Reject wird als `crs:PickState` geschrieben (LR/ACR kompatibel), ohne `xmp:Rating` zu überschreiben.
- **IPTC Panel**: kompakt/responsiv (kein unschönes Wrapping in schmaler Sidebar), Batch‑Editor vorhanden.

---

## Performance (wichtig für Sport)
- **SmartImageLoader**: Progressive Loading (Low‑Res → High‑Res), Cache, Prefetching.
- **Concurrency Limits**: Decoder‑Limits gegen IOSurface/VRAM Peaks.
- **QoS Fix**: Prefetch läuft nicht mehr „userInitiated“, Interaktionen können Loads hochstufen (vermeidet „Hang Risk“).
- **Clipping/HitTesting Safety**: gezoomter Content wird geclippt, damit Sidebars/Tabs klickbar bleiben.

---

## UI/UX Highlights
- **Toolbar**: wieder vollständig **customizable**; Display‑Mode **Icon Only ↔ Icon+Text** über macOS‑Toolbar‑Menü (wird nicht überschrieben).
- **Overlay‑Badges**: Rating/ColorTag Overlays stark kompakt, ohne Schatten.
- **Sidebar Tabs rechts** (Lightroom‑Style).

---

## Wichtige Tastenkürzel (Auszug)
- **Navigation**: `← / →`
- **View Modes**: `⌃⌘1` Detail, `⌃⌘2` Grid, `⌃⌘3` Compare, `⌃⌘4` Survey
- **Culling**: `1–5` Rating, `0` löschen, `P / X / U` Pick/Reject/Unflag, `K` Keepers‑Filter, `Z` Loupe
- **Copy/Paste/Sync**:
  - `⌘C / ⌘V` instant Copy/Paste
  - `⇧⌘C / ⇧⌘V` Copy/Paste Dialog (Scope)
  - `⌥⌘V` Paste auf Auswahl
  - `⌥⌘S` Sync Dialog
- **Before/After**: `⌥⌘B`
- **Focus Mode**: `⌥⌘F` an/aus, `Esc` beendet Focus Mode
- **Hilfe**: `⇧⌘?` Hilfe & Anleitung, `⌘/` Tastenkürzel

---

## Wichtige Code-Bausteine (Orientierung)
- **State/Store**: `WB Foto Manager/WB Foto Manager/Store/PhotoStore.swift`, `.../Store/UIState.swift`
- **Main UI**: `.../Views/RootView.swift`, `DetailView.swift`, `FullscreenView.swift`, `ComparisonView.swift`
- **Help/Shortcuts**: `.../Views/HelpView.swift`, `ShortcutsHelpView.swift`
- **Jobs**: `.../Services/JobCenter.swift`, `.../Views/ActivityCenterPopover.swift`
- **Edits**: `.../Services/EditCatalogService.swift`, `.../Services/EditEngine.swift`
- **Media/Perf**: `.../Services/SmartImageLoader.swift`
- **Metadaten**: `.../Services/MetadataWriteQueue.swift`, `RatingPersistenceService.swift`, `IPTCMetadataService.swift`
- **Duplikate/Bursts**: `.../Services/DuplicateDetectionService.swift`, `.../Views/DuplicateDetectionView.swift`

---

## Entwicklung (Xcode / Sandbox – kurz)
- **App Sandbox**: benötigt „User Selected File (Read/Write)“ für Folder‑Workflows; Upload braucht Network‑Entitlements.
- **Security‑Scoped Bookmarks**: werden genutzt, um Ordnerzugriff über Restarts zu behalten (Sandbox‑kompatibel).
- **MLX (lokal KI)**: via Swift Package Manager (kein Python/pip nötig); erster Run lädt Modelle (Network nötig).

---

*Stand: Dezember 2025 (laufende Entwicklung)*


