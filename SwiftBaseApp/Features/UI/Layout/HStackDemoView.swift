import SwiftUI

// MARK: - 基础示例
struct BasicHStackExampleView: View {
  var body: some View {
    Group {
      // 基本用法
      ShowcaseItem(title: "基本用法") {
        HStack {
          Text("左侧")
          Text("中间")
          Text("右侧")
        }
        .background(.blue.opacity(0.1))
      }
      
      // 设置间距
      ShowcaseItem(title: "设置间距") {
        HStack(spacing: 20) {
          Text("间距")
          Text("20")
          Text("点")
        }
        .background(.green.opacity(0.1))
      }
      
      // 对齐方式
      ShowcaseItem(title: "顶部对齐") {
        HStack(alignment: .top) {
          Text("顶部").font(.title)
          Text("对齐").font(.body)
          Text("示例").font(.caption)
        }
        .frame(height: 60)
        .background(.yellow.opacity(0.1))
      }
      
      ShowcaseItem(title: "中心对齐") {
        HStack(alignment: .center) {
          Text("中心").font(.title)
          Text("对齐").font(.body)
          Text("示例").font(.caption)
        }
        .frame(height: 60)
        .background(.orange.opacity(0.1))
      }
      
      ShowcaseItem(title: "底部对齐") {
        HStack(alignment: .bottom) {
          Text("底部").font(.title)
          Text("对齐").font(.body)
          Text("示例").font(.caption)
        }
        .frame(height: 60)
        .background(.purple.opacity(0.1))
      }
      
      ShowcaseItem(title: "首行基线对齐") {
        HStack(alignment: .firstTextBaseline) {
          Text("首行").font(.title)
          Text("基线").font(.body)
          Text("对齐").font(.caption)
        }
        .background(.blue.opacity(0.1))
      }
      
      ShowcaseItem(title: "末行基线对齐") {
        HStack(alignment: .lastTextBaseline) {
          Text("末行").font(.title)
          Text("基线").font(.body)
          Text("对齐").font(.caption)
        }
        .background(.green.opacity(0.1))
      }
    }
  }
}

// MARK: - 样式示例
struct StyleHStackExampleView: View {
  var body: some View {
    Group {
      // 边框样式
      ShowcaseItem(title: "边框样式") {
        HStack {
          Image(systemName: "star.fill")
          Text("边框样式")
        }
        .padding()
        .border(.blue)
      }
      
      // 阴影样式
      ShowcaseItem(title: "阴影样式") {
        HStack {
          Image(systemName: "moon.fill")
          Text("阴影样式")
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 3)
      }
      
      // 自定义样式
      ShowcaseItem(title: "自定义样式") {
        HStack {
          Image(systemName: "sun.max.fill")
          Text("自定义样式")
        }
        .modifier(CardStyle())
      }
    }
  }
}

// MARK: - 交互示例
struct InteractiveHStackExampleView: View {
  @State private var isExpanded = false
  @State private var isHighlighted = false
  
  var body: some View {
    Group {
      // 展开/收起
      ShowcaseItem(title: "展开/收起") {
        HStack {
          Image(systemName: "info.circle")
          if isExpanded {
            Text("详细信息")
              .transition(.slide)
          }
          Spacer()
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
        .padding()
        .background(.blue.opacity(0.1))
        .cornerRadius(8)
        .onTapGesture {
          withAnimation {
            isExpanded.toggle()
          }
        }
      }
      
      // 高亮效果
      ShowcaseItem(title: "高亮效果") {
        HStack {
          Image(systemName: "star.fill")
          Text("点击高亮")
        }
        .padding()
        .background(isHighlighted ? .blue.opacity(0.2) : .clear)
        .cornerRadius(8)
        .animation(.easeInOut, value: isHighlighted)
        .onTapGesture {
          isHighlighted.toggle()
        }
      }
    }
  }
}

// MARK: - 列表示例
struct ListHStackExampleView: View {
  let items = ["收藏", "下载", "分享", "设置"]
  let icons = ["star.fill", "arrow.down.circle", "square.and.arrow.up", "gear"]
  
