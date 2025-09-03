# Canvas 画布控件

## 基本介绍

Canvas 是 SwiftUI 提供的一个强大的绘图控件，它允许我们直接在视图中进行自定义绘制。通过 Canvas，我们可以实现复杂的图形效果、自定义可视化和高性能的动画。

### 使用场景

- 自定义图形和图表
- 实时数据可视化
- 交互式绘图应用
- 游戏和动画效果
- 自定义进度指示器
- 签名和绘画功能

### 主要特性

- 高性能绘制
- 自定义绘图上下文
- 实时渲染
- 支持手势交互
- 支持图形变换
- 支持混合模式和效果

## 基础用法

### 1. 基本绘制

#### 1.1 矩形绘制

```swift
Canvas { context, size in
    // 填充矩形
    context.fill(
        Path(CGRect(x: 0, y: 0, width: 100, height: 100)),
        with: .color(.blue)
    )

    // 描边矩形
    context.stroke(
        Path(CGRect(x: 110, y: 0, width: 100, height: 100)),
        with: .color(.red),
        style: StrokeStyle(lineWidth: 2)
    )

    // 圆角矩形
    let roundedRect = Path(roundedRect: CGRect(x: 220, y: 0, width: 100, height: 100),
                          cornerRadius: 20)
    context.fill(roundedRect, with: .color(.green))
}
```

#### 1.2 圆形和椭圆

```swift
Canvas { context, size in
    // 圆形
    context.fill(
        Circle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100)),
        with: .color(.blue)
    )

    // 椭圆
    context.stroke(
        Ellipse().path(in: CGRect(x: 110, y: 0, width: 150, height: 100)),
        with: .color(.red),
        style: StrokeStyle(lineWidth: 2)
    )

    // 圆弧
    var path = Path()
    path.addArc(center: CGPoint(x: 300, y: 50),
                radius: 50,
                startAngle: .degrees(0),
                endAngle: .degrees(270),
                clockwise: false)
    context.stroke(path, with: .color(.green))
}
```

#### 1.3 线条和多边形

```swift
Canvas { context, size in
    // 直线
    var path = Path()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 100, y: 100))
    context.stroke(path, with: .color(.blue))

    // 三角形
    path = Path()
    path.move(to: CGPoint(x: 120, y: 100))
    path.addLine(to: CGPoint(x: 170, y: 0))
    path.addLine(to: CGPoint(x: 220, y: 100))
    path.closeSubpath()
    context.fill(path, with: .color(.red))

    // 多边形
    path = Path()
    let center = CGPoint(x: 300, y: 50)
    let radius: CGFloat = 50
    let sides = 6
    for i in 0..<sides {
        let angle = Double(i) * 2 * .pi / Double(sides)
        let point = CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
        if i == 0 {
            path.move(to: point)
        } else {
            path.addLine(to: point)
        }
    }
    path.closeSubpath()
    context.stroke(path, with: .color(.purple))
}
```

### 2. 渐变和填充

#### 2.1 线性渐变

```swift
Canvas { context, size in
    // 基本线性渐变
    context.fill(
        Path(CGRect(x: 0, y: 0, width: 100, height: 100)),
        with: .linearGradient(
            Gradient(colors: [.blue, .purple]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 100, y: 100)
        )
    )

    // 多色线性渐变
    context.fill(
        Path(CGRect(x: 110, y: 0, width: 100, height: 100)),
        with: .linearGradient(
            Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 100, y: 0)
        )
    )

    // 带停止点的渐变
    context.fill(
        Path(CGRect(x: 220, y: 0, width: 100, height: 100)),
        with: .linearGradient(
            Gradient(stops: [
                .init(color: .blue, location: 0.0),
                .init(color: .blue, location: 0.4),
                .init(color: .purple, location: 0.6),
                .init(color: .purple, location: 1.0)
            ]),
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 100, y: 100)
        )
    )
}
```

#### 2.2 径向渐变

```swift
Canvas { context, size in
    // 基本径向渐变
    context.fill(
        Circle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100)),
        with: .radialGradient(
            Gradient(colors: [.yellow, .red]),
            center: CGPoint(x: 50, y: 50),
            startRadius: 0,
            endRadius: 50
        )
    )

    // 偏心径向渐变
    context.fill(
        Circle().path(in: CGRect(x: 110, y: 0, width: 100, height: 100)),
        with: .radialGradient(
            Gradient(colors: [.blue, .clear]),
            center: CGPoint(x: 140, y: 30),
            startRadius: 0,
            endRadius: 70
        )
    )
}
```

#### 2.3 角度渐变（圆锥渐变）

```swift
Canvas { context, size in
    context.fill(
        Circle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100)),
        with: .conicGradient(
            Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
            center: CGPoint(x: 50, y: 50),
            angle: .degrees(0)
        )
    )
}
```

#### 2.4 图案填充

