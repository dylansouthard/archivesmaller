//
//  UserPrefs.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-06-11.
//
//Copyright (C) 2023  Dylan Southard
//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <https://www.gnu.org/licenses/>.


import Foundation

class Prefs {
    
    static var archiveName:String {
        get { return UserDefaults.standard.string(forKey: "archive_name") ?? "_archive_" }
        set { UserDefaults.standard.set(newValue, forKey: "archive_name") }
    }
    
    static var dateFormat:String {
        get { return UserDefaults.standard.string(forKey: "date_format") ?? "yyyy-MM-dd_HH-mm-ss" }
        set { UserDefaults.standard.set(newValue, forKey: "date_format") }
    }
    
    static var presetNames:[String] {
        get {UserDefaults.standard.array(forKey: "presets") as? [String] ?? []}
        set {
            UserDefaults.standard.set(newValue, forKey: "presets")
            ArchiveController.shared.presetNames = newValue
        }
    }
    
    
    static func getPresets(for preset:String) {
        
    }
    
    static func savePresets(_ preset:Preset) {
        var pNames = presetNames
        if !pNames.contains(preset.name) {
            pNames.append(preset.name)
            presetNames = pNames
        }
        
        UserDefaults.standard.set(preset.excludeExact, forKey: "\(preset.name)_exact")
        UserDefaults.standard.set(preset.excludeAny, forKey: "\(preset.name)_any")
    }
    
    static func exactExclusions(for name:String)->[String] {
       return UserDefaults.standard.array(forKey: "\(name)_exact") as? [String] ?? []
    }
    
    static func anyExclusions(for name:String)->[String] {
       return UserDefaults.standard.array(forKey: "\(name)_any") as? [String] ?? []
    }
    
    
}
