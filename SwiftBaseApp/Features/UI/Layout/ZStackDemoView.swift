import SwiftUI

// MARK: - 辅助视图
struct BadgedIcon: View {
  let systemName: String
  let badgeCount: Int
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Image(systemName: systemName)
        .font(.title)
        .foregroundColor(.blue)
      
      if badgeCount > 0 {
        Text("\(min(badgeCount, 99))")
          .font(.caption2)
          .padding(4)
          .background(.red)
          .foregroundColor(.white)
          .clipShape(Circle())
          .offset(x: 10, y: -10)
      }
    }
  }
}

struct CardView: View {
  let title: String
  let subtitle: String
  let image: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 15)
        .fill(Color(.systemBackground))
        .shadow(radius: 5)
      
      VStack(spacing: 10) {
        Image(systemName: image)
          .font(.system(size: 50))
          .foregroundColor(.blue)
        
        Text(title)
          .font(.headline)
        
        Text(subtitle)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
      .padding()
    }
    .frame(width: 200, height: 250)
  }
}

// MARK: - 主视图
struct ZStackDemoView: View {
  // MARK: - 状态属性
  @State private var isFlipped = false
  @State private var isHighlighted = false
  @State private var notifications = 5
  @State private var showOverlay = false
  @State private var overlayOpacity = 0.5
  @State private var zIndex = 1.0
  
  // MARK: - 计算属性
  enum AlignmentOption: String, CaseIterable {
    case topLeading = "左上"
    case top = "顶部"
    case topTrailing = "右上"
    case leading = "左侧"
    case center = "中心"
    case trailing = "右侧"
    case bottomLeading = "左下"
    case bottom = "底部"
    case bottomTrailing = "右下"
    
    var alignment: Alignment {
      switch self {
      case .topLeading: return .topLeading
      case .top: return .top
      case .topTrailing: return .topTrailing
      case .leading: return .leading
      case .center: return .center
      case .trailing: return .trailing
      case .bottomLeading: return .bottomLeading
      case .bottom: return .bottom
      case .bottomTrailing: return .bottomTrailing
      }
    }
  }
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础示例
      ShowcaseSection("基础示例") {
        // 1. 基本用法
        ShowcaseItem(title: "基本用法") {
          ZStack {
            Color.blue.opacity(0.2)
            Text("基本叠加")
          }
          .frame(height: 100)
          .cornerRadius(8)
        }
        
        // 2. 设置对齐
        ShowcaseItem(title: "设置对齐") {
          LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
          ], spacing: 10) {
            ForEach(AlignmentOption.allCases, id: \.self) { option in
              VStack {
                Text(option.rawValue)
                  .font(.caption)
                  .foregroundStyle(.secondary)
                
                ZStack(alignment: option.alignment) {
                  Color.green.opacity(0.2)
                  Text("示例")
                    .padding(4)
                    .background(.white)
                    .cornerRadius(4)
                }
                .frame(height: 60)
                .cornerRadius(8)
              }
            }
          }
        }
        
        // 3. 多层叠加
        ShowcaseItem(title: "多层叠加") {
          ZStack {
            Color.orange.opacity(0.2)
            Circle()
              .fill(.blue.opacity(0.3))
              .frame(width: 60, height: 60)
            Text("多层叠加")
          }
          .frame(height: 100)
          .cornerRadius(8)
        }
      }
      
      // MARK: - 层级控制
      ShowcaseSection("层级控制") {
        // 1. Z轴顺序
        ShowcaseItem(title: "Z轴顺序") {
          VStack {
            Slider(value: $zIndex, in: 0...2, step: 1) {
              Text("Z轴顺序: \(Int(zIndex))")
            }
            
            ZStack {
              Rectangle()
                .fill(.blue.opacity(0.3))
                .frame(width: 100, height: 100)
                .zIndex(0)
              
              Rectangle()
                .fill(.green.opacity(0.3))
                .frame(width: 80, height: 80)
                .offset(x: 20, y: 20)
                .zIndex(zIndex)
              
              Rectangle()
                .fill(.red.opacity(0.3))
                .frame(width: 60, height: 60)
                .offset(x: 40, y: 40)
                .zIndex(2)
            }
          }
        }
        
        // 2. 遮罩层
        ShowcaseItem(title: "遮罩层") {
          VStack {
            Toggle("显示遮罩", isOn: $showOverlay)
            if showOverlay {
              Slider(value: $overlayOpacity) {
                Text("遮罩透明度")
              }
            }
          }
          .padding()
          .background(.ultraThinMaterial)
          .cornerRadius(8)
          ZStack {
            Image(systemName: "photo")
              .resizable()
              .frame(width: 100, height: 100)
              .foregroundColor(.gray)
            
            if showOverlay {
              Color.black
                .opacity(overlayOpacity)
                .allowsHitTesting(false)
            }
            
            
          }
          .frame(height: 150)
          .cornerRadius(8)
        }
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        // 1. 翻转效果
        ShowcaseItem(title: "翻转效果") {
          ZStack {
            if isFlipped {
              Color.blue.opacity(0.2)
              Text("背面")
            } else {
              Color.green.opacity(0.2)
              Text("正面")
            }
          }
          .frame(height: 100)
          .cornerRadius(8)
          .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
          )
          .animation(.spring(), value: isFlipped)
          .onTapGesture {
            isFlipped.toggle()
          }
        }
        
        // 2. 高亮效果
        ShowcaseItem(title: "高亮效果") {
          ZStack {
            Circle()
              .fill(isHighlighted ? .blue.opacity(0.2) : .green.opacity(0.2))
            Text(isHighlighted ? "点击" : "松开")
          }
          .frame(height: 100)
          .animation(.easeInOut, value: isHighlighted)
          .onTapGesture {
            isHighlighted.toggle()
          }
        }
      }
      
      // MARK: - 实用示例
      ShowcaseSection("实用示例") {
        // 1. 徽章示例
        ShowcaseItem(title: "徽章示例") {
          HStack(spacing: 30) {
            BadgedIcon(systemName: "bell.fill", badgeCount: notifications)
            BadgedIcon(systemName: "envelope.fill", badgeCount: 12)
            BadgedIcon(systemName: "message.fill", badgeCount: 99)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .shadow(radius: 2)
        }
        
        // 2. 卡片示例
        ShowcaseItem(title: "卡片示例") {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
              CardView(
                title: "功能一",
                subtitle: "这是功能一的描述文本",
                image: "star.fill"
              )
              
              CardView(
                title: "功能二",
                subtitle: "这是功能二的描述文本",
                image: "heart.fill"
              )
              
              CardView(
                title: "功能三",
                subtitle: "这是功能三的描述文本",
                image: "bolt.fill"
              )
            }
          }
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        
        ShowcaseItem(title: "渲染优化") {
          Text("使用 drawingGroup 优化渲染")
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
          ZStack {
            // 使用 drawingGroup() 开启离屏渲染
            ComplexShapeView()
              .drawingGroup()
            
            
          }
          .frame(height: 150)
        }
      }
    }
    .navigationTitle("层叠布局示例")
  }
}

// MARK: - 辅助视图
struct ComplexShapeView: View {
  @State private var animate = false
  
  var body: some View {
    ZStack {
      ForEach(0..<10) { index in
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(.blue.opacity(0.3))
          .frame(width: CGFloat(index * 20))
          .rotationEffect(.degrees(animate ? 360 : 0))
          .animation(
            .linear(duration: Double(index) * 0.5)
            .repeatForever(autoreverses: false),
            value: animate
          )
      }
    }
    .onAppear {
      animate = true
    }
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    ZStackDemoView()
  }
}