```swift
Canvas { context, size in
    // 创建一个简单的图案
    let patternSize = CGSize(width: 20, height: 20)
    let pattern = Path { path in
        path.addEllipse(in: CGRect(x: 5, y: 5, width: 10, height: 10))
    }

    // 使用图案填充矩形
    context.fill(
        Path(CGRect(x: 0, y: 0, width: 200, height: 100)),
        with: .pattern(
            pattern,
            patternSize: patternSize,
            fill: .color(.blue)
        )
    )
}
```

### 3. 阴影和效果

#### 3.1 阴影效果

```swift
Canvas { context, size in
    context.shadow(color: .black.opacity(0.3),
                  radius: 5,
                  x: 3,
                  y: 3)

    context.fill(
        RoundedRectangle(cornerRadius: 10)
            .path(in: CGRect(x: 20, y: 20, width: 100, height: 100)),
        with: .color(.white)
    )
}
```

#### 3.2 内阴影

```swift
Canvas { context, size in
    let rect = CGRect(x: 20, y: 20, width: 100, height: 100)
    let path = RoundedRectangle(cornerRadius: 10).path(in: rect)

    // 绘制主形状
    context.fill(path, with: .color(.white))

    // 添加内阴影
    context.clip(to: path)
    context.shadow(color: .black.opacity(0.3),
                  radius: 5,
                  x: -3,
                  y: -3)
    context.fill(
        Path(CGRect(x: rect.minX - 10,
                   y: rect.minY - 10,
                   width: rect.width + 20,
                   height: rect.height + 20)),
        with: .color(.clear)
    )
}
```

#### 3.3 发光效果

```swift
Canvas { context, size in
    // 外发光
    context.shadow(color: .blue.opacity(0.5),
                  radius: 10,
                  x: 0,
                  y: 0)
    context.fill(
        Circle().path(in: CGRect(x: 20, y: 20, width: 100, height: 100)),
        with: .color(.blue)
    )

    // 内发光
    let rect = CGRect(x: 140, y: 20, width: 100, height: 100)
    let path = Circle().path(in: rect)

    context.fill(path, with: .color(.purple))
    context.clip(to: path)
    context.shadow(color: .white.opacity(0.5),
                  radius: 10,
                  x: 0,
                  y: 0)
    context.fill(
        Circle().path(in: rect.insetBy(dx: -10, dy: -10)),
        with: .color(.clear)
    )
}
```

## 样式和变换

### 1. 绘制样式

#### 1.1 线条样式

```swift
Canvas { context, size in
    // 基本线条样式
    let basicStyle = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round
    )

    // 虚线样式
    let dashedStyle = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round,
        dash: [5, 5]
    )

    // 点划线样式
    let dashDotStyle = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round,
        dash: [10, 5, 2, 5]
    )

    // 绘制示例
    let path = Path { path in
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 0))
    }

    // 基本线条
    context.stroke(path, with: .color(.blue), style: basicStyle)

    // 虚线
    context.stroke(
        path.offsetBy(dx: 0, dy: 20),
        with: .color(.green),
        style: dashedStyle
    )

    // 点划线
    context.stroke(
        path.offsetBy(dx: 0, dy: 40),
        with: .color(.red),
        style: dashDotStyle
    )
}
```

#### 1.2 线条连接和端点

```swift
Canvas { context, size in
    // 不同的线条连接方式
    let styles: [(StrokeStyle, String)] = [
        (StrokeStyle(lineWidth: 10, lineJoin: .miter), "Miter"),
        (StrokeStyle(lineWidth: 10, lineJoin: .round), "Round"),
        (StrokeStyle(lineWidth: 10, lineJoin: .bevel), "Bevel")
    ]

    for (i, (style, name)) in styles.enumerated() {
        var path = Path()
        path.move(to: CGPoint(x: 20, y: 20 + CGFloat(i) * 50))
        path.addLine(to: CGPoint(x: 60, y: 50 + CGFloat(i) * 50))
        path.addLine(to: CGPoint(x: 100, y: 20 + CGFloat(i) * 50))

        context.stroke(path, with: .color(.blue), style: style)

        // 添加标签
        context.draw(
            Text(name).font(.caption),
            at: CGPoint(x: 120, y: 35 + CGFloat(i) * 50)
        )
    }
}
```

### 2. 变换和裁剪

#### 2.1 基本变换

```swift
Canvas { context, size in
    let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
    let originalPath = Path(rect)

    // 平移
    context.translateBy(x: 20, y: 20)
    context.fill(originalPath, with: .color(.blue))

    // 旋转
    context.translateBy(x: 100, y: 0)
    context.rotate(by: .degrees(45))
    context.fill(originalPath, with: .color(.green))

    // 缩放
    context.translateBy(x: 100, y: 0)
    context.scaleBy(x: 1.5, y: 0.5)
    context.fill(originalPath, with: .color(.red))
}
```

#### 2.2 复合变换

