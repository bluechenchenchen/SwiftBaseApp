import SwiftUI

// MARK: - Slider Demo View
struct SliderDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = SliderViewModel()
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本滑块") {
                    VStack(spacing: 20) {
                        Slider(value: $viewModel.basicValue)
                        
                        Text("当前值：\(viewModel.basicValue, format: .number.precision(.fractionLength(2)))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带标签") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.labeledValue,
                            label: {
                                Text("调节")
                            },
                            minimumValueLabel: {
                                Image(systemName: "speaker.fill")
                            },
                            maximumValueLabel: {
                                Image(systemName: "speaker.wave.3.fill")
                            }
                        )
                        
                        Text("当前值：\(viewModel.labeledValue, format: .number.precision(.fractionLength(2)))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带范围") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.rangedValue,
                            in: 0...100
                        )
                        
                        Text("当前值：\(Int(viewModel.rangedValue))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 范围滑块
            ShowcaseSection("范围滑块") {
                ShowcaseItem(title: "价格范围") {
                    VStack(spacing: 20) {
                        let minPrice = viewModel.priceRangeStart * 1000
                        let maxPrice = viewModel.priceRangeEnd * 1000
                        
                        Text("价格范围：¥\(Int(minPrice)) 到 ¥\(Int(maxPrice))")
                            .foregroundStyle(.secondary)
                        
                        Slider(value: $viewModel.priceRangeStart, in: 0...viewModel.priceRangeEnd)
                            .tint(.blue)
                        Slider(value: $viewModel.priceRangeEnd, in: viewModel.priceRangeStart...1)
                            .tint(.blue)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "时间范围") {
                    VStack(spacing: 20) {
                        let minHour = Int(viewModel.timeRangeStart * 24)
                        let maxHour = Int(viewModel.timeRangeEnd * 24)
                        
                        Text("时间范围：\(minHour):00 到 \(maxHour):00")
                            .foregroundStyle(.secondary)
                        
                        Slider(value: $viewModel.timeRangeStart, in: 0...viewModel.timeRangeEnd)
                            .tint(.orange)
                        Slider(value: $viewModel.timeRangeEnd, in: viewModel.timeRangeStart...1)
                            .tint(.orange)
                    }
                    .padding()
                }
            }
            
            // MARK: - 步进滑块
            ShowcaseSection("步进滑块") {
                ShowcaseItem(title: "基本步进") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.basicStepValue,
                            in: 0...100,
                            step: 10
                        )
                        
                        Text("当前值：\(Int(viewModel.basicStepValue))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义步进") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.customStepValue,
                            in: 0...100,
                            step: 5
                        )
                        .tint(.green)
                        
                        HStack {
                            ForEach(0..<21) { index in
                                if index % 2 == 0 {
                                    Text("\(index * 5)")
                                        .font(.caption)
                                        .frame(width: 20)
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带标记") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.markedStepValue,
                            in: 0...4,
                            step: 1
                        )
                        .tint(.blue)
                        
                        HStack {
                            ForEach(["很差", "差", "一般", "好", "很好"], id: \.self) { text in
                                Text(text)
                                    .font(.caption)
                                if text != "很好" {
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 样式美化
            ShowcaseSection("样式美化") {
                ShowcaseItem(title: "自定义颜色") {
                    VStack(spacing: 20) {
                        Slider(value: $viewModel.coloredValue)
                            .tint(viewModel.coloredValue < 0.3 ? .red :
                                    viewModel.coloredValue < 0.7 ? .yellow : .green)
                        
                        Text("当前状态：\(statusText(for: viewModel.coloredValue))")
                            .foregroundStyle(statusColor(for: viewModel.coloredValue))
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        Slider(value: $viewModel.styledValue)
                            .tint(.blue)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("当前值：\(viewModel.styledValue, format: .number.precision(.fractionLength(2)))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "预览效果") {
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemBackground))
                            .frame(height: 100)
                            .overlay {
                                Circle()
                                    .fill(statusColor(for: viewModel.previewValue))
                                    .frame(width: 60, height: 60)
                                    .scaleEffect(viewModel.previewValue)
                            }
                            .shadow(radius: 5)
                        
                        Slider(value: $viewModel.previewValue)
                            .tint(statusColor(for: viewModel.previewValue))
                    }
                    .padding()
                }
            }
            
            // MARK: - 格式化
            ShowcaseSection("格式化") {
                ShowcaseItem(title: "百分比") {
                    VStack(spacing: 20) {
                        Slider(value: $viewModel.percentValue)
                        
                        if let formatted = viewModel.percentFormatter.string(from: NSNumber(value: viewModel.percentValue)) {
                            Text("当前值：\(formatted)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "价格") {
                    VStack(spacing: 20) {
                        Slider(
                            value: $viewModel.priceValue,
                            in: 0...1000,
                            step: 50
                        )
                        
                        if let formatted = viewModel.decimalFormatter.string(from: NSNumber(value: viewModel.priceValue)) {
                            Text("价格：¥\(formatted)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "时间") {
                    VStack(spacing: 20) {
                        let hours = Int(viewModel.timeValue * 24)
                        let minutes = Int((viewModel.timeValue * 24 - Double(hours)) * 60)
                        
                        Slider(value: $viewModel.timeValue)
                        
                        Text("时间：\(hours):\(String(format: "%02d", minutes))")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示高级选项", isOn: $viewModel.showAdvancedOptions.animation())
                        
                        Slider(value: $viewModel.lazyValue)
                        
                        if viewModel.showAdvancedOptions {
                            LazyVStack {
                                ForEach(0..<5) { index in
                                    Slider(
                                        value: .constant(Double(index) / 4.0),
                                        in: 0...1,
                                        step: 0.25
                                    )
                                    .disabled(true)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        Slider(value: $viewModel.cachedValue)
                            .onChange(of: viewModel.cachedValue) { newValue in
                                updateCache(for: newValue)
                            }
                        
                        if let cached = viewModel.valueCache[cacheKey(for: viewModel.cachedValue)] {
                            Text("缓存的值：\(cached)")
                                .foregroundStyle(.secondary)
                        }
                        
                        Button("重置所有值") {
                            withAnimation {
                                viewModel.resetValues()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Slider 示例")
    }
    
    // MARK: - 辅助方法
    private func statusText(for value: Double) -> String {
        if value < 0.3 {
            return "低"
        } else if value < 0.7 {
            return "中"
        } else {
            return "高"
        }
    }
    
    private func statusColor(for value: Double) -> Color {
        if value < 0.3 {
            return .red
        } else if value < 0.7 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private func cacheKey(for value: Double) -> String {
        String(format: "%.2f", value)
    }
    
    private func updateCache(for value: Double) {
        let key = cacheKey(for: value)
        if viewModel.valueCache[key] == nil {
            viewModel.valueCache[key] = viewModel.percentFormatter.string(from: NSNumber(value: value))
        }
    }
}

// MARK: - View Model
class SliderViewModel: ObservableObject {
    // MARK: - 基础滑块
    @Published var basicValue = 0.5
    @Published var labeledValue = 0.5
    @Published var rangedValue = 50.0
    
    // MARK: - 范围滑块
    @Published var priceRangeStart = 0.3
    @Published var priceRangeEnd = 0.7
    @Published var timeRangeStart = 0.3
    @Published var timeRangeEnd = 0.7
    
    // MARK: - 步进滑块
    @Published var basicStepValue = 0.0
    @Published var customStepValue = 0.0
    @Published var markedStepValue = 0.0
    
    // MARK: - 样式定制
    @Published var coloredValue = 0.5
    @Published var styledValue = 0.5
    @Published var previewValue = 0.5
    
    // MARK: - 格式化
    @Published var percentValue = 0.5
    @Published var priceValue = 500.0
    @Published var timeValue = 0.5
    
    // MARK: - 性能优化
    @Published var lazyValue = 0.5
    @Published var cachedValue = 0.5
    @Published var showAdvancedOptions = false
    
    // MARK: - 内部状态
    var valueCache: [String: String] = [:]
    
    // MARK: - 格式化工具
    let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .percent
        return f
    }()
    
    let decimalFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
    
    // MARK: - 方法
    func resetValues() {
        // 基础滑块
        basicValue = 0.5
        labeledValue = 0.5
        rangedValue = 50.0
        
        // 范围滑块
        priceRangeStart = 0.3
        priceRangeEnd = 0.7
        timeRangeStart = 0.3
        timeRangeEnd = 0.7
        
        // 步进滑块
        basicStepValue = 0.0
        customStepValue = 0.0
        markedStepValue = 0.0
        
        // 样式定制
        coloredValue = 0.5
        styledValue = 0.5
        previewValue = 0.5
        
        // 格式化
        percentValue = 0.5
        priceValue = 500.0
        timeValue = 0.5
        
        // 性能优化
        lazyValue = 0.5
        cachedValue = 0.5
        
        // 清理缓存
        valueCache.removeAll()
    }
    
    deinit {
        valueCache.removeAll()
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        SliderDemoView()
    }
}
