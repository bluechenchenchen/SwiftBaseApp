import SwiftUI
import Combine

// MARK: - 基础形状

/// 心形
struct HeartShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.width
    let height = rect.height
    
    path.move(to: CGPoint(x: width * 0.5, y: height * 0.25))
    path.addCurve(
      to: CGPoint(x: width, y: height * 0.25),
      control1: CGPoint(x: width * 0.5, y: height * 0.1),
      control2: CGPoint(x: width * 0.75, y: height * 0.1)
    )
    path.addCurve(
      to: CGPoint(x: width * 0.5, y: height),
      control1: CGPoint(x: width * 1.25, y: height * 0.5),
      control2: CGPoint(x: width * 0.5, y: height * 0.75)
    )
    path.addCurve(
      to: CGPoint(x: 0, y: height * 0.25),
      control1: CGPoint(x: width * 0.5, y: height * 0.75),
      control2: CGPoint(x: -width * 0.25, y: height * 0.5)
    )
    path.addCurve(
      to: CGPoint(x: width * 0.5, y: height * 0.25),
      control1: CGPoint(x: width * 0.25, y: height * 0.1),
      control2: CGPoint(x: width * 0.5, y: height * 0.1)
    )
    return path
  }
}

/// 齿轮
struct GearShape: Shape {
  let teeth: Int
  let innerRadius: CGFloat
  let outerRadius: CGFloat
  let toothWidth: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let angleStep = 2 * .pi / CGFloat(teeth)
    
    var path = Path()
    for i in 0..<teeth {
      let angle = CGFloat(i) * angleStep
      let nextAngle = angle + angleStep
      let toothAngle = toothWidth / outerRadius
      
      // 内圆弧
      path.addArc(
        center: center,
        radius: innerRadius,
        startAngle: .radians(angle),
        endAngle: .radians(nextAngle),
        clockwise: false
      )
      
      // 齿轮外形
      path.addLine(to: CGPoint(
        x: center.x + outerRadius * cos(nextAngle - toothAngle),
        y: center.y + outerRadius * sin(nextAngle - toothAngle)
      ))
      path.addLine(to: CGPoint(
        x: center.x + outerRadius * cos(nextAngle),
        y: center.y + outerRadius * sin(nextAngle)
      ))
    }
    path.closeSubpath()
    return path
  }
}

/// 多边形生成器
struct PolygonShape: Shape {
  let sides: Int
  let inset: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2 - inset
    let angleStep = 2 * .pi / CGFloat(sides)
    
    var path = Path()
    for i in 0..<sides {
      let angle = CGFloat(i) * angleStep - .pi / 2
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
    return path
  }
}

/// 螺旋线
struct SpiralShape: Shape {
  let rotations: Int
  let decay: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2
    let angleStep = 0.1
    let maxAngle = Double(rotations) * 2 * .pi
    
    var path = Path()
    path.move(to: center)
    
    for angle in stride(from: 0.0, through: maxAngle, by: angleStep) {
      let distance = radius * (1 - decay * CGFloat(angle) / maxAngle)
      let x = center.x + distance * cos(angle)
      let y = center.y + distance * sin(angle)
      path.addLine(to: CGPoint(x: x, y: y))
    }
    
    return path
  }
}

// MARK: - 动画组件

/// 波纹效果
struct RippleShape: Shape {
  var rippleCount: Int
  var progress: CGFloat
  
  var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let maxRadius = min(rect.width, rect.height) / 2
    let stepRadius = maxRadius / CGFloat(rippleCount)
    
    var path = Path()
    
    for i in 0..<rippleCount {
      let radius = stepRadius * CGFloat(i + 1) * progress
      path.addEllipse(in: CGRect(
        x: center.x - radius,
        y: center.y - radius,
        width: radius * 2,
        height: radius * 2
      ))
    }
    
    return path
  }
}

/// 可拖拽变形形状
struct DraggableShape: View {
  @State private var offset: CGSize = .zero
  @State private var scale: CGFloat = 1.0
  let shape: AnyShape
  let color: Color
  
  var body: some View {
    shape
      .fill(color)
      .frame(width: 100, height: 100)
      .scaleEffect(scale)
      .offset(offset)
      .gesture(
        DragGesture()
          .onChanged { value in
            offset = value.translation
            scale = 1.2
          }
          .onEnded { _ in
            withAnimation(.spring()) {
              offset = .zero
              scale = 1.0
            }
          }
      )
  }
}

