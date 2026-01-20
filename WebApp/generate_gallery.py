#!/usr/bin/env python3
"""
Skript zum Generieren von gallery.json aus Bildern im images/ Ordner.

Unterstützt jetzt mehrere Galerien mit Passwortschutz.

Verwendung:
    # Einzelne Galerie:
    python3 generate_gallery.py --images-dir images/ --gallery-name "Hockey" --password "mein-passwort"
    
    # Mehrere Galerien: Erstelle mehrere Ordner (z.B. images/hockey/, images/fussball/)
    python3 generate_gallery.py --images-dir images/hockey/ --gallery-name "Hockey" --gallery-id "hockey" --password "hockey123"
    python3 generate_gallery.py --images-dir images/fussball/ --gallery-name "Fussball" --gallery-id "fussball" --password "fussball123"
    
    # Dann manuell in gallery.json kombinieren
"""

import os
import json
import argparse
from pathlib import Path
from datetime import datetime
from PIL import Image

# Unterstützte Bildformate
IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.tiff', '.tif'}

def get_image_info(image_path):
    """Holt Metadaten von einem Bild."""
    try:
        with Image.open(image_path) as img:
            width, height = img.size
            return {
                'width': width,
                'height': height,
                'format': img.format
            }
    except Exception as e:
        print(f"Warnung: Konnte Metadaten von {image_path} nicht lesen: {e}")
        return None

def create_thumbnail(image_path, thumbnail_path, size=(300, 300)):
    """Erstellt ein Thumbnail von einem Bild."""
    try:
        with Image.open(image_path) as img:
            img.thumbnail(size, Image.Resampling.LANCZOS)
            # Konvertiere zu RGB falls nötig (für JPEG)
            if img.mode in ('RGBA', 'LA', 'P'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            img.save(thumbnail_path, 'JPEG', quality=85)
            return True
    except Exception as e:
        print(f"Warnung: Konnte Thumbnail für {image_path} nicht erstellen: {e}")
        return False

def scan_images_directory(images_dir, create_thumbnails=True):
    """Scannt den images/ Ordner nach Bildern."""
    images = []
    images_path = Path(images_dir)
    thumbnails_path = images_path / 'thumbnails'
    
    if not images_path.exists():
        print(f"Fehler: Ordner {images_dir} existiert nicht!")
        return images
    
    # Erstelle thumbnails Ordner falls nötig
    if create_thumbnails:
        thumbnails_path.mkdir(exist_ok=True)
    
    # Scanne nach Bildern
    for file_path in sorted(images_path.iterdir()):
        if file_path.is_file() and file_path.suffix.lower() in IMAGE_EXTENSIONS:
            image_name = file_path.name
            image_url = f"./images/{image_name}"
            
            # Erstelle Thumbnail falls gewünscht
            thumbnail_url = None
            if create_thumbnails:
                thumbnail_path = thumbnails_path / f"thumb_{image_name}"
                if not thumbnail_path.exists():
                    if create_thumbnail(file_path, thumbnail_path):
                        thumbnail_url = f"./images/thumbnails/thumb_{image_name}"
                else:
                    thumbnail_url = f"./images/thumbnails/thumb_{image_name}"
            
            # Hole Metadaten
            info = get_image_info(file_path)
            
            image_data = {
                'id': f"img_{len(images) + 1}",
                'name': image_name,
                'url': image_url,
                'uploadDate': datetime.fromtimestamp(file_path.stat().st_mtime).isoformat() + 'Z'
            }
            
            if thumbnail_url:
                image_data['thumbnailUrl'] = thumbnail_url
            
            if info:
                image_data['width'] = info['width']
                image_data['height'] = info['height']
            
            images.append(image_data)
            print(f"✓ {image_name}")
    
    return images

def generate_gallery_json(images_dir='images/', gallery_name='Galerie', gallery_id=None, 
                          description=None, password=None, create_thumbnails=True, 
                          output_file='gallery.json', merge_existing=False):
    """Generiert gallery.json aus Bildern im images/ Ordner."""
    print(f"Scanne Bilder in {images_dir}...")
    images = scan_images_directory(images_dir, create_thumbnails)
    
    if not images:
        print("Keine Bilder gefunden!")
        return False
    
    print(f"\n{len(images)} Bilder gefunden.")
    
    # Erstelle Galerie-Objekt
    gallery_id = gallery_id or gallery_name.lower().replace(' ', '-')
    gallery = {
        'id': gallery_id,
        'name': gallery_name,
        'images': images
    }
    
    if description:
        gallery['description'] = description
    
    if password:
        gallery['password'] = password
        print(f"\n⚠️  Passwort gesetzt (unsicher - nur für einfachen Schutz)")
    
    # Lade bestehende gallery.json falls vorhanden und merge_existing=True
    existing_galleries = []
    if merge_existing and os.path.exists(output_file):
        try:
            with open(output_file, 'r', encoding='utf-8') as f:
                existing_data = json.load(f)
                if existing_data.get('galleries'):
                    existing_galleries = existing_data['galleries']
                    # Entferne Galerie mit gleicher ID falls vorhanden
                    existing_galleries = [g for g in existing_galleries if g.get('id') != gallery_id]
        except Exception as e:
            print(f"Warnung: Konnte bestehende gallery.json nicht laden: {e}")
    
    # Erstelle gallery.json Struktur (neue Version 3.0 mit galleries Array)
    gallery_data = {
        'version': '3.0',
        'generated': datetime.now().isoformat() + 'Z',
        'galleries': existing_galleries + [gallery]
    }
    
    # Speichere gallery.json
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(gallery_data, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ gallery.json erfolgreich generiert!")
    print(f"  - Galerie: {gallery_name} ({gallery_id})")
    print(f"  - {len(images)} Bilder")
    print(f"  - Ausgabedatei: {output_file}")
    if existing_galleries:
        print(f"  - {len(existing_galleries)} weitere Galerien beibehalten")
    
    return True

def main():
    parser = argparse.ArgumentParser(
        description='Generiert gallery.json aus Bildern im images/ Ordner'
    )
    parser.add_argument(
        '--images-dir',
        default='images/',
        help='Ordner mit Bildern (Standard: images/)'
    )
    parser.add_argument(
        '--gallery-name',
        default='Galerie',
        help='Name der Galerie (Standard: "Galerie")'
    )
    parser.add_argument(
        '--gallery-id',
        default=None,
        help='Eindeutige ID der Galerie (Standard: automatisch aus Name)'
    )
    parser.add_argument(
        '--description',
        default=None,
        help='Beschreibung der Galerie (optional)'
    )
    parser.add_argument(
        '--password',
        default=None,
        help='Passwort für die Galerie (optional)'
    )
    parser.add_argument(
        '--no-thumbnails',
        action='store_true',
        help='Erstelle keine Thumbnails'
    )
    parser.add_argument(
        '--output',
        default='gallery.json',
        help='Ausgabedatei (Standard: gallery.json)'
    )
    parser.add_argument(
        '--merge',
        action='store_true',
        help='Füge zu bestehender gallery.json hinzu (statt zu überschreiben)'
    )
    
    args = parser.parse_args()
    
    generate_gallery_json(
        images_dir=args.images_dir,
        gallery_name=args.gallery_name,
        gallery_id=args.gallery_id,
        description=args.description,
        password=args.password,
        create_thumbnails=not args.no_thumbnails,
        output_file=args.output,
        merge_existing=args.merge
    )

if __name__ == '__main__':
    main()
