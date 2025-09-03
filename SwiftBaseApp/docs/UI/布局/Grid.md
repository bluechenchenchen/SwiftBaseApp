# Grid 布局控件

## 1. 基本介绍

### 控件概述

Grid 是 SwiftUI 在 iOS 16 及以上版本引入的新布局容器，用于创建灵活的网格布局。它提供了比 LazyVGrid 和 LazyHGrid 更简单直接的网格布局方式。

> ⚠️ 版本要求：
>
> - Grid：需要 iOS 16.0+
> - gridCellColumns：需要 iOS 16.0+
> - gridCellRows：需要 iOS 16.0+
> - gridColumnAlignment：需要 iOS 16.0+
> - gridCellUnsizedAxes：需要 iOS 16.0+
>
> 如果需要支持更低版本的 iOS，请使用 LazyVGrid 和 LazyHGrid 作为替代方案。

### 使用场景

- 创建固定行列的网格布局
- 实现等宽等高的单元格布局
- 构建复杂的表格式界面
- 照片墙或图片网格展示

### 主要特性

- 支持固定行列数的网格布局
- 自动计算单元格大小
- 支持水平和垂直对齐
- 可以设置行列间距
- 支持动态内容调整

## 2. 基础用法

### 基本示例

```swift
Grid {
    GridRow {
        Text("1")
        Text("2")
        Text("3")
    }
    GridRow {
        Text("4")
        Text("5")
        Text("6")
    }
}
```

### 常用属性

- `horizontalSpacing`: 设置列间距
- `verticalSpacing`: 设置行间距
- `alignment`: 设置网格内容对齐方式

### Grid 专有修饰符

- `gridCellColumns(_:)`: 设置单元格跨越的列数
- `gridCellUnsizedAxes(_:)`: 指定单元格在哪些轴上不受大小限制
- `gridColumnAlignment(_:)`: 设置列的对齐方式
- `gridCellAnchor(_:)`: 设置单元格的锚点
- `gridCellRows(_:)`: 设置单元格跨越的行数

### Grid 特殊用法

1. 不规则网格布局

```swift
Grid {
    GridRow {
        Color.red.frame(width: 50, height: 50)
        Color.blue.frame(width: 50, height: 50)
            .gridCellColumns(2)  // 跨越2列
    }
    GridRow {
        Color.green.frame(width: 50, height: 50)
            .gridCellRows(2)     // 跨越2行
        Color.yellow.frame(width: 50, height: 50)
        Color.purple.frame(width: 50, height: 50)
    }
    GridRow {
        Color.orange.frame(width: 50, height: 50)
        Color.pink.frame(width: 50, height: 50)
    }
}
```

2. 自适应大小

```swift
Grid {
    GridRow {
        Text("自适应")
            .gridCellUnsizedAxes([.horizontal, .vertical])
        Text("固定大小")
            .frame(width: 100, height: 50)
    }
}
```

3. 对齐控制

```swift
Grid {
    GridRow {
        Text("左对齐")
            .gridColumnAlignment(.leading)
        Text("居中")
            .gridColumnAlignment(.center)
        Text("右对齐")
            .gridColumnAlignment(.trailing)
    }
}
```

### 事件处理

Grid 本身不直接处理事件，但其中的内容视图可以添加手势识别器和交互事件。

## 3. 样式和自定义

### 内置样式

Grid 没有预定义的样式，但可以通过以下方式自定义外观：

- 设置背景色
- 添加边框
- 调整内边距
- 设置圆角

### 自定义修饰符

```swift
Grid {
    GridRow {
        Text("1").padding()
        Text("2").padding()
    }
}
.background(Color.gray.opacity(0.2))
.cornerRadius(10)
```

### 主题适配

- 支持 Dark Mode
- 响应系统颜色方案
- 适配动态字体大小

## 4. 高级特性

### 组合使用

```swift
Grid {
    GridRow {
        Color.red.frame(width: 50, height: 50)
        Color.blue.frame(width: 50, height: 50)
        Color.green.frame(width: 50, height: 50)
    }
    GridRow {
        Image(systemName: "star.fill")
        Image(systemName: "heart.fill")
        Image(systemName: "circle.fill")
    }
}
```

### 动画效果

支持以下动画：

- 单元格大小变化
- 内容更新
- 显示/隐藏行列

### 状态管理

- 支持 @State 和 @Binding
- 可以动态更新网格内容
- 响应数据变化自动更新布局

## 5. 性能优化

### 最佳实践

1. 避免过多嵌套
2. 合理设置单元格大小
3. 使用适当的间距
4. 控制网格内容数量

### 常见陷阱

- 过度使用动态大小可能影响性能
- 嵌套层级过深会降低渲染效率
- 频繁更新可能导致性能问题

### 优化技巧

- 使用固定大小提高性能
- 适当使用不透明类型
- 避免不必要的状态更新

## 6. 辅助功能

### 无障碍支持

- VoiceOver 支持
- 动态字体大小适配
- 支持辅助功能标签

### 本地化

- 支持 RTL 布局
- 文本内容本地化
- 适配不同语言环境

### 动态类型

- 响应系统字体大小设置
- 自动调整布局
- 保持内容可读性

## 7. 示例代码

### 基础示例

```swift
struct BasicGridExample: View {
    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                ForEach(0..<3) { index in
                    Text("\(index)")
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.2))
                }
            }
        }
    }
}
```

### 进阶示例

```swift
struct AdvancedGridExample: View {
    var body: some View {
        Grid {
            GridRow {
                Text("A")
                    .gridCellColumns(2)
                Text("B")
            }
            GridRow {
                Text("C")
                Text("D")
                Text("E")
            }
        }
        .padding()
        .border(Color.gray)
    }
}
```

### 完整 Demo

请参考 GridDemoView.swift 中的完整示例代码。

## 8. 注意事项

### 常见问题

1. 布局不对齐

   - 检查单元格大小设置
   - 确认间距设置
   - 验证对齐方式

2. 性能问题
   - 减少动态内容
   - 控制网格大小
   - 优化更新逻辑

### 兼容性考虑

- 仅支持 iOS 16 及以上版本
- 在较低版本需要使用 LazyVGrid/LazyHGrid
- 考虑设备适配问题

### 使用建议

1. 合理规划网格结构
2. 注意性能优化
3. 保持代码可维护性
4. 考虑响应式设计

## 9. 完整运行 Demo

### 源代码

完整的示例代码请参考项目中的 GridDemoView.swift 文件。

### 运行说明

1. 打开项目
2. 找到 GridDemoView.swift
3. 运行模拟器或真机
4. 通过主页面导航访问 Demo

### 功能说明

Demo 包含以下功能演示：

1. 基础网格布局
2. 自定义单元格大小
3. 动态内容更新
4. 交互事件处理
5. 样式定制
6. 动画效果
