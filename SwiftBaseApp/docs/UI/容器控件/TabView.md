# TabView 选项卡视图

## 1. 基本介绍

### 控件概述

TabView 是 SwiftUI 中的一个容器视图控件，用于创建选项卡式界面。它允许用户通过点击底部的标签页在不同的内容视图之间切换，是 iOS 应用程序中最常用的导航模式之一。

### 使用场景

- 应用程序的主要导航界面
- 分类内容的展示
- 设置或偏好设置界面
- 多页面内容的展示（使用 PageTabViewStyle）

### 主要特性

- 支持多个选项卡页面
- 可自定义选项卡图标和标题
- 支持选项卡徽章（badge）
- 提供分页视图样式
- 支持程序化控制页面切换
- 可以与其他导航控件组合使用

## 2. 基础用法

### 基本示例

1. 基础选项卡界面

```swift
TabView {
    Text("First Tab")
        .tabItem {
            Image(systemName: "1.circle")
            Text("First")
        }
    Text("Second Tab")
        .tabItem {
            Image(systemName: "2.circle")
            Text("Second")
        }
}
```

2. 带徽章的选项卡

```swift
TabView {
    Text("Messages")
        .tabItem {
            Image(systemName: "message")
            Text("Messages")
        }
        .badge(5)

    Text("Profile")
        .tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
}
```

### 常用属性

1. 选项卡项配置

- `tabItem`: 配置选项卡的图标和标题
- `badge`: 在选项卡上显示徽章

2. 选择状态

- `selection`: 绑定当前选中的选项卡

3. 样式设置

- `tabViewStyle`: 设置选项卡视图的样式

## 3. 样式和自定义

### 内置样式

1. 默认样式（DefaultTabViewStyle）

```swift
TabView {
    // 内容
}
.tabViewStyle(.automatic)
```

2. 分页样式（PageTabViewStyle）

```swift
TabView {
    // 内容
}
.tabViewStyle(.page)
```

### 自定义修饰符

1. 自定义选项卡外观

```swift
TabView {
    Text("Content")
        .tabItem {
            Label("Home", systemImage: "house")
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.blue, for: .tabBar)
}
```

2. 自定义选项卡标签

```swift
TabView {
    Text("Content")
        .tabItem {
            VStack {
                Image(systemName: "star.fill")
                Text("Custom")
                    .font(.caption)
            }
        }
}
```

### 主题适配

1. 暗黑模式适配

```swift
TabView {
    Text("Content")
        .tabItem {
            Image(systemName: "moon")
            Text("Dark Mode")
        }
        .preferredColorScheme(.dark)
}
```

## 4. 高级特性

### 组合使用

1. 与 NavigationStack 结合

```swift
TabView {
    NavigationStack {
        List {
            NavigationLink("Detail", value: "detail")
        }
        .navigationTitle("Home")
    }
    .tabItem {
        Label("Home", systemImage: "house")
    }
}
```

2. 与状态管理结合

```swift
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }
                .tag(0)

            Text("Tab 2")
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }
                .tag(1)
        }
    }
}
```

### 动画效果

1. 页面切换动画

```swift
TabView {
    ForEach(pages, id: \.self) { page in
        Text(page)
            .transition(.slide)
    }
}
.tabViewStyle(.page)
.animation(.easeInOut, value: selectedPage)
```

### 状态管理

1. 使用 @State 管理选中状态

```swift
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FirstView()
                .tag(0)
                .tabItem { /* ... */ }

            SecondView()
                .tag(1)
                .tabItem { /* ... */ }
        }
    }
}
```

2. 程序化切换选项卡

```swift
Button("Switch to Second Tab") {
    withAnimation {
        selectedTab = 1
    }
}
```

## 5. 性能优化

### 最佳实践

1. 视图懒加载

- 每个选项卡的内容只有在被选中时才会加载
- 使用 @State 而不是 @StateObject 来管理选项卡状态

2. 内存管理

