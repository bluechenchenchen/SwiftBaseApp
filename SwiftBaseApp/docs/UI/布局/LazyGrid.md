# LazyGrid 网格布局

## 1. 基本介绍

### 控件概述

LazyGrid 是 SwiftUI 中用于创建网格布局的延迟加载容器，包括 `LazyVGrid`（垂直网格）和 `LazyHGrid`（水平网格）。它们只在需要时才创建和加载子视图，非常适合处理大量数据。

### 使用场景

- 照片墙/图片网格
- 应用图标网格
- 商品列表
- 日历视图
- 键盘布局
- 仪表盘布局

### 主要特性

- 延迟加载机制
- 灵活的列/行配置
- 自适应大小
- 固定大小选项
- 动态布局调整
- 滚动视图集成

## 2. 基础用法

### 基本示例

1. LazyVGrid 基本用法：

```swift
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

ScrollView {
    LazyVGrid(columns: columns, spacing: 20) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
```

2. LazyHGrid 基本用法：

```swift
let rows = [
    GridItem(.fixed(44)),
    GridItem(.fixed(44))
]

ScrollView(.horizontal) {
    LazyHGrid(rows: rows, spacing: 20) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
```

### 常用属性

- `GridItem` 配置：
  - `.fixed(CGFloat)`: 固定大小
  - `.flexible(minimum:maximum:)`: 灵活大小
  - `.adaptive(minimum:maximum:)`: 自适应大小
- `spacing`: 项目间距
- `alignment`: 对齐方式
- `pinnedViews`: 固定视图设置

## 3. 样式和自定义

### 内置样式

1. 固定列宽：

```swift
GridItem(.fixed(100))
```

2. 灵活列宽：

```swift
GridItem(.flexible(minimum: 50, maximum: 100))
```

3. 自适应列宽：

```swift
GridItem(.adaptive(minimum: 50))
```

### 自定义修饰符

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
    }
}
```

### 主题适配

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .foregroundColor(.primary)
            .background(Color(.systemBackground))
    }
}
```

## 4. 高级特性

### 组合使用

1. 与 ScrollView 结合：

```swift
ScrollView(.vertical, showsIndicators: false) {
    LazyVGrid(columns: columns) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}
```

2. 嵌套使用：

```swift
ScrollView {
    LazyVGrid(columns: columns) {
        ForEach(sections) { section in
            Section(header: Text(section.title)) {
                ForEach(section.items) { item in
                    ItemView(item: item)
                }
            }
        }
    }
}
```

### 动画效果

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .transition(.scale)
    }
}
.animation(.spring(), value: items)
```

### 状态管理

```swift
@State private var selectedItems: Set<UUID> = []

LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .onTapGesture {
                withAnimation {
                    if selectedItems.contains(item.id) {
                        selectedItems.remove(item.id)
                    } else {
                        selectedItems.insert(item.id)
                    }
                }
            }
    }
}
```

## 5. 性能优化

### 最佳实践

1. 使用适当的 GridItem 类型
2. 避免不必要的重新计算
3. 合理设置缓存大小
4. 优化子视图性能

### 常见陷阱

1. 过度使用固定大小
2. 忽略设备旋转
3. 内存泄漏
4. 性能瓶颈

### 优化技巧

1. 使用 ID 优化
2. 实现视图复用
3. 延迟加载
4. 分页加载

## 6. 辅助功能

### 无障碍支持

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .accessibilityLabel(item.title)
            .accessibilityHint("Tap to select")
    }
}
```

### 本地化

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .environment(\.layoutDirection, .rightToLeft)
    }
}
```

### 动态类型

```swift
LazyVGrid(columns: columns) {
    ForEach(items) { item in
        ItemView(item: item)
            .font(.body)
            .minimumScaleFactor(0.5)
    }
}
```

## 7. 示例代码

### 基础示例

见 LazyGridDemoView.swift 中的 BasicExamples

### 进阶示例

见 LazyGridDemoView.swift 中的 AdvancedExamples

### 完整 Demo

见 LazyGridDemoView.swift

## 8. 注意事项

### 常见问题

1. 布局计算问题
2. 性能问题
3. 内存管理问题
4. 动画问题

### 兼容性考虑

1. iOS 版本兼容
2. 设备适配
3. 方向变化

### 使用建议

1. 选择合适的网格类型
2. 注意性能优化
3. 考虑用户体验
4. 保持代码清晰

## 9. 完整运行 Demo

### 源代码

完整的示例代码在 LazyGridDemoView.swift 文件中。

### 运行说明

1. 打开项目
2. 运行 LazyGridDemoView 预览
3. 查看不同示例效果

### 功能说明

1. 基础网格布局
2. 高级布局示例
3. 性能优化示例
4. 交互动画示例
