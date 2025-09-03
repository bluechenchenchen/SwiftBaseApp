# SwiftUI LazyVStack 布局控件完整指南

## 1. 基本介绍

### 1.1 控件概述

LazyVStack 是 SwiftUI 中的延迟加载垂直布局容器。与普通的 VStack 不同，它只会在视图即将出现在屏幕上时才创建和加载子视图，这对于处理大量数据或复杂视图时能显著提高性能。

### 1.2 使用场景

- 长列表布局
- 新闻流
- 社交媒体流
- 商品列表
- 设置页面
- 聊天记录

### 1.3 主要特性

- 延迟加载子视图
- 垂直滚动支持
- 内存优化
- 支持动态内容
- 支持间距设置
- 支持对齐方式

## 2. 基础用法

### 2.1 基本示例

```swift
// 基本用法
ScrollView {
    LazyVStack {
        ForEach(0..<100) { index in
            Text("项目 \(index)")
                .padding()
        }
    }
}

// 设置间距
ScrollView {
    LazyVStack(spacing: 20) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}

// 设置对齐
ScrollView {
    LazyVStack(alignment: .leading, spacing: 10) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
```

### 2.2 常用属性

```swift
// 设置内边距
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
    .padding()
}

// 设置背景
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
    .background(.blue.opacity(0.1))
}

// 设置固定尺寸
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
                .frame(height: 100)
        }
    }
}
```

### 2.3 事件处理

```swift
// 滚动事件
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
                .onAppear {
                    // 视图出现时的处理
                    handleItemAppear(item)
                }
                .onDisappear {
                    // 视图消失时的处理
                    handleItemDisappear(item)
                }
        }
    }
}

// 点击事件
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
                .onTapGesture {
                    handleItemTap(item)
                }
        }
    }
}
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 基本样式
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// 卡片样式
ScrollView {
    LazyVStack(spacing: 15) {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 3)
        }
    }
    .padding()
}
```

### 3.2 自定义修饰符

```swift
struct LazyCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

// 使用自定义样式
ScrollView {
    LazyVStack(spacing: 15) {
        ForEach(items) { item in
            Text(item.title)
                .modifier(LazyCardStyle())
        }
    }
    .padding()
}
```

### 3.3 主题适配

```swift
// 深色模式适配
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(Color(.systemBackground))
                .foregroundColor(Color(.label))
        }
    }
}

// 动态颜色
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}
```

## 4. 高级特性

### 4.1 组合使用

```swift
// 新闻列表布局
ScrollView {
    LazyVStack(spacing: 15) {
        ForEach(articles) { article in
            HStack(alignment: .top) {
                AsyncImage(url: article.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.headline)
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    HStack {
                        Text(article.author)
                            .font(.caption)
                        Spacer()
                        Text(article.date)
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
    .padding()
}
```

### 4.2 动画效果

```swift
// 滚动动画
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .scaleEffect(selectedItem == item ? 1.1 : 1.0)
                .animation(.spring(), value: selectedItem)
                .onTapGesture {
                    withAnimation {
                        selectedItem = item
                    }
                }
        }
    }
}

// 渐变动画
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .opacity(item.isVisible ? 1 : 0)
                .animation(.easeInOut, value: item.isVisible)
                .onAppear {
                    withAnimation {
                        item.isVisible = true
                    }
                }
        }
    }
}
```

### 4.3 状态管理

```swift
struct LazyLoadingView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in
                    ItemView(item: item)
                        .onAppear {
                            if item == viewModel.items.last {
                                viewModel.loadMoreItems()
                            }
                        }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 避免重复创建视图

```swift
// 不推荐
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ComplexView()  // 每次都创建新的视图
        }
    }
}

// 推荐
let complexView = ComplexView()  // 创建一次复用
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            complexView
        }
    }
}
```

2. 使用 ID 优化

```swift
ScrollView {
    LazyVStack {
        ForEach(items, id: \.uniqueID) { item in
            ItemView(item: item)
        }
    }
}
```

3. 合理设置预加载

```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
                .onAppear {
                    if items.index(of: item) == items.count - 5 {
                        loadMoreItems()  // 提前加载更多
                    }
                }
        }
    }
}
```

### 5.2 常见陷阱

1. 避免在循环中创建大量视图

```swift
// 不推荐
ScrollView {
    LazyVStack {
        ForEach(0..<1000) { _ in
            ComplexView()  // 创建大量复杂视图
        }
    }
}

