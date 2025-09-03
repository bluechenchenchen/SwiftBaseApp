# SwiftUI 生命周期完全指南

> 专为前端开发者设计的 SwiftUI 生命周期解析

## 目录

- [基础概念](#基础概念)
- [View 的生命周期](#view-的生命周期)
- [与 React 生命周期的对比](#与-react-生命周期的对比)
- [常见场景示例](#常见场景示例)
- [最佳实践](#最佳实践)

## 基础概念

在深入生命周期之前，需要理解 SwiftUI 的几个核心概念：

1. **声明式 UI**：

   - 与 React 类似，SwiftUI 也是声明式的
   - 你描述想要的 UI 状态，框架负责实现细节

2. **值类型 vs 引用类型**：

   - View 是值类型（struct）
   - ViewModel 是引用类型（class）
   - 这与 React 的组件（引用类型）有很大不同

3. **状态管理**：
   - @State：类似 React 的 useState
   - @Binding：类似 React 的 props 传递
   - @StateObject：类似 React 的 useRef
   - @ObservedObject：类似 React 的 props 中的对象

## View 的生命周期

SwiftUI 视图的生命周期与 React 组件有很大的不同。作为前端开发者，理解这些差异对于正确使用 SwiftUI 至关重要。

### 1. 初始化阶段（Initialization Phase）

在这个阶段，SwiftUI 视图被创建和初始化。这个过程包括：

```swift
struct MyView: View {
    // 1. 属性初始化 - 最先执行
    // @State 属性包装器会创建持久化存储
    @State private var count = 0
    @StateObject private var viewModel = ViewModel() // 创建持久化的对象
    @ObservedObject var dataManager: DataManager // 接收外部对象
    @Environment(\.colorScheme) var colorScheme // 环境值
    @Binding var isActive: Bool // 绑定值

    // 2. init() 构造函数 (可选) - 第二步执行
    init(dataManager: DataManager, isActive: Binding<Bool>) {
        self.dataManager = dataManager
        self._isActive = isActive // 注意 Binding 的特殊语法

        // 可以在这里进行一些初始化工作
        // 但不建议在这里进行异步操作或副作用
    }

    // 3. body 计算属性 - 最后执行
    // body 会被多次调用，每次状态改变都会重新计算
    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") { count += 1 }
        }
    }
}
```

#### 初始化阶段注意事项：

1. **属性初始化顺序**：

   - 属性包装器（@State 等）最先初始化
   - 普通属性其次
   - init() 构造函数最后

2. **@State 的特殊性**：

   - @State 创建持久化存储
   - 在内存中的位置保持不变
   - 视图重建时值保持不变

3. **构造函数限制**：
   - 不能使用 async/await
   - 不能直接修改 @State 值
   - 不能访问 @Environment 值

### 2. 出现阶段（Appearance Phase）

这个阶段对应视图被添加到视图层级时：

```swift
struct DetailView: View {
    @State private var data: [Item] = []
    @State private var hasAppeared = false

    var body: some View {
        List(data) { item in
            ItemRow(item: item)
        }
        .onAppear {
            // 视图出现时执行
            // ⚠️ 可能被多次调用！
            if !hasAppeared {
                loadInitialData() // 仅首次加载数据
                hasAppeared = true
            }

            // 每次出现都需要执行的代码
            startObservingNotifications()
        }
        .task {
            // 推荐用 task 处理异步操作
            // task 会在视图消失时自动取消
            do {
                data = try await loadDataFromServer()
            } catch {
                handleError(error)
            }
        }
    }
}
```

#### 出现阶段的关键点：

1. **onAppear 的特点**：

   - 可能被多次调用
   - 适合设置观察者、订阅通知
   - 不保证在主线程执行

2. **task 修饰符的优势**：

   - 自动取消异步操作
   - 支持 async/await
   - 生命周期绑定到视图

3. **常见用途**：
   - 数据加载
   - 设置通知观察
   - 启动动画
   - 初始化外部资源

### 3. 更新阶段（Update Phase）

SwiftUI 的更新机制是自动的，但你可以精确控制和响应这些更新：

```swift
struct ContentView: View {
    @State private var searchText = ""
    @State private var items: [Item] = []
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        List {
            ForEach(filteredItems) { item in
                ItemRow(item: item)
            }
        }
        .searchable(text: $searchText)
        // 1. 监听单个值的变化
        .onChange(of: searchText) { oldValue, newValue in
            // 可以访问变化前后的值
            print("Search text changed from \(oldValue) to \(newValue)")
            updateSearchResults()
        }
        // 2. 监听多个值的变化
        .onChange(of: viewModel.filterOptions) { _ in
            updateSearchResults()
        }
        // 3. 使用 task 处理异步更新
        .task(id: searchText) { // id 参数使 task 在值变化时重新执行
            do {
                items = try await searchItems(matching: searchText)
            } catch {
                handleError(error)
            }
        }
        // 4. 转场动画
        .animation(.spring(), value: filteredItems)
    }

    // 计算属性也是更新机制的一部分
    var filteredItems: [Item] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.name.contains(searchText) }
    }
}
```

#### 更新触发条件：

1. **状态变化**：

   - @State 值改变
   - @StateObject 对象发出更新
   - @ObservedObject 对象发出更新
   - @Environment 值改变
   - @Binding 值改变

2. **视图结构变化**：

   - 父视图重建
   - 条件渲染改变
   - ForEach 内容更新

3. **系统事件**：
   - 设备旋转
   - 暗黑模式切换
   - 动态字体大小改变

### 4. 消失阶段（Disappearance Phase）

这个阶段需要特别注意资源的清理和状态的保存：

```swift
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var subscription: AnyCancellable?

    var body: some View {
        ChatList(messages: viewModel.messages)
            .onAppear {
                // 设置订阅
                subscription = viewModel.messagePublisher
                    .sink { message in
                        // 处理新消息
                    }
            }
            .onDisappear {
                // 1. 清理资源
                subscription?.cancel()
                viewModel.disconnectFromChat()

                // 2. 保存状态
                viewModel.saveMessages()

                // 3. 停止定时器或其他后台任务
                viewModel.stopPolling()
            }
            // task 会在视图消失时自动取消
            .task {
                await viewModel.connectToChat()
            }
    }
}

// ViewModel 示例
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var timer: Timer?

    // 在 deinit 中进行最终清理
    deinit {
        print("ChatViewModel is being deinitialized")
        timer?.invalidate()
        // 执行其他清理工作
    }
}
```

## 与 React 生命周期的对比

| React                 | SwiftUI     | 说明                     |
| --------------------- | ----------- | ------------------------ |
| constructor           | init()      | 初始化阶段               |
| componentDidMount     | onAppear    | 组件出现时               |
| componentDidUpdate    | onChange    | 状态更新时               |
| componentWillUnmount  | onDisappear | 组件消失时               |
| shouldComponentUpdate | -           | SwiftUI 自动处理更新优化 |
| render                | body        | 渲染视图                 |

## 常见场景示例

### 1. 数据加载

```swift
struct ContentView: View {
    @State private var data: [Item] = []

    var body: some View {
        List(data) { item in
            Text(item.name)
        }
        .onAppear {
            // 加载数据
            loadData()
        }
    }

    func loadData() {
        // 数据加载逻辑
    }
}
```

### 2. 订阅管理

```swift
class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    init() {
        // 设置订阅
        setupSubscriptions()
    }

    func setupSubscriptions() {
        // 添加订阅
        $somePublisher
            .sink { ... }
            .store(in: &cancellables)
    }

    deinit {
        // 订阅会自动取消
        print("ViewModel deinit")
    }
}
```

### 3. 视图更新优化

```swift
struct OptimizedView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            // 使用 equatable 视图避免不必要的更新
            CountDisplay(count: count)

            Button("Increment") {
                count += 1
            }
        }
    }
}

// 实现 Equatable 以优化更新
struct CountDisplay: View, Equatable {
    let count: Int

    static func == (lhs: CountDisplay, rhs: CountDisplay) -> Bool {
        lhs.count == rhs.count
    }

    var body: some View {
        Text("Count: \(count)")
    }
}
```

## 最佳实践

### 1. 状态管理详解

SwiftUI 的状态管理系统非常强大，但需要正确理解每种状态类型的使用场景：

#### @State

适用于简单的视图本地状态：

```swift
struct CounterView: View {
    @State private var count = 0  // 简单的数值
    @State private var isActive = false  // 布尔标志
    @State private var text = ""  // 文本输入

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") { count += 1 }

            TextField("Enter text", text: $text)

            if isActive {
                ActiveView()
            }
        }
    }
}
```

特点：

- 值类型数据（Int, String, struct 等）
- 视图私有状态
- SwiftUI 管理内存和生命周期
- 修改时触发视图更新

#### @StateObject

用于管理引用类型（class）的生命周期：

```swift
class UserViewModel: ObservableObject {
    @Published var username = ""
    @Published var isLoggedIn = false

    func login() async throws {
        // 登录逻辑
        isLoggedIn = true
    }
}

struct UserView: View {
    // 创建并持有 ViewModel 实例
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
            Button("Login") {
                Task {
                    try? await viewModel.login()
                }
            }
        }
    }
}
```

特点：

- 引用类型数据（class）
- 视图创建和管理实例
- 实例在视图重建时保持不变
- 适合复杂的状态管理

#### @ObservedObject

用于接收外部传入的可观察对象：

```swift
struct ProfileView: View {
    // 接收外部传入的 ViewModel
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        VStack {
            Text("Welcome, \(viewModel.username)")
            if viewModel.isLoggedIn {
                LogoutButton(viewModel: viewModel)
            }
        }
    }
}

// 子视图也使用同一个 ViewModel
struct LogoutButton: View {
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        Button("Logout") {
            // 登出逻辑
        }
    }
}
```

特点：

- 接收外部对象
- 不负责对象生命周期
- 视图重建时可能重置
- 适合依赖注入模式

#### @Environment

用于访问环境值和依赖项：

```swift
struct ThemeAwareView: View {
    // 系统环境值
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar

    // 自定义环境值
    @Environment(\.myAppTheme) var theme

    var body: some View {
        VStack {
            Text("Current theme: \(theme.name)")
            Text("Color scheme: \(colorScheme == .dark ? "Dark" : "Light")")
        }
        .foregroundColor(theme.textColor)
        .background(theme.backgroundColor)
    }
}

// 自定义环境值
struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme.default
}

extension EnvironmentValues {
    var myAppTheme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 在父视图中设置环境值
struct RootView: View {
    var body: some View {
        ThemeAwareView()
            .environment(\.myAppTheme, Theme.dark)
    }
}
```

特点：

- 全局或局部环境配置
- 自动向下传递
- 适合主题、本地化等
- 支持依赖注入

#### @Binding

用于在视图间共享和同步状态：

```swift
struct ParentView: View {
    @State private var isOn = false

    var body: some View {
        VStack {
            Text("Switch is: \(isOn ? "On" : "Off")")
            // 传递绑定
            CustomToggle(isOn: $isOn)
            // 转换绑定
            InvertedToggle(isOn: Binding(
                get: { !isOn },
                set: { isOn = !$0 }
            ))
        }
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool  // 接收绑定

    var body: some View {
        Toggle("Toggle", isOn: $isOn)
            .toggleStyle(.switch)
    }
}

// 高级绑定用法
struct FormField: View {
    @Binding var text: String
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField("Enter \(title)", text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}
```

特点：

- 双向数据绑定
- 支持值转换
- 适合组件复用
- 保持状态同步

### 2. 性能优化详解

SwiftUI 的性能优化需要从多个层面考虑：

#### 视图结构优化

1. **视图拆分**：

```swift
// ❌ 不好的做法：单个复杂视图
struct ComplexView: View {
    var body: some View {
        VStack {
            // 大量嵌套的视图和逻辑
            ForEach(items) { item in
                // 复杂的条件渲染
                if item.isEnabled {
                    // 复杂的布局
                }
            }
        }
    }
}

// ✅ 好的做法：拆分成多个子视图
struct OptimizedView: View {
    var body: some View {
        VStack {
            HeaderView()
            ItemListView(items: items)
            FooterView()
        }
    }
}

struct ItemListView: View {
    let items: [Item]

    var body: some View {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}

struct ItemRow: View {
    let item: Item

    var body: some View {
        if item.isEnabled {
            EnabledItemView(item: item)
        } else {
            DisabledItemView(item: item)
        }
    }
}
```

2. **避免无谓的重建**：

```swift
// ❌ 不好的做法：在 body 中创建对象或进行计算
struct BadView: View {
    var body: some View {
        VStack {
            // 每次重建都会创建新的格式化器
            let formatter = DateFormatter()
            Text(formatter.string(from: Date()))

            // 每次重建都会重新计算
            let total = items.reduce(0) { $0 + $1.price }
            Text("Total: \(total)")
        }
    }
}

// ✅ 好的做法：使用计算属性或静态属性
struct GoodView: View {
    // 静态属性：只创建一次
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    // 计算属性：缓存计算结果
    var total: Double {
        items.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        VStack {
            Text(Self.formatter.string(from: Date()))
            Text("Total: \(total)")
        }
    }
}
```

#### 状态管理优化

1. **正确的状态作用域**：

```swift
// ❌ 不好的做法：状态作用域过大
struct ParentView: View {
    @State private var detailText = "" // 这个状态只在子视图中使用

    var body: some View {
        VStack {
            HeaderView()
            DetailView(text: $detailText) // 传递给真正需要的视图
            FooterView()
        }
    }
}

// ✅ 好的做法：状态靠近使用它的视图
struct ParentView: View {
    var body: some View {
        VStack {
            HeaderView()
            DetailView()
            FooterView()
        }
    }
}

struct DetailView: View {
    @State private var text = "" // 状态在实际使用的地方

    var body: some View {
        TextField("Detail", text: $text)
    }
}
```

2. **避免不必要的观察**：

```swift
// ❌ 不好的做法：观察整个对象
class UserViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var preferences = Preferences()
}

// ✅ 好的做法：只观察需要的属性
struct UserView: View {
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        // 使用 @ViewBuilder 分离不同部分
        VStack {
            NameSection(name: $viewModel.name)
            EmailSection(email: $viewModel.email)
            PreferencesSection(preferences: $viewModel.preferences)
        }
    }
}
```

#### 列表性能优化

1. **使用 LazyVStack 和 LazyHStack**：

```swift
// ❌ 不好的做法：一次性加载所有内容
ScrollView {
    VStack {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}

// ✅ 好的做法：懒加载内容
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}
```

2. **ID 优化**：

```swift
// ❌ 不好的做法：使用索引作为 ID
ForEach(0..<items.count, id: \.self) { index in
    ItemRow(item: items[index])
}

// ✅ 好的做法：使用稳定的标识符
ForEach(items) { item in // 要求 Item 遵循 Identifiable
    ItemRow(item: item)
}

// 或者使用自定义 ID
ForEach(items, id: \.stableId) { item in
    ItemRow(item: item)
}
```

#### 绘图和动画优化

1. **使用 drawingGroup()**：

```swift
// 当有复杂的绘图操作时
struct ComplexGraphView: View {
    var body: some View {
        Canvas { context, size in
            // 复杂的绘图操作
        }
        .drawingGroup() // 使用 Metal 进行渲染
    }
}
```

2. **动画性能**：

```swift
// ❌ 不好的做法：动画过多属性
Button("Animate") {
    withAnimation {
        // 同时动画多个属性可能导致性能问题
        self.scale = 1.5
        self.rotation = .degrees(45)
        self.offset = CGSize(width: 100, height: 100)
    }
}

// ✅ 好的做法：分离动画
Button("Animate") {
    // 使用不同的动画时间和曲线
    withAnimation(.spring(duration: 0.3)) {
        self.scale = 1.5
    }
    withAnimation(.easeInOut(duration: 0.5)) {
        self.rotation = .degrees(45)
    }
    withAnimation(.easeOut(duration: 0.7)) {
        self.offset = CGSize(width: 100, height: 100)
    }
}
```

#### 调试性能问题

1. **使用 Instruments**：

- Time Profiler 工具
- Allocations 工具
- Core Animation 工具

2. **使用 SwiftUI 预览性能检查**：

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Default")
            .previewLayout(.sizeThatFits)

        // 添加性能检查
        ContentView()
            .previewDisplayName("With Performance Metrics")
            .previewLayout(.sizeThatFits)
            .measureMetrics() // 自定义修饰符用于性能测量
    }
}
```

3. **日志和断点**：

```swift
struct DebugView: View {
    var body: some View {
        Text("Debug")
            .onChange(of: someValue) { oldValue, newValue in
                print("Value changed: \(oldValue) -> \(newValue)")
                // 设置条件断点
                if newValue > threshold {
                    print("Threshold exceeded!")
                }
            }
    }
}
```

- 实现 Equatable 以减少更新
- 使用 lazy 容器延迟加载

### 3. 内存管理详解

SwiftUI 的内存管理需要特别注意引用类型和闭包的处理：

#### 引用循环预防

1. **使用 weak self**：

```swift
class ChatViewModel: ObservableObject {
    private var timer: Timer?

    func startPolling() {
        // ❌ 不好的做法：可能造成引用循环
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.fetchNewMessages()
        }

        // ✅ 好的做法：使用 weak self
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.fetchNewMessages()
        }
    }

    deinit {
        timer?.invalidate()
        print("ChatViewModel deinitialized")
    }
}
```

2. **异步操作中的内存管理**：

```swift
class DataViewModel: ObservableObject {
    @Published var data: [Item] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchData() {
        // ❌ 不好的做法：可能导致内存泄漏
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Item].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.handleCompletion(completion)
            } receiveValue: { items in
                self.data = items
            }
            // 忘记存储或取消订阅

        // ✅ 好的做法：正确管理订阅
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Item].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] items in
                self?.data = items
            }
            .store(in: &cancellables) // 存储订阅以便自动取消
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
```

#### 资源管理

1. **视图资源的生命周期管理**：

```swift
struct ResourceView: View {
    // 使用 @StateObject 确保 ViewModel 的生命周期与视图同步
    @StateObject private var viewModel = ResourceViewModel()

