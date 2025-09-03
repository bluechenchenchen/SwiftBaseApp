# @Published 属性包装器详解

## 概念介绍

`@Published` 是 Combine 框架中的一个属性包装器，专门用于创建可观察的属性。当被 `@Published` 修饰的属性发生变化时，会自动发布变更通知，通知所有订阅者。这是 SwiftUI 响应式数据流的核心机制之一。

### 类比理解（前端视角）

如果你熟悉前端开发，`@Published` 可以类比为：

- **Vue.js 的 reactive 数据**: 当数据变化时自动触发视图更新
- **React 的 useState Hook**: 状态变化时重新渲染组件
- **Observable 模式**: 数据变化时通知所有观察者
- **MobX 的 observable**: 自动追踪和响应数据变化

```typescript
// 前端对比示例
// Vue.js
const state = reactive({
  count: 0
})

// React
const [count, setCount] = useState(0)

// SwiftUI @Published
@Published var count = 0
```

## 主要特性

### 1. 自动发布机制

- 属性值变化时自动发布 `objectWillChange` 信号
- 无需手动调用通知方法
- 与 SwiftUI 视图系统完美集成

### 2. 类型安全

- 编译时类型检查
- 支持任何可发布的数据类型
- 提供强类型的发布者（Publisher）

### 3. 组合友好

- 可以与 Combine 操作符组合使用
- 支持数据流转换和过滤
- 易于测试和调试

### 4. 性能优化

- 仅在值实际变化时发布
- 支持自定义相等性检查
- 可以控制发布时机

## 使用场景

### 1. ObservableObject 中的属性

```swift
class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var loginError: String?
}
```

### 2. 数据模型的可观察属性

```swift
class ShoppingCart: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var total: Double = 0.0
    @Published var isCheckingOut = false
}
```

### 3. 应用状态管理

```swift
class AppSettings: ObservableObject {
    @Published var theme: Theme = .light
    @Published var language: String = "en"
    @Published var notificationsEnabled = true
}
```

## 基础用法

### 1. 基本声明和使用

```swift
class CounterViewModel: ObservableObject {
    @Published var count = 0
    @Published var message = "Hello"

    func increment() {
        count += 1  // 自动发布变更通知
    }

    func updateMessage(_ newMessage: String) {
        message = newMessage  // 自动发布变更通知
    }
}
```

### 2. 在 SwiftUI 视图中使用

```swift
struct ContentView: View {
    @StateObject private var viewModel = CounterViewModel()

    var body: some View {
        VStack {
            Text("计数: \(viewModel.count)")
            Text(viewModel.message)

            Button("增加") {
                viewModel.increment()
            }
        }
    }
}
```

### 3. 访问发布者

```swift
class DataManager: ObservableObject {
    @Published var data: [String] = []

    init() {
        // 访问发布者，进行自定义处理
        $data
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { newData in
                print("数据变化: \(newData)")
            }
    }
}
```

## 高级特性

### 1. 自定义发布者行为

```swift
class CustomPublisher: ObservableObject {
    private var _value: String = ""

    @Published var value: String {
        get { _value }
        set {
            // 自定义设置逻辑
            if newValue != _value {
                _value = newValue.uppercased()
            }
        }
    }

    // 或者使用 willSet/didSet
    @Published var anotherValue: Int = 0 {
        willSet {
            print("即将设置为: \(newValue)")
        }
        didSet {
            print("已设置为: \(anotherValue)")
        }
    }
}
```

### 2. 条件发布

```swift
class ConditionalPublisher: ObservableObject {
    @Published var filteredData: [String] = []

    private var _rawData: [String] = [] {
        didSet {
            // 只有满足条件才更新发布的属性
            let filtered = _rawData.filter { !$0.isEmpty }
            if filtered != filteredData {
                filteredData = filtered
            }
        }
    }

    func updateData(_ newData: [String]) {
        _rawData = newData
    }
}
```

