import SwiftUI
import Combine

struct ObservedObjectDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "外部对象观察") {
          ObservedObjectBasicExample()
        }
        
        ShowcaseItem(title: "购物车管理") {
          ObservedObjectShoppingCartExample()
        }
        
        ShowcaseItem(title: "消息系统") {
          ObservedObjectMessageExample()
        }
      }
      
      // MARK: - 数据更新响应
      ShowcaseSection("数据更新响应") {
        ShowcaseItem(title: "实时计数器") {
          ObservedObjectCounterExample()
        }
        
        ShowcaseItem(title: "用户状态监听") {
          ObservedObjectUserStateExample()
        }
        
        ShowcaseItem(title: "数据同步") {
          ObservedObjectSyncExample()
        }
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "多数据源组合") {
          ObservedObjectMultiSourceExample()
        }
        
        ShowcaseItem(title: "条件观察") {
          ObservedObjectConditionalExample()
        }
        
        ShowcaseItem(title: "动画响应") {
          ObservedObjectAnimationExample()
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "计算属性优化") {
          ObservedObjectComputedPropertyExample()
        }
        
        ShowcaseItem(title: "批量更新") {
          ObservedObjectBatchUpdateExample()
        }
        
        ShowcaseItem(title: "防抖搜索") {
          ObservedObjectThrottledSearchExample()
        }
      }
      
      // MARK: - 实际应用
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "待办事项应用") {
          ObservedObjectTodoAppExample()
        }
        
        ShowcaseItem(title: "网络数据管理") {
          ObservedObjectNetworkExample()
        }
        
        ShowcaseItem(title: "设置管理") {
          ObservedObjectSettingsExample()
        }
      }
    }
    .navigationTitle("@ObservedObject 观察对象")
  }
}

// MARK: - 数据模型

struct ObservedObjectProduct: Identifiable {
  let id = UUID()
  var name: String
  var price: Double
  var stock: Int
}

struct ObservedObjectCartItem: Identifiable {
  let id = UUID()
  var product: ObservedObjectProduct
  var quantity: Int
}

struct ObservedObjectMessage: Identifiable {
  let id = UUID()
  var content: String
  var timestamp: Date
  var sender: String
}

struct ObservedObjectUser: Identifiable {
  let id = UUID()
  var name: String
  var email: String
  var isOnline: Bool
}

struct ObservedObjectTodoItem: Identifiable {
  let id = UUID()
  var title: String
  var isCompleted: Bool
  var createdAt: Date
}

enum ObservedObjectTodoFilter: String, CaseIterable {
  case all = "全部"
  case active = "进行中"
  case completed = "已完成"
}

// MARK: - 可观察对象

@MainActor
class ObservedObjectSharedCounter: ObservableObject {
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
    history.removeAll()
    addToHistory("重置计数器")
  }
  
  private func addToHistory(_ action: String) {
    let timestamp = ObservedObjectDateFormatter.timeOnly.string(from: Date())
    history.append("[\(timestamp)] \(action)")
    if history.count > 10 {
      history.removeFirst()
    }
  }
}

@MainActor
class ObservedObjectShoppingCartManager: ObservableObject {
  @Published var items: [ObservedObjectCartItem] = []
  @Published var discount: Double = 0.0
  
  var subtotal: Double {
    items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
  }
  
  var total: Double {
    subtotal * (1 - discount)
  }
  
  var itemCount: Int {
    items.reduce(0) { $0 + $1.quantity }
  }
  
  func addItem(_ product: ObservedObjectProduct) {
    if let index = items.firstIndex(where: { $0.product.id == product.id }) {
      items[index].quantity += 1
    } else {
      items.append(ObservedObjectCartItem(product: product, quantity: 1))
    }
  }
  
  func removeItem(at index: Int) {
    items.remove(at: index)
  }
  
  func updateQuantity(for item: ObservedObjectCartItem, quantity: Int) {
    guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
    if quantity <= 0 {
      items.remove(at: index)
    } else {
      items[index].quantity = quantity
    }
  }
  
  func applyDiscount(_ percentage: Double) {
    discount = max(0, min(percentage, 1.0))
  }
  
  func clearCart() {
    items.removeAll()
    discount = 0.0
  }
}

@MainActor
class ObservedObjectMessageManager: ObservableObject {
  @Published var messages: [ObservedObjectMessage] = []
  @Published var unreadCount = 0
  
  func addMessage(_ content: String, sender: String = "用户") {
    let message = ObservedObjectMessage(content: content, timestamp: Date(), sender: sender)
    messages.append(message)
    if sender != "我" {
      unreadCount += 1
    }
  }
  
  func markAllAsRead() {
    unreadCount = 0
  }
  