    var body: some View {
        List(viewModel.resources) { resource in
            ResourceRow(resource: resource)
        }
        .onAppear {
            viewModel.startResourceMonitoring()
        }
        .onDisappear {
            viewModel.stopResourceMonitoring()
        }
    }
}

class ResourceViewModel: ObservableObject {
    @Published private(set) var resources: [Resource] = []
    private var monitor: ResourceMonitor?

    func startResourceMonitoring() {
        monitor = ResourceMonitor()
        monitor?.startMonitoring { [weak self] newResources in
            self?.resources = newResources
        }
    }

    func stopResourceMonitoring() {
        monitor?.stopMonitoring()
        monitor = nil
    }

    deinit {
        stopResourceMonitoring()
    }
}
```

2. **临时资源的管理**：

```swift
struct ImageProcessingView: View {
    @State private var processedImage: UIImage?
    @State private var tempFileURL: URL?

    var body: some View {
        VStack {
            if let image = processedImage {
                Image(uiImage: image)
            }
        }
        .task {
            // 创建临时文件
            tempFileURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)

            // 使用临时文件
            if let url = tempFileURL {
                try? processImage(saveToURL: url)
            }
        }
        .onDisappear {
            // 清理临时文件
            if let url = tempFileURL {
                try? FileManager.default.removeItem(at: url)
                tempFileURL = nil
            }
        }
    }
}
```

#### 内存使用优化

1. **图片资源优化**：

```swift
struct ImageGalleryView: View {
    let images: [UIImage]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(images.indices, id: \.self) { index in
                    // ❌ 不好的做法：直接使用大图
                    // Image(uiImage: images[index])

                    // ✅ 好的做法：根据显示大小调整图片
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}

// 图片缓存管理
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()

    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
```

2. **大数据集的处理**：

```swift
struct PaginatedListView: View {
    @StateObject private var viewModel = PaginatedViewModel()