```swift
Canvas { context, size in
    let rect = CGRect(x: -25, y: -25, width: 50, height: 50)
    let originalPath = Path(rect)

    // 保存当前状态
    context.saveGState()

    // 移动到中心点
    context.translateBy(x: size.width/2, y: size.height/2)

    // 绘制多个旋转的矩形
    for i in 0..<8 {
        context.rotate(by: .degrees(45))
        context.fill(originalPath, with: .color(.blue.opacity(0.3)))
    }

    // 恢复状态
    context.restoreGState()
}
```

#### 2.3 裁剪和蒙版

```swift
Canvas { context, size in
    // 创建裁剪路径
    let clipPath = Circle().path(in: CGRect(x: 50, y: 50, width: 100, height: 100))
    context.clip(to: clipPath)

    // 绘制网格背景
    for x in stride(from: 0, to: size.width, by: 20) {
        for y in stride(from: 0, y: size.height, by: 20) {
            let rect = CGRect(x: x, y: y, width: 10, height: 10)
            context.fill(Path(rect), with: .color(.blue.opacity(0.3)))
        }
    }
}
```

### 3. 混合模式和透明度

#### 3.1 混合模式

```swift
Canvas { context, size in
    let rect = CGRect(x: 50, y: 50, width: 100, height: 100)

    // 正常模式
    context.fill(
        Circle().path(in: rect),
        with: .color(.blue.opacity(0.7))
    )

    // 正片叠底
    context.blendMode = .multiply
    context.fill(
        Circle().path(in: rect.offsetBy(dx: 50, dy: 0)),
        with: .color(.red.opacity(0.7))
    )

    // 叠加
    context.blendMode = .overlay
    context.fill(
        Circle().path(in: rect.offsetBy(dx: 25, dy: 50)),
        with: .color(.green.opacity(0.7))
    )
}
```

#### 3.2 透明度和遮罩

```swift
Canvas { context, size in
    // 全局透明度
    context.opacity = 0.5

    // 创建渐变遮罩
    let mask = Gradient(colors: [.clear, .black])
    context.fill(
        Path(CGRect(origin: .zero, size: size)),
        with: .linearGradient(
            mask,
            startPoint: .zero,
            endPoint: CGPoint(x: size.width, y: 0)
        )
    )

    // 在遮罩上绘制内容
    context.opacity = 1.0
    let circle = Circle().path(in: CGRect(x: 50, y: 50, width: 100, height: 100))
    context.fill(circle, with: .color(.blue))
}
```

## 高级特性

### 1. 实时绘制和交互

#### 1.1 基本绘制板

```swift
struct DrawingBoard: View {
    @State private var lines: [Line] = []
    @State private var currentLine: Line?

    struct Line {
        var points: [CGPoint]
        var color: Color
        var lineWidth: CGFloat
    }

    var body: some View {
        Canvas { context, size in
            // 绘制已完成的线条
            for line in lines {
                var path = Path()
                guard let start = line.points.first else { continue }
                path.move(to: start)
                for point in line.points.dropFirst() {
                    path.addLine(to: point)
                }
                context.stroke(
                    path,
                    with: .color(line.color),
                    style: StrokeStyle(
                        lineWidth: line.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }

            // 绘制当前线条
            if let line = currentLine {
                var path = Path()
                guard let start = line.points.first else { return }
                path.move(to: start)
                for point in line.points.dropFirst() {
                    path.addLine(to: point)
                }
                context.stroke(
                    path,
                    with: .color(line.color),
                    style: StrokeStyle(
                        lineWidth: line.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let point = value.location
                    if currentLine == nil {
                        currentLine = Line(
                            points: [point],
                            color: .blue,
                            lineWidth: 2
                        )
                    } else {
                        currentLine?.points.append(point)
                    }
                }
                .onEnded { _ in
                    if let line = currentLine {
                        lines.append(line)
                        currentLine = nil
                    }
                }
        )
    }
}
```

#### 1.2 压力感应绘制

```swift
struct PressureSensitiveDrawing: View {
    @State private var lines: [Line] = []
    @State private var currentLine: Line?

    struct Line {
        var points: [(point: CGPoint, pressure: CGFloat)]
        var color: Color
    }

    var body: some View {
        Canvas { context, size in
            for line in lines {
                var path = Path()
                guard let start = line.points.first else { continue }
                path.move(to: start.point)

                for i in 1..<line.points.count {
                    let current = line.points[i]
                    let previous = line.points[i-1]

                    // 使用压力值调整线宽
                    let lineWidth = current.pressure * 10

                    context.stroke(
                        Path { path in
                            path.move(to: previous.point)
                            path.addLine(to: current.point)
                        },
                        with: .color(line.color),
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($currentLine) { value, state, _ in
                    let point = value.location
                    let pressure = value.force ?? 1.0

                    if state == nil {
                        state = Line(
                            points: [(point, pressure)],
                            color: .blue
                        )
                    } else {
                        state?.points.append((point, pressure))
                    }
                }
                .onEnded { value in
                    if let line = currentLine {
                        lines.append(line)
                    }
                }
        )
    }
}
```