### 3. 组合多个发布者

```swift
class CombinedPublisher: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var fullName: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        // 组合多个发布者
        Publishers.CombineLatest($firstName, $lastName)
            .map { "\($0) \($1)".trimmingCharacters(in: .whitespaces) }
            .assign(to: &$fullName)
    }
}
```

## 性能优化

### 1. 避免频繁发布

```swift
class OptimizedPublisher: ObservableObject {
    @Published private(set) var processedData: [String] = []

    private var pendingData: [String] = []
    private let debounceInterval: TimeInterval = 0.3

    func addData(_ item: String) {
        pendingData.append(item)

        // 防抖处理，避免频繁更新
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval) {
            self.flushPendingData()
        }
    }

    private func flushPendingData() {
        if !pendingData.isEmpty {
            processedData.append(contentsOf: pendingData)
            pendingData.removeAll()
        }
    }
}
```

### 2. 使用私有设置器

```swift
class ReadOnlyPublisher: ObservableObject {
    @Published private(set) var computedValue: Double = 0.0

    @Published var inputValue: Double = 0.0 {
        didSet {
            // 只有在计算结果不同时才更新
            let newComputed = inputValue * 2.5
            if abs(newComputed - computedValue) > 0.001 {
                computedValue = newComputed
            }
        }
    }
}
```

### 3. 批量更新

```swift
class BatchUpdatePublisher: ObservableObject {
    @Published var items: [Item] = []

    func performBatchUpdate(_ updates: [Item]) {
        // 关闭自动发布
        objectWillChange.send()

        // 批量更新
        items = updates

        // 手动发布一次变更通知（如果需要）
    }
}
```

## 与其他属性包装器的关系

### 1. 与 @StateObject 配合

```swift
// ViewModel 中使用 @Published
class ViewModel: ObservableObject {
    @Published var data: String = ""
}

// View 中使用 @StateObject
struct MyView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        Text(viewModel.data)
    }
}
```

### 2. 与 @ObservedObject 配合

```swift
// 父视图创建对象
struct ParentView: View {
    @StateObject private var sharedViewModel = SharedViewModel()

    var body: some View {
        ChildView(viewModel: sharedViewModel)
    }
}

// 子视图观察对象
struct ChildView: View {
    @ObservedObject var viewModel: SharedViewModel

    var body: some View {
        Text(viewModel.sharedData)
    }
}
```

### 3. 与 @EnvironmentObject 配合

```swift
// 注入环境对象
struct AppView: View {
    @StateObject private var appSettings = AppSettings()

    var body: some View {
        ContentView()
            .environmentObject(appSettings)
    }
}

// 使用环境对象
struct ContentView: View {
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        Toggle("通知", isOn: $appSettings.notificationsEnabled)
    }
}
```

## 测试策略

### 1. 基本测试

```swift
class PublisherTests: XCTestCase {
    func testPublishedPropertyUpdates() {
        let viewModel = TestViewModel()
        let expectation = XCTestExpectation(description: "Published property updates")

        var receivedValues: [String] = []
        let cancellable = viewModel.$data
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }

        viewModel.data = "Test"

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, ["", "Test"])

        cancellable.cancel()
    }
}
```

### 2. 组合测试

```swift
func testCombinedPublishers() {
    let publisher = CombinedPublisher()
    let expectation = XCTestExpectation(description: "Combined publishers")

    let cancellable = publisher.$fullName
        .dropFirst() // 跳过初始值
        .sink { fullName in
            if fullName == "John Doe" {
                expectation.fulfill()
            }
        }

    publisher.firstName = "John"
    publisher.lastName = "Doe"

    wait(for: [expectation], timeout: 1.0)
    cancellable.cancel()
}
```

### 3. 性能测试

```swift
func testPublishingPerformance() {
    let publisher = OptimizedPublisher()

    measure {
        for i in 0..<1000 {
            publisher.inputValue = Double(i)
        }
    }
}
```

