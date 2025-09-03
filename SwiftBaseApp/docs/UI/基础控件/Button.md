# SwiftUI 按钮控件完整指南

## 1. 基础按钮

### 1.1 基本用法

```swift
// 基本按钮
Button("点击我") {
    // 按钮点击事件处理
    handleTap()
}

// 自定义标签
Button {
    handleTap()
} label: {
    Text("自定义按钮")
        .bold()
        .foregroundStyle(.blue)
}

// 带图标的按钮
Button {
    handleAction()
} label: {
    HStack {
        Image(systemName: "star.fill")
        Text("收藏")
    }
}
```

### 1.2 按钮样式

```swift
// 内置样式
Button("默认样式", action: handleTap)
    .buttonStyle(.automatic)

Button("边框样式", action: handleTap)
    .buttonStyle(.bordered)

Button("突出样式", action: handleTap)
    .buttonStyle(.borderedProminent)

Button("普通样式", action: handleTap)
    .buttonStyle(.plain)

// 自定义颜色
Button("自定义颜色", action: handleTap)
    .buttonStyle(.borderedProminent)
    .tint(.purple)

// 自定义大小
Button("大按钮", action: handleTap)
    .buttonStyle(.bordered)
    .controlSize(.large)
```

## 2. 高级按钮

### 2.1 自定义按钮样式

```swift
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

// 使用自定义样式
Button("自定义样式", action: handleTap)
    .buttonStyle(CustomButtonStyle())
```

### 2.2 按钮状态

```swift
// 禁用状态
@State private var isDisabled = false

Button("可禁用按钮", action: handleTap)
    .disabled(isDisabled)

// 加载状态
@State private var isLoading = false

Button {
    isLoading = true
    // 异步操作
} label: {
    if isLoading {
        ProgressView()
    } else {
        Text("开始加载")
    }
}
.disabled(isLoading)
```

## 3. 特殊按钮类型

### 3.1 菜单按钮

```swift
Menu("选项菜单") {
    Button("选项1", action: handleOption1)
    Button("选项2", action: handleOption2)
    Menu("子菜单") {
        Button("子选项1", action: handleSubOption1)
        Button("子选项2", action: handleSubOption2)
    }
}
```

### 3.2 长按按钮

```swift
// 长按手势
Button {
    handleTap()
} label: {
    Text("长按按钮")
}
.simultaneousGesture(LongPressGesture().onEnded { _ in
    handleLongPress()
})

// 组合手势
Button {
    handleTap()
} label: {
    Text("组合手势按钮")
}
.gesture(
    DragGesture()
        .onChanged { _ in handleDrag() }
        .onEnded { _ in handleDragEnd() }
)
```

## 4. 按钮布局

### 4.1 按钮组

```swift
// 水平按钮组
HStack {
    Button("按钮1", action: handleButton1)
    Button("按钮2", action: handleButton2)
    Button("按钮3", action: handleButton3)
}

// 垂直按钮组
VStack {
    Button("按钮1", action: handleButton1)
    Button("按钮2", action: handleButton2)
    Button("按钮3", action: handleButton3)
}

// 网格按钮组
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible())
]) {
    Button("按钮1", action: handleButton1)
    Button("按钮2", action: handleButton2)
    Button("按钮3", action: handleButton3)
    Button("按钮4", action: handleButton4)
}
```

### 4.2 按钮对齐

```swift
// 按钮对齐
Button {
    handleTap()
} label: {
    Text("对齐按钮")
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
}

// 固定大小按钮
Button {
    handleTap()
} label: {
    Text("固定大小")
        .frame(width: 200, height: 50)
        .background(.blue)
        .foregroundStyle(.white)
}
```

## 5. 按钮动画

### 5.1 基础动画

```swift
// 点击动画
Button {
    withAnimation {
        isExpanded.toggle()
    }
} label: {
    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
}

// 自定义动画
Button {
    handleTap()
} label: {
    Text("动画按钮")
}
.scaleEffect(isPressed ? 0.9 : 1.0)
.animation(.spring(), value: isPressed)
```

### 5.2 高级动画

```swift
// 组合动画
Button {
    handleTap()
} label: {
    Text("组合动画")
}
.modifier(PressEffectModifier())

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
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
Button {
    handleTap()
} label: {
    Text("无障碍按钮")
}
.accessibilityLabel("主要操作按钮")
.accessibilityHint("点击执行主要操作")
.accessibilityAddTraits(.isButton)
```

### 6.2 本地化

```swift
Button {
    handleTap()
} label: {
    Text("button.submit")
        .environment(\.locale, Locale(identifier: "zh_CN"))
}
```

## 7. 性能优化

### 7.1 按钮防抖

```swift
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
```

### 7.2 内存管理

