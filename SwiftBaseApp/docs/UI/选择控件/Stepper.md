# Stepper 步进器控件

## 1. 基本介绍

### 控件概述

Stepper 是 SwiftUI 中的步进器控件，用于通过增加或减少操作来调整数值。它提供了精确的数值调整机制，特别适合需要离散值调整的场景。

Stepper 的核心特点：

1. 数值控制

   - 精确步进
   - 范围限制
   - 自定义步长
   - 循环选项

2. 交互方式

   - 按钮点击
   - 长按加速
   - 键盘控制
   - 手势支持

3. 样式定制

   - 按钮样式
   - 标签显示
   - 布局调整
   - 状态反馈

4. 平台适配
   - iOS 原生体验
   - macOS 原生体验
   - watchOS 原生体验
   - 跨平台一致性

### 使用场景

1. 数量选择

   - 商品数量
   - 人数选择
   - 份数调整
   - 计数器

2. 数值调整

   - 温度设置
   - 时间调整
   - 数值微调
   - 级别选择

3. 配置设置

   - 系统参数
   - 用户偏好
   - 游戏设置
   - 控制选项

4. 表单输入
   - 数字字段
   - 范围选择
   - 增量调整
   - 精确输入

### 主要特性

1. 值管理

   - 数值绑定
   - 范围限制
   - 步进控制
   - 循环选项

2. 外观定制

   - 标签样式
   - 按钮布局
   - 尺寸调整
   - 状态显示

3. 交互控制

   - 点击响应
   - 长按行为
   - 禁用状态
   - 值验证

4. 辅助功能
   - VoiceOver
   - 动态类型
   - 本地化
   - 无障碍标签

### 与其他控件的对比

1. Stepper vs Slider

   - Stepper 适合离散步进
   - Slider 适合连续范围
   - Stepper 更精确
   - Slider 更直观

2. Stepper vs Picker

   - Stepper 适合数值调整
   - Picker 适合选项选择
   - Stepper 操作更快
   - Picker 选项更清晰

3. Stepper vs TextField
   - Stepper 避免输入错误
   - TextField 支持直接输入
   - Stepper 操作更安全
   - TextField 输入更灵活

## 2. 基础用法

### 基本示例

1. 简单步进器

```swift
struct BasicStepper: View {
    @State private var value = 0

    var body: some View {
        Stepper(value: $value) {
            Text("数值：\(value)")
        }
    }
}
```

2. 带范围的步进器

```swift
struct RangeStepper: View {
    @State private var value = 0

    var body: some View {
        Stepper(
            value: $value,
            in: 0...10
        ) {
            Text("数值：\(value)")
        }
    }
}
```

3. 带步长的步进器

```swift
struct SteppedStepper: View {
    @State private var value = 0

    var body: some View {
        Stepper(
            value: $value,
            in: 0...100,
            step: 5
        ) {
            Text("数值：\(value)")
        }
    }
}
```

### 常用属性和修饰符

1. 基本属性

```swift
Stepper(value: $value, in: range, step: step) {
    Text("标签")
}
.disabled(isDisabled)
.onChange(of: value) { newValue in
    // 处理值变化
}
```

2. 自定义行为

```swift
Stepper(
    onIncrement: {
        // 增加操作
        value += 1
    },
    onDecrement: {
        // 减少操作
        value -= 1
    }
) {
    Text("自定义操作")
}
```

3. 循环选项

```swift
Stepper(
    value: $value,
    in: 0...10,
    step: 1
) {
    Text("循环选择")
}
.wrappedValue { value in
    // 处理循环逻辑
    if value > 10 {
        return 0
    } else if value < 0 {
        return 10
    }
    return value
}
```

### 布局系统集成

1. 在 Form 中使用

```swift
Form {
    Stepper("数量", value: $quantity, in: 1...10)
    Stepper("温度", value: $temperature, in: 16...30)
    Stepper("亮度", value: $brightness, in: 0...100, step: 5)
}
```

2. 在 List 中使用

```swift
List {
    HStack {
        Text("数量")
        Stepper(value: $quantity, in: 1...10) {
            Text("\(quantity)")
        }
    }
}
```

3. 在导航中使用

```swift
NavigationStack {
    Stepper(value: $value) {
        Text("调节")
    }
    .navigationTitle("步进器")
}
```

## 3. 样式和自定义

### 内置样式

1. 默认样式

```swift
Stepper(value: $value) {
    Text("默认样式")
}
```

2. 紧凑样式

```swift
Stepper(value: $value) {
    Text("紧凑样式")
}
.controlSize(.small)
```

3. 自定义颜色

```swift
Stepper(value: $value) {
    Text("自定义颜色")
}
.tint(.blue)
```

### 自定义修饰符

1. 外观定制

```swift
Stepper(value: $value) {
    Text("自定义外观")
}
.padding()
.background(Color.secondary.opacity(0.1))
.cornerRadius(8)
```

2. 交互定制

