//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    public var url: URL
    
    private let webView: WKWebView
    
    init(_ url: URL) {
        self.url = url
        webView = WKWebView(frame: .zero)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}

#Preview {
    WebView(URL(string: "https://google.com")!)
}
