import SwiftUI
import Combine

// MARK: - 动态效果

/// 心跳动画视图
struct HeartbeatView: View {
  @State private var progress: Double = 0.0
  
  var body: some View {
    HeartbeatShape(progress: progress)
      .stroke(
        LinearGradient(
          colors: [.red, .pink],
          startPoint: .leading,
          endPoint: .trailing
        ),
        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
      )
      .frame(height: 100)
      .padding()
      .onAppear {
        withAnimation(
          .easeInOut(duration: 0.5)
          .repeatForever(autoreverses: true)
        ) {
          progress = 1.0
        }
      }
  }
}

/// 心跳波形形状
struct HeartbeatShape: Shape {
  var progress: Double
  
  var animatableData: Double {
    get { progress }
    set { progress = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.width
    let height = rect.height
    let midY = height / 2
    
    // 起点
    path.move(to: CGPoint(x: 0, y: midY))
    
    // 第一段平线
    path.addLine(to: CGPoint(x: width * 0.1, y: midY))
    
    // P波
    path.addQuadCurve(
      to: CGPoint(x: width * 0.2, y: midY),
      control: CGPoint(x: width * 0.15, y: midY - height * 0.1 * progress)
    )
    
    // PR段
    path.addLine(to: CGPoint(x: width * 0.3, y: midY))
    
    // QRS波群
    path.addQuadCurve(
      to: CGPoint(x: width * 0.35, y: midY + height * 0.3 * progress),
      control: CGPoint(x: width * 0.325, y: midY - height * 0.1 * progress)
    )
    path.addQuadCurve(
      to: CGPoint(x: width * 0.4, y: midY - height * 0.4 * progress),
      control: CGPoint(x: width * 0.375, y: midY + height * 0.4 * progress)
    )
    path.addQuadCurve(
      to: CGPoint(x: width * 0.45, y: midY),
      control: CGPoint(x: width * 0.425, y: midY - height * 0.2 * progress)
    )
    
    // ST段
    path.addLine(to: CGPoint(x: width * 0.5, y: midY))
    
    // T波
    path.addQuadCurve(
      to: CGPoint(x: width * 0.7, y: midY),
      control: CGPoint(x: width * 0.6, y: midY + height * 0.2 * progress)
    )
    
    // 结束段
    path.addLine(to: CGPoint(x: width, y: midY))
    
    return path
  }
}

/// 音频波形视图模型
class AudioWaveformViewModel: ObservableObject {
  @Published var amplitudes: [CGFloat]
  private var cancellables = Set<AnyCancellable>()
  private let barCount: Int
  
  init(barCount: Int) {
    self.barCount = barCount
    self.amplitudes = Array(repeating: 0.5, count: barCount)
    startTimer()
  }
  
  private func startTimer() {
    // 减慢更新频率
    Timer.publish(every: 0.2, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self else { return }
        // 使用缓动动画，并增加动画持续时间
        withAnimation(.easeInOut(duration: 0.3)) {
          for i in 0..<self.barCount {
            // 减小随机范围，使波形更平滑
            let currentValue = self.amplitudes[i]
            let targetValue = CGFloat.random(in: 0.2...0.8)
            // 限制相邻值的变化幅度
            let maxChange: CGFloat = 0.3
            let change = min(abs(targetValue - currentValue), maxChange)
            self.amplitudes[i] = currentValue + (targetValue > currentValue ? change : -change)
          }
        }
      }
      .store(in: &cancellables)
  }
}

/// 音频波形图
struct AudioWaveform: View {
  @StateObject private var viewModel: AudioWaveformViewModel
  let barCount: Int
  let color: Color
  
  init(barCount: Int = 30, color: Color = .blue) {
    self.barCount = barCount
    self.color = color
    _viewModel = StateObject(wrappedValue: AudioWaveformViewModel(barCount: barCount))
  }
  
