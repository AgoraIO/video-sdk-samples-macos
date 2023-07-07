//
//  RPSystemBroadcastPickerWrapper.swift
//  Docs-Examples
//
//  Created by Max Cobb on 24/05/2023.
//

import SwiftUI
import ReplayKit

struct RPSystemBroadcastPickerWrapper: NSViewRepresentable {
    var preferredExtension: String?

    func makeNSView(context: Context) -> NSView {
        let broadcastPicker = NSView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        return broadcastPicker
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
