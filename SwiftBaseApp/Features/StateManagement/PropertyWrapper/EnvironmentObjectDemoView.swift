import SwiftUI
import Combine

// MARK: - EnvironmentObjectDemoView

struct EnvironmentObjectDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "全局状态管理") {
          EnvironmentObjectGlobalStateExample()
        }
        
        ShowcaseItem(title: "依赖注入模式") {
          EnvironmentObjectDependencyInjectionExample()
        }
        
        ShowcaseItem(title: "环境值传递") {
          EnvironmentObjectEnvironmentPassingExample()
        }
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "多层级环境对象") {
          EnvironmentObjectMultiLevelExample()
        }
        
        ShowcaseItem(title: "条件性环境对象") {
          EnvironmentObjectConditionalExample()
        }
        
        ShowcaseItem(title: "环境对象组合") {
          EnvironmentObjectCombinationExample()
        }
      }
      
      // MARK: - 实际应用
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "用户认证系统") {
          EnvironmentObjectAuthExample()
        }
        
        ShowcaseItem(title: "主题管理") {
          EnvironmentObjectThemeExample()
        }
        
        ShowcaseItem(title: "购物车系统") {
          EnvironmentObjectShoppingCartExample()
        }
      }
      
      // MARK: - 测试策略
      ShowcaseSection("测试策略") {
        ShowcaseItem(title: "模拟环境对象") {
          EnvironmentObjectMockExample()
        }
        
        ShowcaseItem(title: "环境对象隔离") {
          EnvironmentObjectIsolationExample()
        }
        
        ShowcaseItem(title: "状态验证") {
          EnvironmentObjectValidationExample()
        }
      }
    }
    .navigationTitle("@EnvironmentObject 环境对象")
  }
}

// MARK: - 数据模型

struct EnvironmentObjectUser: Identifiable {
  let id = UUID()
  var name: String
  var email: String
  var role: String
  var isOnline: Bool
  var lastActiveTime: Date?
}

struct EnvironmentObjectProduct: Identifiable {
  let id = UUID()
  var name: String
  var price: Double
  var category: String
  var imageURL: String?
  var inStock: Bool
}

struct EnvironmentObjectCartItem: Identifiable {
  let id = UUID()
  var product: EnvironmentObjectProduct
  var quantity: Int
  
  var totalPrice: Double {
    product.price * Double(quantity)
  }
}

struct EnvironmentObjectTheme {
  var primaryColor: Color
  var secondaryColor: Color
  var backgroundColor: Color
  var textColor: Color
  var isDarkMode: Bool
  
  static let light = EnvironmentObjectTheme(
    primaryColor: .blue,
    secondaryColor: .gray,
    backgroundColor: .white,
    textColor: .black,
    isDarkMode: false
  )
  
  static let dark = EnvironmentObjectTheme(
    primaryColor: .orange,
    secondaryColor: .gray,
    backgroundColor: .black,
    textColor: .white,
    isDarkMode: true
  )
}

enum EnvironmentObjectAuthState: Equatable {
  case notAuthenticated
  case authenticating
  case authenticated
  case failed(String)
}

// MARK: - 协议定义

@MainActor
protocol EnvironmentObjectUserManaging: ObservableObject {
  var currentUser: EnvironmentObjectUser? { get set }
  var authState: EnvironmentObjectAuthState { get set }
  var isLoggedIn: Bool { get set }
  var loginAttempts: Int { get set }
  
  func login(email: String, password: String)
  func logout()
  func updateUserActivity()
  func toggleOnlineStatus()
}

// MARK: - 类型擦除包装类

@MainActor
class AnyEnvironmentObjectUserManager: ObservableObject {
  @Published var currentUser: EnvironmentObjectUser?
  @Published var authState: EnvironmentObjectAuthState = .notAuthenticated
  @Published var isLoggedIn = false
  @Published var loginAttempts = 0
  
  private var manager: any EnvironmentObjectUserManaging
  private var cancellables = Set<AnyCancellable>()
  
  init<T: EnvironmentObjectUserManaging>(_ manager: T) {
    self.manager = manager
    self.currentUser = manager.currentUser
    self.authState = manager.authState
    self.isLoggedIn = manager.isLoggedIn
    self.loginAttempts = manager.loginAttempts
    
    // 绑定发布者以保持同步
    manager.objectWillChange.sink { [weak self] _ in
      self?.objectWillChange.send()
    }.store(in: &cancellables)
    
    // 使用类型转换来访问发布者
    if let userManager = manager as? EnvironmentObjectUserManager {
      userManager.$currentUser.sink { [weak self] newValue in
        self?.currentUser = newValue
      }.store(in: &cancellables)
      
      userManager.$authState.sink { [weak self] newValue in
        self?.authState = newValue
      }.store(in: &cancellables)
      
      userManager.$isLoggedIn.sink { [weak self] newValue in
        self?.isLoggedIn = newValue
      }.store(in: &cancellables)
      
      userManager.$loginAttempts.sink { [weak self] newValue in
        self?.loginAttempts = newValue
      }.store(in: &cancellables)
    } else if let mockManager = manager as? EnvironmentObjectMockUserManager {
      mockManager.$currentUser.sink { [weak self] newValue in
        self?.currentUser = newValue
      }.store(in: &cancellables)
      
      mockManager.$authState.sink { [weak self] newValue in
        self?.authState = newValue
      }.store(in: &cancellables)
      
      mockManager.$isLoggedIn.sink { [weak self] newValue in
        self?.isLoggedIn = newValue
      }.store(in: &cancellables)
      
      mockManager.$loginAttempts.sink { [weak self] newValue in
        self?.loginAttempts = newValue
      }.store(in: &cancellables)
    }
  }
  
