import Foundation

// MARK: - Document Type
enum DocumentType: String, CaseIterable, Sendable {
    case markdown = "md"
    case text = "txt"
    
    var icon: String {
        switch self {
        case .markdown:
            return "doc.text"
        case .text:
            return "doc.plaintext"
        }
    }
}

// MARK: - Document Item
struct DocumentItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let fileName: String
    let relativePath: String
    let fullPath: String
    let type: DocumentType
    let lastModified: Date
    
    init(name: String, fileName: String, relativePath: String, fullPath: String, type: DocumentType, lastModified: Date = Date()) {
        self.name = name
        self.fileName = fileName
        self.relativePath = relativePath
        self.fullPath = fullPath
        self.type = type
        self.lastModified = lastModified
    }
    
    // 从文件名创建显示名称
    var displayName: String {
        return name.isEmpty ? fileName.replacingOccurrences(of: ".\(type.rawValue)", with: "") : name
    }
}

// MARK: - Document Category
struct DocumentCategory: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let displayName: String
    let relativePath: String
    let fullPath: String
    let icon: String
    let color: String
    var subCategories: [DocumentCategory]
    var documents: [DocumentItem]
    
    init(name: String, displayName: String? = nil, relativePath: String, fullPath: String, icon: String = "folder", color: String = "blue") {
        self.name = name
        self.displayName = displayName ?? name
        self.relativePath = relativePath
        self.fullPath = fullPath
        self.icon = icon
        self.color = color
        self.subCategories = []
        self.documents = []
    }
    
    // 总文档数量（包括子分类）
    var totalDocumentCount: Int {
        return documents.count + subCategories.reduce(0) { $0 + $1.totalDocumentCount }
    }
    
    // 是否为空分类
    var isEmpty: Bool {
        return documents.isEmpty && subCategories.isEmpty
    }
}

// MARK: - Document Tree Node
enum DocumentTreeNode: Identifiable, Hashable, Sendable {
    case category(DocumentCategory)
    case document(DocumentItem)
    
    var id: UUID {
        switch self {
        case .category(let category):
            return category.id
        case .document(let document):
            return document.id
        }
    }
    
    var name: String {
        switch self {
        case .category(let category):
            return category.displayName
        case .document(let document):
            return document.displayName
        }
    }
    
    var icon: String {
        switch self {
        case .category(let category):
            return category.icon
        case .document(let document):
            return document.type.icon
        }
    }
}
