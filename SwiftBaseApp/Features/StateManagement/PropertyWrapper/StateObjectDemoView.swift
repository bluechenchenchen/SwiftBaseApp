import SwiftUI
import Combine

struct StateObjectDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "用户信息管理") {
          StateObjectUserInfoExample()
        }
        
        ShowcaseItem(title: "计数器视图模型") {
          StateObjectCounterExample()
        }
        
        ShowcaseItem(title: "数据加载示例") {
          StateObjectDataLoadingExample()
        }
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "错误处理") {
          StateObjectErrorHandlingExample()
        }
        
        ShowcaseItem(title: "视图模型通信") {
          StateObjectCommunicationExample()
        }
        
        ShowcaseItem(title: "异步操作") {
          StateObjectAsyncExample()
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "内存管理") {
          StateObjectMemoryExample()
        }
        
        ShowcaseItem(title: "优化更新") {
          StateObjectOptimizedExample()
        }
      }
      
      // MARK: - 实际应用
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "待办事项管理") {
          StateObjectTodoExample()
        }
        
        ShowcaseItem(title: "用户设置") {
          StateObjectSettingsExample()
        }
      }
    }
    .navigationTitle("@StateObject 视图模型")
  }
}

// MARK: - 数据模型
struct User: Identifiable, Codable {
  let id = UUID()
  var name: String
  var age: Int
  var email: String
  
  init(name: String, age: Int, email: String = "") {
    self.name = name
    self.age = age
    self.email = email
  }
}

struct TodoItem: Identifiable, Codable {
  let id = UUID()
  var title: String
  var isCompleted: Bool
  var createdAt: Date
  
  init(title: String, isCompleted: Bool = false) {
    self.title = title
    self.isCompleted = isCompleted
    self.createdAt = Date()
  }
}

enum LoadingState: Equatable {
  case idle
  case loading
  case loaded
  case error(String)
}

// MARK: - 基础用法示例
struct StateObjectUserInfoExample: View {
  @StateObject private var viewModel = UserInfoViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      if let user = viewModel.user {
        VStack(spacing: 8) {
          Text("用户信息")
            .font(.headline)
          
          HStack {
            Text("姓名:")
              .foregroundStyle(.secondary)
            Spacer()
            Text(user.name)
          }
          
          HStack {
            Text("年龄:")
              .foregroundStyle(.secondary)
            Spacer()
            Text("\(user.age)")
          }
          
          if !user.email.isEmpty {
            HStack {
              Text("邮箱:")
                .foregroundStyle(.secondary)
              Spacer()
              Text(user.email)
            }
          }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
      } else {
        Text("暂无用户信息")
          .foregroundStyle(.secondary)
          .padding()
          .background(Color.gray.opacity(0.1))
          .cornerRadius(10)
      }
      
      HStack(spacing: 12) {
        Button("加载用户") {
          viewModel.loadUser()
        }
        .buttonStyle(.borderedProminent)
        
        Button("清除") {
          viewModel.clearUser()
        }
        .buttonStyle(.bordered)
        
        Button("更新年龄") {
          viewModel.updateAge()
        }
        .buttonStyle(.bordered)
        .disabled(viewModel.user == nil)
      }
      
      Text("展示了 @StateObject 管理用户信息的基本用法")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  
  }
}

class UserInfoViewModel: ObservableObject {
  @Published var user: User?
  
  func loadUser() {
    user = User(name: "张三", age: 25, email: "zhangsan@example.com")
  }
  
  func clearUser() {
    user = nil
  }
  
  func updateAge() {
    user?.age += 1
  }
}

struct StateObjectCounterExample: View {
  @StateObject private var viewModel = CounterViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("计数: \(viewModel.count)")
        .font(.title2)
        .fontWeight(.semibold)
      
      if !viewModel.history.isEmpty {
        Text("历史: \(viewModel.history.map { String($0) }.joined(separator: ", "))")
          .font(.caption)
          .foregroundStyle(.secondary)
          .padding(8)
          .background(Color.orange.opacity(0.1))
          .cornerRadius(8)
      }
      
      HStack(spacing: 12) {
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
      
      Text("展示了计数器视图模型和历史记录功能")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  
  }
}

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

