# SwiftUI HStack 布局控件完整指南

## 1. 基本介绍

### 1.1 控件概述

HStack 是 SwiftUI 中用于水平排列视图的基础布局容器。它将子视图按照从左到右（或从右到左，取决于本地化设置）的顺序排列。

### 1.2 使用场景

- 工具栏布局
- 列表项布局
- 按钮组布局
- 标签栏布局
- 表单行布局
- 卡片内容布局

### 1.3 主要特性

- 水平排列子视图
- 支持间距设置
- 支持对齐方式
- 自动适应内容大小
- 支持动态内容
- 支持本地化布局

## 2. 基础用法

### 2.1 基本示例

```swift
// 基本用法
HStack {
    Text("左侧")
    Text("中间")
    Text("右侧")
}

// 设置间距
HStack(spacing: 20) {
    Text("间距")
    Text("20")
    Text("点")
}

// 设置对齐
HStack(alignment: .center) {
    Text("顶部")
    Text("中间")
    Text("底部")
}
```

### 2.2 常用属性

```swift
// 设置间距和对齐
HStack(alignment: .firstTextBaseline, spacing: 10) {
    Text("标题").font(.title)
    Text("副标题").font(.subheadline)
}

// 设置内边距
HStack {
    Text("内容")
}
.padding()

// 设置背景
HStack {
    Text("带背景")
}
.background(.blue.opacity(0.1))
.cornerRadius(8)
```

### 2.3 事件处理

```swift
// 点击事件
HStack {
    Text("点击")
}
.onTapGesture {
    handleTap()
}

// 长按事件
HStack {
    Text("长按")
}
.onLongPressGesture {
    handleLongPress()
}
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 边框样式
HStack {
    Text("边框样式")
}
.border(.blue)

// 阴影样式
HStack {
    Text("阴影样式")
}
.shadow(radius: 5)

// 圆角样式
HStack {
    Text("圆角样式")
}
.background(.blue.opacity(0.1))
.cornerRadius(8)
```

### 3.2 自定义修饰符

```swift
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

// 使用自定义样式
HStack {
    Image(systemName: "star.fill")
    Text("自定义样式")
}
.modifier(CardStyle())
```

### 3.3 主题适配

```swift
// 深色模式适配
HStack {
    Text("主题适配")
}
.background(Color(.systemBackground))
.foregroundColor(Color(.label))

// 动态颜色
HStack {
    Text("动态颜色")
}
.background(Color(.secondarySystemBackground))
.foregroundColor(Color(.secondaryLabel))
```

## 4. 高级特性

### 4.1 组合使用

```swift
// 嵌套布局
VStack {
    HStack {
        Image(systemName: "person.fill")
        VStack(alignment: .leading) {
            Text("用户名")
            Text("详细信息")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        Spacer()
        Image(systemName: "chevron.right")
    }
    .padding()

    Divider()

    HStack {
        Image(systemName: "gear")
        Text("设置")
        Spacer()
    }
    .padding()
}
```

### 4.2 动画效果

```swift
// 展开/收起动画
@State private var isExpanded = false

HStack {
    Image(systemName: "info.circle")
    if isExpanded {
        Text("详细信息")
            .transition(.slide)
    }
}
.onTapGesture {
    withAnimation {
        isExpanded.toggle()
    }
}

// 渐变动画
@State private var isHighlighted = false

HStack {
    Text("动画效果")
}
.background(isHighlighted ? .blue : .clear)
.animation(.easeInOut, value: isHighlighted)
.onTapGesture {
    isHighlighted.toggle()
}
```

### 4.3 状态管理

```swift
struct DynamicHStack: View {
    @State private var items: [String] = ["项目1", "项目2"]

    var body: some View {
        VStack {
            HStack {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            Button("添加") {
                withAnimation {
                    items.append("项目\(items.count + 1)")
                }
            }
        }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 避免过多嵌套

```swift
// 不推荐
HStack {
    HStack {
        HStack {
            Text("过度嵌套")
        }
    }
}

// 推荐
HStack {
    Text("适当嵌套")
}
```

2. 使用 Group 组合视图

```swift
HStack {
    Group {
        Text("项目1")
        Text("项目2")
        Text("项目3")
    }
    .font(.body)
    .foregroundColor(.blue)
}
```

3. 合理使用 Spacer

```swift
HStack {
    Text("左对齐")
    Spacer()  // 推送内容到左侧
}
```

### 5.2 常见陷阱

1. 避免固定宽度

```swift
// 不推荐
HStack {
    Text("固定宽度")
        .frame(width: 200)  // 可能导致布局问题
}

// 推荐
HStack {
    Text("灵活宽度")
        .frame(maxWidth: 200)  // 允许自适应
}
```

2. 处理溢出

```swift
HStack {
    Text("很长的文本内容...")
        .lineLimit(1)  // 限制行数
        .truncationMode(.tail)  // 显示省略号
}
```

### 5.3 优化技巧

```swift
// 使用 LazyHStack 延迟加载
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<1000) { index in
            Text("项目 \(index)")
                .padding()
        }
    }
}

