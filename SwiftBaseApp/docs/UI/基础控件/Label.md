# SwiftUI Label 控件完整指南

## 1. 基本介绍

### 1.1 控件概述

Label 是 SwiftUI 中用于显示图标和文本组合的控件。它提供了一种标准的方式来展示带有图标的文本标签，常用于列表项、设置项等场景。

### 1.2 使用场景

- 设置项标签
- 列表项标题
- 表单字段标签
- 导航项标题
- 按钮内容

### 1.3 主要特性

- 支持图标和文本组合
- 自动适应系统样式
- 支持本地化
- 支持动态字体
- 支持无障碍功能

## 2. 基础用法

### 2.1 基本示例

```swift
// 基本用法
Label("用户名", systemImage: "person.fill")

// 使用自定义图片
Label("照片", image: "photo")

// 使用 title 和 icon 闭包
Label {
    Text("设置")
        .font(.headline)
} icon: {
    Image(systemName: "gear")
        .foregroundStyle(.blue)
}
```

### 2.2 常用属性

```swift
// 设置字体
Label("标题", systemImage: "star.fill")
    .font(.title)

// 设置颜色
Label("重要", systemImage: "exclamationmark.circle")
    .foregroundStyle(.red)

// 设置对齐方式
Label("居中对齐", systemImage: "arrow.up.arrow.down")
    .multilineTextAlignment(.center)

// 设置行数限制
Label("多行文本显示", systemImage: "text.alignleft")
    .lineLimit(2)
```

### 2.3 事件处理

```swift
// 点击事件
Label("点击我", systemImage: "hand.tap")
    .onTapGesture {
        handleTap()
    }

// 长按事件
Label("长按操作", systemImage: "hand.tap.fill")
    .onLongPressGesture {
        handleLongPress()
    }
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 标题样式
Label("标题样式", systemImage: "title")
    .labelStyle(.titleOnly)

// 图标样式
Label("图标样式", systemImage: "photo")
    .labelStyle(.iconOnly)

// 自动样式
Label("自动样式", systemImage: "autostartstop")
    .labelStyle(.automatic)
```

### 3.2 自定义修饰符

```swift
// 自定义样式
struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .foregroundStyle(.blue)
                .imageScale(.large)
            configuration.title
                .font(.headline)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// 使用自定义样式
Label("自定义样式", systemImage: "star")
    .labelStyle(CustomLabelStyle())
```

### 3.3 主题适配

```swift
// 深色模式适配
Label("主题适配", systemImage: "moon.fill")
    .foregroundStyle(.primary)
    .background(Color(.systemBackground))

// 动态颜色
Label("动态颜色", systemImage: "paintpalette")
    .foregroundStyle(Color(.label))
    .background(Color(.systemGray6))
```

## 4. 高级特性

### 4.1 组合使用

```swift
// 与其他控件组合
HStack {
    Label("标题", systemImage: "tag")
    Spacer()
    Toggle("", isOn: $isEnabled)
}

// 在列表中使用
List {
    Label("收藏", systemImage: "star.fill")
    Label("下载", systemImage: "arrow.down.circle")
    Label("分享", systemImage: "square.and.arrow.up")
}
```

### 4.2 动画效果

```swift
// 图标旋转动画
@State private var isRotating = false

Label("旋转效果", systemImage: "arrow.clockwise")
    .rotationEffect(.degrees(isRotating ? 360 : 0))
    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
              value: isRotating)
    .onAppear { isRotating = true }

// 颜色渐变动画
@State private var isHighlighted = false

Label("渐变效果", systemImage: "heart.fill")
    .foregroundStyle(isHighlighted ? .red : .gray)
    .animation(.easeInOut, value: isHighlighted)
    .onTapGesture {
        isHighlighted.toggle()
    }
```

### 4.3 状态管理

```swift
// 根据状态改变样式
struct StatefulLabel: View {
    @State private var isSelected = false

    var body: some View {
        Label("选择状态", systemImage: isSelected ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isSelected ? .blue : .gray)
            .onTapGesture {
                withAnimation {
                    isSelected.toggle()
                }
            }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 使用适当的图标大小

```swift
Label("优化大小", systemImage: "photo")
    .imageScale(.medium)  // 使用合适的图标大小
```

2. 避免过度动画

```swift
Label("简单动画", systemImage: "star")
    .scaleEffect(isHighlighted ? 1.1 : 1.0)  // 使用简单的缩放动画
```

3. 合理使用透明度

```swift
Label("透明度", systemImage: "circle.fill")
    .opacity(isEnabled ? 1.0 : 0.5)  // 使用透明度表示状态