  var body: some View {
    TimelineView(.animation) { _ in
      Canvas { context, size in
        let barWidth = size.width / CGFloat(barCount)
        let midY = size.height / 2
        
        // 绘制连接线
        var linePath = Path()
        let points = viewModel.amplitudes.enumerated().map { index, amplitude in
          let x = CGFloat(index) * barWidth + barWidth * 0.3
          let height = size.height * amplitude
          return CGPoint(x: x, y: midY - height / 2 + height)
        }
        
        if let firstPoint = points.first {
          linePath.move(to: firstPoint)
          for point in points.dropFirst() {
            linePath.addLine(to: point)
          }
        }
        
        // 绘制平滑曲线
        context.stroke(
          linePath,
          with: .linearGradient(
            Gradient(colors: [color.opacity(0.3), color]),
            startPoint: CGPoint(x: 0, y: midY),
            endPoint: CGPoint(x: size.width, y: midY)
          ),
          style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
        )
        
        // 绘制柱状图
        for (index, amplitude) in viewModel.amplitudes.enumerated() {
          let x = CGFloat(index) * barWidth
          let height = size.height * amplitude
          let y = midY - height / 2
          
          var path = Path()
          path.addRoundedRect(
            in: CGRect(x: x + barWidth * 0.2, y: y, width: barWidth * 0.6, height: height),
            cornerSize: CGSize(width: 4, height: 4)
          )
          
          context.fill(
            path,
            with: .linearGradient(
              Gradient(colors: [color.opacity(0.3), color]),
              startPoint: CGPoint(x: x, y: y + height),
              endPoint: CGPoint(x: x, y: y)
            )
          )
        }
      }
    }
  }
}

/// 粒子路径视图模型
class ParticlePathViewModel: ObservableObject {
  struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var opacity: Double
  }
  
  @Published var particles: [Particle] = []
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    generateParticles()
    startTimer()
  }
  
  private func generateParticles() {
    particles = (0..<50).map { _ in
      Particle(
        position: CGPoint(x: 0, y: 0),
        velocity: CGPoint(
          x: CGFloat.random(in: -1...1),
          y: CGFloat.random(in: -1...1)
        ),
        size: CGFloat.random(in: 2...4),
        opacity: Double.random(in: 0.3...0.8)
      )
    }
  }
  
  private func startTimer() {
    Timer.publish(every: 0.016, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.updateParticles()
      }
      .store(in: &cancellables)
  }
  
  private func updateParticles() {
    for i in particles.indices {
      particles[i].position.x += particles[i].velocity.x
      particles[i].position.y += particles[i].velocity.y
      particles[i].opacity -= 0.01
      
      if particles[i].opacity <= 0 {
        particles[i] = Particle(
          position: CGPoint(x: 0, y: 0),
          velocity: CGPoint(
            x: CGFloat.random(in: -1...1),
            y: CGFloat.random(in: -1...1)
          ),
          size: CGFloat.random(in: 2...4),
          opacity: Double.random(in: 0.3...0.8)
        )
      }
    }
  }
}

/// 粒子路径
struct ParticlePath: View {
  @StateObject private var viewModel = ParticlePathViewModel()
  let path: Path
  let color: Color
  
  var body: some View {
    TimelineView(.animation) { _ in
      Canvas { context, size in
        // 绘制主路径
        context.stroke(
          path,
          with: .color(color.opacity(0.3)),
          style: StrokeStyle(lineWidth: 1)
        )
        
        // 绘制粒子
        for particle in viewModel.particles {
          context.opacity = particle.opacity
          context.fill(
            Path(ellipseIn: CGRect(
              x: particle.position.x - particle.size/2,
              y: particle.position.y - particle.size/2,
              width: particle.size,
              height: particle.size
            )),
            with: .color(color)
          )
        }
      }
    }
  }
}

/// 手写文字动画
struct HandwritingPath: View {
  let text: String
  @State private var progress: CGFloat = 0
  
