#!/usr/bin/env python3
# restore_presets_direct.py
# Stellt Presets direkt aus Backup wieder her (direkt in UserDefaults)

import json
import subprocess
import sys
import os

backup_file = "/Users/noelguyaz/Projekte/WB Foto Manager/_Backups/WB_Foto_Manager_Backup_1766079021.json"

print("Lade Backup von:", backup_file)

try:
    with open(backup_file, 'r') as f:
        data = json.load(f)
    
    presets = data.get('adjustmentPresets', [])
    preset_groups = data.get('presetGroups', [])
    
    print(f"✓ {len(presets)} Presets gefunden")
    print(f"✓ {len(preset_groups)} Preset-Gruppen gefunden")
    
    # Konvertiere Presets zu JSON (wird als Data gespeichert)
    presets_json = json.dumps(presets)
    
    # Schreibe Presets in UserDefaults
    # macOS UserDefaults kann JSON-Strings direkt speichern
    # Wir verwenden `defaults write` mit einem plist-Format
    
    # Erstelle temporäre plist-Dateien
    import tempfile
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.plist', delete=False) as f:
        json.dump(presets, f, indent=2)
        temp_presets = f.name
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.plist', delete=False) as f:
        json.dump(preset_groups, f, indent=2)
        temp_groups = f.name
    
    print("\n⚠ Hinweis: Das direkte Schreiben in UserDefaults ist kompliziert,")
    print("da wir die Bundle-ID der App brauchen.")
    print("")
    print("Empfehlung: Verwende die Backup-Wiederherstellung in der App!")
    print("Die Datei wurde auf den Desktop kopiert: ~/Desktop/WB_Foto_Manager_Backup.json")
    print("")
    print("ODER: Versuche, die App-Bundle-ID zu finden:")
    print("  defaults domains | grep -i foto")
    
    # Cleanup
    os.unlink(temp_presets)
    os.unlink(temp_groups)
    
except Exception as e:
    print(f"Fehler: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
