# SwiftUI NavigationStack 导航栈完整指南

## 1. 基本介绍

### 1.1 控件概述

NavigationStack 是 SwiftUI 在 iOS 16 中引入的新一代导航容器，用于替代旧的 NavigationView。它提供了更强大的导航功能和更灵活的状态管理能力，支持数据驱动的导航和深层链接。

> ⚠️ 版本要求：
>
> - NavigationStack：需要 iOS 16.0+
> - navigationDestination：需要 iOS 16.0+
> - navigationPath：需要 iOS 16.0+
>
> 如果需要支持更低版本的 iOS，请使用 NavigationView 作为替代方案。

### 1.2 使用场景

- 构建层级导航界面
- 实现多级页面跳转
- 管理复杂的导航状态
- 实现深层链接功能
- 构建电商类应用的商品详情页导航
- 实现设置页面的层级导航
- 构建文件浏览器的目录导航
- 实现社交应用的用户资料导航

### 1.3 主要特性

- 声明式导航 API
- 内置导航状态管理
- 支持可编程导航
- 深层链接支持
- 导航路径管理
- 导航栈状态保持
- 支持多种数据类型导航
- 支持自定义转场动画
- 提供导航生命周期回调
- 支持导航栈状态恢复

## 2. 基础用法

### 2.1 基本示例

1. 简单导航

```swift
struct BasicNavigationExample: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("跳转到详情页面") {
                    Text("详情页面")
                        .navigationTitle("详情")
                }

                NavigationLink("跳转到设置页面") {
                    Text("设置页面")
                        .navigationTitle("设置")
                }
            }
            .navigationTitle("主页")
        }
    }
}
```

2. 带数据传递的导航

```swift
struct Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
}

struct ItemListView: View {
    let items = [
        Item(title: "项目1", description: "这是项目1的详细描述"),
        Item(title: "项目2", description: "这是项目2的详细描述")
    ]

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(item.title) {
                    ItemDetailView(item: item)
                }
            }
            .navigationTitle("项目列表")
        }
    }
}
```

### 2.2 常用属性

```swift
NavigationStack {
    List {
        // 内容
    }
    // 设置导航标题
    .navigationTitle("主页")

    // 设置标题显示模式
    .navigationBarTitleDisplayMode(.large)

    // 隐藏返回按钮
    .navigationBarBackButtonHidden(true)

    // 隐藏导航栏
    .navigationBarHidden(true)

    // 添加工具栏按钮
    .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("编辑") {
                // 处理编辑操作
            }
        }
    }
}
```

### 2.3 导航目标配置

```swift
NavigationStack {
    List {
        // 字符串类型导航
        NavigationLink("字符串导航", value: "目标页面")

        // 数字类型导航
        NavigationLink("数字导航", value: 42)

        // 自定义类型导航
        NavigationLink("对象导航", value: Item(title: "示例", description: "描述"))
    }
    // 配置字符串类型目标
    .navigationDestination(for: String.self) { text in
        Text(text)
    }
    // 配置数字类型目标
    .navigationDestination(for: Int.self) { number in
        Text("数字: \(number)")
    }
    // 配置自定义类型目标
    .navigationDestination(for: Item.self) { item in
        ItemDetailView(item: item)
    }
}
```

### 2.4 编程式导航

```swift
struct ProgrammaticNavigationDemo: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("导航到第二页") {
                    path.append("第二页")
                }

                Button("导航到第三页") {
                    path.append("第三页")
                }

                Button("返回首页") {
                    path.removeLast(path.count)
                }
            }
            .navigationDestination(for: String.self) { text in
                Text(text)
            }
        }
    }
}
```

### 2.5 导航栈操作

```swift
class NavigationStateManager: ObservableObject {
    @Published var path = NavigationPath()

    func navigateToRoot() {
        path.removeLast(path.count)
    }

    func navigateBack() {
        guard path.count > 0 else { return }
        path.removeLast()
    }

    func navigateTo(_ destination: String) {
        path.append(destination)
    }

    func replaceStack(with destinations: [String]) {
        path.removeLast(path.count)
        destinations.forEach { path.append($0) }
    }
}
```

