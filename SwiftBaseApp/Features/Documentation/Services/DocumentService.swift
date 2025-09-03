import Foundation

// MARK: - Document Service
@MainActor
class DocumentService: ObservableObject {
    @Published var rootCategories: [DocumentCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let docsBasePath: String
    
    init() {
        // 获取bundle中的docs文件夹路径
        print("🔍 开始初始化 DocumentService...")
        
        if let docsPath = Bundle.main.path(forResource: "docs", ofType: nil) {
            print("✅ 从 Bundle 中找到 docs 目录: \(docsPath)")
            self.docsBasePath = docsPath
        } else {
            print("❌ 从 Bundle 中未找到 docs 目录")
            
            // 如果bundle中没有docs文件夹，尝试从项目根目录读取（仅用于开发/调试）
            let bundlePath = Bundle.main.bundlePath
            print("📱 Bundle 路径: \(bundlePath)")
            
            let projectRoot = URL(fileURLWithPath: bundlePath)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            let fallbackDocsPath = projectRoot.appendingPathComponent("docs").path
            
            print("🔄 尝试回退路径: \(fallbackDocsPath)")
            print("📁 回退路径是否存在: \(FileManager.default.fileExists(atPath: fallbackDocsPath))")
            
            self.docsBasePath = fallbackDocsPath
        }
        
        print("🎯 最终使用的 docs 路径: \(docsBasePath)")
        print("📂 路径是否存在: \(FileManager.default.fileExists(atPath: docsBasePath))")
        
        loadDocuments()
    }
    
    // MARK: - Public Methods
    
    func loadDocuments() {
        isLoading = true
        errorMessage = nil
        
        Task.detached {
            do {
                let categories = try await self.scanDocsDirectoryAsync()
                
                await MainActor.run {
                    self.rootCategories = categories
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "加载文档失败: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func readDocumentContent(for document: DocumentItem) -> String? {
        guard FileManager.default.fileExists(atPath: document.fullPath) else {
            return nil
        }
        
        do {
            return try String(contentsOfFile: document.fullPath, encoding: .utf8)
        } catch {
            print("读取文档失败: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    nonisolated private func scanDocsDirectoryAsync() async throws -> [DocumentCategory] {
        print("🔍 开始使用新策略扫描 Bundle 资源...")
        
        // 新策略：直接扫描 Bundle 资源中的 Markdown 文件
        var categories: [DocumentCategory] = []
        
        // 获取 Bundle 资源路径
        guard let resourcePath = Bundle.main.resourcePath else {
            print("❌ 无法获取 Bundle 资源路径")
            return []
        }
        
        print("📁 Bundle 资源路径: \(resourcePath)")
        
        do {
            // 扫描 Bundle 资源目录
            let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            let mdFiles = contents.filter { $0.hasSuffix(".md") }
            
            print("📄 找到 \(mdFiles.count) 个 Markdown 文件")
            
                    if mdFiles.isEmpty {
            print("⚠️ 没有找到 Markdown 文件，返回空数组")
            return []
        }
            
            // 根据文件名推断分类结构
            let categorizedFiles = categorizeFilesByPath(mdFiles)
            
            // 创建分类
            for (categoryName, files) in categorizedFiles {
                let category = createCategoryFromFiles(name: categoryName, files: files, resourcePath: resourcePath)
                categories.append(category)
            }
            
            print("✅ 成功创建 \(categories.count) 个分类")
            
        } catch {
            print("❌ 扫描 Bundle 资源失败: \(error.localizedDescription)")
            return []
        }
        
        return categories.sorted { $0.name < $1.name }
    }
    
    // 根据文件名推断分类结构
    nonisolated private func categorizeFilesByPath(_ files: [String]) -> [String: [String]] {
        var categories: [String: [String]] = [:]
        
        for file in files {
            let fileName = file.replacingOccurrences(of: ".md", with: "")
            
            // 根据文件名推断分类
            let category = inferCategoryFromFileName(fileName)
            
            if categories[category] == nil {
                categories[category] = []
            }
            categories[category]?.append(file)
        }
        
        return categories
    }
    
    // 根据文件名推断分类
    nonisolated private func inferCategoryFromFileName(_ fileName: String) -> String {
        // 特殊文件映射
        let specialMappings: [String: String] = [
            "demoView模版": "其他",
            "说明": "其他",
            "学习路径": "其他",
            "热更新": "其他",
            "CoreData_Guide": "其他"
        ]
        
        if let category = specialMappings[fileName] {
            return category
        }
        
        // 根据文件名前缀推断
        if fileName.hasPrefix("SwiftUI_") || fileName.hasPrefix("Swift_") {
            return "swift6"
        } else if fileName.hasPrefix("State_") || fileName.hasPrefix("Publisher") || fileName.hasPrefix("Binding") || fileName.hasPrefix("EnvironmentObject") || fileName.hasPrefix("ObservedObject") || fileName.hasPrefix("Published") || fileName.hasPrefix("State") || fileName.hasPrefix("StateObject") {
            return "StateManagement"
        } else if fileName.hasPrefix("Local_Storage") || fileName.hasPrefix("UserDefaults") || fileName.hasPrefix("Keychain") || fileName.hasPrefix("FileManager") || fileName.hasPrefix("CoreData") {
            return "LocalStorage"
        } else if fileName.hasPrefix("Network_Data") || fileName.hasPrefix("URLSession") || fileName.hasPrefix("Alamofire") {
            return "NetworkData"
        } else if fileName.hasPrefix("System_Integration") || fileName.hasPrefix("NotificationCenter") || fileName.hasPrefix("UserNotifications") || fileName.hasPrefix("CoreLocation") || fileName.hasPrefix("AVFoundation") {
            return "SystemIntegration"
        } else if fileName.hasPrefix("UI_") || fileName.hasPrefix("Button") || fileName.hasPrefix("Text") || fileName.hasPrefix("Image") || fileName.hasPrefix("Label") || fileName.hasPrefix("Link") || fileName.hasPrefix("Input") || fileName.hasPrefix("Form") || fileName.hasPrefix("Group") || fileName.hasPrefix("NavigationStack") || fileName.hasPrefix("NavigationSplitView") || fileName.hasPrefix("TabView") || fileName.hasPrefix("HStack") || fileName.hasPrefix("VStack") || fileName.hasPrefix("ZStack") || fileName.hasPrefix("Grid") || fileName.hasPrefix("LazyGrid") || fileName.hasPrefix("LazyHStack") || fileName.hasPrefix("LazyVStack") || fileName.hasPrefix("List") || fileName.hasPrefix("Image") || fileName.hasPrefix("ForEach") || fileName.hasPrefix("ProgressView") || fileName.hasPrefix("Gauge") || fileName.hasPrefix("Badge") || fileName.hasPrefix("ColorPicker") || fileName.hasPrefix("DatePicker") || fileName.hasPrefix("Picker") || fileName.hasPrefix("Slider") || fileName.hasPrefix("Stepper") || fileName.hasPrefix("Toggle") || fileName.hasPrefix("Canvas") || fileName.hasPrefix("Chart") || fileName.hasPrefix("Path") || fileName.hasPrefix("Shape") || fileName.hasPrefix("VideoPlayer") {
            return "UI"
        }
        
        // 默认分类
        return "其他"
    }
    
    // 从文件创建分类
    nonisolated private func createCategoryFromFiles(name: String, files: [String], resourcePath: String) -> DocumentCategory {
        var category = DocumentCategory(
            name: name,
            displayName: getCategoryDisplayName(for: name),
            relativePath: name,
            fullPath: resourcePath,
            icon: getCategoryIcon(for: name),
            color: getCategoryColor(for: name)
        )
        
        // 为每个文件创建 DocumentItem
        for fileName in files {
            let fullPath = (resourcePath as NSString).appendingPathComponent(fileName)
            let relativePath = fileName
            
            let document = createDocumentItem(fileName: fileName, fullPath: fullPath, relativePath: relativePath)
            category.documents.append(document)
        }
        
        // 按文件名排序
        category.documents.sort { $0.fileName < $1.fileName }
        
        return category
    }
    
    nonisolated private func scanDirectoryAsync(name: String, fullPath: String, relativePath: String) async throws -> DocumentCategory {
        var category = DocumentCategory(
            name: name,
            displayName: getCategoryDisplayName(for: name),
            relativePath: relativePath,
            fullPath: fullPath,
            icon: getCategoryIcon(for: name),
            color: getCategoryColor(for: name)
        )
        
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(atPath: fullPath)
        
        for item in contents {
            let itemPath = (fullPath as NSString).appendingPathComponent(item)
            let itemRelativePath = (relativePath as NSString).appendingPathComponent(item)
            var isDirectory: ObjCBool = false
            
            guard fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory) else {
                continue
            }
            
            if isDirectory.boolValue {
                // 递归处理子目录
                if let subCategory = try? await scanDirectoryAsync(name: item, fullPath: itemPath, relativePath: itemRelativePath) {
                    category.subCategories.append(subCategory)
                }
            } else if item.hasSuffix(".md") {
                // 处理Markdown文档
                let document = createDocumentItem(fileName: item, fullPath: itemPath, relativePath: itemRelativePath)
                category.documents.append(document)
            }
        }
        
        // 排序
        category.subCategories.sort { $0.name < $1.name }
        category.documents.sort { $0.fileName < $1.fileName }
        
        return category
    }
    
    nonisolated private func createDocumentItem(fileName: String, fullPath: String, relativePath: String) -> DocumentItem {
        let fileManager = FileManager.default
        var lastModified = Date()
        
        if let attributes = try? fileManager.attributesOfItem(atPath: fullPath),
           let modificationDate = attributes[.modificationDate] as? Date {
            lastModified = modificationDate
        }
        
        let displayName = getDocumentDisplayName(for: fileName)
        
        return DocumentItem(
            name: displayName,
            fileName: fileName,
            relativePath: relativePath,
            fullPath: fullPath,
            type: .markdown,
            lastModified: lastModified
        )
    }
    
    // MARK: - Helper Methods
    
    nonisolated private func getCategoryDisplayName(for name: String) -> String {
        let displayNames: [String: String] = [
            "UI": "用户界面",
            "StateManagement": "状态管理",
            "LocalStorage": "本地存储",
            "NetworkData": "网络数据",
            "SystemIntegration": "系统集成",
            "swift6": "Swift 6",
            "其他": "其他文档",
            "基础控件": "基础控件",
            "容器控件": "容器控件",
            "布局": "布局",
            "选择控件": "选择控件",
            "指示器控件": "指示器控件",
            "列表和集合控件": "列表和集合控件",
            "图形控件": "图形控件",
            "媒体控件": "媒体控件",
            "属性包装器": "属性包装器"
        ]
        
        return displayNames[name] ?? name
    }
    
    nonisolated private func getCategoryIcon(for name: String) -> String {
        let icons: [String: String] = [
            "UI": "square.grid.2x2",
            "StateManagement": "arrow.triangle.2.circlepath",
            "LocalStorage": "externaldrive",
            "NetworkData": "network",
            "SystemIntegration": "gear",
            "swift6": "swift",
            "基础控件": "rectangle.3.group",
            "容器控件": "square.stack.3d.down.right",
            "布局": "rectangle.grid.2x2",
            "选择控件": "checkmark.circle",
            "指示器控件": "gauge",
            "列表和集合控件": "list.bullet",
            "图形控件": "paintbrush",
            "媒体控件": "play.rectangle",
            "属性包装器": "at.badge.gearshape"
        ]
        
        return icons[name] ?? "folder"
    }
    
    nonisolated private func getCategoryColor(for name: String) -> String {
        let colors: [String: String] = [
            "UI": "blue",
            "StateManagement": "purple",
            "LocalStorage": "green",
            "NetworkData": "orange",
            "SystemIntegration": "red",
            "swift6": "indigo",
            "基础控件": "blue",
            "容器控件": "teal",
            "布局": "cyan",
            "选择控件": "mint",
            "指示器控件": "yellow",
            "列表和集合控件": "pink",
            "图形控件": "purple",
            "媒体控件": "red",
            "属性包装器": "orange"
        ]
        
        return colors[name] ?? "gray"
    }
    
    nonisolated private func getDocumentDisplayName(for fileName: String) -> String {
        // 移除.md扩展名
        let nameWithoutExtension = fileName.replacingOccurrences(of: ".md", with: "")
        
        // 特殊名称映射
        let displayNames: [String: String] = [
            "SwiftUI_Guide": "SwiftUI 入门指南",
            "Swift_Guide": "Swift 语言指南",
            "SwiftUI_Controls_TodoList": "SwiftUI 控件学习清单",
            "State_Management_TodoList": "状态管理学习清单",
            "Local_Storage_TodoList": "本地存储学习清单",
            "Network_Data_TodoList": "网络数据学习清单",
            "System_Integration_TodoList": "系统集成学习清单",
            "SwiftUI_Lifecycle_Guide": "SwiftUI 生命周期指南",
            "CoreData_Guide": "CoreData 使用指南"
        ]
        
        return displayNames[nameWithoutExtension] ?? nameWithoutExtension
    }
    

}

// MARK: - Document Error
enum DocumentError: LocalizedError {
    case docsDirectoryNotFound
    case fileNotFound
    case readError(String)
    
    var errorDescription: String? {
        switch self {
        case .docsDirectoryNotFound:
            return "找不到docs文档目录"
        case .fileNotFound:
            return "文件不存在"
        case .readError(let message):
            return "读取文件失败: \(message)"
        }
    }
}
