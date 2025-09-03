import SwiftUI
import Charts

// MARK: - 数据模型
struct SalesData: Identifiable, Equatable {
  let id = UUID()
  let month: String
  let sales: Double
  let profit: Double
  let category: String
  
  static func == (lhs: SalesData, rhs: SalesData) -> Bool {
    lhs.id == rhs.id &&
    lhs.month == rhs.month &&
    lhs.sales == rhs.sales &&
    lhs.profit == rhs.profit &&
    lhs.category == rhs.category
  }
}

struct StockData: Identifiable, Equatable {
  let id = UUID()
  let date: Date
  let price: Double
  let volume: Double
  
  static func == (lhs: StockData, rhs: StockData) -> Bool {
    lhs.id == rhs.id &&
    lhs.date == rhs.date &&
    lhs.price == rhs.price &&
    lhs.volume == rhs.volume
  }
}

struct PieData: Identifiable {
  let id = UUID()
  let category: String
  let value: Double
  let color: Color
}

// MARK: - 视图模型
@MainActor
class ChartViewModel: ObservableObject {
  @Published var salesData: [SalesData] = []
  @Published var stockData: [StockData] = []
  @Published var pieData: [PieData] = []
  @Published var selectedDataPoint: SalesData?
  @Published var isLoading = false
  
  private let categories = ["电子产品", "服装", "食品", "家居"]
  private let months = ["1月", "2月", "3月", "4月", "5月", "6月"]
  private let colors: [Color] = [.blue, .green, .orange, .purple]
  
  init() {
    generateSampleData()
  }
  
  private func generateSampleData() {
    // 生成销售数据
    salesData = categories.flatMap { category in
      months.map { month in
        SalesData(
          month: month,
          sales: Double.random(in: 1000...5000),
          profit: Double.random(in: 100...1000),
          category: category
        )
      }
    }
    
    // 生成股票数据
    let calendar = Calendar.current
    let today = Date()
    stockData = (0..<30).map { day in
      let date = calendar.date(byAdding: .day, value: -day, to: today)!
      return StockData(
        date: date,
        price: Double.random(in: 100...200),
        volume: Double.random(in: 1000...5000)
      )
    }.reversed()
    
    // 生成饼图数据
    pieData = categories.enumerated().map { index, category in
      PieData(
        category: category,
        value: Double.random(in: 1000...5000),
        color: colors[index]
      )
    }
  }
  
  func refreshData() {
    isLoading = true
    // 模拟网络请求延迟
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      guard let self = self else { return }
      self.generateSampleData()
      self.isLoading = false
    }
  }
}

// MARK: - 主视图
struct ChartDemoView: View {
  @StateObject private var viewModel = ChartViewModel()
  @State private var selectedTab = 0
  
  var body: some View {
    ScrollView() {
      
      VStack(spacing:20) {
        // 1. 基础图表
        BasicChartsView(viewModel: viewModel)
        
        
        // 2. 样式示例
        ChartStyleView(viewModel: viewModel)
        
        
        // 3. 高级功能
        ChartAdvancedView(viewModel: viewModel)
        
        
        // 4. 性能优化
        ChartPerformanceView(viewModel: viewModel)
        
      }.padding(.horizontal,20)
      
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Chart 示例")
      .refreshable {
        await withCheckedContinuation { continuation in
          viewModel.refreshData()
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            continuation.resume()
          }
        }
      }
  }
}


// MARK: - 预览
#Preview {
  NavigationStack {
    ChartDemoView()
  }
}
