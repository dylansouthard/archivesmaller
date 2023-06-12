//
//  ArchiveController.swift
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

enum ArchiveStatus:String {
    case standby
    case inProcess
    case success
    case fail
    case cancelled
}

extension ArchiveStatus {
    var display:String {
        switch self {
        case .standby, .inProcess:
            return ""
        case .success:
            return "Success!"
        case .fail:
            return "Failed!"
        case .cancelled:
            return "Cancelled"
        }
    }
}




class ArchiveController:ObservableObject {
    static let shared:ArchiveController = ArchiveController()
    @Published var presetNames = Prefs.presetNames
    
    //MARK: - === FILES ===
    @Published var url:URL?
    @Published var toExclude:[String] = [] {
        didSet {
            toExcludeTxt = toExclude.joined(separator: ", ")
        }
    }
    @Published var toExcludeTxt:String = ""
    @Published var toExcludeExact:[String] = [] {
        didSet {
            toExcludeExactTxt = toExcludeExact.joined(separator: ", ")
        }
    }
    @Published var toExcludeExactTxt:String = ""
    
    //MARK: - === SETTTINGS ===
    @Published var createZip = true
    @Published var cancel = false

    //MARK: - === STATUS VARS ===
    @Published var errors:[Error] = []
    @Published var status:ArchiveStatus = .standby {
        didSet {
            inProcess = status == .inProcess
            if !(status == .inProcess || status == .standby) {
                self.progressTxt = status.display
            }
        }
    }
    @Published var inProcess:Bool = false
    @Published var progressTxt:String = ""
    @Published var showErrorMessage:Bool = false
 
    
    //MARK: - =============== FUNCTIONS ===============
    
    func execute() {
        guard let url = self.url else {return}
        self.errors = []
        self.cancel = false
        self.progressTxt = ""
        self.status = .inProcess
        
        copyDirectory(url) {newURL in
            if self.createZip {
                self.progressTxt = "Archiving..."
                FileManager.zip(newURL) {zipURL in
                    self.status = .success
                    self.showErrors()
                   FileManager.DeleteFile(atURL: zipURL.deletingPathExtension())
                }
            } else {
                self.status = .success
                self.showErrors()
            }
        }
    }
    
    func copyDirectory(_ url:URL, onComplete:@escaping (URL)->Void) {
  
        let srcName = url.lastPathComponent
        let destName = srcName + Prefs.archiveName + Date.currentString(Prefs.dateFormat)
        guard let newFolder = FileManager.CreateFolder(withName: destName, at: url.deletingLastPathComponent()) else {return}

        FileManager.enumerateAndCopy(
            from: url,
            to: newFolder,
            excluding: toExclude,
            excludingExact: toExcludeExact,
            updateProgress: {url in
                self.progressTxt = "Copying \(url.lastPathComponent)"
            },
            shouldCancel: {return self.cancel},
            onCancel:{self.status = .cancelled}
        ) {url, err in
                
                self.errors.append(contentsOf: err)
                onComplete(url)
            }
    }
    
    func showErrors() {
        if self.errors.count > 0 {
            self.showErrorMessage = true
        }
    }
    
    func cancelProcess() {
        self.cancel = true
        FileManager.currentZipProcess?.terminate()
        self.status = .cancelled
    }
    
}
