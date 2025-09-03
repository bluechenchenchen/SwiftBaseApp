# @ObservedObject 和外部对象观察

## 基本介绍

### 概念解释

`@ObservedObject` 是 SwiftUI 中用于观察符合 `ObservableObject` 协议的外部对象的属性包装器。与 `@StateObject` 不同，它不负责创建对象，而是观察由父视图或其他地方创建的现有对象。当对象的 `@Published` 属性发生变化时，使用该对象的视图会自动重新渲染。

从前端开发的角度来看，`@ObservedObject` 类似于 Vue.js 中的 `props` 响应式对象或 React 中的外部状态订阅，它让视图能够响应外部传入的可观察对象的状态变化。

### 使用场景

- 接收父视图传递的视图模型
- 观察全局共享的数据对象
- 监听服务层的状态变化
- 在子视图中使用父级创建的状态对象
- 多个视图共享同一个数据源

### 主要特性

- **外部对象观察**: 观察由外部创建和管理的对象
- **自动更新**: 当对象的 @Published 属性变化时自动更新视图
- **轻量级**: 不负责对象的生命周期管理
- **响应式**: 提供完整的响应式数据绑定
- **灵活传递**: 可以通过参数、环境等方式传递

## 基础用法

### 基本示例

```swift
// 1. 定义可观察对象
class ShoppingCart: ObservableObject {
    @Published var items: [Item] = []
    @Published var totalPrice: Double = 0.0

    func addItem(_ item: Item) {
        items.append(item)
        updateTotalPrice()
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
        updateTotalPrice()
    }

    private func updateTotalPrice() {
        totalPrice = items.reduce(0) { $0 + $1.price }
    }
}

// 2. 父视图创建对象
struct ShoppingView: View {
    @StateObject private var cart = ShoppingCart()

    var body: some View {
        VStack {
            ProductListView(cart: cart)
            CartSummaryView(cart: cart)
        }
    }
}

// 3. 子视图观察对象
struct CartSummaryView: View {
    @ObservedObject var cart: ShoppingCart

    var body: some View {
        VStack {
            Text("购物车商品: \(cart.items.count)")
            Text("总价: ¥\(cart.totalPrice, specifier: "%.2f")")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
```

### 与 @StateObject 的对比

```swift
// @StateObject - 创建和管理对象
struct ParentView: View {
    @StateObject private var viewModel = UserViewModel() // 创建对象

    var body: some View {
        ChildView(viewModel: viewModel) // 传递给子视图
    }
}

// @ObservedObject - 观察外部对象
struct ChildView: View {
    @ObservedObject var viewModel: UserViewModel // 接收外部对象

    var body: some View {
        Text(viewModel.userName)
    }
}
```

### 常用属性和方法

#### 数据流传递

```swift
// 用户信息管理
class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var loginError: String?

    func login(username: String, password: String) async {
        // 登录逻辑
        do {
            let user = try await AuthService.login(username: username, password: password)
            await MainActor.run {
                self.currentUser = user
                self.isLoggedIn = true
                self.loginError = nil
            }
        } catch {
            await MainActor.run {
                self.loginError = error.localizedDescription
            }
        }
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        loginError = nil
    }
}
```

#### 列表数据管理

```swift
// 任务列表管理
class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var filter: TaskFilter = .all

    var filteredTasks: [Task] {
        switch filter {
        case .all:
            return tasks
        case .completed:
            return tasks.filter { $0.isCompleted }
        case .pending:
            return tasks.filter { !$0.isCompleted }
        }
    }

    func addTask(_ task: Task) {
        tasks.append(task)
    }

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}
```

### 使用注意事项

1. **对象来源**: @ObservedObject 必须接收外部创建的对象，不能自己创建
2. **生命周期**: 对象的生命周期由创建者管理，观察者不负责释放
3. **线程安全**: 确保 @Published 属性的更新在主线程进行
4. **强引用**: 视图会持有对象的强引用，注意避免循环引用

## 样式和自定义

### 自定义数据源

```swift
// 网络数据源
class NetworkDataSource: ObservableObject {
    @Published var data: [String] = []
    @Published var isLoading = false
    @Published var error: Error?

    func fetchData() async {
        await MainActor.run {
            isLoading = true
            error = nil
        }

        do {
            let result = try await NetworkService.fetchData()
            await MainActor.run {
                self.data = result
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
}

// 使用自定义数据源
struct DataListView: View {
    @ObservedObject var dataSource: NetworkDataSource

    var body: some View {
        VStack {
            if dataSource.isLoading {
                ProgressView("加载中...")
            } else if let error = dataSource.error {
                Text("错误: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                List(dataSource.data, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .onAppear {
            Task {
                await dataSource.fetchData()
            }
        }
    }
}
```

### 条件观察

```swift
// 条件观察示例
struct ConditionalObserverView: View {
    let useExternalData: Bool
    @StateObject private var localData = LocalDataManager()
    @ObservedObject var externalData: ExternalDataManager

    var body: some View {
        VStack {
            if useExternalData {
                ExternalDataView(manager: externalData)
            } else {
                LocalDataView(manager: localData)
            }
        }
    }
}
```