  func clearMessages() {
    messages.removeAll()
    unreadCount = 0
  }
}

@MainActor
class ObservedObjectUserStateManager: ObservableObject {
  @Published var currentUser: ObservedObjectUser?
  @Published var isLoggedIn = false
  @Published var lastActiveTime: Date?
  
  func login(name: String, email: String) {
    currentUser = ObservedObjectUser(name: name, email: email, isOnline: true)
    isLoggedIn = true
    lastActiveTime = Date()
  }
  
  func logout() {
    currentUser = nil
    isLoggedIn = false
    lastActiveTime = nil
  }
  
  func updateActivity() {
    lastActiveTime = Date()
  }
  
  func toggleOnlineStatus() {
    currentUser?.isOnline.toggle()
  }
}

@MainActor
class ObservedObjectDataSyncManager: ObservableObject {
  @Published var localData: [String] = []
  @Published var remoteData: [String] = []
  @Published var syncStatus: ObservedObjectSyncStatus = .idle
  
  enum ObservedObjectSyncStatus {
    case idle, syncing, success, failed
  }
  
  func addLocalData(_ item: String) {
    localData.append(item)
  }
  
  func syncToRemote() {
    syncStatus = .syncing
    
    Task {
      try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
      self.remoteData = self.localData
      self.syncStatus = .success
      
      try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
      self.syncStatus = .idle
    }
  }
}

@MainActor
class ObservedObjectOptimizedDataManager: ObservableObject {
  @Published private var rawData: [String] = []
  @Published var filter: String = ""
  @Published var isLoading = false
  
  var filteredData: [String] {
    if filter.isEmpty {
      return rawData
    }
    return rawData.filter { $0.localizedCaseInsensitiveContains(filter) }
  }
  
  var rawDataCount: Int {
    rawData.count
  }
  
  func loadData() {
    isLoading = true
    Task {
      try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
      self.rawData = (1...100).map { "数据项 \($0)" }
      self.isLoading = false
    }
  }
  
  func updateFilter(_ newFilter: String) {
    filter = newFilter
  }
}

@MainActor
class ObservedObjectBatchUpdateManager: ObservableObject {
  @Published var items: [String] = []
  @Published var updateCount = 0
  
  func addSingleItem() {
    items.append("单个项目 \(items.count + 1)")
    updateCount += 1
  }
  
  func addBatchItems() {
    let newItems = (1...10).map { "批量项目 \(items.count + $0)" }
    items.append(contentsOf: newItems)
    updateCount += 1 // 只触发一次更新
  }
  
  func clearItems() {
    items.removeAll()
    updateCount += 1
  }
}

@MainActor
class ObservedObjectThrottledSearchManager: ObservableObject {
  @Published var searchQuery: String = ""
  @Published var searchResults: [String] = []
  @Published var isSearching = false
  
  private var searchTask: Task<Void, Never>?
  private let allData = (1...1000).map { "搜索结果 \($0)" }
  
  func updateSearchQuery(_ query: String) {
    searchQuery = query
    performThrottledSearch()
  }
  
  private func performThrottledSearch() {
    searchTask?.cancel()
    
    if searchQuery.isEmpty {
      searchResults = []
      isSearching = false
      return
    }
    
    isSearching = true
    searchTask = Task {
      try? await Task.sleep(nanoseconds: 300_000_000) // 300ms 延迟
      
      if !Task.isCancelled {
        self.searchResults = self.allData.filter {
          $0.localizedCaseInsensitiveContains(self.searchQuery)
        }.prefix(20).map { $0 }
        self.isSearching = false
      }
    }
  }
}

@MainActor
class ObservedObjectTodoManager: ObservableObject {
  @Published var todos: [ObservedObjectTodoItem] = []
  @Published var filter: ObservedObjectTodoFilter = .all
  
  var filteredTodos: [ObservedObjectTodoItem] {
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
  
  var completedCount: Int {
    todos.filter { $0.isCompleted }.count
  }
  
  func addTodo(_ title: String) {
    let todo = ObservedObjectTodoItem(title: title, isCompleted: false, createdAt: Date())
    todos.append(todo)
  }
  
  func toggleTodo(_ todo: ObservedObjectTodoItem) {
    if let index = todos.firstIndex(where: { $0.id == todo.id }) {
      todos[index].isCompleted.toggle()
    }
  }
  
  func deleteTodo(_ todo: ObservedObjectTodoItem) {
    todos.removeAll { $0.id == todo.id }
  }
  
  func clearCompleted() {
    todos.removeAll { $0.isCompleted }
  }
}

@MainActor
class ObservedObjectNetworkDataManager: ObservableObject {
  @Published var data: [String] = []
  @Published var isLoading = false
  @Published var error: String?
  