### 2. 动画和特效

#### 2.1 路径动画

```swift
struct PathAnimation: View {
    @State private var progress: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            // 创建路径
            let path = Path { path in
                path.move(to: CGPoint(x: 0, y: size.height/2))
                path.addCurve(
                    to: CGPoint(x: size.width, y: size.height/2),
                    control1: CGPoint(x: size.width/3, y: 0),
                    control2: CGPoint(x: 2*size.width/3, y: size.height)
                )
            }

            // 获取路径的长度
            let length = path.length

            // 绘制背景路径
            context.stroke(
                path,
                with: .color(.gray.opacity(0.3)),
                style: StrokeStyle(lineWidth: 2)
            )

            // 绘制动画路径
            let animatedPath = path.trimmedPath(from: 0, to: progress)
            context.stroke(
                animatedPath,
                with: .linearGradient(
                    Gradient(colors: [.blue, .purple]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: size.width, y: 0)
                ),
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )

            // 绘制路径点
            let point = path.point(at: progress)
            context.fill(
                Circle().path(in: CGRect(
                    x: point.x - 5,
                    y: point.y - 5,
                    width: 10,
                    height: 10
                )),
                with: .color(.blue)
            )
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                progress = 1
            }
        }
    }
}
```

#### 2.2 粒子系统

```swift
struct ParticleSystem: View {
    @StateObject private var system = ParticleSystemViewModel()

    class ParticleSystemViewModel: ObservableObject {
        struct Particle: Identifiable {
            let id = UUID()
            var position: CGPoint
            var velocity: CGPoint
            var color: Color
            var size: CGFloat
            var opacity: Double
            var rotation: Angle
        }

        @Published var particles: [Particle] = []

        func update() {
            particles = particles.compactMap { particle in
                var newParticle = particle
                newParticle.position.x += particle.velocity.x
                newParticle.position.y += particle.velocity.y
                newParticle.opacity -= 0.01
                newParticle.rotation += .degrees(2)
                return newParticle.opacity > 0 ? newParticle : nil
            }
        }

        func emit(at position: CGPoint) {
            let colors: [Color] = [.blue, .purple, .pink]
            let particle = Particle(
                position: position,
                velocity: CGPoint(
                    x: .random(in: -2...2),
                    y: .random(in: -2...2)
                ),
                color: colors.randomElement() ?? .blue,
                size: .random(in: 5...15),
                opacity: 1,
                rotation: .degrees(.random(in: 0...360))
            )
            particles.append(particle)
        }
    }

    var body: some View {
        TimelineView(.animation) { _ in
            Canvas { context, size in
                for particle in system.particles {
                    context.opacity = particle.opacity
                    context.rotate(by: particle.rotation)

                    let rect = CGRect(
                        x: particle.position.x - particle.size/2,
                        y: particle.position.y - particle.size/2,
                        width: particle.size,
                        height: particle.size
                    )

                    context.fill(
                        Star(points: 5).path(in: rect),
                        with: .color(particle.color)
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        system.emit(at: value.location)
                    }
            )
            .onChange(of: system.particles) { _ in
                system.update()
            }
        }
    }
}

struct Star: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4

        for i in 0..<points * 2 {
            let angle = Double(i) * .pi / Double(points)
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}
```

### 3. 图像处理和滤镜

#### 3.1 基本图像绘制

```swift
Canvas { context, size in
    if let image = context.resolve(Image("example")) {
        // 简单绘制
        context.draw(image, in: CGRect(origin: .zero, size: size))

        // 调整不透明度
        context.opacity = 0.7
        context.draw(image, in: CGRect(x: 50, y: 50, width: 100, height: 100))

        // 旋转绘制
        context.rotate(by: .degrees(45))
        context.draw(image, in: CGRect(x: 100, y: 0, width: 100, height: 100))
    }
}
```

#### 3.2 图像滤镜

```swift
Canvas { context, size in
    if let image = context.resolve(Image("example")) {
        // 模糊效果
        context.addFilter(.blur(radius: 5))
        context.draw(image, in: CGRect(x: 0, y: 0, width: 100, height: 100))

        // 饱和度调整
        context.addFilter(.saturation(2.0))
        context.draw(image, in: CGRect(x: 110, y: 0, width: 100, height: 100))

        // 亮度调整
        context.addFilter(.brightness(0.5))
        context.draw(image, in: CGRect(x: 220, y: 0, width: 100, height: 100))

        // 组合滤镜
        context.addFilter(.blur(radius: 3))
        context.addFilter(.saturation(1.5))
        context.addFilter(.brightness(0.2))
        context.draw(image, in: CGRect(x: 330, y: 0, width: 100, height: 100))
    }
}
```

#### 3.3 图像混合