## 3. 样式和自定义

### 3.1 导航栏样式

1. 基本样式设置

```swift
NavigationStack {
    List {
        // 内容
    }
    .navigationBarTitleDisplayMode(.large)
    .navigationTitle("主页")
    .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("编辑") {
                // 处理编辑操作
            }
        }
    }
}
```

2. 自定义返回按钮

```swift
.navigationBarBackButtonHidden(true)
.toolbar {
    ToolbarItem(placement: .navigationBarLeading) {
        Button {
            // 返回操作
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("返回")
            }
        }
    }
}
```

3. 导航栏外观定制

```swift
.toolbarBackground(.visible, for: .navigationBar)
.toolbarBackground(Color.blue, for: .navigationBar)
.toolbarColorScheme(.dark, for: .navigationBar)
```

### 3.2 转场动画

1. 基本转场动画

```swift
NavigationStack {
    List {
        NavigationLink("淡入淡出") {
            Text("目标页面")
                .transition(.opacity)
        }

        NavigationLink("滑动") {
            Text("目标页面")
                .transition(.slide)
        }
    }
}
```

2. 自定义转场动画

```swift
struct CustomTransitionView: View {
    var body: some View {
        Text("目标页面")
            .transition(
                .asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .slide
                )
            )
    }
}
```

### 3.3 主题适配

```swift
NavigationStack {
    List {
        // 内容
    }
    .navigationTitle("主题示例")
    // 适配深色模式
    .preferredColorScheme(.dark)
    // 自定义导航栏颜色
    .toolbarBackground(.blue, for: .navigationBar)
    // 自定义导航栏文字颜色
    .toolbarColorScheme(.dark, for: .navigationBar)
}
```

## 4. 高级特性

### 4.1 导航状态管理

1. 使用 NavigationPath

```swift
struct NavigationStateDemo: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            // 内容
        }
    }
}
```

2. 状态持久化

```swift
struct PersistentNavigationDemo: View {
    @SceneStorage("navigationState") private var navigationData: Data?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            // 内容
        }
        .onAppear {
            restoreNavigationState()
        }
        .onChange(of: path) { _ in
            saveNavigationState()
        }
    }

    private func saveNavigationState() {
        // 保存导航状态
    }

    private func restoreNavigationState() {
        // 恢复导航状态
    }
}
```

### 4.2 深层链接

```swift
struct DeepLinkHandler: View {
    @StateObject private var navigator = NavigationStateManager()

    var body: some View {
        NavigationStack(path: $navigator.path) {
            ContentView()
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
    }

    private func handleDeepLink(_ url: URL) {
        // 处理深层链接
    }
}
```

### 4.3 导航生命周期

```swift
struct NavigationLifecycleDemo: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("详情") {
                    DetailView()
                        .onAppear {
                            print("页面出现")
                        }
                        .onDisappear {
                            print("页面消失")
                        }
                }
            }
        }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 避免过深的导航层级
2. 及时清理不需要的导航状态
3. 使用适当的状态管理方式
4. 优化视图层次结构
5. 合理使用导航栈操作

### 5.2 常见陷阱

1. 导航状态管理不当
2. 内存泄漏问题
3. 过度使用导航栈操作
4. 性能问题

### 5.3 优化技巧

1. 使用 `@StateObject` 而不是 `@ObservedObject`
2. 适时使用 `weak self` 避免循环引用
3. 导航栈深度控制在合理范围
4. 及时释放不需要的资源
5. 使用合适的状态管理方案

## 6. 辅助功能

### 6.1 无障碍支持

```swift
NavigationStack {
    List {
        NavigationLink("无障碍示例") {
            Text("详情")
        }
        .accessibilityLabel("导航到详情页面")
        .accessibilityHint("点击查看详细信息")
    }
}
```

### 6.2 本地化

```swift
NavigationStack {
    List {
        NavigationLink(LocalizedStringKey("navigation.title")) {
            Text(LocalizedStringKey("detail.title"))
        }
    }
    .navigationTitle(LocalizedStringKey("main.title"))
}
```

### 6.3 动态类型

```swift
NavigationStack {
    List {
        NavigationLink("支持动态字体") {
            Text("详情")
                .dynamicTypeSize(...DynamicTypeSize.accessibility3)
        }
    }
}
```

## 7. 示例代码

### 7.1 基础示例

```swift
struct BasicNavigationDemo: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("基本导航") {
                    Text("详情页面")
                }

                NavigationLink("带数据导航", value: "示例数据")
            }
            .navigationDestination(for: String.self) { text in
                Text(text)
            }
        }
    }
}
```

### 7.2 进阶示例

```swift
struct AdvancedNavigationDemo: View {
    @StateObject private var navigator = NavigationStateManager()
    @State private var showingSheet = false