/// 爆炸效果
struct ExplosionEffect: View {
  @Binding var isExploding: Bool
  let particleCount: Int
  let color: Color
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<particleCount, id: \.self) { i in
          Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(
              x: isExploding ? CGFloat.random(in: -100...100) : 0,
              y: isExploding ? CGFloat.random(in: -100...100) : 0
            )
            .opacity(isExploding ? 0 : 1)
            .animation(
              .spring(
                response: 0.6,
                dampingFraction: 0.8,
                blendDuration: 0.8
              ).delay(Double.random(in: 0...0.3)),
              value: isExploding
            )
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}

// MARK: - 实用组件

/// 星级评分
struct StarRating: View {
  let rating: Int
  let maxRating: Int
  let size: CGFloat
  let color: Color
  
  var body: some View {
    HStack {
      ForEach(1...maxRating, id: \.self) { index in
        Star(points: 5, innerRadius: size * 0.4)
          .fill(index <= rating ? color : .gray.opacity(0.3))
          .frame(width: size, height: size)
      }
    }
  }
}

/// 音量可视化器的视图模型
class AudioVisualizerViewModel: ObservableObject {
  @Published var amplitudes: [CGFloat]
  private var cancellables = Set<AnyCancellable>()
  private let barCount: Int
  
  init(barCount: Int) {
    self.barCount = barCount
    self.amplitudes = Array(repeating: 0.2, count: barCount)
    startTimer()
  }
  
  private func startTimer() {
    Timer.publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self else { return }
        for i in 0..<self.barCount {
          self.amplitudes[i] = CGFloat.random(in: 0.2...1.0)
        }
      }
      .store(in: &cancellables)
  }
}

/// 音量可视化器
struct AudioVisualizer: View {
  @StateObject private var viewModel: AudioVisualizerViewModel
  let barCount: Int
  let color: Color
  
  init(barCount: Int = 20, color: Color = .blue) {
    self.barCount = barCount
    self.color = color
    _viewModel = StateObject(wrappedValue: AudioVisualizerViewModel(barCount: barCount))
  }
  
  var body: some View {
    HStack(spacing: 4) {
      ForEach(0..<barCount, id: \.self) { index in
        RoundedRectangle(cornerRadius: 2)
          .fill(color)
          .frame(width: 4, height: 50 * viewModel.amplitudes[index])
          .animation(
            .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)
            .repeatForever()
            .delay(Double(index) * 0.05),
            value: viewModel.amplitudes[index]
          )
      }
    }
  }
}

/// 雷达图
struct RadarChart: View {
  let values: [CGFloat]
  let labels: [String]
  let maxValue: CGFloat
  let color: Color
  
  var body: some View {
    GeometryReader { geometry in
      let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
      let radius = min(geometry.size.width, geometry.size.height) / 2
      let angleStep = 2 * .pi / CGFloat(values.count)
      
      ZStack {
        // 背景网格
        Path { path in
          for i in 0..<values.count {
            let angle = CGFloat(i) * angleStep - .pi / 2
            path.move(to: center)
            path.addLine(to: CGPoint(
              x: center.x + radius * cos(angle),
              y: center.y + radius * sin(angle)
            ))
          }
        }
        .stroke(Color.gray.opacity(0.3))
        
        // 数据区域
        Path { path in
          for i in 0..<values.count {
            let angle = CGFloat(i) * angleStep - .pi / 2
            let value = values[i] / maxValue
            let point = CGPoint(
              x: center.x + radius * value * cos(angle),
              y: center.y + radius * value * sin(angle)
            )
            
            if i == 0 {
              path.move(to: point)
            } else {
              path.addLine(to: point)
            }
          }
          path.closeSubpath()
        }
        .fill(color.opacity(0.2))
        .overlay(
          Path { path in
            for i in 0..<values.count {
              let angle = CGFloat(i) * angleStep - .pi / 2
              let value = values[i] / maxValue
              let point = CGPoint(
                x: center.x + radius * value * cos(angle),
                y: center.y + radius * value * sin(angle)
              )
              
              if i == 0 {
                path.move(to: point)
              } else {
                path.addLine(to: point)
              }
            }
            path.closeSubpath()
          }
            .stroke(color, lineWidth: 2)
        )
        
        // 标签
        ForEach(0..<values.count, id: \.self) { i in
          let angle = CGFloat(i) * angleStep - .pi / 2
          let point = CGPoint(
            x: center.x + (radius + 20) * cos(angle),
            y: center.y + (radius + 20) * sin(angle)
          )
          
          Text(labels[i])
            .font(.caption)
            .position(point)
        }
      }
    }
  }
}

