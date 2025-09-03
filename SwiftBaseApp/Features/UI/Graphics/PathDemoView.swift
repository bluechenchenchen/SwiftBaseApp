import SwiftUI

// MARK: - 辅助类型

/// 签名板视图模型
class SignaturePadViewModel: ObservableObject {
  @Published var points: [CGPoint] = []
  @Published var currentLine: [CGPoint] = []
  
  func addPoint(_ point: CGPoint) {
    currentLine.append(point)
  }
  
  func finishLine() {
    points.append(contentsOf: currentLine)
    currentLine.removeAll()
  }
  
  func clear() {
    points.removeAll()
    currentLine.removeAll()
  }
}

/// 波浪动画形状
struct WaveShape: Shape {
  var phase: CGFloat
  var amplitude: CGFloat
  var frequency: CGFloat
  
  var animatableData: CGFloat {
    get { phase }
    set { phase = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.width
    let height = rect.height
    let midHeight = height / 2
    
    path.move(to: CGPoint(x: 0, y: midHeight))
    
    for x in stride(from: 0, through: width, by: 1) {
      let relativeX = x / width
      let y =
      midHeight + sin(relativeX * frequency * .pi * 2 + phase) * amplitude
      path.addLine(to: CGPoint(x: x, y: y))
    }
    
    path.addLine(to: CGPoint(x: width, y: height))
    path.addLine(to: CGPoint(x: 0, y: height))
    path.closeSubpath()
    
    return path
  }
}

/// 路径绘制动画形状
struct AnimatedPath: Shape {
  var progress: CGFloat
  
  var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.width * progress, y: rect.midY))
    return path
  }
}

/// 签名板视图
struct SignaturePadView: View {
  @StateObject private var viewModel = SignaturePadViewModel()
  let color: Color
  let lineWidth: CGFloat
  
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        // 绘制已完成的线条
        for (i, point) in viewModel.points.enumerated() {
          if i == 0 {
            path.move(to: point)
          } else {
            path.addLine(to: point)
          }
        }
        
        // 绘制当前线条
        if let firstPoint = viewModel.currentLine.first {
          path.move(to: firstPoint)
          for point in viewModel.currentLine.dropFirst() {
            path.addLine(to: point)
          }
        }
      }
      .stroke(color, lineWidth: lineWidth)
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            viewModel.addPoint(value.location)
          }
          .onEnded { _ in
            viewModel.finishLine()
          }
      )
    }
    .overlay(alignment: .topTrailing) {
      Button("清除") {
        viewModel.clear()
      }
      .buttonStyle(.borderless)
      .padding()
    }
    .background(Color.gray.opacity(0.1))
    .cornerRadius(10)
  }
}

