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
    let options = CMARK_OPT_UNSAFE

    cmark_gfm_core_extensions_ensure_registered()

    guard let parser = cmark_parser_new(options) else {
        return nil
    }
    defer {
        cmark_parser_free(parser)
    }

    // Attach parser extensions
    for extensionName in ["table","autolink","strikethrough","tasklist"] {
        let foundExtension = cmark_find_syntax_extension(extensionName)
        if cmark_parser_attach_syntax_extension(parser, foundExtension) != 0 {
            print("Attached extension \(extensionName)")
        }
        else {
            print("Unable to attach extension \(extensionName)")
        }
    }

    cmark_parser_feed(parser, string, string.utf8.count)

    guard let doc = cmark_parser_finish(parser) else {
        return nil
    }
    defer {
        cmark_node_free(doc);
    }

    // Enable HTML specific extension to render output
    var htmlExtensions: UnsafeMutablePointer<cmark_llist>?
    if let tagfilter = cmark_find_syntax_extension("tagfilter") {
        htmlExtensions = cmark_llist_append(cmark_get_default_mem_allocator(), nil, tagfilter)
    }
    guard let html = cmark_render_html(doc, options, htmlExtensions) else {
        return nil
    }
    defer {
        free(html)
    }

    return String(cString: html)
}

class ViewModel: ObservableObject {
    @Binding var document: MarkdownDocument
    @Published var html: String = ""

    init(document: Binding<MarkdownDocument>) {
        _document = document
        renderHTML()
    }

    func renderHTML() {
        let text = document.text
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let html = renderMarkdown(text) {
                DispatchQueue.main.async {
                    self.html = html
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
        WebView(indexHtmlUrl: Bundle.main.url(forResource: "index", withExtension: "html")!, injectHtml: viewModel.html)
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