// MARK: - 加载动画集
struct LoadingAnimations: View {
  @State private var isAnimating = false
  let color: Color
  
  var body: some View {
    HStack(spacing: 30) {
      // 旋转圆点
      ZStack {
        ForEach(0..<8) { i in
          Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(y: -20)
            .rotationEffect(.degrees(Double(i) * 45))
            .opacity(isAnimating ? 1 : 0.3)
            .animation(
              .linear(duration: 1)
              .repeatForever()
              .delay(Double(i) * 0.1),
              value: isAnimating
            )
        }
      }
      .frame(width: 50, height: 50)
      
      // 弹跳球
      HStack(spacing: 5) {
        ForEach(0..<3) { i in
          Circle()
            .fill(color)
            .frame(width: 10, height: 10)
            .offset(y: isAnimating ? -15 : 0)
            .animation(
              .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)
              .repeatForever()
              .delay(Double(i) * 0.2),
              value: isAnimating
            )
        }
      }
      
      // 脉冲圆环
      ZStack {
        Circle()
          .stroke(color.opacity(0.3), lineWidth: 4)
          .frame(width: 40, height: 40)
        
        Circle()
          .trim(from: 0, to: 0.8)
          .stroke(color, lineWidth: 4)
          .frame(width: 40, height: 40)
          .rotationEffect(.degrees(isAnimating ? 360 : 0))
          .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
      }
    }
    .onAppear {
      isAnimating = true
    }
  }
}

// MARK: - 组合效果

/// 万花筒效果
struct KaleidoscopeView: View {
  @State private var rotation = 0.0
  let segments: Int
  let content: AnyShape
  
  var body: some View {
    GeometryReader { geometry in
      let size = min(geometry.size.width, geometry.size.height)
      ZStack {
        ForEach(0..<segments, id: \.self) { i in
          content
            .fill(
              AngularGradient(
                gradient: Gradient(colors: [.blue, .purple, .pink]),
                center: .center,
                startAngle: .degrees(Double(i) * 360 / Double(segments)),
                endAngle: .degrees(Double(i + 1) * 360 / Double(segments))
              )
            )
            .frame(width: size * 0.4, height: size * 0.4)
            .rotationEffect(.degrees(360 / Double(segments) * Double(i) + rotation))
        }
      }
      .frame(width: size, height: size)
    }
    .onAppear {
      withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
        rotation = 360
      }
    }
  }
}

/// 粒子系统
struct ParticleSystem: View {
  struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var scale: CGFloat
    var opacity: Double
  }
  
  @State private var particles: [Particle] = []
  let particleCount: Int
  let emitterPosition: CGPoint
  let color: Color
  
  var body: some View {
    TimelineView(.animation) { timeline in
      Canvas { context, size in
        for particle in particles {
          context.opacity = particle.opacity
          context.fill(
            Path(ellipseIn: CGRect(
              x: particle.position.x - particle.scale / 2,
              y: particle.position.y - particle.scale / 2,
              width: particle.scale,
              height: particle.scale
            )),
            with: .color(color)
          )
        }
      }
      .onChange(of: timeline.date) { _ in
        updateParticles()
      }
    }
    .onAppear {
      // 初始化粒子
      for _ in 0..<particleCount {
        particles.append(createParticle())
      }
    }
  }
  
  private func createParticle() -> Particle {
    let angle = Double.random(in: 0...2 * .pi)
    let speed = Double.random(in: 1...3)
    return Particle(
      position: emitterPosition,
      velocity: CGPoint(
        x: cos(angle) * speed,
        y: sin(angle) * speed
      ),
      scale: CGFloat.random(in: 2...6),
      opacity: Double.random(in: 0.3...0.8)
    )
  }
  
  private func updateParticles() {
    for i in particles.indices {
      particles[i].position.x += particles[i].velocity.x
      particles[i].position.y += particles[i].velocity.y
      particles[i].opacity -= 0.01
      
      if particles[i].opacity <= 0 {
        particles[i] = createParticle()
      }
    }
  }
}