  var body: some View {
    Canvas { context, size in
      let center = CGPoint(x: size.width/2, y: size.height/2)
      
      // 创建文字路径
      var path = Path()
      let letters = Array(text)
      let letterWidth = size.width / CGFloat(letters.count)
      let letterHeight = size.height * 0.5
      
      for (index, letter) in letters.enumerated() {
        let x = letterWidth * CGFloat(index)
        let y = center.y - letterHeight/2
        
        var letterPath = Path()
        letterPath.addRect(CGRect(x: x, y: y, width: letterWidth * 0.8, height: letterHeight))
        
        // 使用进度来控制每个字母的显示
        let letterProgress = progress * CGFloat(letters.count)
        if CGFloat(index) <= letterProgress {
          context.stroke(
            letterPath,
            with: .linearGradient(
              Gradient(colors: [.blue, .purple]),
              startPoint: CGPoint(x: x, y: y),
              endPoint: CGPoint(x: x + letterWidth, y: y + letterHeight)
            ),
            style: StrokeStyle(
              lineWidth: 2,
              dash: [8, 4],
              dashPhase: -progress * 20
            )
          )
        }
      }
      
      // 添加装饰线
      var decorationPath = Path()
      decorationPath.move(to: CGPoint(x: 0, y: center.y + letterHeight/2 + 10))
      decorationPath.addLine(to: CGPoint(x: size.width, y: center.y + letterHeight/2 + 10))
      
      context.stroke(
        decorationPath,
        with: .color(.blue.opacity(0.3)),
        style: StrokeStyle(
          lineWidth: 1,
          dash: [5, 5]
        )
      )
    }
    .onAppear {
      withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
        progress = 1
      }
    }
  }
}

// MARK: - 交互效果

/// 可变形路径
struct MorphingPath: View {
  @State private var points: [CGPoint] = []
  @State private var draggedPoint: Int?
  @State private var showHelp = true
  let pathClosed: Bool
  
  private func initializePoints(in size: CGSize) {
    points.removeAll()
    let radius = min(size.width, size.height) / 3
    let center = CGPoint(x: size.width/2, y: size.height/2)
    let count = 5
    
    for i in 0..<count {
      let angle = 2 * .pi * Double(i) / Double(count)
      points.append(CGPoint(
        x: center.x + radius * CGFloat(cos(angle)),
        y: center.y + radius * CGFloat(sin(angle))
      ))
    }
  }
  
  var body: some View {
    VStack(spacing: 16) {
      // 使用说明
      if showHelp {
        VStack(alignment: .leading, spacing: 8) {
          Text("使用说明：")
            .font(.headline)
          Text("• 拖动蓝色控制点来改变形状")
          Text("• 形状会自动闭合并填充渐变色")
          Text("• 双击空白处添加新的控制点")
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .overlay(
          Button(action: { showHelp = false }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
            .padding(8),
          alignment: .topTrailing
        )
      }
      
      // 绘图区域
      GeometryReader { geometry in
        Canvas { context, size in
          let center = CGPoint(x: size.width/2, y: size.height/2)
          
          // 如果没有点，显示提示圆圈
          if points.isEmpty {
            let radius = min(size.width, size.height) / 4
            context.stroke(
              Path(ellipseIn: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
              )),
              with: .color(.gray.opacity(0.5)),
              style: StrokeStyle(
                lineWidth: 2,
                dash: [5, 5]
              )
            )
            return
          }
          
          // 绘制路径
          var path = Path()
          path.move(to: points[0])
          
          for i in 1..<points.count {
            path.addLine(to: points[i])
          }
          
          if pathClosed {
            path.closeSubpath()
          }
          
          // 填充渐变
          if pathClosed {
            context.fill(
              path,
              with: .linearGradient(
                Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
              )
            )
          }
          
          // 绘制路径
          context.stroke(
            path,
            with: .linearGradient(
              Gradient(colors: [.blue, .purple]),
              startPoint: CGPoint(x: 0, y: 0),
              endPoint: CGPoint(x: size.width, y: size.height)
            ),
            style: StrokeStyle(lineWidth: 2)
          )
          
          // 绘制控制点
          for point in points {
            // 绘制点的阴影
            context.fill(
              Path(ellipseIn: CGRect(
                x: point.x - 6,
                y: point.y - 6,
                width: 12,
                height: 12
              )),
              with: .color(.black.opacity(0.2))
            )
            // 绘制点
            context.fill(
              Path(ellipseIn: CGRect(
                x: point.x - 5,
                y: point.y - 5,
                width: 10,
                height: 10
              )),
              with: .color(.blue)
            )
          }
        }
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { value in
              if let draggedPoint = draggedPoint {
                points[draggedPoint] = value.location
              } else {
                // 查找最近的点
                let location = value.location
                if let nearestPoint = points.enumerated().min(by: { first, second in
                  let firstDistance = first.element.distance(to: location)
                  let secondDistance = second.element.distance(to: location)
                  return firstDistance < secondDistance
                }), nearestPoint.element.distance(to: location) < 20 {
                  draggedPoint = nearestPoint.offset
                  points[nearestPoint.offset] = location
                }
              }
            }
            .onEnded { _ in
              draggedPoint = nil
            }
        )
        .simultaneousGesture(
          SpatialTapGesture(count: 2)
            .onEnded { value in
              // 双击添加新点
              points.append(value.location)
            }
        )
        .onAppear {
          initializePoints(in: geometry.size)
        }
      }
      .padding(.horizontal)
    }
  }
}