  var body: some View {
    ShowcaseItem(title: "列表项目") {
      VStack(spacing: 10) {
        ForEach(Array(zip(items, icons)), id: \.0) { item, icon in
          HStack {
            Image(systemName: icon)
              .frame(width: 32, height: 32)
              .background(.blue.opacity(0.1))
              .cornerRadius(8)
            
            Text(item)
            
            Spacer()
            
            Image(systemName: "chevron.right")
              .foregroundColor(.secondary)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)
          .shadow(radius: 2)
        }
      }
    }
  }
}


// MARK: - 嵌套布局
struct NestedHStackExampleView: View {
  var body: some View {
    Group {
      // 基础嵌套
      ShowcaseItem(title: "基础嵌套") {
        HStack {
          VStack {
            Text("上")
            Text("下")
          }
          .padding()
          .background(.blue.opacity(0.1))
          
          HStack {
            Text("左")
            Text("右")
          }
          .padding()
          .background(.green.opacity(0.1))
        }
      }
      
      // 复杂嵌套
      ShowcaseItem(title: "复杂嵌套") {
        HStack(alignment: .top, spacing: 20) {
          VStack(spacing: 10) {
            Image(systemName: "person.circle.fill")
              .font(.largeTitle)
            Text("用户信息")
              .font(.caption)
          }
          .padding()
          .background(.blue.opacity(0.1))
          .cornerRadius(8)
          
          VStack(alignment: .leading, spacing: 8) {
            Text("标题")
              .font(.headline)
            
            HStack {
              Image(systemName: "calendar")
              Text("2024-01-01")
              Spacer()
              Image(systemName: "clock")
              Text("10:00")
            }
            .font(.caption)
            
            Text("这是一段描述文本，展示了复杂嵌套布局的效果。")
              .font(.body)
              .foregroundColor(.secondary)
          }
          .padding()
          .background(.green.opacity(0.1))
          .cornerRadius(8)
        }
        .padding()
      }
      
      // 动态嵌套
      ShowcaseItem(title: "动态嵌套") {
        VStack {
          ForEach(0..<2) { row in
            HStack {
              ForEach(0..<3) { column in
                VStack {
                  Image(systemName: "star.fill")
                  Text("项目 \(row * 3 + column + 1)")
                    .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
              }
            }
          }
        }
      }
    }
  }
}

// MARK: - 尺寸控制
struct SizeControlHStackExampleView: View {
  var body: some View {
    Group {
      // 固定尺寸
      ShowcaseItem(title: "固定尺寸") {
        HStack {
          Text("固定宽度")
            .frame(width: 100)
          Text("固定高度")
            .frame(height: 50)
          Text("固定尺寸")
            .frame(width: 80, height: 50)
        }
        .background(.blue.opacity(0.1))
      }
      
      // 最小最大尺寸
      ShowcaseItem(title: "最小最大尺寸") {
        HStack {
          Text("最小宽度")
            .frame(minWidth: 100)
            .background(.green.opacity(0.1))
          
          Text("最大宽度")
            .frame(maxWidth: 100)
            .background(.yellow.opacity(0.1))
          
          Text("最小最大")
            .frame(minWidth: 50, maxWidth: 100)
            .background(.orange.opacity(0.1))
        }
        .padding()
      }
      
      // 自适应尺寸
      ShowcaseItem(title: "自适应尺寸") {
        HStack {
          Text("自适应")
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.1))
          
          Text("固定")
            .frame(width: 80)
            .background(.blue.opacity(0.1))
          
          Text("自适应")
            .frame(maxWidth: .infinity)
            .background(.green.opacity(0.1))
        }
        .padding()
      }
      
      // 理想尺寸
      ShowcaseItem(title: "理想尺寸") {
        HStack {
          Text("理想尺寸")
            .frame(idealWidth: 100)
            .background(.red.opacity(0.1))
          
          Text("自动调整")
            .background(.orange.opacity(0.1))
        }
        .padding()
      }
    }
  }
}