```swift
Canvas { context, size in
    if let image1 = context.resolve(Image("image1")),
       let image2 = context.resolve(Image("image2")) {
        // 绘制第一张图片
        context.draw(image1, in: CGRect(origin: .zero, size: size))

        // 设置混合模式并绘制第二张图片
        context.blendMode = .multiply
        context.draw(image2, in: CGRect(origin: .zero, size: size))

        // 添加渐变遮罩
        context.blendMode = .normal
        context.fill(
            Path(CGRect(origin: .zero, size: size)),
            with: .linearGradient(
                Gradient(colors: [.clear, .black.opacity(0.5)]),
                startPoint: .zero,
                endPoint: CGPoint(x: size.width, y: 0)
            )
        )
    }
}
```

## 性能优化和最佳实践

### 1. 路径优化

#### 1.1 路径缓存

```swift
struct CachedPathView: View {
    // 缓存静态路径
    private let staticPath: Path = {
        var path = Path()
        // 创建复杂路径
        path.move(to: CGPoint(x: 0, y: 0))
        // ... 添加更多点
        return path
    }()

    var body: some View {
        Canvas { context, size in
            // 使用缓存的路径
            context.stroke(staticPath, with: .color(.blue))

            // 动态内容单独处理
            // ...
        }
    }
}
```

#### 1.2 路径简化

```swift
struct PathSimplification: View {
    func simplifyPath(_ points: [CGPoint], tolerance: CGFloat) -> [CGPoint] {
        guard points.count > 2 else { return points }

        var result = [points[0]]
        var prev = points[0]

        for point in points.dropFirst().dropLast() {
            let distance = sqrt(
                pow(point.x - prev.x, 2) +
                pow(point.y - prev.y, 2)
            )

            if distance > tolerance {
                result.append(point)
                prev = point
            }
        }

        result.append(points.last!)
        return result
    }

    var body: some View {
        Canvas { context, size in
            // 原始点
            let points: [CGPoint] = // ... 大量点

            // 简化后的点
            let simplified = simplifyPath(points, tolerance: 5)

            // 使用简化后的点绘制
            var path = Path()
            path.addLines(simplified)

            context.stroke(path, with: .color(.blue))
        }
    }
}
```

### 2. 绘制优化

#### 2.1 分层绘制

```swift
struct LayeredDrawing: View {
    var body: some View {
        ZStack {
            // 静态背景层
            Canvas { context, size in
                // 绘制不变的背景内容
            }

            // 动态前景层
            Canvas { context, size in
                // 只更新需要动画的内容
            }
        }
    }
}
```

#### 2.2 裁剪优化

```swift
struct ClippingOptimization: View {
    var body: some View {
        Canvas { context, size in
            // 设置裁剪区域
            let visibleRect = CGRect(x: 0, y: 0, width: 100, height: 100)
            context.clip(to: visibleRect)

            // 只有在裁剪区域内的内容会被绘制
            // 这可以大大减少绘制工作量
            for i in 0..<1000 {
                let rect = CGRect(x: i * 10, y: 0, width: 8, height: 8)
                if rect.intersects(visibleRect) {
                    context.fill(Path(rect), with: .color(.blue))
                }
            }
        }
    }
}
```

### 3. 状态管理

#### 3.1 视图模型分离

```swift
class DrawingViewModel: ObservableObject {
    @Published private(set) var paths: [Path] = []
    private var currentPath: Path?

    // 缓存常用值
    private let strokeStyle = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round
    )

    func startNewPath(at point: CGPoint) {
        var path = Path()
        path.move(to: point)
        currentPath = path
    }

    func updatePath(to point: CGPoint) {
        guard var path = currentPath else { return }
        path.addLine(to: point)
        currentPath = path
    }

    func endPath() {
        if let path = currentPath {
            paths.append(path)
            currentPath = nil
        }
    }
}

struct OptimizedDrawingView: View {
    @StateObject private var viewModel = DrawingViewModel()

    var body: some View {
        Canvas { context, size in
            // 使用视图模型中的数据
            for path in viewModel.paths {
                context.stroke(path, with: .color(.blue))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if viewModel.currentPath == nil {
                        viewModel.startNewPath(at: value.location)
                    } else {
                        viewModel.updatePath(to: value.location)
                    }
                }
                .onEnded { _ in
                    viewModel.endPath()
                }
        )
    }
}
```

### 4. 内存管理

#### 4.1 资源释放

```swift
class ResourceManagementViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 50 // 限制缓存数量
        cache.totalCostLimit = 50 * 1024 * 1024 // 限制内存使用
        return cache
    }()

    func loadImage(_ name: String) -> UIImage? {
        // 检查缓存
        if let cached = cache.object(forKey: name as NSString) {
            return cached
        }

        // 加载图片
        if let image = UIImage(named: name) {
            cache.setObject(image, forKey: name as NSString)
            return image
        }

        return nil
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
```

#### 4.2 自动清理