/// 路径绘制游戏
struct PathDrawingGame: View {
  struct TargetPath {
    let path: Path
    var completed: Bool
  }
  
  @State private var currentPath: Path?
  @State private var targetPaths: [TargetPath]
  @State private var score = 0
  
  init() {
    // 创建目标路径
    let size = CGSize(width: 300, height: 300)
    var paths: [TargetPath] = []
    
    // 添加一些简单的形状作为目标
    // 正方形
    var path = Path()
    path.addRect(CGRect(x: 50, y: 50, width: 50, height: 50))
    paths.append(TargetPath(path: path, completed: false))
    
    // 圆形
    path = Path()
    path.addEllipse(in: CGRect(x: 150, y: 50, width: 50, height: 50))
    paths.append(TargetPath(path: path, completed: false))
    
    // 三角形
    path = Path()
    path.move(to: CGPoint(x: 50, y: 150))
    path.addLine(to: CGPoint(x: 100, y: 150))
    path.addLine(to: CGPoint(x: 75, y: 100))
    path.closeSubpath()
    paths.append(TargetPath(path: path, completed: false))
    
    _targetPaths = State(initialValue: paths)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      // 分数显示
      HStack {
        Text("分数: \(score)")
          .font(.title2)
          .foregroundColor(.blue)
        
        Spacer()
        
        Button("重置") {
          resetGame()
        }
        .buttonStyle(.bordered)
      }
      .padding(.horizontal)
      
      // 游戏区域
      Canvas { context, size in
        // 绘制目标路径
        for targetPath in targetPaths {
          context.stroke(
            targetPath.path,
            with: .color(targetPath.completed ? .green : .gray),
            style: StrokeStyle(lineWidth: 2)
          )
        }
        
        // 绘制当前路径
        if let currentPath = currentPath {
          context.stroke(
            currentPath,
            with: .color(.blue),
            style: StrokeStyle(lineWidth: 2)
          )
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            let point = value.location
            if currentPath == nil {
              var path = Path()
              path.move(to: point)
              currentPath = path
            } else {
              var path = currentPath!
              path.addLine(to: point)
              currentPath = path
            }
          }
          .onEnded { _ in
            checkPath()
            currentPath = nil
          }
      )
      .frame(maxWidth: .infinity)
      .frame(height: 250)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.gray.opacity(0.2), lineWidth: 1)
      )
      .padding(.horizontal)
    }
  }
  
  private func checkPath() {
    // 这里应该实现路径匹配算法
    // 简单示例：检查起点和终点是否接近
    guard let drawnPath = currentPath else { return }
    
    for i in targetPaths.indices where !targetPaths[i].completed {
      let targetPath = targetPaths[i].path
      let targetBounds = targetPath.boundingRect
      let drawnBounds = drawnPath.boundingRect
      
      // 简单的边界框重叠检测
      if targetBounds.intersects(drawnBounds) {
        targetPaths[i].completed = true
        score += 100
        break
      }
    }
  }
  
  private func resetGame() {
    for i in targetPaths.indices {
      targetPaths[i].completed = false
    }
    score = 0
    currentPath = nil
  }
}

// MARK: - 实用效果

/// 自定义饼图
struct CustomPieChart: View {
  struct Segment: Identifiable {
    let id = UUID()
    var value: Double
    var color: Color
    var label: String
  }
  
  let segments: [Segment]
  @State private var selectedSegment: UUID?
  @State private var highlightedSegment: UUID?
  
