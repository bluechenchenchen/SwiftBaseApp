# SwiftUI Text 控件完整指南

## 1. 基础用法

### 1.1 创建文本

```swift
// 基本文本
Text("Hello, World!")

// 本地化文本
Text("greeting_key", bundle: .main, comment: "Greeting message")

// 使用String格式化
Text("Count: \(count)")

// 使用LocalizedStringKey
Text(verbatim: "Raw String") // 不进行本地化

// AttributedString支持
let attributedString = AttributedString("Hello")
Text(attributedString)
```

### 1.2 日期和数字格式化

```swift
// 日期格式化
Text(Date(), style: .date)
Text(Date(), style: .time)
Text(Date(), style: .relative)
Text(Date(), style: .timer)

// 数字格式化
Text(1.2345, format: .number)
Text(1.2345, format: .percent)
Text(1.2345, format: .currency(code: "USD"))
```

## 2. 样式修饰

### 2.1 字体设置

```swift
Text("Hello")
    .font(.largeTitle)         // 系统大标题
    .font(.title)              // 标题
    .font(.headline)           // 大标题
    .font(.subheadline)        // 副标题
    .font(.body)               // 正文
    .font(.callout)            // 标注
    .font(.caption)            // 说明文字
    .font(.caption2)           // 次要说明文字
    .font(.footnote)           // 脚注

// 自定义字体大小
    .font(.system(size: 20))

// 自定义字体和样式
    .font(.system(size: 20, weight: .bold, design: .rounded))

// 使用自定义字体
    .font(.custom("CustomFont", size: 20))
```

### 2.2 文本样式

```swift
Text("Hello")
    .bold()                    // 加粗
    .italic()                  // 斜体
    .underline()              // 下划线
    .underline(true, color: .red) // 带颜色的下划线
    .strikethrough()          // 删除线
    .strikethrough(true, color: .red) // 带颜色的删除线
    .baselineOffset(10)       // 基线偏移
    .kerning(2)               // 字符间距
    .tracking(2)              // 字符追踪
```

### 2.3 颜色和背景

```swift
Text("Hello")
    .foregroundStyle(.blue)            // 文字颜色
    .foregroundStyle(.primary)         // 主要文字颜色
    .foregroundStyle(.secondary)       // 次要文字颜色
    .background(.yellow)               // 背景颜色
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.yellow)
    )                                  // 自定义背景形状
```

### 2.4 文本对齐和布局

```swift
Text("Hello")
    .multilineTextAlignment(.center)   // 多行文本对齐
    .lineLimit(2)                      // 行数限制
    .lineLimit(nil)                    // 取消行数限制
    .lineSpacing(10)                   // 行间距
    .minimumScaleFactor(0.5)          // 最小缩放比例
    .truncationMode(.tail)             // 截断模式（头部/中间/尾部）
    .allowsTightening(true)            // 允许字符压缩
```

## 3. 高级用法

### 3.1 文本组合

```swift
// 使用+运算符组合
Text("Hello")
    .foregroundStyle(.red)
    + Text(" ")
    + Text("World")
    .foregroundStyle(.blue)

// 使用concatenation修饰符
Text("Hello")
    .foregroundStyle(.red)
    .concatenating(Text(" World").foregroundStyle(.blue))
```

### 3.2 Markdown 支持

```swift
// SwiftUI 的 Text 原生支持 Markdown 语法
Text("Hello **bold** and *italic* text")  // 支持粗体和斜体

// 支持更多 Markdown 语法
Text("支持以下格式：\n- **粗体**\n- *斜体*\n- ~删除线~\n- `代码`")

// 支持链接（但链接需要额外处理才能点击）
Text("Visit [Apple](https://www.apple.com)")

// 使用 AttributedString 处理复杂的 Markdown
let markdown = try? AttributedString(markdown: "**Bold** and *italic* [link](https://apple.com)")
if let markdown {
    Text(markdown)
}
```

### 3.3 动态文本

```swift
// 支持动态类型
Text("Dynamic Type Text")
    .dynamicTypeSize(.large)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // 设置最大字号

// 自定义动态类型范围
    .dynamicTypeSize(DynamicTypeSize.small...DynamicTypeSize.large)
```

### 3.4 文本交互

```swift
Text("Selectable Text")
    .textSelection(.enabled)           // 允许文本选择
    .contextMenu {                     // 添加上下文菜单
        Button("Copy") {
            // 复制操作
        }
    }
    .onTapGesture {                   // 点击手势
        // 处理点击
    }
```

## 4. 辅助功能支持

### 4.1 VoiceOver 支持

```swift
Text("Accessible Text")
    .accessibilityLabel("This is the description")
    .accessibilityHint("Double tap to perform action")
    .accessibilityAddTraits(.isHeader)
```

### 4.2 语义设置

```swift
Text("Important Message")
    .accessibilityHeading(.h1)        // 设置标题级别
    .accessibilityTextContentType(.prose) // 设置文本内容类型
```

## 5. 性能优化

### 5.1 文本缓存

```swift
// 使用常量文本提高性能
let cachedText = Text("Frequently used text")

var body: some View {
    cachedText
}
```

### 5.2 条件渲染

