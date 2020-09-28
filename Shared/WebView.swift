//
//  WebView.swift
//  Markdown
//
//  Created by Philipp on 06.09.20.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        print("\(#function)")
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.loadHTMLString(html, baseURL: nil)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("\(#function)")
        context.coordinator.load(webView: uiView, html: html)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let parent: WebView
        var oldHtml: String = ""

        init(parent: WebView) {
            self.parent = parent
        }

        func load(webView: WKWebView, html: String) {
            print("\(#function)")
            guard html != oldHtml else {
                return
            }
            webView.loadHTMLString(html, baseURL: nil)
            oldHtml = html
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // do not allow navigating away from document
            let decision: WKNavigationActionPolicy = navigationAction.navigationType == .linkActivated && !(navigationAction.request.url?.host ?? "").isEmpty ? .cancel : .allow
            print("\(#function): navigationAction=\(navigationAction) request=\(navigationAction.request.url?.host) ==> decision: \(decision.rawValue)")
            decisionHandler(decision)
        }
    }
}
