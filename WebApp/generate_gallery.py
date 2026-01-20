#!/usr/bin/env python3
"""
Skript zum Generieren von gallery.json aus Bildern im images/ Ordner.

Verwendung:
    python3 generate_gallery.py [--password PASSWORD] [--images-dir images/]

Das Skript:
1. Scannt den images/ Ordner nach Bildern
2. Erstellt Thumbnails (optional)
3. Generiert gallery.json mit allen Bildern
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

def generate_gallery_json(images_dir='images/', password=None, create_thumbnails=True, output_file='gallery.json'):
    """Generiert gallery.json aus Bildern im images/ Ordner."""
    print(f"Scanne Bilder in {images_dir}...")
    images = scan_images_directory(images_dir, create_thumbnails)
    
    if not images:
        print("Keine Bilder gefunden!")
        return False
    
    print(f"\n{len(images)} Bilder gefunden.")
    
    # Erstelle gallery.json Struktur
    gallery_data = {
        'version': '2.0',
        'generated': datetime.now().isoformat() + 'Z',
        'images': images
    }
    
    if password:
        gallery_data['password'] = password
        print(f"\n⚠️  Passwort gesetzt (unsicher - nur für einfachen Schutz)")
    
    # Speichere gallery.json
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(gallery_data, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ gallery.json erfolgreich generiert!")
    print(f"  - {len(images)} Bilder")
    print(f"  - Ausgabedatei: {output_file}")
    
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
    
    args = parser.parse_args()
    
    generate_gallery_json(
        images_dir=args.images_dir,
        password=args.password,
        create_thumbnails=not args.no_thumbnails,
        output_file=args.output
    )

if __name__ == '__main__':
    main()
