import SwiftUI
import Charts

// MARK: - 性能优化视图
struct ChartPerformanceView: View {
    @ObservedObject var viewModel: ChartViewModel
    @State private var isLoading = false
    @State private var largeDataSet: [StockData] = []
    @State private var visibleRange = 0.0...1.0
    
    var body: some View {
        // List {
            // 1. 大数据集
            Section("大数据集") {
                VStack(alignment: .leading) {
                    Text("1.1 数据采样")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if isLoading {
                        ProgressView("加载中...")
                            .frame(height: 200)
                    } else {
                        Chart {
                            ForEach(sampleData(largeDataSet)) { item in
                                LineMark(
                                    x: .value("日期", item.date),
                                    y: .value("价格", item.price)
                                )
                            }
                        }
                        .frame(height: 200)
                    }
                }
                .onAppear {
                    loadLargeDataSet()
                }
                
                VStack(alignment: .leading) {
                    Text("1.2 区间选择")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    RangeSlider(range: $visibleRange)
                        .frame(height: 30)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(visibleData(largeDataSet)) { item in
                            LineMark(
                                x: .value("日期", item.date),
                                y: .value("价格", item.price)
                            )
                        }
                    }
                    .frame(height: 200)
                }
            }
            
            // 2. 性能优化
            Section("性能优化") {
                VStack(alignment: .leading) {
                    Text("2.1 延迟加载")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    LazyVStack {
                        ForEach(Array(stride(from: 0, to: largeDataSet.count, by: 100)), id: \.self) { index in
                            let data = Array(largeDataSet[index..<min(index + 100, largeDataSet.count)])
                            Chart {
                                ForEach(data) { item in
                                    LineMark(
                                        x: .value("日期", item.date),
                                        y: .value("价格", item.price)
                                    )
                                }
                            }
                            .frame(height: 100)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("2.2 内存优化")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(largeDataSet.prefix(1000)) { item in
                            LineMark(
                                x: .value("日期", item.date),
                                y: .value("价格", item.price)
                            )
                        }
                    }
                    .frame(height: 200)
                    .id(UUID())  // 强制视图重新创建，释放内存
                }
            }
        // }
    }
    
    private func loadLargeDataSet() {
        isLoading = true
        DispatchQueue.global().async {
            // 生成大量数据
            var data: [StockData] = []
            let calendar = Calendar.current
            let today = Date()
            
            for day in 0..<365 {
                let date = calendar.date(byAdding: .day, value: -day, to: today)!
                let price = Double.random(in: 100...200)
                let volume = Double.random(in: 1000...5000)
                data.append(StockData(date: date, price: price, volume: volume))
            }
            
            DispatchQueue.main.async {
                largeDataSet = data.reversed()
                isLoading = false
            }
        }
    }
    
    private func sampleData(_ data: [StockData]) -> [StockData] {
        guard data.count > 100 else { return data }
        let strideSize = data.count / 100
        return Array(stride(from: 0, to: data.count, by: strideSize)).map { data[$0] }
    }
    
    private func visibleData(_ data: [StockData]) -> [StockData] {
        guard !data.isEmpty else { return [] }
        let startIndex = Int(Double(data.count) * visibleRange.lowerBound)
        let endIndex = Int(Double(data.count) * visibleRange.upperBound)
        return Array(data[startIndex..<endIndex])
    }
}
