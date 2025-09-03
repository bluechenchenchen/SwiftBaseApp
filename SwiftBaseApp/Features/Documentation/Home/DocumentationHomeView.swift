import SwiftUI

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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("文档详情")
                    .font(.title)
                
                Text("文件名: \(document.fileName)")
                Text("路径: \(document.relativePath)")
                Text("类型: \(document.type.rawValue)")
                
                Text("这里将显示文档内容...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(document.displayName)
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    DocumentationHomeView()
}