  func login(email: String, password: String) {
    manager.login(email: email, password: password)
  }
  
  func logout() {
    manager.logout()
  }
  
  func updateUserActivity() {
    manager.updateUserActivity()
  }
  
  func toggleOnlineStatus() {
    manager.toggleOnlineStatus()
  }
}

// MARK: - 环境对象类

@MainActor
class EnvironmentObjectAppSettings: ObservableObject {
  @Published var isDarkMode = false
  @Published var fontSize: Double = 16
  @Published var language = "中文"
  @Published var enableNotifications = true
  @Published var enableAnalytics = false
  
  let availableLanguages = ["中文", "English", "日本語", "Español"]
  
  func toggleDarkMode() {
    isDarkMode.toggle()
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
    fontSize = 16
    language = "中文"
    enableNotifications = true
    enableAnalytics = false
  }
}

@MainActor
class EnvironmentObjectUserManager: EnvironmentObjectUserManaging {
  @Published var currentUser: EnvironmentObjectUser?
  @Published var authState: EnvironmentObjectAuthState = .notAuthenticated
  @Published var isLoggedIn = false
  @Published var loginAttempts = 0
  
  private let maxLoginAttempts = 3
  
  func login(email: String, password: String) {
    guard loginAttempts < maxLoginAttempts else {
      authState = .failed("登录尝试次数过多，请稍后再试")
      return
    }
    
    authState = .authenticating
    
    Task {
      try? await Task.sleep(nanoseconds: 2_000_000_000) // 模拟网络延迟
      
      if email == "test@example.com" && password == "123456" {
        let user = EnvironmentObjectUser(
          name: "测试用户",
          email: email,
          role: "管理员",
          isOnline: true,
          lastActiveTime: Date()
        )
        self.currentUser = user
        self.isLoggedIn = true
        self.authState = .authenticated
        self.loginAttempts = 0
      } else {
        self.loginAttempts += 1
        self.authState = .failed("用户名或密码错误")
      }
    }
  }
  
  func logout() {
    currentUser = nil
    isLoggedIn = false
    authState = .notAuthenticated
    loginAttempts = 0
  }
  
  func updateUserActivity() {
    currentUser?.lastActiveTime = Date()
  }
  
  func toggleOnlineStatus() {
    currentUser?.isOnline.toggle()
  }
}

@MainActor
class EnvironmentObjectThemeManager: ObservableObject {
  @Published var currentTheme: EnvironmentObjectTheme = .light
  @Published var customColors: [Color] = [.blue, .green, .purple, .orange, .pink]
  @Published var animateThemeChanges = true
  
  func applyTheme(_ theme: EnvironmentObjectTheme) {
    if animateThemeChanges {
      withAnimation(.easeInOut(duration: 0.3)) {
        currentTheme = theme
      }
    } else {
      currentTheme = theme
    }
  }
  
  func toggleTheme() {
    let newTheme = currentTheme.isDarkMode ? EnvironmentObjectTheme.light : EnvironmentObjectTheme.dark
    applyTheme(newTheme)
  }
  
  func createCustomTheme(primaryColor: Color) {
    let customTheme = EnvironmentObjectTheme(
      primaryColor: primaryColor,
      secondaryColor: .gray,
      backgroundColor: currentTheme.backgroundColor,
      textColor: currentTheme.textColor,
      isDarkMode: currentTheme.isDarkMode
    )
    applyTheme(customTheme)
  }
}

@MainActor
class EnvironmentObjectShoppingCart: ObservableObject {
  @Published var items: [EnvironmentObjectCartItem] = []
  @Published var discountPercentage: Double = 0
  @Published var shippingCost: Double = 0
  @Published var isCheckingOut = false
  
  var subtotal: Double {
    items.reduce(0) { $0 + $1.totalPrice }
  }
  
  var discountAmount: Double {
    subtotal * discountPercentage / 100
  }
  
  var total: Double {
    subtotal - discountAmount + shippingCost
  }
  
  var itemCount: Int {
    items.reduce(0) { $0 + $1.quantity }
  }
  
  var isEmpty: Bool {
    items.isEmpty
  }
  
  func addItem(_ product: EnvironmentObjectProduct) {
    if let index = items.firstIndex(where: { $0.product.id == product.id }) {
      items[index].quantity += 1
    } else {
      items.append(EnvironmentObjectCartItem(product: product, quantity: 1))
    }
  }
  
  func removeItem(at index: Int) {
    guard index < items.count else { return }
    items.remove(at: index)
  }
  
  func updateQuantity(for itemId: UUID, quantity: Int) {
    guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
    
    if quantity <= 0 {
      items.remove(at: index)
    } else {
      items[index].quantity = quantity
    }
  }
  
  func applyDiscount(_ percentage: Double) {
    discountPercentage = max(0, min(100, percentage))
  }
  
  func calculateShipping() {
    // 免费配送超过100元
    shippingCost = subtotal >= 100 ? 0 : 15
  }
  
  func clearCart() {
    items.removeAll()
    discountPercentage = 0
    shippingCost = 0
  }
  
  func checkout() {
    isCheckingOut = true
    
    Task {
      try? await Task.sleep(nanoseconds: 3_000_000_000) // 模拟结算延迟
      self.clearCart()
      self.isCheckingOut = false
    }
  }
}

@MainActor
class EnvironmentObjectNetworkManager: ObservableObject {
  @Published var isConnected = true
  @Published var connectionType = "WiFi"
  @Published var requestCount = 0
  @Published var lastRequestTime: Date?
  
  let connectionTypes = ["WiFi", "Cellular", "Ethernet", "Offline"]
  