- 避免在选项卡中持有大量数据
- 使用适当的数据结构和缓存策略

### 常见陷阱

1. 内存泄漏

- 注意清理不再需要的观察者和订阅
- 避免循环引用

2. 性能问题

- 避免在选项卡切换时进行重量级操作
- 合理使用 ViewBuilder 和子视图

### 优化技巧

1. 视图复用

```swift
TabView {
    ForEach(tabs, id: \.id) { tab in
        tab.view
            .tabItem {
                Label(tab.title, systemImage: tab.icon)
            }
    }
}
```

2. 状态隔离

```swift
struct TabContent: View {
    @StateObject private var viewModel = TabViewModel()

    var body: some View {
        // 内容
    }
}
```

## 6. 辅助功能

### 无障碍支持

1. VoiceOver 支持

```swift
TabView {
    Text("Content")
        .tabItem {
            Label("Home", systemImage: "house")
        }
        .accessibilityLabel("Home Tab")
        .accessibilityHint("Shows home content")
}
```

### 本地化

1. 选项卡标题本地化

```swift
TabView {
    Text("Content")
        .tabItem {
            Label(NSLocalizedString("Home", comment: "Home tab"),
                  systemImage: "house")
        }
}
```

### 动态类型

1. 支持动态字体大小

```swift
TabView {
    Text("Content")
        .tabItem {
            Label("Home", systemImage: "house")
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility5)
}
```

## 7. 示例代码

