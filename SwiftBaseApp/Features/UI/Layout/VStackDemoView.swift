import SwiftUI

// MARK: - 主视图
struct VStackDemoView: View {
  // MARK: - 状态属性
  @State private var isExpanded = false
  @State private var isHighlighted = false
  @State private var username = ""
  @State private var password = ""
  @State private var rememberMe = false
  @State private var dynamicItems = ["项目1", "项目2", "项目3"]
  @State private var selectedAlignmentOption: AlignmentOption = .center
  @State private var showLongContent = false
  
  // MARK: - 计算属性
  enum AlignmentOption: String, CaseIterable {
    case leading = "左对齐"
    case center = "居中对齐"
    case trailing = "右对齐"
    
    var alignment: HorizontalAlignment {
      switch self {
      case .leading: return .leading
      case .center: return .center
      case .trailing: return .trailing
      }
    }
    
    var title: String {
      return rawValue
    }
  }
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础示例
      ShowcaseSection("基础示例") {
        // 1. 基本用法
        ShowcaseItem(title: "基本用法") {
          VStack {
            Text("顶部")
            Text("中间")
            Text("底部")
          }
          .background(.blue.opacity(0.1))
        }
        
        // 2. 设置间距
        ShowcaseItem(title: "设置间距") {
          VStack(spacing: 20) {
            Text("间距")
            Text("20")
            Text("点")
          }
          .background(.green.opacity(0.1))
        }
        
        // 3. 设置对齐
        ShowcaseItem(title: "设置对齐") {
          VStack(alignment: .leading) {
            Text("左对齐")
            Text("示例")
          }
          .background(.yellow.opacity(0.1))
        }
      }
      
      // MARK: - 对齐方式
      ShowcaseSection("对齐方式") {
        // 1. 多种对齐选项
        ShowcaseItem(title: "对齐选项") {
          VStack {
            Picker("选择对齐方式", selection: $selectedAlignmentOption) {
              ForEach(AlignmentOption.allCases, id: \.self) { option in
                Text(option.title).tag(option)
              }
            }
            .pickerStyle(.segmented)
            
            VStack(alignment: selectedAlignmentOption.alignment) {
              Text("短文本")
              Text("这是一个较长的文本行")
              Text("最长的文本行用来演示对齐效果")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.blue.opacity(0.1))
          }
        }
        
        // 2. 自定义对齐
        ShowcaseItem(title: "自定义对齐") {
          VStack(alignment: .leading) {
            HStack {
              Text("标题")
                .alignmentGuide(.leading) { d in
                  d[.leading]
                }
              Spacer()
            }
            
            Text("带有缩进的内容")
              .alignmentGuide(.leading) { _ in 20 }
          }
          .padding()
          .background(.green.opacity(0.1))
        }
      }
      
      // MARK: - 布局优先级
      ShowcaseSection("布局优先级") {
        // 1. 基础优先级
        ShowcaseItem(title: "布局优先级") {
          VStack {
            Text("低优先级")
              .layoutPriority(1)
              .lineLimit(1)
            
            Text("这是一个较长的文本，演示高优先级会获得更多空间")
              .layoutPriority(2)
              .lineLimit(1)
          }
          .frame(width: 200)
          .padding()
          .background(.orange.opacity(0.1))
        }
        
        // 2. 尺寸优先级
        ShowcaseItem(title: "尺寸优先级") {
          VStack {
            Text("固定高度")
              .frame(height: 30)
            
            Text("弹性高度")
              .frame(minHeight: 30)
              .frame(maxHeight: .infinity)
            
            Text("优先级高")
              .frame(height: 30)
              .layoutPriority(1)
          }
          .frame(height: 150)
          .padding()
          .background(.purple.opacity(0.1))
        }
      }
      
      // MARK: - 动态内容
      ShowcaseSection("动态内容") {
        // 1. ForEach 示例
        ShowcaseItem(title: "动态列表") {
          VStack {
            ForEach(dynamicItems, id: \.self) { item in
              Text(item)
                .padding(8)
                .background(.blue.opacity(0.1))
                .cornerRadius(4)
            }
            
            Button("添加项目") {
              dynamicItems.append("项目\(dynamicItems.count + 1)")
            }
            .buttonStyle(.bordered)
          }
        }
        
        // 2. 条件内容
        ShowcaseItem(title: "条件内容") {
          VStack {
            Button(showLongContent ? "显示简短内容" : "显示完整内容") {
              withAnimation {
                showLongContent.toggle()
              }
            }
            .buttonStyle(.bordered)
            
            if showLongContent {
              VStack {
                ForEach(1...5, id: \.self) { index in
                  Text("额外内容 \(index)")
                }
              }
              .transition(.opacity.combined(with: .slide))
            }
          }
          .padding()
          .background(.green.opacity(0.1))
        }
      }
      
