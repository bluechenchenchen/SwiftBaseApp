# @State 和基本状态管理

## 基本介绍

### 概念解释

`@State` 是 SwiftUI 中最基本的状态管理属性包装器，用于在视图内部管理简单的状态数据。当 `@State` 包装的属性发生变化时，SwiftUI 会自动重新渲染相关的视图部分。

### 使用场景

- 视图内部的简单状态管理
- 用户交互状态（如按钮点击、文本输入）
- 临时数据状态
- 动画状态
- 表单数据

### 主要特性

- **自动更新**: 状态变化时自动触发视图更新
- **值类型支持**: 主要用于值类型（String、Int、Bool 等）
- **视图生命周期**: 状态与视图生命周期绑定
- **线程安全**: 只能在主线程上修改
- **性能优化**: SwiftUI 智能地只更新变化的部分

## 基础用法

### 基本示例

```swift
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("计数: \(count)")
                .font(.title)

            Button("增加") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

### 常用属性和方法

#### 基本类型状态

```swift
// 字符串状态
@State private var name = ""

// 数值状态
@State private var age = 0
@State private var price = 0.0

// 布尔状态
@State private var isOn = false
@State private var isLoading = false

// 数组状态
@State private var items: [String] = []

// 可选状态
@State private var selectedItem: String?
```

#### 状态更新

```swift
// 直接赋值
@State private var count = 0

Button("重置") {
    count = 0  // 直接修改状态
}

// 条件更新
Button("切换") {
    isOn.toggle()  // 布尔值切换
}

// 数组操作
Button("添加项目") {
    items.append("新项目")  // 数组修改
}
```

### 使用注意事项

1. **只能在主线程修改**: `@State` 属性只能在主线程上修改
2. **值类型优先**: 优先使用值类型，避免引用类型
3. **避免复杂逻辑**: 不要在状态更新中包含复杂计算
4. **生命周期管理**: 状态与视图生命周期绑定，视图销毁时状态也会重置

## 高级特性

### 组合使用

`@State` 可以与其他属性包装器组合使用：

```swift
struct CombinedStateView: View {
    @State private var localCount = 0
    @StateObject private var viewModel = CounterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("本地计数: \(localCount)")
            Text("ViewModel计数: \(viewModel.count)")

            HStack {
                Button("本地+1") {
                    localCount += 1
                }

                Button("ViewModel+1") {
                    viewModel.increment()
                }
            }

            Button("关闭") {
                dismiss()
            }
        }
        .padding()
    }
}
```

### 动画效果

结合动画创建流畅的用户体验：

```swift
struct AnimatedStateView: View {
    @State private var isExpanded = false
    @State private var rotation: Double = 0

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .frame(width: isExpanded ? 200 : 100, height: 100)
                .rotationEffect(.degrees(rotation))
                .animation(.easeInOut(duration: 0.5), value: isExpanded)
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                .onTapGesture {
                    isExpanded.toggle()
                    rotation += 360
                }

            Text(isExpanded ? "已展开" : "点击展开")
                .foregroundColor(.blue)
        }
        .padding()
    }
}
```

## 性能优化

### 最佳实践

1. **避免不必要的状态**: 只将真正需要触发视图更新的数据标记为 `@State`
2. **使用计算属性**: 对于派生数据，使用计算属性而不是状态
3. **批量更新**: 将多个相关更新放在一起，减少重绘次数
4. **条件渲染**: 使用条件渲染避免不必要的视图创建

```swift
struct OptimizedStateView: View {
    @State private var isLoading = false
    @State private var data: [String] = []

    // 使用计算属性而不是状态
    private var isEmpty: Bool {
        data.isEmpty
    }

    private var itemCount: Int {
        data.count
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("加载中...")
            } else if isEmpty {
                Text("暂无数据")
                    .foregroundColor(.secondary)
            } else {
                List(data, id: \.self) { item in
                    Text(item)
                }
            }

            HStack {
                Button("加载数据") {
                    loadData()
                }
                .disabled(isLoading)

                Button("清空") {
                    // 批量更新
                    withAnimation {
                        data.removeAll()
                    }
                }
                .disabled(isLoading || isEmpty)
            }
        }
        .padding()
    }

    private func loadData() {
        isLoading = true

        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            data = ["项目1", "项目2", "项目3", "项目4", "项目5"]
            isLoading = false
        }
    }
}
```

### 常见陷阱

1. **循环引用**: 避免在状态更新中创建循环引用
2. **过度使用**: 不要将所有变量都标记为 `@State`
3. **异步更新**: 确保在主线程上更新状态
4. **状态泄漏**: 注意状态的生命周期管理

## 注意事项

### 常见问题

1. **状态更新不生效**

   - 确保在主线程上更新状态
   - 检查状态变量是否正确标记为 `@State`
   - 验证更新逻辑是否正确

2. **性能问题**

   - 避免在状态更新中包含复杂计算
   - 使用计算属性替代不必要的状态
   - 合理使用条件渲染

3. **内存泄漏**
   - 避免在状态中持有强引用
   - 注意闭包中的循环引用
   - 及时清理不需要的资源

### 兼容性考虑

1. **iOS 版本**: `@State` 从 iOS 13 开始支持
2. **SwiftUI 版本**: 确保使用兼容的 SwiftUI 版本
3. **平台差异**: 在不同平台上的行为可能略有不同

### 使用建议

1. **简单状态优先**: 对于简单的视图内状态，优先使用 `@State`
2. **状态提升**: 当需要在多个视图间共享状态时，考虑状态提升
3. **性能监控**: 监控状态更新对性能的影响
4. **测试覆盖**: 为状态逻辑编写充分的测试
