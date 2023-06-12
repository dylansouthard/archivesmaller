//
//  FileManager.swift
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
import Cocoa
extension FileManager {
    
    static var currentZipProcess:Process?
    
    static func CreateFolder(withName name:String, at destination:URL, withIntermediateDirectories:Bool = false)->URL? {
        
        let folder = destination.appendingPathComponent(name)
        
        if folder.hasDirectoryPath {
            return folder
        }
        
        do {
            
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            
            return folder
            
        } catch let error {
            Alert.PresentErrorAlert(text: "Error creating folder!\n\(error)")
            return nil
        }
    }
    
    static func enumerateAndCopy(from srcURL:URL, to destURL:URL, excluding:[String], excludingExact:[String], updateProgress:@escaping (URL)->Void, shouldCancel: @escaping () -> Bool, onCancel:@escaping ()-> Void, onComplete:@escaping (URL, [Error])->Void) {
        DispatchQueue.global().async {
            let fileManager = FileManager.default
            var errors:[Error] = []

            let enumerator = fileManager.enumerator(
                at: srcURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [],
                errorHandler: { url, error in
                    errors.append(error)
                    return true
                })!

            for case let fileURL as URL in enumerator {
                // Check if operation should be cancelled
                if shouldCancel() {
                    DispatchQueue.main.async{
                        onCancel()
                    }
                    
                    return
                }
                
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
                    let relativePath = fileURL.path.replacingOccurrences(of: srcURL.path, with: "")
                    let destFileURL = destURL.appendingPathComponent(relativePath)

                    if resourceValues.isDirectory == true {
                        let name = fileURL.lastPathComponent
                        if name.containsAny(excluding) || name.containsAny(excludingExact, exact: true) {
                            enumerator.skipDescendants()
                        } else {
                            DispatchQueue.main.async {updateProgress(fileURL)}
                            try fileManager.createDirectory(at: destFileURL, withIntermediateDirectories: true, attributes: nil)
                        }
                    } else {
                     
                        try fileManager.copyItem(at: fileURL, to: destFileURL)
                    }
                } catch let error {
                    errors.append(error)
                }
            }
            DispatchQueue.main.async {
                onComplete(destURL, errors)
            }
        }
    }
    
    static func DeleteFile(atURL url:URL, recycle:Bool = false, onComplete:()->Void = {}) {
        do {
            
            if recycle {
               
                NSWorkspace.shared.recycle([url])
            } else {
                try FileManager.default.removeItem(at: url)
            }
            
            onComplete()
        } catch let error {
            
            Alert.PresentErrorAlert(text: "Error deleting file: \(url.lastPathComponent)!" + error.localizedDescription)
            
        }
    }
    
    
    static func zip(_ srcURL:URL, onComplete:@escaping (URL)->Void) {

        DispatchQueue.global(qos: .background).async {
            let destinationURL = srcURL.appendingPathExtension(for: .zip)
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
            
            // Change the current directory to the parent directory of srcURL
            process.currentDirectoryURL = srcURL.deletingLastPathComponent()
            
            // Update the source path to be relative to the new current directory
            let relativeSrcPath = srcURL.lastPathComponent
            
            process.arguments = ["-r", destinationURL.path, relativeSrcPath]
            
            FileManager.currentZipProcess = process
            
            do {
                try process.run()
                process.waitUntilExit()
                DispatchQueue.main.async {
                    onComplete(destinationURL)
                }
            } catch let error {
                Alert.PresentErrorAlert(text: "Error zipping file \(error)")
            }
        }
    }
}