      // MARK: - 尺寸控制
      ShowcaseSection("尺寸控制") {
        // 1. 固定尺寸
        ShowcaseItem(title: "固定尺寸") {
          VStack {
            Text("固定宽度")
              .frame(width: 150)
              .background(.blue.opacity(0.1))
            
            Text("固定高度")
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .background(.green.opacity(0.1))
            
            Text("固定尺寸")
              .frame(width: 150, height: 50)
              .background(.yellow.opacity(0.1))
          }
        }
        
        // 2. 弹性尺寸
        ShowcaseItem(title: "弹性尺寸") {
          VStack {
            Text("最小宽度")
              .frame(minWidth: 100)
              .background(.purple.opacity(0.1))
            
            Text("最大宽度")
              .frame(maxWidth: 200)
              .background(.orange.opacity(0.1))
            
            Text("理想宽度")
              .frame(idealWidth: 150)
              .background(.blue.opacity(0.1))
          }
        }
        
        // 3. 固定大小
        ShowcaseItem(title: "固定大小") {
          VStack {
            Text("这是一个很长的文本，演示固定大小的效果和换行表现")
              .fixedSize(horizontal: false, vertical: true)
              .frame(width: 150)
              .padding()
              .background(.red.opacity(0.1))
          }
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        // 1. LazyVStack
        ShowcaseItem(title: "LazyVStack") {
          ScrollView {
            LazyVStack {
              ForEach(0..<20) { index in
                Text("延迟加载项 \(index)")
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(index % 2 == 0 ? .blue.opacity(0.1) : .green.opacity(0.1))
              }
            }
          }
          .frame(height: 200)
        }
      }
      
      // MARK: - 嵌套布局
      ShowcaseSection("嵌套布局") {
        // 1. 复杂布局
        ShowcaseItem(title: "复杂布局") {
          VStack(spacing: 10) {
            HStack {
              VStack(alignment: .leading) {
                Text("左侧")
                Text("内容")
              }
              
              Spacer()
              
              VStack(alignment: .trailing) {
                Text("右侧")
                Text("内容")
              }
            }
            .padding()
            .background(.blue.opacity(0.1))
            
            VStack {
              HStack {
                Text("标题")
                Spacer()
                Text("详情")
              }
              
              Divider()
              
              HStack {
                Image(systemName: "star.fill")
                Text("评分")
                Spacer()
                Text("4.5")
              }
            }
            .padding()
            .background(.green.opacity(0.1))
          }
        }
        
        // 2. 网格布局
        ShowcaseItem(title: "网格布局") {
          VStack {
            ForEach(0..<2) { row in
              HStack {
                ForEach(0..<2) { column in
                  VStack {
                    Image(systemName: "star.fill")
                    Text("项目 \(row * 2 + column)")
                  }
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(.blue.opacity(0.1))
                }
              }
            }
          }
        }
      }
      
      // MARK: - 样式示例
      ShowcaseSection("样式示例") {
        // 1. 边框样式
        ShowcaseItem(title: "边框样式") {
          VStack {
            Image(systemName: "star.fill")
            Text("边框样式")
          }
          .padding()
          .border(.blue)
        }
        
        // 2. 阴影样式
        ShowcaseItem(title: "阴影样式") {
          VStack {
            Image(systemName: "moon.fill")
            Text("阴影样式")
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)
          .shadow(radius: 3)
        }
        
        // 3. 自定义样式
        ShowcaseItem(title: "自定义样式") {
          VStack {
            Image(systemName: "sun.max.fill")
            Text("自定义样式")
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(10)
          .shadow(radius: 3)
        }
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        // 1. 展开/收起
        ShowcaseItem(title: "展开/收起") {
          VStack {
            Text("标题")
            if isExpanded {
              Text("详细内容")
                .transition(.slide)
            }
          }
          .padding()
          .frame(height: 100)
          .background(.blue.opacity(0.1))
          .cornerRadius(8)
          .onTapGesture {
            withAnimation {
              isExpanded.toggle()
            }
          }
        }
        
        // 2. 高亮效果
        ShowcaseItem(title: "高亮效果") {
          VStack {
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
      
      // MARK: - 表单示例
      ShowcaseSection("表单示例") {
        ShowcaseItem(title: "登录表单") {
          VStack(spacing: 16) {
            TextField("用户名", text: $username)
              .textFieldStyle(.roundedBorder)
            
            SecureField("密码", text: $password)
              .textFieldStyle(.roundedBorder)
            
            Toggle("记住我", isOn: $rememberMe)
            
            Button("登录") {}
              .buttonStyle(.borderedProminent)
              .frame(maxWidth: .infinity)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .shadow(radius: 2)
        }
      }
      
      // MARK: - 卡片示例
      ShowcaseSection("卡片示例") {
        ShowcaseItem(title: "信息卡片") {
          VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "photo.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(height: 200)
              .background(.blue.opacity(0.1))
              .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
              Text("卡片标题")
                .font(.headline)
              
              Text("这是一段较长的描述文本，用来演示卡片布局的效果。可以包含多行内容，并且会自动换行。")
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
              
              HStack {
                Button("详情") {}
                  .buttonStyle(.bordered)
                
                Spacer()
                
                Button("分享") {}
                  .buttonStyle(.bordered)
              }
              .padding(.top, 8)
            }
            .padding()
          }
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .shadow(radius: 3)
        }
      }
    }
    .navigationTitle("垂直布局示例")
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    VStackDemoView()
  }
}
