import SwiftUI

@available(iOS 16.0, *)
struct GridDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础网格
      ShowcaseSection("基础网格") {
        BasicGridDemoView()
      }
      
      // MARK: - 自定义大小
      ShowcaseSection("自定义大小") {
        CustomSizeGridDemoView()
      }
      
      // MARK: - 动态内容
      ShowcaseSection("动态内容") {
        DynamicContentGridDemoView()
      }
      
      // MARK: - 样式定制
      ShowcaseSection("样式定制") {
        StyledGridDemoView()
      }
      
      // MARK: - 动画效果
      ShowcaseSection("动画效果") {
        AnimatedGridDemoView()
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        AdvancedFeaturesGridDemoView()
      }
      
      // MARK: - 响应式布局
      ShowcaseSection("响应式布局") {
        ResponsiveGridDemoView()
      }
    }
    .navigationTitle("Grid 布局示例")
  }
}

// MARK: - Basic Grid Demo
struct BasicGridDemoView: View {
  var body: some View {
    VStack(spacing: 20) {
      // 基本网格
      ShowcaseItem(title: "基本网格") {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
          GridRow {
            ForEach(0..<3, id: \.self) { index in
              Text("\(index + 1)")
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.2))
            }
          }
          GridRow {
            ForEach(3..<6, id: \.self) { index in
              Text("\(index + 1)")
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.2))
            }
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 间距控制
      ShowcaseItem(title: "间距控制") {
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
          GridRow {
            ForEach(0..<2) { _ in
              Rectangle()
                .fill(.blue.opacity(0.2))
                .frame(width: 50, height: 50)
            }
          }
          GridRow {
            ForEach(0..<2) { _ in
              Rectangle()
                .fill(.green.opacity(0.2))
                .frame(width: 50, height: 50)
            }
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 网格说明
      ShowcaseItem(title: "网格说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• Grid 是 iOS 16+ 引入的新布局控件")
          Text("• 支持固定行列的网格布局")
          Text("• 可以通过 GridRow 定义行")
          Text("• 支持自定义水平和垂直间距")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Custom Size Demo
struct CustomSizeGridDemoView: View {
  var body: some View {
    VStack(spacing: 20) {
      // 跨列单元格
      ShowcaseItem(title: "跨列单元格") {
        Grid {
          GridRow {
            Text("跨两列")
              .frame(width: 100, height: 50)
              .background(Color.red.opacity(0.2))
              .gridCellColumns(2)
            
            Text("单列")
              .frame(width: 50, height: 50)
              .background(Color.blue.opacity(0.2))
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 不同尺寸组合
      ShowcaseItem(title: "不同尺寸组合") {
        Grid {
          GridRow {
            Text("大")
              .frame(width: 100, height: 100)
              .background(Color.purple.opacity(0.2))
            
            VStack {
              Text("小")
                .frame(width: 50, height: 45)
                .background(Color.orange.opacity(0.2))
              Text("小")
                .frame(width: 50, height: 45)
                .background(Color.green.opacity(0.2))
            }
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 尺寸说明
      ShowcaseItem(title: "尺寸说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• 使用 gridCellColumns 控制跨列")
          Text("• 单元格可以有不同的尺寸")
          Text("• Grid 会自动对齐单元格")
          Text("• 支持嵌套其他布局容器")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Dynamic Content Demo
struct DynamicContentGridDemoView: View {
  @State private var colors: [[Color]] = [
    [.red, .blue, .green],
    [.yellow, .purple, .orange],
    [.pink, .cyan, .gray]
  ]
  @State private var items = ["A", "B", "C", "D"]
  
  var body: some View {
    VStack(spacing: 20) {
      // 动态颜色网格
      ShowcaseItem(title: "动态颜色网格") {
        VStack {
          Grid {
            ForEach(0..<colors.count, id: \.self) { row in
              GridRow {
                ForEach(0..<colors[row].count, id: \.self) { col in
                  Rectangle()
                    .fill(colors[row][col])
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                      withAnimation {
                        colors[row][col] = Color(
                          red: Double.random(in: 0...1),
                          green: Double.random(in: 0...1),
                          blue: Double.random(in: 0...1)
                        )
                      }
                    }
                }
              }
            }
          }
          .border(Color.gray.opacity(0.2))
          
          Text("点击方块改变颜色")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
      
      // 动态项目网格
      ShowcaseItem(title: "动态项目网格") {
        VStack {
          Grid {
            GridRow {
              ForEach(items, id: \.self) { item in
                Text(item)
                  .frame(width: 50, height: 50)
                  .background(Color.blue.opacity(0.2))
              }
            }
          }
          .border(Color.gray.opacity(0.2))
          
          Button("添加项目") {
            withAnimation {
              if let last = items.last,
                 let ascii = last.unicodeScalars.first?.value {
                let next = String(Character(UnicodeScalar(ascii + 1)!))
                items.append(next)
              }
            }
          }
          .padding(.top)
        }
      }
      
      // 动态内容说明
      ShowcaseItem(title: "动态内容说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• Grid 支持动态内容更新")
          Text("• 可以响应用户交互")
          Text("• 支持添加和删除项目")
          Text("• 可以与动画结合使用")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Styled Grid Demo
struct StyledGridDemoView: View {
  var body: some View {
    VStack(spacing: 20) {
      // 基础样式
      ShowcaseItem(title: "基础样式") {
        Grid(horizontalSpacing: 15, verticalSpacing: 15) {
          ForEach(0..<2, id: \.self) { row in
            GridRow {
              ForEach(0..<2, id: \.self) { col in
                RoundedRectangle(cornerRadius: 10)
                  .fill(Color.blue.opacity(0.1))
                  .overlay(
                    Image(systemName: ["star.fill", "heart.fill", "circle.fill", "square.fill"][row * 2 + col])
                      .foregroundColor(.blue)
                  )
                  .frame(width: 80, height: 80)
              }
            }
          }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
      }
      
      // 渐变样式
      ShowcaseItem(title: "渐变样式") {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
          GridRow {
            ForEach(0..<2) { _ in
              RoundedRectangle(cornerRadius: 10)
                .fill(
                  LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
                .frame(width: 70, height: 70)
                .opacity(0.3)
            }
          }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
      }
      
      // 样式说明
      ShowcaseItem(title: "样式说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• Grid 支持各种样式定制")
          Text("• 可以添加背景、边框和阴影")
          Text("• 支持渐变和叠加效果")
          Text("• 单元格可以使用任何 View")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Animated Grid Demo
struct AnimatedGridDemoView: View {
  @State private var isAnimating = false
  @State private var isRotating = false
  @State private var isScaling = false
  
  var body: some View {
    VStack(spacing: 20) {
      // 3D 旋转动画
      ShowcaseItem(title: "3D 旋转动画") {
        VStack {
          Grid {
            ForEach(0..<3, id: \.self) { row in
              GridRow {
                ForEach(0..<3, id: \.self) { col in
                  Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: isAnimating ? 70 : 50,
                           height: isAnimating ? 70 : 50)
                    .rotation3DEffect(
                      .degrees(isAnimating ? 180 : 0),
                      axis: (x: CGFloat(row), y: CGFloat(col), z: 0.0)
                    )
                }
              }
            }
          }
          .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true),
                     value: isAnimating)
          
          Button(action: {
            isAnimating.toggle()
          }) {
            Text(isAnimating ? "停止动画" : "开始动画")
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
          .padding(.top)
        }
      }
      
      // 旋转动画
      ShowcaseItem(title: "旋转动画") {
        VStack {
          Grid(horizontalSpacing: 15, verticalSpacing: 15) {
            GridRow {
              ForEach(0..<2) { _ in
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.green.opacity(0.2))
                  .frame(width: 60, height: 60)
                  .rotationEffect(.degrees(isRotating ? 360 : 0))
              }
            }
          }
          .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                     value: isRotating)
          
          Button("切换旋转") {
            isRotating.toggle()
          }
          .padding(.top)
        }
        .onAppear { isRotating = true }
      }
      
      // 动画说明
      ShowcaseItem(title: "动画说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• Grid 支持各种动画效果")
          Text("• 可以组合多种变换")
          Text("• 支持 3D 效果")
          Text("• 可以自定义动画时间和曲线")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
    .onAppear {
      isAnimating = true
    }
    .onDisappear {
      isAnimating = false
      isRotating = false
    }
  }
}

// MARK: - Responsive Layout Demo
struct ResponsiveGridDemoView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  
  var body: some View {
    VStack(spacing: 20) {
      // 响应式布局
      ShowcaseItem(title: "响应式布局") {
        Grid {
          if horizontalSizeClass == .regular {
            // 宽屏布局：2x2
            GridRow {
              ForEach(0..<2, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.blue.opacity(0.2))
                  .frame(height: 100)
              }
            }
            GridRow {
              ForEach(0..<2, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.green.opacity(0.2))
                  .frame(height: 100)
              }
            }
          } else {
            // 窄屏布局：1x4
            ForEach(0..<4, id: \.self) { _ in
              GridRow {
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.blue.opacity(0.2))
                  .frame(height: 50)
              }
            }
          }
        }
        .animation(.easeInOut, value: horizontalSizeClass)
      }
      
      // 动态间距
      ShowcaseItem(title: "动态间距") {
        Grid(horizontalSpacing: horizontalSizeClass == .regular ? 20 : 10,
             verticalSpacing: verticalSizeClass == .regular ? 20 : 10) {
          GridRow {
            ForEach(0..<2, id: \.self) { _ in
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.purple.opacity(0.2))
                .frame(height: 60)
            }
          }
          GridRow {
            ForEach(0..<2, id: \.self) { _ in
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.2))
                .frame(height: 60)
            }
          }
        }
             .animation(.easeInOut, value: horizontalSizeClass)
             .animation(.easeInOut, value: verticalSizeClass)
      }
      
      // 响应式说明
      ShowcaseItem(title: "响应式说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• 根据屏幕尺寸调整布局")
          Text("• 支持动态调整间距")
          Text("• 可以改变网格结构")
          Text("• 支持布局动画")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - Advanced Features Demo
struct AdvancedFeaturesGridDemoView: View {
  var body: some View {
    VStack(spacing: 20) {
      // 跨行跨列
      ShowcaseItem(title: "跨行跨列") {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
          // 第一行：跨两列的蓝色方块
          GridRow {
            Rectangle()
              .fill(Color.red)
              .frame(width: 50, height: 50)
            Rectangle()
              .fill(Color.blue)
              .frame(width: 100, height: 50)
              .gridCellColumns(2)
          }
          
          // 第二行：使用高度和锚点模拟跨行效果
          GridRow {
            Rectangle()
              .fill(Color.green)
              .frame(width: 50, height: 100)
              .gridCellAnchor(.center)
            Rectangle()
              .fill(Color.yellow)
              .frame(width: 50, height: 50)
            Rectangle()
              .fill(Color.purple)
              .frame(width: 50, height: 50)
          }
          
          // 第三行：与高度较大的单元格对齐
          GridRow {
            Color.clear // 占位，保持列对齐
              .frame(width: 50, height: 50)
            Rectangle()
              .fill(Color.orange)
              .frame(width: 50, height: 50)
            Rectangle()
              .fill(Color.pink)
              .frame(width: 50, height: 50)
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 跨行跨列说明
      ShowcaseItem(title: "跨行跨列说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• gridCellColumns: 控制跨列数")
          Text("• gridCellAnchor: 控制单元格锚点")
          Text("• 使用高度和锚点模拟跨行")
          Text("• 支持不规则布局")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      // 列对齐方式
      ShowcaseItem(title: "列对齐方式") {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
          GridRow {
            Text("左对齐")
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
              .background(Color.blue.opacity(0.1))
              .gridColumnAlignment(.leading)
            
            Text("居中")
              .frame(maxWidth: .infinity, alignment: .center)
              .padding()
              .background(Color.blue.opacity(0.1))
              .gridColumnAlignment(.center)
            
            Text("右对齐")
              .frame(maxWidth: .infinity, alignment: .trailing)
              .padding()
              .background(Color.blue.opacity(0.1))
              .gridColumnAlignment(.trailing)
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 行对齐方式
      ShowcaseItem(title: "行对齐方式") {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
          GridRow(alignment: .top) {
            Text("顶部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.blue.opacity(0.1))
            
            Text("居中对齐")
              .frame(height: 60)
              .padding()
              .background(Color.green.opacity(0.1))
            
            Text("底部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.orange.opacity(0.1))
          }
          
          GridRow(alignment: .center) {
            Text("顶部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.blue.opacity(0.1))
            
            Text("居中对齐")
              .frame(height: 60)
              .padding()
              .background(Color.green.opacity(0.1))
            
            Text("底部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.orange.opacity(0.1))
          }
          
          GridRow(alignment: .bottom) {
            Text("顶部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.blue.opacity(0.1))
            
            Text("居中对齐")
              .frame(height: 60)
              .padding()
              .background(Color.green.opacity(0.1))
            
            Text("底部对齐")
              .frame(height: 60)
              .padding()
              .background(Color.orange.opacity(0.1))
          }
          
          GridRow(alignment: .firstTextBaseline) {
            Text("首行基线")
              .font(.title)
              .padding()
              .background(Color.purple.opacity(0.1))
            
            Text("基线对齐")
              .padding()
              .background(Color.blue.opacity(0.1))
            
            Text("示例")
              .font(.caption)
              .padding()
              .background(Color.green.opacity(0.1))
          }
        }
        .border(Color.gray.opacity(0.2))
      }
      
      // 对齐方式说明
      ShowcaseItem(title: "对齐方式说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• gridColumnAlignment: 控制列对齐")
          Text("• gridRowAlignment: 控制行对齐")
          Text("• 支持多种对齐方式：")
          Text("  - top/center/bottom")
          Text("  - firstTextBaseline/lastTextBaseline")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      // 内容处理
      ShowcaseItem(title: "内容处理") {
        VStack(spacing: 20) {
          // 自适应大小
          Grid {
            GridRow {
              Text("自适应大小\n可以根据内容\n自动调整")
                .padding()
                .background(Color.green.opacity(0.1))
                .gridCellUnsizedAxes([.horizontal, .vertical])
              
              Text("固定大小")
                .frame(width: 100, height: 50)
                .background(Color.blue.opacity(0.1))
            }
          }
          .border(Color.gray.opacity(0.2))
          
          // 内容溢出
          Grid {
            GridRow {
              Text("这是一段很长的文本内容，会超出固定宽度")
                .frame(width: 100)
                .lineLimit(1)
                .truncationMode(.tail)
                .background(Color.purple.opacity(0.1))
              
              Text("这也是一段长文本")
                .frame(width: 100)
                .lineLimit(1)
                .truncationMode(.middle)
                .background(Color.orange.opacity(0.1))
            }
          }
          .border(Color.gray.opacity(0.2))
          
          // 内容缩放
          Grid {
            GridRow {
              Text("缩放文本以适应")
                .frame(width: 80)
                .minimumScaleFactor(0.5)
                .background(Color.blue.opacity(0.1))
              
              Text("不缩放文本")
                .frame(width: 80)
                .background(Color.green.opacity(0.1))
            }
          }
          .border(Color.gray.opacity(0.2))
        }
      }
      
      // 内容处理说明
      ShowcaseItem(title: "内容处理说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• gridCellUnsizedAxes: 控制自适应轴向")
          Text("• 支持文本截断和缩放")
          Text("• 可以设置固定或灵活尺寸")
          Text("• 支持多种文本截断模式")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      // 网格嵌套
      ShowcaseItem(title: "网格嵌套") {
        Grid(horizontalSpacing: 15, verticalSpacing: 15) {
          // 第一行：嵌套网格
          GridRow {
            Grid(horizontalSpacing: 5, verticalSpacing: 5) {
              GridRow {
                ForEach(0..<2, id: \.self) { _ in
                  Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 30, height: 30)
                }
              }
              GridRow {
                ForEach(0..<2, id: \.self) { _ in
                  Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 30, height: 30)
                }
              }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // 嵌套网格2
            Grid(horizontalSpacing: 5, verticalSpacing: 5) {
              GridRow {
                Rectangle()
                  .fill(Color.green.opacity(0.2))
                  .frame(width: 70, height: 30)
              }
              GridRow {
                Rectangle()
                  .fill(Color.green.opacity(0.2))
                  .frame(width: 30, height: 30)
                Rectangle()
                  .fill(Color.green.opacity(0.2))
                  .frame(width: 30, height: 30)
              }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
          }
          
          // 第二行：复杂嵌套
          GridRow {
            Grid {
              GridRow {
                Text("嵌套标题")
                  .font(.caption)
                  .padding(5)
                  .background(Color.purple.opacity(0.1))
                  .gridCellColumns(2)
              }
              GridRow {
                Image(systemName: "star.fill")
                  .foregroundColor(.yellow)
                Text("评分")
                  .font(.caption)
              }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Grid {
              GridRow {
                ForEach(0..<3, id: \.self) { _ in
                  Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 20, height: 20)
                }
              }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
          }
        }
      }
      
      // 网格嵌套说明
      ShowcaseItem(title: "网格嵌套说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• Grid 支持无限层级嵌套")
          Text("• 可以组合不同布局结构")
          Text("• 内外网格可以有不同间距")
          Text("• 支持复杂的布局组合")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      // 高级特性说明
      ShowcaseItem(title: "高级特性说明") {
        VStack(alignment: .leading, spacing: 8) {
          Text("• 支持不规则网格布局")
          Text("• 可以控制单元格对齐方式")
          Text("• 支持自适应大小的单元格")
          Text("• 可以设置单元格跨行跨列")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

#Preview {
  if #available(iOS 16.0, *) {
    NavigationView {
      GridDemoView()
    }
  } else {
    Text("需要 iOS 16.0 或更高版本")
  }
}
