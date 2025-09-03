import SwiftUI

// MARK: - 主视图
struct ModifierGuideView: View {
  // MARK: - 状态属性
  @State private var isExpanded = false
  @State private var selectedColor = Color.blue
  @State private var cornerRadius: CGFloat = 10
  @State private var shadowRadius: CGFloat = 5
  @State private var opacity: Double = 1.0
  @State private var scale: CGFloat = 1.0
  @State private var rotation: Double = 0
  @State private var offset: CGSize = .zero
  @State private var showAnimation = false
  @State private var selectedStyle = 0
  
  // MARK: - 计算属性
  private var colors: [Color] {
    [.blue, .green, .red, .purple, .orange, .pink]
  }
  
  private var cornerRadiusOptions: [CGFloat] {
    [0, 5, 10, 15, 20, 25]
  }
  
  private var shadowRadiusOptions: [CGFloat] {
    [0, 2, 5, 8, 12, 16]
  }
  
  var body: some View {
    
    
    ShowcaseList {
      
      VStack() {
        Text("Hello").frame(width:300,height:40).background(Color.red)
      }.frame(height:800)
   
      
      VStack(spacing:0) {
        //      pfb 6种： pfb,pbf,fpb,fbp,bpf,bfp
        //     pfb
        Text("pfb")
          .padding(.all, 100)
          .frame(width: 300, height: 40)
          .background(Color.red)
        
        
        //     pbf
        Text("pbf")
          .padding()
          .background(Color.blue)
          .frame(width: 300, height: 40)
        
        // fpb
        Text("fpb")
          .frame(width: 300, height: 40)
          .padding()
          .background(Color.green)
        //fbp
        Text("fbp")
          .frame(width: 300, height: 40)
          .background(Color.purple)
          .padding()
        
        
        //bpf
        Text("bpf")
          .background(Color.mint)
          .padding()
          .frame(width: 300, height: 40)
        
        //bfp
        Text("bfp")
          .background(Color.orange)
          .frame(width: 300, height: 40)
          .padding()
        
      }
      
      
      VStack(spacing:0) {
        //      pfb 6种： pfb,pbf,fpb,fbp,bpf,bfp
        
        
        ZStack() {
          //     pfb
          Text("pfb")
            .padding(.all, 100)
            .frame(width: 300, height: 40)
            .background(Color.red)
          
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
        }
        
        
        
        ZStack() {
          //     pbf
          Text("pbf")
            .padding()
            .background(Color.red)
            .frame(width: 300, height: 40)
          
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
        }
        
        ZStack() {
          // fpb
          Text("fpb")
            .frame(width: 300, height: 40)
            .padding()
            .background(Color.red)
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
        }
        
        ZStack() {
          //fbp
          Text("fbp")
            .frame(width: 300, height: 40)
            .background(Color.red)
            .padding()
          
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
        }
        
        ZStack() {
          //bpf
          Text("bpf")
            .background(Color.red)
            .padding()
            .frame(width: 300, height: 40)
          
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
          
        }
        
        ZStack() {
          //bfp
          Text("bfp")
            .background(Color.red)
            .frame(width: 300, height: 40)
            .padding()
          Text("正常 300 * 40").frame(width:300, height: 40, alignment: .trailing).background(Color.blue.opacity(0.2))
        }
        
      }
      
      
      
      
      
      
      
      
      // MARK: - 基础概念
      ShowcaseSection("基础概念") {
        ShowcaseItem(title: "修饰符链式调用", backgroundColor: Color.gray.opacity(0.1)) {
          ModifierChainExampleView().padding()
        }
        
        ShowcaseItem(title: "修饰符工作原理", backgroundColor: Color.purple.opacity(0.1)) {
          ModifierWorkflowView()
          Text("这意味着修饰符的顺序决定了修改的应用顺序")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center).padding()
        }
      }
      
      // MARK: - 顺序规则
      ShowcaseSection("顺序规则") {
        ShowcaseItem(title: "推荐顺序",backgroundColor: Color.green.opacity(0.1)) {
          RecommendedOrderView()
        }
        
        ShowcaseItem(title: "修饰符分类") {
          ModifierCategoriesView()
        }
      }
      
      // MARK: - 实际示例
      ShowcaseSection("实际示例") {
        ShowcaseItem(title: "尺寸和布局") {
          SizeLayoutExampleView(selectedColor: $selectedColor, colors: colors)
        }
        
        ShowcaseItem(title: "背景和圆角") {
          BackgroundCornerExampleView(
            selectedColor: $selectedColor,
            cornerRadius: $cornerRadius
          )
        }
        
        ShowcaseItem(title: "复杂布局") {
          ComplexLayoutExampleView(selectedColor: selectedColor)
        }
      }
      
      // MARK: - 动画修饰符
      ShowcaseSection("动画修饰符") {
        ShowcaseItem(title: "动画效果") {
          AnimationExampleView(
            selectedColor: $selectedColor,
            showAnimation: $showAnimation
          )
        }
        
        ShowcaseItem(title: "变换效果") {
          TransformExampleView(
            selectedColor: $selectedColor,
            scale: $scale,
            rotation: $rotation,
            offset: $offset
          )
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "渲染优化") {
          RenderingOptimizationView(colors: colors)
        }
        
        ShowcaseItem(title: "避免重复创建") {
          AvoidRepetitionView()
        }
      }
      
      // MARK: - 自定义修饰符
      ShowcaseSection("自定义修饰符") {
        ShowcaseItem(title: "ViewModifier") {
          CustomModifierView(
            selectedColor: $selectedColor,
            cornerRadius: $cornerRadius,
            shadowRadius: $shadowRadius
          )
        }
        
        ShowcaseItem(title: "条件修饰符") {
          ConditionalModifierView(
            isExpanded: $isExpanded,
            showAnimation: $showAnimation
          )
        }
      }
      
      // MARK: - 调试技巧
      ShowcaseSection("调试技巧") {
        ShowcaseItem(title: "背景色调试") {
          BackgroundDebugView(selectedColor: selectedColor)
        }
        
        ShowcaseItem(title: "GeometryReader 调试") {
          GeometryDebugView(selectedColor: selectedColor)
        }
      }
    }
    .navigationTitle("修饰符使用指南")
  }
}