    var body: some View {
        List {
            ForEach(viewModel.visibleItems) { item in
                ItemRow(item: item)
            }

            if viewModel.hasMoreItems {
                ProgressView()
                    .onAppear {
                        viewModel.loadMoreItems()
                    }
            }
        }
    }
}

class PaginatedViewModel: ObservableObject {
    @Published private(set) var visibleItems: [Item] = []
    private var allItems: [Item] = []
    private var currentPage = 0
    private let pageSize = 20

    var hasMoreItems: Bool {
        visibleItems.count < allItems.count
    }

    func loadMoreItems() {
        let start = currentPage * pageSize
        let end = min(start + pageSize, allItems.count)
        guard start < end else { return }

        visibleItems.append(contentsOf: allItems[start..<end])
        currentPage += 1
    }
}
```

#### 调试内存问题

1. **使用 Memory Graph**：

- Xcode Memory Debugger
- 检测引用循环
- 分析对象持有关系

2. **日志调试**：

```swift
class DebugViewModel: ObservableObject {
    init() {
        print("[\(type(of: self))] Initialized")
    }

    deinit {
        print("[\(type(of: self))] Deinitialized")
    }
}

struct DebugView: View {
    @StateObject private var viewModel = DebugViewModel()

    var body: some View {
        Text("Debug View")
            .onAppear {
                print("DebugView appeared")
            }
            .onDisappear {
                print("DebugView disappeared")
            }
    }
}
```

3. **内存警告处理**：

````swift
struct MemoryAwareView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var cache = ImageCache()

    var body: some View {
        ContentView()
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .background {
                    // 进入后台时清理内存
                    cache.clearCache()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                // 收到内存警告时清理缓存
                cache.clearCache()
            }
    }
}

- 正确使用 weak self 避免循环引用
- 在 onDisappear 中清理资源
- 使用 deinit 确认清理是否正确执行

### 4. 调试技巧

```swift
struct DebugView: View {
    var body: some View {
        Text("Debug View")
            .onAppear { print("View appeared") }
            .onDisappear { print("View disappeared") }
            .onChange(of: someValue) { print("Value changed to: \($0)") }
    }
}
````

## 注意事项

1. **值类型特性**：

