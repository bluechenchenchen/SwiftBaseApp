# SwiftUI ZStack 布局控件完整指南

## 1. 基本介绍

### 1.1 控件概述

ZStack 是 SwiftUI 中用于层叠排列视图的布局容器。它将子视图按照添加顺序从后到前叠加，常用于创建复杂的叠层效果、背景装饰和自定义控件。

### 1.2 使用场景

- 背景装饰
- 叠加效果
- 水印效果
- 徽章显示
- 自定义控件
- 弹出层设计

### 1.3 主要特性

- 层叠排列子视图
- 支持对齐方式
- 自动适应内容大小
- 支持 Z 轴排序
- 支持动画效果
- 支持手势交互

## 2. 基础用法

### 2.1 基本示例

```swift
// 基本用法
ZStack {
    Color.blue  // 背景层
    Text("内容")  // 内容层
}

// 设置对齐
ZStack(alignment: .topLeading) {
    Color.green
    Text("左上角")
}

// 多层叠加
ZStack {
    Color.yellow
    Circle()
        .fill(.blue.opacity(0.3))
    Text("叠加效果")
}
```

### 2.2 常用属性

```swift
// 设置对齐和大小
ZStack(alignment: .center) {
    Color.blue
    Text("居中内容")
}
.frame(width: 200, height: 200)

// 设置内边距
ZStack {
    Color.green
    Text("带内边距")
}
.padding()

// 设置圆角
ZStack {
    Color.orange
    Text("圆角效果")
}
.cornerRadius(10)
```

### 2.3 事件处理

```swift
// 点击事件
ZStack {
    Color.blue
    Text("点击")
}
.onTapGesture {
    handleTap()
}

// 长按事件
ZStack {
    Color.green
    Text("长按")
}
.onLongPressGesture {
    handleLongPress()
}
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 背景样式
ZStack {
    Color.blue.opacity(0.2)
    Text("背景样式")
}

// 边框样式
ZStack {
    Color.white
    Text("边框样式")
}
.border(.blue)

// 阴影样式
ZStack {
    Color.white
    Text("阴影样式")
}
.shadow(radius: 5)
```

### 3.2 自定义修饰符

```swift
struct CardBackgroundStyle: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        ZStack {
            color.opacity(0.1)
            content
        }
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// 使用自定义样式
Text("自定义背景")
    .modifier(CardBackgroundStyle(color: .blue))
```

### 3.3 主题适配

```swift
// 深色模式适配
ZStack {
    Color(.systemBackground)
    Text("主题适配")
}
.foregroundColor(Color(.label))

// 动态颜色
ZStack {
    Color(.secondarySystemBackground)
    Text("动态颜色")
}
.foregroundColor(Color(.secondaryLabel))
```

## 4. 高级特性

### 4.1 组合使用

```swift
// 卡片布局
ZStack {
    // 背景层
    RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemBackground))
        .shadow(radius: 5)

    // 内容层
    VStack(spacing: 10) {
        Image(systemName: "star.fill")
            .font(.largeTitle)
        Text("标题")
            .font(.headline)
        Text("描述文本")
            .font(.body)
            .foregroundColor(.secondary)
    }
    .padding()
}
.frame(width: 200, height: 200)
```

### 4.2 动画效果

```swift
// 翻转动画
@State private var isFlipped = false

ZStack {
    if isFlipped {
        Color.blue
        Text("背面")
    } else {
        Color.green
        Text("正面")
    }
}
.rotation3DEffect(
    .degrees(isFlipped ? 180 : 0),
    axis: (x: 0, y: 1, z: 0)
)
.animation(.spring(), value: isFlipped)
.onTapGesture {
    isFlipped.toggle()
}

// 渐变动画
@State private var isHighlighted = false

ZStack {
    Circle()
        .fill(isHighlighted ? .blue : .green)
    Text(isHighlighted ? "点击" : "松开")
}
.animation(.easeInOut, value: isHighlighted)
.onTapGesture {
    isHighlighted.toggle()
}
```

