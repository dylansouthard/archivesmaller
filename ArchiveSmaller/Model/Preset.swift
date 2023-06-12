//
//  Preset.swift
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

struct Preset {
    var name:String
    var excludeAny:[String] = [] {
        didSet {
            Prefs.savePresets(self)
        }
    }
    var excludeExact:[String] = [] {
        didSet {
            Prefs.savePresets(self)
        }
    }
    
    static func withName(_ name:String)->Preset {
        return Preset(name: name, excludeAny: Prefs.anyExclusions(for: name), excludeExact: Prefs.exactExclusions(for: name))
    }
    
}
