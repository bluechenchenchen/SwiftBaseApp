# Gauge 仪表控件

## 1. 基本介绍

### 控件概述

Gauge 是 SwiftUI 提供的仪表控件，用于在指定范围内显示当前值的位置。它支持多种样式，可以用来创建各种类型的仪表盘、进度指示器和测量表。

### 使用场景

- 显示系统资源使用情况（CPU、内存、磁盘等）
- 展示设备状态（电池电量、信号强度等）
- 呈现环境数据（温度、湿度、气压等）
- 音量、亮度等控制界面
- 速度表、转速表等仪表盘

### 主要特性

- 支持多种内置样式（线性、圆形、访问计量表）
- 可自定义外观和行为
- 支持动画过渡
- 提供丰富的自定义选项
- 适配系统主题
- 支持辅助功能

## 2. 基础用法

### 基本示例

1. 基础仪表盘

```swift
Gauge(value: 0.7) {
    Text("进度")
}
```

2. 带当前值和范围的仪表盘

```swift
Gauge(value: 75, in: 0...100) {
    Text("温度")
} currentValueLabel: {
    Text("\(Int(75))°C")
}
```

3. 带最小最大值标签的仪表盘

```swift
Gauge(value: 50, in: 0...100) {
    Text("音量")
} currentValueLabel: {
    Text("50%")
} minimumValueLabel: {
    Text("0")
} maximumValueLabel: {
    Text("100")
}
```

### 常用属性

- `value`: 当前值
- `in`: 值的范围
- `label`: 仪表盘标签
- `currentValueLabel`: 当前值标签
- `minimumValueLabel`: 最小值标签
- `maximumValueLabel`: 最大值标签

## 3. 样式和自定义

### 内置样式

1. 线性样式

```swift
Gauge(value: 0.7) {
    Text("进度")
}
.gaugeStyle(.linearCapacity)
```

2. 圆形样式

```swift
Gauge(value: 0.7) {
    Text("进度")
}
.gaugeStyle(.accessoryCircular)
```

3. 访问计量表样式

```swift
Gauge(value: 0.7) {
    Text("进度")
}
.gaugeStyle(.accessoryCircularCapacity)
```

### 自定义样式

1. 自定义颜色和渐变

```swift
Gauge(value: progress, in: 0...100) {
    Text("CPU")
}
.gaugeStyle(.accessoryCircularCapacity)
.tint(Gradient(colors: [.green, .yellow, .red]))
```

2. 自定义 Gauge 样式

```swift
struct CustomGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)

            Circle()
                .trim(from: 0, to: configuration.value)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            configuration.currentValueLabel
                .font(.system(.title2, design: .rounded))
                .bold()
        }
    }
}

// 使用自定义样式
Gauge(value: 0.7) {
    Text("自定义")
} currentValueLabel: {
    Text("70%")
}
.gaugeStyle(CustomGaugeStyle())
```

### 主题适配

- 自动适配深色/浅色模式
- 支持自定义颜色方案
- 响应系统颜色变化

## 4. 高级特性

### 组合使用

1. CPU 使用率监控

```swift
struct CPUGaugeView: View {
    @State private var cpuUsage: Double
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Gauge(value: cpuUsage, in: 0...100) {
            Image(systemName: "cpu")
        } currentValueLabel: {
            Text("\(Int(cpuUsage))%")
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text("100")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(Gradient(colors: [.green, .yellow, .red]))
    }
}
```

2. 电池电量显示

```swift
struct BatteryGaugeView: View {
    let batteryLevel: Double

    var body: some View {
        Gauge(value: batteryLevel, in: 0...100) {
            Image(systemName: "battery.100")
        } currentValueLabel: {
            Text("\(Int(batteryLevel))%")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(batteryColor)
    }

    var batteryColor: Color {
        switch batteryLevel {
        case 0..<20: return .red
        case 20..<40: return .orange
        default: return .green
        }
    }
}
```

### 动画效果

1. 基础动画

```swift
withAnimation(.spring()) {
    value += 10
}
```

2. 自定义动画

```swift
withAnimation(.easeInOut(duration: 1.0)) {
    value = targetValue
}
```

### 状态管理

1. 基本状态

```swift
@State private var value = 0.0

Button("增加") {
    withAnimation {
        value = min(100, value + 10)
    }
}
```

2. 带定时器的自动更新

```swift
struct AutoUpdateGauge: View {
    @State private var value = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        Gauge(value: value, in: 0...100) {
            Text("自动更新")
        }
        .onReceive(timer) { _ in
            withAnimation {
                value = value < 100 ? value + 1 : 0
            }
        }
    }
}
```

## 5. 性能优化

### 最佳实践

- 避免频繁更新值
- 合理使用动画
- 选择合适的样式
- 注意内存使用

### 常见陷阱

- 更新频率过高
- 动画过于复杂
- 样式嵌套过深
- 未处理极端值

### 优化技巧

- 使用 debounce 或 throttle 控制更新频率
- 适当使用 drawingGroup()
- 避免不必要的重绘
- 合理设置动画持续时间

## 6. 辅助功能

### 无障碍支持

- 自动朗读当前值
- 支持 VoiceOver
- 可自定义朗读标签

### 本地化

- 支持数值格式本地化
- 适配不同语言和地区
- 支持自定义数值格式

### 动态类型

- 自动适配系统字体大小
- 保持布局稳定性
- 支持自定义字体大小

## 7. 示例代码

### 基础示例

参见 GaugeDemoView.swift 中的具体实现。

### 进阶示例

参见 GaugeDemoView.swift 中的仪表盘示例。

## 8. 注意事项

### 常见问题

- 值范围控制
- 动画性能优化
- 样式自定义限制

### 兼容性考虑

- iOS 16.0+ 支持
- 不同设备适配
- 系统版本差异

### 使用建议

- 选择合适的样式
- 注意用户体验
- 保持界面响应性

## 9. 完整运行 Demo

### 源代码

完整示例代码位于 Features/Indicators/GaugeDemoView.swift

### 运行说明

1. 打开项目
2. 运行模拟器或真机
3. 在主界面选择 Gauge 示例

### 功能说明

- 展示各种仪表盘样式
- 演示动画效果
- 提供实际应用场景示例