```swift
Stepper(value: $value) {
    Text("自定义交互")
}
.simultaneousGesture(
    LongPressGesture()
        .onEnded { _ in
            hapticFeedback()
        }
)
```

3. 动画效果

```swift
Stepper(value: $value) {
    Text("\(value)")
        .animation(.spring(), value: value)
}
```

### 主题适配

1. 颜色适配

```swift
Stepper(value: $value) {
    Text("主题颜色")
}
.tint(Color.accentColor)
```

2. 暗黑模式

```swift
Stepper(value: $value) {
    Text("暗黑模式")
}
.preferredColorScheme(.dark)
```

3. 动态颜色

```swift
Stepper(value: $value) {
    Text("动态颜色")
}
.tint(value < 5 ? .blue : .green)
```

## 4. 高级特性

### 自定义操作

```swift
struct CustomStepper: View {
    @State private var value = 0
    let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    var body: some View {
        Stepper(
            onIncrement: {
                withAnimation {
                    value = min(value + 1, 10)
                    hapticFeedback()
                }
            },
            onDecrement: {
                withAnimation {
                    value = max(value - 1, 0)
                    hapticFeedback()
                }
            }
        ) {
            HStack {
                Text("当前值：")
                Text(formatter.string(from: NSNumber(value: value)) ?? "0")
                    .foregroundColor(.blue)
            }
        }
    }

    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
```

### 组合控件

```swift
struct CombinedStepper: View {
    @State private var value = 0
    @State private var isEditing = false

    var body: some View {
        VStack {
            HStack {
                TextField("输入数值", value: $value, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .keyboardType(.numberPad)

                Stepper("", value: $value, in: 0...100)
                    .labelsHidden()
            }
            .padding()

            Text("当前值：\(value)")
                .foregroundStyle(.secondary)
        }
    }
}
```

### 自定义验证

```swift
struct ValidatedStepper: View {
    @State private var value = 0
    @State private var isValid = true

    var body: some View {
        VStack {
            Stepper(
                value: $value,
                in: 0...100,
                step: 5
            ) {
                HStack {
                    Text("数值：\(value)")
                    if !isValid {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .onChange(of: value) { newValue in
                validateValue(newValue)
            }

            if !isValid {
                Text("请选择 10 的倍数")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func validateValue(_ value: Int) {
        isValid = value % 10 == 0
    }
}
```

## 5. 性能优化

### 最佳实践

1. 值更新优化

```swift
struct OptimizedStepper: View {
    @State private var value = 0
    @State private var lastUpdate = Date()

    var body: some View {
        Stepper(value: $value) {
            Text("数值：\(value)")
        }
        .onChange(of: value) { newValue in
            // 限制更新频率
            if Date().timeIntervalSince(lastUpdate) > 0.1 {
                updateUI(with: newValue)
                lastUpdate = Date()
            }
        }
    }
}
```

2. 视图结构

```swift
struct StructuredStepper: View {
    var body: some View {
        VStack {
            StepperHeader()
            StepperContent()
            StepperFooter()
        }
    }
}
```

3. 状态管理

```swift
class StepperViewModel: ObservableObject {
    @Published var value: Int
    let range: ClosedRange<Int>
    let step: Int

    init(value: Int = 0, range: ClosedRange<Int> = 0...100, step: Int = 1) {
        self.value = value
        self.range = range
        self.step = step
    }
}
```

### 常见陷阱

1. 频繁更新

```swift
// 问题代码
struct ProblematicStepper: View {
    @State private var value = 0

    var body: some View {
        Stepper(value: $value) {
            Text("\(value)")
                .onChange(of: value) { _ in
                    // 每次变化都重新计算
                    heavyComputation()
                }
        }
    }
}

// 优化后
struct OptimizedStepper: View {
    @State private var value = 0
    @State private var lastUpdate = Date()

    var body: some View {
        Stepper(value: $value) {
            Text("\(value)")
                .onChange(of: value) { newValue in
                    // 限制更新频率
                    if Date().timeIntervalSince(lastUpdate) > 0.1 {
                        heavyComputation()
                        lastUpdate = Date()
                    }
                }
        }
    }
}
```

2. 内存管理

```swift
// 使用合适的数据结构
struct MemoryEfficientStepper: View {
    @State private var value = 0
    let formatter: NumberFormatter  // 共享格式化器

    var body: some View {
        Stepper(value: $value) {
            Text(formatter.string(from: NSNumber(value: value)) ?? "")
        }
    }
}
```

3. 状态冲突

```swift
// 避免状态冲突
struct ConflictFreeStepper: View {
    @State private var localValue = 0
    let externalValue: Int

    var body: some View {
        Stepper(value: $localValue) {
            Text("\(localValue)")
        }
        .onChange(of: externalValue) { newValue in
            // 仅在必要时更新本地状态
            if localValue != newValue {
                localValue = newValue
            }
        }
    }
}
```

### 优化技巧

1. 延迟加载