  func fetchData() {
    isLoading = true
    error = nil
    
    Task {
      let delay = UInt64(Double.random(in: 1...3) * 1_000_000_000) // 1-3 seconds
      try? await Task.sleep(nanoseconds: delay)
      
      if Bool.random() {
        // 模拟成功
        self.data = (1...20).map { "网络数据 \($0)" }
        self.error = nil
      } else {
        // 模拟失败
        self.error = "网络请求失败"
      }
      self.isLoading = false
    }
  }
  
  func refreshData() {
    fetchData()
  }
}

@MainActor
class ObservedObjectAppSettingsManager: ObservableObject {
  @Published var isDarkMode = false
  @Published var notificationsEnabled = true
  @Published var fontSize: Double = 16
  @Published var language = "中文"
  
  let availableLanguages = ["中文", "English", "日本語"]
  
  func toggleDarkMode() {
    isDarkMode.toggle()
  }
  
  func toggleNotifications() {
    notificationsEnabled.toggle()
  }
  
  func updateFontSize(_ size: Double) {
    fontSize = max(12, min(24, size))
  }
  
  func setLanguage(_ lang: String) {
    if availableLanguages.contains(lang) {
      language = lang
    }
  }
  
  func resetToDefaults() {
    isDarkMode = false
    notificationsEnabled = true
    fontSize = 16
    language = "中文"
  }
}

@MainActor
class ObservedObjectAnimationController: ObservableObject {
  @Published var scale: CGFloat = 1.0
  @Published var rotation: Double = 0.0
  @Published var color: Color = .blue
  @Published var isAnimating = false
  
  private let colors: [Color] = [.blue, .red, .green, .orange, .purple]
  
  func startAnimation() {
    isAnimating = true
    
    withAnimation(.easeInOut(duration: 1.0).repeatCount(3, autoreverses: true)) {
      scale = 1.5
      rotation += 360
      color = colors.randomElement() ?? .blue
    }
    
    Task {
      try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
      self.stopAnimation()
    }
  }
  
  func stopAnimation() {
    withAnimation(.easeInOut(duration: 0.5)) {
      scale = 1.0
      rotation = 0.0
      color = .blue
      isAnimating = false
    }
  }
}

// MARK: - 示例视图

struct ObservedObjectBasicExample: View {
  @StateObject private var counter = ObservedObjectSharedCounter()
  
