# @EnvironmentObject 和依赖注入

## 基本介绍

`@EnvironmentObject` 是 SwiftUI 中用于全局状态管理和依赖注入的属性包装器。它允许你在应用的任意层级的视图中访问共享的可观察对象，而无需通过视图层级逐层传递。

### 概念解释

在前端开发中，这就像是 React 的 Context API 或 Vue 的 provide/inject 机制。你可以在应用的顶层"提供"一个对象，然后在任何子组件中"注入"使用它，而不需要通过 props 一层层传递。

### 使用场景

1. **全局状态管理** - 用户登录状态、主题设置、应用配置等
2. **跨组件通信** - 多个不相关组件需要共享数据
3. **依赖注入** - 服务对象、数据管理器的注入
4. **避免 Prop Drilling** - 避免通过多层视图传递数据

### 主要特性

- **全局访问** - 在任意视图中访问环境对象
- **自动依赖注入** - SwiftUI 自动管理对象的生命周期
- **类型安全** - 编译时类型检查
- **性能优化** - 只有使用了环境对象的视图才会更新

## 基础用法

### 1. 创建可观察对象

```swift
class UserSettings: ObservableObject {
    @Published var isDarkMode = false
    @Published var fontSize: Double = 16
    @Published var language = "中文"
}
```

### 2. 在应用根部提供环境对象

```swift
@main
struct MyApp: App {
    @StateObject private var userSettings = UserSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
        }
    }
}
```

### 3. 在视图中使用环境对象

```swift
struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            Toggle("深色模式", isOn: $userSettings.isDarkMode)
            Slider(value: $userSettings.fontSize, in: 12...24)
        }
    }
}
```

## 样式和自定义

### 环境对象的作用域

```swift
struct ParentView: View {
    @StateObject private var sharedData = SharedDataModel()

    var body: some View {
        NavigationView {
            VStack {
                ChildView1()
                ChildView2()
            }
        }
        .environmentObject(sharedData) // 作用域限定在这个视图树
    }
}
```

### 多个环境对象

```swift
struct ContentView: View {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var appState = AppState()

    var body: some View {
        MainView()
            .environmentObject(userSettings)
            .environmentObject(appState)
    }
}
```

### 条件性环境对象

```swift
struct ConditionalEnvironmentView: View {
    @State private var useSpecialMode = false
    @StateObject private var normalData = NormalDataModel()
    @StateObject private var specialData = SpecialDataModel()

    var body: some View {
        ContentView()
            .environmentObject(useSpecialMode ? specialData : normalData)
    }
}
```

## 高级特性

### 1. 嵌套环境对象

```swift
// 全局用户设置
class GlobalSettings: ObservableObject {
    @Published var appTheme = "light"
}

// 页面特定设置
class PageSettings: ObservableObject {
    @Published var showAdvancedOptions = false
}

struct AppView: View {
    @StateObject private var globalSettings = GlobalSettings()

    var body: some View {
        PageView()
            .environmentObject(globalSettings)
    }
}

struct PageView: View {
    @StateObject private var pageSettings = PageSettings()
    @EnvironmentObject var globalSettings: GlobalSettings

    var body: some View {
        DetailView()
            .environmentObject(pageSettings)
    }
}

struct DetailView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var pageSettings: PageSettings

    var body: some View {
        // 可以同时访问两个环境对象
        Text("主题: \(globalSettings.appTheme)")
        Toggle("高级选项", isOn: $pageSettings.showAdvancedOptions)
    }
}
```

### 2. 环境对象的生命周期管理

```swift
class DataManager: ObservableObject {
    @Published var data: [String] = []

    init() {
        print("DataManager 初始化")
        loadData()
    }

    deinit {
        print("DataManager 销毁")
        cleanup()
    }

    func loadData() {
        // 加载数据
    }

    func cleanup() {
        // 清理资源
    }
}
```

### 3. 组合使用不同的属性包装器

```swift
struct ComplexView: View {
    @StateObject private var localManager = LocalDataManager()
    @EnvironmentObject var globalSettings: GlobalSettings
    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                DataListView()
            }
        }
        .onAppear {
            loadDataBasedOnSettings()
        }
    }

    private func loadDataBasedOnSettings() {
        // 根据全局设置加载本地数据
        localManager.loadData(theme: globalSettings.appTheme)
    }
}
```

## 性能优化

### 1. 避免不必要的环境对象订阅