## 常见问题和解决方案

### 1. 循环引用问题

```swift
// 问题：循环引用
class ProblematicClass: ObservableObject {
    @Published var data: String = ""

    init() {
        // 错误：强引用 self
        $data.sink { _ in
            self.handleDataChange()
        }
    }

    func handleDataChange() {
        // 处理逻辑
    }
}

// 解决方案：使用弱引用
class FixedClass: ObservableObject {
    @Published var data: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        $data.sink { [weak self] _ in
            self?.handleDataChange()
        }
        .store(in: &cancellables)
    }

    func handleDataChange() {
        // 处理逻辑
    }
}
```

### 2. 线程安全问题

```swift
// 问题：在后台线程更新
class ThreadUnsafeClass: ObservableObject {
    @Published var data: String = ""

    func loadData() {
        DispatchQueue.global().async {
            // 错误：在后台线程更新 @Published 属性
            self.data = "Loaded"
        }
    }
}

// 解决方案：确保在主线程更新
class ThreadSafeClass: ObservableObject {
    @Published var data: String = ""

    func loadData() {
        DispatchQueue.global().async {
            let loadedData = "Loaded"

            DispatchQueue.main.async {
                self.data = loadedData
            }
        }
    }
}
```

### 3. 性能问题

```swift
// 问题：频繁更新导致性能问题
class PerformanceProblem: ObservableObject {
    @Published var items: [Item] = []

    func addItemsOneByOne(_ newItems: [Item]) {
        // 每次添加都会触发发布
        for item in newItems {
            items.append(item)
        }
    }
}

// 解决方案：批量更新
class PerformanceSolution: ObservableObject {
    @Published var items: [Item] = []

    func addItems(_ newItems: [Item]) {
        // 一次性更新，只触发一次发布
        items.append(contentsOf: newItems)
    }
}
```

## 最佳实践

### 1. 命名约定

```swift
class BestPractices: ObservableObject {
    // 使用清晰的命名
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userList: [User] = []

    // 对于私有设置器，使用有意义的名称
    @Published private(set) var processedUserCount = 0
}
```

### 2. 属性组织

```swift
class OrganizedClass: ObservableObject {
    // 按功能分组
    // MARK: - 用户相关
    @Published var currentUser: User?
    @Published var isLoggedIn = false

    // MARK: - 界面状态
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - 数据
    @Published var items: [Item] = []
    @Published private(set) var filteredItems: [Item] = []
}
```

### 3. 文档注释

```swift
class DocumentedClass: ObservableObject {
    /// 当前登录的用户信息
    /// - Note: 当用户登录状态改变时会自动更新
    @Published var currentUser: User?

    /// 是否正在加载数据
    /// - Warning: 不要在后台线程直接设置此属性
    @Published var isLoading = false

    /// 错误消息，nil 表示没有错误
    /// - Important: 设置此属性会触发错误 UI 显示
    @Published var errorMessage: String?
}
```

## 总结

`@Published` 是 SwiftUI 和 Combine 生态系统中的核心组件，它提供了：

1. **简单的响应式编程模型**: 类似于前端框架的响应式数据
2. **自动通知机制**: 无需手动管理观察者模式
3. **类型安全**: 编译时检查，运行时安全
4. **高度可组合**: 与 Combine 操作符完美配合
5. **性能友好**: 智能的变更检测和通知

掌握 `@Published` 的使用是构建高质量 SwiftUI 应用的关键，它让数据流变得简单、可预测且易于调试。结合合适的架构模式（如 MVVM），可以构建出响应迅速、易于维护的应用程序。

## 相关资源

- [Swift 官方文档 - Published](https://developer.apple.com/documentation/combine/published)
- [Combine 框架指南](https://developer.apple.com/documentation/combine)
- [SwiftUI 数据流](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
- [WWDC 2019 - Introducing Combine](https://developer.apple.com/videos/play/wwdc2019/722/)