```swift
import SwiftUI

struct TabViewDemoView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    @State private var showPageStyle = false

    // Custom Tab Properties
    @State private var customIcon = "2.circle"
    @State private var customTitle = "自定义"
    @State private var badgeCount = 0
    @State private var backgroundColor = Color.blue.opacity(0.2)
    @State private var fontSize: CGFloat = 17
    @State private var iconSize: CGFloat = 20

    // MARK: - Views
    var body: some View {
        VStack {
            if showPageStyle {
                pageStyleExample
            } else {
                tabStyleExample
            }

            Toggle("使用分页样式", isOn: $showPageStyle)
                .padding()
        }
        .navigationTitle("TabView 示例")
    }

    // MARK: - Basic TabView Example
    private var tabStyleExample: some View {
        TabView(selection: $selectedTab) {
            // First Tab - Basic
            basicTabExample
                .tabItem {
                    Label("基础", systemImage: "1.circle")
                }
                .tag(0)

            // Second Tab - Custom
            customTabExample
                .tabItem {
                    Label(customTitle, systemImage: customIcon)
                        .font(.system(size: iconSize))
                }
                .tag(1)
                .badge(badgeCount)

            // Third Tab - Advanced
            advancedTabExample
                .tabItem {
                    Label("高级", systemImage: "3.circle")
                }
                .tag(2)
        }
    }

    // MARK: - Page Style Example
    private var pageStyleExample: some View {
        TabView {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.opacity(0.2))
                    .overlay(
                        Text("Page \(index + 1)")
                            .font(.largeTitle)
                    )
                    .padding()
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    // MARK: - Basic Tab Content
    private var basicTabExample: some View {
        VStack(spacing: 20) {
            Text("基础 TabView 示例")
                .font(.title)

            Text("这是一个简单的 TabView 示例，展示了基本的选项卡功能。")
                .multilineTextAlignment(.center)
                .padding()

            Button("切换到自定义选项卡") {
                withAnimation {
                    selectedTab = 1
                }
            }
        }
        .padding()
    }

    // MARK: - Custom Tab Content
    private var customTabExample: some View {
        VStack(spacing: 20) {
            Text("自定义 TabView 示例")
                .font(.title)

            List {
                Section("自定义特性") {
                    // 1. 自定义图标
                    Picker("选择图标", selection: $customIcon) {
                        ForEach(["2.circle", "star.fill", "heart.fill", "person.fill", "gear"], id: \.self) { icon in
                            Label(icon, systemImage: icon)
                        }
                    }

                    // 2. 自定义标题
                    HStack {
                        Text("标题：")
                        TextField("输入标题", text: $customTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // 3. 徽章设置
                    Stepper("徽章数量: \(badgeCount)", value: $badgeCount, in: 0...99)
                }

                Section("样式设置") {
                    // 1. 背景色设置
                    ColorPicker("背景颜色", selection: $backgroundColor)

                    // 2. 字体大小设置
                    HStack {
                        Text("字体大小: \(Int(fontSize))")
                        Slider(value: $fontSize, in: 12...24, step: 1)
                    }

                    // 3. 图标大小设置
                    HStack {
                        Text("图标大小: \(Int(iconSize))")
                        Slider(value: $iconSize, in: 16...32, step: 1)
                    }
                }
            }
        }
        .background(backgroundColor)
        .font(.system(size: fontSize))
    }

    // MARK: - Advanced Tab Content
    private var advancedTabExample: some View {
        NavigationStack {
            List {
                Section("高级特性") {
                    NavigationLink("1. 状态管理") {
                        stateManagementExample
                    }

                    NavigationLink("2. 动画效果") {
                        animationExample
                    }

                    NavigationLink("3. 组合使用") {
                        combinationExample
                    }
                }

                Section("辅助功能") {
                    Text("1. VoiceOver 支持")
                        .accessibilityLabel("Voice Over 支持示例")
                        .accessibilityHint("展示如何添加无障碍支持")

                    Text("2. 动态字体")
                        .dynamicTypeSize(...DynamicTypeSize.accessibility5)

                    Text("3. 本地化支持")
                }
            }
            .navigationTitle("高级示例")
        }
    }

    // MARK: - Advanced Examples
    private var stateManagementExample: some View {
        VStack(spacing: 20) {
            Text("状态管理示例")
                .font(.title)

            Text("当前选中的选项卡: \(selectedTab)")

            Button("切换到第一个选项卡") {
                withAnimation {
                    selectedTab = 0
                }
            }
        }
        .padding()
    }

    private var animationExample: some View {
        TabView {
            ForEach(0..<3) { index in
                Text("动画页面 \(index + 1)")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .transition(.slide)
            }
        }
        .tabViewStyle(.page)
        .animation(.easeInOut, value: selectedTab)
    }

    private var combinationExample: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(1...5, id: \.self) { item in
                        NavigationLink("项目 \(item)") {
                            Text("详情 \(item)")
                        }
                    }
                }
                .navigationTitle("组合示例")
            }
            .tabItem {
                Label("列表", systemImage: "list.bullet")
            }

            Text("设置")
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
    }
}

// MARK: - Preview
struct TabViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabViewDemoView()
        }
    }
}

```

## 8. 注意事项

### 常见问题

1. 选项卡数量

- iOS 建议不超过 5 个选项卡
- 选项卡过多会影响用户体验

2. 选项卡内容

- 避免在选项卡之间频繁共享状态
- 保持各个选项卡的独立性

### 兼容性考虑

1. iOS 版本

- TabView 在 iOS 13 及以上版本可用
- 某些特性（如 badge）需要更高版本

2. 设备适配

- 适配不同尺寸的设备
- 考虑横竖屏切换

### 使用建议

1. 设计原则

- 保持选项卡简单明了
- 使用直观的图标
- 提供清晰的标签文本

2. 交互设计

- 提供适当的反馈
- 保持一致的交互模式
- 避免深层嵌套

## 9. 完整运行 Demo

### 源代码

完整的示例代码请参考项目中的 TabViewDemoView.swift 文件。

### 运行说明

1. 在 Xcode 中打开项目
2. 找到 TabViewDemoView.swift 文件
3. 运行项目，导航到 TabView 示例页面

### 功能说明

示例代码展示了：

1. 基本的选项卡界面
2. 带徽章的选项卡
3. 自定义样式的选项卡
4. 分页视图模式
5. 程序化控制选项卡
6. 与其他控件的组合使用
