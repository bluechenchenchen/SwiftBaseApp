# SwiftUI NavigationSplitView 分栏导航完整指南

## 1. 基本介绍

### 1.1 控件概述

NavigationSplitView 是 SwiftUI 在 iOS 16 中引入的分栏导航容器，专门为 iPad 和 Mac 应用程序设计。它支持两栏和三栏布局，能够自动适应不同设备和屏幕尺寸，提供了灵活的分栏导航体验。

> ⚠️ 版本要求：
>
> - NavigationSplitView：需要 iOS 16.0+
> - columnVisibility：需要 iOS 16.0+
> - preferredCompactColumn：需要 iOS 16.0+
>
> 如果需要支持更低版本的 iOS，请使用 NavigationView 作为替代方案。

### 1.2 使用场景

- 构建 iPad/Mac 应用的分栏界面
- 实现邮件类应用（文件夹列表 + 邮件列表 + 邮件内容）
- 构建文件管理器（目录树 + 文件列表 + 文件预览）
- 实现设置应用（分类列表 + 设置项 + 详情）
- 构建社交应用（好友列表 + 聊天列表 + 聊天内容）
- 开发文档类应用（章节列表 + 内容列表 + 文档内容）
- 实现音乐应用（播放列表 + 歌曲列表 + 歌曲详情）
- 构建任务管理器（项目列表 + 任务列表 + 任务详情）

### 1.3 主要特性

- 支持两栏和三栏布局
- 自适应布局系统
- 可折叠侧边栏
- 列宽控制
- 列可见性管理
- 紧凑模式支持
- 导航状态管理
- 深层链接支持
- 主题定制能力
- 转场动画
- 设备适配
- 辅助功能支持

## 2. 基础用法

### 2.1 两栏布局

1. 基本两栏布局

```swift
struct TwoColumnExample: View {
    @State private var selectedItem: Int? = nil

    var body: some View {
        NavigationSplitView {
            // 侧边栏
            List(1..<10, selection: $selectedItem) { item in
                Text("Item \(item)")
            }
            .navigationTitle("侧边栏")
        } detail: {
            // 详情视图
            if let selectedItem {
                Text("选中项目 \(selectedItem)")
            } else {
                Text("请选择一个项目")
            }
        }
    }
}
```

2. 带数据模型的两栏布局

```swift
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
}

struct TwoColumnWithDataExample: View {
    @State private var selectedCategory: Category? = nil

    let categories = [
        Category(name: "收件箱", icon: "tray"),
        Category(name: "已发送", icon: "paperplane"),
        Category(name: "草稿", icon: "doc")
    ]

    var body: some View {
        NavigationSplitView {
            List(categories, selection: $selectedCategory) { category in
                Label(category.name, systemImage: category.icon)
            }
            .navigationTitle("邮件")
        } detail: {
            if let category = selectedCategory {
                CategoryDetailView(category: category)
            } else {
                Text("请选择一个分类")
            }
        }
    }
}
```

### 2.2 三栏布局

1. 基本三栏布局

```swift
struct ThreeColumnExample: View {
    @State private var selectedCategory: Category? = nil
    @State private var selectedItem: Item? = nil

    var body: some View {
        NavigationSplitView {
            // 侧边栏
            List(categories, selection: $selectedCategory) { category in
                Label(category.name, systemImage: category.icon)
            }
            .navigationTitle("分类")
        } content: {
            // 内容列表
            if let category = selectedCategory {
                List(itemsForCategory(category), selection: $selectedItem) { item in
                    Text(item.title)
                }
                .navigationTitle(category.name)
            } else {
                Text("请选择一个分类")
            }
        } detail: {
            // 详情视图
            if let item = selectedItem {
                ItemDetailView(item: item)
            } else {
                Text("请选择一个项目")
            }
        }
    }
}
```

2. 完整的邮件应用示例

