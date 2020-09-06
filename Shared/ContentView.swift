//
//  ContentView.swift
//  Shared
//
//  Created by Philipp on 05.09.20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MarkdownDocument

    var body: some View {
        TabView {
            MarkdownView(viewModel: ViewModel(document: $document))
                .tabItem {
                    Label("View", systemImage: "eye")
                }
            TextEditor(text: $document.text)
                .tabItem {
                    Label("Edit", systemImage: "pencil")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var document = MarkdownDocument()
    static var previews: some View {
        ContentView(document: $document)
    }
}
