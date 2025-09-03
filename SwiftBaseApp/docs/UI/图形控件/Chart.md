# SwiftUI Chart 控件完整指南

## 1. 基本介绍

### 1.1 控件概述

Chart 是 SwiftUI 中用于创建各种图表的强大控件，它是 iOS 16 中引入的原生图表框架。它提供了一套声明式的 API，使得创建和自定义各种类型的图表变得简单直观。

### 1.2 使用场景

- 数据可视化展示
- 统计分析报表
- 趋势图表
- 数据比较
- 实时数据监控
- 金融数据展示
- 性能监控图表
- 健康数据追踪

### 1.3 主要特性

- 支持多种图表类型（折线图、柱状图、饼图等）
- 自动数据缩放和适配
- 内置动画效果
- 支持交互操作
- 自定义样式和主题
- 支持多数据系列
- 支持标注和标签
- 支持实时数据更新
- 支持辅助元素（图例、坐标轴、网格线等）

## 2. 基础用法

### 2.1 基本示例

```swift
// 1. 简单柱状图
struct SimpleBarChart: View {
    let data = [
        ("周一", 6019),
        ("周二", 7200),
        ("周三", 8300),
        ("周四", 7400),
        ("周五", 6500)
    ]

    var body: some View {
        Chart {
            ForEach(data, id: \.0) { day, steps in
                BarMark(
                    x: .value("日期", day),
                    y: .value("步数", steps)
                )
            }
        }
    }
}

// 2. 折线图
struct SimpleLineChart: View {
    let data = [
        ("1月", 1000),
        ("2月", 1200),
        ("3月", 1100),
        ("4月", 1400),
        ("5月", 1600)
    ]

    var body: some View {
        Chart {
            ForEach(data, id: \.0) { month, sales in
                LineMark(
                    x: .value("月份", month),
                    y: .value("销售额", sales)
                )
            }
        }
    }
}

// 3. 面积图
struct SimpleAreaChart: View {
    let data = [
        ("周一", 65),
        ("周二", 72),
        ("周三", 83),
        ("周四", 74),
        ("周五", 65)
    ]

    var body: some View {
        Chart {
            ForEach(data, id: \.0) { day, percentage in
                AreaMark(
                    x: .value("日期", day),
                    y: .value("使用率", percentage)
                )
            }
        }
    }
}
```

### 2.2 常用属性

```swift
// 1. 设置图表大小
Chart {
    // 图表内容
}
.frame(height: 300)

// 2. 设置图表样式
Chart {
    // 图表内容
}
.chartStyle(.automatic)

// 3. 设置图例位置
Chart {
    // 图表内容
}
.chartLegend(position: .bottom)

// 4. 设置坐标轴
Chart {
    // 图表内容
}
.chartXAxis {
    AxisMarks(values: .automatic(desiredCount: 5))
}
.chartYAxis {
    AxisMarks(position: .leading)
}

// 5. 设置网格线
Chart {
    // 图表内容
}
.chartXGrid(true)
.chartYGrid(true)
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 1. 柱状图样式
BarMark(x: .value("X", x), y: .value("Y", y))
    .foregroundStyle(.blue)
    .cornerRadius(5)

// 2. 折线图样式
LineMark(x: .value("X", x), y: .value("Y", y))
    .foregroundStyle(.green)
    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))

// 3. 面积图样式
AreaMark(x: .value("X", x), y: .value("Y", y))
    .foregroundStyle(.linearGradient(
        colors: [.blue, .blue.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    ))

// 4. 点图样式
PointMark(x: .value("X", x), y: .value("Y", y))
    .foregroundStyle(.red)
    .symbol(.circle)
    .symbolSize(100)
```

### 3.2 自定义修饰符

```swift
// 1. 自定义数据点标注
BarMark(x: .value("X", x), y: .value("Y", y))
    .annotation {
        Text("\(y)")
            .font(.caption)
            .foregroundColor(.secondary)
    }

// 2. 自定义渐变色
AreaMark(x: .value("X", x), y: .value("Y", y))
    .foregroundStyle(
        .linearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    )

// 3. 自定义交互提示
Chart {
    // 图表内容
}
.chartOverlay { proxy in
    GeometryReader { geometry in
        Rectangle().fill(.clear).contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // 处理拖动手势
                    }
            )
    }
}
```

### 3.3 主题适配

```swift
// 1. 适配深色模式
Chart {
    // 图表内容
}
.foregroundStyle(Color("ChartColor"))  // 使用 Asset 中定义的颜色

// 2. 适配动态字体
Chart {
    // 图表内容
}
.chartLegend {
    Text("图例")
        .font(.body)  // 使用系统动态字体
}
```