```swift
struct EmailApp: View {
    @State private var selectedFolder: Folder? = nil
    @State private var selectedEmail: Email? = nil

    var body: some View {
        NavigationSplitView {
            // 文件夹列表
            EmailFolderList(selection: $selectedFolder)
        } content: {
            // 邮件列表
            if let folder = selectedFolder {
                EmailList(folder: folder, selection: $selectedEmail)
            } else {
                Text("请选择一个文件夹")
            }
        } detail: {
            // 邮件内容
            if let email = selectedEmail {
                EmailDetail(email: email)
            } else {
                Text("请选择一封邮件")
            }
        }
        .navigationSplitViewStyle(.balanced) // 平衡列宽
    }
}
```

### 2.3 列可见性控制

```swift
struct ColumnVisibilityExample: View {
    // 控制列的可见性
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: .sidebar // 紧凑模式下优先显示的列
        ) {
            SidebarContent()
        } content: {
            ContentList()
        } detail: {
            DetailView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // 切换列可见性
                    withAnimation {
                        columnVisibility = columnVisibility == .all ? .detailOnly : .all
                    }
                } label: {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}
```

### 2.4 列宽控制

```swift
struct ColumnWidthExample: View {
    var body: some View {
        NavigationSplitView {
            SidebarContent()
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } content: {
            ContentList()
                .navigationSplitViewColumnWidth(min: 250, ideal: 300, max: 400)
        } detail: {
            DetailView()
        }
    }
}
```

### 2.5 样式设置

```swift
struct StyleExample: View {
    var body: some View {
        NavigationSplitView {
            SidebarContent()
        } content: {
            ContentList()
        } detail: {
            DetailView()
        }
        // 设置分栏样式
        .navigationSplitViewStyle(.balanced) // 平衡列宽
        // 或
        .navigationSplitViewStyle(.prominentDetail) // 突出显示详情列
        // 或
        .navigationSplitViewStyle(.automatic) // 自动适应
    }
}
```

## 3. 高级特性

### 3.1 状态管理

```swift
class NavigationStateManager: ObservableObject {
    @Published var selectedCategory: Category? = nil
    @Published var selectedItem: Item? = nil

    // 保存状态
    func saveState() {
        if let categoryData = try? JSONEncoder().encode(selectedCategory) {
            UserDefaults.standard.set(categoryData, forKey: "selectedCategory")
        }
        if let itemData = try? JSONEncoder().encode(selectedItem) {
            UserDefaults.standard.set(itemData, forKey: "selectedItem")
        }
    }

    // 恢复状态
    func restoreState() {
        if let categoryData = UserDefaults.standard.data(forKey: "selectedCategory"),
           let category = try? JSONDecoder().decode(Category.self, from: categoryData) {
            selectedCategory = category
        }
        if let itemData = UserDefaults.standard.data(forKey: "selectedItem"),
           let item = try? JSONDecoder().decode(Item.self, from: itemData) {
            selectedItem = item
        }
    }
}
```

### 3.2 深层链接支持

```swift
struct DeepLinkHandler: View {
    @StateObject private var navigator = NavigationStateManager()

    var body: some View {
        NavigationSplitView {
            SidebarContent()
                .environmentObject(navigator)
        } content: {
            ContentList()
                .environmentObject(navigator)
        } detail: {
            DetailView()
                .environmentObject(navigator)
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }

        // 处理深层链接
        switch components.path {
        case "/category":
            if let categoryId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                // 导航到指定分类
                navigator.navigateToCategory(categoryId)
            }
        case "/item":
            if let itemId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                // 导航到指定项目
                navigator.navigateToItem(itemId)
            }
        default:
            break
        }
    }
}
```

### 3.3 设备适配

```swift
struct AdaptiveNavigationExample: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // 在 iPhone 上使用标准导航
                CompactNavigationView()
            } else {
                // 在 iPad/Mac 上使用分栏导航
                NavigationSplitView {
                    SidebarContent()
                } content: {
                    ContentList()
                } detail: {
                    DetailView()
                }
            }
        }
    }
}
```

### 3.4 自定义转场动画

```swift
struct CustomTransitionExample: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarContent()
        } content: {
            ContentList()
        } detail: {
            DetailView()
        }
        .animation(.spring(), value: columnVisibility)
    }
}
```

## 4. 性能优化

