import SwiftUI


// MARK: - 自定义形状

/// 三角形
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

/// 星形
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

/// 波浪线
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

// MARK: - 辅助视图

/// 自定义按钮
struct ShapeButton: View {
  let title: String
  let action: () -> Void
  @State private var isPressed = false
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .foregroundColor(.white)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: isPressed ? 15 : 10)
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(radius: isPressed ? 2 : 5)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
    .buttonStyle(.plain)
    .pressEvents {
      withAnimation(.easeInOut(duration: 0.2)) {
        isPressed = true
      }
    } onRelease: {
      withAnimation(.easeInOut(duration: 0.2)) {
        isPressed = false
      }
    }
  }
}

/// 圆形进度指示器
struct CircularProgress: View {
  let progress: Double
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color.gray.opacity(0.2),
          lineWidth: 8
        )
      
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          style: StrokeStyle(
            lineWidth: 8,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .animation(.easeInOut, value: progress)
      
      Text("\(Int(progress * 100))%")
        .font(.headline)
    }
  }
}

// MARK: - 主视图
struct ShapeDemoView: View {
  // 进度相关状态
  @State private var progress = 0.0
  
  // 波纹动画状态
  @State private var rippleProgress = 0.0
  
  // 形状变形动画状态
  @State private var isRectangleMorphing = false
  
  // 波浪动画状态
  @State private var wavePhase = 0.0
  
  // 渐变动画状态
  @State private var isGradientRotating = false
  
  // 爆炸效果状态
  @State private var isExploding = false
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础形状
      ShowcaseSection("基础形状") {
        // 1. 矩形
        ShowcaseItem(title: "矩形", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Rectangle()
              .fill(.blue)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 2. 圆角矩形
        ShowcaseItem(title: "圆角矩形", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 15)
              .fill(.green)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 3. 圆形
        ShowcaseItem(title: "圆形", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Circle()
              .fill(.red)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 4. 椭圆
        ShowcaseItem(title: "椭圆", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Ellipse()
              .fill(.orange)
              .frame(width: 80, height: 50)
          }.padding()
        }
        
        // 5. 胶囊形
        ShowcaseItem(title: "胶囊形", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Capsule()
              .fill(.purple)
              .frame(width: 80, height: 40)
          }.padding()
        }
      }
      