## 4. 高级特性

### 4.1 多数据系列

```swift
struct MultiSeriesChart: View {
    let data = [
        (date: "周一", sales: 100, profit: 20),
        (date: "周二", sales: 120, profit: 25),
        (date: "周三", sales: 150, profit: 30)
    ]

    var body: some View {
        Chart {
            ForEach(data, id: \.date) { item in
                LineMark(
                    x: .value("日期", item.date),
                    y: .value("销售额", item.sales)
                )
                .foregroundStyle(.blue)

                LineMark(
                    x: .value("日期", item.date),
                    y: .value("利润", item.profit)
                )
                .foregroundStyle(.green)
            }
        }
    }
}
```

### 4.2 交互功能

```swift
struct InteractiveChart: View {
    @State private var selectedDate: String?

    var body: some View {
        Chart {
            // 图表内容
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = value.location.x
                                if let date = proxy.value(atX: x) as String? {
                                    selectedDate = date
                                }
                            }
                            .onEnded { _ in
                                selectedDate = nil
                            }
                    )
            }
        }
    }
}
```

### 4.3 动画效果

```swift
struct AnimatedChart: View {
    @State private var data: [(String, Double)] = []

    var body: some View {
        Chart {
            ForEach(data, id: \.0) { item in
                BarMark(
                    x: .value("类别", item.0),
                    y: .value("数值", item.1)
                )
            }
        }
        .animation(.spring(), value: data)
        .onAppear {
            // 模拟数据更新
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    data = [
                        ("A", 100),
                        ("B", 200),
                        ("C", 150)
                    ]
                }
            }
        }
    }
}
```

### 4.4 实时更新

```swift
struct RealTimeChart: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        Chart {
            ForEach(viewModel.data, id: \.timestamp) { item in
                LineMark(
                    x: .value("时间", item.timestamp),
                    y: .value("值", item.value)
                )
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateData()
        }
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 数据处理

```swift
// 在视图模型中处理数据
class ChartViewModel: ObservableObject {
    @Published var data: [DataPoint] = []

    func processData(_ rawData: [RawDataPoint]) {
        // 在后台线程处理数据
        DispatchQueue.global().async {
            let processedData = rawData.map { ... }

            DispatchQueue.main.async {
                self.data = processedData
            }
        }
    }
}
```

2. 视图优化

```swift
// 使用 ID 优化重绘
Chart {
    ForEach(data, id: \.id) { item in
        // 图表内容
    }
}
.id(updateCounter)  // 只在需要时更新整个图表
```

3. 内存管理

```swift
// 限制数据点数量
class ChartViewModel: ObservableObject {
    private let maxDataPoints = 100

    func addDataPoint(_ point: DataPoint) {
        data.append(point)
        if data.count > maxDataPoints {
            data.removeFirst(data.count - maxDataPoints)
        }
    }
}
```

### 5.2 常见陷阱

1. 避免频繁更新

```swift
// 不推荐
Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

// 推荐
Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
```

2. 避免过多数据点

```swift
// 不推荐：显示所有数据点
ForEach(allDataPoints) { point in
    PointMark(...)
}

