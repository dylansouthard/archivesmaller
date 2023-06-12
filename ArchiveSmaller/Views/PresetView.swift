//
//  PresetView.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-06-12.
//

import SwiftUI

struct PresetView: View {
    @State var selectedPreset:String = "none"
    @ObservedObject var ac = ArchiveController.shared
    var body: some View {
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
            ExcludeInput(label: "Exclude", txt:$ac.toExcludeTxt, values:$ac.toExclude, onCommit: ac.commitTextValues)
            ExcludeInput(label: "Exclude Exact", txt:$ac.toExcludeExactTxt, values:$ac.toExcludeExact, onCommit: ac.commitTextValues)
            HStack {
                Button("Save Preset") {
                    var name:String = selectedPreset
                    if name == "none" {
                        name = Alert.GetUserInput(message: "Enter a name for your preset", placeholderText: "name") ?? "none"
                    }
                    
                    if name == "none" {return}
                    self.ac.commitTextValues()
                    
                    let p = Preset(name: name, excludeAny: ac.toExclude, excludeExact: ac.toExcludeExact)
                    self.selectedPreset = name
                    Prefs.savePresets(p)
                }
                Button("Delete Preset") {
                    let p = Preset.withName(selectedPreset)
                    Alert.presentConfirmationAlert(messageText: "Are you sure you want to delete the preset \(selectedPreset)?\nThis cannot be undone", confirmText: "Do it!") {
                        Prefs.deletePreset(p)
                        print("resetting \(ac.presetNames)")
                        self.selectedPreset = ac.presetNames.count > 0 ? ac.presetNames[0] : "none"
                    }
                }
                .disabled(selectedPreset == "none")
            }
            
        }
        .padding()
        .onAppear {
            if ac.presetNames.count > 0 {
                self.selectedPreset = ac.presetNames[0]
            }
        }
    }
}

struct PresetView_Previews: PreviewProvider {
    static var previews: some View {
        PresetView()
    }
}
