//
// restore_presets_from_backup.swift
// Wiederherstellung der Presets aus Backup-Datei
//
// Usage: swift restore_presets_from_backup.swift
//

import Foundation

// Backup-Pfad (absoluter Pfad)
let backupPath = "/Users/noelguyaz/Projekte/WB Foto Manager/_Backups/WB_Foto_Manager_Backup_1766079021.json"

print("Lade Backup von: \(backupPath)")

// Lade Backup-Datei
guard let backupData = FileManager.default.contents(atPath: backupPath),
      let backup = try? JSONSerialization.jsonObject(with: backupData) as? [String: Any] else {
    print("Fehler: Backup-Datei konnte nicht geladen werden")
    exit(1)
}

print("Backup erfolgreich geladen")

// Extrahiere Presets
if let adjustmentPresets = backup["adjustmentPresets"] as? [[String: Any]] {
    // Konvertiere zu JSON-String
    if let jsonData = try? JSONSerialization.data(withJSONObject: adjustmentPresets),
       let jsonString = String(data: jsonData, encoding: .utf8) {
        UserDefaults.standard.set(jsonString, forKey: "adjustmentPresetsV1")
        print("✓ \(adjustmentPresets.count) Adjustment Presets in UserDefaults geschrieben")
    } else {
        print("Fehler: Presets konnten nicht serialisiert werden")
    }
} else {
    print("Warnung: Keine adjustmentPresets im Backup gefunden")
}

// Extrahiere Preset-Gruppen
if let presetGroups = backup["presetGroups"] as? [String] {
    if let jsonData = try? JSONSerialization.data(withJSONObject: presetGroups),
       let jsonString = String(data: jsonData, encoding: .utf8) {
        UserDefaults.standard.set(jsonString, forKey: "presetGroupsV1")
        print("✓ \(presetGroups.count) Preset-Gruppen in UserDefaults geschrieben")
    } else {
        print("Fehler: Preset-Gruppen konnten nicht serialisiert werden")
    }
} else {
    print("Warnung: Keine presetGroups im Backup gefunden")
}

// Synchronisiere UserDefaults
UserDefaults.standard.synchronize()

print("\n✅ Wiederherstellung abgeschlossen!")
print("Bitte App neu starten, damit die Presets geladen werden.")