  var body: some View {
    VStack(spacing: 20) {
      Text("外部对象观察示例")
        .font(.headline)
      
      CounterDisplayView(counter: counter)
      CounterControlView(counter: counter)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct CounterDisplayView: View {
  @ObservedObject var counter: ObservedObjectSharedCounter
  
  var body: some View {
    VStack {
      Text("当前计数: \(counter.count)")
        .font(.title)
        .bold()
      
      VStack(alignment: .leading, spacing: 4) {
        Text("操作历史:")
          .font(.caption)
          .foregroundColor(.secondary)
        
        ForEach(counter.history.suffix(3), id: \.self) { record in
          Text(record)
            .font(.caption2)
            .foregroundColor(.secondary)
        }
      }
    }
  }
}

struct CounterControlView: View {
  @ObservedObject var counter: ObservedObjectSharedCounter
  
  var body: some View {
    HStack(spacing: 12) {
      Button("减少") {
        counter.decrement()
      }
      .buttonStyle(.bordered)
      
      Button("增加") {
        counter.increment()
      }
      .buttonStyle(.borderedProminent)
      
      Button("重置") {
        counter.reset()
      }
      .buttonStyle(.bordered)
    }
  }
}

struct ObservedObjectShoppingCartExample: View {
  @StateObject private var cartManager = ObservedObjectShoppingCartManager()
  
  private let sampleProducts = [
    ObservedObjectProduct(name: "iPhone", price: 5999, stock: 10),
    ObservedObjectProduct(name: "iPad", price: 3299, stock: 5),
    ObservedObjectProduct(name: "MacBook", price: 9999, stock: 3)
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("购物车管理")
        .font(.headline)
      
      // 产品列表
      VStack(alignment: .leading, spacing: 8) {
        Text("产品列表:")
          .font(.subheadline)
          .bold()
        
        ForEach(sampleProducts) { product in
          HStack {
            VStack(alignment: .leading) {
              Text(product.name)
                .font(.body)
              Text("¥\(product.price, specifier: "%.0f")")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("添加") {
              cartManager.addItem(product)
            }
            .buttonStyle(.bordered)
          }
        }
      }
      
      Divider()
      
      // 购物车显示
      CartSummaryView(cartManager: cartManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct CartSummaryView: View {
  @ObservedObject var cartManager: ObservedObjectShoppingCartManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("购物车 (\(cartManager.itemCount) 件)")
          .font(.subheadline)
          .bold()
        
        Spacer()
        
        if !cartManager.items.isEmpty {
          Button("清空") {
            cartManager.clearCart()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
        }
      }
      
      if cartManager.items.isEmpty {
        Text("购物车为空")
          .foregroundColor(.secondary)
          .italic()
      } else {
        ForEach(Array(cartManager.items.enumerated()), id: \.element.id) { index, item in
          HStack {
            Text("\(item.product.name) × \(item.quantity)")
              .font(.caption)
            
            Spacer()
            
            Text("¥\(item.product.price * Double(item.quantity), specifier: "%.0f")")
              .font(.caption)
              .bold()
            
            Button("删除") {
              cartManager.removeItem(at: index)
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
          }
        }
        
        Divider()
        
        HStack {
          Text("总计:")
            .font(.subheadline)
            .bold()
          
          Spacer()
          
          Text("¥\(cartManager.total, specifier: "%.2f")")
            .font(.subheadline)
            .bold()
            .foregroundColor(.primary)
        }
      }
    }
  }
}

struct ObservedObjectMessageExample: View {
  @StateObject private var messageManager = ObservedObjectMessageManager()
  @State private var newMessage = ""
  
  var body: some View {
    VStack(spacing: 16) {
      Text("消息系统")
        .font(.headline)
      
      MessageListView(messageManager: messageManager)
      
      HStack {
        TextField("输入消息", text: $newMessage)
          .textFieldStyle(.roundedBorder)
        
        Button("发送") {
          if !newMessage.isEmpty {
            messageManager.addMessage(newMessage, sender: "我")
            newMessage = ""
            
            // 模拟回复
            Task {
              try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
              messageManager.addMessage("收到你的消息!", sender: "系统")
            }
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(newMessage.isEmpty)
      }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct MessageListView: View {
  @ObservedObject var messageManager: ObservedObjectMessageManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("消息列表 (\(messageManager.messages.count))")
          .font(.subheadline)
          .bold()
        
        if messageManager.unreadCount > 0 {
          Text("\(messageManager.unreadCount) 未读")
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        
        Spacer()
        
        Button("标记已读") {
          messageManager.markAllAsRead()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        .disabled(messageManager.unreadCount == 0)
      }
      
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 4) {
          ForEach(messageManager.messages) { message in
            HStack {
              Text("[\(ObservedObjectDateFormatter.timeOnly.string(from: message.timestamp))] \(message.sender):")
                .font(.caption2)
                .foregroundColor(.secondary)
              
              Text(message.content)
                .font(.caption)
            }
          }
        }
      }
      .frame(height: 100)
      .background(Color.white)
      .cornerRadius(8)
    }
  }
}

struct ObservedObjectCounterExample: View {
  @StateObject private var sharedCounter = ObservedObjectSharedCounter()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("实时计数器")
        .font(.headline)
      
      HStack(spacing: 20) {
        CounterView1(counter: sharedCounter)
        CounterView2(counter: sharedCounter)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
  }
}

struct CounterView1: View {
  @ObservedObject var counter: ObservedObjectSharedCounter
  
  var body: some View {
    VStack {
      Text("视图 1")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text("\(counter.count)")
        .font(.title)
        .bold()
        .foregroundColor(.blue)
      
      Button("+1") {
        counter.increment()
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(8)
  }
}

struct CounterView2: View {
  @ObservedObject var counter: ObservedObjectSharedCounter
  
  var body: some View {
    VStack {
      Text("视图 2")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text("\(counter.count)")
        .font(.title)
        .bold()
        .foregroundColor(.red)
      
      Button("-1") {
        counter.decrement()
      }
      .buttonStyle(.bordered)
    }
    .padding()
    .background(Color.red.opacity(0.1))
    .cornerRadius(8)
  }
}

struct ObservedObjectUserStateExample: View {
  @StateObject private var userManager = ObservedObjectUserStateManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("用户状态监听")
        .font(.headline)
      
      UserStatusView(userManager: userManager)
      UserControlView(userManager: userManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct UserStatusView: View {
  @ObservedObject var userManager: ObservedObjectUserStateManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Circle()
          .fill(userManager.isLoggedIn ? .green : .gray)
          .frame(width: 12, height: 12)
        
        Text(userManager.isLoggedIn ? "已登录" : "未登录")
          .font(.subheadline)
          .bold()
      }
      
      if let user = userManager.currentUser {
        Text("用户: \(user.name)")
          .font(.body)
        
        Text("邮箱: \(user.email)")
          .font(.caption)
          .foregroundColor(.secondary)
        
        HStack {
          Text("状态:")
            .font(.caption)
          
          Text(user.isOnline ? "在线" : "离线")
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(user.isOnline ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(4)
        }
        
        if let lastActive = userManager.lastActiveTime {
          Text("最后活跃: \(ObservedObjectDateFormatter.timeOnly.string(from: lastActive))")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct UserControlView: View {
  @ObservedObject var userManager: ObservedObjectUserStateManager
  
  var body: some View {
    VStack(spacing: 8) {
      if userManager.isLoggedIn {
        HStack {
          Button("切换状态") {
            userManager.toggleOnlineStatus()
          }
          .buttonStyle(.bordered)
          
          Button("更新活跃时间") {
            userManager.updateActivity()
          }
          .buttonStyle(.bordered)
          
          Button("退出登录") {
            userManager.logout()
          }
          .buttonStyle(.bordered)
        }
      } else {
        Button("登录") {
          userManager.login(name: "张三", email: "zhangsan@example.com")
        }
        .buttonStyle(.borderedProminent)
      }
    }
  }
}

struct ObservedObjectSyncExample: View {
  @StateObject private var syncManager = ObservedObjectDataSyncManager()
  @State private var newItem = ""
  
  var body: some View {
    VStack(spacing: 16) {
      Text("数据同步")
        .font(.headline)
      
      HStack {
        TextField("新项目", text: $newItem)
          .textFieldStyle(.roundedBorder)
        
        Button("添加") {
          if !newItem.isEmpty {
            syncManager.addLocalData(newItem)
            newItem = ""
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(newItem.isEmpty)
      }
      
      DataObservedObjectSyncStatusView(syncManager: syncManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct DataObservedObjectSyncStatusView: View {
  @ObservedObject var syncManager: ObservedObjectDataSyncManager
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        VStack(alignment: .leading) {
          Text("本地数据 (\(syncManager.localData.count))")
            .font(.caption)
            .bold()
          
          ForEach(syncManager.localData.suffix(3), id: \.self) { item in
            Text("• \(item)")
              .font(.caption2)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
        
        VStack(alignment: .leading) {
          Text("远程数据 (\(syncManager.remoteData.count))")
            .font(.caption)
            .bold()
          
          ForEach(syncManager.remoteData.suffix(3), id: \.self) { item in
            Text("• \(item)")
              .font(.caption2)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
      }
      
      HStack {
        statusIndicator
        
        Spacer()
        
        Button("同步到远程") {
          syncManager.syncToRemote()
        }
        .buttonStyle(.borderedProminent)
        .disabled(syncManager.syncStatus == .syncing || syncManager.localData.isEmpty)
      }
    }
  }
  
  @ViewBuilder
  private var statusIndicator: some View {
    HStack(spacing: 4) {
      Circle()
        .fill(statusColor)
        .frame(width: 8, height: 8)
      
      Text(statusText)
        .font(.caption)
        .foregroundColor(statusColor)
    }
  }
  
  private var statusColor: Color {
    switch syncManager.syncStatus {
    case .idle: return .gray
    case .syncing: return .blue
    case .success: return .green
    case .failed: return .red
    }
  }
  
  private var statusText: String {
    switch syncManager.syncStatus {
    case .idle: return "空闲"
    case .syncing: return "同步中..."
    case .success: return "同步成功"
    case .failed: return "同步失败"
    }
  }
}

struct ObservedObjectMultiSourceExample: View {
  @StateObject private var userManager = ObservedObjectUserStateManager()
  @StateObject private var messageManager = ObservedObjectMessageManager()
  @StateObject private var settingsManager = ObservedObjectAppSettingsManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("多数据源组合")
        .font(.headline)
      
      HStack(spacing: 12) {
        MultiSourceView1(
          userManager: userManager,
          messageManager: messageManager
        )
        
        MultiSourceView2(
          userManager: userManager,
          settingsManager: settingsManager
        )
      }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
    .onAppear {
      userManager.login(name: "演示用户", email: "demo@example.com")
      messageManager.addMessage("欢迎使用系统!", sender: "系统")
    }
  }
}

struct MultiSourceView1: View {
  @ObservedObject var userManager: ObservedObjectUserStateManager
  @ObservedObject var messageManager: ObservedObjectMessageManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("视图 1")
        .font(.caption)
        .bold()
      
      if let user = userManager.currentUser {
        Text(user.name)
          .font(.body)
          .bold()
      }
      
      Text("消息: \(messageManager.messages.count)")
        .font(.caption)
      
      if messageManager.unreadCount > 0 {
        Text("\(messageManager.unreadCount) 未读")
          .font(.caption2)
          .padding(.horizontal, 4)
          .background(Color.red)
          .foregroundColor(.white)
          .cornerRadius(4)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(8)
  }
}

struct MultiSourceView2: View {
  @ObservedObject var userManager: ObservedObjectUserStateManager
  @ObservedObject var settingsManager: ObservedObjectAppSettingsManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("视图 2")
        .font(.caption)
        .bold()
      
      Text("主题: \(settingsManager.isDarkMode ? "深色" : "浅色")")
        .font(.caption)
      
      Text("语言: \(settingsManager.language)")
        .font(.caption)
      
      if userManager.isLoggedIn {
        Button("切换主题") {
          settingsManager.toggleDarkMode()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color.green.opacity(0.1))
    .cornerRadius(8)
  }
}

struct ObservedObjectConditionalExample: View {
  @StateObject private var dataManager = ObservedObjectOptimizedDataManager()
  @State private var useAdvancedMode = false
  
  var body: some View {
    VStack(spacing: 16) {
      Text("条件观察")
        .font(.headline)
      
      Toggle("高级模式", isOn: $useAdvancedMode)
        .toggleStyle(.switch)
      
      if useAdvancedMode {
        AdvancedDataView(dataManager: dataManager)
      } else {
        SimpleDataView(dataManager: dataManager)
      }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
    .onAppear {
      dataManager.loadData()
    }
  }
}

struct SimpleDataView: View {
  @ObservedObject var dataManager: ObservedObjectOptimizedDataManager
  
  var body: some View {
    VStack {
      Text("简单模式")
        .font(.subheadline)
        .bold()
      
      if dataManager.isLoading {
        ProgressView("加载中...")
      } else {
        Text("数据项: \(dataManager.filteredData.count)")
          .font(.title2)
          .bold()
      }
    }
    .frame(height: 100)
    .frame(maxWidth: .infinity)
    .background(Color.blue.opacity(0.1))
    .cornerRadius(8)
  }
}

struct AdvancedDataView: View {
  @ObservedObject var dataManager: ObservedObjectOptimizedDataManager
  
  var body: some View {
    VStack(spacing: 8) {
      Text("高级模式")
        .font(.subheadline)
        .bold()
      
      TextField("搜索", text: Binding(
        get: { dataManager.filter },
        set: { dataManager.updateFilter($0) }
      ))
      .textFieldStyle(.roundedBorder)
      
      if dataManager.isLoading {
        ProgressView("加载中...")
      } else {
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(Array(dataManager.filteredData.prefix(5)), id: \.self) { item in
              Text(item)
                .font(.caption)
            }
            
            if dataManager.filteredData.count > 5 {
              Text("... 还有 \(dataManager.filteredData.count - 5) 项")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
          }
        }
        .frame(height: 80)
      }
    }
    .padding(8)
    .background(Color.green.opacity(0.1))
    .cornerRadius(8)
  }
}

struct ObservedObjectAnimationExample: View {
  @StateObject private var animationController = ObservedObjectAnimationController()
  
  var body: some View {
    VStack(spacing: 20) {
      Text("动画响应")
        .font(.headline)
      
      AnimatedShapeView(controller: animationController)
      
      Button(animationController.isAnimating ? "停止动画" : "开始动画") {
        if animationController.isAnimating {
          animationController.stopAnimation()
        } else {
          animationController.startAnimation()
        }
      }
      .buttonStyle(.borderedProminent)
    }
    .padding().frame(maxWidth:.infinity)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct AnimatedShapeView: View {
  @ObservedObject var controller: ObservedObjectAnimationController
  
  var body: some View {
    Rectangle()
      .fill(controller.color)
      .frame(width: 60, height: 60)
      .scaleEffect(controller.scale)
      .rotationEffect(.degrees(controller.rotation))
      .animation(.easeInOut(duration: 0.5), value: controller.scale)
      .animation(.linear(duration: 1.0), value: controller.rotation)
      .animation(.easeInOut(duration: 0.3), value: controller.color)
  }
}

struct ObservedObjectComputedPropertyExample: View {
  @StateObject private var dataManager = ObservedObjectOptimizedDataManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("计算属性优化")
        .font(.headline)
      
      TextField("搜索过滤", text: Binding(
        get: { dataManager.filter },
        set: { dataManager.updateFilter($0) }
      ))
      .textFieldStyle(.roundedBorder)
      
      ComputedPropertyDisplayView(dataManager: dataManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
    .onAppear {
      dataManager.loadData()
    }
  }
}

struct ComputedPropertyDisplayView: View {
  @ObservedObject var dataManager: ObservedObjectOptimizedDataManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("总数据: \(dataManager.rawDataCount)")
          .font(.caption)
        
        Spacer()
        
        Text("过滤结果: \(dataManager.filteredData.count)")
          .font(.caption)
          .bold()
      }
      
      if dataManager.isLoading {
        ProgressView("加载中...")
          .frame(height: 60)
      } else {
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(Array(dataManager.filteredData.prefix(8)), id: \.self) { item in
              Text(item)
                .font(.caption2)
            }
          }
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(6)
      }
    }
  }
}

struct ObservedObjectBatchUpdateExample: View {
  @StateObject private var batchManager = ObservedObjectBatchUpdateManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("批量更新")
        .font(.headline)
      
      HStack {
        Button("单个添加") {
          batchManager.addSingleItem()
        }
        .buttonStyle(.bordered)
        
        Button("批量添加") {
          batchManager.addBatchItems()
        }
        .buttonStyle(.borderedProminent)
        
        Button("清空") {
          batchManager.clearItems()
        }
        .buttonStyle(.bordered)
      }
      
      BatchUpdateDisplayView(batchManager: batchManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct BatchUpdateDisplayView: View {
  @ObservedObject var batchManager: ObservedObjectBatchUpdateManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("项目数: \(batchManager.items.count)")
          .font(.caption)
          .bold()
        
        Spacer()
        
        Text("更新次数: \(batchManager.updateCount)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(Array(batchManager.items.suffix(10)), id: \.self) { item in
            Text(item)
              .font(.caption2)
          }
          
          if batchManager.items.count > 10 {
            Text("... 还有 \(batchManager.items.count - 10) 项")
              .font(.caption2)
              .foregroundColor(.secondary)
              .italic()
          }
        }
      }
      .frame(height: 80)
      .background(Color.white)
      .cornerRadius(6)
    }
  }
}

struct ObservedObjectThrottledSearchExample: View {
  @StateObject private var searchManager = ObservedObjectThrottledSearchManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("防抖搜索")
        .font(.headline)
      
      TextField("搜索内容", text: Binding(
        get: { searchManager.searchQuery },
        set: { searchManager.updateSearchQuery($0) }
      ))
      .textFieldStyle(.roundedBorder)
      
      ThrottledSearchResultView(searchManager: searchManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct ThrottledSearchResultView: View {
  @ObservedObject var searchManager: ObservedObjectThrottledSearchManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        if searchManager.isSearching {
          ProgressView()
            .controlSize(.small)
          Text("搜索中...")
            .font(.caption)
        } else {
          Text("结果: \(searchManager.searchResults.count)")
            .font(.caption)
            .bold()
        }
        
        Spacer()
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(Array(searchManager.searchResults.prefix(8)), id: \.self) { result in
            Text(result)
              .font(.caption2)
          }
          
          if searchManager.searchResults.count > 8 {
            Text("... 还有 \(searchManager.searchResults.count - 8) 个结果")
              .font(.caption2)
              .foregroundColor(.secondary)
              .italic()
          }
        }
      }
      .frame(height: 100)
      .background(Color.white)
      .cornerRadius(6)
    }
  }
}

struct ObservedObjectTodoAppExample: View {
  @StateObject private var todoManager = ObservedObjectTodoManager()
  @State private var newTodoTitle = ""
  
  var body: some View {
    VStack(spacing: 16) {
      Text("待办事项应用")
        .font(.headline)
      
      HStack {
        TextField("新待办事项", text: $newTodoTitle)
          .textFieldStyle(.roundedBorder)
        
        Button("添加") {
          if !newTodoTitle.isEmpty {
            todoManager.addTodo(newTodoTitle)
            newTodoTitle = ""
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(newTodoTitle.isEmpty)
      }
      
      ObservedObjectTodoFilterView(todoManager: todoManager)
      TodoListView(todoManager: todoManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct ObservedObjectTodoFilterView: View {
  @ObservedObject var todoManager: ObservedObjectTodoManager
  
  var body: some View {
    HStack {
      Picker("过滤", selection: $todoManager.filter) {
        ForEach(ObservedObjectTodoFilter.allCases, id: \.self) { filter in
          Text(filter.rawValue).tag(filter)
        }
      }
      .pickerStyle(.segmented)
      
      Spacer()
      
      VStack(alignment: .trailing, spacing: 2) {
        Text("活跃: \(todoManager.activeCount)")
          .font(.caption2)
          .foregroundColor(.blue)
        
        Text("完成: \(todoManager.completedCount)")
          .font(.caption2)
          .foregroundColor(.green)
      }
    }
  }
}

struct TodoListView: View {
  @ObservedObject var todoManager: ObservedObjectTodoManager
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 4) {
        ForEach(todoManager.filteredTodos) { todo in
          TodoRowView(todo: todo, todoManager: todoManager)
        }
        
        if todoManager.filteredTodos.isEmpty {
          Text("没有待办事项")
            .font(.caption)
            .foregroundColor(.secondary)
            .italic()
            .padding()
        }
      }
    }
    .frame(height: 120)
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct TodoRowView: View {
  let todo: ObservedObjectTodoItem
  @ObservedObject var todoManager: ObservedObjectTodoManager
  
  var body: some View {
    HStack {
      Button(action: {
        todoManager.toggleTodo(todo)
      }) {
        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
          .foregroundColor(todo.isCompleted ? .green : .gray)
      }
      
      Text(todo.title)
        .font(.caption)
        .strikethrough(todo.isCompleted)
        .foregroundColor(todo.isCompleted ? .secondary : .primary)
      
      Spacer()
      
      Button("删除") {
        todoManager.deleteTodo(todo)
      }
      .buttonStyle(.bordered)
      .controlSize(.mini)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
  }
}

struct ObservedObjectNetworkExample: View {
  @StateObject private var networkManager = ObservedObjectNetworkDataManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("网络数据管理")
        .font(.headline)
      
      HStack {
        Button("获取数据") {
          networkManager.fetchData()
        }
        .buttonStyle(.borderedProminent)
        .disabled(networkManager.isLoading)
        
        Button("刷新") {
          networkManager.refreshData()
        }
        .buttonStyle(.bordered)
        .disabled(networkManager.isLoading)
      }
      
      NetworkDataDisplayView(networkManager: networkManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct NetworkDataDisplayView: View {
  @ObservedObject var networkManager: ObservedObjectNetworkDataManager
  
  var body: some View {
    VStack {
      if networkManager.isLoading {
        ProgressView("加载网络数据...")
          .frame(height: 100)
      } else if let error = networkManager.error {
        VStack {
          Image(systemName: "exclamationmark.triangle")
            .foregroundColor(.red)
            .font(.title2)
          Text(error)
            .font(.caption)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
        }
        .frame(height: 100)
      } else {
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(networkManager.data, id: \.self) { item in
              Text(item)
                .font(.caption2)
            }
          }
        }
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(6)
      }
    }
  }
}

struct ObservedObjectSettingsExample: View {
  @StateObject private var settingsManager = ObservedObjectAppSettingsManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("设置管理")
        .font(.headline)
      
      SettingsControlView(settingsManager: settingsManager)
      SettingsPreviewView(settingsManager: settingsManager)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct SettingsControlView: View {
  @ObservedObject var settingsManager: ObservedObjectAppSettingsManager
  
  var body: some View {
    VStack(spacing: 8) {
      Toggle("深色模式", isOn: $settingsManager.isDarkMode)
        .toggleStyle(.switch)
      
      Toggle("通知", isOn: $settingsManager.notificationsEnabled)
        .toggleStyle(.switch)
      
      HStack {
        Text("字体大小")
          .font(.caption)
        
        Slider(
          value: $settingsManager.fontSize,
          in: 12...24,
          step: 1
        )
        
        Text("\(Int(settingsManager.fontSize))")
          .font(.caption)
          .bold()
      }
      
      HStack {
        Text("语言")
          .font(.caption)
        
        Picker("语言", selection: $settingsManager.language) {
          ForEach(settingsManager.availableLanguages, id: \.self) { lang in
            Text(lang).tag(lang)
          }
        }
        .pickerStyle(.menu)
      }
      
      Button("重置设置") {
        settingsManager.resetToDefaults()
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
    }
  }
}

struct SettingsPreviewView: View {
  @ObservedObject var settingsManager: ObservedObjectAppSettingsManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("预览效果")
        .font(.caption)
        .bold()
      
      VStack(alignment: .leading, spacing: 4) {
        Text("这是示例文本")
          .font(.system(size: settingsManager.fontSize))
        
        Text("语言: \(settingsManager.language)")
          .font(.caption2)
        
        HStack {
          Image(systemName: settingsManager.notificationsEnabled ? "bell.fill" : "bell.slash")
            .foregroundColor(settingsManager.notificationsEnabled ? .blue : .gray)
          
          Text(settingsManager.notificationsEnabled ? "通知开启" : "通知关闭")
            .font(.caption2)
        }
      }
    }
    .padding()
    .background(settingsManager.isDarkMode ? Color.black : Color.white)
    .foregroundColor(settingsManager.isDarkMode ? Color.white : Color.black)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    )
  }
}

// MARK: - 辅助扩展

struct ObservedObjectDateFormatter {
  static let timeOnly: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()
}

#Preview {
  NavigationView {
    ObservedObjectDemoView()
  }
}