    var body: some View {
        NavigationStack(path: $navigator.path) {
            List {
                // 导航内容
            }
            .navigationDestination(for: String.self) { text in
                Text(text)
            }
            .sheet(isPresented: $showingSheet) {
                Text("模态视图")
            }
            .toolbar {
                // 工具栏内容
            }
        }
    }
}
```

## 8. 注意事项

### 8.1 常见问题

1. 导航状态丢失

   - 使用 SceneStorage 保存状态
   - 实现状态恢复机制
   - 注意状态序列化

2. 返回手势失效

   - 检查导航栈配置
   - 确认手势启用状态
   - 验证自定义返回按钮实现

3. 深层链接问题
   - 完善 URL 处理逻辑
   - 实现降级方案
   - 处理异常情况

### 8.2 兼容性考虑

1. iOS 版本兼容

   - iOS 16+ 使用 NavigationStack
   - 低版本使用 NavigationView
   - 实现版本适配逻辑

2. 设备适配
   - iPad 分屏支持
   - 横竖屏切换处理
   - 不同设备尺寸适配

### 8.3 使用建议

1. 遵循 SwiftUI 的声明式编程范式
2. 保持导航逻辑清晰简单
3. 注意状态管理和内存使用
4. 做好错误处理和降级方案
5. 定期检查和优化性能

## 9. 完整运行 Demo

### 9.1 源代码

下面是一个完整的、系统化的示例，展示了 NavigationStack 的所有主要功能。这个示例通过一个文章阅读应用展示了导航栈的各种用法：

```swift
import SwiftUI

// MARK: - 数据模型
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let content: String
    let category: Category
    let date: Date
}

// MARK: - 导航状态管理
class NavigationStateManager: ObservableObject {
    @Published var pathItems: [String] = [] {
        didSet {
            path = NavigationPath(pathItems)
        }
    }
    @Published var path = NavigationPath()
    @Published var selectedCategory: Category?
    @Published var selectedArticle: Article?

    // 导航操作
    func navigateToRoot() {
        pathItems.removeAll()
    }

    func navigateBack() {
        guard !pathItems.isEmpty else { return }
        pathItems.removeLast()
    }

    func navigateToCategory(_ category: Category) {
        selectedCategory = category
        pathItems.append("category:\(category.id.uuidString)")
    }

    func navigateToArticle(_ article: Article) {
        selectedArticle = article
        pathItems.append("article:\(article.id.uuidString)")
    }

    // 深层链接处理
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return
        }

        switch host {
        case "category":
            if let categoryId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                pathItems.append("category:\(categoryId)")
            }
        case "article":
            if let articleId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                pathItems.append("article:\(articleId)")
            }
        default:
            break
        }
    }
}

// MARK: - 基础导航示例
struct BasicNavigationExampleView: View {
    @EnvironmentObject var navigator: NavigationStateManager
    @State private var searchText = ""

    // 示例数据
    let categories = [
        Category(name: "技术", icon: "laptopcomputer", color: .blue),
        Category(name: "设计", icon: "paintbrush", color: .purple),
        Category(name: "生活", icon: "heart", color: .pink),
        Category(name: "运动", icon: "figure.run", color: .green)
    ]