// MARK: - 子视图组件

// 修饰符链式调用示例视图
struct ModifierChainExampleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("每个修饰符都会创建一个新的视图：")
        .font(.subheadline)
        .foregroundStyle(.secondary)
      
      CodeLineView(code: "Text(\"Hello\")", color: .blue)
      CodeLineView(code: "  .font(.title)", color: .green)
      CodeLineView(code: "  .foregroundColor(.red)", color: .orange)
      CodeLineView(code: "  .padding(10)", color: .purple)
    }
    
    
  }
}

// 代码行视图
struct CodeLineView: View {
  let code: String
  let color: Color
  
  var body: some View {
    Text(code)
      .font(.system(.body, design: .monospaced))
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(color.opacity(0.1))
      .cornerRadius(4)
  }
}

// 修饰符工作原理视图
struct ModifierWorkflowView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        WorkflowStepView(number: 1, text: "接收一个视图作为输入", color: .blue)
        WorkflowStepView(number: 2, text: "应用特定的修改", color: .green)
        WorkflowStepView(number: 3, text: "返回一个新的视图", color: .orange)
      }
      .padding()
      
    }
  }
}

// 工作流程步骤视图
struct WorkflowStepView: View {
  let number: Int
  let text: String
  let color: Color
  
  var body: some View {
    HStack {
      Image(systemName: "\(number).circle.fill")
        .foregroundStyle(color)
      Text(text)
    }
    .font(.body)
  }
}

// 推荐顺序视图
struct RecommendedOrderView: View {
  var body: some View {
    
    
    
    VStack(alignment: .leading, spacing: 8) {
      OrderStepView(number: 1, text: "尺寸设置", color: .blue)
      OrderStepView(number: 2, text: "样式设置", color: .green)
      OrderStepView(number: 3, text: "布局设置", color: .orange)
      OrderStepView(number: 4, text: "交互设置", color: .purple)
    }
    .padding()
    
  }
  
}

// 顺序步骤视图
struct OrderStepView: View {
  let number: Int
  let text: String
  let color: Color
  
  var body: some View {
    HStack {
      Text("\(number).")
        .font(.headline)
        .foregroundStyle(color)
      Text(text)
        .font(.body)
      Spacer()
    }
  }
}

