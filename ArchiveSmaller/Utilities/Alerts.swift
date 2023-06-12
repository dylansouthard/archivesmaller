//
//  Alerts.swift
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


class Alert:NSObject {
    
    static func PresentErrorAlert(text:String) {
        
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        let _ = alert.runModal()
        
    }
    
    static func PresentConfirmationAlert(messageText text:String, confirmText:String, cancelText:String = "Nevermind", onConfirm:@escaping ()->Void, onCancel: @escaping ()->Void = {}) {
        
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: confirmText)
        alert.addButton(withTitle: cancelText)
        
        let response = alert.runModal()
        
        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
            onConfirm()
        }
        
        if response == NSApplication.ModalResponse.alertSecondButtonReturn {
            onCancel()
        }
        
    }
    
    static func GetUserInput(message:String, placeholderText:String?)->String? {
        
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")      // 1st button
        alert.addButton(withTitle: "Cancel")  // 2nd button
        alert.messageText = message
        
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = placeholderText ?? ""
        //self.textField = txt
        alert.accessoryView = txt
        let response: NSApplication.ModalResponse = alert.runModal()
        
       
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            
            return txt.stringValue
            
        }
        
        return nil
    }
    
    
}
