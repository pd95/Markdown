//
//  MarkdownView.swift
//  Markdown
//
//  Created by Philipp on 06.09.20.
//

import SwiftUI
import cmark_gfm

let testMarkDown: String = {
    guard let resourceUrl = Bundle.main.url(forResource: "test", withExtension: "md"),
          let data = try? Data(contentsOf: resourceUrl),
          let string = String(data: data, encoding: .utf8)
    else {
        return "# test.md could not be loaded"
    }
    return string
}()

let stylesCSS: String = {
    guard let resourceUrl = Bundle.main.url(forResource: "styles", withExtension: "css"),
          let data = try? Data(contentsOf: resourceUrl),
          let string = String(data: data, encoding: .utf8)
    else {
        return "# styles.css could not be loaded"
    }
    return string
}()


let templateHTML: String = {
    guard let resourceUrl = Bundle.main.url(forResource: "template", withExtension: "html"),
          let data = try? Data(contentsOf: resourceUrl),
          let string = String(data: data, encoding: .utf8)
    else {
        return "test.html could not be loaded"
    }
    return string.replacingOccurrences(of: "___CSS___", with: stylesCSS)
}()

func renderMarkdown(_ string: String) -> String? {
    let options = CMARK_OPT_DEFAULT

    cmark_gfm_core_extensions_ensure_registered()

    guard let parser = cmark_parser_new(options) else {
        return nil
    }

    defer {
        cmark_parser_free(parser)
    }

    for extensionName in ["table","autolink","strikethrough","tagfilter","tasklist"] {
        if let foundExtension = cmark_find_syntax_extension(extensionName) {
            cmark_parser_attach_syntax_extension(parser, foundExtension)
        }
        else {
            print("Unable to attach extension \(extensionName)")
        }
    }

    cmark_parser_feed(parser, string, string.utf8.count)

    guard let doc = cmark_parser_finish(parser) else {
        return nil
    }
    let html = cmark_render_html(doc, options, nil);
    cmark_node_free(doc);

    if let strPointer = html {
        let output = String(cString: strPointer)
        free(html)
        return output
    }
    return nil
}

class ViewModel: ObservableObject {
    @Binding var document: MarkdownDocument
    let template: String
    @Published var html: String = ""

    init(document: Binding<MarkdownDocument>) {
        _document = document
        template = templateHTML.replacingOccurrences(of: "___CSS___", with: stylesCSS)
            .replacingOccurrences(of: "___TITLE___", with: document.wrappedValue.name)
        renderHTML()
    }

    func renderHTML() {
        let text = document.text
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let html = renderMarkdown(text) {
                print(html)
                let finalHTML = templateHTML.replacingOccurrences(of: "___MARKDOWN___", with: html)
                DispatchQueue.main.async {
                    self.html = finalHTML
                }
            }
            else {
                print("Error processing: \(text)")
            }
        }
    }
}

struct MarkdownView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        WebView(html: viewModel.html)
            .onChange(of: viewModel.document.text, perform: { value in
                viewModel.renderHTML()
            })
    }
}

struct MarkdownView_Previews: PreviewProvider {
    @State static var document = MarkdownDocument()
    static var previews: some View {
        MarkdownView(viewModel: ViewModel(document: $document))
    }
}
