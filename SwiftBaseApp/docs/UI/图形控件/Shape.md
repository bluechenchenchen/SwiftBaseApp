# Shape 形状控件

## 1. 基本介绍

### 控件概述

Shape 是 SwiftUI 中用于创建和操作各种形状的协议，它提供了丰富的内置形状和自定义形状的能力。通过 Shape，我们可以创建从简单的几何图形到复杂的自定义形状，并支持填充、描边、渐变等多种样式。

### 使用场景

- 创建自定义按钮背景
- 设计装饰性元素
- 实现图表组件
- 制作动画效果
- 创建自定义进度指示器
- 设计特殊形状的视图

### 主要特性

- 提供多种内置基础形状
- 支持自定义形状定义
- 丰富的样式选项
- 强大的动画能力
- 支持形状变换和组合
- 提供多种渐变效果

## 2. 基础用法

### 基本示例

1. 矩形（Rectangle）

```swift
Rectangle()
    .fill(.blue)
    .frame(width: 100, height: 100)
```

2. 圆角矩形（RoundedRectangle）

```swift
RoundedRectangle(cornerRadius: 20)
    .fill(.green)
    .frame(width: 100, height: 100)
```

3. 圆形（Circle）

```swift
Circle()
    .fill(.red)
    .frame(width: 100, height: 100)
```

4. 椭圆（Ellipse）

```swift
Ellipse()
    .fill(.orange)
    .frame(width: 100, height: 50)
```

5. 胶囊形（Capsule）

```swift
Capsule()
    .fill(.purple)
    .frame(width: 100, height: 50)
```

### 常用属性

- `fill`: 填充颜色或渐变
- `stroke`: 描边样式
- `frame`: 尺寸设置
- `scale`: 缩放效果
- `rotation`: 旋转效果
- `offset`: 位置偏移

## 3. 样式和自定义

### 填充样式

1. 纯色填充

```swift
Circle()
    .fill(.blue)
```

2. 渐变填充

```swift
Circle()
    .fill(
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
```

3. 径向渐变

```swift
Circle()
    .fill(
        RadialGradient(
            gradient: Gradient(colors: [.yellow, .orange]),
            center: .center,
            startRadius: 0,
            endRadius: 50
        )
    )
```

### 描边样式

1. 基础描边

```swift
Circle()
    .stroke(.blue, lineWidth: 2)
```

2. 虚线描边

```swift
Circle()
    .stroke(
        .blue,
        style: StrokeStyle(
            lineWidth: 2,
            dash: [5, 3]
        )
    )
```

3. 渐变描边

```swift
Circle()
    .stroke(
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        lineWidth: 2
    )
```

### 组合效果

1. 填充和描边

```swift
Circle()
    .fill(.blue.opacity(0.2))
    .overlay(
        Circle()
            .stroke(.blue, lineWidth: 2)
    )
```

2. 阴影效果

```swift
RoundedRectangle(cornerRadius: 10)
    .fill(.white)
    .shadow(
        color: .gray.opacity(0.3),
        radius: 5,
        x: 0,
        y: 2
    )
```

## 4. 高级特性

### 自定义形状

1. 三角形

```swift
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
```

2. 星形

```swift
struct Star: Shape {
    let points: Int
    let innerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let angleStep = .pi * 2 / CGFloat(points)

        var path = Path()

        for i in 0..<points * 2 {
            let angle = angleStep * CGFloat(i) / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}
```

3. 波浪线

```swift
struct Wave: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))

        for x in stride(from: rect.minX, through: rect.maxX, by: 1) {
            let relativeX = x - rect.minX
            let y = rect.midY + amplitude * sin(frequency * relativeX + phase)
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}
```

### 动画效果

1. 形状变形

```swift
@State private var morphing = false

RoundedRectangle(cornerRadius: morphing ? 50 : 0)
    .animation(.easeInOut, value: morphing)
```

2. 渐变动画

```swift
@State private var rotateGradient = false

Circle()
    .fill(
        AngularGradient(
            gradient: Gradient(colors: [.blue, .purple, .blue]),
            center: .center,
            startAngle: .degrees(rotateGradient ? 0 : 360),
            endAngle: .degrees(rotateGradient ? 360 : 720)
        )
    )
    .animation(.linear(duration: 3).repeatForever(autoreverses: false),
              value: rotateGradient)
```

3. 路径动画

```swift
@State private var wavePhase = 0.0

Wave(amplitude: 20, frequency: 0.05, phase: wavePhase)
    .stroke(.blue, lineWidth: 2)
    .onAppear {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            wavePhase = .pi * 2
        }
    }
```

## 5. 性能优化

### 最佳实践

- 避免过于复杂的自定义形状
- 合理使用 drawingGroup()
- 优化动画性能
- 注意内存使用

### 常见陷阱

- 形状过于复杂
- 动画过于频繁
- 渐变效果使用过多
- 未优化重绘逻辑

### 优化技巧

- 使用 drawingGroup() 开启 Metal 渲染
- 避免不必要的形状嵌套
- 合理设置动画时间
- 优化自定义形状的路径计算

## 6. 辅助功能

### 无障碍支持

- 为形状添加描述标签
- 确保足够的触摸区域
- 提供适当的对比度

### 本地化

- 支持不同语言的形状描述
- 考虑文字方向的影响
- 适配不同地区的样式

### 动态类型

- 确保形状大小适配
- 保持布局稳定性
- 支持缩放

## 7. 示例代码

### 基础示例

参见 ShapeDemoView.swift 中的具体实现。

### 进阶示例

参见 ShapeDemoView.swift 中的自定义形状示例。

## 8. 注意事项

### 常见问题

- 形状定位和大小调整
- 动画性能优化
- 渐变效果使用
- 形状组合注意事项

### 兼容性考虑

- iOS 13.0+ 支持
- 不同设备适配
- 系统版本差异

### 使用建议

- 保持形状简单
- 合理使用动画
- 注意性能影响
- 考虑用户体验

## 9. 完整运行 Demo

### 源代码

完整示例代码位于 Features/Graphics/ShapeDemoView.swift

### 运行说明

1. 打开项目
2. 运行模拟器或真机
3. 在主界面选择 Shape 示例

### 功能说明

- 展示各种基础形状
- 演示自定义形状
- 展示动画效果
- 提供实际应用场景示例