// 条件渲染
HStack {
    if shouldShowLeadingIcon {
        Image(systemName: "star")
    }
    Text("内容")
    if shouldShowTrailingIcon {
        Image(systemName: "chevron.right")
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
HStack {
    Image(systemName: "person.fill")
    Text("用户信息")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("用户信息按钮")
.accessibilityHint("点击查看用户详细信息")
```

### 6.2 本地化

```swift
HStack {
    Text("hello")
        .environment(\.layoutDirection, .leftToRight)
    Text("مرحبا")
        .environment(\.layoutDirection, .rightToLeft)
}
```

### 6.3 动态类型

```swift
HStack {
    Text("支持动态字体")
}
.font(.body)
.dynamicTypeSize(...DynamicTypeSize.accessibility3)
```

## 7. 示例代码

### 7.1 工具栏布局

```swift
struct ToolbarView: View {
    var body: some View {
        HStack(spacing: 16) {
            Button(action: handleBack) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Button(action: handleShare) {
                Image(systemName: "square.and.arrow.up")
            }

            Button(action: handleMore) {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
```

### 7.2 列表项布局

```swift
struct ListItemView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
                .background(.blue.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
```

### 7.3 卡片布局

```swift
struct CardView: View {
    let title: String
    let description: String
    let image: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                HStack {
                    Button("详情") {
                        // 处理详情按钮点击
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("分享") {
                        // 处理分享按钮点击
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
```

## 8. 注意事项

1. 布局考虑

   - 注意子视图的大小和比例
   - 合理使用 Spacer 和 padding
   - 考虑不同屏幕尺寸的适配

2. 性能考虑

   - 避免过度嵌套
   - 合理使用 LazyHStack
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

// MARK: - 基础示例
struct BasicHStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础示例").font(.title)

            Group {
                // 基本用法
                HStack {
                    Text("左侧")
                    Text("中间")
                    Text("右侧")
                }
                .background(.blue.opacity(0.1))

                // 设置间距
                HStack(spacing: 20) {
                    Text("间距")
                    Text("20")
                    Text("点")
                }
                .background(.green.opacity(0.1))

                // 设置对齐
                HStack(alignment: .firstTextBaseline) {
                    Text("基线").font(.title)
                    Text("对齐").font(.body)
                    Text("示例").font(.caption)
                }
                .background(.yellow.opacity(0.1))
            }
        }
    }
}

// MARK: - 样式示例
struct StyleHStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 样式示例").font(.title)

            Group {
                // 边框样式
                HStack {
                    Image(systemName: "star.fill")
                    Text("边框样式")
                }
                .padding()
                .border(.blue)

                // 阴影样式
                HStack {
                    Image(systemName: "moon.fill")
                    Text("阴影样式")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 3)

                // 自定义样式
                HStack {
                    Image(systemName: "sun.max.fill")
                    Text("自定义样式")
                }
                .modifier(CardStyle())
            }
        }
    }
}

// MARK: - 交互示例
struct InteractiveHStackExampleView: View {
    @State private var isExpanded = false
    @State private var isHighlighted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 交互示例").font(.title)

            Group {
                // 展开/收起
                HStack {
                    Image(systemName: "info.circle")
                    if isExpanded {
                        Text("详细信息")
                            .transition(.slide)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

                // 高亮效果
                HStack {
                    Image(systemName: "star.fill")
                    Text("点击高亮")
                }
                .padding()
                .background(isHighlighted ? .blue.opacity(0.2) : .clear)
                .cornerRadius(8)
                .animation(.easeInOut, value: isHighlighted)
                .onTapGesture {
                    isHighlighted.toggle()
                }
            }
        }
    }
}

// MARK: - 列表示例
struct ListHStackExampleView: View {
    let items = ["收藏", "下载", "分享", "设置"]
    let icons = ["star.fill", "arrow.down.circle", "square.and.arrow.up", "gear"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 列表示例").font(.title)

            ForEach(Array(zip(items, icons)), id: \.0) { item, icon in
                HStack {
                    Image(systemName: icon)
                        .frame(width: 32, height: 32)
                        .background(.blue.opacity(0.1))
                        .cornerRadius(8)

                    Text(item)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 2)
            }
        }
    }
}

// MARK: - 卡片示例
struct CardHStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 卡片示例").font(.title)

            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .background(.blue.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("卡片标题")
                        .font(.headline)
                    Text("这是一段较长的描述文本，用来演示卡片布局的效果。可以包含多行内容，并且会自动换行。")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)

                    HStack {
                        Button("详情") {}
                            .buttonStyle(.bordered)

                        Spacer()

                        Button("分享") {}
                            .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
}

// MARK: - 自定义样式
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

// MARK: - 主视图
struct HStackDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicHStackExampleView()
                StyleHStackExampleView()
                InteractiveHStackExampleView()
                ListHStackExampleView()
                CardHStackExampleView()
            }
            .padding()
        }
        .navigationTitle("水平布局 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        HStackDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `HStackDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct HStackDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HStackDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础示例

   - 基本用法
   - 间距设置
   - 对齐方式

2. 样式示例

   - 边框样式
   - 阴影样式
   - 自定义样式

3. 交互示例

   - 展开/收起
   - 高亮效果

4. 列表示例

   - 图标列表
   - 详细信息

5. 卡片示例
   - 复杂布局
   - 图文混排

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互和动画效果
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