struct StateObjectDataLoadingExample: View {
  @StateObject private var viewModel = DataLoadingViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      switch viewModel.loadingState {
      case .idle:
        Text("点击按钮开始加载数据")
          .foregroundStyle(.secondary)
      case .loading:
        HStack {
          ProgressView()
            .scaleEffect(0.8)
          Text("正在加载...")
        }
      case .loaded:
        VStack(spacing: 8) {
          Text("数据加载完成")
            .font(.headline)
            .foregroundColor(.green)
          
          ForEach(viewModel.data, id: \.self) { item in
            Text(item)
              .padding(8)
              .background(Color.green.opacity(0.1))
              .cornerRadius(6)
          }
        }
      case .error(let message):
        VStack {
          Text("加载失败")
            .font(.headline)
            .foregroundColor(.red)
          Text(message)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
      }
      
      HStack(spacing: 12) {
        Button("加载数据") {
          Task {
            await viewModel.loadData()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.loadingState == .loading)
        
        Button("清除") {
          viewModel.clearData()
        }
        .buttonStyle(.bordered)
      }
      
      Text("展示了异步数据加载和状态管理")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    
  }
}

class DataLoadingViewModel: ObservableObject {
  @Published var data: [String] = []
  @Published var loadingState: LoadingState = .idle
  
  @MainActor
  func loadData() async {
    loadingState = .loading
    
    do {
      // 模拟网络延迟
      try await Task.sleep(nanoseconds: 2_000_000_000)
      
      if Bool.random() {
        data = ["项目 1", "项目 2", "项目 3", "项目 4"]
        loadingState = .loaded
      } else {
        loadingState = .error("网络连接失败")
      }
    } catch {
      loadingState = .error(error.localizedDescription)
    }
  }
  
  func clearData() {
    data.removeAll()
    loadingState = .idle
  }
}

// MARK: - 高级特性示例
struct StateObjectErrorHandlingExample: View {
  @StateObject private var viewModel = ErrorHandlingViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      if let errorMessage = viewModel.errorMessage {
        VStack(spacing: 8) {
          Image(systemName: "exclamationmark.triangle")
            .foregroundColor(.red)
            .font(.title2)
          
          Text("错误信息")
            .font(.headline)
            .foregroundColor(.red)
          
          Text(errorMessage)
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
          
          Button("清除错误") {
            viewModel.clearError()
          }
          .buttonStyle(.bordered)
          .foregroundColor(.red)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
      } else {
        Text("当前没有错误")
          .foregroundColor(.green)
          .padding()
          .background(Color.green.opacity(0.1))
          .cornerRadius(10)
      }
      
      VStack(spacing: 8) {
        Button("模拟网络错误") {
          viewModel.simulateNetworkError()
        }
        .buttonStyle(.borderedProminent)
        
        Button("模拟验证错误") {
          viewModel.simulateValidationError()
        }
        .buttonStyle(.bordered)
        
        Button("模拟服务器错误") {
          viewModel.simulateServerError()
        }
        .buttonStyle(.bordered)
      }
      
      Text("展示了不同类型的错误处理机制")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    
  }
}

class ErrorHandlingViewModel: ObservableObject {
  @Published var errorMessage: String?
  
  func simulateNetworkError() {
    errorMessage = "网络连接超时，请检查网络设置"
  }
  
  func simulateValidationError() {
    errorMessage = "输入数据验证失败，请检查输入格式"
  }
  
  func simulateServerError() {
    errorMessage = "服务器内部错误，请稍后重试"
  }
  
  func clearError() {
    errorMessage = nil
  }
}

struct StateObjectCommunicationExample: View {
  @StateObject private var parentViewModel = ParentViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("父视图模型")
        .font(.headline)
      
      Text("子视图数量: \(parentViewModel.childViewModels.count)")
        .padding(8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
      
      if !parentViewModel.messages.isEmpty {
        VStack(alignment: .leading, spacing: 4) {
          Text("消息日志:")
            .font(.subheadline)
            .fontWeight(.medium)
          
          ForEach(parentViewModel.messages.suffix(3), id: \.self) { message in
            Text(message)
              .font(.caption)
              .padding(4)
              .background(Color.blue.opacity(0.1))
              .cornerRadius(4)
          }
        }
      }
      
      HStack(spacing: 12) {
        Button("添加子视图") {
          parentViewModel.addChild()
        }
        .buttonStyle(.borderedProminent)
        
        Button("清除所有") {
          parentViewModel.removeAllChildren()
        }
        .buttonStyle(.bordered)
        .foregroundColor(.red)
        .disabled(parentViewModel.childViewModels.isEmpty)
      }
      
      if !parentViewModel.childViewModels.isEmpty {
        VStack(spacing: 8) {
          Text("子视图模型列表:")
            .font(.subheadline)
            .fontWeight(.medium)
          
          ForEach(parentViewModel.childViewModels) { child in
            ChildViewModelRow(viewModel: child, parent: parentViewModel)
          }
        }
      }
      
      Text("展示了父子视图模型间的通信机制")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
   
  }
}

struct ChildViewModelRow: View {
  @ObservedObject var viewModel: ChildViewModel
  let parent: ParentViewModel
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("子视图 \(viewModel.index)")
          .font(.caption)
          .fontWeight(.medium)
        Text("数据: \(viewModel.data)")
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
      