      // MARK: - 样式定制
      ShowcaseSection("样式定制") {
        // 1. 渐变填充
        ShowcaseItem(title: "渐变填充", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 10)
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [.blue, .purple]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 100, height: 60)
          }.padding()
        }
        
        // 2. 描边样式
        ShowcaseItem(title: "描边样式", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Circle()
              .stroke(
                .blue,
                style: StrokeStyle(
                  lineWidth: 2,
                  dash: [5, 3]
                )
              )
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 3. 阴影效果
        ShowcaseItem(title: "阴影效果", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 10)
              .fill(.white)
              .shadow(
                color: .gray.opacity(0.3),
                radius: 5,
                x: 0,
                y: 2
              )
              .frame(width: 100, height: 60)
          }.padding()
        }
      }
      
      // MARK: - 自定义形状
      ShowcaseSection("自定义形状") {
        // 1. 三角形
        ShowcaseItem(title: "三角形", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Triangle()
              .fill(.blue)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 2. 星形
        ShowcaseItem(title: "星形", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Star(points: 5, innerRadius: 20)
              .fill(.yellow)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 3. 波浪线
        ShowcaseItem(title: "波浪线", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Wave(amplitude: 10, frequency: 0.1, phase: wavePhase)
              .stroke(.blue, lineWidth: 2)
              .frame(width: 200, height: 60)
          }.padding()
        }
        .onAppear {
          withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            wavePhase = .pi * 2
          }
        }
      }
      
      // MARK: - 动画效果
      ShowcaseSection("动画效果") {
        // 1. 形状变形
        ShowcaseItem(title: "形状变形", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: isRectangleMorphing ? 30 : 0)
              .fill(.blue)
              .frame(width: 60, height: 60)
              .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isRectangleMorphing)
          }.padding()
        }
        .onAppear {
          isRectangleMorphing = true
        }
        
        
        // 2. 渐变动画
        ShowcaseItem(title: "渐变动画", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            Circle()
              .fill(
                AngularGradient(
                  gradient: Gradient(colors: [.blue, .purple, .blue]),
                  center: .center,
                  startAngle: .degrees(isGradientRotating ? 0 : 360),
                  endAngle: .degrees(isGradientRotating ? 360 : 720)
                )
              )
              .frame(width: 60, height: 60)
          }.padding()
        }
        .onAppear {
          withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            isGradientRotating = true
          }
        }
        
        // 3. 波纹效果
        ShowcaseItem(title: "波纹效果", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            RippleShape(rippleCount: 5, progress: rippleProgress)
              .stroke(Color.blue.opacity(0.5), lineWidth: 2)
              .frame(width: 100, height: 100)
            
            Slider(value: $rippleProgress)
              .padding(.horizontal)
          }.padding()
        }
        .onAppear {
          withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
            rippleProgress = 1.0
          }
        }
        
        // 4. 可拖拽形状
        ShowcaseItem(title: "可拖拽形状", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            DraggableShape(shape: AnyShape(Star(points: 5, innerRadius: 20)), color: .yellow)
          }.padding()
        }
        
        // 5. 爆炸效果
        ShowcaseItem(title: "爆炸效果", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            ZStack {
              Circle()
                .fill(.red)
                .frame(width: 50, height: 50)
                .opacity(isExploding ? 0 : 1)
              ExplosionEffect(isExploding: $isExploding, particleCount: 20, color: .red)
            }
            .onTapGesture {
              isExploding.toggle()
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isExploding.toggle()
              }
            }
          }.padding()
        }
        
        
      }
      
      // MARK: - 高级形状
      ShowcaseSection("高级形状") {
        // 1. 心形
        ShowcaseItem(title: "心形", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            HeartShape()
              .fill(Color.red)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 2. 齿轮
        ShowcaseItem(title: "齿轮", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            GearShape(teeth: 12, innerRadius: 20, outerRadius: 30, toothWidth: 4)
              .fill(Color.blue)
              .frame(width: 80, height: 80)
              .rotationEffect(.degrees(isGradientRotating ? 360 : 0))
              .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: isGradientRotating)
          }.padding()
        }
        
        // 3. 多边形
        ShowcaseItem(title: "多边形", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            PolygonShape(sides: 6, inset: 5)
              .fill(Color.purple)
              .frame(width: 60, height: 60)
          }.padding()
        }
        
        // 4. 螺旋线
        ShowcaseItem(title: "螺旋线", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            SpiralShape(rotations: 3, decay: 0.8)
              .stroke(Color.orange, lineWidth: 2)
              .frame(width: 80, height: 80)
          }.padding()
        }
      }
      
      // MARK: - 实用组件
      ShowcaseSection("实用组件") {
        // 1. 星级评分
        ShowcaseItem(title: "星级评分", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            StarRating(rating: Int(progress * 5), maxRating: 5, size: 30, color: .yellow)
          }.padding()
        }
        
        // 2. 音量可视化
        ShowcaseItem(title: "音量可视化", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            AudioVisualizer().frame(height: 100)
          }.padding()
        }
        
        // 3. 雷达图
        ShowcaseItem(title: "雷达图", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            RadarChart(
              values: [0.8, 0.6, 0.9, 0.7, 0.5],
              labels: ["A", "B", "C", "D", "E"],
              maxValue: 1.0,
              color: .blue
            )
            .frame(width: 200, height: 200)
          }.padding()
        }
        
        // 4. 加载动画
        ShowcaseItem(title: "加载动画", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            LoadingAnimations(color: .blue)
          }.padding()
        }
      }
      
      // MARK: - 组合效果
      ShowcaseSection("组合效果") {
        // 1. 万花筒
        ShowcaseItem(title: "万花筒", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            KaleidoscopeView(segments: 8, content: AnyShape(Triangle()))
              .frame(width: 200, height: 200)
          }.padding()
        }
        
        // 2. 粒子系统
        ShowcaseItem(title: "粒子系统", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            ParticleSystem(
              particleCount: 50,
              emitterPosition: CGPoint(x: 100, y: 100),
              color: .blue
            )
            .frame(width: 200, height: 200)
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
          }.padding()
        }
        
        // 3. 进度指示器
        ShowcaseItem(title: "进度指示器", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            CircularProgress(progress: progress)
              .frame(width: 100, height: 100)
          }.padding()
        }
        Slider(value: $progress)
          .padding(.horizontal)
      }
    }
    .navigationTitle("Shape 示例")
  }
}

// MARK: - 辅助扩展
extension View {
  func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
    self.simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .onChanged { _ in
          onPress()
        }
        .onEnded { _ in
          onRelease()
        }
    )
  }
}

#Preview {
  NavigationStack {
    ShapeDemoView()
  }
}
