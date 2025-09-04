import SwiftUI
import Down
import WebKit

struct DocumentationHomeView: View {
  @StateObject private var documentService = DocumentService()
  @State private var path: String = ""
  @State private var expandedCategories: Set<UUID> = []
  @State private var searchText = ""
  
  var body: some View {
    NavigationStack {
      
      ScrollView() {
        // 顶部统计信息
        if !documentService.rootCategories.isEmpty {
          statisticsHeader
          //            .padding(.horizontal)
          // .padding(.top, 8)
        }
        
        // 内容区域
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
              categories: filteredCategories,
              expandedCategories: $expandedCategories,
              documentService: documentService
            )
          }
        }
      }
      .navigationTitle("📚 文档中心")
      
      .navigationBarTitleDisplayMode(.large)
      .searchable(text: $searchText, prompt: "搜索文档...")
      .background(Color(.systemGroupedBackground))
    }
    .onAppear {
      // 确保文档被加载
      if documentService.rootCategories.isEmpty {
        documentService.loadDocuments()
      }
    }
  }
  
  // MARK: - Statistics Header
  private var statisticsHeader: some View {
    HStack(spacing: 16) {
      StatisticCard(
        title: "总分类",
        value: "\(documentService.rootCategories.count)",
        icon: "folder.fill",
        color: .blue
      )
      
      StatisticCard(
        title: "总文档",
        value: "\(totalDocumentCount)",
        icon: "doc.text.fill",
        color: .green
      )
      
      StatisticCard(
        title: "Markdown",
        value: "\(markdownCount)",
        icon: "doc.richtext.fill",
        color: .orange
      )
    }.padding(.all, 10)
    
  }
  
  // MARK: - Computed Properties
  private var filteredCategories: [DocumentCategory] {
    if searchText.isEmpty {
      return documentService.rootCategories
    }
    
    return documentService.rootCategories.compactMap { category in
      filterCategory(category, searchText: searchText)
    }
  }
  
  private var totalDocumentCount: Int {
    documentService.rootCategories.reduce(0) { $0 + $1.totalDocumentCount }
  }
  
  private var markdownCount: Int {
    countMarkdownFiles(in: documentService.rootCategories)
  }
  
  // MARK: - Helper Methods
  private func filterCategory(_ category: DocumentCategory, searchText: String) -> DocumentCategory? {
    let filteredDocuments = category.documents.filter { document in
      document.displayName.localizedCaseInsensitiveContains(searchText) ||
      document.fileName.localizedCaseInsensitiveContains(searchText)
    }
    
    let filteredSubCategories = category.subCategories.compactMap { subCategory in
      filterCategory(subCategory, searchText: searchText)
    }
    
    if filteredDocuments.isEmpty && filteredSubCategories.isEmpty &&
        !category.displayName.localizedCaseInsensitiveContains(searchText) {
      return nil
    }
    
    var filteredCategory = category
    filteredCategory.documents = filteredDocuments
    filteredCategory.subCategories = filteredSubCategories
    return filteredCategory
  }
  
  private func countMarkdownFiles(in categories: [DocumentCategory]) -> Int {
    var count = 0
    for category in categories {
      count += category.documents.filter { $0.type == .markdown }.count
      count += countMarkdownFiles(in: category.subCategories)
    }
    return count
  }
}

// MARK: - Statistic Card
struct StatisticCard: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(.white)
        .frame(width: 36, height: 36)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      VStack(alignment: .leading, spacing: 2) {
        Text(value)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity)
        
        
        Text(title)
          .font(.caption)
          .frame(maxWidth: .infinity)
          .foregroundColor(.secondary)
      }
      
      Spacer()
    }.frame(maxWidth: .infinity)
      .padding(.all, 10)
    
      .background(Color(.secondarySystemGroupedBackground))
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
  }
}

// MARK: - Document Category List View
struct DocumentCategoryListView: View {
  let categories: [DocumentCategory]
  @Binding var expandedCategories: Set<UUID>
  let documentService: DocumentService
  
  var body: some View {
    //    ScrollView {
    LazyVStack(spacing: 12) {
      ForEach(categories, id: \.id) { category in
        DocumentCategoryCard(
          category: category,
          expandedCategories: $expandedCategories,
          documentService: documentService
        )
      }
    }
    .padding(.horizontal)
    .padding(.bottom, 20)
    //    }
  }
}

// MARK: - Document Category Card
struct DocumentCategoryCard: View {
  let category: DocumentCategory
  @Binding var expandedCategories: Set<UUID>
  let documentService: DocumentService
  