   - SwiftUI 视图是值类型（struct）
   - 每次状态变化都会创建新的视图实例
   - 不要在视图中存储可变状态

2. **状态管理**：

   - @State 只用于简单的视图本地状态
   - 复杂状态使用 MVVM 模式
   - 避免视图之间直接传递 @StateObject

3. **生命周期回调**：

   - onAppear 不保证只调用一次
   - 视图可能被多次创建和销毁
   - 避免在 body 中进行副作用操作

4. **性能考虑**：
   - 保持视图简单和可组合
   - 使用 Group 和 @ViewBuilder 拆分大型视图
   - 合理使用 lazy 加载

## 常见问题解答

### Q1: 为什么我的 onAppear 被多次调用？

A1: SwiftUI 可能会多次创建和销毁视图实例。如果需要确保某些代码只运行一次，可以使用 @State 标志位：

```swift
struct ContentView: View {
    @State private var didAppear = false

    var body: some View {
        Text("Hello")
            .onAppear {
                if !didAppear {
                    // 只执行一次的代码
                    didAppear = true
                }
            }
    }
}
```

### Q2: 如何处理异步操作？

A2: 使用 Task 和 async/await：

```swift
struct AsyncView: View {
    @State private var data: String = ""

    var body: some View {
        Text(data)
            .task {
                // 异步操作
                do {
                    data = try await loadData()
                } catch {
                    print(error)
                }
            }
    }
}
```

### Q3: 如何在视图消失时取消操作？

A3: 使用 task 修饰符，它会在视图消失时自动取消：

```swift
struct CancellableView: View {
    var body: some View {
        Text("Loading...")
            .task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                // 如果视图消失，这里会自动取消
            }
    }
}
```

## 参考资源

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [WWDC Videos](https://developer.apple.com/videos/all-videos/)
- [Swift by Sundell](https://www.swiftbysundell.com)

## 更新日志

- 2024-01-17：初始版本
- 持续更新中...
