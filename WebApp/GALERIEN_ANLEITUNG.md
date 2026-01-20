# 📸 Mehrere Galerien mit Passwortschutz - Anleitung

## Übersicht

Die WebApp unterstützt jetzt mehrere Galerien, jede mit eigenem Passwortschutz.

## Struktur

Die `gallery.json` hat jetzt folgende Struktur:

```json
{
  "version": "3.0",
  "generated": "2026-01-20T12:00:00Z",
  "galleries": [
    {
      "id": "hockey",
      "name": "Hockey",
      "description": "Eishockey-Fotos",
      "password": null,
      "images": [...]
    },
    {
      "id": "fussball",
      "name": "Fussball",
      "description": "Fussball-Fotos",
      "password": "geheim123",
      "images": [...]
    }
  ]
}
```

## Galerien erstellen

### Option 1: Mit Python-Skript (empfohlen)

#### Einzelne Galerie:

```bash
python3 WebApp/generate_gallery.py \
  --images-dir images/ \
  --gallery-name "Hockey" \
  --gallery-id "hockey" \
  --description "Eishockey-Fotos" \
  --password "hockey123" \
  --output gallery.json
```

#### Mehrere Galerien (mit --merge):

```bash
# Erste Galerie
python3 WebApp/generate_gallery.py \
  --images-dir images/hockey/ \
  --gallery-name "Hockey" \
  --gallery-id "hockey" \
  --password "hockey123" \
  --output gallery.json

# Zweite Galerie (wird zur ersten hinzugefügt)
python3 WebApp/generate_gallery.py \
  --images-dir images/fussball/ \
  --gallery-name "Fussball" \
  --gallery-id "fussball" \
  --password "fussball123" \
  --output gallery.json \
  --merge
```

### Option 2: Manuell

1. Öffne `gallery.json`
2. Füge eine neue Galerie zum `galleries` Array hinzu:

```json
{
  "version": "3.0",
  "generated": "2026-01-20T12:00:00Z",
  "galleries": [
    {
      "id": "gallery1",
      "name": "Hockey",
      "description": "Eishockey-Fotos",
      "password": null,
      "images": [...]
    },
    {
      "id": "gallery2",
      "name": "Fussball",
      "description": "Fussball-Fotos",
      "password": "geheim123",
      "images": [...]
    }
  ]
}
```

## Passwortschutz

### Passwort setzen:

In der `gallery.json`:

```json
{
  "id": "hockey",
  "name": "Hockey",
  "password": "mein-passwort",
  "images": [...]
}
```

### Kein Passwort:

```json
{
  "id": "hockey",
  "name": "Hockey",
  "password": null,
  "images": [...]
}
```

**Wichtig**: Der Passwortschutz ist nur client-seitig und **nicht sicher**. Jeder kann den JavaScript-Code sehen und umgehen. Für echten Schutz benötigen Sie ein Backend.

## Ordnerstruktur

### Option A: Alle Bilder in einem Ordner

```
images/
├── bild1.jpg
├── bild2.jpg
└── thumbnails/
    ├── thumb_bild1.jpg
    └── thumb_bild2.jpg
```

In `gallery.json` werden die Bilder dann verschiedenen Galerien zugeordnet.

### Option B: Separate Ordner pro Galerie

```
images/
├── hockey/
│   ├── bild1.jpg
│   └── thumbnails/
├── fussball/
│   ├── bild2.jpg
│   └── thumbnails/
```

Dann verwenden Sie:

```bash
python3 WebApp/generate_gallery.py --images-dir images/hockey/ --gallery-name "Hockey" --merge
python3 WebApp/generate_gallery.py --images-dir images/fussball/ --gallery-name "Fussball" --merge
```

## Beispiel: Drei Galerien erstellen

```bash
# 1. Hockey (ohne Passwort)
python3 WebApp/generate_gallery.py \
  --images-dir images/hockey/ \
  --gallery-name "Hockey" \
  --gallery-id "hockey" \
  --description "Eishockey-Fotos" \
  --output gallery.json

# 2. Fussball (mit Passwort)
python3 WebApp/generate_gallery.py \
  --images-dir images/fussball/ \
  --gallery-name "Fussball" \
  --gallery-id "fussball" \
  --description "Fussball-Fotos" \
  --password "fussball123" \
  --output gallery.json \
  --merge

# 3. Privat (mit Passwort)
python3 WebApp/generate_gallery.py \
  --images-dir images/privat/ \
  --gallery-name "Privat" \
  --gallery-id "privat" \
  --description "Private Fotos" \
  --password "privat123" \
  --output gallery.json \
  --merge
```

## Funktionsweise

1. **Galerie-Auswahl**: Wenn mehrere Galerien vorhanden sind, wird eine Auswahl-Seite angezeigt
2. **Passwortschutz**: Galerien mit Passwort zeigen ein 🔒-Symbol
3. **Direkter Zugriff**: Wenn nur eine Galerie vorhanden ist, wird sie direkt angezeigt
4. **Zurück-Button**: Bei mehreren Galerien gibt es einen "Zurück"-Button

## Tipps

- **Galerie-IDs**: Verwenden Sie kurze, eindeutige IDs (z.B. "hockey", "fussball")
- **Passwörter**: Verwenden Sie starke Passwörter (auch wenn der Schutz nur client-seitig ist)
- **Beschreibungen**: Beschreibungen helfen Benutzern, die richtige Galerie zu finden
- **Bilder**: Alle Bilder müssen im `images/` Ordner sein (oder Unterordner)