```swift
// 根据条件显示不同文本
if isError {
    Text("Error message")
        .foregroundStyle(.red)
} else {
    Text("Success message")
        .foregroundStyle(.green)
}
```

## 6. 常见用例

### 6.1 表单标签

```swift
VStack(alignment: .leading) {
    Text("Username")
        .font(.caption)
        .foregroundStyle(.secondary)
    TextField("Enter username", text: $username)
}
```

### 6.2 错误消息

```swift
Text(errorMessage)
    .font(.caption2)
    .foregroundStyle(.red)
    .padding(.horizontal, 4)
    .background(Color.red.opacity(0.1))
    .cornerRadius(4)
```

### 6.3 计数器显示

```swift
Text("\(count)")
    .font(.system(.title, design: .monospaced))
    .monospacedDigit()
    .foregroundStyle(count > 0 ? .blue : .red)
```

### 6.4 时间显示

```swift
Text(Date(), style: .timer)
    .font(.system(.title2, design: .monospaced))
    .monospacedDigit()
    .onAppear {
        // 开始计时
    }
```

## 7. 注意事项

1. Text 是不可变的（immutable），每次修改都会创建新的实例
2. 过多的 Text 组合可能影响性能，建议适度使用
3. 本地化字符串应使用标准的本地化机制
4. 动态类型支持应该是默认考虑的功能
5. 文本缩放和截断应该谨慎使用，确保重要信息不会丢失
6. 考虑使用 SF Symbols 来增强文本的视觉效果
7. 注意深色模式下的文本可见性
8. 大量文本应考虑使用 ScrollView 或 List

## 8. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI

// MARK: - 基础文本示例视图
struct BasicTextExampleView: View {
    let attributedString: AttributedString = {
        var str = AttributedString("Attributed String Demo")
        str.foregroundColor = .blue
        str.backgroundColor = .yellow
        return str
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("1. 基础文本示例").font(.title)
            Text("普通文本")
            Text("格式化数字: \(123.456, format: .number.precision(.fractionLength(2)))")
            Text(Date(), style: .date)
            Text(attributedString)
        }
    }
}

// MARK: - 样式修饰示例视图
struct StyleTextExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("2. 样式修饰示例").font(.title)

            Text("自定义字体")
                .font(.system(size: 20, weight: .bold, design: .rounded))

            Text("带有样式的文本")
                .bold()
                .italic()
                .underline()
                .foregroundStyle(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.yellow.opacity(0.3))
                )
                .padding()
        }
    }
}

// MARK: - 文本组合示例视图
struct CombinedTextExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("3. 文本组合示例").font(.title)

            HStack {
                Text("红色").foregroundStyle(.red)
                Text("和")
                Text("蓝色").foregroundStyle(.blue)
            }

            // 在 SwiftUI 中，Text 会自动解析 Markdown 语法
            Text("支持 **粗体** 和 *斜体* 和 ~删除线~ 和 `代码`")
        }
    }
}

// MARK: - 交互示例视图
struct InteractiveTextExampleView: View {
    @Binding var count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("4. 交互示例").font(.title)

            Text("可选择的文本")
                .textSelection(.enabled)

            Text("点击增加计数: \(count)")
                .onTapGesture {
                    count += 1
                }
                .font(.system(.body, design: .monospaced))
        }
    }
}

// MARK: - 错误提示示例视图
struct ErrorTextExampleView: View {
    @Binding var showError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("5. 错误提示示例").font(.title)

            Button("显示/隐藏错误") {
                showError.toggle()
            }

            if showError {
                Text("错误信息示例")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - 日期处理示例视图
struct DateTextExampleView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("6. 日期处理示例").font(.title)

            DatePicker("选择日期", selection: $selectedDate, displayedComponents: [.date])
                .padding()

            Text(selectedDate, style: .date)
            Text(selectedDate, style: .time)
            Text(selectedDate, style: .relative)
            Text(selectedDate, style: .timer)
        }
    }
}

// MARK: - 辅助功能示例视图
struct AccessibilityTextExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("7. 辅助功能示例").font(.title)

            Text("这是一个带有辅助功能的文本")
                .accessibilityLabel("辅助功能标签")
                .accessibilityHint("这是辅助功能提示")
                .accessibilityAddTraits(.isHeader)
        }
    }
}

// MARK: - 主视图
struct TextDemoView: View {
    @State private var count = 0
    @State private var showError = false
    @State private var selectedDate = Date()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                BasicTextExampleView()
                StyleTextExampleView()
                CombinedTextExampleView()
                InteractiveTextExampleView(count: $count)
                ErrorTextExampleView(showError: $showError)
                DateTextExampleView(selectedDate: $selectedDate)
                AccessibilityTextExampleView()
            }
            .padding()
        }
        .navigationTitle("Text 控件 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        TextDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为`TextDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是`XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct TextDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TextDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础文本展示
2. 格式化文本（数字、日期）
3. 富文本展示
4. 样式修饰示例
5. 文本组合
6. Markdown 支持
7. 交互功能
8. 错误提示展示
9. 日期处理
10. 辅助功能支持

### 注意事项

1. Demo 中包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了交互示例，可以实际体验文本的各种功能
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题，使界面更完整