// 修饰符分类视图
struct ModifierCategoriesView: View {
  var body: some View {
    
    
    
    VStack(spacing: 12) {
      CategoryItemView(
        title: "尺寸修饰符",
        examples: ".frame(), .fixedSize(), .layoutPriority()",
        color: .blue
      )
      CategoryItemView(
        title: "样式修饰符",
        examples: ".background(), .foregroundColor(), .font(), .cornerRadius()",
        color: .green
      )
      CategoryItemView(
        title: "布局修饰符",
        examples: ".padding(), .offset(), .position(), .alignmentGuide()",
        color: .orange
      )
      CategoryItemView(
        title: "交互修饰符",
        examples: ".onTapGesture(), .onAppear(), .onChange(), .gesture()",
        color: .purple
      )
    }
    
  }
}

// 分类项目视图
struct CategoryItemView: View {
  let title: String
  let examples: String
  let color: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      Text(examples)
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.1))
    .cornerRadius(8)
  }
}

// 尺寸和布局示例视图
struct SizeLayoutExampleView: View {
  @Binding var selectedColor: Color
  let colors: [Color]
  
  var body: some View {
    VStack(spacing: 16) {
      VStack(spacing: 12) {
        // ExampleComparisonView(
        //   title: "❌ 错误顺序",
        //   color: .red,
        //   description: "padding 被 frame 覆盖"
        // ) {
        //   Rectangle()
        //     .fill(selectedColor)
        //     .padding(20)
        //     .frame(width: 200, height: 100)
        // }
        VStack(alignment: .leading, spacing: 8) {
          Text("❌ 错误顺序")
            .font(.subheadline)
            .foregroundStyle(.red)
          Text("padding 被 frame 覆盖dsffsfssd")
            .font(.caption)
            .foregroundStyle(.secondary)
        }.padding(20)
          .frame(width: 200, height: 100)
          .background(selectedColor)
        CodeLineView(code: ".padding(20)\n.frame(width: 200, height: 100)", color: .blue)
        
        // ExampleComparisonView(
        //   title: "✅ 正确顺序",
        //   color: .green,
        //   description: "200x100 矩形，周围有 20 点内边距"
        // ) {
        //   Rectangle()
        //     .fill(selectedColor)
        //     .frame(width: 200, height: 100)
        //     .padding(20)
        // }
        
        VStack(alignment: .leading, spacing: 8) {
          Text("✅ 正确顺序")
            .font(.subheadline)
            .foregroundStyle(.green)
          Text("200x100 矩形，周围有 20 点内边距lkjklj")
            .font(.caption)
            .foregroundStyle(.secondary)
        } .frame(width: 200, height: 100)
          .padding(20)
          .background(selectedColor)
        
        CodeLineView(code: ".frame(width: 200, height: 100)\n.padding(20)", color: .blue)
      }
      
      ColorPickerView(selectedColor: $selectedColor, colors: colors)
    }.frame(maxWidth: .infinity)
  }
}

// 示例对比视图
struct ExampleComparisonView<Content: View>: View {
  let title: String
  let color: Color
  let description: String
  let content: Content
  
  init(title: String, color: Color, description: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.description = description
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      content
        .overlay(
          Text(description)
            .font(.caption)
            .foregroundStyle(.white)
        )
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 颜色选择器视图
struct ColorPickerView: View {
  @Binding var selectedColor: Color
  let colors: [Color]
  
  var body: some View {
    HStack(spacing: 20) {
      ForEach(colors, id: \.self) { color in
        Circle()
          .fill(color)
          .frame(width: 30, height: 30)
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              selectedColor = color
            }
          }
      }
    }
    .padding(.top)
  }
}

// 背景和圆角示例视图
struct BackgroundCornerExampleView: View {
  @Binding var selectedColor: Color
  @Binding var cornerRadius: CGFloat
  
  var body: some View {
    VStack(spacing: 16) {
      Text("背景和圆角示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        ExampleComparisonView(
          title: "❌ 错误顺序",
          color: .red,
          description: "圆角被背景覆盖"
        ) {
          Rectangle()
            .fill(selectedColor)
            .cornerRadius(cornerRadius)
            .background(Color.yellow)
        }
        
        ExampleComparisonView(
          title: "✅ 正确顺序",
          color: .green,
          description: "蓝色背景，带圆角"
        ) {
          Rectangle()
            .fill(selectedColor)
            .background(Color.yellow)
            .cornerRadius(cornerRadius)
        }
      }
      
      CornerRadiusSlider(cornerRadius: $cornerRadius, selectedColor: selectedColor)
    }
  }
}

