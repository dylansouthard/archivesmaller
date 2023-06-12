//
//  ClearBackground.swift
//  ArchiveSmaller
//
//  Created by Dylan Southard on 2023-06-12.
//

import SwiftUI
import Foundation

struct ClearBackgroundView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.isEmphasized = true
        view.material = .appearanceBased
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}