  func simulateNetworkRequest() {
    requestCount += 1
    lastRequestTime = Date()
    
    // 模拟网络状态变化
    if Int.random(in: 1...10) == 1 {
      isConnected = false
      
      Task {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        self.isConnected = true
      }
    }
  }
  
  func changeConnectionType(_ type: String) {
    if connectionTypes.contains(type) {
      connectionType = type
      isConnected = type != "Offline"
    }
  }
  
  func resetStats() {
    requestCount = 0
    lastRequestTime = nil
  }
}

@MainActor
class EnvironmentObjectDataService: ObservableObject {
  @Published var data: [String] = []
  @Published var isLoading = false
  @Published var error: String?
  @Published var lastUpdateTime: Date?
  
  func loadData() {
    isLoading = true
    error = nil
    
    Task {
      try? await Task.sleep(nanoseconds: 1_500_000_000) // 模拟网络延迟
      
      if Bool.random() {
        // 模拟成功
        self.data = (1...20).map { "数据项 \($0)" }
        self.lastUpdateTime = Date()
        self.error = nil
      } else {
        // 模拟失败
        self.error = "网络连接失败"
      }
      
      self.isLoading = false
    }
  }
  
  func refreshData() {
    loadData()
  }
  
  func clearData() {
    data.removeAll()
    error = nil
    lastUpdateTime = nil
  }
}

// MARK: - 测试用模拟对象

@MainActor
class EnvironmentObjectMockUserManager: EnvironmentObjectUserManaging {
  @Published var currentUser: EnvironmentObjectUser?
  @Published var authState: EnvironmentObjectAuthState = .notAuthenticated
  @Published var isLoggedIn = false
  @Published var loginAttempts = 0
  
  init(isLoggedIn: Bool = false) {
    self.isLoggedIn = isLoggedIn
    if isLoggedIn {
      self.currentUser = EnvironmentObjectUser(
        name: "测试用户",
        email: "test@mock.com",
        role: "用户",
        isOnline: true,
        lastActiveTime: Date()
      )
      self.authState = .authenticated
    }
  }
  
  func login(email: String, password: String) {
    authState = .authenticating
    
    Task {
      try? await Task.sleep(nanoseconds: 500_000_000) // 快速模拟
      
      let user = EnvironmentObjectUser(
        name: "Mock用户",
        email: email,
        role: "测试",
        isOnline: true,
        lastActiveTime: Date()
      )
      self.currentUser = user
      self.isLoggedIn = true
      self.authState = .authenticated
    }
  }
  
  func logout() {
    currentUser = nil
    isLoggedIn = false
    authState = .notAuthenticated
  }
  
  func updateUserActivity() {
    currentUser?.lastActiveTime = Date()
  }
  
  func toggleOnlineStatus() {
    currentUser?.isOnline.toggle()
  }
}

// MARK: - 示例视图

struct EnvironmentObjectGlobalStateExample: View {
  @StateObject private var appSettings = EnvironmentObjectAppSettings()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("全局状态管理示例")
        .font(.headline)
      
