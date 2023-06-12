//
//  ContentView.swift
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


import SwiftUI

struct ContentView: View {
   
    @ObservedObject var ac = ArchiveController.shared

    var body: some View {
        VStack {
           
            
            PresetView()
            Divider()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Toggle(isOn: $ac.createZip) {
                        Text("Create .zip archive")
                    }
                }
                
                DropView(txt:"Drop a directory here to archive", disabled:$ac.inProcess){url, _ in
                    self.ac.url = url
                    self.ac.execute()
                }
                .padding()
                
                HStack {
                    Text(ac.progressTxt)
                    
                    if ac.inProcess {
                        Spacer()
                        Button("Cancel") {
                            self.ac.cancelProcess()
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .sheet(isPresented: $ac.showErrorMessage) {
            ErrorSheet(errors: $ac.errors, showing:$ac.showErrorMessage)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
