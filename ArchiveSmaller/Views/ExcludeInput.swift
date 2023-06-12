//
//  ExcludeInput.swift
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

struct ExcludeInput: View {
    var label:String
    @Binding var txt:String
    @Binding var values:[String]
   
    var body: some View {
        HStack {
            Text(label)
            TextField("", text: $txt, onCommit: {
                let arr = txt.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                values = arr
            })
        }
        .onAppear{
            txt = values.joined(separator: ", ")
        }
    }
}

struct ExcludeInput_Previews: PreviewProvider {
    static var previews: some View {
        ExcludeInput(label:"Exclude any", txt:.constant(""), values:.constant([])) 
    }
}