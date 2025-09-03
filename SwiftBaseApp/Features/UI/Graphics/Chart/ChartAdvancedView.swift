import SwiftUI
import Charts

// MARK: - 高级功能视图
struct ChartAdvancedView: View {
    @ObservedObject var viewModel: ChartViewModel
    @State private var selectedPoint: StockData?
    @State private var dragLocation: CGPoint?
    @State private var scale: CGFloat = 1.0
    @State private var lastValue: Double = 0
    @State private var timer: Timer?
    
    var body: some View {

            interactionSection
            realtimeSection
            combinedSection
        
    }
    
    private var interactionSection: some View {
        Section("交互功能") {
            VStack(alignment: .leading) {
                Text("1.1 数据点选择")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData) { item in
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .interpolationMethod(.catmullRom)
                        
                        if let selected = selectedPoint,
                           selected.id == item.id {
                            PointMark(
                                x: .value("日期", selected.date),
                                y: .value("价格", selected.price)
                            )
                            .foregroundStyle(.red)
                            .annotation {
                                VStack {
                                    Text(selected.date, format: .dateTime.day().month())
                                    Text("¥\(String(format: "%.2f", selected.price))")
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
                }
                .frame(height: 200)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let x = value.location.x
                                        if let date = proxy.value(atX: x, as: Date.self) {
                                            selectedPoint = viewModel.stockData
                                                .first { abs($0.date.timeIntervalSince(date)) < 24 * 60 * 60 }
                                        }
                                    }
                                    .onEnded { _ in
                                        selectedPoint = nil
                                    }
                            )
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("1.2 缩放和平移")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData) { item in
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 200)
                .chartXScale(domain: .automatic(includesZero: false))
                .chartYScale(domain: .automatic(includesZero: false))
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { value in
                            scale = 1.0
                        }
                )
            }
        }
    }
    
    private var realtimeSection: some View {
        Section("实时更新") {
            VStack(alignment: .leading) {
                Text("2.1 实时数据")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData.suffix(10)) { item in
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                        
                        PointMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .foregroundStyle(.blue)
                    }
                    
                    if let last = viewModel.stockData.last {
                        RuleMark(
                            y: .value("最新价", last.price)
                        )
                        .foregroundStyle(.red.opacity(0.3))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .annotation(position: .trailing) {
                            Text("¥\(String(format: "%.2f", last.price))")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: 200)
                .onAppear {
                    // 启动定时器，模拟实时数据更新
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        Task { @MainActor in
                            let lastPrice = viewModel.stockData.last?.price ?? 100
                            let change = Double.random(in: -5...5)
                            let newPrice = max(lastPrice + change, 50)
                            let newData = StockData(
                                date: Date(),
                                price: newPrice,
                                volume: Double.random(in: 1000...5000)
                            )
                            viewModel.stockData.append(newData)
                            if viewModel.stockData.count > 30 {
                                viewModel.stockData.removeFirst()
                            }
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
            }
            
            VStack(alignment: .leading) {
                Text("2.2 动态更新")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData.suffix(10)) { item in
                        BarMark(
                            x: .value("日期", item.date),
                            y: .value("成交量", item.volume)
                        )
                        .foregroundStyle(
                            item.price > (viewModel.stockData.last?.price ?? 0) ? .green : .red
                        )
                    }
                }
                .frame(height: 200)
                .animation(.spring(), value: viewModel.stockData.map { $0.price })
            }
        }
    }
    
    private var combinedSection: some View {
        Section("组合图表") {
            VStack(alignment: .leading) {
                Text("3.1 K线图")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData.suffix(10)) { item in
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                        
                        BarMark(
                            x: .value("日期", item.date),
                            y: .value("成交量", item.volume / 50)
                        )
                        .foregroundStyle(.blue.opacity(0.2))
                    }
                }
                .frame(height: 200)
            }
            
            VStack(alignment: .leading) {
                Text("3.2 技术指标")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Chart {
                    ForEach(viewModel.stockData.suffix(10)) { item in
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("价格", item.price)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("MA5", calculateMA(for: item.date, period: 5))
                        )
                        .foregroundStyle(.red)
                        
                        LineMark(
                            x: .value("日期", item.date),
                            y: .value("MA10", calculateMA(for: item.date, period: 10))
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 200)
                .chartLegend(position: .bottom)
            }
        }
    }
    
    private func calculateMA(for date: Date, period: Int) -> Double {
        guard let index = viewModel.stockData.firstIndex(where: { $0.date == date }) else {
            return 0
        }
        let startIndex = max(0, index - period + 1)
        let values = viewModel.stockData[startIndex...index].map(\.price)
        return values.reduce(0, +) / Double(values.count)
    }
}