      TabView {
        SettingsTabView()
          .tabItem { Label("设置", systemImage: "gear") }
        
        PreviewTabView()
          .tabItem { Label("预览", systemImage: "eye") }
      }
      .frame(height: 300)
    }
    .environmentObject(appSettings)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct SettingsTabView: View {
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  
  var body: some View {
    VStack(spacing: 12) {
      Toggle("深色模式", isOn: $appSettings.isDarkMode)
        .toggleStyle(.switch)
      
      HStack {
        Text("字体大小")
          .font(.caption)
        
        Slider(value: $appSettings.fontSize, in: 12...24, step: 1)
        
        Text("\(Int(appSettings.fontSize))")
          .font(.caption)
          .bold()
      }
      
      Picker("语言", selection: $appSettings.language) {
        ForEach(appSettings.availableLanguages, id: \.self) { lang in
          Text(lang).tag(lang)
        }
      }
      .pickerStyle(.menu)
      
      Toggle("通知", isOn: $appSettings.enableNotifications)
        .toggleStyle(.switch)
      
      Button("重置设置") {
        appSettings.resetToDefaults()
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
    }
    .padding()
  }
}

struct PreviewTabView: View {
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  
  var body: some View {
    VStack(spacing: 12) {
      Text("预览效果")
        .font(.caption)
        .bold()
      
      Text("这是示例文本")
        .font(.system(size: appSettings.fontSize))
        .padding()
        .background(appSettings.isDarkMode ? Color.black : Color.white)
        .foregroundColor(appSettings.isDarkMode ? Color.white : Color.black)
        .cornerRadius(8)
      
      HStack {
        Text("语言: \(appSettings.language)")
          .font(.caption)
        
        Spacer()
        
        HStack {
          Image(systemName: appSettings.enableNotifications ? "bell.fill" : "bell.slash")
          Text(appSettings.enableNotifications ? "通知开启" : "通知关闭")
        }
        .font(.caption2)
        .foregroundColor(appSettings.enableNotifications ? .blue : .gray)
      }
    }
    .padding()
  }
}

struct EnvironmentObjectDependencyInjectionExample: View {
  @StateObject private var networkManager = EnvironmentObjectNetworkManager()
  @StateObject private var dataService = EnvironmentObjectDataService()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("依赖注入模式")
        .font(.headline)
      
      NetworkStatusView()
      
      DataServiceView()
    }
    .environmentObject(networkManager)
    .environmentObject(dataService)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct NetworkStatusView: View {
  @EnvironmentObject var networkManager: EnvironmentObjectNetworkManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Circle()
          .fill(networkManager.isConnected ? .green : .red)
          .frame(width: 12, height: 12)
        
        Text("网络状态")
          .font(.subheadline)
          .bold()
        
        Spacer()
        
        Text(networkManager.connectionType)
          .font(.caption)
          .padding(.horizontal, 8)
          .padding(.vertical, 2)
          .background(Color.blue.opacity(0.1))
          .cornerRadius(4)
      }
      
      HStack {
        Text("请求数: \(networkManager.requestCount)")
          .font(.caption)
        
        Spacer()
        
        Button("模拟请求") {
          networkManager.simulateNetworkRequest()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
      }
      
      if let lastRequest = networkManager.lastRequestTime {
        Text("最后请求: \(DateFormatter.timeOnly.string(from: lastRequest))")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct DataServiceView: View {
  @EnvironmentObject var dataService: EnvironmentObjectDataService
  @EnvironmentObject var networkManager: EnvironmentObjectNetworkManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("数据服务")
          .font(.subheadline)
          .bold()
        
        Spacer()
        
        HStack {
          Button("加载") {
            if networkManager.isConnected {
              dataService.loadData()
              networkManager.simulateNetworkRequest()
            }
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.small)
          .disabled(!networkManager.isConnected || dataService.isLoading)
          
          Button("清空") {
            dataService.clearData()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
        }
      }
      
      if dataService.isLoading {
        HStack {
          ProgressView()
            .controlSize(.small)
          Text("加载中...")
            .font(.caption)
        }
      } else if let error = dataService.error {
        Text("错误: \(error)")
          .font(.caption)
          .foregroundColor(.red)
      } else if !dataService.data.isEmpty {
        Text("数据项: \(dataService.data.count)")
          .font(.caption)
        
        if let lastUpdate = dataService.lastUpdateTime {
          Text("更新时间: \(DateFormatter.timeOnly.string(from: lastUpdate))")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
      } else {
        Text("暂无数据")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct EnvironmentObjectEnvironmentPassingExample: View {
  @StateObject private var appSettings = EnvironmentObjectAppSettings()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("环境值传递")
        .font(.headline)
      
      NavigationView {
        VStack {
          Text("级别 1")
            .font(.title3)
            .bold()
          
          NavigationLink("进入级别 2") {
            Level2View()
          }
          .buttonStyle(.borderedProminent)
        }
        .navigationTitle("环境传递")
        .navigationBarTitleDisplayMode(.inline)
      }
      .frame(height: 200)
    }
    .environmentObject(appSettings)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct Level2View: View {
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  
  var body: some View {
    VStack(spacing: 16) {
      Text("级别 2")
        .font(.title3)
        .bold()
      
      Text("字体大小: \(Int(appSettings.fontSize))")
        .font(.system(size: appSettings.fontSize))
      
      NavigationLink("进入级别 3") {
        Level3View()
      }
      .buttonStyle(.borderedProminent)
      
      Slider(value: $appSettings.fontSize, in: 12...24, step: 1)
        .padding(.horizontal)
    }
    .padding()
    .navigationTitle("级别 2")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct Level3View: View {
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  
  var body: some View {
    VStack(spacing: 16) {
      Text("级别 3")
        .font(.title3)
        .bold()
      
      Text("深层嵌套的视图也能访问环境对象")
        .font(.system(size: appSettings.fontSize))
        .multilineTextAlignment(.center)
        .padding()
      
      Toggle("深色模式", isOn: $appSettings.isDarkMode)
        .toggleStyle(.switch)
      
      Text("语言: \(appSettings.language)")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
    .background(appSettings.isDarkMode ? Color.black : Color.white)
    .foregroundColor(appSettings.isDarkMode ? Color.white : Color.black)
    .cornerRadius(12)
    .navigationTitle("级别 3")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct EnvironmentObjectMultiLevelExample: View {
  @StateObject private var userManager = EnvironmentObjectUserManager()
  @StateObject private var appSettings = EnvironmentObjectAppSettings()
  @StateObject private var wrappedUserManager = AnyEnvironmentObjectUserManager(EnvironmentObjectUserManager())
  
  var body: some View {
    VStack(spacing: 16) {
      Text("多层级环境对象")
        .font(.headline)
      
      NavigationView {
        RootLevelView()
      }
      .frame(height: 250)
    }
    .environmentObject(wrappedUserManager)
    .environmentObject(appSettings)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct RootLevelView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  @StateObject private var localData = EnvironmentObjectDataService()
  
  var body: some View {
    VStack(spacing: 12) {
      Text("根级别视图")
        .font(.subheadline)
        .bold()
      
      if userManager.isLoggedIn {
        NavigationLink("用户界面") {
          UserLevelView()
            .environmentObject(localData) // 添加本地环境对象
        }
        .buttonStyle(.borderedProminent)
        
        Button("注销") {
          userManager.logout()
        }
        .buttonStyle(.bordered)
      } else {
        Button("登录 (test@example.com / 123456)") {
          userManager.login(email: "test@example.com", password: "123456")
        }
        .buttonStyle(.borderedProminent)
        .disabled(userManager.authState == .authenticating)
      }
      
      if userManager.authState == .authenticating {
        ProgressView("登录中...")
          .controlSize(.small)
      }
    }
    .padding()
    .navigationTitle("多层级示例")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct UserLevelView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  @EnvironmentObject var localData: EnvironmentObjectDataService
  
  var body: some View {
    VStack(spacing: 12) {
      if let user = userManager.currentUser {
        Text("欢迎, \(user.name)")
          .font(.system(size: appSettings.fontSize))
          .bold()
        
        Text("角色: \(user.role)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      NavigationLink("数据视图") {
        DataLevelView()
      }
      .buttonStyle(.borderedProminent)
      
      HStack {
        Button("切换主题") {
          appSettings.toggleDarkMode()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        
        Button("加载数据") {
          localData.loadData()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        .disabled(localData.isLoading)
      }
    }
    .padding()
    .navigationTitle("用户级别")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct DataLevelView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  @EnvironmentObject var appSettings: EnvironmentObjectAppSettings
  @EnvironmentObject var localData: EnvironmentObjectDataService
  
  var body: some View {
    VStack(spacing: 12) {
      Text("数据级别视图")
        .font(.system(size: appSettings.fontSize))
        .bold()
      
      if localData.isLoading {
        ProgressView("加载中...")
      } else if let error = localData.error {
        Text("错误: \(error)")
          .font(.caption)
          .foregroundColor(.red)
      } else if !localData.data.isEmpty {
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(localData.data.prefix(5), id: \.self) { item in
              Text(item)
                .font(.caption2)
            }
          }
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(6)
      } else {
        Text("暂无数据")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Button("刷新数据") {
        localData.refreshData()
        userManager.updateUserActivity()
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
    }
    .padding()
    .background(appSettings.isDarkMode ? Color.black.opacity(0.1) : Color.white)
    .cornerRadius(8)
    .navigationTitle("数据级别")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct EnvironmentObjectConditionalExample: View {
  @State private var useProductionEnvironment = true
  @StateObject private var prodUserManager = EnvironmentObjectUserManager()
  @StateObject private var mockUserManager = EnvironmentObjectMockUserManager(isLoggedIn: true)
  
  private var wrappedUserManager: AnyEnvironmentObjectUserManager {
    useProductionEnvironment ? 
      AnyEnvironmentObjectUserManager(prodUserManager) : 
      AnyEnvironmentObjectUserManager(mockUserManager)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Text("条件性环境对象")
        .font(.headline)
      
      Toggle("生产环境", isOn: $useProductionEnvironment)
        .toggleStyle(.switch)
      
      ConditionalContentView()
    }
    .environmentObject(wrappedUserManager)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct ConditionalContentView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  
  var body: some View {
    VStack(spacing: 12) {
      if userManager.isLoggedIn {
        if let user = userManager.currentUser {
          VStack(alignment: .leading, spacing: 4) {
            Text("用户: \(user.name)")
              .font(.body)
              .bold()
            
            Text("邮箱: \(user.email)")
              .font(.caption)
              .foregroundColor(.secondary)
            
            Text("角色: \(user.role)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .background(Color.white)
          .cornerRadius(8)
        }
        
        Button("注销") {
          userManager.logout()
        }
        .buttonStyle(.bordered)
      } else {
        VStack(spacing: 8) {
          Text("未登录")
            .font(.subheadline)
            .foregroundColor(.secondary)
          
          Button("登录 (test@example.com / 123456)") {
            userManager.login(email: "test@example.com", password: "123456")
          }
          .buttonStyle(.borderedProminent)
          .disabled(userManager.authState == .authenticating)
        }
        
        if userManager.authState == .authenticating {
          ProgressView("登录中...")
            .controlSize(.small)
        }
      }
    }
  }
}

struct EnvironmentObjectCombinationExample: View {
  @StateObject private var userManager = EnvironmentObjectUserManager()
  @StateObject private var themeManager = EnvironmentObjectThemeManager()
  @StateObject private var shoppingCart = EnvironmentObjectShoppingCart()
  @StateObject private var wrappedUserManager = AnyEnvironmentObjectUserManager(EnvironmentObjectUserManager())
  
  var body: some View {
    VStack(spacing: 16) {
      Text("环境对象组合")
        .font(.headline)
      
      CombinedInterfaceView()
    }
    .environmentObject(wrappedUserManager)
    .environmentObject(themeManager)
    .environmentObject(shoppingCart)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct CombinedInterfaceView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  @EnvironmentObject var themeManager: EnvironmentObjectThemeManager
  @EnvironmentObject var shoppingCart: EnvironmentObjectShoppingCart
  
  var body: some View {
    VStack(spacing: 12) {
      // 主题控制
      HStack {
        Text("主题")
          .font(.caption)
          .bold()
        
        Spacer()
        
        Button("切换") {
          themeManager.toggleTheme()
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
      }
      .padding()
      .background(themeManager.currentTheme.backgroundColor)
      .foregroundColor(themeManager.currentTheme.textColor)
      .cornerRadius(8)
      
      // 用户状态
      HStack {
        VStack(alignment: .leading) {
          Text("用户状态")
            .font(.caption)
            .bold()
          
          if userManager.isLoggedIn {
            Text("已登录")
              .font(.caption2)
              .foregroundColor(.green)
          } else {
            Text("未登录")
              .font(.caption2)
              .foregroundColor(.red)
          }
        }
        
        Spacer()
        
        if userManager.isLoggedIn {
          Button("注销") {
            userManager.logout()
          }
        } else {
          Button("登录") {
            userManager.login(email: "test@example.com", password: "123456")
          }
        }
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
      .padding()
      .background(Color.white)
      .cornerRadius(8)
      
      // 购物车状态
      HStack {
        VStack(alignment: .leading) {
          Text("购物车")
            .font(.caption)
            .bold()
          
          Text("\(shoppingCart.itemCount) 件商品")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        HStack {
          Button("添加商品") {
            let product = EnvironmentObjectProduct(
              name: "示例商品",
              price: Double.random(in: 10...100),
              category: "测试",
              inStock: true
            )
            shoppingCart.addItem(product)
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.small)
          
          if !shoppingCart.isEmpty {
            Button("清空") {
              shoppingCart.clearCart()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
          }
        }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(8)
    }
  }
}

struct EnvironmentObjectAuthExample: View {
  @StateObject private var userManager = EnvironmentObjectUserManager()
  @StateObject private var wrappedUserManager = AnyEnvironmentObjectUserManager(EnvironmentObjectUserManager())
  
  var body: some View {
    VStack(spacing: 16) {
      Text("用户认证系统")
        .font(.headline)
      
      if wrappedUserManager.isLoggedIn {
        AuthenticatedView()
      } else {
        LoginView()
      }
    }
    .environmentObject(wrappedUserManager)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct LoginView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  @State private var email = "test@example.com"
  @State private var password = "123456"
  
  var body: some View {
    VStack(spacing: 12) {
      Text("用户登录")
        .font(.subheadline)
        .bold()
      
      TextField("邮箱", text: $email)
        .textFieldStyle(.roundedBorder)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
      
      SecureField("密码", text: $password)
        .textFieldStyle(.roundedBorder)
      
      Button("登录") {
        userManager.login(email: email, password: password)
      }
      .buttonStyle(.borderedProminent)
      .disabled(userManager.authState == .authenticating || email.isEmpty || password.isEmpty)
      
      if userManager.authState == .authenticating {
        HStack {
          ProgressView()
            .controlSize(.small)
          Text("登录中...")
            .font(.caption)
        }
      }
      
      if case .failed(let message) = userManager.authState {
        Text(message)
          .font(.caption)
          .foregroundColor(.red)
          .multilineTextAlignment(.center)
      }
      
      if userManager.loginAttempts > 0 {
        Text("登录尝试次数: \(userManager.loginAttempts)/3")
          .font(.caption2)
          .foregroundColor(.orange)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct AuthenticatedView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  
  var body: some View {
    VStack(spacing: 12) {
      if let user = userManager.currentUser {
        VStack(spacing: 8) {
          Text("欢迎回来!")
            .font(.subheadline)
            .bold()
          
          HStack {
            VStack(alignment: .leading, spacing: 2) {
              Text("用户: \(user.name)")
                .font(.body)
              
              Text("邮箱: \(user.email)")
                .font(.caption)
                .foregroundColor(.secondary)
              
              Text("角色: \(user.role)")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack {
              HStack {
                Circle()
                  .fill(user.isOnline ? .green : .gray)
                  .frame(width: 8, height: 8)
                
                Text(user.isOnline ? "在线" : "离线")
                  .font(.caption2)
              }
              
              if let lastActive = user.lastActiveTime {
                Text("活跃: \(DateFormatter.timeOnly.string(from: lastActive))")
                  .font(.caption2)
                  .foregroundColor(.secondary)
              }
            }
          }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        
        HStack {
          Button("切换状态") {
            userManager.toggleOnlineStatus()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
          
          Button("更新活跃时间") {
            userManager.updateUserActivity()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
          
          Button("注销") {
            userManager.logout()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
        }
      }
    }
  }
}

struct EnvironmentObjectThemeExample: View {
  @StateObject private var themeManager = EnvironmentObjectThemeManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("主题管理")
        .font(.headline)
      
      ThemeControlView()
      
      ThemedContentView()
    }
    .environmentObject(themeManager)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct ThemeControlView: View {
  @EnvironmentObject var themeManager: EnvironmentObjectThemeManager
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Text("主题控制")
          .font(.subheadline)
          .bold()
        
        Spacer()
        
        Button("切换主题") {
          themeManager.toggleTheme()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
      }
      
      Text("自定义颜色:")
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack {
        ForEach(themeManager.customColors, id: \.self) { color in
          Button(action: {
            themeManager.createCustomTheme(primaryColor: color)
          }) {
            Circle()
              .fill(color)
              .frame(width: 30, height: 30)
          }
          .buttonStyle(.plain)
        }
        
        Spacer()
        
        Toggle("动画", isOn: $themeManager.animateThemeChanges)
          .toggleStyle(.switch)
          .controlSize(.mini)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct ThemedContentView: View {
  @EnvironmentObject var themeManager: EnvironmentObjectThemeManager
  
  var body: some View {
    VStack(spacing: 12) {
      Text("主题预览")
        .font(.subheadline)
        .bold()
        .foregroundColor(themeManager.currentTheme.textColor)
      
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("主要颜色")
            .font(.caption)
            .foregroundColor(themeManager.currentTheme.textColor)
          
          Rectangle()
            .fill(themeManager.currentTheme.primaryColor)
            .frame(height: 20)
            .cornerRadius(4)
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text("次要颜色")
            .font(.caption)
            .foregroundColor(themeManager.currentTheme.textColor)
          
          Rectangle()
            .fill(themeManager.currentTheme.secondaryColor)
            .frame(height: 20)
            .cornerRadius(4)
        }
      }
      
      Text("这是使用当前主题的示例文本")
        .font(.body)
        .foregroundColor(themeManager.currentTheme.textColor)
        .padding()
        .background(themeManager.currentTheme.primaryColor.opacity(0.1))
        .cornerRadius(8)
      
      Text("模式: \(themeManager.currentTheme.isDarkMode ? "深色" : "浅色")")
        .font(.caption)
        .foregroundColor(themeManager.currentTheme.textColor)
    }
    .padding()
    .background(themeManager.currentTheme.backgroundColor)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(themeManager.currentTheme.primaryColor, lineWidth: 1)
    )
  }
}

struct EnvironmentObjectShoppingCartExample: View {
  @StateObject private var shoppingCart = EnvironmentObjectShoppingCart()
  
  private let sampleProducts = [
    EnvironmentObjectProduct(name: "iPhone 15", price: 5999, category: "手机", inStock: true),
    EnvironmentObjectProduct(name: "iPad Air", price: 3799, category: "平板", inStock: true),
    EnvironmentObjectProduct(name: "MacBook Pro", price: 12999, category: "笔记本", inStock: true),
    EnvironmentObjectProduct(name: "AirPods Pro", price: 1899, category: "耳机", inStock: false)
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("购物车系统")
        .font(.headline)
      
      ProductGridView()
      
      EnvironmentObjectCartSummaryView()
    }
    .environmentObject(shoppingCart)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
  
  private func ProductGridView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("商品列表")
        .font(.subheadline)
        .bold()
      
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
        ForEach(sampleProducts) { product in
          ProductCardView(product: product)
        }
      }
    }
  }
}

struct ProductCardView: View {
  let product: EnvironmentObjectProduct
  @EnvironmentObject var shoppingCart: EnvironmentObjectShoppingCart
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(product.name)
        .font(.caption)
        .bold()
        .lineLimit(1)
      
      Text(product.category)
        .font(.caption2)
        .foregroundColor(.secondary)
      
      Text("¥\(product.price, specifier: "%.0f")")
        .font(.caption)
        .bold()
        .foregroundColor(.primary)
      
      Button(product.inStock ? "加入购物车" : "缺货") {
        if product.inStock {
          shoppingCart.addItem(product)
        }
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.mini)
      .disabled(!product.inStock)
    }
    .padding(8)
    .background(Color.white)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    )
  }
}

struct EnvironmentObjectCartSummaryView: View {
  @EnvironmentObject var shoppingCart: EnvironmentObjectShoppingCart
  @State private var discountCode = ""
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Text("购物车 (\(shoppingCart.itemCount))")
          .font(.subheadline)
          .bold()
        
        Spacer()
        
        if !shoppingCart.isEmpty {
          Button("清空") {
            shoppingCart.clearCart()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
        }
      }
      
      if shoppingCart.isEmpty {
        Text("购物车为空")
          .font(.caption)
          .foregroundColor(.secondary)
          .italic()
      } else {
        // 商品列表
        ScrollView {
          LazyVStack(spacing: 4) {
            ForEach(Array(shoppingCart.items.enumerated()), id: \.element.id) { index, item in
              CartItemRowView(item: item, index: index)
            }
          }
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(6)
        
        // 优惠码
        HStack {
          TextField("优惠码 (SAVE10/SAVE20)", text: $discountCode)
            .textFieldStyle(.roundedBorder)
          
          Button("应用") {
            applyDiscountCode()
          }
          .buttonStyle(.bordered)
          .controlSize(.small)
        }
        
        // 价格明细
        VStack(spacing: 4) {
          HStack {
            Text("小计")
              .font(.caption)
            Spacer()
            Text("¥\(shoppingCart.subtotal, specifier: "%.2f")")
              .font(.caption)
          }
          
          if shoppingCart.discountPercentage > 0 {
            HStack {
              Text("优惠 (\(shoppingCart.discountPercentage, specifier: "%.0f")%)")
                .font(.caption)
              Spacer()
              Text("-¥\(shoppingCart.discountAmount, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.green)
            }
          }
          
          HStack {
            Text("配送费")
              .font(.caption)
            Spacer()
            Text(shoppingCart.shippingCost > 0 ? "¥\(shoppingCart.shippingCost, specifier: "%.2f")" : "免费")
              .font(.caption)
              .foregroundColor(shoppingCart.shippingCost > 0 ? .primary : .green)
          }
          
          Divider()
          
          HStack {
            Text("总计")
              .font(.caption)
              .bold()
            Spacer()
            Text("¥\(shoppingCart.total, specifier: "%.2f")")
              .font(.caption)
              .bold()
          }
        }
        .padding(.horizontal)
        
        Button("结算") {
          shoppingCart.calculateShipping()
          shoppingCart.checkout()
        }
        .buttonStyle(.borderedProminent)
        .disabled(shoppingCart.isCheckingOut)
        
        if shoppingCart.isCheckingOut {
          HStack {
            ProgressView()
              .controlSize(.small)
            Text("处理中...")
              .font(.caption)
          }
        }
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
  
  private func applyDiscountCode() {
    switch discountCode.uppercased() {
    case "SAVE10":
      shoppingCart.applyDiscount(10)
    case "SAVE20":
      shoppingCart.applyDiscount(20)
    default:
      shoppingCart.applyDiscount(0)
    }
    discountCode = ""
  }
}

struct CartItemRowView: View {
  let item: EnvironmentObjectCartItem
  let index: Int
  @EnvironmentObject var shoppingCart: EnvironmentObjectShoppingCart
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 2) {
        Text(item.product.name)
          .font(.caption)
          .bold()
        
        Text("¥\(item.product.price, specifier: "%.0f")")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      HStack {
        Button("-") {
          shoppingCart.updateQuantity(for: item.id, quantity: item.quantity - 1)
        }
        .buttonStyle(.bordered)
        .controlSize(.mini)
        
        Text("\(item.quantity)")
          .font(.caption)
          .frame(minWidth: 20)
        
        Button("+") {
          shoppingCart.updateQuantity(for: item.id, quantity: item.quantity + 1)
        }
        .buttonStyle(.bordered)
        .controlSize(.mini)
        
        Button("删除") {
          shoppingCart.removeItem(at: index)
        }
        .buttonStyle(.bordered)
        .controlSize(.mini)
        .foregroundColor(.red)
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
  }
}

struct EnvironmentObjectMockExample: View {
  @StateObject private var mockUserManager = EnvironmentObjectMockUserManager(isLoggedIn: true)
  @StateObject private var wrappedMockUserManager = AnyEnvironmentObjectUserManager(EnvironmentObjectMockUserManager(isLoggedIn: true))
  
  var body: some View {
    VStack(spacing: 16) {
      Text("模拟环境对象")
        .font(.headline)
      
      MockContentView()
    }
    .environmentObject(wrappedMockUserManager)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

struct MockContentView: View {
  @EnvironmentObject var userManager: AnyEnvironmentObjectUserManager
  
  var body: some View {
    VStack(spacing: 12) {
      Text("使用模拟数据进行测试")
        .font(.subheadline)
        .bold()
      
      if let user = userManager.currentUser {
        VStack(alignment: .leading, spacing: 4) {
          Text("模拟用户信息:")
            .font(.caption)
            .bold()
          
          Text("姓名: \(user.name)")
            .font(.caption)
          
          Text("邮箱: \(user.email)")
            .font(.caption)
          
          Text("角色: \(user.role)")
            .font(.caption)
          
          Text("状态: \(user.isOnline ? "在线" : "离线")")
            .font(.caption)
            .foregroundColor(user.isOnline ? .green : .gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        
        Button("模拟注销") {
          userManager.logout()
        }
        .buttonStyle(.bordered)
      } else {
        Text("未登录状态")
          .font(.caption)
          .foregroundColor(.secondary)
        
        Button("模拟登录") {
          userManager.login(email: "mock@test.com", password: "mock123")
        }
        .buttonStyle(.borderedProminent)
      }
      
      Text("💡 这个示例展示了如何在测试环境中使用模拟的环境对象")
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.top)
    }
  }
}

struct EnvironmentObjectIsolationExample: View {
  @StateObject private var isolatedSettings = EnvironmentObjectAppSettings()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("环境对象隔离")
        .font(.headline)
      
      Text("这个示例有独立的设置环境")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      IsolatedSettingsView()
    }
    .environmentObject(isolatedSettings)
    .padding()
    .background(Color.orange.opacity(0.1))
    .cornerRadius(12)
  }
}

struct IsolatedSettingsView: View {
  @EnvironmentObject var settings: EnvironmentObjectAppSettings
  
  var body: some View {
    VStack(spacing: 12) {
      Toggle("隔离的深色模式", isOn: $settings.isDarkMode)
        .toggleStyle(.switch)
      
      HStack {
        Text("字体大小")
          .font(.caption)
        
        Slider(value: $settings.fontSize, in: 12...24, step: 1)
        
        Text("\(Int(settings.fontSize))")
          .font(.caption)
          .bold()
      }
      
      Text("预览文本")
        .font(.system(size: settings.fontSize))
        .padding()
        .background(settings.isDarkMode ? Color.black : Color.white)
        .foregroundColor(settings.isDarkMode ? Color.white : Color.black)
        .cornerRadius(8)
      
      Button("重置隔离设置") {
        settings.resetToDefaults()
      }
      .buttonStyle(.bordered)
      .controlSize(.small)
      
      Text("💡 这些设置与其他示例的设置是完全独立的")
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(8)
  }
}

struct EnvironmentObjectValidationExample: View {
  @StateObject private var validationManager = EnvironmentObjectValidationManager()
  
  var body: some View {
    VStack(spacing: 16) {
      Text("状态验证")
        .font(.headline)
      
      ValidationContentView()
    }
    .environmentObject(validationManager)
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

@MainActor
class EnvironmentObjectValidationManager: ObservableObject {
  @Published var testResults: [String] = []
  @Published var isRunningTests = false
  
  func runValidationTests() {
    isRunningTests = true
    testResults.removeAll()
    
    Task {
      // 模拟测试过程
      testResults.append("✅ 环境对象注入测试通过")
      try? await Task.sleep(nanoseconds: 500_000_000)
      
      testResults.append("✅ 状态更新传播测试通过")
      try? await Task.sleep(nanoseconds: 500_000_000)
      
      testResults.append("✅ 视图层级传递测试通过")
      try? await Task.sleep(nanoseconds: 500_000_000)
      
      testResults.append("✅ 内存管理测试通过")
      try? await Task.sleep(nanoseconds: 500_000_000)
      
      testResults.append("🎉 所有验证测试完成!")
      
      self.isRunningTests = false
    }
  }
  
  func clearResults() {
    testResults.removeAll()
  }
}

struct ValidationContentView: View {
  @EnvironmentObject var validationManager: EnvironmentObjectValidationManager
  
  var body: some View {
    VStack(spacing: 12) {
      Text("环境对象状态验证测试")
        .font(.subheadline)
        .bold()
      
      HStack {
        Button("运行验证测试") {
          validationManager.runValidationTests()
        }
        .buttonStyle(.borderedProminent)
        .disabled(validationManager.isRunningTests)
        
        Button("清空结果") {
          validationManager.clearResults()
        }
        .buttonStyle(.bordered)
        .disabled(validationManager.testResults.isEmpty)
      }
      
      if validationManager.isRunningTests {
        HStack {
          ProgressView()
            .controlSize(.small)
          Text("运行测试中...")
            .font(.caption)
        }
      }
      
      if !validationManager.testResults.isEmpty {
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 4) {
            ForEach(validationManager.testResults, id: \.self) { result in
              Text(result)
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
        .frame(height: 100)
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
      }
      
      Text("💡 验证环境对象在不同场景下的行为一致性")
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
  }
}

// MARK: - 辅助扩展

extension DateFormatter {
  static let timeOnly: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()
}

#Preview {
  NavigationView {
    EnvironmentObjectDemoView()
  }
}