// 圆角滑块视图
struct CornerRadiusSlider: View {
  @Binding var cornerRadius: CGFloat
  let selectedColor: Color
  
  var body: some View {
    VStack(spacing: 8) {
      Text("圆角大小: \(Int(cornerRadius))")
        .font(.caption)
        .foregroundStyle(.secondary)
      
      Slider(value: $cornerRadius, in: 0...25, step: 5)
        .accentColor(selectedColor)
    }
    .padding(.top)
  }
}

// 复杂布局示例视图
struct ComplexLayoutExampleView: View {
  let selectedColor: Color
  
  var body: some View {
    VStack(spacing: 16) {
      Text("复杂布局示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        ExampleComparisonView(
          title: "❌ 错误顺序",
          color: .red,
          description: "颜色可能被覆盖"
        ) {
          Text("Hello World")
            .padding(10)
            .background(selectedColor)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
        }
        
        ExampleComparisonView(
          title: "✅ 正确顺序",
          color: .green,
          description: "白色文字，彩色背景，占满宽度，有内边距"
        ) {
          Text("Hello World")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(selectedColor)
            .padding(10)
        }
      }
    }
  }
}

// 动画示例视图
struct AnimationExampleView: View {
  @Binding var selectedColor: Color
  @Binding var showAnimation: Bool
  
  var body: some View {
    VStack(spacing: 16) {
      Text("动画修饰符示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        ExampleComparisonView(
          title: "❌ 错误顺序",
          color: .red,
          description: "背景色不会动画"
        ) {
          Rectangle()
            .fill(selectedColor)
            .frame(width: 100, height: 100)
            .scaleEffect(showAnimation ? 1.5 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: showAnimation)
            .background(Color.yellow)
        }
        
        ExampleComparisonView(
          title: "✅ 正确顺序",
          color: .green,
          description: "只有缩放会动画"
        ) {
          Rectangle()
            .fill(selectedColor)
            .background(Color.yellow)
            .frame(width: 100, height: 100)
            .scaleEffect(showAnimation ? 1.5 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: showAnimation)
        }
      }
      
      AnimationButton(showAnimation: $showAnimation, selectedColor: selectedColor)
    }
  }
}

// 动画按钮视图
struct AnimationButton: View {
  @Binding var showAnimation: Bool
  let selectedColor: Color
  
  var body: some View {
    Button {
      withAnimation(.spring()) {
        showAnimation.toggle()
      }
    } label: {
      Text(showAnimation ? "缩小" : "放大")
        .frame(maxWidth: .infinity)
        .padding()
        .background(selectedColor)
        .foregroundStyle(.white)
        .cornerRadius(8)
    }
    .padding(.top)
  }
}

// 变换示例视图
struct TransformExampleView: View {
  @Binding var selectedColor: Color
  @Binding var scale: CGFloat
  @Binding var rotation: Double
  @Binding var offset: CGSize
  
  var body: some View {
    VStack(spacing: 16) {
      Text("变换效果示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        TransformItemView(
          title: "缩放效果",
          color: .blue
        ) {
          Rectangle()
            .fill(selectedColor)
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 0.5), value: scale)
        }
        
        TransformItemView(
          title: "旋转效果",
          color: .green
        ) {
          Rectangle()
            .fill(selectedColor)
            .frame(width: 80, height: 80)
            .rotationEffect(.degrees(rotation))
            .animation(.easeInOut(duration: 0.5), value: rotation)
        }
        
        TransformItemView(
          title: "偏移效果",
          color: .orange
        ) {
          Rectangle()
            .fill(selectedColor)
            .frame(width: 80, height: 80)
            .offset(offset)
            .animation(.easeInOut(duration: 0.5), value: offset)
        }
      }
      
      TransformButtonsView(
        scale: $scale,
        rotation: $rotation,
        offset: $offset
      )
    }
  }
}

// 变换项目视图
struct TransformItemView<Content: View>: View {
  let title: String
  let color: Color
  let content: Content
  
