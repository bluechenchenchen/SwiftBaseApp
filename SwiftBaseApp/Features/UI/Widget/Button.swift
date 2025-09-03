import SwiftUI
import AudioToolbox

// MARK: - 辅助组件
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? .gray.opacity(0.5) : .blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PressEffectModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                }
            }
    }
}

struct DebouncedButton: View {
    let action: () -> Void
    let label: String
    @State private var isDebouncing = false
    
    var body: some View {
        Button {
            guard !isDebouncing else { return }
            isDebouncing = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isDebouncing = false
            }
        } label: {
            Text(label)
        }
        .disabled(isDebouncing)
    }
}

// MARK: - 主视图
struct ButtonDemoView: View {
    // MARK: - 状态属性
    @State private var count = 0
    @State private var isLoading = false
    @State private var isExpanded = false
    @State private var isAnimating = false
    @State private var isPressed = false
    @State private var isRotated = false
    @State private var isRippling = false
    @State private var isMorphing = false
    @State private var dragOffset = CGSize.zero
    @State private var draggedButtonPosition = CGSize.zero
    
    var body: some View {
        ShowcaseList {
            // MARK: - 基础按钮
            ShowcaseSection("基础按钮") {
                // 1. 基本按钮
                ShowcaseItem(title: "基本按钮") {
                    VStack(spacing: 10) {
                        Button("点击按钮") {
                            count += 1
                        }
                        .buttonStyle(.bordered)
                        
                        Text("点击次数: \(count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // 2. 图标按钮
                ShowcaseItem(title: "图标按钮") {
                    Button {
                        count += 1
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("带图标的按钮")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                // 3. 加载按钮
                ShowcaseItem(title: "加载按钮") {
                    Button {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("点击加载")
                            }
                        }
                        .frame(width: 100)
                    }
                    .buttonStyle(.bordered)
                    .disabled(isLoading)
                }
            }
            
            // MARK: - 按钮样式
            ShowcaseSection("按钮样式") {
                // 1. 系统样式
                ShowcaseItem(title: "系统样式") {
                    VStack(spacing: 20) {
                        Button("默认样式") {}
                            .buttonStyle(.automatic)
                        
                        Button("边框样式") {}
                            .buttonStyle(.bordered)
                        
                        Button("突出样式") {}
                            .buttonStyle(.borderedProminent)
                        
                        Button("普通样式") {}
                            .buttonStyle(.plain)
                    }
                }
                
                // 2. 自定义样式
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        Button("自定义颜色") {}
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)
                        
                        Button("大按钮") {}
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        
                        Button("自定义样式按钮") {}
                            .buttonStyle(CustomButtonStyle())
                    }
                }
            }
            
            // MARK: - 高级功能
            ShowcaseSection("高级功能") {
                // 1. 下拉菜单
                ShowcaseItem(title: "下拉菜单") {
                    Menu("下拉菜单") {
                        Button("选项1") {}
                        Button("选项2") {}
                        Menu("子菜单") {
                            Button("子选项1") {}
                            Button("子选项2") {}
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                // 2. 展开收起
                ShowcaseItem(title: "展开收起") {
                    VStack {
                        Button {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Text("展开/收起")
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        if isExpanded {
                            Text("展开的内容")
                                .padding()
                                .background(.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }.frame(height: 100)
                }
            }
            
            // MARK: - 按钮布局
            ShowcaseSection("按钮布局") {
                // 1. 水平布局
                ShowcaseItem(title: "水平布局") {
                    HStack {
                        Button("按钮1") {}
                            .buttonStyle(.bordered)
                        Button("按钮2") {}
                            .buttonStyle(.bordered)
                        Button("按钮3") {}
                            .buttonStyle(.bordered)
                    }
                }
                
                // 2. 垂直布局
                ShowcaseItem(title: "垂直布局") {
                    VStack {
                        Button("按钮1") {}
                            .buttonStyle(.bordered)
                        Button("按钮2") {}
                            .buttonStyle(.bordered)
                        Button("按钮3") {}
                            .buttonStyle(.bordered)
                    }
                }
                
                // 3. 网格布局
                ShowcaseItem(title: "网格布局") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(1...4, id: \.self) { index in
                            Button("按钮\(index)") {}
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            
            // MARK: - 动画效果
            ShowcaseSection("动画效果") {
                // 1. 点击动画
                ShowcaseItem(title: "点击动画") {
                    Button("弹性动画") {}
                        .modifier(PressEffectModifier())
                        .buttonStyle(.bordered)
                }
                
                // 2. 旋转动画
                ShowcaseItem(title: "旋转动画") {
                    Button {
                        withAnimation(.spring()) {
                            isAnimating.toggle()
                        }
                    } label: {
                        Text("旋转动画")
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // MARK: - 角色和状态
            ShowcaseSection("角色和状态") {
                // 1. 角色按钮
                ShowcaseItem(title: "角色按钮") {
                    VStack(spacing: 20) {
                        Button("主要操作") {}
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        
                        Button("取消操作", role: .cancel) {}
                            .buttonStyle(.bordered)
                        
                        Button("删除操作", role: .destructive) {}
                            .buttonStyle(.borderedProminent)
                    }
                }
                
                // 2. 状态按钮
                ShowcaseItem(title: "状态按钮") {
                    VStack(spacing: 20) {
                        Button("禁用状态") {}
                            .buttonStyle(.bordered)
                            .disabled(true)
                        
                        Button(action: {}) {
                            Text("自定义禁用样式")
                                .opacity(0.5)
                        }
                        .buttonStyle(.bordered)
                        .disabled(true)
                    }
                }
            }
            
            // MARK: - 手势交互
            ShowcaseSection("手势交互") {
                // 1. 长按按钮
                ShowcaseItem(title: "长按按钮") {
                    Button {
                        // 动作
                    } label: {
                        Text("长按按钮")
                    }
                    .buttonStyle(.bordered)
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                print("长按结束")
                            }
                    )
                }
                
                // 2. 拖动按钮
                ShowcaseItem(title: "拖动按钮") {
                    ZStack {
                        // 背景区域指示器
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.1))
                            .frame(width: 300, height: 200)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(
                                        .gray.opacity(0.3),
                                        style: StrokeStyle(
                                            lineWidth: 2,
                                            dash: [5]
                                        )
                                    )
                            )
                        
                        // 可拖动按钮
                        Button("拖动我") {}
                            .buttonStyle(.borderedProminent)
                            .offset(x: draggedButtonPosition.width + dragOffset.width,
                                    y: draggedButtonPosition.height + dragOffset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        draggedButtonPosition.width += value.translation.width
                                        draggedButtonPosition.height += value.translation.height
                                        dragOffset = .zero
                                        
                                        // 限制按钮在区域内
                                        draggedButtonPosition.width = min(max(draggedButtonPosition.width, -120), 120)
                                        draggedButtonPosition.height = min(max(draggedButtonPosition.height, -70), 70)
                                    }
                            )
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
                    }
                }
            }
            
            // MARK: - 反馈效果
            ShowcaseSection("反馈效果") {
                // 1. 触觉反馈
                ShowcaseItem(title: "触觉反馈") {
                    VStack(spacing: 20) {
                        Button("轻触反馈") {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("重触反馈") {
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                // 2. 声音反馈
                ShowcaseItem(title: "声音反馈") {
                    Button("播放系统音效") {
                        AudioServicesPlaySystemSound(1104)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // MARK: - 动画效果
            ShowcaseSection("动画效果") {
                // 1. 缩放动画
                ShowcaseItem(title: "缩放动画") {
                    Button("点击缩放") {}
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                        .onTapGesture {
                            isPressed.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isPressed.toggle()
                            }
                        }
                }
                
                // 2. 旋转动画
                ShowcaseItem(title: "旋转动画") {
                    Button("3D旋转") {}
                        .frame(width: 200, height: 50)
                        .background(.purple)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .rotation3DEffect(
                            .degrees(isRotated ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isRotated)
                        .onTapGesture {
                            isRotated.toggle()
                        }
                }
                
                // 3. 波纹效果
                ShowcaseItem(title: "波纹效果") {
                    Button("波纹按钮") {}
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            Circle()
                                .fill(.white.opacity(0.3))
                                .scaleEffect(isRippling ? 2 : 0)
                                .opacity(isRippling ? 0 : 0.3)
                        )
                        .animation(.easeOut(duration: 1), value: isRippling)
                        .onTapGesture {
                            isRippling = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isRippling = false
                            }
                        }
                }
                
                // 4. 形变动画
                ShowcaseItem(title: "形变动画") {
                    Button("形变按钮") {}
                        .frame(width: isMorphing ? 50 : 200, height: 50)
                        .background(isMorphing ? .green : .blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: isMorphing ? 25 : 10))
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isMorphing)
                        .onTapGesture {
                            isMorphing.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isMorphing.toggle()
                            }
                        }
                }
            }
            
            // MARK: - 视觉效果
            ShowcaseSection("视觉效果") {
                // 1. 阴影效果
                ShowcaseItem(title: "阴影效果") {
                    VStack(spacing: 20) {
                        Button("基础阴影") {}
                            .buttonStyle(.bordered)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 4)
                        
                        Button("强调阴影") {}
                            .buttonStyle(.borderedProminent)
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 6)
                            .shadow(color: .purple.opacity(0.2), radius: 20, x: 0, y: 10)
                    }
                }
                
                // 2. 渐变背景
                ShowcaseItem(title: "渐变背景") {
                    VStack(spacing: 20) {
                        Button("线性渐变") {}
                            .frame(width: 200, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button("径向渐变") {}
                            .frame(width: 200, height: 50)
                            .background(
                                RadialGradient(
                                    colors: [.orange, .red],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button("角度渐变") {}
                            .frame(width: 200, height: 50)
                            .background(
                                AngularGradient(
                                    colors: [.green, .blue, .purple, .green],
                                    center: .center
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                // 3. 玻璃效果
                ShowcaseItem(title: "玻璃效果") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 300, height: 150)
                        
                        Button("玻璃态按钮") {}
                            .frame(width: 150, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                // 4. 边框效果
                ShowcaseItem(title: "边框效果") {
                    VStack(spacing: 20) {
                        Button("渐变边框") {}
                            .frame(width: 200, height: 50)
                            .background(.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                        
                        Button("动画边框") {}
                            .frame(width: 200, height: 50)
                            .background(.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.purple.opacity(0.5), lineWidth: 2)
                                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                                    .opacity(isAnimating ? 0 : 0.5)
                            )
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                                    isAnimating = true
                                }
                            }
                    }
                }
                
                // 5. 内发光效果
                ShowcaseItem(title: "内发光效果") {
                    Button("发光按钮") {}
                        .frame(width: 200, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue)
                                .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 0)
                                .shadow(color: .blue.opacity(0.2), radius: 20, x: 0, y: 0)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                        .foregroundStyle(.white)
                }
            }
            
            // MARK: - 优化功能
            ShowcaseSection("优化功能") {
                // 1. 防抖按钮
                ShowcaseItem(title: "防抖按钮") {
                    VStack(spacing: 20) {
                        DebouncedButton(action: {
                            count += 1
                        }, label: "防抖按钮")
                        .buttonStyle(.bordered)
                        
                        Text("点击次数: \(count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // 2. 异步按钮
                ShowcaseItem(title: "异步按钮") {
                    Button {
                        Task {
                            isLoading = true
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                            isLoading = false
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Text("异步操作")
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isLoading)
                }
            }
        }
        .navigationTitle("Button 示例")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        ButtonDemoView()
    }
}
