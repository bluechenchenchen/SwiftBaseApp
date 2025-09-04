import SwiftUI
import Down
import WebKit

struct DocumentationHomeView: View {
    @StateObject private var documentService = DocumentService()
    @State private var path: String = ""
    @State private var expandedCategories: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            Group {
                if documentService.isLoading {
                    LoadingView()
                } else if let errorMessage = documentService.errorMessage {
                    ErrorView(message: errorMessage) {
                        documentService.loadDocuments()
                    }
                } else if documentService.rootCategories.isEmpty {
                    EmptyView()
                } else {
                    // 文档分类列表
                    DocumentCategoryListView(
                        categories: documentService.rootCategories,
                        expandedCategories: $expandedCategories,
                        documentService: documentService
                    )
                }
            }
            .navigationTitle("文档浏览")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // 确保文档被加载
            if documentService.rootCategories.isEmpty {
                documentService.loadDocuments()
            }
        }
    }
}

// MARK: - Document Category List View
struct DocumentCategoryListView: View {
    let categories: [DocumentCategory]
    @Binding var expandedCategories: Set<UUID>
    let documentService: DocumentService
    
    var body: some View {
        List {
            ForEach(categories, id: \.id) { category in
                DocumentCategoryRow(
                    category: category,
                    expandedCategories: $expandedCategories,
                    documentService: documentService
                )
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

// MARK: - Document Category Row
struct DocumentCategoryRow: View {
    let category: DocumentCategory
    @Binding var expandedCategories: Set<UUID>
    let documentService: DocumentService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 分类标题行
            HStack(spacing: 15) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color(category.color))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.headline)
                    
                    if category.totalDocumentCount > 0 {
                        Text("\(category.totalDocumentCount) 个文档")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // 展开/折叠按钮
                if !category.documents.isEmpty || !category.subCategories.isEmpty {
                    Button(action: {
                        if expandedCategories.contains(category.id) {
                            expandedCategories.remove(category.id)
                        } else {
                            expandedCategories.insert(category.id)
                        }
                    }) {
                        Image(systemName: expandedCategories.contains(category.id) ? "chevron.down" : "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
            
            // 展开的内容
            if expandedCategories.contains(category.id) {
                VStack(alignment: .leading, spacing: 8) {
                    // 子分类
                    if !category.subCategories.isEmpty {
                        ForEach(category.subCategories, id: \.id) { subCategory in
                            DocumentCategoryRow(
                                category: subCategory,
                                expandedCategories: $expandedCategories,
                                documentService: documentService
                            )
                            .padding(.leading, 20)
                        }
                    }
                    
                    // 文档列表
                    if !category.documents.isEmpty {
                        ForEach(category.documents, id: \.id) { document in
                            NavigationLink(destination: DocumentDetailView(document: document)) {
                                DocumentRow(document: document)
                            }
                            .padding(.leading, 20)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

// MARK: - Document Row
struct DocumentRow: View {
    let document: DocumentItem
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: document.type.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(document.displayName)
                    .font(.body)
                
                Text(document.fileName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Document Detail View
struct DocumentDetailView: View {
    let document: DocumentItem
    
    var body: some View {
        Group {
            switch document.type {
            case .markdown:
                MarkdownDocumentView(document: document)
            case .text:
                TextDocumentView(document: document)
            }
        }
        .navigationTitle(document.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Markdown Document View
struct MarkdownDocumentView: View {
    let document: DocumentItem
    @State private var markdownContent: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if let error = errorMessage {
                ErrorView(message: error) {
                    loadMarkdownFile()
                }
            } else {
                DownView(markdownContent: markdownContent)
            }
        }
        .onAppear {
            loadMarkdownFile()
        }
    }
    
    private func loadMarkdownFile() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let content = try String(contentsOfFile: document.fullPath, encoding: .utf8)
                
                DispatchQueue.main.async {
                    self.markdownContent = content
                    self.isLoading = false
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

// MARK: - Text Document View
struct TextDocumentView: View {
    let document: DocumentItem
    @State private var textContent: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if let error = errorMessage {
                ErrorView(message: error) {
                    loadTextFile()
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(textContent)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            loadTextFile()
        }
    }
    
    private func loadTextFile() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let content = try String(contentsOfFile: document.fullPath, encoding: .utf8)
                
                DispatchQueue.main.async {
                    self.textContent = content
                    self.isLoading = false
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



// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("正在加载文档...")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("加载失败")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("重试") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Empty View
extension DocumentationHomeView {
    private struct EmptyView: View {
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "doc.text")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                Text("暂无文档")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("docs文件夹中没有找到任何文档")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
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
    DocumentationHomeView()
}