  init(title: String, color: Color, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      content
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 变换按钮视图
struct TransformButtonsView: View {
  @Binding var scale: CGFloat
  @Binding var rotation: Double
  @Binding var offset: CGSize
  
  var body: some View {
    HStack(spacing: 20) {
      Button("缩放") {
        scale = scale == 1.0 ? 1.5 : 1.0
      }
      .buttonStyle(.borderedProminent)
      
      Button("旋转") {
        rotation += 90
      }
      .buttonStyle(.borderedProminent)
      
      Button("偏移") {
        offset = offset == .zero ? CGSize(width: 50, height: 0) : .zero
      }
      .buttonStyle(.borderedProminent)
    }
    .padding(.top)
  }
}

// 渲染优化视图
struct RenderingOptimizationView: View {
  let colors: [Color]
  
  var body: some View {
    VStack(spacing: 16) {
      Text("渲染优化示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        OptimizationItemView(
          title: "compositingGroup 优化",
          color: .blue,
          description: "将多个视图合并为一个图层"
        ) {
          VStack {
            ForEach(0..<10) { index in
              Circle()
                .fill(colors[index % colors.count])
                .frame(width: 20, height: 20)
            }
          }
          .compositingGroup()
        }
        
        OptimizationItemView(
          title: "drawingGroup 优化",
          color: .green,
          description: "使用 Metal 渲染"
        ) {
          Text("复杂渐变文本")
            .font(.title)
            .foregroundStyle(
              LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .drawingGroup()
        }
      }
    }
  }
}

// 优化项目视图
struct OptimizationItemView<Content: View>: View {
  let title: String
  let color: Color
  let description: String
  let content: Content
  
  init(title: String, color: Color, description: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.description = description
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      content
        .overlay(
          Text(description)
            .font(.caption)
            .foregroundStyle(.white)
        )
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 避免重复创建视图
struct AvoidRepetitionView: View {
  var body: some View {
    VStack(spacing: 16) {
      Text("避免重复创建对象")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        PerformanceComparisonView(
          title: "❌ 性能较差",
          color: .red,
          description: "每个项目都创建渐变"
        ) {
          VStack(spacing: 4) {
            ForEach(0..<5) { _ in
              Text("项目")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                  LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                  )
                )
                .foregroundStyle(.white)
                .cornerRadius(4)
            }
          }
        }
        
        PerformanceComparisonView(
          title: "✅ 性能更好",
          color: .green,
          description: "复用渐变对象"
        ) {
          let gradient = LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
          )
          
          VStack(spacing: 4) {
            ForEach(0..<5) { _ in
              Text("项目")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(gradient)
                .foregroundStyle(.white)
                .cornerRadius(4)
            }
          }
        }
      }
    }
  }
}

// 性能对比视图
struct PerformanceComparisonView<Content: View>: View {
  let title: String
  let color: Color
  let description: String
  let content: Content
  
  init(title: String, color: Color, description: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.description = description
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      Text(description)
        .font(.caption)
        .foregroundStyle(.secondary)
      content
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 自定义修饰符视图
struct CustomModifierView: View {
  @Binding var selectedColor: Color
  @Binding var cornerRadius: CGFloat
  @Binding var shadowRadius: CGFloat
  
  var body: some View {
    VStack(spacing: 16) {
      Text("自定义 ViewModifier")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        CustomModifierItemView(
          title: "卡片样式",
          color: .blue
        ) {
          Text("使用自定义修饰符")
            .cardStyle()
        }
        
        CustomModifierItemView(
          title: "扩展方法",
          color: .green
        ) {
          Text("使用扩展方法")
            .cardStyle()
        }
      }
      
      ShadowRadiusSlider(shadowRadius: $shadowRadius, selectedColor: selectedColor)
    }
  }
}

// 自定义修饰符项目视图
struct CustomModifierItemView<Content: View>: View {
  let title: String
  let color: Color
  let content: Content
  