## 高级特性

### 组合使用

```swift
// 多数据源组合
struct DashboardView: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var notificationManager: NotificationManager
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                UserProfileSection(manager: userManager)
                NotificationSection(manager: notificationManager)
                SettingsSection(manager: settingsManager)
            }
        }
    }
}

// 数据源协调器
class AppDataCoordinator: ObservableObject {
    let userManager = UserManager()
    let notificationManager = NotificationManager()
    let settingsManager = SettingsManager()

    init() {
        setupDataBinding()
    }

    private func setupDataBinding() {
        // 设置数据源之间的协调逻辑
    }
}
```

### 动画效果

```swift
struct AnimatedObserverView: View {
    @ObservedObject var animationController: AnimationController

    var body: some View {
        VStack {
            Circle()
                .fill(animationController.currentColor)
                .frame(width: animationController.circleSize)
                .scaleEffect(animationController.scale)
                .animation(.easeInOut(duration: 0.5), value: animationController.scale)

            Button("切换动画") {
                animationController.toggleAnimation()
            }
        }
    }
}

class AnimationController: ObservableObject {
    @Published var circleSize: CGFloat = 100
    @Published var scale: CGFloat = 1.0
    @Published var currentColor: Color = .blue

    func toggleAnimation() {
        scale = scale == 1.0 ? 1.5 : 1.0
        currentColor = currentColor == .blue ? .red : .blue
        circleSize = circleSize == 100 ? 150 : 100
    }
}
```

### 状态同步

```swift
// 多视图状态同步
class SharedCounter: ObservableObject {
    @Published var count = 0
    @Published var history: [String] = []

    func increment() {
        count += 1
        addToHistory("增加到 \(count)")
    }

    func decrement() {
        count -= 1
        addToHistory("减少到 \(count)")
    }

    func reset() {
        count = 0
        addToHistory("重置为 0")
    }

    private func addToHistory(_ action: String) {
        history.append("\(Date().formatted(.dateTime.hour().minute().second())): \(action)")
        if history.count > 10 {
            history.removeFirst()
        }
    }
}

struct CounterDisplayView: View {
    @ObservedObject var counter: SharedCounter

    var body: some View {
        VStack {
            Text("当前计数: \(counter.count)")
                .font(.largeTitle)
                .bold()

            Text("历史记录:")
                .font(.headline)

            ForEach(counter.history.reversed(), id: \.self) { record in
                Text(record)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

## 性能优化

### 最佳实践

```swift
// 1. 使用计算属性减少不必要的更新
class OptimizedDataManager: ObservableObject {
    @Published private var rawData: [Item] = []
    @Published var filter: String = ""

    // 计算属性，只在依赖项变化时重新计算
    var filteredData: [Item] {
        if filter.isEmpty {
            return rawData
        }
        return rawData.filter { $0.name.localizedCaseInsensitiveContains(filter) }
    }

    // 批量更新减少发布次数
    func updateData(_ newData: [Item]) {
        DispatchQueue.main.async {
            self.rawData = newData
        }
    }
}

// 2. 条件性观察，避免不必要的重绘
struct OptimizedView: View {
    @ObservedObject var dataManager: OptimizedDataManager

    var body: some View {
        List {
            ForEach(dataManager.filteredData) { item in
                ItemRowView(item: item)
                    .id(item.id) // 使用稳定的 ID
            }
        }
        .animation(.default, value: dataManager.filteredData.count)
    }
}
```

### 常见陷阱

```swift
// ❌ 错误：在视图中创建 @ObservedObject
struct BadExample: View {
    @ObservedObject var manager = DataManager() // 错误！每次重绘都会创建新对象

    var body: some View {
        Text("数据: \(manager.data)")
    }
}

// ✅ 正确：接收外部创建的对象
struct GoodExample: View {
    @ObservedObject var manager: DataManager // 正确！接收外部对象

    var body: some View {
        Text("数据: \(manager.data)")
    }
}

// ❌ 错误：循环引用
class BadViewModel: ObservableObject {
    @Published var view: AnyView? // 持有视图的强引用
}

// ✅ 正确：避免循环引用
class GoodViewModel: ObservableObject {
    @Published var data: String = ""
    weak var delegate: ViewModelDelegate? // 使用弱引用
}
```

### 优化技巧

```swift
// 1. 分离状态，减少不必要的更新
class SeparatedStateManager: ObservableObject {
    // 频繁变化的状态
    @Published var searchText: String = ""

    // 不频繁变化的状态分离到另一个对象
    @Published var staticData: [String] = []
}

// 2. 使用 @Published 的 projectedValue 进行更精确的控制
class AdvancedManager: ObservableObject {
    @Published var value: Int = 0

    // 提供对发布者的直接访问
    var valuePublisher: Published<Int>.Publisher {
        $value
    }