  private var isExpanded: Bool {
    expandedCategories.contains(category.id)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      // 主分类头部
      categoryHeader
      
      // 展开的内容
      if isExpanded {
        VStack(spacing: 12) {
          // 子分类
          if !category.subCategories.isEmpty {
            VStack(spacing: 8) {
              ForEach(category.subCategories, id: \.id) { subCategory in
                SubCategoryRow(
                  category: subCategory,
                  expandedCategories: $expandedCategories,
                  documentService: documentService
                )
              }
            }
            .padding(.top, 8)
          }
          
          // 文档列表
          if !category.documents.isEmpty {
            documentsGrid
              .padding(.top, 8)
          }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(Color(.tertiarySystemGroupedBackground))
      }
    }
    .background(Color(.secondarySystemGroupedBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    .animation(.easeInOut(duration: 0.3), value: isExpanded)
  }
  
  // MARK: - Category Header
  private var categoryHeader: some View {
    Button(action: {
      withAnimation(.easeInOut(duration: 0.3)) {
        if isExpanded {
          expandedCategories.remove(category.id)
        } else {
          expandedCategories.insert(category.id)
        }
      }
    }) {
      HStack(spacing: 16) {
        // 分类图标
        Image(systemName: category.icon)
          .font(.title2)
          .foregroundColor(.white)
          .frame(width: 48, height: 48)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [Color(category.color), Color(category.color).opacity(0.7)]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .shadow(color: Color(category.color).opacity(0.3), radius: 4, x: 0, y: 2)
        
        // 分类信息
        VStack(alignment: .leading, spacing: 4) {
          Text(category.displayName)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          
          HStack(spacing: 16) {
            if category.totalDocumentCount > 0 {
              Label("\(category.totalDocumentCount)", systemImage: "doc.text")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            if !category.subCategories.isEmpty {
              Label("\(category.subCategories.count)", systemImage: "folder")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }
        
        Spacer()
        
        // 展开指示器
        if !category.documents.isEmpty || !category.subCategories.isEmpty {
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .rotationEffect(.degrees(isExpanded ? 0 : 0))
            .animation(.easeInOut(duration: 0.3), value: isExpanded)
        }
      }
      .padding(16)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  // MARK: - Documents Grid
  private var documentsGrid: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
      ForEach(category.documents, id: \.id) { document in
        NavigationLink(destination: DocumentDetailView(document: document)) {
          DocumentCard(document: document)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}

// MARK: - Sub Category Row
struct SubCategoryRow: View {
  let category: DocumentCategory
  @Binding var expandedCategories: Set<UUID>
  let documentService: DocumentService
  
  private var isExpanded: Bool {
    expandedCategories.contains(category.id)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Button(action: {
        withAnimation(.easeInOut(duration: 0.2)) {
          if isExpanded {
            expandedCategories.remove(category.id)
          } else {
            expandedCategories.insert(category.id)
          }
        }
      }) {
        HStack(spacing: 12) {
          Image(systemName: category.icon)
            .font(.body)
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(Color(category.color))
            .clipShape(RoundedRectangle(cornerRadius: 8))
          
          VStack(alignment: .leading, spacing: 2) {
            Text(category.displayName)
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.primary)
            
            if category.totalDocumentCount > 0 {
              Text("\(category.totalDocumentCount) 个文档")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          
          Spacer()
          
          if !category.documents.isEmpty {
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
      }
      .buttonStyle(PlainButtonStyle())
      
      if isExpanded && !category.documents.isEmpty {
        VStack(spacing: 6) {
          ForEach(category.documents, id: \.id) { document in
            NavigationLink(destination: DocumentDetailView(document: document)) {
              DocumentCard(document: document)
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
      }
    }
    .background(Color(.quaternarySystemFill))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

// MARK: - Document Card
struct DocumentCard: View {
  let document: DocumentItem
  
  var body: some View {
    HStack(spacing: 12) {
      // 文档类型图标
      Image(systemName: document.type.icon)
        .font(.title3)
        .foregroundColor(.white)
        .frame(width: 36, height: 36)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [documentTypeColor, documentTypeColor.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      // 文档信息
      VStack(alignment: .leading, spacing: 4) {
        Text(document.displayName)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.primary)
          .lineLimit(2)
        
        HStack(spacing: 8) {
          // 文件类型标签
          Text(document.type.rawValue.uppercased())
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(documentTypeColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(documentTypeColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
          
          Spacer()
          
          // 修改时间
          Text(formattedDate)
            .font(.caption2)
            .foregroundColor(.secondary)
        }
      }
      
      Spacer()
      
      // 箭头指示器
      Image(systemName: "chevron.right")
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(.secondary)
    }
    .padding(12)
    .background(Color(.secondarySystemGroupedBackground))
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
    )
  }
  
  private var documentTypeColor: Color {
    switch document.type {
    case .markdown:
      return .orange
    case .text:
      return .blue
    }
  }
  
  private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter.string(from: document.lastModified)
  }
}

// MARK: - Document Row (Legacy)
struct DocumentRow: View {
  let document: DocumentItem
  
  var body: some View {
    DocumentCard(document: document)
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
