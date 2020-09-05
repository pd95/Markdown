//
//  MarkDownApp.swift
//  Shared
//
//  Created by Philipp on 05.09.20.
//

import SwiftUI

@main
struct MarkDownApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MarkDownDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