```swift
// 使用弱引用避免循环引用
class ButtonViewModel: ObservableObject {
    weak var delegate: ButtonDelegate?

    func handleTap() {
        delegate?.buttonTapped()
    }
}
```

## 8. 最佳实践

1. 按钮文字应简洁明了
2. 提供适当的视觉反馈
3. 合理使用禁用状态
4. 注意按钮大小和点击区域
5. 适当使用动画效果
6. 实现防抖处理
7. 注意内存管理
8. 支持无障碍功能
9. 适配深色模式
10. 考虑本地化需求

## 9. 注意事项

1. 避免按钮文字过长
2. 保持统一的视觉风格
3. 注意按钮间距
4. 合理使用图标
5. 处理异步操作状态
6. 注意按钮响应区域
7. 避免过度动画
8. 处理边缘情况
9. 注意性能影响
10. 保持代码可维护性

## 10. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI

// MARK: - 基础按钮示例
struct BasicButtonExampleView: View {
    @State private var count = 0
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 基础按钮示例").font(.title)

            Group {
                // 基本按钮
                Button("基本按钮") {
                    count += 1
                }
                Text("点击次数: \(count)")

                // 自定义标签按钮
                Button {
                    count += 1
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("带图标的按钮")
                    }
                }

                // 加载状态按钮
                Button {
                    isLoading = true
                    // 模拟异步操作
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("点击加载")
                    }
                }
                .disabled(isLoading)
            }
        }
    }
}

// MARK: - 按钮样式示例
struct ButtonStyleExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 按钮样式示例").font(.title)

            Group {
                Button("默认样式") {}
                    .buttonStyle(.automatic)

                Button("边框样式") {}
                    .buttonStyle(.bordered)

                Button("突出样式") {}
                    .buttonStyle(.borderedProminent)

                Button("普通样式") {}
                    .buttonStyle(.plain)

                Button("自定义颜色") {}
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)

                Button("大按钮") {}
                    .buttonStyle(.bordered)
                    .controlSize(.large)
            }
        }
    }
}

// MARK: - 高级按钮示例
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

struct AdvancedButtonExampleView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 高级按钮示例").font(.title)

            Group {
                Button("自定义样式按钮") {}
                    .buttonStyle(CustomButtonStyle())

                Menu("下拉菜单") {
                    Button("选项1") {}
                    Button("选项2") {}
                    Menu("子菜单") {
                        Button("子选项1") {}
                        Button("子选项2") {}
                    }
                }

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

                if isExpanded {
                    Text("展开的内容")
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - 按钮布局示例
struct ButtonLayoutExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 按钮布局示例").font(.title)

            Group {
                // 水平按钮组
                HStack {
                    Button("按钮1") {}
                    Button("按钮2") {}
                    Button("按钮3") {}
                }

                // 垂直按钮组
                VStack {
                    Button("按钮1") {}
                    Button("按钮2") {}
                    Button("按钮3") {}
                }

                // 网格按钮组
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    Button("按钮1") {}
                    Button("按钮2") {}
                    Button("按钮3") {}
                    Button("按钮4") {}
                }
            }
        }
    }
}

// MARK: - 动画按钮示例
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

struct AnimatedButtonExampleView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 动画按钮示例").font(.title)

            Group {
                Button("弹性动画") {}
                    .modifier(PressEffectModifier())

                Button {
                    withAnimation(.spring()) {
                        isAnimating.toggle()
                    }
                } label: {
                    Text("旋转动画")
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }
            }
        }
    }
}

// MARK: - 防抖按钮示例
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

struct OptimizedButtonExampleView: View {
    @State private var count = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("6. 优化按钮示例").font(.title)

            Group {
                DebouncedButton(action: {
                    count += 1
                }, label: "防抖按钮")

                Text("点击次数: \(count)")
            }
        }
    }
}

// MARK: - 主视图
struct ButtonDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                BasicButtonExampleView()
                ButtonStyleExampleView()
                AdvancedButtonExampleView()
                ButtonLayoutExampleView()
                AnimatedButtonExampleView()
                OptimizedButtonExampleView()
            }
            .padding()
        }
        .navigationTitle("按钮控件 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        ButtonDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为 `ButtonDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是 `XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct ButtonDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ButtonDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 基础按钮示例

   - 基本按钮
   - 带图标的按钮
   - 加载状态按钮

2. 按钮样式示例

   - 默认样式
   - 边框样式
   - 突出样式
   - 自定义颜色和大小

3. 高级按钮示例

   - 自定义样式按钮
   - 下拉菜单按钮
   - 展开/收起动画按钮

4. 按钮布局示例

   - 水平按钮组
   - 垂直按钮组
   - 网格按钮组

5. 动画按钮示例

   - 按压效果
   - 旋转动画

6. 优化按钮示例
   - 防抖按钮

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了输入验证和即时反馈
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