// 推荐：采样或聚合数据
ForEach(sampledDataPoints) { point in
    PointMark(...)
}
```

### 5.3 优化技巧

1. 数据采样

```swift
func sampleData(_ data: [DataPoint], sampleSize: Int) -> [DataPoint] {
    guard data.count > sampleSize else { return data }
    let stride = data.count / sampleSize
    return stride(from: 0, to: data.count, by: stride).map { data[$0] }
}
```

2. 异步加载

```swift
struct LazyChart: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        Chart {
            if let data = viewModel.data {
                ForEach(data) { item in
                    // 图表内容
                }
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
Chart {
    BarMark(...)
        .accessibilityLabel("销售数据")
        .accessibilityValue("\(value)元")
        .accessibilityHint("双击查看详情")
}
```

### 6.2 本地化

```swift
Chart {
    BarMark(
        x: .value("月份", NSLocalizedString("month", comment: "月份")),
        y: .value("销售额", sales)
    )
}
```

### 6.3 动态类型

```swift
Chart {
    // 图表内容
}
.chartLegend {
    Text("图例")
        .font(.body)  // 使用系统动态字体
        .minimumScaleFactor(0.5)
}
```

## 7. 示例代码

### 7.1 基础示例

```swift
struct BasicChartDemo: View {
    let salesData = [
        ("Q1", 1000),
        ("Q2", 1200),
        ("Q3", 1500),
        ("Q4", 1800)
    ]

    var body: some View {
        VStack(spacing: 20) {
            // 柱状图
            Chart {
                ForEach(salesData, id: \.0) { quarter, sales in
                    BarMark(
                        x: .value("季度", quarter),
                        y: .value("销售额", sales)
                    )
                    .foregroundStyle(by: .value("季度", quarter))
                }
            }
            .frame(height: 200)

            // 折线图
            Chart {
                ForEach(salesData, id: \.0) { quarter, sales in
                    LineMark(
                        x: .value("季度", quarter),
                        y: .value("销售额", sales)
                    )
                    .symbol(by: .value("季度", quarter))
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
}
```

### 7.2 进阶示例

```swift
struct AdvancedChartDemo: View {
    @StateObject private var viewModel = SalesViewModel()
    @State private var selectedDataPoint: DataPoint?

    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.monthlySales) { data in
                    AreaMark(
                        x: .value("月份", data.month),
                        y: .value("销售额", data.sales)
                    )
                    .foregroundStyle(.linearGradient(
                        colors: [.blue, .blue.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))

                    LineMark(
                        x: .value("月份", data.month),
                        y: .value("销售额", data.sales)
                    )
                    .symbol {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                    }
                }

                if let selected = selectedDataPoint {
                    RuleMark(
                        x: .value("月份", selected.month)
                    )
                    .foregroundStyle(.gray.opacity(0.3))
                    .annotation(position: .top) {
                        VStack {
                            Text(selected.month)
                                .font(.caption2)
                            Text("¥\(selected.sales)")
                                .font(.caption)
                                .bold()
                        }
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white)
                                .shadow(radius: 2)
                        )
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let x = value.location.x
                                    if let month = proxy.value(atX: x) as String? {
                                        selectedDataPoint = viewModel.monthlySales
                                            .first { $0.month == month }
                                    }
                                }
                                .onEnded { _ in
                                    selectedDataPoint = nil
                                }
                        )
                }
            }
            .frame(height: 300)
            .padding()

            // 图例
            HStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
                Text("月度销售额")
                    .font(.caption)
            }
        }
    }
}

class SalesViewModel: ObservableObject {
    @Published var monthlySales: [DataPoint] = []

    init() {
        loadData()
    }

    private func loadData() {
        // 模拟加载数据
        monthlySales = [
            DataPoint(month: "1月", sales: 1000),
            DataPoint(month: "2月", sales: 1200),
            DataPoint(month: "3月", sales: 1100),
            DataPoint(month: "4月", sales: 1400),
            DataPoint(month: "5月", sales: 1600),
            DataPoint(month: "6月", sales: 1800)
        ]
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
}
```

### 7.3 完整 Demo

请参考 `ChartDemoView.swift` 中的完整示例代码。

## 8. 注意事项

### 8.1 常见问题

1. 数据更新问题

   - 确保数据模型遵循 `Identifiable` 协议
   - 使用稳定的标识符
   - 正确处理数据更新的时机

2. 性能问题

   - 避免过多数据点
   - 使用适当的数据结构
   - 实现数据采样或聚合

3. 布局问题
   - 注意图表的自适应大小
   - 处理好旋转和布局变化
   - 注意标注和标签的位置

### 8.2 兼容性考虑

1. iOS 版本兼容

   - iOS 16+: 基本图表功能
   - iOS 16.4+: 增强的交互功能
   - iOS 17+: 新增图表类型和功能

2. 设备适配
   - iPhone: 标准图表布局
   - iPad: 考虑更大的显示区域
   - Mac: 考虑鼠标和触控板交互

### 8.3 使用建议

1. 数据管理

   - 使用 MVVM 架构管理图表数据
   - 实现适当的数据缓存机制
   - 处理好数据更新的性能问题

2. 用户体验

   - 提供适当的加载状态指示
   - 实现合理的错误处理
   - 添加适当的动画效果

3. 维护性
   - 模块化图表组件
   - 使用清晰的命名约定
   - 添加适当的注释

## 9. 完整运行 Demo

请参考 `ChartDemoView.swift` 中的完整示例代码。

### 9.1 运行说明

1. 确保 Xcode 版本 >= 14.0
2. 确保 iOS 部署目标 >= 16.0
3. 运行项目，导航到 Chart Demo 页面

### 9.2 功能说明

1. 基础功能

   - 柱状图示例
   - 折线图示例
   - 面积图示例
   - 饼图示例

2. 交互功能

   - 数据点选择
   - 缩放和平移
   - 实时数据更新
   - 动画效果

3. 样式演示
   - 不同的图表样式
   - 自定义颜色和主题
   - 标注和标签
   - 图例和坐标轴