// 推荐
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            SimpleView(item: item)  // 使用简单视图
        }
    }
}
```

2. 注意内存使用

```swift
// 使用分页加载
ScrollView {
    LazyVStack {
        ForEach(viewModel.currentPageItems) { item in
            ItemView(item: item)
        }
    }
}
```

### 5.3 优化技巧

```swift
// 使用占位视图
struct LazyLoadingView: View {
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items) { item in
                    if item.isLoaded {
                        ItemView(item: item)
                    } else {
                        PlaceholderView()
                            .onAppear {
                                loadItem(item)
                            }
                    }
                }
            }
        }
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .accessibilityLabel(item.accessibilityLabel)
                .accessibilityHint(item.accessibilityHint)
        }
    }
}
```

### 6.2 本地化

```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(LocalizedStringKey(item.titleKey))
                .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }
}
```

### 6.3 动态类型

```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            Text(item.title)
                .font(.body)
                .dynamicTypeSize(...DynamicTypeSize.accessibility3)
        }
    }
}
```

## 7. 示例代码

### 7.1 社交媒体流

```swift
struct SocialFeed: View {
    let posts: [Post]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(posts) { post in
                    VStack(alignment: .leading, spacing: 12) {
                        // 用户信息
                        HStack {
                            AsyncImage(url: post.userAvatar) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(post.userName)
                                    .font(.headline)
                                Text(post.timestamp)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button {
                                // 更多操作
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }

                        // 帖子内容
                        Text(post.content)
                            .font(.body)

                        if let image = post.image {
                            AsyncImage(url: image) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // 交互按钮
                        HStack(spacing: 20) {
                            Button {
                                // 点赞
                            } label: {
                                Label("\(post.likes)", systemImage: "heart")
                            }

                            Button {
                                // 评论
                            } label: {
                                Label("\(post.comments)", systemImage: "bubble.right")
                            }

                            Button {
                                // 分享
                            } label: {
                                Label("分享", systemImage: "square.and.arrow.up")
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 3)
                }
            }
            .padding()
        }
    }
}
```

### 7.2 设置页面

```swift
struct SettingsView: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var volume = 0.5
    @State private var selectedTheme = 0

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // 用户信息
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                    Text("用户名")
                        .font(.headline)
                    Text("用户ID: 123456")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))

                // 设置项
                Group {
                    Toggle("通知", isOn: $notifications)
                        .padding()

                    Divider()

                    Toggle("深色模式", isOn: $darkMode)
                        .padding()

                    Divider()

                    VStack(alignment: .leading) {
                        Text("音量")
                        Slider(value: $volume)
                    }
                    .padding()

                    Divider()

                    VStack(alignment: .leading) {
                        Text("主题")
                        Picker("", selection: $selectedTheme) {
                            Text("默认").tag(0)
                            Text("经典").tag(1)
                            Text("现代").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                }
                .background(Color(.systemBackground))

                // 账户操作
                Group {
                    Button("修改密码") {
                        // 处理修改密码
                    }
                    .padding()

                    Divider()

                    Button("清除缓存") {
                        // 处理清除缓存
                    }
                    .padding()

                    Divider()

                    Button("退出登录") {
                        // 处理退出登录
                    }
                    .foregroundColor(.red)
                    .padding()
                }
                .background(Color(.systemBackground))
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
```

### 7.3 聊天记录

```swift
struct ChatView: View {
    let messages: [Message]
    @State private var newMessage = ""

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isFromMe {
                                Spacer()
                                MessageBubble(message: message, isFromMe: true)
                            } else {
                                MessageBubble(message: message, isFromMe: false)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }

            // 输入框
            HStack {
                TextField("输入消息", text: $newMessage)
                    .textFieldStyle(.roundedBorder)

                Button {
                    // 发送消息
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isFromMe: Bool

    var body: some View {
        VStack(alignment: isFromMe ? .trailing : .leading) {
            if !isFromMe {
                Text(message.sender)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(message.content)
                .padding()
                .background(isFromMe ? .blue : Color(.systemGray5))
                .foregroundColor(isFromMe ? .white : .primary)
                .cornerRadius(16)

            Text(message.time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
```

## 8. 注意事项

1. 布局考虑

   - 注意子视图的高度和比例
   - 合理设置间距
   - 考虑不同屏幕尺寸的适配

2. 性能考虑

   - 避免加载过多数据
   - 使用分页加载
   - 注意内存使用

3. 可访问性

   - 提供适当的无障碍标签
   - 支持动态字体
   - 考虑本地化需求

4. 动画和交互
   - 使用适当的动画效果
   - 提供清晰的交互反馈
   - 注意动画性能

## 9. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI

// MARK: - 数据模型
struct LazyItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let color: Color

    static func == (lhs: LazyItem, rhs: LazyItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct LazyCategory: Identifiable {
    let id = UUID()
    let title: String
    let items: [LazyItem]
}

// MARK: - 基础示例
struct BasicLazyVStackExampleView: View {
    let items = (1...20).map { LazyItem(title: "项目 \($0)", color: .random) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础示例").font(.title)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(items) { item in
                        Text(item.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(item.color.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 200)
        }
    }
}

// MARK: - 卡片示例
struct CardLazyVStackExampleView: View {
    let items = (1...10).map { LazyItem(title: "卡片 \($0)", color: .random) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 卡片示例").font(.title)

            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(items) { item in
                        HStack {
                            Circle()
                                .fill(item.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Text(item.title)
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 300)
        }
    }
}

// MARK: - 交互示例
struct InteractiveLazyVStackExampleView: View {
    let items = (1...10).map { LazyItem(title: "项目 \($0)", color: .random) }
    @State private var selectedItem: LazyItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 交互示例").font(.title)

            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(items) { item in
                        Text(item.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedItem?.id == item.id ?
                                    item.color.opacity(0.4) :
                                    item.color.opacity(0.2)
                            )
                            .cornerRadius(8)
                            .scaleEffect(selectedItem?.id == item.id ? 1.1 : 1.0)
                            .animation(.spring(), value: selectedItem)
                            .onTapGesture {
                                withAnimation {
                                    selectedItem = item
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
    }
}

// MARK: - 列表示例
struct ListLazyVStackExampleView: View {
    let items = (1...10).map { LazyItem(title: "列表项 \($0)", color: .random) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 列表示例").font(.title)

            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(items) { item in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(item.color)
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                }
            }
            .frame(height: 300)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - 设置示例
struct SettingsLazyVStackExampleView: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var volume = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 设置示例").font(.title)

            ScrollView {
                LazyVStack(spacing: 0) {
                    Toggle("通知", isOn: $notifications)
                        .padding()

                    Divider()

                    Toggle("深色模式", isOn: $darkMode)
                        .padding()

                    Divider()

                    VStack(alignment: .leading) {
                        Text("音量")
                        Slider(value: $volume)
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            .frame(height: 200)
        }
    }
}

// MARK: - 辅助扩展
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// MARK: - 主视图
struct LazyVStackDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicLazyVStackExampleView()
                CardLazyVStackExampleView()
                InteractiveLazyVStackExampleView()
                ListLazyVStackExampleView()
                SettingsLazyVStackExampleView()
            }
            .padding()
        }
        .navigationTitle("延迟垂直布局 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        LazyVStackDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `LazyVStackDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct LazyVStackDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LazyVStackDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础示例

   - 基本用法
   - 间距设置
   - 颜色随机

2. 卡片示例

   - 圆形图标
   - 阴影效果
   - 圆角设计

3. 交互示例

   - 点击选中
   - 动画效果
   - 状态管理

4. 列表示例

   - 系统风格
   - 分割线
   - 图标装饰

5. 设置示例
   - 开关控件
   - 滑块控件
   - 分组布局

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互和动画效果
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
