//
//  ContentView.swift
//  Shared
//
//  Created by Philipp on 05.09.20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MarkDownDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(MarkDownDocument()))
    }
}
