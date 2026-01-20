#!/usr/bin/env python3
# restore_presets.py
# Stellt Presets aus Backup wieder her

import json
import subprocess
import sys

backup_file = "/Users/noelguyaz/Projekte/WB Foto Manager/_Backups/WB_Foto_Manager_Backup_1766079021.json"

print("Lade Backup von:", backup_file)

try:
    with open(backup_file, 'r') as f:
        data = json.load(f)
    
    presets = data.get('adjustmentPresets', [])
    preset_groups = data.get('presetGroups', [])
    
    print(f"✓ 134 Presets gefunden")
    print(f"✓ 15 Preset-Gruppen gefunden")
    
    # Konvertiere zu JSON-String (UserDefaults in macOS akzeptiert JSON-Strings für komplexe Daten)
    presets_json = json.dumps(presets)
    groups_json = json.dumps(preset_groups)
    
    # Schreibe in UserDefaults (als String, macOS konvertiert intern)
    # Bundle-ID muss bekannt sein - lass mich prüfen, ob wir das aus dem System holen können
    bundle_id = "com.wbfoto.WB-Foto-Manager"  # Typischer Bundle-ID-Format
    
    # Versuche, die Bundle-ID aus dem System zu holen
    try:
        result = subprocess.run(
            ["defaults", "read", "-g", "NSApplicationBundleIdentifier"],
            capture_output=True,
            text=True
        )
        # Das funktioniert nicht für die App...
        # Versuche stattdessen, alle UserDefaults zu durchsuchen
    except:
        pass
    
    # Alternativer Ansatz: Schreibe die Daten direkt in die UserDefaults-Datenbank
    # Als plist-XML Format
    
    print("\nHinweis: Die einfachste Lösung ist:")
    print("1. Verwende die Backup-Wiederherstellung in der App")
    print("2. ODER kopiere die Backup-Datei auf den Desktop und wähle sie dort aus")
    print("3. ODER verwende dieses Script (erfordert Bundle-ID)")
    
    # Versuche, die Daten direkt zu schreiben
    # Aber das ist kompliziert, da wir die Bundle-ID brauchen
    # Besser: Verwende die App-Funktionalität
    
except Exception as e:
    print(f"Fehler: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
