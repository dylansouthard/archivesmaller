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


import SwiftUI


struct CustomDropDelegate: DropDelegate {
//    @Binding var droppedURL:URL?
    var acceptedTypes:[DroppableType]
    var onDrop:(URL, DroppableType)->Void
   
    
    func validateDrop(info: DropInfo) -> Bool {
        
        return info.hasItemsConforming(to: ["public.file-url"])
    }
    
    func performDrop(info: DropInfo) -> Bool {
        
        if let item = info.itemProviders(for: ["public.file-url"]).first {
            
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    
                    if let urlData = urlData as? Data {
                        
                        let _url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        if _url.hasDirectoryPath && acceptedTypes.contains(.folder){
                    
//                            droppedURL = _url
                            onDrop(_url, .folder)
                        }
                        
                        for type in acceptedTypes {
                            if type.acceptedTypes.joined().contains(_url.pathExtension) {
//                                droppedURL = _url
                                onDrop(_url, type)
                            }  else {
                                
                            }
                        }
                        
                    }
                }
            }
            
            return true
            
        } else {
            return false
        }
    }
}


struct DroppedURL {
    var url:URL
    var type:DroppableType
}

struct MultiDropDelegate: DropDelegate {
    var onDrop:([DroppedURL])->Void
    var acceptedTypes:[DroppableType]
    
    
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.file-url"])
        
    }
    
    func performDrop(info: DropInfo) -> Bool {
        
        
        let items = info.itemProviders(for: ["public.file-url"])
        if items.count > 0 {
            
            
            var droppedURLs = [DroppedURL]()
            var urlsExamined = 0
            
            for item in items {
                
                item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    
                    DispatchQueue.main.async {
                        if let urlData = urlData as? Data {
                            
                            let _url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                            if _url.hasDirectoryPath && acceptedTypes.contains(.folder){
                                
                                droppedURLs.append(DroppedURL(url:_url, type:DroppableType.folder))
                            }
                            
                            for type in acceptedTypes {
                                if type.acceptedTypes.contains(_url.pathExtension) {
                                    
                                    droppedURLs.append(DroppedURL(url:_url, type:type))
                                }
                            }
                            
                            if acceptedTypes.map({$0.acceptedTypes}).joined().contains(_url.pathExtension) {
                                
                            }
                            
                        }
                        urlsExamined += 1
                        if urlsExamined == items.count && droppedURLs.count > 0 {
                            
                            self.onDrop(droppedURLs)
                        }
                    }
                }
            }
            return true
            
        } else {
            return false
        }
    }
}


enum DroppableType:CaseIterable {
    
    case folder
    case zip
    
    var acceptedTypes:[String] {
        switch self {
        case .zip:
            return ["zip"]
        case .folder:
            return []
        }
    }
}