  var body: some View {
    Canvas { context, size in
      let total = segments.reduce(0) { $0 + $1.value }
      let center = CGPoint(x: size.width/2, y: size.height/2)
      let radius = min(size.width, size.height) / 2 * 0.8
      
      var startAngle = Angle.degrees(-90)
      for segment in segments {
        let endAngle = startAngle + Angle.degrees(360 * (segment.value / total))
        
        var path = Path()
        path.move(to: center)
        path.addArc(
          center: center,
          radius: radius * (segment.id == selectedSegment ? 1.1 : 1.0),
          startAngle: startAngle,
          endAngle: endAngle,
          clockwise: false
        )
        path.closeSubpath()
        
        context.fill(
          path,
          with: .color(segment.id == highlightedSegment ? segment.color.opacity(0.8) : segment.color)
        )
        
        // 添加标签
        let midAngle = startAngle + Angle.degrees(360 * (segment.value / total) / 2)
        let labelRadius = radius * 0.7
        let labelPosition = CGPoint(
          x: center.x + CGFloat(cos(midAngle.radians)) * labelRadius,
          y: center.y + CGFloat(sin(midAngle.radians)) * labelRadius
        )
        
        context.draw(
          Text(segment.label)
            .font(.caption)
            .foregroundColor(.white),
          at: labelPosition
        )
        
        startAngle = endAngle
      }
    }
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged { value in
          let center = CGPoint(x: value.startLocation.x, y: value.startLocation.y)
          highlightedSegment = findSegment(at: center)
        }
        .onEnded { value in
          let center = CGPoint(x: value.startLocation.x, y: value.startLocation.y)
          selectedSegment = findSegment(at: center)
          highlightedSegment = nil
        }
    )
  }
  
  private func findSegment(at point: CGPoint) -> UUID? {
    // 这里应该实现点击检测算法
    // 简单示例：返回第一个段
    return segments.first?.id
  }
}

/// 雷达扫描效果
struct RadarScanEffect: View {
  @State private var angle: Double = 0
  
  var body: some View {
    Canvas { context, size in
      let center = CGPoint(x: size.width/2, y: size.height/2)
      let radius = min(size.width, size.height) / 2
      
      // 绘制背景圆圈
      for i in 1...3 {
        let circlePath = Path(ellipseIn: CGRect(
          x: center.x - radius * CGFloat(i) / 3,
          y: center.y - radius * CGFloat(i) / 3,
          width: radius * 2 * CGFloat(i) / 3,
          height: radius * 2 * CGFloat(i) / 3
        ))
        context.stroke(
          circlePath,
          with: .color(.green.opacity(0.3)),
          style: StrokeStyle(lineWidth: 1)
        )
      }
      
      // 绘制扫描线
      var scanPath = Path()
      scanPath.move(to: center)
      scanPath.addLine(to: CGPoint(
        x: center.x + cos(angle) * radius,
        y: center.y + sin(angle) * radius
      ))
      
      context.stroke(
        scanPath,
        with: .color(.green),
        style: StrokeStyle(lineWidth: 2)
      )
      
      // 绘制扫描区域
      var scanArea = Path()
      scanArea.move(to: center)
      scanArea.addArc(
        center: center,
        radius: radius,
        startAngle: Angle.degrees(angle * 180 / .pi - 30),
        endAngle: Angle.degrees(angle * 180 / .pi),
        clockwise: false
      )
      scanArea.closeSubpath()
      
      context.fill(
        scanArea,
        with: .color(.green.opacity(0.2))
      )
    }
    .onAppear {
      withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
        angle = 2 * .pi
      }
    }
  }
}

/// 仪表盘
struct DashboardGauge: View {
  let value: Double
  let range: ClosedRange<Double>
  let gradient: Gradient
  
