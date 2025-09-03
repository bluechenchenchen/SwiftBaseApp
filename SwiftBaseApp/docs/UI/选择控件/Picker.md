# Picker 选择器

## 1. 基本介绍

### 控件概述

Picker 是 SwiftUI 中的一个选择控件，用于从一组选项中选择一个或多个值。它提供了多种样式和展现形式，可以适应不同的使用场景和平台特性。

Picker 的核心特点：

1. 数据绑定

   - 支持单选和多选
   - 自动状态管理
   - 双向数据绑定
   - 支持自定义数据类型

2. 样式多样

   - 默认样式
   - 分段控制器样式
   - 菜单样式
   - 滚轮样式
   - 内联样式

3. 平台适配

   - iOS 原生样式
   - macOS 原生样式
   - watchOS 原生样式
   - 跨平台一致性

4. 交互特性
   - 手势支持
   - 键盘导航
   - 无障碍支持
   - 动画过渡

### 使用场景

1. 单项选择

   - 设置选项
   - 筛选条件
   - 类别选择
   - 状态切换

2. 数据输入

   - 日期选择
   - 时间选择
   - 数值范围
   - 预设选项

3. 表单元素

   - 用户偏好
   - 配置选项
   - 数据过滤
   - 排序方式

4. 界面控制
   - 视图切换
   - 主题选择
   - 语言设置
   - 显示模式

### 主要特性

1. 数据管理

   - 值绑定
   - 选项管理
   - 状态同步
   - 数据验证

2. 外观控制

   - 样式定制
   - 布局适配
   - 主题集成
   - 动态调整

3. 交互控制

   - 选择响应
   - 手势识别
   - 焦点管理
   - 动画效果

4. 辅助功能
   - VoiceOver
   - 动态字体
   - 本地化
   - 无障碍标签

### 与其他控件的对比

1. Picker vs Menu

   - Picker 专注于选择功能
   - Menu 更适合命令菜单
   - Picker 提供更多选择样式
   - Menu 提供更多交互选项

2. Picker vs List

   - Picker 适合单项选择
   - List 适合展示数据
   - Picker 有特定的选择样式
   - List 更灵活但需要自定义

3. Picker vs TabView
   - Picker 用于数据选择
   - TabView 用于视图切换
   - Picker 更轻量级
   - TabView 提供更丰富的导航

## 2. 基础用法

### 基本示例

1. 简单选择器

```swift
struct SimplePicker: View {
    @State private var selectedOption = 0
    let options = ["选项1", "选项2", "选项3"]

    var body: some View {
        Picker("选择选项", selection: $selectedOption) {
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index]).tag(index)
            }
        }
    }
}
```

2. 分段选择器

```swift
struct SegmentedPicker: View {
    @State private var selectedTab = 0

    var body: some View {
        Picker("选择视图", selection: $selectedTab) {
            Text("列表").tag(0)
            Text("网格").tag(1)
            Text("收藏").tag(2)
        }
        .pickerStyle(.segmented)
    }
}
```

3. 菜单样式选择器

```swift
struct MenuPicker: View {
    @State private var selectedColor = Color.red
    let colors: [Color] = [.red, .green, .blue]
    let colorNames = ["红色", "绿色", "蓝色"]

    var body: some View {
        Picker("选择颜色", selection: $selectedColor) {
            ForEach(0..<colors.count, id: \.self) { index in
                Text(colorNames[index])
                    .tag(colors[index])
            }
        }
        .pickerStyle(.menu)
    }
}
```

### 常用属性和修饰符

1. 选择器样式

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.pickerStyle(.automatic)  // 自动样式
.pickerStyle(.segmented)  // 分段样式
.pickerStyle(.menu)      // 菜单样式
.pickerStyle(.wheel)     // 滚轮样式
.pickerStyle(.inline)    // 内联样式
```

2. 外观定制

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.labelsHidden()         // 隐藏标签
.accentColor(.blue)     // 强调色
.disabled(isDisabled)   // 禁用状态
```

3. 事件处理

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.onChange(of: selection) { newValue in
    // 处理选择变化
}
```

### 布局系统集成

1. 在 Form 中使用

```swift
Form {
    Picker("选择选项", selection: $selection) {
        // 内容
    }
}
```

2. 在 List 中使用

```swift
List {
    Picker("选择选项", selection: $selection) {
        // 内容
    }
}
```

3. 在导航中使用

```swift
NavigationStack {
    Picker("选择选项", selection: $selection) {
        // 内容
    }
    .navigationTitle("选择器示例")
}
```

## 3. 样式和自定义

### 内置样式

1. 自动样式

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.pickerStyle(.automatic)
```

2. 分段样式

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.pickerStyle(.segmented)
```

3. 菜单样式

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.pickerStyle(.menu)
```

### 自定义修饰符

