//
//  OnboardingSymbol.swift
//  Cinefiled
//
//  Created by Dylan Southard on 2023-05-11.
//

import SwiftUI

struct HoverableSystemIcon: View {
    @Binding var hovered:Bool
    var imageName:String =  "folder.badge.plus"
    var initialColor:Color = .primary
    var hoveredColor:Color = .secondary
    var animationDuration:CGFloat = 0.2
    
    var body: some View {
        
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .foregroundColor(hovered ? hoveredColor : initialColor)
            .animation(hovered ? .linear(duration: animationDuration) : nil)
           
    }
        
        
}

struct OnboardingSymbol_Previews: PreviewProvider {
    static var previews: some View {
        HoverableSystemIcon(hovered:.constant(false))
    }
}