    func updateValue(_ newValue: Int) {
        // 只在值真正改变时更新
        if value != newValue {
            value = newValue
        }
    }
}

// 3. 延迟更新减少高频更新
class ThrottledManager: ObservableObject {
    @Published var searchResults: [String] = []
    private var searchTask: Task<Void, Never>?

    func search(_ query: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms 延迟
            if !Task.isCancelled {
                await performSearch(query)
            }
        }
    }

    @MainActor
    private func performSearch(_ query: String) async {
        // 执行搜索并更新结果
        searchResults = ["结果1", "结果2", "结果3"]
    }
}
```

## 示例代码

### 基础示例

```swift
// 简单的消息管理
class MessageManager: ObservableObject {
    @Published var messages: [String] = []

    func addMessage(_ message: String) {
        messages.append(message)
    }

    func clearMessages() {
        messages.removeAll()
    }
}

struct MessageView: View {
    @ObservedObject var messageManager: MessageManager
    @State private var newMessage = ""

    var body: some View {
        VStack {
            List(messageManager.messages, id: \.self) { message in
                Text(message)
            }

            HStack {
                TextField("输入消息", text: $newMessage)
                Button("发送") {
                    messageManager.addMessage(newMessage)
                    newMessage = ""
                }
            }
            .padding()
        }
    }
}
```

### 进阶示例

```swift
// 复杂的购物车系统
class Product: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var price: Double
    @Published var stock: Int

    init(name: String, price: Double, stock: Int) {
        self.name = name
        self.price = price
        self.stock = stock
    }
}

class ShoppingCartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var discount: Double = 0.0

    var subtotal: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var total: Double {
        subtotal * (1 - discount)
    }

    func addItem(_ product: Product) {
        if let existingItem = items.first(where: { $0.product.id == product.id }) {
            existingItem.quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    func updateQuantity(_ item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }
}

struct CartItem: Identifiable, ObservableObject {
    let id = UUID()
    @Published var product: Product
    @Published var quantity: Int

    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
```

### 完整 Demo

```swift
// 完整的待办事项应用
class TodoManager: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var filter: TodoFilter = .all

    var filteredTodos: [Todo] {
        switch filter {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }

    var activeCount: Int {
        todos.filter { !$0.isCompleted }.count
    }

    func addTodo(_ title: String) {
        let todo = Todo(title: title)
        todos.append(todo)
    }

    func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }

    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }

    func clearCompleted() {
        todos.removeAll { $0.isCompleted }
    }
}

struct TodoApp: View {
    @StateObject private var todoManager = TodoManager()

    var body: some View {
        NavigationView {
            VStack {
                TodoInputView(todoManager: todoManager)
                TodoListView(todoManager: todoManager)
                TodoFilterView(todoManager: todoManager)
            }
            .navigationTitle("待办事项")
        }
    }
}

struct TodoListView: View {
    @ObservedObject var todoManager: TodoManager

    var body: some View {
        List {
            ForEach(todoManager.filteredTodos) { todo in
                TodoRowView(todo: todo, todoManager: todoManager)
            }
            .onDelete(perform: deleteTodos)
        }
    }

    private func deleteTodos(offsets: IndexSet) {
        for index in offsets {
            let todo = todoManager.filteredTodos[index]
            todoManager.deleteTodo(todo)
        }
    }
}
```

## 注意事项

### 常见问题

1. **对象创建混淆**: 记住 @ObservedObject 不创建对象，只观察现有对象
2. **生命周期管理**: 对象的生命周期由创建者负责，不是观察者
3. **内存泄漏**: 避免在观察的对象中持有视图的强引用
4. **线程安全**: 确保对 @Published 属性的修改在主线程进行

### 兼容性考虑

- iOS 13.0+ 支持 @ObservedObject
- 需要导入 SwiftUI 和 Combine 框架
- 确保观察的对象符合 ObservableObject 协议

### 使用建议

1. **明确职责**: 明确对象的创建者和观察者的职责
2. **避免过度观察**: 只观察真正需要响应变化的对象
3. **合理设计**: 设计合理的对象传递层次，避免过深的传递链
4. **性能优化**: 使用计算属性和条件更新来优化性能

## 完整运行 Demo

### 源代码

完整的 @ObservedObject 演示代码包含在 `ObservedObjectDemoView.swift` 文件中，展示了各种使用场景和最佳实践。

### 运行说明

1. 在 Xcode 中打开项目
2. 导航到状态管理模块
3. 选择 "@ObservedObject 观察对象" 选项
4. 查看各种示例和演示

### 功能说明

演示包含以下功能：

- 基础的外部对象观察
- 数据更新响应机制
- 多视图共享状态
- 性能优化技巧
- 常见陷阱避免
- 实际应用场景展示

每个示例都包含详细的注释和说明，帮助理解 @ObservedObject 的使用方法和最佳实践。通过对比 @StateObject 和 @ObservedObject 的差异，更好地掌握 SwiftUI 中的状态管理概念。