// MARK: - 主视图
struct PathDemoView: View {
  @State private var progress = 0.0
  @State private var phase = 0.0
  @State private var morphing = false
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础路径
      ShowcaseSection("基础路径") {
        // 1. 直线路径
        ShowcaseItem(title: "直线路径", backgroundColor: Color.blue.opacity(0.1)) {
          HStack(alignment:.center) {
            Path { path in
              path.move(to: CGPoint(x: 50, y: 25))
              path.addLine(to: CGPoint(x: 200, y: 25))
            }
            .stroke(.blue, lineWidth: 2)
            .frame(height: 50)
          }.padding().frame(maxWidth: .infinity)
        }
        
        // 2. 矩形路径
        ShowcaseItem(title: "矩形路径", backgroundColor: Color.blue.opacity(0.1)) {
          HStack(alignment:.center) {
            Path { path in
              path.addRect(CGRect(x: 50, y: 0, width: 50, height: 50))
            }
            .fill(.blue)
            .frame(height: 50)
          }.padding()
        }
        
        // 3. 圆形路径
        ShowcaseItem(title: "圆形路径", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.addEllipse(in: CGRect(x: 50, y: 0, width: 50, height: 50))
            }
            .stroke(.blue, lineWidth: 2)
            .frame(height: 50)
          }.padding()
        }
        
        // 4. 弧形路径
        ShowcaseItem(title: "弧形路径", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.addArc(
                center: CGPoint(x: 75, y: 25),
                radius: 25,
                startAngle: .degrees(0),
                endAngle: .degrees(180),
                clockwise: false
              )
            }
            .stroke(.blue, lineWidth: 2)
            .frame(height: 50)
          }.padding()
        }
      }
      
      // MARK: - 贝塞尔曲线
      ShowcaseSection("贝塞尔曲线") {
        // 1. 二次贝塞尔曲线
        ShowcaseItem(title: "二次贝塞尔曲线", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.move(to: CGPoint(x: 50, y: 25))
              path.addQuadCurve(
                to: CGPoint(x: 200, y: 25),
                control: CGPoint(x: 125, y: morphing ? 0 : 50)
              )
            }
            .stroke(.blue, lineWidth: 2)
            .frame(height: 50)
            .animation(
              .easeInOut(duration: 1).repeatForever(autoreverses: true),
              value: morphing
            )
          }.padding()
        }
        .onAppear {
          morphing = true
        }
        
        // 2. 三次贝塞尔曲线
        ShowcaseItem(title: "三次贝塞尔曲线", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.move(to: CGPoint(x: 50, y: 25))
              path.addCurve(
                to: CGPoint(x: 200, y: 25),
                control1: CGPoint(x: 75, y: morphing ? 0 : 50),
                control2: CGPoint(x: 175, y: morphing ? 50 : 0)
              )
            }
            .stroke(.blue, lineWidth: 2)
            .frame(height: 50)
          }.padding()
        }
      }
      
      // MARK: - 样式效果
      ShowcaseSection("样式效果") {
        // 1. 渐变填充
        ShowcaseItem(title: "渐变填充", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.addEllipse(in: CGRect(x: 50, y: 0, width: 50, height: 50))
            }
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .frame(height: 50)
          }.padding()
        }
        
        // 2. 虚线描边
        ShowcaseItem(title: "虚线描边", backgroundColor: Color.orange.opacity(0.1)) {
          VStack(spacing: 20) {
            Path { path in
              path.addRect(CGRect(x: 50, y: 0, width: 50, height: 50))
            }
            .stroke(
              .blue,
              style: StrokeStyle(
                lineWidth: 2,
                lineCap: .round,
                lineJoin: .round,
                dash: [5, 3]
              )
            )
            .frame(height: 50)
          }.padding()
        }
      }
      
      // MARK: - 动画效果
      ShowcaseSection("动画效果") {
        // 1. 路径绘制动画
        ShowcaseItem(title: "路径绘制动画", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            AnimatedPath(progress: progress)
              .stroke(.blue, lineWidth: 2)
              .frame(height: 50)
              .onAppear {
                withAnimation(
                  .linear(duration: 2).repeatForever(autoreverses: true)
                ) {
                  progress = 1.0
                }
              }
          }.padding()
        }
        
        // 2. 波浪动画
        ShowcaseItem(title: "波浪动画", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            WaveShape(phase: phase, amplitude: 20, frequency: 2)
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [
                    .blue.opacity(0.3), .blue.opacity(0.1),
                  ]),
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
              .frame(height: 100)
              .onAppear {
                withAnimation(
                  .linear(duration: 2).repeatForever(autoreverses: false)
                ) {
                  phase = .pi * 2
                }
              }
          }.padding()
        }
      }
      
      // MARK: - 实际应用
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "实际应用示例", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            PathPracticalExamplesView(progress: $progress)
          }.padding()
        }
      }
      
      // MARK: - 动态效果
      ShowcaseSection("动态效果") {
        // 1. 心跳动画
        ShowcaseItem(title: "心跳动画", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            HeartbeatView()
          }.padding()
        }
        
        // 2. 音频波形
        ShowcaseItem(title: "音频波形", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            AudioWaveform()
              .frame(height: 100)
          }.padding()
        }
        
        // 3. 手写动画
        ShowcaseItem(title: "手写动画", backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            HandwritingPath(text: "Hello")
              .frame(height: 150)
          }.padding()
        }
      }
      
      // MARK: - 交互效果
      ShowcaseSection("交互效果") {
        // 1. 可变形路径
        ShowcaseItem(title: "可变形路径", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            MorphingPath(pathClosed: true)
              .frame(height: 300)
          }.padding()
        }
        
        // 2. 路径绘制游戏
        ShowcaseItem(title: "路径绘制游戏", backgroundColor: Color.brown.opacity(0.1)) {
          VStack(spacing: 20) {
            PathDrawingGame()
              .frame(height: 300)
          }.padding()
        }
      }
      
      // MARK: - 实用效果
      ShowcaseSection("实用效果") {
        // 1. 自定义饼图
        ShowcaseItem(title: "自定义饼图", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            CustomPieChart(segments: [
              .init(value: 30, color: .blue, label: "A"),
              .init(value: 20, color: .green, label: "B"),
              .init(value: 15, color: .orange, label: "C"),
              .init(value: 35, color: .purple, label: "D"),
            ])
            .frame(height: 200)
          }.padding()
        }
        
        // 2. 雷达扫描
        ShowcaseItem(title: "雷达扫描", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            RadarScanEffect()
              .frame(height: 200)
          }.padding()
        }
        
        // 3. 仪表盘
        ShowcaseItem(title: "仪表盘", backgroundColor: Color.gray.opacity(0.1)) {
          VStack(spacing: 20) {
            DashboardGauge(
              value: progress * 100,
              range: 0...100,
              gradient: Gradient(colors: [.green, .yellow, .red])
            )
            .frame(height: 150)
          }.padding()
        }
      }
      
      // MARK: - 艺术效果
      ShowcaseSection("艺术效果") {
        // 1. 分形图案
        ShowcaseItem(title: "分形图案", backgroundColor: Color.indigo.opacity(0.1)) {
          VStack(spacing: 20) {
            FractalPattern(depth: 7, angle: .pi / 4, scale: 0.7)
              .frame(height: 300)
          }.padding()
        }
        
        // 2. 几何艺术
        ShowcaseItem(title: "几何艺术", backgroundColor: Color.indigo.opacity(0.1)) {
          VStack(spacing: 20) {
            GeometricArt()
              .frame(height: 300)
          }.padding()
        }
      }
    }
    .navigationTitle("Path 示例")
  }
}

