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
        DocumentGroup(newDocument: MarkdownDocument(text: testMarkDown)) { configuration -> ContentView in
            // Extract fileURL of document and pass it down to the MarkdownDocument
            if configuration.document.fileURL != configuration.fileURL {
                configuration.$document.wrappedValue.fileURL = configuration.fileURL
            }
            return ContentView(document: configuration.$document)
        }
    }
}