// MARK: - 布局优先级
struct LayoutPriorityHStackExampleView: View {
  var body: some View {
    Group {
      // 布局优先级基础
      ShowcaseItem(title: "布局优先级基础") {
        HStack {
          Text("低优先级")
            .layoutPriority(1)
            .lineLimit(1)
          Text("中等优先级")
            .layoutPriority(2)
            .lineLimit(1)
          Text("高优先级")
            .layoutPriority(3)
            .lineLimit(1)
        }
        .frame(width: 200)
        .padding()
        .background(.blue.opacity(0.1))
      }
      
      // 空间分配
      ShowcaseItem(title: "空间分配") {
        HStack {
          Text("固定宽度")
            .frame(width: 100)
            .background(.green.opacity(0.1))
          
          Text("弹性宽度1")
            .layoutPriority(1)
            .background(.yellow.opacity(0.1))
          
          Text("弹性宽度2")
            .layoutPriority(2)
            .background(.orange.opacity(0.1))
        }
        .padding()
      }
      
      // 文本截断优先级
      ShowcaseItem(title: "文本截断优先级") {
        HStack {
          Text("这是一段很长的文本")
            .layoutPriority(1)
            .lineLimit(1)
          
          Text("这是另一段更长的文本内容")
            .layoutPriority(2)
            .lineLimit(1)
        }
        .frame(width: 250)
        .padding()
        .background(.purple.opacity(0.1))
      }
    }
  }
}

// MARK: - 动态布局
struct DynamicHStackExampleView: View {
  @State private var isLongText = false
  @State private var showAdditionalContent = false
  @State private var items = ["项目1"]
  
  var body: some View {
    Group {
      // 动态文本长度
      ShowcaseItem(title: "动态文本长度") {
        VStack {
          HStack {
            Text(isLongText ? "这是一段很长的文本用来测试动态适应" : "短文本")
              .lineLimit(1)
            Spacer()
            Button("切换") {
              withAnimation {
                isLongText.toggle()
              }
            }
          }
          .padding()
          .background(.blue.opacity(0.1))
        }
      }
      
      // 动态内容显示
      ShowcaseItem(title: "动态内容显示") {
        VStack {
          HStack {
            Text("固定内容")
            if showAdditionalContent {
              Text("动态内容")
                .transition(.slide)
            }
            Spacer()
            Button("切换") {
              withAnimation {
                showAdditionalContent.toggle()
              }
            }
          }
          .padding()
          .background(.green.opacity(0.1))
        }
      }
      
      // 动态项目列表
      ShowcaseItem(title: "动态项目列表") {
        VStack {
          ForEach(items, id: \.self) { item in
            HStack {
              Text(item)
              Spacer()
            }
            .padding()
            .background(.orange.opacity(0.1))
          }
          
          Button("添加项目") {
            withAnimation {
              items.append("项目\(items.count + 1)")
            }
          }
        }
      }
    }
  }
}

// MARK: - 自定义样式
struct CardStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(10)
      .shadow(radius: 3)
  }
}

// MARK: - 主视图
struct HStackDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础示例
      ShowcaseSection("基础示例") {
        BasicHStackExampleView()
      }
      
      // MARK: - 样式示例
      ShowcaseSection("样式示例") {
        StyleHStackExampleView()
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        InteractiveHStackExampleView()
      }
      
      // MARK: - 列表示例
      ShowcaseSection("列表示例") {
        ListHStackExampleView()
      }
      
      // MARK: - 动态布局
      ShowcaseSection("动态布局") {
        DynamicHStackExampleView()
      }
      
      // MARK: - 布局优先级
      ShowcaseSection("布局优先级") {
        LayoutPriorityHStackExampleView()
      }
      
      // MARK: - 尺寸控制
      ShowcaseSection("尺寸控制") {
        SizeControlHStackExampleView()
      }
      
      // MARK: - 嵌套布局
      ShowcaseSection("嵌套布局") {
        NestedHStackExampleView()
      }
    }
    .navigationTitle("水平布局示例")
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    HStackDemoView()
  }
}
