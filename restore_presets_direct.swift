#!/usr/bin/env swift
//
// restore_presets_direct.swift
// Stellt Presets direkt aus Backup wieder her (verwendet Python für UserDefaults-Zugriff)
//
// Usage: swift restore_presets_direct.swift
//

// Da Swift-Scripts nicht auf die App-Frameworks zugreifen können,
// verwenden wir Python, um die UserDefaults direkt zu schreiben

import Foundation

let backupPath = "/Users/noelguyaz/Projekte/WB Foto Manager/_Backups/WB_Foto_Manager_Backup_1766079021.json"

print("⚠ Dieses Script kann nicht direkt verwendet werden, da es die App-Frameworks benötigt.")
print("")
print("Lösung: Verwende die Backup-Wiederherstellung in der App!")
print("Die Backup-Datei wurde auf den Desktop kopiert: ~/Desktop/WB_Foto_Manager_Backup.json")
print("")
print("Alternativ: Ich erstelle ein Python-Script, das die UserDefaults direkt schreibt.")