1. 外观定制

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.background(Color.secondary.opacity(0.1))
.cornerRadius(8)
.padding()
```

2. 交互定制

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.onTapGesture {
    // 处理点击
}
.onChange(of: selection) { newValue in
    // 处理选择变化
}
```

3. 动画效果

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.animation(.easeInOut, value: selection)
```

### 主题适配

1. 颜色适配

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.tint(Color.accentColor)
```

2. 暗黑模式

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.preferredColorScheme(.dark)
```

3. 动态颜色

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.foregroundStyle(Color(.label))
```

## 4. 高级特性

### 自定义数据类型

```swift
struct CustomOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: Int
}

struct CustomPicker: View {
    @State private var selection: CustomOption
    let options: [CustomOption]

    var body: some View {
        Picker("选择", selection: $selection) {
            ForEach(options) { option in
                Text(option.title).tag(option)
            }
        }
    }
}
```

### 多级选择器

```swift
struct MultiLevelPicker: View {
    @State private var primarySelection = 0
    @State private var secondarySelection = 0

    var body: some View {
        VStack {
            Picker("主选项", selection: $primarySelection) {
                // 主选项内容
            }

            Picker("次选项", selection: $secondarySelection) {
                // 基于主选项的次选项内容
            }
        }
    }
}
```

### 自定义选择器

```swift
struct CustomStylePicker<SelectionValue: Hashable, Content: View>: View {
    let selection: Binding<SelectionValue>
    let content: Content

    init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.content = content()
    }

    var body: some View {
        // 自定义选择器实现
    }
}
```

## 5. 性能优化

### 最佳实践

1. 数据结构优化

```swift
// 使用值类型
struct PickerOption: Hashable {
    let id: Int
    let title: String
}

// 避免复杂计算
let precomputedOptions = options.map { option in
    // 预处理数据
    PickerOption(id: option.id, title: option.title)
}
```

2. 视图结构优化

```swift
// 拆分子视图
struct OptimizedPicker: View {
    var body: some View {
        Picker("选择", selection: $selection) {
            PickerOptionsView(options: options)
        }
    }
}

struct PickerOptionsView: View {
    let options: [PickerOption]

    var body: some View {
        ForEach(options, id: \.self) { option in
            Text(option.title).tag(option)
        }
    }
}
```

3. 状态管理优化

```swift
// 使用适当的状态作用域
class PickerViewModel: ObservableObject {
    @Published var selection: Int
    @Published var options: [PickerOption]

    // 其他状态管理逻辑
}
```

### 常见陷阱

1. 避免频繁更新

```swift
// 问题代码
struct ProblematicPicker: View {
    @State private var selection = 0

    var body: some View {
        Picker("选择", selection: $selection) {
            ForEach(0..<1000) { index in
                // 每次重建所有选项
                Text("\(index)").tag(index)
            }
        }
    }
}

// 优化后
struct OptimizedPicker: View {
    @State private var selection = 0
    let options = Array(0..<1000)  // 预先创建

    var body: some View {
        Picker("选择", selection: $selection) {
            ForEach(options, id: \.self) { index in
                Text("\(index)").tag(index)
            }
        }
    }
}
```

2. 内存管理

```swift
// 使用合适的数据结构
struct MemoryEfficientPicker: View {
    @State private var selection = 0
    let options: [Int]  // 使用简单类型

    var body: some View {
        Picker("选择", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text("\(option)").tag(option)
            }
        }
    }
}
```

3. 状态更新

```swift
// 避免不必要的状态更新
struct StateEfficientPicker: View {
    @State private var selection = 0

    var body: some View {
        Picker("选择", selection: $selection) {
            // 内容
        }
        .onChange(of: selection) { newValue in
            // 只在必要时更新其他状态
            if shouldUpdate(newValue) {
                updateDependentState(newValue)
            }
        }
    }
}
```

### 优化技巧

1. 延迟加载

```swift
struct LazyLoadingPicker: View {
    @State private var selection = 0
    @State private var isExpanded = false

    var body: some View {
        Picker("选择", selection: $selection) {
            if isExpanded {
                // 展开时加载完整选项
                CompleteOptionsView()
            } else {
                // 默认只显示常用选项
                CommonOptionsView()
            }
        }
        .onTapGesture {
            isExpanded = true
        }
    }
}
```

2. 缓存优化

```swift
struct CachedPicker: View {
    @State private var selection = 0
    @State private var cache: [Int: String] = [:]

    var body: some View {
        Picker("选择", selection: $selection) {
            ForEach(0..<1000) { index in
                Text(cachedTitle(for: index))
                    .tag(index)
            }
        }
    }

    private func cachedTitle(for index: Int) -> String {
        if let cached = cache[index] {
            return cached
        }
        let title = computeTitle(for: index)  // 耗时操作
        cache[index] = title
        return title
    }
}
```

3. 批量更新