```swift
class AutoCleanupViewModel: ObservableObject {
    @Published var particles: [Particle] = []
    private var cleanupTimer: Timer?

    init() {
        // 定期清理
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.cleanup()
        }
    }

    private func cleanup() {
        // 移除不需要的粒子
        particles.removeAll { $0.opacity <= 0 }

        // 限制粒子数量
        if particles.count > 1000 {
            particles = Array(particles.suffix(1000))
        }
    }

    deinit {
        cleanupTimer?.invalidate()
    }
}
```

### 5. 调试技巧

#### 5.1 性能监控

```swift
struct PerformanceMonitor: View {
    @State private var frameTime: CFTimeInterval = 0
    private let displayLink = CADisplayLink()

    var body: some View {
        Canvas { context, size in
            // 绘制内容
            // ...

            // 显示帧率
            let fps = 1 / max(frameTime, 0.001)
            context.draw(
                Text(String(format: "FPS: %.1f", fps))
                    .font(.caption),
                at: CGPoint(x: 10, y: 10)
            )
        }
        .onAppear {
            displayLink.add(to: .current, forMode: .common)
            displayLink.preferredFramesPerSecond = 60
        }
        .onDisappear {
            displayLink.invalidate()
        }
    }
}
```

#### 5.2 边界显示

```swift
struct DebugBounds: View {
    @State private var showDebug = false

    var body: some View {
        Canvas { context, size in
            // 正常绘制
            // ...

            // 调试模式
            if showDebug {
                // 显示边界
                context.stroke(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(.red),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                )

                // 显示中心点
                let center = CGPoint(x: size.width/2, y: size.height/2)
                context.fill(
                    Circle().path(in: CGRect(
                        x: center.x - 2,
                        y: center.y - 2,
                        width: 4,
                        height: 4
                    )),
                    with: .color(.red)
                )
            }
        }
        .overlay(
            Button(action: { showDebug.toggle() }) {
                Image(systemName: "eye")
            }
            .padding(),
            alignment: .topTrailing
        )
    }
}
```

## 辅助功能和国际化

### 1. 无障碍支持

#### 1.1 基本无障碍

```swift
struct AccessibleCanvas: View {
    var body: some View {
        Canvas { context, size in
            // 绘制图表
            let barHeight = size.height * 0.6
            context.fill(
                Path(CGRect(x: 0, y: size.height - barHeight, width: size.width, height: barHeight)),
                with: .color(.blue)
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("进度图表")
        .accessibilityValue("当前进度60%")
        .accessibilityAddTraits(.updatesFrequently)
    }
}
```

#### 1.2 自定义无障碍行为

```swift
struct CustomAccessibilityCanvas: View {
    @State private var selectedElement: Int?

    var body: some View {
        Canvas { context, size in
            // 绘制多个数据点
            for i in 0..<5 {
                let isSelected = selectedElement == i
                let rect = CGRect(
                    x: CGFloat(i) * (size.width / 5),
                    y: 0,
                    width: size.width / 5 - 10,
                    height: size.height
                )

                context.fill(
                    Path(rect),
                    with: .color(isSelected ? .blue : .gray)
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("数据图表")
        .accessibilityChildren {
            ForEach(0..<5) { i in
                AccessibilityElement(
                    label: Text("数据项 \(i + 1)"),
                    value: Text("值: \(i * 20)%"),
                    traits: .isButton
                )
                .accessibilityAction {
                    selectedElement = i
                }
            }
        }
    }
}
```

### 2. 本地化支持

#### 2.1 文本本地化

```swift
struct LocalizedCanvas: View {
    var body: some View {
        Canvas { context, size in
            // 获取本地化文本
            let title = NSLocalizedString(
                "chart_title",
                comment: "Chart title"
            )

            // 计算文本大小
            let titleFont = UIFont.preferredFont(forTextStyle: .title1)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont
            ]
            let titleSize = (title as NSString).size(withAttributes: titleAttributes)

            // 绘制本地化文本
            context.draw(
                Text(title).font(.title),
                at: CGPoint(
                    x: (size.width - titleSize.width) / 2,
                    y: 20
                )
            )
        }
    }
}
```

#### 2.2 RTL 支持

```swift
struct RTLAwareCanvas: View {
    @Environment(\.layoutDirection) var layoutDirection

    var body: some View {
        Canvas { context, size in
            // 根据布局方向调整坐标系
            if layoutDirection == .rightToLeft {
                context.translateBy(x: size.width, y: 0)
                context.scaleBy(x: -1, y: 1)
            }

            // 绘制内容
            let rect = CGRect(x: 20, y: 20, width: 100, height: 100)
            context.fill(Path(rect), with: .color(.blue))

            // 绘制文本（自动处理RTL）
            context.draw(
                Text("示例文本")
                    .flipsForRightToLeftLayoutDirection(true),
                at: CGPoint(x: 20, y: 140)
            )
        }
    }
}
```

### 3. 动态类型支持

#### 3.1 字体缩放

