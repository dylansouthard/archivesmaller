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
   
    @State var selectedPreset:String = "none"
    @ObservedObject var ac = ArchiveController()

    var body: some View {
        VStack {
           
            VStack {
                Picker("Preset", selection:$selectedPreset) {
                    Text("none").tag("none")
                    ForEach(ac.presetNames, id:\.self) {name in
                        Text(name).tag(name)
                    }
                }
                .onChange(of: selectedPreset) { value in
                    if value != "none" {
                        let p = Preset.withName(value)
                        self.ac.toExclude = p.excludeAny
                        self.ac.toExcludeExact = p.excludeExact
                    } else {
                        self.ac.toExclude = []
                        self.ac.toExcludeExact = []
                    }
                }
                ExcludeInput(label: "Exclude", txt:$ac.toExcludeTxt, values:$ac.toExclude)
                ExcludeInput(label: "Exclude Exact", txt:$ac.toExcludeExactTxt, values:$ac.toExcludeExact)
                Button("Save Preset") {
                    var name:String = selectedPreset
                    if name == "none" {
                        name = Alert.GetUserInput(message: "Enter a name for your preset", placeholderText: "name") ?? "none"
                    }
                    
                    if name == "none" {return}
                    
                    let p = Preset(name: name, excludeAny: ac.toExclude, excludeExact: ac.toExcludeExact)
                    self.selectedPreset = name
                    Prefs.savePresets(p)
                }
            }
            .padding()
            
            Divider()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Toggle(isOn: $ac.createZip) {
                        Text("Create .zip archive")
                    }
                }
                
                DropView(txt:"Drop your directory here", disabled:$ac.inProcess){url, _ in
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
