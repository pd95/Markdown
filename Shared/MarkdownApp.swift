//
//  MarkdownApp.swift
//  Shared
//
//  Created by Philipp on 05.09.20.
//

import SwiftUI

@main
struct MarkdownApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument(text: testMarkDown)) { file -> ContentView in
            return ContentView(document: file.$document)
        }
    }
}
