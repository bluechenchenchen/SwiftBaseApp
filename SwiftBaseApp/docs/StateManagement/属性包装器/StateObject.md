# @StateObject 和视图模型管理

## 基本介绍

### 概念解释

`@StateObject` 是 SwiftUI 中用于管理符合 `ObservableObject` 协议的引用类型对象的属性包装器。它负责创建和管理视图模型的生命周期，确保对象在视图的生命周期内保持活跃状态。

### 使用场景

- 视图模型（ViewModel）的创建和管理
- 复杂业务逻辑的状态管理
- 网络请求和数据加载
- 长时间运行的任务管理
- 需要跨视图共享的状态对象

### 主要特性

- **生命周期管理**: 自动管理对象的创建和销毁
- **内存安全**: 避免内存泄漏和循环引用
- **响应式更新**: 当 @Published 属性变化时自动更新视图
- **线程安全**: 确保在主线程上更新 UI
- **性能优化**: 智能的对象生命周期管理

## 基础用法

### 基本示例

```swift
// 1. 定义视图模型
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadUser() {
        isLoading = true
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(name: "张三", age: 25)
            self.isLoading = false
        }
    }
}

// 2. 在视图中使用
struct UserView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("加载中...")
            } else if let user = viewModel.user {
                Text("用户: \(user.name)")
                Text("年龄: \(user.age)")
            } else {
                Text("暂无用户信息")
            }

            Button("加载用户") {
                viewModel.loadUser()
            }
        }
        .padding()
    }
}
```

### 常用属性和方法

#### 基本视图模型结构

```swift
class BasicViewModel: ObservableObject {
    // 发布属性 - 变化时自动更新视图
    @Published var data: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 计算属性
    var isDataValid: Bool {
        !data.isEmpty
    }

    // 方法
    func loadData() {
        isLoading = true
        // 异步操作
    }

    func clearData() {
        data = ""
        errorMessage = nil
    }
}
```

#### 状态更新

```swift
class CounterViewModel: ObservableObject {
    @Published var count = 0
    @Published var history: [Int] = []

    func increment() {
        count += 1
        history.append(count)
    }

    func decrement() {
        count -= 1
        history.append(count)
    }

    func reset() {
        count = 0
        history.removeAll()
    }
}
```

### 使用注意事项

1. **只在视图中创建**: @StateObject 只能在视图中创建，不能在方法中创建
2. **避免重复创建**: 不要在每次视图更新时重新创建 StateObject
3. **主线程更新**: 确保 @Published 属性在主线程上更新
4. **内存管理**: 避免在视图模型中持有强引用循环

## 高级特性

### 组合使用

```swift
// 多个视图模型组合
struct ComplexView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var dataViewModel = DataViewModel()

    var body: some View {
        TabView {
            UserProfileView()
                .environmentObject(userViewModel)

            SettingsView()
                .environmentObject(settingsViewModel)

            DataView()
                .environmentObject(dataViewModel)
        }
    }
}
```

### 视图模型通信

```swift
// 父子视图模型通信
class ParentViewModel: ObservableObject {
    @Published var childViewModels: [ChildViewModel] = []

    func addChild() {
        let child = ChildViewModel(parent: self)
        childViewModels.append(child)
    }

    func removeChild(_ child: ChildViewModel) {
        childViewModels.removeAll { $0.id == child.id }
    }
}

class ChildViewModel: ObservableObject {
    let id = UUID()
    weak var parent: ParentViewModel?
    @Published var data: String = ""

    init(parent: ParentViewModel) {
        self.parent = parent
    }

    func notifyParent() {
        parent?.handleChildUpdate(self)
    }
}
```

### 异步操作处理

```swift
class AsyncViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @MainActor
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            // 模拟异步网络请求
            try await Task.sleep(nanoseconds: 2_000_000_000)
            data = ["项目1", "项目2", "项目3"]
        } catch {
            errorMessage = "加载失败: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
```

## 性能优化

### 最佳实践

```swift
class OptimizedViewModel: ObservableObject {
    // 使用私有属性减少不必要的更新
    private var _internalData: String = ""

    @Published var displayData: String = ""

    var internalData: String {
        get { _internalData }
        set {
            _internalData = newValue
            // 只在需要时更新显示数据
            if shouldUpdateDisplay {
                displayData = newValue
            }
        }
    }

    private var shouldUpdateDisplay: Bool {
        // 添加更新条件
        return true
    }
}
```

### 内存管理

```swift
class MemorySafeViewModel: ObservableObject {
    @Published var data: [String] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        // 使用 weak self 避免循环引用
        $data
            .sink { [weak self] newData in
                self?.processData(newData)
            }
            .store(in: &cancellables)
    }

    private func processData(_ data: [String]) {
        // 处理数据
    }

    deinit {
        // 清理资源
        cancellables.removeAll()
    }
}
```

