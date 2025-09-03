# SwiftUI LazyHStack 布局控件完整指南

## 1. 基本介绍

### 1.1 控件概述

LazyHStack 是 SwiftUI 中的延迟加载水平布局容器。与普通的 HStack 不同，它只会在视图即将出现在屏幕上时才创建和加载子视图，这对于处理大量数据或复杂视图时能显著提高性能。

### 1.2 使用场景

- 水平滚动列表
- 图片画廊
- 卡片轮播
- 标签栏
- 商品展示
- 大数据列表

### 1.3 主要特性

- 延迟加载子视图
- 水平滚动支持
- 内存优化
- 支持动态内容
- 支持间距设置
- 支持对齐方式

## 2. 基础用法

### 2.1 基本示例

```swift
// 基本用法
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<100) { index in
            Text("项目 \(index)")
                .padding()
        }
    }
}

// 设置间距
ScrollView(.horizontal) {
    LazyHStack(spacing: 20) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}

// 设置对齐
ScrollView(.horizontal) {
    LazyHStack(alignment: .top, spacing: 10) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
```

### 2.2 常用属性

```swift
// 设置内边距
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
    .padding()
}

// 设置背景
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
    .background(.blue.opacity(0.1))
}

// 设置固定尺寸
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            ItemView(item: item)
                .frame(width: 100, height: 100)
        }
    }
}
```

### 2.3 事件处理

```swift
// 滚动事件
ScrollView(.horizontal) {
    LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// 卡片样式
ScrollView(.horizontal) {
    LazyHStack(spacing: 15) {
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
ScrollView(.horizontal) {
    LazyHStack(spacing: 15) {
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
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            Text(item.title)
                .padding()
                .background(Color(.systemBackground))
                .foregroundColor(Color(.label))
        }
    }
}

// 动态颜色
ScrollView(.horizontal) {
    LazyHStack {
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
// 嵌套布局
ScrollView(.horizontal) {
    LazyHStack(spacing: 15) {
        ForEach(categories) { category in
            VStack(alignment: .leading) {
                Text(category.title)
                    .font(.headline)
                Text(category.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    ForEach(category.tags) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(4)
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
ScrollView(.horizontal) {
    LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
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
        ScrollView(.horizontal) {
            LazyHStack {
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
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 避免重复创建视图

```swift
// 不推荐
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            ComplexView()  // 每次都创建新的视图
        }
    }
}

// 推荐
let complexView = ComplexView()  // 创建一次复用
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            complexView
        }
    }
}
```

2. 使用 ID 优化

```swift
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items, id: \.uniqueID) { item in
            ItemView(item: item)
        }
    }
}
```

3. 合理设置预加载

```swift
ScrollView(.horizontal) {
    LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<1000) { _ in
            ComplexView()  // 创建大量复杂视图
        }
    }
}

// 推荐
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            SimpleView(item: item)  // 使用简单视图
        }
    }
}
```

2. 注意内存使用

```swift
// 使用分页加载
ScrollView(.horizontal) {
    LazyHStack {
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
        ScrollView(.horizontal) {
            LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
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
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            Text(LocalizedStringKey(item.titleKey))
                .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }
}
```

### 6.3 动态类型

```swift
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(items) { item in
            Text(item.title)
                .font(.body)
                .dynamicTypeSize(...DynamicTypeSize.accessibility3)
        }
    }
}
```

## 7. 示例代码

### 7.1 图片画廊

```swift
struct ImageGallery: View {
    let images: [ImageItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(images) { image in
                    AsyncImage(url: image.url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        }
    }
}
```

### 7.2 标签栏

```swift
struct TabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                    VStack {
                        Image(systemName: tab.icon)
                            .font(.title2)
                        Text(tab.title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                    .padding()
                    .background(
                        selectedTab == index ?
                            .blue.opacity(0.1) : .clear
                    )
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            selectedTab = index
                        }
                    }
                }
            }
            .padding()
        }
    }
}
```

### 7.3 商品列表

```swift
struct ProductList: View {
    let products: [Product]
    @State private var selectedProduct: Product?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        AsyncImage(url: product.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text(product.name)
                            .font(.headline)
                            .lineLimit(2)

                        Text(product.price)
                            .font(.subheadline)
                            .foregroundColor(.blue)

                        Button("加入购物车") {
                            // 处理添加到购物车
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 150)
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

## 8. 注意事项

1. 布局考虑

   - 注意子视图的大小和比例
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
struct Item: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let items: [Item]
}

// MARK: - 基础示例
struct BasicLazyHStackExampleView: View {
    let items = (1...20).map { Item(title: "项目 \($0)", color: .random) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(items) { item in
                        Text(item.title)
                            .padding()
                            .background(item.color.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - 卡片示例
struct CardLazyHStackExampleView: View {
    let items = (1...10).map { Item(title: "卡片 \($0)", color: .random) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 卡片示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(items) { item in
                        VStack {
                            Circle()
                                .fill(item.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Text(item.title)
                                .font(.headline)
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
}

// MARK: - 交互示例
struct InteractiveLazyHStackExampleView: View {
    let items = (1...10).map { Item(title: "项目 \($0)", color: .random) }
    @State private var selectedItem: Item?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 交互示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(items) { item in
                        Text(item.title)
                            .padding()
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
                .padding()
            }
        }
    }
}

// MARK: - 图片画廊示例
struct GalleryLazyHStackExampleView: View {
    let images = ["star.fill", "heart.fill", "bell.fill", "person.fill", "gear"]
    @State private var selectedImage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 图片画廊示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(images, id: \.self) { image in
                        Image(systemName: image)
                            .font(.system(size: 40))
                            .frame(width: 100, height: 100)
                            .background(
                                selectedImage == image ?
                                    .blue.opacity(0.2) :
                                    .gray.opacity(0.1)
                            )
                            .cornerRadius(12)
                            .onTapGesture {
                                withAnimation {
                                    selectedImage = image
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - 分类示例
struct CategoryLazyHStackExampleView: View {
    let categories = [
        Category(title: "类别1", items: (1...5).map { Item(title: "项目1-\($0)", color: .blue) }),
        Category(title: "类别2", items: (1...5).map { Item(title: "项目2-\($0)", color: .green) }),
        Category(title: "类别3", items: (1...5).map { Item(title: "项目3-\($0)", color: .orange) })
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 分类示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 15) {
                    ForEach(categories) { category in
                        VStack(alignment: .leading) {
                            Text(category.title)
                                .font(.headline)

                            ForEach(category.items) { item in
                                Text(item.title)
                                    .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .frame(width: 150)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                    }
                }
                .padding()
            }
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
struct LazyHStackDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicLazyHStackExampleView()
                CardLazyHStackExampleView()
                InteractiveLazyHStackExampleView()
                GalleryLazyHStackExampleView()
                CategoryLazyHStackExampleView()
            }
            .padding()
        }
        .navigationTitle("延迟水平布局 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        LazyHStackDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `LazyHStackDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct LazyHStackDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LazyHStackDemoView()
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

4. 图片画廊示例

   - 系统图标
   - 网格布局
   - 选中效果

5. 分类示例
   - 垂直布局
   - 分组显示
   - 滚动效果

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互和动画效果
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
