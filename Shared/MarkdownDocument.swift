//
//  MarkdownDocument.swift
//  Shared
//
//  Created by Philipp on 05.09.20.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var markdown: UTType {
        UTType(importedAs: "net.daringfireball.markdown")
    }
}

struct MarkdownDocument: FileDocument {
    var text: String
    let name: String
    var fileURL: URL? {
        didSet {
            print("MarkdownDocument fileURL set to \(fileURL)")
        }
    }

    init(text: String = "# Hello, world!", name: String = "Unnamed", fileURL: URL? = nil) {
        self.text = text
        self.name = name
        self.fileURL = fileURL
    }

    static var readableContentTypes: [UTType] { [.markdown] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
        name = "Unnamed"
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
