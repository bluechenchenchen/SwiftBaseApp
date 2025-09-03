import SwiftUI
import Charts

// MARK: - 样式示例视图
struct ChartStyleView: View {
    @ObservedObject var viewModel: ChartViewModel
    @State private var selectedColorScheme: Int = 0
    @State private var showSymbols = true
    @State private var showLabels = true
    @State private var lineWidth: CGFloat = 2
    @State private var cornerRadius: CGFloat = 4
    @State private var selectedAnimation: Int = 0
    
    private let colorSchemes = [
        [Color.blue, Color.green, Color.orange, Color.purple],
        [Color.red, Color.pink, Color.yellow, Color.mint],
        [Color.indigo, Color.teal, Color.brown, Color.cyan]
    ]
    
    private let animations = [
        Animation.easeInOut(duration: 1),
        Animation.spring(response: 0.5, dampingFraction: 0.5),
        Animation.linear(duration: 1).repeatForever(autoreverses: true)
    ]
    
    var body: some View {
        // List {
            colorStyleSection
            markStyleSection
            animationSection
            themeSection
        // }
    }
    
    private var colorStyleSection: some View {
        Section("颜色样式") {
            VStack(alignment: .leading) {
                Text("1.1 颜色方案")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("颜色方案", selection: $selectedColorScheme) {
                    Text("默认").tag(0)
                    Text("暖色").tag(1)
                    Text("冷色").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 8)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        BarMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .foregroundStyle(by: .value("月份", item.month))
                    }
                }
                .chartForegroundStyleScale(range: colorSchemes[selectedColorScheme])
                .frame(height: 200)
            }
            
            VStack(alignment: .leading) {
                Text("1.2 渐变效果")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        AreaMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .foregroundStyle(.linearGradient(
                            colors: [colorSchemes[selectedColorScheme][0], 
                                    colorSchemes[selectedColorScheme][0].opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    }
                }
                .frame(height: 200)
            }
        }
    }
    
    private var markStyleSection: some View {
        Section("标记样式") {
            VStack(alignment: .leading) {
                Text("2.1 数据点标记")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("显示数据点", isOn: $showSymbols)
                    .padding(.vertical, 8)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        LineMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .lineStyle(StrokeStyle(lineWidth: lineWidth))
                        .symbol(.circle)
                        .symbolSize(showSymbols ? 30 : 0)
                    }
                }
                .frame(height: 200)
            }
            
            VStack(alignment: .leading) {
                Text("2.2 标签显示")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("显示数值标签", isOn: $showLabels)
                    .padding(.vertical, 8)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        BarMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .cornerRadius(cornerRadius)
                        .annotation(position: .top) {
                            if showLabels {
                                Text("\(Int(item.sales))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(height: 200)
            }
        }
    }
    
    private var animationTypeView: some View {
        VStack(alignment: .leading) {
            Text("3.1 动画类型")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("动画类型", selection: $selectedAnimation) {
                Text("渐入渐出").tag(0)
                Text("弹性").tag(1)
                Text("循环").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 8)
            
            Chart {
                ForEach(viewModel.salesData.prefix(6)) { item in
                    LineMark(
                        x: .value("月份", item.month),
                        y: .value("销售额", item.sales)
                    )
                    .foregroundStyle(colorSchemes[selectedColorScheme][0])
                    .lineStyle(StrokeStyle(lineWidth: lineWidth))
                    .symbol(.circle)
                    .symbolSize(showSymbols ? 30 : 0)
                }
            }
            .frame(height: 200)
            .animation(animations[selectedAnimation], value: viewModel.salesData)
        }
    }
    
    private var styleAdjustmentView: some View {
        VStack(alignment: .leading) {
            Text("3.2 样式调整")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack {
                HStack {
                    Text("线宽")
                    Slider(value: $lineWidth, in: 1...5)
                }
                HStack {
                    Text("圆角")
                    Slider(value: $cornerRadius, in: 0...10)
                }
            }
            .padding(.vertical, 8)
            
            Chart {
                ForEach(viewModel.salesData.prefix(6)) { item in
                    BarMark(
                        x: .value("月份", item.month),
                        y: .value("销售额", item.sales)
                    )
                    .cornerRadius(cornerRadius)
                    .foregroundStyle(by: .value("月份", item.month))
                }
            }
            .chartForegroundStyleScale(range: colorSchemes[selectedColorScheme])
            .frame(height: 200)
            .animation(.spring(), value: cornerRadius)
        }
    }
    
    private var animationSection: some View {
        Section("动画效果") {
            animationTypeView
            styleAdjustmentView
        }
    }
    
    private var themeSection: some View {
        Section("主题适配") {
            VStack(alignment: .leading) {
                Text("4.1 深色模式适配")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        BarMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .foregroundStyle(Color.accentColor)
                    }
                }
                .frame(height: 200)
            }
            
            VStack(alignment: .leading) {
                Text("4.2 动态字体")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.salesData.prefix(6)) { item in
                        BarMark(
                            x: .value("月份", item.month),
                            y: .value("销售额", item.sales)
                        )
                        .annotation(position: .top) {
                            Text("\(Int(item.sales))")
                                .font(.body)  // 使用动态字体
                                .foregroundColor(.secondary)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
    }
}