### 4.1 最佳实践

1. 视图层次优化

```swift
struct OptimizedView: View {
    var body: some View {
        // 使用 LazyVStack/LazyHStack 延迟加载列表项
        LazyVStack {
            ForEach(items) { item in
                ItemRow(item: item)
            }
        }
    }
}
```

2. 状态管理优化

```swift
// 使用 @StateObject 而不是 @ObservedObject
@StateObject private var viewModel = ViewModel()

// 避免不必要的状态更新
private var filteredItems: [Item] {
    items.filter { /* 过滤条件 */ }
}
```

### 4.2 内存管理

```swift
class NavigationViewModel: ObservableObject {
    // 使用弱引用避免循环引用
    weak var delegate: NavigationDelegate?

    // 及时清理不需要的资源
    func cleanup() {
        // 清理代码
    }
}
```

## 5. 完整示例

### 5.1 文件管理器示例

这个示例展示了一个完整的文件管理器应用，使用三栏布局：

```swift
// 数据模型
struct Folder: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    var subfolders: [Folder]
}

struct File: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: String
    let size: Int
    let modificationDate: Date
}

// 视图模型
class FileManagerViewModel: ObservableObject {
    @Published var selectedFolder: Folder?
    @Published var selectedFile: File?
    @Published var folders: [Folder] = []
    @Published var files: [File] = []

    func loadFolders() {
        // 加载文件夹
    }

    func loadFiles(in folder: Folder) {
        // 加载文件
    }
}

// 主视图
struct FileManagerView: View {
    @StateObject private var viewModel = FileManagerViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // 文件夹树
            FolderTreeView(
                folders: viewModel.folders,
                selection: $viewModel.selectedFolder
            )
            .navigationTitle("文件夹")
        } content: {
            // 文件列表
            if let folder = viewModel.selectedFolder {
                FileListView(
                    folder: folder,
                    files: viewModel.files,
                    selection: $viewModel.selectedFile
                )
                .navigationTitle(folder.name)
            } else {
                Text("请选择一个文件夹")
            }
        } detail: {
            // 文件预览
            if let file = viewModel.selectedFile {
                FilePreviewView(file: file)
            } else {
                Text("请选择一个文件")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

// 文件夹树视图
struct FolderTreeView: View {
    let folders: [Folder]
    @Binding var selection: Folder?

    var body: some View {
        List(folders, selection: $selection) { folder in
            FolderRow(folder: folder)
        }
    }
}

// 文件列表视图
struct FileListView: View {
    let folder: Folder
    let files: [File]
    @Binding var selection: File?

    var body: some View {
        List(files, selection: $selection) { file in
            FileRow(file: file)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("按名称排序") { }
                    Button("按日期排序") { }
                    Button("按大小排序") { }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
    }
}

// 文件预览视图
struct FilePreviewView: View {
    let file: File

    var body: some View {
        VStack {
            // 文件预览内容
            Group {
                switch file.type {
                case "image":
                    ImagePreview(file: file)
                case "text":
                    TextPreview(file: file)
                default:
                    GenericPreview(file: file)
                }
            }

            // 文件信息
            VStack(alignment: .leading) {
                Text("文件名：\(file.name)")
                Text("大小：\(formatFileSize(file.size))")
                Text("修改时间：\(formatDate(file.modificationDate))")
            }
            .padding()
        }
        .navigationTitle(file.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("分享") {
                    // 分享文件
                }
            }
        }
    }
}
```

### 5.2 邮件应用示例

这个示例展示了一个完整的邮件应用，使用三栏布局：

