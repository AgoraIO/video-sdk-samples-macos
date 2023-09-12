//
//  GitHubButtonView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 28/07/2023.
//

import SwiftUI

struct GitHubButtonView: View {
    let url: URL?
    static let repoBase = "https://github.com/AgoraIO/video-sdk-samples-macos/tree/main/"

    init(_ path: String) {
        self.url = URL(string: GitHubButtonView.repoBase + path)
        print("url: \(self.url?.absoluteString ?? "")")
    }

    var body: some View {
        if let url {
            Button(action: {
                openURL(url)
            }, label: {
                Image(nsImage: NSImage(
                    named: "github-mark\(colorScheme == .dark ? "-white" : "")")!
                ).resizable().frame(width: 24, height: 24)
            })
        }
    }

    func openURL(_ url: URL) {
        #if os(iOS)
        if NSApplication.shared.canOpenURL(url) {
            NSApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        #endif
        #if os(macOS)
        if NSWorkspace.shared.urlForApplication(toOpen: url) != nil {
            NSWorkspace.shared.open(url)
        }
        #endif
    }

    @Environment(\.colorScheme) var colorScheme
}

struct GitHubButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubButtonView(".")
    }
}