/// 实际应用示例视图
struct PathPracticalExamplesView: View {
  @Binding var progress: Double
  
  var body: some View {
    VStack(spacing: 20) {
      // 1. 签名板
      VStack(alignment: .leading) {
        Text("签名板")
          .font(.caption)
          .foregroundColor(.secondary)
        SignaturePadView(color: .blue, lineWidth: 2)
          .frame(height: 200)
      }
      
      // 2. 自定义进度条
      VStack(alignment: .leading) {
        Text("自定义进度条")
          .font(.caption)
          .foregroundColor(.secondary)
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
            Path { path in
              path.addRoundedRect(
                in: CGRect(x: 0, y: 0, width: geometry.size.width, height: 8),
                cornerSize: CGSize(width: 4, height: 4)
              )
            }
            .fill(Color.gray.opacity(0.2))
            
            Path { path in
              path.addRoundedRect(
                in: CGRect(
                  x: 0,
                  y: 0,
                  width: geometry.size.width * progress,
                  height: 8
                ),
                cornerSize: CGSize(width: 4, height: 4)
              )
            }
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .leading,
                endPoint: .trailing
              )
            )
          }
        }
        .frame(height: 8)
        .padding(.vertical)
        
        Slider(value: $progress)
      }
    }
  }
}

#Preview {
  NavigationStack {
    PathDemoView()
  }
}