### 4.3 状态管理

```swift
struct BadgeView: View {
    @Binding var count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 主要内容
            Image(systemName: "bell.fill")
                .font(.title2)

            // 徽章
            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .padding(4)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 避免过多层级

```swift
// 不推荐
ZStack {
    ZStack {
        ZStack {
            Text("过度嵌套")
        }
    }
}

// 推荐
ZStack {
    Text("适当嵌套")
}
```

2. 使用 Group 组合视图

```swift
ZStack {
    Color.blue
    Group {
        Circle()
        Rectangle()
        Text("组合视图")
    }
    .foregroundColor(.white)
}
```

3. 合理使用条件渲染

```swift
ZStack {
    Color.background
    if shouldShowOverlay {
        overlayContent
    }
}
```

### 5.2 常见陷阱

1. 避免不必要的透明度

```swift
// 不推荐
ZStack {
    Color.black.opacity(0.5)
    Color.black.opacity(0.5)
    // 多层透明会影响性能
}

// 推荐
ZStack {
    Color.black.opacity(0.75)
    // 使用单层透明
}
```

2. 注意内存使用

```swift
// 使用 lazy 加载大型内容
ZStack {
    background
    if isContentVisible {
        LargeContentView()
    }
}
```

### 5.3 优化技巧

```swift
// 使用 zIndex 控制层级
ZStack {
    background
        .zIndex(0)
    content
        .zIndex(1)
    overlay
        .zIndex(2)
}

// 条件性显示复杂内容
@State private var showDetails = false

ZStack {
    mainContent
    if showDetails {
        DetailView()
            .transition(.opacity)
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
ZStack {
    Image("background")
    Text("内容")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("带背景的内容")
.accessibilityAddTraits(.isButton)
```

### 6.2 本地化

```swift
ZStack {
    Text("hello")
    Text("مرحبا")
}
.environment(\.layoutDirection, .rightToLeft)
```

### 6.3 动态类型

```swift
ZStack {
    Text("支持动态字体")
}
.font(.body)
.dynamicTypeSize(...DynamicTypeSize.accessibility3)
```

## 7. 示例代码

### 7.1 自定义按钮

```swift
struct CustomButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        ZStack {
            // 背景层
            RoundedRectangle(cornerRadius: 10)
                .fill(.blue)
                .opacity(isPressed ? 0.8 : 1.0)

            // 内容层
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
        }
        .frame(height: 50)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                action()
            }
        }
    }
}
```

### 7.2 徽章视图

```swift
struct BadgedIcon: View {
    let systemName: String
    let badgeCount: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.blue)

            if badgeCount > 0 {
                Text("\(min(badgeCount, 99))")
                    .font(.caption2)
                    .padding(4)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
        .padding(5)
    }
}
```

### 7.3 卡片视图

```swift
struct CardView: View {
    let title: String
    let subtitle: String
    let image: String