  init(title: String, color: Color, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      content
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 阴影半径滑块视图
struct ShadowRadiusSlider: View {
  @Binding var shadowRadius: CGFloat
  let selectedColor: Color
  
  var body: some View {
    VStack(spacing: 8) {
      Text("阴影半径: \(Int(shadowRadius))")
        .font(.caption)
        .foregroundStyle(.secondary)
      
      Slider(value: $shadowRadius, in: 0...16, step: 2)
        .accentColor(selectedColor)
    }
    .padding(.top)
  }
}

// 条件修饰符视图
struct ConditionalModifierView: View {
  @Binding var isExpanded: Bool
  @Binding var showAnimation: Bool
  
  var body: some View {
    VStack(spacing: 16) {
      Text("条件修饰符示例")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        ConditionalModifierItemView(
          title: "使用 if 语句",
          color: .blue
        ) {
          Text("Hello World")
            .font(.title)
            .conditional(isExpanded) { view in
              view
                .foregroundColor(.yellow)
                .background(Color.black)
            }
            .conditional(showAnimation) { view in
              view.fontWeight(.bold)
            }
        }
        
        ConditionalModifierItemView(
          title: "使用 when 修饰符",
          color: .green
        ) {
          Text("Hello World")
            .font(.title)
            .when(isExpanded) { view in
              view.background(Color.yellow)
            }
        }
      }
      
      ConditionalButtonsView(
        isExpanded: $isExpanded,
        showAnimation: $showAnimation
      )
    }
  }
}

// 条件修饰符项目视图
struct ConditionalModifierItemView<Content: View>: View {
  let title: String
  let color: Color
  let content: Content
  
  init(title: String, color: Color, @ViewBuilder content: () -> Content) {
    self.title = title
    self.color = color
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(color)
      content
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(10)
  }
}

// 条件按钮视图
struct ConditionalButtonsView: View {
  @Binding var isExpanded: Bool
  @Binding var showAnimation: Bool
  
  var body: some View {
    HStack(spacing: 20) {
      Button("切换展开") {
        withAnimation(.easeInOut(duration: 0.3)) {
          isExpanded.toggle()
        }
      }
      .buttonStyle(.borderedProminent)
      
      Button("切换动画") {
        withAnimation(.easeInOut(duration: 0.3)) {
          showAnimation.toggle()
        }
      }
      .buttonStyle(.borderedProminent)
    }
    .padding(.top)
  }
}

// 背景调试视图
struct BackgroundDebugView: View {
  let selectedColor: Color
  
  var body: some View {
    VStack(spacing: 16) {
      Text("使用背景色调试布局")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      VStack(spacing: 12) {
        VStack(alignment: .leading, spacing: 8) {
          Text("调试用背景色")
            .font(.subheadline)
            .foregroundStyle(.blue)
          Rectangle()
            .fill(selectedColor)
            .frame(width: 200, height: 100)
            .background(Color.red.opacity(0.3))
            .padding(20)
            .background(Color.blue.opacity(0.3))
            .overlay(
              Text("红色：内容区域\n蓝色：padding 区域")
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.top, 50)
            )
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
      }
    }
  }
}

// 几何调试视图
struct GeometryDebugView: View {
  let selectedColor: Color
  
  var body: some View {
    VStack(spacing: 16) {
      Text("使用 GeometryReader 查看尺寸")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
      
      GeometryReader { geometry in
        Rectangle()
          .fill(selectedColor)
          .frame(width: 200, height: 100)
          .padding(20)
          .overlay(
            VStack {
              Text("容器尺寸")
                .font(.caption)
                .foregroundStyle(.white)
              Text("\(Int(geometry.size.width)) x \(Int(geometry.size.height))")
                .font(.caption)
                .foregroundStyle(.white)
            }
          )
      }
      .frame(height: 200)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)
    }
  }
}

// MARK: - 自定义修饰符
struct ModifierGuideCardStyle: ViewModifier {
  let backgroundColor: Color
  let cornerRadius: CGFloat
  let shadowRadius: CGFloat
  
  func body(content: Content) -> some View {
    content
      .padding(16)
      .background(backgroundColor)
      .cornerRadius(cornerRadius)
      .shadow(radius: shadowRadius)
  }
}

// MARK: - 扩展方法
extension View {
  func cardStyle() -> some View {
    self.modifier(ModifierGuideCardStyle(
      backgroundColor: .white,
      cornerRadius: 12,
      shadowRadius: 4
    ))
  }
  
  func conditional<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      return AnyView(transform(self))
    } else {
      return AnyView(self)
    }
  }
  
  func when<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      return AnyView(transform(self))
    } else {
      return AnyView(self)
    }
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    ModifierGuideView()
  }
}