      Button("更新") {
        viewModel.updateData()
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
      
      Button("删除") {
        parent.removeChild(viewModel)
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
      .foregroundColor(.red)
    }
    .padding(8)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
}

class ParentViewModel: ObservableObject {
  @Published var childViewModels: [ChildViewModel] = []
  @Published var messages: [String] = []
  private var childCounter = 0
  
  func addChild() {
    childCounter += 1
    let child = ChildViewModel(index: childCounter, parent: self)
    childViewModels.append(child)
    addMessage("添加了子视图 \(childCounter)")
  }
  
  func removeChild(_ child: ChildViewModel) {
    if let index = childViewModels.firstIndex(where: { $0.id == child.id }) {
      childViewModels.remove(at: index)
      addMessage("删除了子视图 \(child.index)")
    }
  }
  
  func removeAllChildren() {
    let count = childViewModels.count
    childViewModels.removeAll()
    addMessage("删除了所有 \(count) 个子视图")
  }
  
  func handleChildUpdate(_ child: ChildViewModel) {
    addMessage("子视图 \(child.index) 更新了数据: \(child.data)")
  }
  
  private func addMessage(_ message: String) {
    messages.append(message)
    if messages.count > 10 {
      messages.removeFirst()
    }
  }
}

class ChildViewModel: ObservableObject, Identifiable {
  let id = UUID()
  let index: Int
  weak var parent: ParentViewModel?
  @Published var data: String = ""
  
  init(index: Int, parent: ParentViewModel) {
    self.index = index
    self.parent = parent
    self.data = "初始数据"
  }
  
  func updateData() {
    data = "更新时间: \(Date().formatted(.dateTime.hour().minute().second()))"
    parent?.handleChildUpdate(self)
  }
}

struct StateObjectAsyncExample: View {
  @StateObject private var viewModel = AsyncOperationViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("异步操作演示")
        .font(.headline)
      
      if viewModel.isLoading {
        VStack {
          ProgressView()
          Text("执行异步操作中...")
            .font(.caption)
        }
      }
      
      if !viewModel.results.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          Text("操作结果:")
            .font(.subheadline)
            .fontWeight(.medium)
          
          ForEach(viewModel.results, id: \.self) { result in
            Text(result)
              .padding(8)
              .background(Color.green.opacity(0.1))
              .cornerRadius(6)
          }
        }
      }
      
      HStack(spacing: 12) {
        Button("开始异步任务") {
          Task {
            await viewModel.performAsyncOperation()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isLoading)
        
        Button("取消任务") {
          viewModel.cancelOperation()
        }
        .buttonStyle(.bordered)
        .disabled(!viewModel.isLoading)
        
        Button("清除结果") {
          viewModel.clearResults()
        }
        .buttonStyle(.bordered)
      }
      
      Text("展示了异步操作的管理和取消机制")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
   
  }
}

class AsyncOperationViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var results: [String] = []
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func performAsyncOperation() async {
    isLoading = true
    
    currentTask = Task {
      for i in 1...5 {
        if Task.isCancelled {
          await MainActor.run {
            self.results.append("任务在步骤 \(i) 被取消")
            self.isLoading = false
          }
          return
        }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
          self.results.append("完成步骤 \(i)")
        }
      }
      
      await MainActor.run {
        self.results.append("所有步骤完成")
        self.isLoading = false
      }
    }
    
    await currentTask?.value
  }
  
  func cancelOperation() {
    currentTask?.cancel()
    currentTask = nil
  }
  
  func clearResults() {
    results.removeAll()
  }
}

// MARK: - 性能优化示例
struct StateObjectMemoryExample: View {
  @StateObject private var viewModel = MemoryManagementViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("内存管理演示")
        .font(.headline)
      
      VStack(spacing: 8) {
        HStack {
          Text("对象数量:")
          Spacer()
          Text("\(viewModel.objectCount)")
            .fontWeight(.semibold)
        }
        
        HStack {
          Text("内存使用:")
          Spacer()
          Text("\(viewModel.memoryUsage) MB")
            .fontWeight(.semibold)
            .foregroundColor(viewModel.memoryUsage > 50 ? .red : .green)
        }
      }
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(10)
      
      HStack(spacing: 12) {
        Button("创建对象") {
          viewModel.createObjects()
        }
        .buttonStyle(.borderedProminent)
        
        Button("清理内存") {
          viewModel.cleanupMemory()
        }
        .buttonStyle(.bordered)
        .foregroundColor(.red)
      }
      