```

### 5.2 常见陷阱

1. 避免频繁更新

```swift
// 不推荐
Label("计数器", systemImage: "number")
    .onChange(of: count) { oldValue, newValue in
        updateLabel()  // 避免频繁更新
    }
```

2. 注意内存使用

```swift
// 推荐
let systemImage = "photo"  // 重用系统图标
Label("图片", systemImage: systemImage)
```

### 5.3 优化技巧

```swift
// 使用 ViewBuilder 优化复杂布局
@ViewBuilder
func optimizedLabel(_ title: String, icon: String) -> some View {
    if shouldShowLabel {
        Label(title, systemImage: icon)
            .font(.body)
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
Label("设置", systemImage: "gear")
    .accessibilityLabel("打开设置")
    .accessibilityHint("点击进入设置页面")
    .accessibilityAddTraits(.isButton)
```

### 6.2 本地化

```swift
Label(LocalizedStringKey("settings"), systemImage: "gear")
    .environment(\.locale, Locale(identifier: "zh_CN"))
```

### 6.3 动态类型

```swift
Label("支持动态字体", systemImage: "textformat.size")
    .font(.body)
    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
```

## 7. 示例代码

### 7.1 设置项标签

```swift
struct SettingsLabel: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.body)
            .foregroundStyle(.primary)
    }
}
```

### 7.2 状态标签

```swift
struct StatusLabel: View {
    let status: Status

    var body: some View {
        Label(status.title, systemImage: status.icon)
            .foregroundStyle(status.color)
            .font(.subheadline)
    }
}
```

### 7.3 交互式标签

```swift
struct InteractiveLabel: View {
    @Binding var isSelected: Bool
    let title: String

    var body: some View {
        Label(title, systemImage: isSelected ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isSelected ? .blue : .gray)
            .onTapGesture {
                withAnimation {
                    isSelected.toggle()
                }
            }
    }
}
```

## 8. 注意事项

1. 图标选择

   - 使用合适大小的图标
   - 保持图标风格统一
   - 注意深色模式适配

2. 文本处理

   - 考虑文本长度
   - 处理多语言
   - 支持动态字体

3. 交互设计

   - 提供清晰的反馈
   - 合理的点击区域
   - 适当的动画效果

4. 性能考虑
   - 避免过度刷新
   - 合理使用动画
   - 注意内存使用

## 9. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI

// MARK: - 基础标签示例
struct BasicLabelExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础标签示例").font(.title)

            Group {
                // 基本用法
                Label("基本标签", systemImage: "tag")

                // 自定义图片和文本样式
                Label {
                    Text("自定义样式")
                        .font(.headline)
                        .foregroundStyle(.blue)
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }

                // 使用本地图片
                Label("本地图片", image: "photo")
            }
        }
    }
}

// MARK: - 样式示例
struct LabelStyleExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 样式示例").font(.title)

            Group {
                Label("标题样式", systemImage: "title")
                    .labelStyle(.titleOnly)

                Label("图标样式", systemImage: "photo")
                    .labelStyle(.iconOnly)

                Label("自定义样式", systemImage: "star")
                    .labelStyle(CustomLabelStyle())
            }
        }
    }
}

// MARK: - 交互示例
struct InteractiveLabelExampleView: View {
    @State private var isSelected = false
    @State private var isRotating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 交互示例").font(.title)

            Group {
                // 点击切换
                Label("点击切换", systemImage: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .onTapGesture {
                        withAnimation {
                            isSelected.toggle()
                        }
                    }

                // 旋转动画
                Label("旋转动画", systemImage: "arrow.clockwise")
                    .rotationEffect(.degrees(isRotating ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                              value: isRotating)
                    .onAppear { isRotating = true }
            }
        }
    }
}

// MARK: - 列表示例
struct ListLabelExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 列表示例").font(.title)

            List {
                Label("收藏", systemImage: "star.fill")
                Label("下载", systemImage: "arrow.down.circle")
                Label("分享", systemImage: "square.and.arrow.up")
                Label("设置", systemImage: "gear")
            }
        }
    }
}

// MARK: - 自定义样式
struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .foregroundStyle(.blue)
                .imageScale(.large)
            configuration.title
                .font(.headline)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - 主视图
struct LabelDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicLabelExampleView()
                LabelStyleExampleView()
                InteractiveLabelExampleView()
                ListLabelExampleView()
            }
            .padding()
        }
        .navigationTitle("标签控件 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        LabelDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `LabelDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct LabelDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LabelDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础标签示例

   - 基本用法
   - 自定义样式
   - 本地图片

2. 样式示例

   - 标题样式
   - 图标样式
   - 自定义样式

3. 交互示例

   - 点击切换
   - 旋转动画

4. 列表示例
   - 常见列表项
   - 系统图标使用

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互和动画效果
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