```swift
struct DynamicTypeCanvas: View {
    @Environment(\.sizeCategory) var sizeCategory

    private func scaledFont(_ style: Font.TextStyle) -> UIFont {
        UIFont.preferredFont(forTextStyle: UIFont.TextStyle(style))
    }

    var body: some View {
        Canvas { context, size in
            // 获取动态大小的字体
            let titleFont = scaledFont(.title)
            let bodyFont = scaledFont(.body)

            // 绘制标题
            context.draw(
                Text("标题")
                    .font(Font(titleFont)),
                at: CGPoint(x: 20, y: 20)
            )

            // 绘制正文
            context.draw(
                Text("正文内容")
                    .font(Font(bodyFont)),
                at: CGPoint(x: 20, y: 60)
            )

            // 调整图形大小
            let baseSize: CGFloat = 100
            let scale = sizeCategory.isAccessibilityCategory ? 1.5 : 1.0
            let scaledSize = baseSize * scale

            context.fill(
                Circle().path(in: CGRect(
                    x: 20,
                    y: 100,
                    width: scaledSize,
                    height: scaledSize
                )),
                with: .color(.blue)
            )
        }
    }
}
```

#### 3.2 内容适配

```swift
struct AdaptiveCanvas: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Canvas { context, size in
            // 根据动态类型调整布局
            let isAccessibility = sizeCategory.isAccessibilityCategory
            let spacing = isAccessibility ? 30.0 : 20.0
            let fontSize = isAccessibility ? 24.0 : 16.0

            // 调整颜色对比度
            let backgroundColor = colorScheme == .dark
                ? Color.black
                : Color.white
            let textColor = colorScheme == .dark
                ? Color.white
                : Color.black

            // 绘制背景
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(backgroundColor)
            )

            // 绘制文本
            context.draw(
                Text("示例文本")
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor),
                at: CGPoint(x: spacing, y: spacing)
            )
        }
    }
}
```

## 注意事项和最佳实践

### 1. 常见问题和解决方案

#### 1.1 坐标系统问题

```swift
struct CoordinateSystemExample: View {
    var body: some View {
        Canvas { context, size in
            // 保存当前状态
            context.saveGState()

            // 移动原点到中心
            context.translateBy(x: size.width/2, y: size.height/2)

            // 翻转Y轴（使Y轴向上为正）
            context.scaleBy(x: 1, y: -1)

            // 在新坐标系中绘制
            let rect = CGRect(x: -50, y: -50, width: 100, height: 100)
            context.stroke(
                Path(rect),
                with: .color(.blue),
                style: StrokeStyle(lineWidth: 2)
            )

            // 恢复状态
            context.restoreGState()
        }
    }
}
```

#### 1.2 内存管理

```swift
class CanvasViewModel: ObservableObject {
    // 使用弱引用避免循环引用
    weak var delegate: CanvasViewModelDelegate?

    // 使用 NSCache 缓存大型对象
    private let imageCache = NSCache<NSString, UIImage>()

    // 限制数据量
    private let maxDataPoints = 1000
    @Published private(set) var dataPoints: [CGPoint] = []

    func addPoint(_ point: CGPoint) {
        dataPoints.append(point)
        if dataPoints.count > maxDataPoints {
            dataPoints.removeFirst(dataPoints.count - maxDataPoints)
        }
    }

    func clearCache() {
        imageCache.removeAllObjects()
        dataPoints.removeAll()
    }
}
```

#### 1.3 事件处理

```swift
struct EventHandlingCanvas: View {
    @State private var touchLocation: CGPoint?
    @GestureState private var isDragging = false

    var body: some View {
        Canvas { context, size in
            // 绘制基本内容
            if let location = touchLocation {
                context.fill(
                    Circle().path(in: CGRect(
                        x: location.x - 10,
                        y: location.y - 10,
                        width: 20,
                        height: 20
                    )),
                    with: .color(.blue)
                )
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isDragging) { value, state, _ in
                    state = true
                }
                .onChanged { value in
                    touchLocation = value.location
                }
                .onEnded { _ in
                    touchLocation = nil
                }
        )
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged { scale in
                    // 处理缩放
                }
        )
        .simultaneousGesture(
            RotationGesture()
                .onChanged { angle in
                    // 处理旋转
                }
        )
    }
}
```

### 2. 设备适配

#### 2.1 屏幕分辨率

```swift
struct ResolutionAwareCanvas: View {
    var body: some View {
        Canvas { context, size in
            // 获取设备比例
            let scale = UIScreen.main.scale

            // 调整线宽
            let lineWidth = 1.0 / scale // 保证1像素线条

            // 对齐到像素网格
            let x = round(size.width/2 * scale) / scale
            let y = round(size.height/2 * scale) / scale

            // 绘制
            context.stroke(
                Path(CGRect(x: x, y: y, width: 100, height: 100)),
                with: .color(.blue),
                style: StrokeStyle(lineWidth: lineWidth)
            )
        }
    }
}
```

#### 2.2 设备方向

