import SwiftUI

// MARK: - 辅助类型

/// 实时绘制视图模型
class LiveDrawingViewModel: ObservableObject {
  @Published var points: [CGPoint] = []
  @Published var color: Color = .blue
  @Published var lineWidth: CGFloat = 2
  
  func clear() {
    points.removeAll()
  }
}

/// 波浪动画视图模型
class WaveAnimationViewModel: ObservableObject {
  @Published var phase: Double = 0
  @Published var amplitude: Double = 20
  @Published var frequency: Double = 2
}

/// 粒子系统视图模型
class ParticleSystemViewModel: ObservableObject {
  struct Particle: Identifiable, Equatable {
    let id: UUID
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var opacity: Double
    var color: Color
    
    static func == (lhs: Particle, rhs: Particle) -> Bool {
      lhs.id == rhs.id &&
      lhs.position == rhs.position &&
      lhs.velocity == rhs.velocity &&
      lhs.size == rhs.size &&
      lhs.opacity == rhs.opacity &&
      lhs.color == rhs.color
    }
  }
  
  @Published var particles: [Particle] = []
  
  func update() {
    particles = particles.compactMap { particle in
      var newParticle = particle
      newParticle.position.x += particle.velocity.x
      newParticle.position.y += particle.velocity.y
      newParticle.opacity -= 0.01
      
      return newParticle.opacity > 0 ? newParticle : nil
    }
  }
  
  func addParticle(at position: CGPoint) {
    let colors: [Color] = [.blue, .purple, .pink]
    let particle = Particle(
      id: UUID(),
      position: position,
      velocity: CGPoint(
        x: CGFloat.random(in: -2...2),
        y: CGFloat.random(in: -2...2)
      ),
      size: CGFloat.random(in: 3...8),
      opacity: 1.0,
      color: colors.randomElement() ?? .blue
    )
    particles.append(particle)
  }
}

// MARK: - 示例视图

/// 实时绘制视图
struct LiveDrawingView: View {
  @StateObject private var viewModel = LiveDrawingViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      // 工具栏
      HStack {
        ColorPicker("颜色", selection: $viewModel.color)
          .labelsHidden()
        
        Slider(value: $viewModel.lineWidth, in: 1...10) {
          Text("线宽")
        }
        .frame(width: 100)
        
        Button("清除") {
          viewModel.clear()
        }
      }
      .padding(.horizontal)
      
      // 画布
      Canvas { context, size in
        var path = Path()
        if let start = viewModel.points.first {
          path.move(to: start)
          for point in viewModel.points.dropFirst() {
            path.addLine(to: point)
          }
        }
        
        context.stroke(
          path,
          with: .color(viewModel.color),
          style: StrokeStyle(
            lineWidth: viewModel.lineWidth,
            lineCap: .round,
            lineJoin: .round
          )
        )
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            viewModel.points.append(value.location)
          }
      )
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
    }
  }
}

/// 波浪动画视图
struct WaveAnimationView: View {
  @StateObject private var viewModel = WaveAnimationViewModel()
  
  var body: some View {
    VStack(spacing: 16) {
      // 控制面板
      VStack {
        HStack {
          Text("振幅")
          Slider(value: $viewModel.amplitude, in: 0...50)
        }
        
        HStack {
          Text("频率")
          Slider(value: $viewModel.frequency, in: 0...5)
        }
      }
      .padding(.horizontal)
      
      // 波浪动画
      Canvas { context, size in
        let width = size.width
        let height = size.height
        let midHeight = height / 2
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
          let relativeX = x / width
          let y = midHeight + sin(relativeX * viewModel.frequency * .pi * 2 + viewModel.phase) * viewModel.amplitude
          path.addLine(to: CGPoint(x: x, y: y))
        }
        
        context.stroke(
          path,
          with: .linearGradient(
            Gradient(colors: [.blue, .purple]),
            startPoint: CGPoint(x: 0, y: midHeight),
            endPoint: CGPoint(x: width, y: midHeight)
          ),
          style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
        )
      }
      .onAppear {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
          viewModel.phase = 2 * .pi
        }
      }
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
    }
  }
}

/// 粒子系统视图
struct ParticleSystemView: View {
  @StateObject private var viewModel = ParticleSystemViewModel()
  
  var body: some View {
    TimelineView(.animation) { _ in
      Canvas { context, size in
        for particle in viewModel.particles {
          let rect = CGRect(
            x: particle.position.x - particle.size/2,
            y: particle.position.y - particle.size/2,
            width: particle.size,
            height: particle.size
          )
          
          context.opacity = particle.opacity
          context.fill(
            Circle().path(in: rect),
            with: .color(particle.color)
          )
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            viewModel.addParticle(at: value.location)
          }
      )
      .onChange(of: viewModel.particles) { _ in
        viewModel.update()
      }
    }
    .background(Color.black)
    .cornerRadius(12)
  }
}

// MARK: - 主视图
struct CanvasDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础绘制
      Section("基础绘制") {
        // 1. 基本形状
        VStack(alignment: .leading) {
          Text("基本形状")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Canvas { context, size in
            // 矩形
            context.fill(
              Path(CGRect(x: 10, y: 10, width: 40, height: 40)),
              with: .color(.blue)
            )
            
            // 圆形
            context.fill(
              Circle().path(in: CGRect(x: 60, y: 10, width: 40, height: 40)),
              with: .color(.green)
            )
            
            // 三角形
            var path = Path()
            path.move(to: CGPoint(x: 110, y: 50))
            path.addLine(to: CGPoint(x: 130, y: 10))
            path.addLine(to: CGPoint(x: 150, y: 50))
            path.closeSubpath()
            context.fill(path, with: .color(.orange))
          }
          .frame(height: 70)
        }
        
        // 2. 渐变效果
        VStack(alignment: .leading) {
          Text("渐变效果")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Canvas { context, size in
            context.fill(
              Path(CGRect(origin: .zero, size: size)),
              with: .linearGradient(
                Gradient(colors: [.blue, .purple]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
              )
            )
          }
          .frame(height: 70)
        }
        
        // 3. 描边样式
        VStack(alignment: .leading) {
          Text("描边样式")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Canvas { context, size in
            let rect = CGRect(x: 10, y: 10, width: size.width - 20, height: size.height - 20)
            
            // 实线
            context.stroke(
              Path(rect),
              with: .color(.blue),
              style: StrokeStyle(lineWidth: 2)
            )
            
            // 虚线
            context.stroke(
              Path(CGRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40)),
              with: .color(.purple),
              style: StrokeStyle(
                lineWidth: 2,
                dash: [5, 5]
              )
            )
          }
          .frame(height: 70)
        }
      }
      
      // MARK: - 交互绘制
      Section("交互绘制") {
        // 1. 实时绘制
        VStack(alignment: .leading) {
          Text("实时绘制")
            .font(.caption)
            .foregroundColor(.secondary)
          
          LiveDrawingView()
            .frame(height: 200)
        }
        
        // 2. 粒子系统
        VStack(alignment: .leading) {
          Text("粒子系统")
            .font(.caption)
            .foregroundColor(.secondary)
          
          ParticleSystemView()
            .frame(height: 200)
        }
      }
      
      // MARK: - 动画效果
      Section("动画效果") {
        // 1. 波浪动画
        VStack(alignment: .leading) {
          Text("波浪动画")
            .font(.caption)
            .foregroundColor(.secondary)
          
          WaveAnimationView()
            .frame(height: 200)
        }
      }
    }
    .navigationTitle("Canvas 示例")
  }
}

#Preview {
  NavigationStack {
    CanvasDemoView()
  }
}