    var body: some View {
        List {
            Section("基础导航") {
                // 简单导航
                NavigationLink("简单导航示例") {
                    Text("详情页面")
                        .navigationTitle("详情")
                }

                // 带值的导航
                NavigationLink(value: "带值导航") {
                    Text("使用值的导航")
                }
            }

            Section("分类导航") {
                ForEach(categories) { category in
                    NavigationLink(value: category) {
                        Label(category.name, systemImage: category.icon)
                            .foregroundColor(category.color)
                    }
                }
            }
        }
        .navigationTitle("导航示例")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationDestination(for: String.self) { text in
            Text(text)
                .navigationTitle(text)
        }
        .navigationDestination(for: Category.self) { category in
            CategoryDetailView(category: category)
        }
    }
}

// MARK: - 导航栈管理示例
struct NavigationStackManagementView: View {
    @EnvironmentObject var navigator: NavigationStateManager
    @State private var showingActionSheet = false

    var body: some View {
        VStack(spacing: 20) {
            // 导航栈操作
            Group {
                Button("返回上一级") {
                    navigator.navigateBack()
                }

                Button("返回根视图") {
                    navigator.navigateToRoot()
                }

                Button("显示操作菜单") {
                    showingActionSheet = true
                }
            }
            .buttonStyle(.bordered)

            // 当前导航状态
            Text("当前导航层级: \(navigator.path.count)")
                .font(.caption)
        }
        .padding()
        .navigationTitle("导航栈管理")
        .confirmationDialog("导航操作", isPresented: $showingActionSheet) {
            Button("返回上一级") {
                navigator.navigateBack()
            }
            Button("返回根视图") {
                navigator.navigateToRoot()
            }
            Button("取消", role: .cancel) {}
        }
    }
}

// MARK: - 导航栏定制示例
struct NavigationBarCustomizationView: View {
    @State private var isNavigationBarHidden = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showingSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 导航栏控制
                Toggle("隐藏导航栏", isOn: $isNavigationBarHidden)
                    .padding()