```swift
// 数据模型
struct EmailFolder: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    var unreadCount: Int
}

struct Email: Identifiable, Hashable {
    let id = UUID()
    let subject: String
    let sender: String
    let preview: String
    let date: Date
    var isRead: Bool
}

// 视图模型
class EmailViewModel: ObservableObject {
    @Published var selectedFolder: EmailFolder?
    @Published var selectedEmail: Email?
    @Published var folders: [EmailFolder] = []
    @Published var emails: [Email] = []

    func loadFolders() {
        // 加载邮件文件夹
    }

    func loadEmails(in folder: EmailFolder) {
        // 加载邮件
    }
}

// 主视图
struct EmailAppView: View {
    @StateObject private var viewModel = EmailViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // 文件夹列表
            EmailFolderList(
                folders: viewModel.folders,
                selection: $viewModel.selectedFolder
            )
            .navigationTitle("邮件")
        } content: {
            // 邮件列表
            if let folder = viewModel.selectedFolder {
                EmailList(
                    folder: folder,
                    emails: viewModel.emails,
                    selection: $viewModel.selectedEmail
                )
                .navigationTitle(folder.name)
                .searchable(text: $searchText)
            } else {
                Text("请选择一个文件夹")
            }
        } detail: {
            // 邮件内容
            if let email = viewModel.selectedEmail {
                EmailDetailView(email: email)
            } else {
                Text("请选择一封邮件")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

// 文件夹列表视图
struct EmailFolderList: View {
    let folders: [EmailFolder]
    @Binding var selection: EmailFolder?

    var body: some View {
        List(folders, selection: $selection) { folder in
            HStack {
                Label(folder.name, systemImage: folder.icon)
                Spacer()
                if folder.unreadCount > 0 {
                    Text("\(folder.unreadCount)")
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

// 邮件列表视图
struct EmailList: View {
    let folder: EmailFolder
    let emails: [Email]
    @Binding var selection: Email?

    var body: some View {
        List(emails, selection: $selection) { email in
            EmailRow(email: email)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("全部标记为已读") { }
                    Button("排序方式") { }
                    Button("筛选") { }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

// 邮件详情视图
struct EmailDetailView: View {
    let email: Email

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 邮件头部
                VStack(alignment: .leading, spacing: 8) {
                    Text(email.subject)
                        .font(.title)

                    HStack {
                        Text(email.sender)
                            .font(.subheadline)
                        Spacer()
                        Text(formatDate(email.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)

                // 邮件内容
                Text(email.preview)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(email.subject)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button("回复") {
                        // 回复邮件
                    }
                    Button("转发") {
                        // 转发邮件
                    }
                    Button("删除") {
                        // 删除邮件
                    }
                }
            }
        }
    }
}
```

## 6. 注意事项

### 6.1 常见问题

1. 列宽控制

   - 使用 `navigationSplitViewColumnWidth` 设置合适的列宽
   - 考虑不同设备的屏幕尺寸
   - 避免设置过大或过小的列宽

2. 状态管理

   - 正确使用 `@State` 和 `@StateObject`
   - 及时清理不需要的状态
   - 实现状态持久化

3. 性能问题
   - 避免过深的视图层次
   - 使用懒加载视图
   - 优化数据加载

### 6.2 兼容性考虑

1. 设备适配

   - 为不同设备提供合适的布局
   - 处理横竖屏切换
   - 支持 Split View

2. iOS 版本兼容
   - iOS 16+ 使用 NavigationSplitView
   - 低版本提供降级方案
   - 检查 API 可用性

### 6.3 最佳实践

1. 界面设计

   - 保持导航层次清晰
   - 提供适当的视觉反馈
   - 遵循平台设计规范

2. 代码组织

   - 使用 MVVM 架构
   - 分离业务逻辑
   - 保持代码可维护性

3. 用户体验
   - 实现合适的动画
   - 提供清晰的导航提示
   - 支持辅助功能

## 7. 运行说明

1. 创建新的 Swift 文件：NavigationSplitViewDemoView.swift
2. 复制示例代码到文件中
3. 确保 iOS 部署目标为 16.0 或更高
4. 运行项目查看效果

## 8. 总结

NavigationSplitView 是一个强大的分栏导航容器，特别适合 iPad 和 Mac 应用程序。通过合理使用其特性，可以构建出专业的多栏应用界面。在使用时需要注意：

1. 设备适配
2. 性能优化
3. 状态管理
4. 用户体验
5. 代码组织

通过本文的示例和说明，你应该能够掌握 NavigationSplitView 的所有主要用法，并能够在实际项目中灵活运用。
