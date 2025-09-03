import SwiftUI
import Combine

// MARK: - 主演示视图

struct PublishedDemoView: View {
    var body: some View {
        ShowcaseList {
            ShowcaseSection("基础发布机制") {
              ShowcaseItem(title:"基本属性发布") {
                    PublishedBasicExample()
                }
                
              ShowcaseItem(title:"自动视图更新") {
                    PublishedAutoUpdateExample()
                }
                
              ShowcaseItem(title:"发布者访问") {
                    PublishedPublisherAccessExample()
                }
            }
            
            ShowcaseSection("自定义发布行为") {
              ShowcaseItem(title:"条件发布") {
                    PublishedConditionalExample()
                }
                
          ShowcaseItem(title:"自定义设置器") {
                    PublishedCustomSetterExample()
                }
                
          ShowcaseItem(title:"转换发布") {
                    PublishedTransformExample()
                }
            }
            
            ShowcaseSection("组合发布者") {
              ShowcaseItem(title:"多属性组合") {
                    PublishedCombineExample()
                }
                
              ShowcaseItem(title:"数据流处理") {
                    PublishedDataFlowExample()
                }
                
              ShowcaseItem(title:"防抖处理") {
                    PublishedDebounceExample()
                }
            }
            
            ShowcaseSection("性能优化") {
              ShowcaseItem(title:"批量更新") {
                    PublishedBatchUpdateExample()
                }
                
              ShowcaseItem(title:"私有设置器") {
                    PublishedPrivateSetterExample()
                }
                
              ShowcaseItem(title:"条件更新") {
                    PublishedConditionalUpdateExample()
                }
            }
            
            ShowcaseSection("实际应用案例") {
              ShowcaseItem(title:"用户管理") {
                    PublishedUserManagerExample()
                }
                
              ShowcaseItem(title:"购物车系统") {
                    PublishedShoppingCartExample()
                }
                
              ShowcaseItem(title:"表单验证") {
                    PublishedFormValidationExample()
                }
            }
            
            ShowcaseSection("测试和调试") {
              ShowcaseItem(title:"发布监听") {
                    PublishedMonitoringExample()
                }
                
              ShowcaseItem(title:"发布历史") {
                    PublishedHistoryExample()
                }
                
              ShowcaseItem(title:"性能分析") {
                    PublishedPerformanceExample()
                }
            }
        }
        .navigationTitle("@Published 演示")
    }
}

// MARK: - 数据模型

struct PublishedUser: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var email: String
    var isActive: Bool
    
    init(name: String, email: String, isActive: Bool = true) {
        self.name = name
        self.email = email
        self.isActive = isActive
    }
}

struct PublishedProduct: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var price: Double
    var isInStock: Bool
    
    init(name: String, price: Double, isInStock: Bool = true) {
        self.name = name
        self.price = price
        self.isInStock = isInStock
    }
}

struct PublishedCartItem: Identifiable, Equatable {
    let id = UUID()
    var product: PublishedProduct
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
}

// MARK: - 基础发布机制示例

// 1. 基本属性发布
@MainActor
class PublishedBasicViewModel: ObservableObject {
    @Published var counter = 0
    @Published var message = "Hello, @Published!"
    @Published var isEnabled = true
    
    func increment() {
        counter += 1
    }
    
    func updateMessage() {
        message = "Updated at \(Date().formatted(.dateTime.hour().minute().second()))"
    }
    
    func toggle() {
        isEnabled.toggle()
    }
}

struct PublishedBasicExample: View {
    @StateObject private var viewModel = PublishedBasicViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("基本 @Published 属性发布")
                .font(.headline)
            
            VStack(spacing: 8) {
                Text("计数器: \(viewModel.counter)")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(viewModel.message)
                    .font(.body)
                    .foregroundColor(viewModel.isEnabled ? .primary : .secondary)
                
                Text("状态: \(viewModel.isEnabled ? "启用" : "禁用")")
                    .font(.caption)
                    .foregroundColor(viewModel.isEnabled ? .green : .red)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            VStack(spacing: 8) {
                Button("增加计数") {
                    viewModel.increment()
                }
                .buttonStyle(.borderedProminent)
                
                Button("更新消息") {
                    viewModel.updateMessage()
                }
                .buttonStyle(.bordered)
                
                Button("切换状态") {
                    viewModel.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 2. 自动视图更新
@MainActor
class PublishedAutoUpdateViewModel: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var status = "准备开始"
    @Published var isRunning = false
    
    private var timer: Timer?
    
    func startProgress() {
        guard !isRunning else { return }
        
        isRunning = true
        status = "进行中..."
        progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                self.progress += 0.02
                
                if self.progress >= 1.0 {
                    self.completeProgress()
                }
            }
        }
    }
    
    private func completeProgress() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        status = "已完成"
        progress = 1.0
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        status = "准备开始"
        progress = 0.0
    }
}