      if viewModel.showMemoryWarning {
        Text("⚠️ 内存使用过高，建议清理")
          .font(.caption)
          .foregroundColor(.red)
          .padding(8)
          .background(Color.red.opacity(0.1))
          .cornerRadius(8)
      }
      
      Text("展示了内存管理和监控的最佳实践")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  
  }
}

class MemoryManagementViewModel: ObservableObject {
  @Published var objectCount = 0
  @Published var memoryUsage = 0
  @Published var showMemoryWarning = false
  
  private var objects: [AnyObject] = []
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    // 监控内存使用
    Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.updateMemoryUsage()
      }
      .store(in: &cancellables)
  }
  
  func createObjects() {
    // 模拟创建大量对象
    for _ in 0..<1000 {
      objects.append(NSObject())
    }
    objectCount = objects.count
  }
  
  func cleanupMemory() {
    objects.removeAll()
    objectCount = 0
    showMemoryWarning = false
  }
  
  private func updateMemoryUsage() {
    // 模拟内存使用计算
    memoryUsage = objectCount / 10
    showMemoryWarning = memoryUsage > 50
  }
  
  deinit {
    cancellables.removeAll()
  }
}

struct StateObjectOptimizedExample: View {
  @StateObject private var viewModel = OptimizedUpdateViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("优化更新演示")
        .font(.headline)
      
      VStack(spacing: 8) {
        HStack {
          Text("内部计数:")
          Spacer()
          Text("\(viewModel.internalCounter)")
        }
        
        HStack {
          Text("显示计数:")
          Spacer()
          Text("\(viewModel.displayCounter)")
            .fontWeight(.semibold)
        }
        
        HStack {
          Text("更新次数:")
          Spacer()
          Text("\(viewModel.updateCount)")
            .foregroundStyle(.secondary)
        }
      }
      .padding()
      .background(Color.purple.opacity(0.1))
      .cornerRadius(10)
      
      HStack(spacing: 12) {
        Button("快速更新") {
          viewModel.fastUpdate()
        }
        .buttonStyle(.borderedProminent)
        
        Button("强制同步") {
          viewModel.forceSync()
        }
        .buttonStyle(.bordered)
        
        Button("重置") {
          viewModel.reset()
        }
        .buttonStyle(.bordered)
        .foregroundColor(.red)
      }
      
      Text("展示了减少不必要更新的优化策略")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  
  }
}

class OptimizedUpdateViewModel: ObservableObject {
  @Published var displayCounter = 0
  @Published var updateCount = 0
  
  private var _internalCounter = 0
  
  var internalCounter: Int {
    _internalCounter
  }
  
  func fastUpdate() {
    // 快速更新内部计数，但只在特定条件下更新显示
    _internalCounter += 1
    
    if _internalCounter % 5 == 0 {
      displayCounter = _internalCounter
      updateCount += 1
    }
  }
  
  func forceSync() {
    displayCounter = _internalCounter
    updateCount += 1
  }
  
  func reset() {
    _internalCounter = 0
    displayCounter = 0
    updateCount = 0
  }
}

// MARK: - 实际应用示例
struct StateObjectTodoExample: View {
  @StateObject private var viewModel = TodoListViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("待办事项管理")
        .font(.headline)
      
      HStack {
        TextField("新建待办事项", text: $viewModel.newTodoTitle)
          .textFieldStyle(.roundedBorder)
        
        Button("添加") {
          viewModel.addTodo()
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.newTodoTitle.isEmpty)
      }
      
      if !viewModel.todos.isEmpty {
        VStack(spacing: 8) {
          HStack {
            Text("待办事项 (\(viewModel.completedCount)/\(viewModel.todos.count))")
              .font(.subheadline)
              .fontWeight(.medium)
            Spacer()
            Button("清除已完成") {
              viewModel.clearCompleted()
            }
            .font(.caption)
            .buttonStyle(.bordered)
            .controlSize(.small)
            .disabled(viewModel.completedCount == 0)
          }
          
          ForEach(viewModel.todos) { todo in
            TodoItemRow(todo: todo, viewModel: viewModel)
          }
        }
      } else {
        Text("暂无待办事项")
          .foregroundStyle(.secondary)
          .padding()
          .background(Color.gray.opacity(0.1))
          .cornerRadius(10)
      }
      
      Text("展示了完整的待办事项管理应用")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
   
  }
}

struct TodoItemRow: View {
  let todo: TodoItem
  let viewModel: TodoListViewModel
  