```swift
struct LazyStepper: View {
    @State private var isExpanded = false
    @State private var value = 0

    var body: some View {
        VStack {
            Stepper(value: $value) {
                Text("数值：\(value)")
            }

            if isExpanded {
                // 按需加载复杂视图
                ComplexValueDisplay(value: value)
            }

            Button("显示详情") {
                isExpanded.toggle()
            }
        }
    }
}
```

2. 批量更新

```swift
struct BatchStepper: View {
    @State private var values: [Int]
    @State private var updating = false

    var body: some View {
        VStack {
            ForEach(values.indices, id: \.self) { index in
                Stepper(
                    value: binding(for: index),
                    in: 0...100
                ) {
                    Text("值 \(index + 1)：\(values[index])")
                }
            }

            Button("重置所有值") {
                // 批量更新避免多次重绘
                withAnimation {
                    updating = true
                    values = Array(repeating: 0, count: values.count)
                    updating = false
                }
            }
        }
        .disabled(updating)
    }

    private func binding(for index: Int) -> Binding<Int> {
        Binding(
            get: { values[index] },
            set: { values[index] = $0 }
        )
    }
}
```

3. 缓存优化

```swift
struct CachedStepper: View {
    @State private var value = 0
    @State private var cache: [Int: String] = [:]

    var body: some View {
        VStack {
            Stepper(value: $value) {
                Text(formattedValue)
            }
        }
    }

    private var formattedValue: String {
        if let cached = cache[value] {
            return cached
        }
        let formatted = String(format: "当前值：%d", value)
        cache[value] = formatted
        return formatted
    }
}
```

## 6. 辅助功能

### 无障碍支持

1. VoiceOver 支持

```swift
Stepper(value: $value, in: 0...100) {
    Text("数量")
}
.accessibilityLabel("数量步进器")
.accessibilityValue("\(value)")
.accessibilityHint("调节数量大小")
```

2. 动态类型支持

```swift
Stepper(value: $value) {
    Text("数值")
        .font(.body)
        .dynamicTypeSize(...DynamicTypeSize.accessibility5)
}
```

3. 辅助功能动作

```swift
Stepper(value: $value) {
    Text("数值")
}
.accessibilityAction(.default) {
    // 默认动作
}
.accessibilityAction(named: "重置") {
    value = 0
}
```

### 本地化

1. 文本本地化

```swift
Stepper(
    value: $value,
    in: 0...100
) {
    Text(NSLocalizedString("stepper_label", comment: "Stepper label"))
}
```

2. 数值格式化

```swift
let formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.locale = .current
    return f
}()

Stepper(value: $value) {
    Text(formatter.string(from: NSNumber(value: value)) ?? "")
}
```

3. 方向适配

```swift
Stepper(value: $value) {
    Text("数值")
}
.environment(\.layoutDirection, .rightToLeft)
```

### 动态类型

1. 字体缩放

```swift
VStack {
    Stepper(value: $value) {
        Text("数值：\(value)")
            .font(.body)
            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
    }
}
```

2. 布局适配

```swift
Stepper(value: $value) {
    Text("数值")
}
.frame(maxWidth: dynamicTypeSize >= .accessibility1 ? .infinity : nil)
.padding(dynamicTypeSize >= .accessibility1 ? 16 : 8)
```

3. 自定义适配

```swift
Stepper(value: $value) {
    Text("数值")
}
.scaleEffect(dynamicTypeSize >= .accessibility1 ? 1.2 : 1.0)
```

## 7. 示例代码

### 基础示例

请参考 StepperDemoView.swift 中的示例代码。

### 进阶示例

请参考 StepperDemoView.swift 中的进阶用法部分。

## 8. 注意事项

### 常见问题

1. 值管理

   - 范围验证
   - 步进控制
   - 循环处理
   - 格式化显示

2. 性能问题

   - 更新频率
   - 值传递
   - 内存管理

3. 用户体验
   - 响应延迟
   - 动画流畅
   - 值反馈

### 兼容性考虑

1. 平台差异

   - iOS 样式
   - macOS 样式
   - watchOS 样式

2. 版本兼容

   - API 可用性
   - 样式支持
   - 功能限制

3. 设备适配
   - 屏幕尺寸
   - 交互方式
   - 硬件能力

### 使用建议

1. 设计原则

   - 直观操作
   - 即时反馈
   - 值显示清晰

2. 实现建议

   - 合理分层
   - 状态管理
   - 性能优化

3. 测试要点
   - 值正确性
   - 性能表现
   - 内存使用

## 9. 完整运行 Demo

### 源代码

完整的示例代码请参考项目中的 StepperDemoView.swift 文件。

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

   - 值调整
   - 范围限制
   - 步进控制
   - 格式化显示

2. 高级特性

   - 自定义操作
   - 组合控件
   - 动画效果
   - 状态管理

3. 辅助功能

   - 无障碍支持
   - 本地化
   - 动态字体

4. 性能优化
   - 延迟加载
   - 缓存机制
   - 批量更新
