import SwiftUI

struct CustomPropertyWrapperDemoView: View {
  var body: some View {
    ShowcaseList {
      ShowcaseSection("基础包装器") {
        ShowcaseItem(title: "范围限制包装器") {
          CPWClampedDemoView()
        }
        
        ShowcaseItem(title: "验证包装器") {
          CPWValidatedDemoView()
        }
        
        ShowcaseItem(title: "格式化包装器") {
          CPWFormattedDemoView()
        }
      }
      
      ShowcaseSection("存储包装器") {
        ShowcaseItem(title: "用户偏好设置") {
          CPWUserDefaultDemoView().frame(height: 600)
        }
        
        ShowcaseItem(title: "缓存包装器") {
          CPWCachedDemoView()
        }
        
        ShowcaseItem(title: "历史记录包装器") {
          CPWHistoryDemoView()
        }
      }
      
      ShowcaseSection("高级包装器") {
        ShowcaseItem(title: "表单验证") {
          CPWFormValidationDemoView().frame(height: 500)
        }
        
        ShowcaseItem(title: "动画包装器") {
          CPWAnimatedPropertyDemoView()
        }
        
        ShowcaseItem(title: "组合使用") {
          CPWCombinedWrappersDemoView().frame(height: 600)
        }
        
        
      }
      
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "用户注册表单") {
          CPWRegistrationFormDemoView().frame(height: 700)
        }
        
        ShowcaseItem(title: "设置面板") {
          CPWSettingsPanelDemoView().frame(height: 800)
        }
        
        ShowcaseItem(title: "性能优化") {
          CPWPerformanceOptimizedDemoView()
        }
      }
    }
    .navigationTitle("自定义属性包装器")
  }
  
}

// MARK: - 基础包装器实现

@propertyWrapper
class CPWClamped<Value: Comparable>: ObservableObject {
  private var value: Value
  private let range: ClosedRange<Value>
  
  init(wrappedValue: Value, _ range: ClosedRange<Value>) {
    self.range = range
    self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
  }
  
  var wrappedValue: Value {
    get { value }
    set { value = min(max(newValue, range.lowerBound), range.upperBound) }
  }
  
  var projectedValue: Binding<Value> {
    Binding(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }
}

@propertyWrapper
class CPWValidated<T>: ObservableObject {
  private var value: T
  private let validator: (T) -> Bool
  private(set) var isValid: Bool = true
  
  init(wrappedValue: T, validator: @escaping (T) -> Bool) {
    self.validator = validator
    self.value = wrappedValue
    self.isValid = validator(wrappedValue)
  }
  
  var wrappedValue: T {
    get { value }
    set {
      value = newValue
      isValid = validator(newValue)
    }
  }
  
  var projectedValue: Bool {
    isValid
  }
}

@propertyWrapper
class CPWFormatted: ObservableObject {
  private var value: String = ""
  private let formatter: (String) -> String
  
  init(wrappedValue: String = "", formatter: @escaping (String) -> String) {
    self.formatter = formatter
    self.value = formatter(wrappedValue)
  }
  
  var wrappedValue: String {
    get { value }
    set { value = formatter(newValue) }
  }
  
  var projectedValue: Binding<String> {
    Binding(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }
}

@propertyWrapper
class CPWUserDefault<T>: ObservableObject {
  let key: String
  let defaultValue: T
  
