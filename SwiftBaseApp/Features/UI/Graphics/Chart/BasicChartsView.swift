import SwiftUI
import Charts

// MARK: - 基础图表视图
struct BasicChartsView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        // List {
            // 1. 柱状图
            Section("柱状图") {
                VStack(alignment: .leading) {
                    Text("1.1 基本柱状图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(6)) { item in
                            BarMark(
                                x: .value("月份", item.month),
                                y: .value("销售额", item.sales)
                            )
                            .foregroundStyle(by: .value("月份", item.month))
                        }
                    }
                    .frame(height: 200)
                }
                
                VStack(alignment: .leading) {
                    Text("1.2 分组柱状图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(12)) { item in
                            BarMark(
                                x: .value("月份", item.month),
                                y: .value("金额", item.sales)
                            )
                            .foregroundStyle(by: .value("类别", "销售额"))
                            
                            BarMark(
                                x: .value("月份", item.month),
                                y: .value("金额", item.profit)
                            )
                            .foregroundStyle(by: .value("类别", "利润"))
                        }
                    }
                    .frame(height: 200)
                    .chartLegend(position: .bottom)
                }
            }
            
            // 2. 折线图
            Section("折线图") {
                VStack(alignment: .leading) {
                    Text("2.1 基本折线图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(6)) { item in
                            LineMark(
                                x: .value("月份", item.month),
                                y: .value("销售额", item.sales)
                            )
                            .symbol(by: .value("月份", item.month))
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    .frame(height: 200)
                }
                
                VStack(alignment: .leading) {
                    Text("2.2 多系列折线图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(12)) { item in
                            LineMark(
                                x: .value("月份", item.month),
                                y: .value("金额", item.sales)
                            )
                            .foregroundStyle(by: .value("类别", "销售额"))
                            
                            LineMark(
                                x: .value("月份", item.month),
                                y: .value("金额", item.profit)
                            )
                            .foregroundStyle(by: .value("类别", "利润"))
                        }
                    }
                    .frame(height: 200)
                    .chartLegend(position: .bottom)
                }
            }
            
            // 3. 面积图
            Section("面积图") {
                VStack(alignment: .leading) {
                    Text("3.1 基本面积图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(6)) { item in
                            AreaMark(
                                x: .value("月份", item.month),
                                y: .value("销售额", item.sales)
                            )
                            .foregroundStyle(.linearGradient(
                                colors: [.blue, .blue.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        }
                    }
                    .frame(height: 200)
                }
                
                VStack(alignment: .leading) {
                    Text("3.2 堆叠面积图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData.prefix(24)) { item in
                            AreaMark(
                                x: .value("月份", item.month),
                                y: .value("销售额", item.sales)
                            )
                            .foregroundStyle(by: .value("类别", item.category))
                        }
                    }
                    .frame(height: 200)
                    .chartLegend(position: .bottom)
                }
            }
            
            // 4. 点图
            Section("点图") {
                VStack(alignment: .leading) {
                    Text("4.1 散点图")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Chart {
                        ForEach(viewModel.salesData) { item in
                            PointMark(
                                x: .value("销售额", item.sales),
                                y: .value("利润", item.profit)
                            )
                            .foregroundStyle(by: .value("类别", item.category))
                        }
                    }
                    .frame(height: 200)
                    .chartLegend(position: .bottom)
                }
            }
        }
    // }
}