```swift
// ❌ 不好的做法 - 整个视图订阅了环境对象
struct BadExample: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            StaticHeaderView()
            DynamicContentView()
            StaticFooterView()
        }
    }
}

// ✅ 好的做法 - 只在需要的地方订阅
struct GoodExample: View {
    var body: some View {
        VStack {
            StaticHeaderView()
            DynamicContentView() // 只有这个视图使用环境对象
            StaticFooterView()
        }
    }
}

struct DynamicContentView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        Text("字体大小: \(userSettings.fontSize)")
    }
}
```

### 2. 使用计算属性优化性能

```swift
class OptimizedSettings: ObservableObject {
    @Published private var _fontSize: Double = 16
    @Published private var _isDarkMode = false

    // 使用计算属性避免频繁发布
    var displayFontSize: String {
        "\(Int(_fontSize))pt"
    }

    var themeDescription: String {
        _isDarkMode ? "深色主题" : "浅色主题"
    }

    // 批量更新
    func updateTheme(fontSize: Double, isDarkMode: Bool) {
        _fontSize = fontSize
        _isDarkMode = isDarkMode
    }
}
```

### 3. 环境对象的分割策略

```swift
// 按功能分割环境对象
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
}

class ThemeManager: ObservableObject {
    @Published var isDarkMode = false
    @Published var accentColor = Color.blue
}

class AppSettings: ObservableObject {
    @Published var language = "zh"
    @Published var enableNotifications = true
}

// 在需要的地方分别注入
struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    // 不需要其他管理器
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appSettings: AppSettings
    // 不需要认证管理器
}
```

## 示例代码

### 基础示例 - 全局设置管理

```swift
// 全局设置模型
class AppSettings: ObservableObject {
    @Published var isDarkMode = false
    @Published var fontSize: Double = 16
    @Published var language = "中文"

    let availableLanguages = ["中文", "English", "日本語"]

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func updateFontSize(_ size: Double) {
        fontSize = max(12, min(24, size))
    }
}

// 应用入口
@main
struct EnvironmentObjectApp: App {
    @StateObject private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appSettings)
        }
    }
}

// 主界面
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("首页", systemImage: "house") }

            SettingsView()
                .tabItem { Label("设置", systemImage: "gear") }
        }
    }
}

// 设置页面
struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        NavigationView {
            Form {
                Section("外观") {
                    Toggle("深色模式", isOn: $appSettings.isDarkMode)

                    HStack {
                        Text("字体大小")
                        Slider(value: $appSettings.fontSize, in: 12...24, step: 1)
                        Text("\(Int(appSettings.fontSize))")
                    }
                }

                Section("语言") {
                    Picker("语言", selection: $appSettings.language) {
                        ForEach(appSettings.availableLanguages, id: \.self) { lang in
                            Text(lang).tag(lang)
                        }
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

// 首页使用设置
struct HomeView: View {
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("欢迎")
                    .font(.system(size: appSettings.fontSize))
                    .fontWeight(.bold)

                Text("当前语言: \(appSettings.language)")
                    .font(.system(size: appSettings.fontSize))

                Text("主题: \(appSettings.isDarkMode ? "深色" : "浅色")")
                    .font(.system(size: appSettings.fontSize))
            }
            .padding()
            .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
            .navigationTitle("首页")
        }
    }
}
```

### 进阶示例 - 购物车应用

