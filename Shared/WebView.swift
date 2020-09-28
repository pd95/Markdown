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
    let indexHtmlUrl: URL
    let injectHtml: String

    func makeUIView(context: Context) -> WKWebView {
        print("\(#function)")

        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator

        webView.load(URLRequest(url: indexHtmlUrl))

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("\(#function)")
        context.coordinator.load(webView: uiView, html: injectHtml)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let parent: WebView
        var oldHtml: String = ""
        var delayedHtml: String = ""
        var runningHtml: String = ""

        init(parent: WebView) {
            self.parent = parent
        }

        func load(webView: WKWebView, html: String) {
            print("\(#function)")
            guard html != oldHtml else {
                print("Skip loading, same data")
                return
            }
            guard html != runningHtml else {
                print("Skip loading, already running with same HTML")
                return
            }

            if webView.isLoading {
                print("Skip loading")
                delayedHtml = html
            }
            else {
                print("calling setBody()")
                runningHtml=html
                let script = "setBody(`\(html.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "`", with: "\\`"))`)"
                //print(script)
                webView.evaluateJavaScript(script) { (x, error) in
                    if let error = error {
                        print("error=\(error)")
                    }
                    else {
                        self.oldHtml = html
                        self.delayedHtml = ""
                        self.runningHtml = ""
                    }
                }
            }
        }

        // MARK: WKUIDelegate
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // do not allow navigating away from document
            let decision: WKNavigationActionPolicy = navigationAction.navigationType == .linkActivated && !(navigationAction.request.url?.host ?? "").isEmpty ? .cancel : .allow
            print("\(#function): navigationAction=\(navigationAction) request=\(navigationAction.request.url?.host) ==> decision: \(decision.rawValue)")
            decisionHandler(decision)
        }

        // MARK: WKNavigationDelegate
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !webView.isLoading {
                load(webView: webView, html: delayedHtml)
            }
        }
    }
}
