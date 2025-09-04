//
//  MdParser.swift
//  SwiftBaseApp
//
//  Created by blue on 2025/9/4.
//

import SwiftUI
import Down
import WebKit

struct MarkdownParserView: View {
    @State private var markdownContent: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 文件信息头部
                    headerView
                    
                    Divider()
                    
                    // 内容展示区域
                    contentView
                }
                .padding()
            }
            .navigationTitle("Markdown 解析器")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadMarkdownFile()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("test.md")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("SwiftUI 数据流和状态管理学习清单")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if let error = errorMessage {
                Label(error, systemImage: "exclamationmark.triangle")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            VStack(spacing: 16) {
                ProgressView("正在加载 Markdown 文件...")
                    .progressViewStyle(CircularProgressViewStyle())
                
                Text("解析文档内容中...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 200)
        } else if let error = errorMessage {
            errorView
        } else {
            markdownRenderView
        }
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("加载失败")
                .font(.headline)
            
            Text(errorMessage ?? "未知错误")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("重新加载") {
                loadMarkdownFile()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    // MARK: - Markdown Render View
    private var markdownRenderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 渲染选项
            HStack {
                Label("Down 库渲染", systemImage: "doc.richtext")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(markdownContent.count) 字符")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // 使用 Down 库渲染 Markdown
            DownView(markdownContent: markdownContent)
                .frame(minHeight: 400)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Load Markdown File
    private func loadMarkdownFile() {
        isLoading = true
        errorMessage = nil
        
        // 异步加载文件内容
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 获取文件路径
                let fileURL = Bundle.main.url(forResource: "test", withExtension: "md", subdirectory: "Features/Documentation/Home")
                
                if let fileURL = fileURL {
                    let content = try String(contentsOf: fileURL, encoding: .utf8)
                    
                    DispatchQueue.main.async {
                        self.markdownContent = content
                        self.isLoading = false
                    }
                } else {
                    // 如果 Bundle 中找不到，尝试从项目路径读取
                    let projectPath = "/Users/blue/Documents/belle-work/SwiftBaseApp/SwiftBaseApp/Features/Documentation/Home/test.md"
                    let projectURL = URL(fileURLWithPath: projectPath)
                    let content = try String(contentsOf: projectURL, encoding: .utf8)
                    
                    DispatchQueue.main.async {
                        self.markdownContent = content
                        self.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "文件读取失败: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Down View Wrapper
struct DownView: UIViewRepresentable {
    let markdownContent: String
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.systemBackground
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // 清除之前的内容
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        do {
            // 使用 Down 库解析 Markdown
            let down = Down(markdownString: markdownContent)
            
            // 创建自定义样式的 CSS
            let css = """
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    color: #333;
                    max-width: 100%;
                    margin: 0;
                    padding: 20px;
                }
                
                h1, h2, h3, h4, h5, h6 {
                    color: #2c3e50;
                    margin-top: 24px;
                    margin-bottom: 16px;
                    font-weight: 600;
                }
                
                h1 { font-size: 28px; border-bottom: 2px solid #eee; padding-bottom: 8px; }
                h2 { font-size: 24px; border-bottom: 1px solid #eee; padding-bottom: 4px; }
                h3 { font-size: 20px; }
                h4 { font-size: 18px; }
                
                p {
                    margin-bottom: 16px;
                }
                
                ul, ol {
                    margin-bottom: 16px;
                    padding-left: 24px;
                }
                
                li {
                    margin-bottom: 4px;
                }
                
                code {
                    background-color: #f8f9fa;
                    padding: 2px 6px;
                    border-radius: 4px;
                    font-family: 'SF Mono', Consolas, 'Liberation Mono', Menlo, monospace;
                    font-size: 14px;
                }
                
                pre {
                    background-color: #f8f9fa;
                    padding: 16px;
                    border-radius: 8px;
                    overflow-x: auto;
                    margin-bottom: 16px;
                }
                
                pre code {
                    background-color: transparent;
                    padding: 0;
                }
                
                blockquote {
                    border-left: 4px solid #007AFF;
                    margin: 16px 0;
                    padding-left: 16px;
                    font-style: italic;
                    color: #666;
                }
                
                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin-bottom: 16px;
                }
                
                th, td {
                    border: 1px solid #ddd;
                    padding: 8px 12px;
                    text-align: left;
                }
                
                th {
                    background-color: #f8f9fa;
                    font-weight: 600;
                }
                
                .task-list-item {
                    list-style-type: none;
                }
                
                .task-list-item input[type="checkbox"] {
                    margin-right: 8px;
                }
                
                hr {
                    border: none;
                    border-top: 1px solid #eee;
                    margin: 24px 0;
                }
                
                @media (prefers-color-scheme: dark) {
                    body { color: #fff; background-color: #1c1c1e; }
                    h1, h2, h3, h4, h5, h6 { color: #fff; }
                    h1, h2 { border-bottom-color: #333; }
                    code, pre { background-color: #2c2c2e; }
                    blockquote { color: #999; }
                    th { background-color: #2c2c2e; }
                    th, td { border-color: #333; }
                    hr { border-top-color: #333; }
                }
            """
            
            // 转换为 HTML
            let html = try down.toHTML()
            
            // 创建完整的 HTML 文档
            let fullHTML = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>\(css)</style>
                </head>
                <body>\(html)</body>
                </html>
            """
            
            // 创建 WKWebView 来显示 HTML
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.loadHTMLString(fullHTML, baseURL: nil)
            
            uiView.addSubview(webView)
            
            // 设置约束
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: uiView.topAnchor),
                webView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
                webView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
                webView.heightAnchor.constraint(greaterThanOrEqualTo: uiView.heightAnchor)
            ])
            
        } catch {
            // 如果解析失败，显示错误信息
            let label = UILabel()
            label.text = "Markdown 解析失败: \(error.localizedDescription)"
            label.textColor = UIColor.systemRed
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            
            uiView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -20)
            ])
        }
    }
}

#Preview {
    MarkdownParserView()
}