  var wrappedValue: T {
    get {
      UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
  
  var projectedValue: Binding<T> {
    Binding(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

@propertyWrapper
class CPWCached<T> {
  private var value: T?
  private let loader: () -> T
  
  init(loader: @escaping () -> T) {
    self.loader = loader
  }
  
  var wrappedValue: T {
    get {
      if let value = value {
        return value
      }
      let newValue = loader()
      value = newValue
      return newValue
    }
    set {
      value = newValue
    }
  }
  
  var projectedValue: CPWCached<T> {
    return self
  }
  
  func refresh() {
    value = nil
  }
}

@propertyWrapper
class CPWStateWithHistory<T: Equatable> {
  private var currentValue: T
  private var history: [T] = []
  private let maxHistorySize: Int
  
  init(wrappedValue: T, maxHistory: Int = 10) {
    self.currentValue = wrappedValue
    self.maxHistorySize = maxHistory
    self.history = [wrappedValue]
  }
  
  var wrappedValue: T {
    get { currentValue }
    set {
      if newValue != currentValue {
        history.append(newValue)
        if history.count > maxHistorySize {
          history.removeFirst()
        }
        currentValue = newValue
      }
    }
  }
  
  var projectedValue: CPWStateWithHistory<T> {
    return self
  }
  
  var historyList: [T] { history }
  var canUndo: Bool { history.count > 1 }
  
  func undo() {
    if history.count > 1 {
      history.removeLast()
      currentValue = history.last!
    }
  }
}

@propertyWrapper
class CPWAnimated<T: VectorArithmetic>: ObservableObject {
  private var value: T
  private let animation: Animation
  
  init(wrappedValue: T, animation: Animation = .default) {
    self.value = wrappedValue
    self.animation = animation
  }
  
  var wrappedValue: T {
    get { value }
    set {
      withAnimation(animation) {
        value = newValue
      }
    }
  }
  
  var projectedValue: Binding<T> {
    Binding(
      get: { self.wrappedValue },
      set: { self.wrappedValue = $0 }
    )
  }
}

@propertyWrapper
class CPWFormField<T>: ObservableObject {
  private var value: T
  private let rules: [(T) -> CPWValidationResult]
  private var validationResult: CPWValidationResult = .valid
  
  init(wrappedValue: T, rules: [(T) -> CPWValidationResult] = []) {
    self.value = wrappedValue
    self.rules = rules
    self.validate()
  }
  
  var wrappedValue: T {
    get { value }
    set {
      value = newValue
      validate()
    }
  }
  
  var projectedValue: CPWValidationResult {
    validationResult
  }
  
  private func validate() {
    for rule in rules {
      let result = rule(value)
      if case .invalid = result {
        validationResult = result
        return
      }
    }
    validationResult = .valid
  }
}

enum CPWValidationResult {
  case valid
  case invalid(String)
  
  var isValid: Bool {
    if case .valid = self { return true }
    return false
  }
  
  var message: String {
    if case .invalid(let msg) = self { return msg }
    return ""
  }
}

// MARK: - 演示视图

struct CPWClampedDemoView: View {
  @State private var volume: Int = 50
  @State private var speed: Int = 5
  @State private var balance: Int = 0
  
  // 使用私有的包装器实例
  @StateObject private var volumeWrapper = CPWClamped(wrappedValue: 50, 0...100)
  @StateObject private var speedWrapper = CPWClamped(wrappedValue: 5, 1...10)
  @StateObject private var balanceWrapper = CPWClamped(wrappedValue: 0, -100...100)
  
  var body: some View {
    VStack(spacing: 20) {
      
      
      Group {
        VStack {
          Text("音量: \(volume) (0-100)")
          Slider(value: Binding(
            get: { Double(volume) },
            set: { newValue in
              volumeWrapper.wrappedValue = Int(newValue)
              volume = volumeWrapper.wrappedValue
            }
          ), in: 0...100)
        }
        
        VStack {
          Text("速度: \(speed) (1-10)")
          Stepper("速度", value: Binding(
            get: { speed },
            set: { newValue in
              speedWrapper.wrappedValue = newValue
              speed = speedWrapper.wrappedValue
            }
          ), in: 1...10)
        }
        
        VStack {
          Text("平衡: \(balance) (-100到100)")
          Slider(value: Binding(
            get: { Double(balance) },
            set: { newValue in
              balanceWrapper.wrappedValue = Int(newValue)
              balance = balanceWrapper.wrappedValue
            }
          ), in: -100...100)
        }
      }
      
      Text("尝试输入超出范围的值，会自动被限制在有效范围内")
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}

struct CPWValidatedDemoView: View {
  @State private var email = ""
  @State private var password = ""
  @State private var phoneNumber = ""
  
  @StateObject private var emailValidator = CPWValidated(wrappedValue: "", validator: { $0.contains("@") && $0.contains(".") })
  @StateObject private var passwordValidator = CPWValidated(wrappedValue: "", validator: { $0.count >= 6 })
  @StateObject private var phoneValidator = CPWValidated(wrappedValue: "", validator: { $0.range(of: "^[0-9]+$", options: .regularExpression) != nil })
  
  var body: some View {
    VStack(spacing: 20) {
      
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          TextField("邮箱地址", text: $email)
            .textFieldStyle(.roundedBorder)
            .onChange(of: email) { newValue in
              emailValidator.wrappedValue = newValue
            }
          Image(systemName: emailValidator.projectedValue ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundColor(emailValidator.projectedValue ? .green : .red)
        }
        Text("必须包含 @ 和 .")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          SecureField("密码", text: $password)
            .textFieldStyle(.roundedBorder)
            .onChange(of: password) { newValue in
              passwordValidator.wrappedValue = newValue
            }
          Image(systemName: passwordValidator.projectedValue ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundColor(passwordValidator.projectedValue ? .green : .red)
        }
        Text("至少6个字符")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          TextField("手机号码", text: $phoneNumber)
            .textFieldStyle(.roundedBorder)
            .onChange(of: phoneNumber) { newValue in
              phoneValidator.wrappedValue = newValue
            }
          Image(systemName: phoneValidator.projectedValue ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundColor(phoneValidator.projectedValue ? .green : .red)
        }
        Text("只能包含数字")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Button("提交") {
        print("表单提交")
      }
      .disabled(!(emailValidator.projectedValue && passwordValidator.projectedValue && phoneValidator.projectedValue))
      .buttonStyle(.borderedProminent)
    }
    .padding()
  }
}

struct CPWFormattedDemoView: View {
  @CPWFormatted(formatter: { phone in
    let digits = phone.filter { $0.isNumber }
    guard digits.count >= 3 else { return digits }
    
    if digits.count <= 6 {
      return String(digits.prefix(3)) + "-" + String(digits.dropFirst(3))
    } else {
      return String(digits.prefix(3)) + "-" +
      String(digits.dropFirst(3).prefix(3)) + "-" +
      String(digits.dropFirst(6).prefix(4))
    }
  }) var phoneNumber = ""
  
  @CPWFormatted(formatter: { $0.uppercased() }) var upperCaseText = ""
  
  @CPWFormatted(formatter: { price in
    let numbers = price.filter { $0.isNumber || $0 == "." }
    if let value = Double(numbers) {
      return String(format: "%.2f", value)
    }
    return price
  }) var price = ""
  
  var body: some View {
    VStack(spacing: 20) {
      
      
      VStack(alignment: .leading, spacing: 8) {
        Text("电话号码自动格式化:")
        TextField("输入电话号码", text: $phoneNumber)
          .textFieldStyle(.roundedBorder)
        
        Text("自动添加横线分隔")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("自动转大写:")
        TextField("输入文本", text: $upperCaseText)
          .textFieldStyle(.roundedBorder)
        Text("输入的文本会自动转为大写")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("价格格式化:")
        TextField("输入价格", text: $price)
          .textFieldStyle(.roundedBorder)
        
        Text("自动格式化为两位小数")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding()
  }
}

struct CPWUserDefaultDemoView: View {
  @CPWUserDefault(key: "demo_username", defaultValue: "") var username
  @CPWUserDefault(key: "demo_isDarkMode", defaultValue: false) var isDarkMode
  @CPWUserDefault(key: "demo_fontSize", defaultValue: 16) var fontSize
  @CPWUserDefault(key: "demo_isNotificationsEnabled", defaultValue: true) var isNotificationsEnabled
  
  var body: some View {
    
    
    
    Form {
      Section(header: Text("用户信息")) {
        TextField("用户名", text: $username)
        Text("用户名: \(username.isEmpty ? "未设置" : username)")
          .foregroundColor(.secondary)
      }
      
      Section(header: Text("界面设置")) {
        Toggle("深色模式", isOn: $isDarkMode)
        
        HStack {
          Text("字体大小")
          Spacer()
          Stepper("\(fontSize)", value: $fontSize, in: 12...24)
        }
      }
      
      Section(header: Text("通知")) {
        Toggle("启用通知", isOn: $isNotificationsEnabled)
      }
      
      Section(header: Text("说明")) {
        Text("这些设置会自动保存到 UserDefaults，关闭应用后重新打开仍会保持")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    
  }
}

struct CPWCachedDemoView: View {
  @State private var cacheDemo = CPWCacheExampleViewModel()
  
  var body: some View {
    VStack(spacing: 20) {
      
      
      VStack {
        Text("昂贵计算结果:")
        Text("\(cacheDemo.expensiveComputation)")
          .font(.title)
          .foregroundColor(.blue)
        
        Text("加载时间: \(cacheDemo.loadTime, specifier: "%.3f")秒")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("重新计算 (首次会很慢)") {
        cacheDemo.refresh()
      }
      .buttonStyle(.borderedProminent)
      
      Text("首次访问会进行复杂计算，后续访问直接返回缓存结果")
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}

@MainActor
class CPWCacheExampleViewModel: ObservableObject {
  @CPWCached(loader: {
    // 模拟耗时计算
    let start = Date()
    Thread.sleep(forTimeInterval: 1) // 模拟1秒的计算时间
    return Int.random(in: 1000...9999)
  }) var expensiveComputation: Int
  
  @Published var loadTime: Double = 0
  
  func refresh() {
    let start = Date()
    $expensiveComputation.refresh() // 清除缓存
    _ = expensiveComputation // 触发重新计算
    loadTime = Date().timeIntervalSince(start)
  }
  
  init() {
    refresh()
  }
}

struct CPWHistoryDemoView: View {
  @CPWStateWithHistory(maxHistory: 5) var counter = 0
  
  var body: some View {
    VStack(spacing: 20) {
      
      VStack {
        Text("当前值: \(counter)")
          .font(.title)
        
        HStack {
          Button("减1") { counter -= 1 }
          Button("加1") { counter += 1 }
          Button("加10") { counter += 10 }
        }
        .buttonStyle(.bordered)
      }
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(8)
      
      VStack(alignment: .leading) {
        HStack {
          Text("历史记录:")
            .font(.headline)
          
          Spacer()
          
          Button("撤销") {
            $counter.undo()
          }
          .disabled(!$counter.canUndo)
          .buttonStyle(.borderless)
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(Array($counter.historyList.enumerated()), id: \.offset) { index, value in
              Text("\(value)")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                  index == $counter.historyList.count - 1 ?
                  Color.blue : Color.gray.opacity(0.3)
                )
                .foregroundColor(
                  index == $counter.historyList.count - 1 ?
                    .white : .primary
                )
                .cornerRadius(4)
            }
          }
          .padding(.horizontal)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Text("最多保存5个历史记录，支持撤销操作")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

struct CPWFormValidationDemoView: View {
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""
  
  @StateObject private var usernameField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.count >= 3 ? .valid : .invalid("用户名至少3个字符") },
    { (s: String) in s.allSatisfy { $0.isLetter || $0.isNumber } ? .valid : .invalid("只能包含字母和数字") }
  ])
  
  @StateObject private var emailField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.contains("@") ? .valid : .invalid("请输入有效邮箱") },
    { (s: String) in s.contains(".") ? .valid : .invalid("邮箱格式不正确") }
  ])
  
  @StateObject private var passwordField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.count >= 8 ? .valid : .invalid("密码至少8个字符") },
    { (s: String) in s.contains { $0.isUppercase } ? .valid : .invalid("密码需要包含大写字母") },
    { (s: String) in s.contains { $0.isNumber } ? .valid : .invalid("密码需要包含数字") }
  ])
  
  var isFormValid: Bool {
    usernameField.projectedValue.isValid && emailField.projectedValue.isValid && passwordField.projectedValue.isValid
  }
  
  var body: some View {
    
    
    Form {
      Section {
        
        VStack () {
          VStack(alignment: .leading, spacing: 8) {
            TextField("用户名", text: $username)
              .textFieldStyle(.roundedBorder)
              .onChange(of: username) { newValue in
                usernameField.wrappedValue = newValue
              }
            if !usernameField.projectedValue.isValid {
              Text(usernameField.projectedValue.message)
                .foregroundColor(.red)
                .font(.caption)
            }
          }
          
          VStack(alignment: .leading, spacing: 8) {
            TextField("邮箱", text: $email)
              .textFieldStyle(.roundedBorder)
            
            if !emailField.projectedValue.isValid {
              Text(emailField.projectedValue.message)
                .foregroundColor(.red)
                .font(.caption)
            }
          }
          
          VStack(alignment: .leading, spacing: 8) {
            SecureField("密码", text: $password)
              .textFieldStyle(.roundedBorder)
            if !passwordField.projectedValue.isValid {
              Text(passwordField.projectedValue.message)
                .foregroundColor(.red)
                .font(.caption)
            }
          }
        }
        
      }
      
      Section {
        HStack {
          Text("表单状态:")
          Spacer()
          Text(isFormValid ? "✓ 有效" : "✗ 无效")
            .foregroundColor(isFormValid ? .green : .red)
        }
        
      }
      
      Button("注册") {
        print("用户注册: \(username), \(email)")
      }
      .disabled(!isFormValid)
      .buttonStyle(.borderedProminent)
    }
    
    
  }}

struct CPWAnimatedPropertyDemoView: View {
  @CPWAnimated(animation: .spring()) var scale: CGFloat = 1.0
  @CPWAnimated(animation: .easeInOut(duration: 0.5)) var rotation: Double = 0
  @State var offset: CGSize = .zero
  
  var body: some View {
    VStack(spacing: 30) {
      
      // 缩放动画
      VStack {
        Circle()
          .fill(.blue)
          .frame(width: 50, height: 50)
          .scaleEffect(scale)
        
        Button("缩放") {
          scale = scale == 1.0 ? 1.5 : 1.0
        }
        .buttonStyle(.bordered)
      }
      
      // 旋转动画
      VStack {
        Rectangle()
          .fill(.green)
          .frame(width: 50, height: 50)
          .rotationEffect(.degrees(rotation))
        
        Button("旋转") {
          rotation += 45
        }
        .buttonStyle(.bordered)
      }
      
      // 位移动画
      VStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(.red)
          .frame(width: 50, height: 50)
          .offset(offset)
        
        Button("移动") {
          withAnimation(.bouncy) {
            offset = offset == .zero ? CGSize(width: 50, height: 0) : .zero
          }
        }
        .buttonStyle(.bordered)
      }
      
      Text("每个属性变化都会自动应用预设的动画效果")
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}

struct CPWCombinedWrappersDemoView: View {
  @State private var sliderValue = 50
  @State private var savedEmail = ""
  @State private var savedCode = ""
  
  @StateObject private var sliderWrapper = CPWClamped(wrappedValue: 50, 0...100)
  @StateObject private var emailValidator = CPWValidated(wrappedValue: "", validator: { $0.contains("@") && $0.contains(".") })
  @StateObject private var codeFormatter = CPWFormatted(wrappedValue: "", formatter: { $0.uppercased() })
  
  var body: some View {
    
    
    Form {
      Section(header: Text("保存 + 限制范围")) {
        VStack(alignment: .leading) {
          Text("滑块值: \(sliderValue)")
          Slider(value: Binding(
            get: { Double(sliderValue) },
            set: { newValue in
              sliderWrapper.wrappedValue = Int(newValue)
              sliderValue = sliderWrapper.wrappedValue
            }
          ), in: 0...100)
          Text("值会自动保存到 UserDefaults 并限制在 0-100 之间")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Section(header: Text("保存 + 验证")) {
        VStack(alignment: .leading) {
          HStack {
            TextField("邮箱", text: $savedEmail)
              .onChange(of: savedEmail) { newValue in
                emailValidator.wrappedValue = newValue
              }
            Image(systemName: emailValidator.projectedValue ? "checkmark.circle.fill" : "xmark.circle.fill")
              .foregroundColor(emailValidator.projectedValue ? .green : .red)
          }
          Text("邮箱会自动保存并实时验证格式")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Section(header: Text("格式化 + 保存")) {
        VStack(alignment: .leading) {
          TextField("代码", text: $savedCode)
          Text("输入会自动转大写并保存")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Section(header: Text("说明")) {
        Text("演示了多个属性包装器的组合使用，每个包装器都发挥各自的作用")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    
  }
}

struct CPWRegistrationFormDemoView: View {
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  @State private var agreeToTerms = false
  @State private var age = 18
  
  @StateObject private var usernameField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.count >= 3 ? .valid : .invalid("用户名至少3个字符") },
    { (s: String) in s.allSatisfy { $0.isLetter || $0.isNumber } ? .valid : .invalid("只能包含字母和数字") }
  ])
  
  @StateObject private var emailField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.contains("@") ? .valid : .invalid("请输入有效邮箱") },
    { (s: String) in s.contains(".") ? .valid : .invalid("邮箱格式不正确") }
  ])
  
  @StateObject private var passwordField = CPWFormField(wrappedValue: "", rules: [
    { (s: String) in s.count >= 8 ? .valid : .invalid("密码至少8个字符") },
    { (s: String) in s.contains { $0.isUppercase } ? .valid : .invalid("密码需要包含大写字母") },
    { (s: String) in s.contains { $0.isNumber } ? .valid : .invalid("密码需要包含数字") }
  ])
  
  @StateObject private var confirmPasswordField = CPWFormField(wrappedValue: "", rules: [])
  @StateObject private var agreeWrapper = CPWUserDefault(key: "demo_agreeToTerms", defaultValue: false)
  @StateObject private var ageWrapper = CPWClamped(wrappedValue: 18, 18...120)
  
  // 手动验证确认密码
  private var isConfirmPasswordValid: Bool {
    confirmPassword == password && !password.isEmpty
  }
  
  var isFormValid: Bool {
    usernameField.projectedValue.isValid && emailField.projectedValue.isValid && passwordField.projectedValue.isValid &&
    isConfirmPasswordValid && agreeToTerms
  }
  
  var body: some View {
    
    Form {
      Section(header: Text("基本信息")) {
        VStack(alignment: .leading, spacing: 4) {
          TextField("用户名", text: $username)
            .onChange(of: username) { newValue in
              usernameField.wrappedValue = newValue
            }
          if !usernameField.projectedValue.isValid {
            Text(usernameField.projectedValue.message)
              .foregroundColor(.red)
              .font(.caption)
          }
        }
        
        VStack(alignment: .leading, spacing: 4) {
          TextField("邮箱", text: $email)
          
            .onChange(of: email) { newValue in
              emailField.wrappedValue = newValue
            }
          if !emailField.projectedValue.isValid {
            Text(emailField.projectedValue.message)
              .foregroundColor(.red)
              .font(.caption)
          }
        }
        
        HStack {
          Text("年龄")
          Spacer()
          Stepper("\(age)岁", value: Binding(
            get: { age },
            set: { newValue in
              ageWrapper.wrappedValue = newValue
              age = ageWrapper.wrappedValue
            }
          ), in: 18...120)
        }
      }
      
      Section(header: Text("密码设置")) {
        VStack(alignment: .leading, spacing: 4) {
          SecureField("密码", text: $password)
            .onChange(of: password) { newValue in
              passwordField.wrappedValue = newValue
            }
          if !passwordField.projectedValue.isValid {
            Text(passwordField.projectedValue.message)
              .foregroundColor(.red)
              .font(.caption)
          }
        }
        
        VStack(alignment: .leading, spacing: 4) {
          SecureField("确认密码", text: $confirmPassword)
          if !isConfirmPasswordValid {
            Text("密码不匹配")
              .foregroundColor(.red)
              .font(.caption)
          }
        }
      }
      
      Section(header: Text("协议")) {
        Toggle("同意用户协议", isOn: Binding(
          get: { agreeToTerms },
          set: { newValue in
            agreeWrapper.wrappedValue = newValue
            agreeToTerms = agreeWrapper.wrappedValue
          }
        ))
      }
      
      Section {
        Button("注册") {
          register()
        }
        .frame(maxWidth: .infinity)
        .disabled(!isFormValid)
      }
    }
    
    
    
  }
  
  private func register() {
    print("注册用户:")
    print("用户名: \(username)")
    print("邮箱: \(email)")
    print("年龄: \(age)")
    print("同意协议: \(agreeToTerms)")
  }
}

struct CPWSettingsPanelDemoView: View {
  @CPWUserDefault(key: "demo_settings_username", defaultValue: "") var username
  @CPWUserDefault(key: "demo_settings_isDarkMode", defaultValue: false) var isDarkMode
  @CPWUserDefault(key: "demo_settings_fontSize", defaultValue: 16) var fontSize
  @CPWUserDefault(key: "demo_settings_isNotificationsEnabled", defaultValue: true) var isNotificationsEnabled
  @CPWUserDefault(key: "demo_settings_language", defaultValue: "中文") var language
  @CPWUserDefault(key: "demo_settings_autoSave", defaultValue: true) var autoSave
  
  @CPWClamped(10...30) var fontSizeAdjustment = 16
  
  let languages = ["中文", "English", "日本語", "한국어"]
  
  var body: some View {
    
    Form {
      Section(header: Text("个人信息")) {
        TextField("用户名", text: $username)
        
        Picker("语言", selection: $language) {
          ForEach(languages, id: \.self) { lang in
            Text(lang).tag(lang)
          }
        }
      }
      
      Section(header: Text("界面设置")) {
        Toggle("深色模式", isOn: $isDarkMode)
        
        VStack(alignment: .leading) {
          HStack {
            Text("字体大小")
            Spacer()
            Text("\(fontSizeAdjustment)")
          }
          Slider(value: Binding(
            get: { Double(fontSizeAdjustment) },
            set: { fontSizeAdjustment = Int($0) }
          ), in: 10...30, step: 1)
        }
      }
      
      Section(header: Text("应用设置")) {
        Toggle("推送通知", isOn: $isNotificationsEnabled)
        Toggle("自动保存", isOn: $autoSave)
      }
      
      Section(header: Text("预览")) {
        VStack(alignment: .leading, spacing: 8) {
          Text("用户名: \(username.isEmpty ? "未设置" : username)")
            .font(.system(size: CGFloat(fontSizeAdjustment)))
          
          Text("当前设置:")
            .font(.system(size: CGFloat(fontSizeAdjustment)))
          
          Text("• 深色模式: \(isDarkMode ? "开启" : "关闭")")
            .font(.system(size: CGFloat(fontSizeAdjustment)))
          
          Text("• 语言: \(language)")
            .font(.system(size: CGFloat(fontSizeAdjustment)))
          
          Text("• 通知: \(isNotificationsEnabled ? "开启" : "关闭")")
            .font(.system(size: CGFloat(fontSizeAdjustment)))
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? Color.white : Color.black)
        .cornerRadius(8)
      }
    }
    
    
  }
}

struct CPWPerformanceOptimizedDemoView: View {
  @State private var performanceModel = CPWPerformanceTestModel()
  
  var body: some View {
    VStack(spacing: 20) {
      
      
      VStack(alignment: .leading, spacing: 12) {
        Text("缓存性能测试:")
          .font(.headline)
        
        HStack {
          Text("缓存值: \(performanceModel.cachedExpensiveValue)")
          Spacer()
          Text("\(performanceModel.cacheLoadTime, specifier: "%.3f")s")
            .foregroundColor(.blue)
        }
        
        Button("访问缓存值 (首次慢)") {
          performanceModel.testCachePerformance()
        }
        .buttonStyle(.bordered)
        
        Button("清除缓存") {
          performanceModel.clearCache()
        }
        .buttonStyle(.borderless)
      }
      .padding()
      .background(Color.blue.opacity(0.1))
      .cornerRadius(8)
      
      VStack(alignment: .leading, spacing: 12) {
        Text("延迟加载测试:")
          .font(.headline)
        
        HStack {
          Text("延迟值: \(performanceModel.lazyValue)")
          Spacer()
          Text("\(performanceModel.lazyLoadTime, specifier: "%.3f")s")
            .foregroundColor(.green)
        }
        
        Button("访问延迟值") {
          performanceModel.testLazyPerformance()
        }
        .buttonStyle(.bordered)
      }
      .padding()
      .background(Color.green.opacity(0.1))
      .cornerRadius(8)
      
      VStack(alignment: .leading, spacing: 8) {
        Text("性能优化要点:")
          .font(.headline)
        
        Text("• 使用缓存避免重复计算")
        Text("• 延迟加载减少初始化时间")
        Text("• 智能刷新机制")
        Text("• 内存使用优化")
      }
      .font(.caption)
      .foregroundColor(.secondary)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

@MainActor
class CPWPerformanceTestModel: ObservableObject {
  @Published var cacheLoadTime: Double = 0
  @Published var lazyLoadTime: Double = 0
  
  @CPWCached(loader: {
    Thread.sleep(forTimeInterval: 0.5) // 模拟耗时计算
    return Int.random(in: 1000...9999)
  }) var cachedExpensiveValue: Int
  
  private var _lazyValue: Int?
  var lazyValue: Int {
    if let value = _lazyValue {
      return value
    }
    Thread.sleep(forTimeInterval: 0.3) // 模拟加载时间
    let value = Int.random(in: 100...999)
    _lazyValue = value
    return value
  }
  
  func testCachePerformance() {
    let start = Date()
    _ = cachedExpensiveValue
    cacheLoadTime = Date().timeIntervalSince(start)
  }
  
  func testLazyPerformance() {
    let start = Date()
    _ = lazyValue
    lazyLoadTime = Date().timeIntervalSince(start)
  }
  
  func clearCache() {
    $cachedExpensiveValue.refresh()
    _lazyValue = nil
    cacheLoadTime = 0
    lazyLoadTime = 0
  }
}

#Preview {
  CustomPropertyWrapperDemoView()
}