    var body: some View {
        ZStack {
            // 背景层
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)

            // 内容层
            VStack(spacing: 10) {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .frame(width: 200, height: 250)
    }
}
```

## 8. 注意事项

1. 布局考虑

   - 注意子视图的大小和位置
   - 合理使用对齐方式
   - 考虑不同屏幕尺寸的适配

2. 性能考虑

   - 避免过多层级
   - 合理使用透明度
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
struct BasicZStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础示例").font(.title)

            Group {
                // 基本用法
                ZStack {
                    Color.blue.opacity(0.2)
                    Text("基本叠加")
                }
                .frame(height: 100)
                .cornerRadius(8)

                // 设置对齐
                ZStack(alignment: .topLeading) {
                    Color.green.opacity(0.2)
                    Text("左上角对齐")
                }
                .frame(height: 100)
                .cornerRadius(8)

                // 多层叠加
                ZStack {
                    Color.orange.opacity(0.2)
                    Circle()
                        .fill(.blue.opacity(0.3))
                        .frame(width: 60, height: 60)
                    Text("多层叠加")
                }
                .frame(height: 100)
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - 样式示例
struct StyleZStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 样式示例").font(.title)

            Group {
                // 边框样式
                ZStack {
                    Color.white
                    Text("边框样式")
                }
                .frame(height: 100)
                .border(.blue)

                // 阴影样式
                ZStack {
                    Color(.systemBackground)
                    Text("阴影样式")
                }
                .frame(height: 100)
                .cornerRadius(8)
                .shadow(radius: 3)

                // 自定义样式
                ZStack {
                    Color(.systemBackground)
                    VStack {
                        Image(systemName: "star.fill")
                        Text("自定义样式")
                    }
                }
                .frame(height: 100)
                .modifier(ZStackCardStyle())
            }
        }
    }
}

// MARK: - 交互示例
struct InteractiveZStackExampleView: View {
    @State private var isFlipped = false
    @State private var isHighlighted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 交互示例").font(.title)

            Group {
                // 翻转效果
                ZStack {
                    if isFlipped {
                        Color.blue.opacity(0.2)
                        Text("背面")
                    } else {
                        Color.green.opacity(0.2)
                        Text("正面")
                    }
                }
                .frame(height: 100)
                .cornerRadius(8)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.spring(), value: isFlipped)
                .onTapGesture {
                    isFlipped.toggle()
                }

                // 高亮效果
                ZStack {
                    Circle()
                        .fill(isHighlighted ? .blue.opacity(0.2) : .green.opacity(0.2))
                    Text(isHighlighted ? "点击" : "松开")
                }
                .frame(height: 100)
                .animation(.easeInOut, value: isHighlighted)
                .onTapGesture {
                    isHighlighted.toggle()
                }
            }
        }
    }
}

// MARK: - 徽章示例
struct BadgeZStackExampleView: View {
    @State private var notifications = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 徽章示例").font(.title)

            HStack(spacing: 30) {
                BadgedIcon(systemName: "bell.fill", badgeCount: notifications)
                BadgedIcon(systemName: "envelope.fill", badgeCount: 12)
                BadgedIcon(systemName: "message.fill", badgeCount: 99)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}

// MARK: - 卡片示例
struct CardZStackExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 卡片示例").font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    CardView(
                        title: "功能一",
                        subtitle: "这是功能一的描述文本",
                        image: "star.fill"
                    )

                    CardView(
                        title: "功能二",
                        subtitle: "这是功能二的描述文本",
                        image: "heart.fill"
                    )

                    CardView(
                        title: "功能三",
                        subtitle: "这是功能三的描述文本",
                        image: "bolt.fill"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - 自定义样式
struct ZStackCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

// MARK: - 辅助视图
struct BadgedIcon: View {
    let systemName: String
    let badgeCount: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.blue)

            if badgeCount > 0 {
                Text("\(min(badgeCount, 99))")
                    .font(.caption2)
                    .padding(4)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
    }
}

struct CardView: View {
    let title: String
    let subtitle: String
    let image: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)

            VStack(spacing: 10) {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .frame(width: 200, height: 250)
    }
}

// MARK: - 主视图
struct ZStackDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicZStackExampleView()
                StyleZStackExampleView()
                InteractiveZStackExampleView()
                BadgeZStackExampleView()
                CardZStackExampleView()
            }
            .padding()
        }
        .navigationTitle("层叠布局 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        ZStackDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `ZStackDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct ZStackDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStackDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础示例

   - 基本叠加
   - 对齐方式
   - 多层叠加

2. 样式示例

   - 边框样式
   - 阴影样式
   - 自定义样式

3. 交互示例

   - 翻转效果
   - 高亮效果

4. 徽章示例

   - 带计数的图标
   - 动态显示

5. 卡片示例
   - 水平滚动
   - 阴影效果
   - 图文混排

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互和动画效果
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
