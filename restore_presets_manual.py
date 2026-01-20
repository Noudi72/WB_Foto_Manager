#!/usr/bin/env python3
# restore_presets_manual.py
# Stellt Presets manuell wieder her

import json
import plistlib
import subprocess
import sys
import os
from pathlib import Path

backup_file = "/Users/noelguyaz/Projekte/WB Foto Manager/_Backups/WB_Foto_Manager_Backup_1766079021.json"

print("Lade Backup-Datei...")
with open(backup_file, 'r') as f:
    data = json.load(f)

presets = data.get('adjustmentPresets', [])
preset_groups = data.get('presetGroups', [])

print(f"✓ {len(presets)} Presets gefunden")
print(f"✓ {len(preset_groups)} Preset-Gruppen gefunden")

# Versuche, die Bundle-ID zu finden, indem wir nach bekannten UserDefaults-Keys suchen
# Die App verwendet "adjustmentPresets" und "presetGroups" als Keys

print("\nVersuche, die Bundle-ID zu finden...")
# Prüfe, ob wir die Daten direkt in UserDefaults schreiben können
# macOS UserDefaults speichert Daten unter der Bundle-ID

# Versuche verschiedene Bundle-IDs
possible_bundle_ids = [
    "com.wbfoto.WB-Foto-Manager",
    "com.wb.FotoManager", 
    "com.wbfoto.WBFotoManager",
    "WB-Foto-Manager"
]

print("\n⚠ Hinweis: Um die Presets direkt in UserDefaults zu schreiben,")
print("brauchen wir die Bundle-ID der App.")
print("\nAlternativ können wir die Daten in eine temporäre Datei schreiben")
print("und dann über die App importieren.")

# Erstelle eine vereinfachte Backup-Datei, die nur Presets enthält
simplified_backup = {
    "adjustmentPresets": presets,
    "presetGroups": preset_groups,
    "version": 1
}

output_file = os.path.join(os.path.expanduser("~"), "Desktop", "WB_Presets_Restore.json")
with open(output_file, 'w') as f:
    json.dump(simplified_backup, f, indent=2)

print(f"\n✓ Vereinfachte Backup-Datei erstellt: {output_file}")
print("Diese Datei enthält nur Presets und kann über die App wiederhergestellt werden.")