```swift
struct OrientationAwareCanvas: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        Canvas { context, size in
            // 根据方向调整布局
            let isLandscape = size.width > size.height
            let isRegular = horizontalSizeClass == .regular

            // 计算合适的大小
            let dimension = min(size.width, size.height)
            let padding: CGFloat = isRegular ? 40 : 20
            let itemSize = (dimension - padding * 2) / (isLandscape ? 4 : 2)

            // 绘制网格
            for row in 0..<2 {
                for col in 0..<(isLandscape ? 4 : 2) {
                    let x = padding + CGFloat(col) * itemSize
                    let y = padding + CGFloat(row) * itemSize

                    context.fill(
                        Path(CGRect(
                            x: x,
                            y: y,
                            width: itemSize - padding,
                            height: itemSize - padding
                        )),
                        with: .color(.blue.opacity(0.3))
                    )
                }
            }
        }
    }
}
```

### 3. 性能优化建议

#### 3.1 绘制优化

```swift
struct OptimizedCanvas: View {
    let complexPath: Path = {
        // 预计算复杂路径
        var path = Path()
        // ... 复杂的路径计算
        return path
    }()

    var body: some View {
        Canvas { context, size in
            // 1. 使用裁剪区域
            context.clip(to: Path(CGRect(origin: .zero, size: size)))

            // 2. 避免透明度叠加
            context.setAlpha(1.0)

            // 3. 合并相似的绘制操作
            var combinedPath = Path()
            for i in 0..<10 {
                combinedPath.addPath(complexPath.offsetBy(dx: CGFloat(i) * 10, dy: 0))
            }
            context.stroke(combinedPath, with: .color(.blue))

            // 4. 使用适当的混合模式
            context.blendMode = .normal

            // 5. 避免不必要的状态改变
            context.saveGState()
            // 执行变换
            context.restoreGState()
        }
    }
}
```

#### 3.2 更新策略

```swift
struct UpdateOptimizedCanvas: View {
    @State private var needsFullRedraw = false
    @State private var lastUpdateTime = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                // 检查是否需要完全重绘
                if needsFullRedraw {
                    // 执行完整重绘
                    drawEverything(in: context, size: size)
                    needsFullRedraw = false
                } else {
                    // 只更新动画部分
                    updateAnimations(in: context, size: size)
                }

                // 控制更新频率
                if timeline.date.timeIntervalSince(lastUpdateTime) > 1.0/60.0 {
                    lastUpdateTime = timeline.date
                    // 执行更新
                }
            }
        }
    }

    private func drawEverything(in context: GraphicsContext, size: CGSize) {
        // 完整绘制逻辑
    }

    private func updateAnimations(in context: GraphicsContext, size: CGSize) {
        // 动画更新逻辑
    }
}
```

### 4. 代码组织建议

#### 4.1 模块化设计

```swift
// 绘制协议
protocol Drawable {
    func draw(in context: GraphicsContext, size: CGSize)
}

// 具体绘制类
struct CircleDrawer: Drawable {
    var center: CGPoint
    var radius: CGFloat
    var color: Color

    func draw(in context: GraphicsContext, size: CGSize) {
        let rect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        context.fill(
            Circle().path(in: rect),
            with: .color(color)
        )
    }
}

// 组合使用
struct ModularCanvas: View {
    var drawables: [Drawable]

    var body: some View {
        Canvas { context, size in
            for drawable in drawables {
                drawable.draw(in: context, size: size)
            }
        }
    }
}
```

#### 4.2 状态管理

```swift
class CanvasStateManager: ObservableObject {
    // 绘制状态
    enum DrawingState {
        case idle
        case drawing
        case erasing
    }

    // 发布状态变化
    @Published var drawingState: DrawingState = .idle
    @Published var currentColor: Color = .blue
    @Published var lineWidth: CGFloat = 2

    // 历史记录
    private var undoStack: [DrawingCommand] = []
    private var redoStack: [DrawingCommand] = []

    // 命令模式
    struct DrawingCommand {
        let path: Path
        let color: Color
        let lineWidth: CGFloat
    }

    func undo() {
        guard let command = undoStack.popLast() else { return }
        redoStack.append(command)
        objectWillChange.send()
    }

    func redo() {
        guard let command = redoStack.popLast() else { return }
        undoStack.append(command)
        objectWillChange.send()
    }

    func addCommand(_ command: DrawingCommand) {
        undoStack.append(command)
        redoStack.removeAll()
        objectWillChange.send()
    }
}
```

## 完整运行 Demo

请参考 `CanvasDemoView.swift` 中的完整示例代码，包括：

1. 基础绘制示例
2. 交互式绘图
3. 动画效果
4. 图形变换
5. 实际应用场景

### 运行说明

1. 克隆项目代码
2. 打开 Xcode 项目
3. 选择目标设备
4. 运行示例程序

### 功能说明

1. 展示 Canvas 的基本用法
2. 演示高级特性
3. 提供性能优化示例
4. 包含完整的交互示例