```swift
// 商品模型
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let category: String
}

// 购物车项目
struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

// 购物车管理器
class ShoppingCart: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var discountPercentage: Double = 0

    var subtotal: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var discountAmount: Double {
        subtotal * discountPercentage / 100
    }

    var total: Double {
        subtotal - discountAmount
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func addItem(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
    }

    func updateQuantity(for item: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if quantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = quantity
        }
    }

    func applyDiscount(_ percentage: Double) {
        discountPercentage = max(0, min(100, percentage))
    }

    func clearCart() {
        items.removeAll()
        discountPercentage = 0
    }
}

// 商品展示视图
struct ProductGridView: View {
    @EnvironmentObject var shoppingCart: ShoppingCart

    private let products = [
        Product(name: "iPhone 15", price: 5999, category: "手机"),
        Product(name: "iPad Air", price: 3799, category: "平板"),
        Product(name: "MacBook Pro", price: 12999, category: "笔记本"),
        Product(name: "AirPods Pro", price: 1899, category: "耳机")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding()
            }
            .navigationTitle("商品")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        ZStack {
                            Image(systemName: "cart")
                            if shoppingCart.itemCount > 0 {
                                Text("\(shoppingCart.itemCount)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var shoppingCart: ShoppingCart

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    Text(product.name)
                        .font(.caption)
                        .bold()
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("¥\(product.price, specifier: "%.0f")")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
            }

            Button("加入购物车") {
                shoppingCart.addItem(product)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// 购物车视图
struct CartView: View {
    @EnvironmentObject var shoppingCart: ShoppingCart

    var body: some View {
        VStack {
            if shoppingCart.items.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)

                    Text("购物车是空的")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(shoppingCart.items.enumerated()), id: \.element.id) { index, item in
                        CartItemRowView(item: item, index: index)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            shoppingCart.removeItem(at: index)
                        }
                    }
                }

                CartSummaryView()
            }
        }
        .navigationTitle("购物车")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !shoppingCart.items.isEmpty {
                    Button("清空") {
                        shoppingCart.clearCart()
                    }
                }
            }
        }
    }
}

struct CartItemRowView: View {
    let item: CartItem
    let index: Int
    @EnvironmentObject var shoppingCart: ShoppingCart

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)

                Text("¥\(item.product.price, specifier: "%.0f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack {
                Button("-") {
                    shoppingCart.updateQuantity(for: item, quantity: item.quantity - 1)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Text("\(item.quantity)")
                    .frame(minWidth: 30)

                Button("+") {
                    shoppingCart.updateQuantity(for: item, quantity: item.quantity + 1)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CartSummaryView: View {
    @EnvironmentObject var shoppingCart: ShoppingCart
    @State private var discountCode = ""

    var body: some View {
        VStack(spacing: 16) {
            // 优惠码输入
            HStack {
                TextField("优惠码", text: $discountCode)
                    .textFieldStyle(.roundedBorder)

                Button("应用") {
                    applyDiscountCode()
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            // 价格明细
            VStack(spacing: 8) {
                HStack {
                    Text("小计")
                    Spacer()
                    Text("¥\(shoppingCart.subtotal, specifier: "%.2f")")
                }

                if shoppingCart.discountPercentage > 0 {
                    HStack {
                        Text("优惠 (\(shoppingCart.discountPercentage, specifier: "%.0f")%)")
                        Spacer()
                        Text("-¥\(shoppingCart.discountAmount, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                }

                Divider()

                HStack {
                    Text("总计")
                        .font(.headline)
                    Spacer()
                    Text("¥\(shoppingCart.total, specifier: "%.2f")")
                        .font(.headline)
                        .bold()
                }
            }
            .padding(.horizontal)

            Button("结算") {
                // 结算逻辑
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.gray.opacity(0.1))
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
```

## 注意事项

### 常见问题

1. **忘记提供环境对象**

```swift
// ❌ 运行时崩溃
struct ContentView: View {
    var body: some View {
        ChildView() // 如果 ChildView 使用了 @EnvironmentObject，但没有提供，会崩溃
    }
}

// ✅ 正确做法
struct ContentView: View {
    @StateObject private var data = DataModel()

    var body: some View {
        ChildView()
            .environmentObject(data)
    }
}
```

2. **类型不匹配**

```swift
class DataModel: ObservableObject { }
class UserModel: ObservableObject { }

struct ParentView: View {
    @StateObject private var dataModel = DataModel()

    var body: some View {
        ChildView()
            .environmentObject(dataModel) // 提供 DataModel
    }
}

struct ChildView: View {
    @EnvironmentObject var userModel: UserModel // ❌ 期望 UserModel，但提供的是 DataModel

    var body: some View {
        Text("Hello")
    }
}
```

### 兼容性考虑

- `@EnvironmentObject` 在 iOS 13.0+ 可用
- 在 Xcode Preview 中使用时需要提供环境对象
- 测试时需要模拟环境对象

### 使用建议

1. **保持环境对象简单** - 避免过于复杂的嵌套结构
2. **按功能分割** - 不同功能使用不同的环境对象
3. **避免过度使用** - 只在真正需要全局访问时使用
4. **注意内存管理** - 环境对象的生命周期与提供它的视图相关

## 完整运行 Demo

### 源代码

以上示例代码展示了 `@EnvironmentObject` 的完整用法，包括：

1. **基础全局设置管理** - 演示如何在应用级别管理设置
2. **购物车应用** - 演示复杂的状态管理和跨视图通信

### 运行说明

1. 将代码复制到 SwiftUI 项目中
2. 确保在应用入口正确设置环境对象
3. 运行应用查看效果

### 功能说明

- **自动依赖注入** - 视图自动获取所需的环境对象
- **状态同步** - 环境对象状态变化时，所有使用它的视图自动更新
- **类型安全** - 编译时检查环境对象类型
- **性能优化** - 只有实际使用环境对象的视图才会重新渲染

这个 Demo 展示了 `@EnvironmentObject` 在实际应用中的强大功能，帮助你理解如何构建可扩展的 SwiftUI 应用架构。