  var body: some View {
    HStack {
      Button(action: {
        viewModel.toggleTodo(todo)
      }) {
        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
          .foregroundColor(todo.isCompleted ? .green : .gray)
      }
      
      VStack(alignment: .leading, spacing: 2) {
        Text(todo.title)
          .strikethrough(todo.isCompleted)
          .foregroundColor(todo.isCompleted ? .secondary : .primary)
        
        Text(todo.createdAt.formatted(.dateTime.hour().minute()))
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
      
      Button("删除") {
        viewModel.deleteTodo(todo)
      }
      .font(.caption)
      .buttonStyle(.bordered)
      .controlSize(.small)
      .foregroundColor(.red)
    }
    .padding(8)
    .background(Color.gray.opacity(0.05))
    .cornerRadius(8)
  }
}

class TodoListViewModel: ObservableObject {
  @Published var todos: [TodoItem] = []
  @Published var newTodoTitle = ""
  
  var completedCount: Int {
    todos.filter { $0.isCompleted }.count
  }
  
  func addTodo() {
    guard !newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    
    let todo = TodoItem(title: newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines))
    todos.append(todo)
    newTodoTitle = ""
  }
  
  func toggleTodo(_ todo: TodoItem) {
    if let index = todos.firstIndex(where: { $0.id == todo.id }) {
      todos[index].isCompleted.toggle()
    }
  }
  
  func deleteTodo(_ todo: TodoItem) {
    todos.removeAll { $0.id == todo.id }
  }
  
  func clearCompleted() {
    todos.removeAll { $0.isCompleted }
  }
}

struct StateObjectSettingsExample: View {
  @StateObject private var viewModel = SettingsViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("用户设置")
        .font(.headline)
      
      VStack(spacing: 12) {
        HStack {
          Text("深色模式")
          Spacer()
          Toggle("", isOn: $viewModel.isDarkMode)
        }
        
        HStack {
          Text("推送通知")
          Spacer()
          Toggle("", isOn: $viewModel.notificationsEnabled)
        }
        
        HStack {
          Text("字体大小")
          Spacer()
          Picker("字体大小", selection: $viewModel.fontSize) {
            Text("小").tag(FontSize.small)
            Text("中").tag(FontSize.medium)
            Text("大").tag(FontSize.large)
          }
          .pickerStyle(.segmented)
          .frame(width: 150)
        }
        
        HStack {
          Text("用户名")
          Spacer()
          TextField("输入用户名", text: $viewModel.username)
            .textFieldStyle(.roundedBorder)
            .frame(width: 150)
        }
      }
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(10)
      
      VStack(spacing: 8) {
        Text("设置预览")
          .font(.subheadline)
          .fontWeight(.medium)
        
        Text("当前主题: \(viewModel.isDarkMode ? "深色" : "浅色")")
        Text("通知状态: \(viewModel.notificationsEnabled ? "已开启" : "已关闭")")
        Text("字体大小: \(viewModel.fontSize.description)")
        if !viewModel.username.isEmpty {
          Text("用户名: \(viewModel.username)")
        }
      }
      .font(.caption)
      .foregroundStyle(.secondary)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)
      
      HStack(spacing: 12) {
        Button("保存设置") {
          viewModel.saveSettings()
        }
        .buttonStyle(.borderedProminent)
        
        Button("重置") {
          viewModel.resetSettings()
        }
        .buttonStyle(.bordered)
        .foregroundColor(.red)
      }
      
      if viewModel.showSaveConfirmation {
        Text("✅ 设置已保存")
          .font(.caption)
          .foregroundColor(.green)
          .padding(8)
          .background(Color.green.opacity(0.1))
          .cornerRadius(8)
      }
      
      Text("展示了用户设置管理和持久化")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
   
  }
}

enum FontSize: CaseIterable {
  case small, medium, large
  
  var description: String {
    switch self {
    case .small: return "小"
    case .medium: return "中"
    case .large: return "大"
    }
  }
}

class SettingsViewModel: ObservableObject {
  @Published var isDarkMode = false
  @Published var notificationsEnabled = true
  @Published var fontSize: FontSize = .medium
  @Published var username = ""
  @Published var showSaveConfirmation = false
  
  func saveSettings() {
    // 在实际应用中，这里会保存到 UserDefaults 或其他持久化存储
    showSaveConfirmation = true
    showSaveConfirmation = false
    
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //            self.showSaveConfirmation = false
    //        }
  }
  
  func resetSettings() {
    isDarkMode = false
    notificationsEnabled = true
    fontSize = .medium
    username = ""
    showSaveConfirmation = false
  }
}

#Preview {
  NavigationView {
    StateObjectDemoView()
  }
}
