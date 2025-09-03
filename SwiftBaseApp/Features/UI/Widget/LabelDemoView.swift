import SwiftUI

// MARK: - 自定义样式
struct CustomLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 8) {
      configuration.icon
        .foregroundStyle(.blue)
        .imageScale(.large)
      configuration.title
        .font(.headline)
    }
    .padding()
    .background(.gray.opacity(0.2))
    .cornerRadius(8)
  }
}

// MARK: - 自定义间距样式
struct CustomSpacingLabelStyle: LabelStyle {
  let spacing: CGFloat
  
  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: spacing) {
      configuration.icon
      configuration.title
    }
  }
}

extension LabelStyle where Self == CustomSpacingLabelStyle {
  static func custom(spacing: CGFloat) -> CustomSpacingLabelStyle {
    CustomSpacingLabelStyle(spacing: spacing)
  }
}

// MARK: - 状态枚举
enum LabelStatus {
  case normal, warning, error
  
  var icon: String {
    switch self {
    case .normal: return "checkmark.circle"
    case .warning: return "exclamationmark.triangle"
    case .error: return "xmark.circle"
    }
  }
  
  var color: Color {
    switch self {
    case .normal: return .green
    case .warning: return .yellow
    case .error: return .red
    }
  }
}

// MARK: - 主视图
struct LabelDemoView: View {
  // MARK: - 状态属性
  @State private var isSelected = false
  @State private var isRotating = false
  @State private var isOn = false
  @State private var selectedOption = 0
  @State private var status: LabelStatus = .normal
  @State private var count = 0
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础标签
      ShowcaseSection("基础标签") {
        // 1. 基本用法
        ShowcaseItem(title: "基本用法", backgroundColor: Color.red.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("基本标签", systemImage: "tag")
            
            Label {
              Text("自定义样式")
                .font(.headline)
                .foregroundStyle(.blue)
            } icon: {
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            }
            
            Label("本地图片", image: "photo")
          }.padding()
        }
        
