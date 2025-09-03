import SwiftUI

// MARK: - Stepper Demo View
struct StepperDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = StepperViewModel()
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本步进器") {
                    VStack(spacing: 20) {
                        Stepper("数值：\(viewModel.basicValue)", value: $viewModel.basicValue)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带步长") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.stepValue,
                            in: 0...100,
                            step: 5
                        ) {
                            Text("数值（步长5）：\(viewModel.stepValue)")
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带图标") {
                    VStack(spacing: 20) {
                        Stepper {
                            Label(
                                "音量：\(viewModel.iconValue)",
                                systemImage: viewModel.iconValue > 50 ? "speaker.wave.3.fill" : "speaker.wave.1.fill"
                            )
                        } onIncrement: {
                            viewModel.iconValue = min(viewModel.iconValue + 10, 100)
                            viewModel.hapticFeedback()
                        } onDecrement: {
                            viewModel.iconValue = max(viewModel.iconValue - 10, 0)
                            viewModel.hapticFeedback()
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 范围步进器
            ShowcaseSection("范围步进器") {
                ShowcaseItem(title: "温度调节") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.temperatureValue,
                            in: 16...30
                        ) {
                            HStack {
                                Image(systemName: "thermometer")
                                Text("\(viewModel.temperatureValue)°C")
                            }
                        }
                        
                        Text(temperatureDescription(for: viewModel.temperatureValue))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "亮度调节") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.brightnessValue,
                            in: 0...100,
                            step: 10
                        ) {
                            HStack {
                                Image(systemName: brightnessIcon(for: viewModel.brightnessValue))
                                Text("\(viewModel.brightnessValue)%")
                            }
                        }
                        
                        Rectangle()
                            .fill(.blue)
                            .frame(height: 20)
                            .opacity(Double(viewModel.brightnessValue) / 100.0)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "音量调节") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.volumeValue,
                            in: 0...100,
                            step: 20
                        ) {
                            HStack {
                                Image(systemName: volumeIcon(for: viewModel.volumeValue))
                                Text("\(viewModel.volumeValue)%")
                            }
                        }
                        
                        ProgressView(value: Double(viewModel.volumeValue), total: 100)
                            .tint(.blue)
                    }
                    .padding()
                }
            }
            
            // MARK: - 自定义操作
            ShowcaseSection("自定义操作") {
                ShowcaseItem(title: "动画效果") {
                    VStack(spacing: 20) {
                        Stepper("缩放效果", value: $viewModel.animatedValue, in: 0...10)
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 100, height: 100)
                            .scaleEffect(Double(viewModel.animatedValue) / 10.0)
                            .animation(.spring(), value: viewModel.animatedValue)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义颜色") {
                    VStack(spacing: 20) {
                        Stepper(value: $viewModel.coloredValue, in: 0...10) {
                            Text("数值：\(viewModel.coloredValue)")
                        }
                        .tint(stepperColor(for: viewModel.coloredValue))
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "触感反馈") {
                    VStack(spacing: 20) {
                        Stepper {
                            HStack {
                                Text("数值：")
                                Text("\(viewModel.feedbackValue)")
                                    .foregroundStyle(.blue)
                            }
                        } onIncrement: {
                            withAnimation(.spring()) {
                                viewModel.feedbackValue = min(viewModel.feedbackValue + 1, 10)
                                viewModel.hapticFeedback()
                            }
                        } onDecrement: {
                            withAnimation(.spring()) {
                                viewModel.feedbackValue = max(viewModel.feedbackValue - 1, 0)
                                viewModel.hapticFeedback()
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 组合控件
            ShowcaseSection("组合控件") {
                ShowcaseItem(title: "步进器和文本框") {
                    VStack(spacing: 20) {
                        HStack {
                            TextField(
                                "输入数值",
                                value: $viewModel.textFieldValue,
                                format: .number
                            )
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                            .keyboardType(.numberPad)
                            
                            Stepper("", value: $viewModel.textFieldValue, in: 0...100)
                                .labelsHidden()
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "步进器和滑块") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.sliderValue,
                            in: 0...100,
                            step: 10
                        ) {
                            Text("数值：\(viewModel.sliderValue)")
                        }
                        
                        Slider(
                            value: .init(
                                get: { Double(viewModel.sliderValue) },
                                set: { viewModel.sliderValue = Int($0) }
                            ),
                            in: 0...100,
                            step: 10
                        )
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "步进器和按钮") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.buttonValue,
                            in: 0...100,
                            step: 25
                        ) {
                            Text("数值：\(viewModel.buttonValue)")
                        }
                        
                        HStack {
                            ForEach([0, 25, 50, 75, 100], id: \.self) { value in
                                Button("\(value)") {
                                    withAnimation {
                                        viewModel.buttonValue = value
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(viewModel.buttonValue == value ? .blue : .gray)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 格式化
            ShowcaseSection("格式化") {
                ShowcaseItem(title: "数字格式化") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.numberValue,
                            in: 0...1000,
                            step: 100
                        ) {
                            if let formatted = viewModel.numberFormatter.string(from: NSNumber(value: viewModel.numberValue)) {
                                Text("数值：\(formatted)")
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "货币格式化") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.currencyValue,
                            in: 0...1000,
                            step: 100
                        ) {
                            if let formatted = viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.currencyValue)) {
                                Text("金额：\(formatted)")
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "时间格式化") {
                    VStack(spacing: 20) {
                        let hours = viewModel.timeValue / 60
                        let minutes = viewModel.timeValue % 60
                        
                        Stepper(
                            value: $viewModel.timeValue,
                            in: 0...1440,
                            step: 30
                        ) {
                            Text("时间：\(hours):\(String(format: "%02d", minutes))")
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示高级选项", isOn: $viewModel.showAdvancedOptions.animation())
                        
                        Stepper(value: $viewModel.lazyValue, in: 0...100) {
                            Text("基础值：\(viewModel.lazyValue)")
                        }
                        
                        if viewModel.showAdvancedOptions {
                            LazyVStack {
                                ForEach(0..<5) { index in
                                    Stepper(
                                        value: .constant(index * 20),
                                        in: 0...100,
                                        step: 20
                                    ) {
                                        Text("预设值 \(index + 1)：\(index * 20)")
                                    }
                                    .disabled(true)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        Stepper(
                            value: $viewModel.cachedValue,
                            in: 0...100,
                            step: 5
                        ) {
                            Text(cachedValue(for: viewModel.cachedValue))
                        }
                        .onChange(of: viewModel.cachedValue) { newValue in
                            updateCache(for: newValue)
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
        .navigationTitle("Stepper 示例")
    }
    
    // MARK: - 辅助方法
    private func temperatureDescription(for value: Int) -> String {
        switch value {
        case 16...20:
            return "较凉爽"
        case 21...24:
            return "舒适"
        case 25...27:
            return "温暖"
        default:
            return "较热"
        }
    }
    
    private func brightnessIcon(for value: Int) -> String {
        switch value {
        case 0...30:
            return "sun.min.fill"
        case 31...70:
            return "sun.max.fill"
        default:
            return "sun.max.circle.fill"
        }
    }
    
    private func volumeIcon(for value: Int) -> String {
        switch value {
        case 0:
            return "speaker.slash.fill"
        case 1...30:
            return "speaker.wave.1.fill"
        case 31...70:
            return "speaker.wave.2.fill"
        default:
            return "speaker.wave.3.fill"
        }
    }
    
    private func stepperColor(for value: Int) -> Color {
        switch value {
        case 0...3:
            return .red
        case 4...7:
            return .yellow
        default:
            return .green
        }
    }
    
    private func cachedValue(for value: Int) -> String {
        if let cached = viewModel.valueCache["\(value)"] {
            return cached
        }
        return "缓存的值：\(value)"
    }
    
    private func updateCache(for value: Int) {
        let key = "\(value)"
        if viewModel.valueCache[key] == nil {
            viewModel.valueCache[key] = "缓存的值：\(value)"
        }
    }
}

// MARK: - View Model
class StepperViewModel: ObservableObject {
    // MARK: - 基础步进器
    @Published var basicValue = 0
    @Published var stepValue = 0
    @Published var iconValue = 50
    
    // MARK: - 范围步进器
    @Published var temperatureValue = 20
    @Published var brightnessValue = 50
    @Published var volumeValue = 0
    
    // MARK: - 自定义操作
    @Published var animatedValue = 5
    @Published var coloredValue = 5
    @Published var feedbackValue = 5
    
    // MARK: - 组合控件
    @Published var textFieldValue = 0
    @Published var sliderValue = 50
    @Published var buttonValue = 0
    
    // MARK: - 格式化
    @Published var numberValue = 0
    @Published var currencyValue = 0
    @Published var timeValue = 0
    
    // MARK: - 性能优化
    @Published var lazyValue = 0
    @Published var cachedValue = 0
    @Published var showAdvancedOptions = false
    
    // MARK: - 内部状态
    var valueCache: [String: String] = [:]
    
    // MARK: - 格式化工具
    let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()
    
    let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = .current
        return f
    }()
    
    // MARK: - 方法
    func resetValues() {
        // 基础步进器
        basicValue = 0
        stepValue = 0
        iconValue = 50
        
        // 范围步进器
        temperatureValue = 20
        brightnessValue = 50
        volumeValue = 0
        
        // 自定义操作
        animatedValue = 5
        coloredValue = 5
        feedbackValue = 5
        
        // 组合控件
        textFieldValue = 0
        sliderValue = 50
        buttonValue = 0
        
        // 格式化
        numberValue = 0
        currencyValue = 0
        timeValue = 0
        
        // 性能优化
        lazyValue = 0
        cachedValue = 0
        
        // 清理缓存
        valueCache.removeAll()
    }
    
    @MainActor
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        StepperDemoView()
    }
}