### 常见陷阱

```swift
// ❌ 错误示例：在方法中创建 StateObject
struct WrongView: View {
    var body: some View {
        VStack {
            // 这会导致每次视图更新时都创建新对象
            let viewModel = UserViewModel() // 错误！
            Text("错误示例")
        }
    }
}

// ✅ 正确示例：在属性中创建 StateObject
struct CorrectView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            Text("正确示例")
        }
    }
}
```

## 辅助功能

### 无障碍支持

```swift
class AccessibleViewModel: ObservableObject {
    @Published var accessibilityLabel: String = ""
    @Published var accessibilityHint: String = ""

    func updateAccessibility(for state: LoadingState) {
        switch state {
        case .loading:
            accessibilityLabel = "正在加载数据"
            accessibilityHint = "请稍等，数据正在加载中"
        case .loaded:
            accessibilityLabel = "数据加载完成"
            accessibilityHint = "数据已成功加载"
        case .error:
            accessibilityLabel = "加载失败"
            accessibilityHint = "点击重试按钮重新加载数据"
        }
    }
}
```

### 本地化支持

```swift
class LocalizedViewModel: ObservableObject {
    @Published var localizedTitle: String = ""
    @Published var localizedMessage: String = ""

    func updateLocalizedContent() {
        localizedTitle = NSLocalizedString("user_profile_title", comment: "用户资料标题")
        localizedMessage = NSLocalizedString("user_profile_message", comment: "用户资料消息")
    }
}
```

## 示例代码

### 基础示例

```swift
// 简单的计数器视图模型
class CounterViewModel: ObservableObject {
    @Published var count = 0

    func increment() {
        count += 1
    }

    func decrement() {
        count -= 1
    }

    func reset() {
        count = 0
    }
}

struct CounterView: View {
    @StateObject private var viewModel = CounterViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("计数: \(viewModel.count)")
                .font(.title)

            HStack(spacing: 15) {
                Button("增加") {
                    viewModel.increment()
                }
                .buttonStyle(.borderedProminent)

                Button("减少") {
                    viewModel.decrement()
                }
                .buttonStyle(.bordered)

                Button("重置") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
    }
}
```

### 进阶示例

```swift
// 用户管理视图模型
class UserManagementViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func loadUsers() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            // 模拟网络请求
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let newUsers = [
                User(name: "张三", age: 25),
                User(name: "李四", age: 30),
                User(name: "王五", age: 28)
            ]

            await MainActor.run {
                self.users = newUsers
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "加载失败: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    func addUser(_ user: User) {
        users.append(user)
    }

    func removeUser(_ user: User) {
        users.removeAll { $0.id == user.id }
    }
}
```

### 完整 Demo

```swift
struct UserManagementView: View {
    @StateObject private var viewModel = UserManagementViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // 搜索栏
                SearchBar(text: $viewModel.searchText)
                    .padding()

                if viewModel.isLoading {
                    ProgressView("加载中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("错误")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                        Button("重试") {
                            Task {
                                await viewModel.loadUsers()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.filteredUsers) { user in
                        UserRow(user: user) {
                            viewModel.removeUser(user)
                        }
                    }
                }
            }
            .navigationTitle("用户管理")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("刷新") {
                        Task {
                            await viewModel.loadUsers()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}
```

## 注意事项

### 常见问题

1. **StateObject 创建时机**: 只能在视图的初始化时创建，不能在方法中创建
2. **内存泄漏**: 避免在视图模型中持有强引用循环
3. **线程安全**: 确保 @Published 属性在主线程上更新
4. **性能问题**: 避免在视图模型中执行耗时的同步操作

### 兼容性考虑

- iOS 14.0+ 支持 @StateObject
- 需要导入 SwiftUI 和 Combine 框架
- 确保 ObservableObject 协议的正确实现

### 使用建议

1. **合理使用**: 只在需要复杂状态管理时使用 @StateObject
2. **生命周期管理**: 注意对象的生命周期，避免内存泄漏
3. **性能优化**: 使用适当的更新策略，避免不必要的视图更新
4. **测试友好**: 设计可测试的视图模型，便于单元测试

## 完整运行 Demo

### 源代码

完整的 @StateObject 演示代码包含在 `StateObjectDemoView.swift` 文件中，展示了各种使用场景和最佳实践。

### 运行说明

1. 在 Xcode 中打开项目
2. 导航到状态管理模块
3. 选择 "@StateObject 视图模型" 选项
4. 查看各种示例和演示

### 功能说明

演示包含以下功能：

- 基础的用户信息管理
- 数据加载和错误处理
- 视图模型间的通信
- 性能优化和内存管理
- 实际应用场景展示

每个示例都包含详细的注释和说明，帮助理解 @StateObject 的使用方法和最佳实践。