struct PublishedAutoUpdateExample: View {
    @StateObject private var viewModel = PublishedAutoUpdateViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("自动视图更新")
                .font(.headline)
            
            VStack(spacing: 12) {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.title2)
                    .bold()
                
                Text(viewModel.status)
                    .font(.body)
                    .foregroundColor(viewModel.isRunning ? .orange : .green)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            HStack(spacing: 16) {
                Button("开始") {
                    viewModel.startProgress()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isRunning)
                
                Button("重置") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isRunning)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 3. 发布者访问
@MainActor
class PublishedPublisherAccessViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var filteredText = ""
    @Published var characterCount = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 访问发布者，进行数据流处理
        $inputText
            .map { $0.filter { $0.isLetter } }
            .assign(to: &$filteredText)
        
        $inputText
            .map { $0.count }
            .assign(to: &$characterCount)
    }
}

struct PublishedPublisherAccessExample: View {
    @StateObject private var viewModel = PublishedPublisherAccessViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("发布者访问和数据流")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("输入文本", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("原始文本: \(viewModel.inputText)")
                        .font(.caption)
                    
                    Text("过滤后: \(viewModel.filteredText)")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("字符数: \(viewModel.characterCount)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 自定义发布行为示例

// 4. 条件发布
@MainActor
class PublishedConditionalViewModel: ObservableObject {
    @Published var validatedEmail = ""
    @Published var isEmailValid = false
    
    private var _email = "" {
        didSet {
            let isValid = _email.contains("@") && _email.contains(".")
            
            // 只有在有效时才发布到 validatedEmail
            if isValid {
                validatedEmail = _email
            }
            
            isEmailValid = isValid
        }
    }
    
    var email: String {
        get { _email }
        set { _email = newValue }
    }
}

struct PublishedConditionalExample: View {
    @StateObject private var viewModel = PublishedConditionalViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("条件发布")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("输入邮箱", text: Binding(
                    get: { viewModel.email },
                    set: { viewModel.email = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("验证状态:")
                        Text(viewModel.isEmailValid ? "有效" : "无效")
                            .foregroundColor(viewModel.isEmailValid ? .green : .red)
                    }
                    .font(.caption)
                    
                    Text("已验证邮箱: \(viewModel.validatedEmail)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 5. 自定义设置器
@MainActor
class PublishedCustomSetterViewModel: ObservableObject {
    private var _temperature: Double = 20.0
    
    var temperature: Double {
        get { _temperature }
        set {
            // 限制温度范围
            let clampedValue = max(-50, min(50, newValue))
            if clampedValue != _temperature {
                objectWillChange.send()
                _temperature = clampedValue
            }
        }
    }
    
    @Published var temperatureDescription = "适中"
    
    init() {
        updateDescription()
    }
    
    private func updateDescription() {
        Task { @MainActor in
            temperatureDescription = switch temperature {
            case ..<0: "严寒"
            case 0..<10: "寒冷"
            case 10..<20: "凉爽"
            case 20..<30: "温暖"
            case 30...: "炎热"
            default: "适中"
            }
        }
    }
    
    func adjustTemperature(by delta: Double) {
        temperature += delta
        updateDescription()
    }
}

struct PublishedCustomSetterExample: View {
    @StateObject private var viewModel = PublishedCustomSetterViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("自定义设置器")
                .font(.headline)
            
            VStack(spacing: 12) {
                Text("\(String(format: "%.1f", viewModel.temperature))°C")
                    .font(.title2)
                    .bold()
                
                Text(viewModel.temperatureDescription)
                    .font(.body)
                    .foregroundColor(.blue)
                
                Slider(value: Binding(
                    get: { viewModel.temperature },
                    set: { 
                        viewModel.temperature = $0
                        viewModel.adjustTemperature(by: 0) // 触发描述更新
                    }
                ), in: -50...50, step: 1)
                
                HStack(spacing: 16) {
                    Button("-10°") {
                        viewModel.adjustTemperature(by: -10)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("-1°") {
                        viewModel.adjustTemperature(by: -1)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("+1°") {
                        viewModel.adjustTemperature(by: 1)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("+10°") {
                        viewModel.adjustTemperature(by: 10)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 6. 转换发布
@MainActor
class PublishedTransformViewModel: ObservableObject {
    @Published var rawValue: Double = 0
    @Published var formattedValue = ""
    @Published var category = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 转换数值格式
        $rawValue
            .map { String(format: "%.2f", $0) }
            .assign(to: &$formattedValue)
        
        // 转换数值分类
        $rawValue
            .map { value in
                switch value {
                case 0..<25: return "低"
                case 25..<50: return "中低"
                case 50..<75: return "中高"
                case 75...: return "高"
                default: return "未知"
                }
            }
            .assign(to: &$category)
    }
}

struct PublishedTransformExample: View {
    @StateObject private var viewModel = PublishedTransformViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("转换发布")
                .font(.headline)
            
            VStack(spacing: 12) {
                Text("原始值: \(String(format: "%.0f", viewModel.rawValue))")
                    .font(.body)
                
                Text("格式化值: \(viewModel.formattedValue)")
                    .font(.body)
                    .foregroundColor(.blue)
                
                Text("分类: \(viewModel.category)")
                    .font(.body)
                    .foregroundColor(.green)
                
                Slider(value: $viewModel.rawValue, in: 0...100, step: 1)
                
                HStack(spacing: 8) {
                    Button("0") { viewModel.rawValue = 0 }
                    Button("25") { viewModel.rawValue = 25 }
                    Button("50") { viewModel.rawValue = 50 }
                    Button("75") { viewModel.rawValue = 75 }
                    Button("100") { viewModel.rawValue = 100 }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 组合发布者示例

// 7. 多属性组合
@MainActor
class PublishedCombineViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var fullName = ""
    @Published var initials = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 组合姓名
        Publishers.CombineLatest($firstName, $lastName)
            .map { first, last in
                "\(first) \(last)".trimmingCharacters(in: .whitespaces)
            }
            .assign(to: &$fullName)
        
        // 生成缩写
        Publishers.CombineLatest($firstName, $lastName)
            .map { first, last in
                let firstInitial = first.prefix(1).uppercased()
                let lastInitial = last.prefix(1).uppercased()
                return "\(firstInitial)\(lastInitial)"
            }
            .assign(to: &$initials)
    }
}

struct PublishedCombineExample: View {
    @StateObject private var viewModel = PublishedCombineViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("多属性组合")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("名字", text: $viewModel.firstName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("姓氏", text: $viewModel.lastName)
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("全名: \(viewModel.fullName)")
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Text("缩写: \(viewModel.initials)")
                        .font(.body)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 8. 数据流处理
@MainActor
class PublishedDataFlowViewModel: ObservableObject {
    @Published var numbers: [Int] = []
    @Published var sum = 0
    @Published var average: Double = 0
    @Published var maximum: Int?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 计算总和
        $numbers
            .map { $0.reduce(0, +) }
            .assign(to: &$sum)
        
        // 计算平均值
        $numbers
            .map { numbers in
                guard !numbers.isEmpty else { return 0 }
                return Double(numbers.reduce(0, +)) / Double(numbers.count)
            }
            .assign(to: &$average)
        
        // 计算最大值
        $numbers
            .map { $0.max() }
            .assign(to: &$maximum)
    }
    
    func addNumber(_ number: Int) {
        numbers.append(number)
    }
    
    func addRandomNumber() {
        addNumber(Int.random(in: 1...100))
    }
    
    func clear() {
        numbers.removeAll()
    }
}

struct PublishedDataFlowExample: View {
    @StateObject private var viewModel = PublishedDataFlowViewModel()
    @State private var inputNumber = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("数据流处理")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("输入数字", text: $inputNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Button("添加") {
                        if let number = Int(inputNumber) {
                            viewModel.addNumber(number)
                            inputNumber = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.numbers, id: \.self) { number in
                            Text("\(number)")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("总和: \(viewModel.sum)")
                    Text("平均值: \(String(format: "%.1f", viewModel.average))")
                    Text("最大值: \(viewModel.maximum.map(String.init) ?? "无")")
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                HStack(spacing: 8) {
                    Button("随机数") {
                        viewModel.addRandomNumber()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("清空") {
                        viewModel.clear()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 9. 防抖处理
@MainActor
class PublishedDebounceViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var debouncedText = ""
    @Published var searchResults: [String] = []
    @Published var isSearching = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 防抖搜索
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedText = text
                self?.performSearch(text)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        // 模拟搜索延迟
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
            
            let mockResults = [
                "Swift", "SwiftUI", "Combine", "Published",
                "iOS", "Xcode", "Apple", "iPhone", "iPad"
            ].filter { $0.localizedCaseInsensitiveContains(query) }
            
            searchResults = mockResults
            isSearching = false
        }
    }
}

struct PublishedDebounceExample: View {
    @StateObject private var viewModel = PublishedDebounceViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("防抖处理")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("搜索...", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text("实时输入: \(viewModel.searchText)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("防抖后: \(viewModel.debouncedText)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                if viewModel.isSearching {
                    HStack {
                        ProgressView()
                            .controlSize(.small)
                        Text("搜索中...")
                            .font(.caption)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("搜索结果:")
                            .font(.caption)
                            .bold()
                        
                        ForEach(viewModel.searchResults, id: \.self) { result in
                            Text("• \(result)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        if viewModel.searchResults.isEmpty && !viewModel.debouncedText.isEmpty {
                            Text("无结果")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 性能优化示例

// 10. 批量更新
@MainActor
class PublishedBatchUpdateViewModel: ObservableObject {
    @Published var items: [String] = []
    @Published var updateCount = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 监听更新次数
        $items
            .sink { [weak self] _ in
                self?.updateCount += 1
            }
            .store(in: &cancellables)
    }
    
    func addItemsIndividually() {
        // 错误方式：逐个添加会触发多次更新
        for i in 1...5 {
            items.append("单个项目 \(i)")
        }
    }
    
    func addItemsBatch() {
        // 正确方式：批量添加只触发一次更新
        let newItems = (1...5).map { "批量项目 \($0)" }
        items.append(contentsOf: newItems)
    }
    
    func clear() {
        items.removeAll()
        updateCount = 0
    }
}

struct PublishedBatchUpdateExample: View {
    @StateObject private var viewModel = PublishedBatchUpdateViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("批量更新优化")
                .font(.headline)
            
            VStack(spacing: 12) {
                Text("更新次数: \(viewModel.updateCount)")
                    .font(.body)
                    .foregroundColor(.red)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.items, id: \.self) { item in
                            Text(item)
                                .font(.caption)
                        }
                    }
                }
                .frame(height: 100)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                VStack(spacing: 8) {
                    Button("逐个添加 (5次更新)") {
                        viewModel.addItemsIndividually()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("批量添加 (1次更新)") {
                        viewModel.addItemsBatch()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("清空") {
                        viewModel.clear()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 11. 私有设置器
@MainActor
class PublishedPrivateSetterViewModel: ObservableObject {
    @Published private(set) var computedValue: Double = 0
    @Published private(set) var status = "待计算"
    @Published private(set) var history: [Double] = []
    
    @Published var inputA: Double = 0 {
        didSet { updateComputation() }
    }
    
    @Published var inputB: Double = 0 {
        didSet { updateComputation() }
    }
    
    private func updateComputation() {
        let newValue = sqrt(inputA * inputA + inputB * inputB)
        
        if newValue != computedValue {
            computedValue = newValue
            history.append(newValue)
            status = "已计算"
        }
    }
    
    func reset() {
        inputA = 0
        inputB = 0
        computedValue = 0
        status = "待计算"
        history.removeAll()
    }
}

struct PublishedPrivateSetterExample: View {
    @StateObject private var viewModel = PublishedPrivateSetterViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("私有设置器")
                .font(.headline)
            
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    HStack {
                        Text("A:")
                        Slider(value: $viewModel.inputA, in: 0...10, step: 0.1)
                        Text("\(String(format: "%.1f", viewModel.inputA))")
                            .frame(width: 30)
                    }
                    
                    HStack {
                        Text("B:")
                        Slider(value: $viewModel.inputB, in: 0...10, step: 0.1)
                        Text("\(String(format: "%.1f", viewModel.inputB))")
                            .frame(width: 30)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("计算结果: \(String(format: "%.2f", viewModel.computedValue))")
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Text("状态: \(viewModel.status)")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("历史记录: \(viewModel.history.count) 条")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                Button("重置") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 12. 条件更新
@MainActor
class PublishedConditionalUpdateViewModel: ObservableObject {
    @Published var filteredItems: [String] = []
    @Published var lastUpdateTime = Date()
    
    private var rawItems: [String] = [] {
        didSet {
            updateFilteredItems()
        }
    }
    
    private var currentFilter: String = "" {
        didSet {
            updateFilteredItems()
        }
    }
    
    var filter: String {
        get { currentFilter }
        set { currentFilter = newValue }
    }
    
    private func updateFilteredItems() {
        let filtered = currentFilter.isEmpty
            ? rawItems
            : rawItems.filter { $0.localizedCaseInsensitiveContains(currentFilter) }
        
        // 只有在结果不同时才更新
        if filtered != filteredItems {
            filteredItems = filtered
            lastUpdateTime = Date()
        }
    }
    
    func addItem(_ item: String) {
        rawItems.append(item)
    }
    
    func addRandomItem() {
        let items = ["苹果", "香蕉", "橙子", "葡萄", "西瓜", "草莓", "蓝莓", "樱桃"]
        addItem(items.randomElement() ?? "水果")
    }
    
    func clear() {
        rawItems.removeAll()
    }
}

struct PublishedConditionalUpdateExample: View {
    @StateObject private var viewModel = PublishedConditionalUpdateViewModel()
    @State private var newItem = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("条件更新")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("过滤条件", text: Binding(
                    get: { viewModel.filter },
                    set: { viewModel.filter = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                
                HStack {
                    TextField("新项目", text: $newItem)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("添加") {
                        if !newItem.isEmpty {
                            viewModel.addItem(newItem)
                            newItem = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("最后更新: \(viewModel.lastUpdateTime.formatted(.dateTime.hour().minute().second()))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("过滤结果 (\(viewModel.filteredItems.count)):")
                        .font(.caption)
                        .bold()
                    
                    ForEach(viewModel.filteredItems, id: \.self) { item in
                        Text("• \(item)")
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                HStack(spacing: 8) {
                    Button("随机添加") {
                        viewModel.addRandomItem()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("清空") {
                        viewModel.clear()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 实际应用案例

// 13. 用户管理
@MainActor
class PublishedUserManagerViewModel: ObservableObject {
    @Published var users: [PublishedUser] = []
    @Published var currentUser: PublishedUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var filteredUsers: [PublishedUser] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 搜索过滤
        Publishers.CombineLatest($users, $searchText)
            .map { users, searchText in
                guard !searchText.isEmpty else { return users }
                return users.filter { user in
                    user.name.localizedCaseInsensitiveContains(searchText) ||
                    user.email.localizedCaseInsensitiveContains(searchText)
                }
            }
            .assign(to: &$filteredUsers)
        
        loadSampleUsers()
    }
    
    private func loadSampleUsers() {
        users = [
            PublishedUser(name: "张三", email: "zhangsan@example.com"),
            PublishedUser(name: "李四", email: "lisi@example.com"),
            PublishedUser(name: "王五", email: "wangwu@example.com", isActive: false),
            PublishedUser(name: "赵六", email: "zhaoliu@example.com")
        ]
    }
    
    func login(user: PublishedUser) {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒
            
            if user.isActive {
                currentUser = user
                isLoading = false
            } else {
                errorMessage = "用户账户已禁用"
                isLoading = false
            }
        }
    }
    
    func logout() {
        currentUser = nil
        errorMessage = nil
    }
    
    func toggleUserStatus(_ user: PublishedUser) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index].isActive.toggle()
        }
    }
}

struct PublishedUserManagerExample: View {
    @StateObject private var viewModel = PublishedUserManagerViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("用户管理系统")
                .font(.headline)
            
            if let currentUser = viewModel.currentUser {
                VStack(spacing: 8) {
                    Text("当前用户: \(currentUser.name)")
                        .font(.body)
                        .foregroundColor(.green)
                    
                    Button("登出") {
                        viewModel.logout()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            } else {
                VStack(spacing: 12) {
                    TextField("搜索用户", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                    
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .controlSize(.small)
                            Text("登录中...")
                        }
                    } else {
                        LazyVStack(spacing: 4) {
                            ForEach(viewModel.filteredUsers) { user in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(user.name)
                                            .font(.caption)
                                            .bold()
                                        Text(user.email)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(user.isActive ? "活跃" : "禁用")
                                        .font(.caption)
                                        .foregroundColor(user.isActive ? .green : .red)
                                    
                                    Button("登录") {
                                        viewModel.login(user: user)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .disabled(!user.isActive)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                        .frame(height: 120)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 14. 购物车系统
@MainActor
class PublishedShoppingCartViewModel: ObservableObject {
    @Published var items: [PublishedCartItem] = []
    @Published var total: Double = 0
    @Published var itemCount: Int = 0
    @Published var isCheckingOut = false
    @Published var checkoutMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 自动计算总价
        $items
            .map { items in
                items.reduce(0) { $0 + $1.totalPrice }
            }
            .assign(to: &$total)
        
        // 自动计算商品数量
        $items
            .map { items in
                items.reduce(0) { $0 + $1.quantity }
            }
            .assign(to: &$itemCount)
    }
    
    func addProduct(_ product: PublishedProduct) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(PublishedCartItem(product: product, quantity: 1))
        }
    }
    
    func removeProduct(_ product: PublishedProduct) {
        items.removeAll { $0.product.id == product.id }
    }
    
    func updateQuantity(for product: PublishedProduct, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func checkout() {
        guard !items.isEmpty else { return }
        
        isCheckingOut = true
        checkoutMessage = ""
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2秒
            
            checkoutMessage = "订单已提交，总金额：¥\(String(format: "%.2f", total))"
            items.removeAll()
            isCheckingOut = false
        }
    }
    
    private let sampleProducts = [
        PublishedProduct(name: "iPhone 15", price: 5999),
        PublishedProduct(name: "iPad Air", price: 3799),
        PublishedProduct(name: "MacBook Pro", price: 12999),
        PublishedProduct(name: "AirPods Pro", price: 1899)
    ]
    
    func getSampleProducts() -> [PublishedProduct] {
        return sampleProducts
    }
}

struct PublishedShoppingCartExample: View {
    @StateObject private var viewModel = PublishedShoppingCartViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("购物车系统")
                .font(.headline)
            
            // 商品列表
            VStack(alignment: .leading, spacing: 8) {
                Text("商品列表")
                    .font(.subheadline)
                    .bold()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(viewModel.getSampleProducts()) { product in
                        Button(action: {
                            viewModel.addProduct(product)
                        }) {
                            VStack(spacing: 4) {
                                Text(product.name)
                                    .font(.caption)
                                    .bold()
                                Text("¥\(String(format: "%.0f", product.price))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // 购物车
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("购物车 (\(viewModel.itemCount) 件)")
                        .font(.subheadline)
                        .bold()
                    
                    Spacer()
                    
                    Text("总价: ¥\(String(format: "%.2f", viewModel.total))")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .bold()
                }
                
                if viewModel.items.isEmpty {
                    Text("购物车为空")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    LazyVStack(spacing: 4) {
                        ForEach(viewModel.items) { item in
                            HStack {
                                Text(item.product.name)
                                    .font(.caption)
                                
                                Spacer()
                                
                                Text("\(item.quantity)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Text("¥\(String(format: "%.0f", item.totalPrice))")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                
                                Button("删除") {
                                    viewModel.removeProduct(item.product)
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.mini)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 80)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // 结账
            VStack(spacing: 8) {
                if viewModel.isCheckingOut {
                    HStack {
                        ProgressView()
                            .controlSize(.small)
                        Text("处理中...")
                            .font(.caption)
                    }
                } else {
                    Button("结账") {
                        viewModel.checkout()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.items.isEmpty)
                }
                
                if !viewModel.checkoutMessage.isEmpty {
                    Text(viewModel.checkoutMessage)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 15. 表单验证
@MainActor
class PublishedFormValidationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 验证姓名
        $name
            .map { name in
                if name.isEmpty {
                    return "姓名不能为空"
                } else if name.count < 2 {
                    return "姓名至少2个字符"
                } else {
                    return nil
                }
            }
            .assign(to: &$nameError)
        
        // 验证邮箱
        $email
            .map { email in
                if email.isEmpty {
                    return "邮箱不能为空"
                } else if !email.contains("@") || !email.contains(".") {
                    return "邮箱格式不正确"
                } else {
                    return nil
                }
            }
            .assign(to: &$emailError)
        
        // 验证密码
        $password
            .map { password in
                if password.isEmpty {
                    return "密码不能为空"
                } else if password.count < 6 {
                    return "密码至少6个字符"
                } else {
                    return nil
                }
            }
            .assign(to: &$passwordError)
        
        // 验证确认密码
        Publishers.CombineLatest($password, $confirmPassword)
            .map { password, confirmPassword in
                if confirmPassword.isEmpty {
                    return "请确认密码"
                } else if password != confirmPassword {
                    return "两次密码不一致"
                } else {
                    return nil
                }
            }
            .assign(to: &$confirmPasswordError)
        
        // 验证整体表单
        let formValidationPublisher = Publishers.CombineLatest4($nameError, $emailError, $passwordError, $confirmPasswordError)
        
        let formValidityPublisher = formValidationPublisher.map { nameError, emailError, passwordError, confirmPasswordError in
            return nameError == nil && emailError == nil && 
                   passwordError == nil && confirmPasswordError == nil
        }
        
        formValidityPublisher.assign(to: &$isFormValid)
    }
    
    func submit() {
        guard isFormValid else { return }
        
        // 提交表单逻辑
        print("表单提交成功: \(name), \(email)")
    }
    
    func reset() {
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}

struct PublishedFormValidationExample: View {
    @StateObject private var viewModel = PublishedFormValidationViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("表单验证")
                .font(.headline)
            
            VStack(spacing: 12) {
                // 姓名
                VStack(alignment: .leading, spacing: 4) {
                    TextField("姓名", text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                    
                    if let error = viewModel.nameError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // 邮箱
                VStack(alignment: .leading, spacing: 4) {
                    TextField("邮箱", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                    
                    if let error = viewModel.emailError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // 密码
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("密码", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    if let error = viewModel.passwordError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // 确认密码
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("确认密码", text: $viewModel.confirmPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    if let error = viewModel.confirmPasswordError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // 提交按钮
                HStack(spacing: 16) {
                    Button("提交") {
                        viewModel.submit()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.isFormValid)
                    
                    Button("重置") {
                        viewModel.reset()
                    }
                    .buttonStyle(.bordered)
                }
                
                Text("表单状态: \(viewModel.isFormValid ? "有效" : "无效")")
                    .font(.caption)
                    .foregroundColor(viewModel.isFormValid ? .green : .red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 测试和调试示例

// 16. 发布监听
@MainActor
class PublishedMonitoringViewModel: ObservableObject {
    @Published var value = 0
    @Published var publishCount = 0
    @Published var lastPublishTime: Date?
    @Published var publishHistory: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 监听所有发布事件
        objectWillChange
            .sink { [weak self] _ in
                self?.publishCount += 1
                self?.lastPublishTime = Date()
                self?.publishHistory.append("发布于 \(Date().formatted(.dateTime.hour().minute().second()))")
            }
            .store(in: &cancellables)
        
        // 特定属性监听
        $value
            .sink { [weak self] newValue in
                self?.publishHistory.append("值变为: \(newValue)")
            }
            .store(in: &cancellables)
    }
    
    func increment() {
        value += 1
    }
    
    func batchUpdate() {
        // 这会触发一次发布
        value += 10
    }
    
    func clearHistory() {
        publishHistory.removeAll()
        publishCount = 0
        lastPublishTime = nil
    }
}

struct PublishedMonitoringExample: View {
    @StateObject private var viewModel = PublishedMonitoringViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("发布监听")
                .font(.headline)
            
            VStack(spacing: 12) {
                Text("当前值: \(viewModel.value)")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("发布次数: \(viewModel.publishCount)")
                        .font(.caption)
                    
                    if let lastTime = viewModel.lastPublishTime {
                        Text("最后发布: \(lastTime.formatted(.dateTime.hour().minute().second()))")
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.publishHistory.suffix(10), id: \.self) { entry in
                            Text(entry)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 80)
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(6)
                
                HStack(spacing: 8) {
                    Button("+1") {
                        viewModel.increment()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("+10") {
                        viewModel.batchUpdate()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("清空") {
                        viewModel.clearHistory()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 17. 发布历史
@MainActor
class PublishedHistoryViewModel: ObservableObject {
    @Published var currentValue = ""
    @Published var valueHistory: [(value: String, timestamp: Date)] = []
    @Published var undoStack: [String] = []
    @Published var redoStack: [String] = []
    
    func updateValue(_ newValue: String) {
        // 记录历史
        valueHistory.append((currentValue, Date()))
        undoStack.append(currentValue)
        redoStack.removeAll()
        
        currentValue = newValue
        
        // 限制历史记录数量
        if valueHistory.count > 10 {
            valueHistory.removeFirst()
        }
        if undoStack.count > 10 {
            undoStack.removeFirst()
        }
    }
    
    func undo() {
        guard !undoStack.isEmpty else { return }
        
        redoStack.append(currentValue)
        currentValue = undoStack.removeLast()
    }
    
    func redo() {
        guard !redoStack.isEmpty else { return }
        
        undoStack.append(currentValue)
        currentValue = redoStack.removeLast()
    }
    
    func clear() {
        currentValue = ""
        valueHistory.removeAll()
        undoStack.removeAll()
        redoStack.removeAll()
    }
}

struct PublishedHistoryExample: View {
    @StateObject private var viewModel = PublishedHistoryViewModel()
    @State private var inputText = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("发布历史")
                .font(.headline)
            
            VStack(spacing: 12) {
                Text("当前值: \(viewModel.currentValue)")
                    .font(.body)
                    .foregroundColor(.blue)
                
                HStack {
                    TextField("输入新值", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("更新") {
                        viewModel.updateValue(inputText)
                        inputText = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack(spacing: 16) {
                    Button("撤销") {
                        viewModel.undo()
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.undoStack.isEmpty)
                    
                    Button("重做") {
                        viewModel.redo()
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.redoStack.isEmpty)
                    
                    Button("清空") {
                        viewModel.clear()
                    }
                    .buttonStyle(.bordered)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("历史记录:")
                        .font(.caption)
                        .bold()
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(viewModel.valueHistory.enumerated()), id: \.offset) { index, entry in
                                Text("\(index + 1). \(entry.value) (\(entry.timestamp.formatted(.dateTime.hour().minute().second())))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(height: 60)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// 18. 性能分析
@MainActor
class PublishedPerformanceViewModel: ObservableObject {
    @Published var updateCount = 0
    @Published var lastUpdateDuration: TimeInterval = 0
    @Published var averageUpdateDuration: TimeInterval = 0
    @Published var performanceData: [Double] = []
    
    private var updateStartTime: Date?
    private var totalUpdateDuration: TimeInterval = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        objectWillChange
            .sink { [weak self] _ in
                self?.recordUpdateStart()
            }
            .store(in: &cancellables)
        
        // 使用 receive(on:) 确保在主线程上更新
        objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.recordUpdateEnd()
                }
            }
            .store(in: &cancellables)
    }
    
    private func recordUpdateStart() {
        updateStartTime = Date()
    }
    
    private func recordUpdateEnd() {
        guard let startTime = updateStartTime else { return }
        
        let duration = Date().timeIntervalSince(startTime)
        lastUpdateDuration = duration
        totalUpdateDuration += duration
        updateCount += 1
        averageUpdateDuration = totalUpdateDuration / Double(updateCount)
        
        performanceData.append(duration * 1000) // 转换为毫秒
        
        // 限制数据点数量
        if performanceData.count > 20 {
            performanceData.removeFirst()
        }
    }
    
    func triggerUpdate() {
        // 触发一次更新
        objectWillChange.send()
    }
    
    func triggerBatchUpdates() {
        // 触发多次更新
        for _ in 0..<5 {
            objectWillChange.send()
        }
    }
    
    func reset() {
        updateCount = 0
        lastUpdateDuration = 0
        averageUpdateDuration = 0
        totalUpdateDuration = 0
        performanceData.removeAll()
    }
}

struct PublishedPerformanceExample: View {
    @StateObject private var viewModel = PublishedPerformanceViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("性能分析")
                .font(.headline)
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("更新次数: \(viewModel.updateCount)")
                        .font(.caption)
                    
                    Text("最后更新耗时: \(String(format: "%.2f", viewModel.lastUpdateDuration * 1000))ms")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("平均耗时: \(String(format: "%.2f", viewModel.averageUpdateDuration * 1000))ms")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                
                // 简单的性能图表
                if !viewModel.performanceData.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("性能趋势 (毫秒):")
                            .font(.caption)
                            .bold()
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            ForEach(Array(viewModel.performanceData.enumerated()), id: \.offset) { index, value in
                                Rectangle()
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(width: 8, height: max(2, value * 10))
                            }
                        }
                        .frame(height: 40)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                }
                
                HStack(spacing: 8) {
                    Button("单次更新") {
                        viewModel.triggerUpdate()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("批量更新") {
                        viewModel.triggerBatchUpdates()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("重置") {
                        viewModel.reset()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - 预览

#Preview {
    NavigationView {
        PublishedDemoView()
    }
}