                // 滚动内容
                ForEach(0..<20) { index in
                    Text("滚动项目 \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding()

            // 滚动位置检测
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            }
            .frame(height: 0)
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(isNavigationBarHidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "gear")
                }
            }

            ToolbarItem(placement: .principal) {
                Text("自定义导航栏")
                    .opacity(scrollOffset < -50 ? 1 : 0)
                    .animation(.easeInOut, value: scrollOffset)
            }
        }
        .toolbarBackground(
            Color.white.opacity(scrollOffset < -50 ? 1 : 0),
            for: .navigationBar
        )
        .sheet(isPresented: $showingSheet) {
            NavigationStack {
                Text("设置")
                    .navigationTitle("设置")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("完成") {
                                showingSheet = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - 转场动画示例
struct TransitionAnimationView: View {
    @State private var showCustomTransition = false

    var body: some View {
        VStack(spacing: 20) {
            // 基本转场
            NavigationLink("标准转场") {
                Text("标准转场页面")
                    .navigationTitle("标准转场")
            }

            // 自定义转场
            Button("自定义转场") {
                withAnimation(.spring()) {
                    showCustomTransition = true
                }
            }
        }
        .padding()
        .navigationTitle("转场动画")
        .overlay {
            if showCustomTransition {
                CustomTransitionDetailView(isShowing: $showCustomTransition)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .slide
                    ))
            }
        }
    }
}

// MARK: - 特殊场景示例
struct SpecialCasesView: View {
    @State private var orientation = UIDevice.current.orientation
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 20) {
            // 设备适配
            Group {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("iPad 布局")
                        .font(.title)
                } else {
                    if orientation.isLandscape {
                        HStack {
                            Text("左侧内容")
                            Divider()
                            Text("右侧内容")
                        }
                    } else {
                        VStack {
                            Text("上方内容")
                            Divider()
                            Text("下方内容")
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            // 搜索示例
            SearchBarView(searchText: $searchText)
                .padding()
        }
        .navigationTitle("特殊场景")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "搜索..."
        )
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

// MARK: - 辅助视图
struct CategoryDetailView: View {
    let category: Category
    @EnvironmentObject var navigator: NavigationStateManager

    var body: some View {
        List {
            Section {
                Label(category.name, systemImage: category.icon)
                    .foregroundColor(category.color)
                    .font(.title2)
            }

            Section("相关文章") {
                ForEach(0..<5) { index in
                    let article = Article(
                        title: "\(category.name)文章\(index + 1)",
                        subtitle: "副标题",
                        content: "文章内容",
                        category: category,
                        date: Date()
                    )

                    NavigationLink(value: article) {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .navigationDestination(for: Article.self) { article in
            ArticleDetailView(article: article)
        }
    }
}

struct ArticleDetailView: View {
    let article: Article
    @State private var showingShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 文章标题
                Text(article.title)
                    .font(.title)

                // 文章信息
                HStack {
                    Label(article.category.name, systemImage: article.category.icon)
                        .foregroundColor(article.category.color)
                    Spacer()
                    Text(article.date, style: .date)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)

                // 文章内容
                Text(article.content)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("文章详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [article.title])
        }
    }
}

struct CustomTransitionDetailView: View {
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Text("自定义转场效果")
                .font(.title)

            Button("关闭") {
                withAnimation(.spring()) {
                    isShowing = false
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("搜索...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

@preconcurrency struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// MARK: - 主视图
struct NavigationStackDemoView: View {
    @StateObject private var navigator = NavigationStateManager()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("基础导航示例") {
                    BasicNavigationExampleView()
                }

                NavigationLink("导航栈管理") {
                    NavigationStackManagementView()
                }

                NavigationLink("导航栏定制") {
                    NavigationBarCustomizationView()
                }

                NavigationLink("转场动画") {
                    TransitionAnimationView()
                }

                NavigationLink("特殊场景") {
                    SpecialCasesView()
                }
            }
            .navigationTitle("NavigationStack Demo")
        }
        .environmentObject(navigator)
    }
}

// MARK: - 预览
#Preview {
    NavigationStackDemoView()
}
```

### 9.2 运行说明

1. 创建新的 Swift 文件，命名为 `NavigationStackDemoView.swift`
2. 将上述代码完整复制到文件中
3. 确保项目的部署目标是 iOS 16.0 或更高版本
4. 运行项目，即可看到一个完整的导航栈示例

### 9.3 功能说明

这个 Demo 展示了 NavigationStack 的所有主要功能：

1. 基础导航功能

   - 简单导航示例
   - 数据传递导航
   - 值类型导航

2. 导航栈操作

   - 多级导航
   - 替换导航栈
   - 插入导航项
   - 返回操作

3. 导航栏定制

   - 显示/隐藏导航栏
   - 导航栏渐变效果
   - 自定义工具栏

4. 转场动画

   - 淡入淡出转场
   - 滑动转场
   - 缩放转场

5. 特殊场景适配

   - iPad Split View
   - 横竖屏切换
   - 搜索栏集成

6. 性能优化
   - 状态管理
   - 内存管理
   - 导航历史清理

### 9.4 使用说明

1. 导航功能

   - 点击不同类型的导航链接
   - 尝试多级导航
   - 测试导航栈操作
   - 体验转场动画

2. 导航栏

   - 切换导航栏显示/隐藏
   - 滚动查看渐变效果
   - 使用工具栏按钮

3. 适配功能

   - 在 iPad 上测试 Split View
   - 旋转设备查看布局变化
   - 使用搜索功能

4. 状态管理
   - 保存导航状态
   - 恢复导航状态
   - 清理导航历史

### 9.5 扩展建议

1. 功能扩展

   - 添加更多转场动画
   - 实现自定义手势
   - 添加更复杂的导航逻辑
   - 集成深层链接

2. 界面优化

   - 添加更多交互反馈
   - 优化转场动画
   - 改进导航栏效果
   - 增强搜索体验

3. 性能优化
   - 优化状态管理
   - 改进内存使用
   - 提升动画性能
   - 优化导航栈管理
