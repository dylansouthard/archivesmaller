//
//  Protection.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-06-12.
//

import Foundation

class Protection {
    
   static let restrictedDirectories = [
        "/",
        "/System",
        "/Library",
        "/bin",
        "/sbin",
        "/usr",
        "/private",
        "/Volumes",
        "/dev",
        "/net",
        "/home",
        "/Applications",
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library").path
    ]
    
    
    
}

extension URL {
    var isRestricted:Bool {
        let path = self.path
        for restrictedDirectory in Protection.restrictedDirectories {
            if path == restrictedDirectory {
                return true
            }
        }
        return false
    }
}