  var body: some View {
    Canvas { context, size in
      let center = CGPoint(x: size.width/2, y: size.height/2)
      let radius = min(size.width, size.height) / 2 * 0.8
      
      // 绘制背景圆弧
      var path = Path()
      path.addArc(
        center: center,
        radius: radius,
        startAngle: Angle.degrees(180),
        endAngle: Angle.degrees(0),
        clockwise: false
      )
      
      context.stroke(
        path,
        with: .color(.gray.opacity(0.2)),
        style: StrokeStyle(
          lineWidth: 20,
          lineCap: .round
        )
      )
      
      // 绘制值指示器
      let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
      let endAngle = Angle.degrees(180 - 180 * progress)
      
      path = Path()
      path.addArc(
        center: center,
        radius: radius,
        startAngle: Angle.degrees(180),
        endAngle: endAngle,
        clockwise: false
      )
      
      context.stroke(
        path,
        with: .linearGradient(
          gradient,
          startPoint: CGPoint(x: 0, y: center.y),
          endPoint: CGPoint(x: size.width, y: center.y)
        ),
        style: StrokeStyle(
          lineWidth: 20,
          lineCap: .round
        )
      )
      
      // 绘制当前值
      context.draw(
        Text(String(format: "%.0f", value))
          .font(.system(size: 36, weight: .bold, design: .rounded)),
        at: CGPoint(x: center.x, y: center.y + radius * 0.3)
      )
    }
  }
}

// MARK: - 艺术效果

/// 分形图案
struct FractalPattern: View {
  let depth: Int
  let angle: Double
  let scale: Double
  
  var body: some View {
    Canvas { context, size in
      func drawBranch(
        from start: CGPoint,
        length: Double,
        angle: Double,
        depth: Int
      ) {
        guard depth > 0 else { return }
        
        let end = CGPoint(
          x: start.x + cos(angle) * length,
          y: start.y + sin(angle) * length
        )
        
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        
        context.stroke(
          path,
          with: .color(.purple.opacity(Double(depth) / Double(self.depth))),
          lineWidth: Double(depth)
        )
        
        let newLength = length * scale
        drawBranch(
          from: end,
          length: newLength,
          angle: angle - self.angle,
          depth: depth - 1
        )
        drawBranch(
          from: end,
          length: newLength,
          angle: angle + self.angle,
          depth: depth - 1
        )
      }
      
      let start = CGPoint(x: size.width/2, y: size.height)
      drawBranch(
        from: start,
        length: size.height * 0.3,
        angle: -.pi/2,
        depth: depth
      )
    }
  }
}

/// 几何艺术
struct GeometricArt: View {
  // MARK: - 类型定义
  private struct LineSegment {
    let start: CGPoint
    let end: CGPoint
  }
  
  // MARK: - 属性
  @State private var phase = 0.0
  private let segmentCount = 12
  private let colors: [Color] = [.blue, .purple]
  
  // MARK: - 私有方法
  private func calculatePoint(
    center: CGPoint,
    radius: CGFloat,
    angle: Double
  ) -> CGPoint {
    CGPoint(
      x: center.x + CGFloat(cos(angle)) * radius,
      y: center.y + CGFloat(sin(angle)) * radius
    )
  }
  
  private func createSegment(
    index: Int,
    center: CGPoint,
    radius: CGFloat
  ) -> LineSegment {
    let angle1 = 2 * .pi * Double(index) / Double(segmentCount) + phase
    let angle2 = 2 * .pi * Double((index + segmentCount/3) % segmentCount) / Double(segmentCount) + phase
    
    return LineSegment(
      start: calculatePoint(center: center, radius: radius, angle: angle1),
      end: calculatePoint(center: center, radius: radius, angle: angle2)
    )
  }
  
  private func drawSegment(
    context: GraphicsContext,
    segment: LineSegment
  ) {
    var path = Path()
    path.move(to: segment.start)
    path.addLine(to: segment.end)
    
    context.stroke(
      path,
      with: .linearGradient(
        Gradient(colors: colors),
        startPoint: segment.start,
        endPoint: segment.end
      ),
      style: StrokeStyle(lineWidth: 2)
    )
  }
  
  // MARK: - Body
  var body: some View {
    TimelineView(.animation) { _ in
      Canvas { context, size in
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let radius = min(size.width, size.height) / 2 * 0.8
        
        for i in 0..<segmentCount {
          let segment = createSegment(
            index: i,
            center: center,
            radius: radius
          )
          drawSegment(context: context, segment: segment)
        }
      }
    }
    .onAppear {
      withAnimation(
        .linear(duration: 10)
        .repeatForever(autoreverses: false)
      ) {
        phase = 2 * .pi
      }
    }
  }
}

// MARK: - 辅助扩展
extension CGPoint {
  func distance(to other: CGPoint) -> CGFloat {
    sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
  }
}