```swift
struct BatchUpdatePicker: View {
    @State private var selections: Set<Int> = []
    @State private var batchMode = false

    var body: some View {
        VStack {
            Toggle("批量选择", isOn: $batchMode)

            Picker("选择", selection: $selections) {
                ForEach(0..<100) { index in
                    Text("\(index)")
                        .tag(index)
                }
            }

            if batchMode {
                Button("全选") {
                    // 一次性更新所有选择
                    selections = Set(0..<100)
                }
            }
        }
    }
}
```

## 6. 辅助功能

### 无障碍支持

1. VoiceOver 支持

```swift
Picker("选择选项", selection: $selection) {
    ForEach(options) { option in
        Text(option.title)
            .tag(option)
            .accessibilityLabel(option.accessibilityLabel)
            .accessibilityHint(option.accessibilityHint)
    }
}
.accessibilityValue(options[selection].accessibilityValue)
```

2. 动态类型支持

```swift
Picker("选择", selection: $selection) {
    ForEach(options) { option in
        Text(option.title)
            .tag(option)
            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
    }
}
```

3. 辅助功能动作

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.accessibilityAction(.default) {
    // 默认选择动作
}
.accessibilityAction(named: "重置") {
    // 重置选择
    selection = defaultSelection
}
```

### 本地化

1. 文本本地化

```swift
Picker(NSLocalizedString("picker_title", comment: "Picker title"), selection: $selection) {
    ForEach(options) { option in
        Text(NSLocalizedString(option.titleKey, comment: "Option title"))
            .tag(option)
    }
}
```

2. 格式化

```swift
Picker("选择日期", selection: $selection) {
    ForEach(dates, id: \.self) { date in
        Text(date, style: .date)
            .tag(date)
            .environment(\.locale, .current)
    }
}
```

3. 方向适配

```swift
Picker("选择", selection: $selection) {
    // 内容
}
.environment(\.layoutDirection, .rightToLeft)
```

### 动态类型

1. 字体缩放

```swift
Picker("选择", selection: $selection) {
    ForEach(options) { option in
        Text(option.title)
            .tag(option)
            .font(.body)
            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
    }
}
```

2. 布局适配

```swift
Picker("选择", selection: $selection) {
    if dynamicTypeSize >= .accessibility1 {
        // 大字体布局
        VStack {
            ForEach(options) { option in
                Text(option.title)
                    .tag(option)
            }
        }
    } else {
        // 标准布局
        ForEach(options) { option in
            Text(option.title)
                .tag(option)
        }
    }
}
```

3. 自定义适配

```swift
Picker("选择", selection: $selection) {
    ForEach(options) { option in
        CustomOptionView(option: option, fontSize: dynamicFontSize)
            .tag(option)
    }
}
```

## 7. 示例代码

### 基础示例

请参考 PickerDemoView.swift 中的示例代码。

### 进阶示例

请参考 PickerDemoView.swift 中的进阶用法部分。

## 8. 注意事项

### 常见问题

1. 数据绑定

   - 确保选择值类型正确
   - 处理可选值情况
   - 验证数据有效性

2. 性能问题

   - 避免过多选项
   - 优化更新逻辑
   - 使用适当的数据结构

3. 布局问题
   - 处理长文本
   - 适配不同屏幕
   - 考虑动态字体

### 兼容性考虑

1. 平台差异

   - iOS 特定样式
   - macOS 特定样式
   - watchOS 特定样式

2. 版本兼容

   - 检查 API 可用性
   - 提供降级方案
   - 处理版本差异

3. 设备适配
   - 屏幕尺寸
   - 输入方式
   - 硬件能力

### 使用建议

1. 设计原则

   - 保持简单直观
   - 提供清晰反馈
   - 考虑用户体验

2. 实现建议

   - 合理组织代码
   - 优化性能
   - 添加适当注释

3. 测试要点
   - 验证功能正确
   - 检查性能表现
   - 测试边界情况

## 9. 完整运行 Demo

### 源代码

完整的示例代码请参考项目中的 PickerDemoView.swift 文件。

### 运行说明

1. 环境要求

   - Xcode 14.0 或更高版本
   - iOS 15.0 或更高版本
   - Swift 5.5 或更高版本

2. 运行步骤

   ```
   1. 打开项目根目录
   2. 找到 iPhoneBaseApp.xcodeproj
   3. 打开项目文件
   4. 选择运行目标设备
   5. 按下 Command + R 运行项目
   ```

3. 调试技巧
   - 使用预览功能
   - 检查视图层级
   - 监控性能指标

### 功能说明

1. 基础功能

   - 基本选择器
   - 分段选择器
   - 菜单选择器

2. 高级特性

   - 自定义样式
   - 动态更新
   - 状态管理

3. 辅助功能

   - 无障碍支持
   - 本地化
   - 动态字体

4. 性能优化
   - 延迟加载
   - 缓存机制
   - 批量更新