        // 2. 标签样式
        ShowcaseItem(title: "标签样式", backgroundColor: Color.blue.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("标题样式", systemImage: "title")
              .labelStyle(.titleOnly)
            
            Label("图标样式", systemImage: "photo")
              .labelStyle(.iconOnly)
            
            Label("自定义样式", systemImage: "star")
              .labelStyle(CustomLabelStyle())
          }.padding()
        }
      }
      
      // MARK: - 交互效果
      ShowcaseSection("交互效果") {
        // 1. 点击效果
        ShowcaseItem(title: "点击效果", backgroundColor: Color.green.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("点击切换", systemImage: isSelected ? "checkmark.circle.fill" : "circle")
              .foregroundStyle(isSelected ? .blue : .gray)
              .onTapGesture {
                withAnimation {
                  isSelected.toggle()
                }
              }
            
            Label("旋转动画", systemImage: "arrow.clockwise")
              .rotationEffect(.degrees(isRotating ? 360 : 0))
              .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                         value: isRotating)
              .onAppear { isRotating = true }
          }.padding().frame(height: 180)
        }
        
        // 2. 状态管理
        ShowcaseItem(title: "状态管理", backgroundColor: Color.indigo.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("当前状态", systemImage: status.icon)
              .foregroundStyle(status.color)
            
            HStack(spacing: 20) {
              Button("正常") {
                withAnimation(.spring(response: 0.3)) {
                  status = .normal
                }
              }
              .buttonStyle(.borderedProminent)
              .tint(.green)
              
              Button("警告") {
                withAnimation(.spring(response: 0.3)) {
                  status = .warning
                }
              }
              .buttonStyle(.borderedProminent)
              .tint(.yellow)
              
              Button("错误") {
                withAnimation(.spring(response: 0.3)) {
                  status = .error
                }
              }
              .buttonStyle(.borderedProminent)
              .tint(.red)
            }
            .padding(.vertical, 10)
            
            Label {
              Text("点击次数: \(count)")
            } icon: {
              Image(systemName: "hand.tap")
            }
            .onTapGesture {
              withAnimation {
                count += 1
              }
            }
          }.padding()
        }
      }
      
      
      // MARK: - 布局和样式
      ShowcaseSection("布局和样式") {
        // 1. 对齐和间距
        ShowcaseItem(title: "对齐和间距", backgroundColor: Color.mint.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("左对齐", systemImage: "align.horizontal.left")
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.gray.opacity(0.1))
            
            Label("居中对齐", systemImage: "align.horizontal.center")
              .frame(maxWidth: .infinity, alignment: .center)
              .background(.gray.opacity(0.1))
            
            Label("右对齐", systemImage: "align.horizontal.right")
              .frame(maxWidth: .infinity, alignment: .trailing)
              .background(.gray.opacity(0.1))
          }.padding()
        }
        
        // 2. 图标调整
        ShowcaseItem(title: "图标调整", backgroundColor: Color.red.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("大图标", systemImage: "star.fill")
              .imageScale(.large)
            
            Label {
              Text("图标位置")
            } icon: {
              Image(systemName: "arrow.right")
                .offset(x: 5)
            }
            
            Label {
              Text("自定义间距")
            } icon: {
              Image(systemName: "circle.fill")
            }
            .labelStyle(.custom(spacing: 20))
          }.padding()
        }
        
        // 3. 变换效果
        ShowcaseItem(title: "变换效果", backgroundColor: Color.yellow.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("缩放效果", systemImage: "magnifyingglass")
              .scaleEffect(1.2)
            
            Label("旋转效果", systemImage: "arrow.clockwise")
              .rotationEffect(.degrees(45))
            
            Label("3D效果", systemImage: "cube")
              .rotation3DEffect(.degrees(20), axis: (x: 1, y: 0, z: 0))
          }.padding()
        }
      }
      
      // MARK: - 交互增强
      ShowcaseSection("交互增强") {
        // 1. 手势交互
        ShowcaseItem(title: "手势交互", backgroundColor: Color.pink.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("长按显示菜单", systemImage: "hand.point.up.left")
              .contextMenu {
                Button("选项1") {}
                Button("选项2") {}
                Button("选项3") {}
              }
            
            Label("拖动排序", systemImage: "arrow.up.and.down")
              .onDrag {
                return NSItemProvider(object: "可拖动标签" as NSString)
              }
            
            Label("双击动作", systemImage: "hand.tap")
              .onTapGesture(count: 2) {
                withAnimation {
                  count += 2
                }
              }
          }.padding()
        }
        
        // 2. 高级样式
        ShowcaseItem(title: "高级样式", backgroundColor: Color.purple.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("渐变文本", systemImage: "paintbrush.fill")
              .foregroundStyle(
                LinearGradient(
                  colors: [.blue, .purple],
                  startPoint: .leading,
                  endPoint: .trailing
                )
              )
            
            Label("带阴影", systemImage: "cloud.sun.fill")
              .shadow(color: .blue.opacity(0.5), radius: 5, x: 2, y: 2)
            
            Label {
              Text("自定义背景")
            } icon: {
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
            )
          }.padding()
        }
      }
      
      // MARK: - 辅助功能
      ShowcaseSection("辅助功能") {
        // 1. 无障碍支持
        ShowcaseItem(title: "无障碍支持",  backgroundColor: Color.cyan.opacity(0.1)) {
          VStack(spacing: 20) {
            Label("无障碍标签", systemImage: "accessibility")
              .accessibilityLabel("这是一个无障碍标签示例")
              .accessibilityHint("点击可以查看更多信息")
            
            Label("动态字体", systemImage: "textformat.size")
              .font(.body)
              .dynamicTypeSize(...DynamicTypeSize.accessibility3)
            
            Label("本地化", systemImage: "globe")
              .environment(\.locale, Locale(identifier: "zh_CN"))
          }.padding()
        }
      }
      
      
    }
    .navigationTitle("Label 示例")
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    LabelDemoView()
  }
}
