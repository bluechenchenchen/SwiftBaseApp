//
//  DocDetailView.swift
//  iPhoneBaseApp
//
//  Created by blue on 2025/8/29.
//
import SwiftUI
import WebKit


//
struct WebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ webView: WKWebView, context: Context) {
    // 加载本地文件，允许读取同级目录的资源
    webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
  }
}


struct DocDetail: View {
  let docPath: String
  
  public init(path: String) {
    self.docPath = path
  }
  
  var body: some View {
    
    if let htmlURL = Bundle.main.url(forResource: "abc", withExtension: "html") {
      WebView(url: htmlURL)
    } else {
      Text("无法找到HTML文件")
    }
  }
}


#Preview {
  DocDetail(path: "/ddd")
}
