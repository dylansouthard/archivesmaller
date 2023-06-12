//
//  AddLibraryView.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-05-11.
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

struct DropView: View {
    let txt:String? = nil
    @Binding var disabled:Bool
    let action:(URL, DroppableType)->Void
    @State private var allowDrag:Bool = true
    @State private var hovered:Bool = false
    let width:CGFloat = 400
    private let anidur:CGFloat = 0.2
    private let initialColor:Color = .primary
    private let hoveredColor:Color = .secondary
    
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width * (hovered ? 1 : 0)
                Rectangle()
                    .fill(hoveredColor.opacity(0.1))
                    .frame(width: width, height: geometry.size.height)
            }
            .frame(width:width, height:width)
            .clipShape(Ellipse())
            
            Ellipse()
                .stroke(initialColor.opacity(0.2), lineWidth: 4)
                .animation(.linear(duration: anidur))
                .frame(width:width, height:width)
            VStack {
                HoverableSystemIcon(hovered:$hovered, initialColor:initialColor, hoveredColor:hoveredColor, animationDuration:anidur)
                    .frame(width:100)
                
                   if let t = txt { Text(t)}
                
                
            }
            .padding(.horizontal, 30)
            .onDrop(of: ["public.url"], delegate: CustomDropDelegate(acceptedTypes: [.folder]) {url, type in
                action(url, type)
            }
                    
                    
            )
            .padding()
            .padding(.horizontal, 50)
            .allowsHitTesting(allowDrag && !disabled)
            .onHover { isHovering in
                withAnimation {
                    self.hovered = isHovering
                }
            }
        }
        
    }
    
}


