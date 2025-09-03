# SwiftUI 输入控件完整指南

## 1. 文本输入控件

### 1.1 TextField - 基础文本输入

```swift
// 基本用法
@State private var text = ""
TextField("占位文本", text: $text)

// 设置键盘类型
TextField("邮箱", text: $email)
    .keyboardType(.emailAddress)

// 文本对齐方式
TextField("居中文本", text: $text)
    .multilineTextAlignment(.center)

// 自动大写
TextField("自动大写", text: $text)
    .textInputAutocapitalization(.words)

// 自动更正
TextField("禁用自动更正", text: $text)
    .autocorrectionDisabled()

// 文本验证
TextField("用户名", text: $username)
    .onChange(of: username) { oldValue, newValue in
        validateUsername(newValue)
    }
```

### 1.2 SecureField - 安全输入

```swift
// 基本密码输入
@State private var password = ""
SecureField("密码", text: $password)

// 带提交操作
SecureField("密码", text: $password) {
    // 提交时的操作
    handleSubmit()
}

// 组合使用
VStack {
    TextField("用户名", text: $username)
    SecureField("密码", text: $password)
    Button("登录") {
        login(username: username, password: password)
    }
}
```

### 1.3 TextEditor - 多行文本输入

```swift
// 基本用法
@State private var longText = ""
TextEditor(text: $longText)
    .frame(height: 200)

// 设置样式
TextEditor(text: $longText)
    .font(.body)
    .foregroundStyle(.primary)
    .background(Color(.systemGray6))
    .cornerRadius(8)

// 限制输入长度
TextEditor(text: $longText)
    .onChange(of: longText) { oldValue, newValue in
        if newValue.count > 500 {
            longText = String(newValue.prefix(500))
        }
    }
```

## 2. 数值输入控件

### 2.1 Slider - 滑块输入

```swift
// 基本用法
@State private var value = 50.0
Slider(value: $value, in: 0...100)

// 步进值
Slider(value: $value, in: 0...100, step: 5)

// 自定义样式
Slider(value: $value, in: 0...100) {
    Text("调节值")
} minimumValueLabel: {
    Text("0")
} maximumValueLabel: {
    Text("100")
}

// 带格式化的值显示
VStack {
    Slider(value: $value, in: 0...100)
    Text("当前值: \(value, specifier: "%.1f")")
}
```

### 2.2 Stepper - 步进器

```swift
// 基本用法
@State private var quantity = 1
Stepper("数量: \(quantity)", value: $quantity, in: 1...10)

// 自定义步进
Stepper("值: \(value)", value: $value, in: 0...100, step: 5)

// 自定义增减操作
Stepper("自定义操作") {
    increment()
} onDecrement: {
    decrement()
}

// 格式化显示
Stepper(value: $temperature, in: -10...40, step: 0.5) {
    Text("温度: \(temperature, specifier: "%.1f")°C")
}
```

## 3. 选择控件

### 3.1 Picker - 选择器

```swift
// 基本用法
@State private var selectedOption = 0
Picker("选项", selection: $selectedOption) {
    Text("选项1").tag(0)
    Text("选项2").tag(1)
    Text("选项3").tag(2)
}

// 使用枚举
enum Category: String, CaseIterable {
    case food = "食物"
    case drink = "饮品"
    case snack = "零食"
}
@State private var selectedCategory: Category = .food
Picker("类别", selection: $selectedCategory) {
    ForEach(Category.allCases, id: \.self) { category in
        Text(category.rawValue).tag(category)
    }
}

// 不同样式
Picker("选择样式", selection: $selectedStyle) {
    ForEach(styles, id: \.self) { style in
        Text(style).tag(style)
    }
}
.pickerStyle(.segmented)  // 分段样式
.pickerStyle(.wheel)      // 滚轮样式
.pickerStyle(.menu)       // 菜单样式
```

### 3.2 Toggle - 开关

```swift
// 基本用法
@State private var isOn = false
Toggle("开启通知", isOn: $isOn)

// 自定义样式
Toggle("飞行模式", isOn: $isAirplaneMode)
    .toggleStyle(.switch)
    .tint(.blue)

// 自定义标签
Toggle(isOn: $isOn) {
    HStack {
        Image(systemName: "bell.fill")
        Text("提醒")
    }
}

// 禁用状态
Toggle("功能开关", isOn: $isEnabled)
    .disabled(true)
```

### 3.3 DatePicker - 日期选择器

```swift
// 基本用法
@State private var selectedDate = Date()
DatePicker("选择日期", selection: $selectedDate)

// 设置日期范围
let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
DatePicker("选择日期",
    selection: $selectedDate,
    in: startDate...Date(),
    displayedComponents: [.date]
)

// 自定义样式
DatePicker("预约时间",
    selection: $selectedDate,
    displayedComponents: [.hourAndMinute]
)
.datePickerStyle(.graphical)

// 本地化
DatePicker("日期",
    selection: $selectedDate,
    displayedComponents: [.date]
)
.environment(\.locale, Locale(identifier: "zh_CN"))
```

## 4. 高级输入

### 4.1 组合输入控件

```swift
// 表单组合
Form {
    Section("个人信息") {
        TextField("姓名", text: $name)
        DatePicker("生日", selection: $birthDate, displayedComponents: [.date])
        Picker("性别", selection: $gender) {
            Text("男").tag("male")
            Text("女").tag("female")
        }
    }

    Section("设置") {
        Toggle("接收通知", isOn: $notifications)
        Toggle("自动登录", isOn: $autoLogin)
    }
}

// 搜索栏
@State private var searchText = ""
NavigationView {
    List {
        ForEach(filteredItems) { item in
            Text(item.name)
        }
    }
    .searchable(text: $searchText, prompt: "搜索")
    .onChange(of: searchText) { oldValue, newValue in
        filterItems(searchText: newValue)
    }
}
```

### 4.2 自定义输入验证

```swift
struct ValidatedTextField: View {
    @Binding var text: String
    let title: String
    let validator: (String) -> Bool
    @State private var isValid = true

    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
                .onChange(of: text) { oldValue, newValue in
                    isValid = validator(newValue)
                }
                .textFieldStyle(.roundedBorder)

            if !isValid {
                Text("输入无效")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}

// 使用示例
struct ContentView: View {
    @State private var email = ""

    var body: some View {
        ValidatedTextField(text: $email, title: "邮箱") { email in
            email.contains("@") && email.contains(".")
        }
    }
}
```

### 4.3 输入辅助功能

```swift
TextField("用户名", text: $username)
    .accessibilityLabel("用户名输入框")
    .accessibilityHint("请输入您的用户名")
    .accessibilityValue(username.isEmpty ? "未输入" : username)

SecureField("密码", text: $password)
    .accessibilityLabel("密码输入框")
    .accessibilityHint("请输入您的密码，至少8个字符")
    .textContentType(.password)
    .privacyLevel(.private)
```

## 5. 性能优化

### 5.1 防抖动处理

```swift
// 使用Combine实现输入防抖
import Combine

struct DebouncedTextField: View {
    @Binding var text: String
    let title: String
    let delay: TimeInterval
    let onValueChanged: (String) -> Void

    @StateObject private var debouncer = Debouncer()

    var body: some View {
        TextField(title, text: $text)
            .onChange(of: text) { oldValue, newValue in
                debouncer.debounce(delay: delay) {
                    onValueChanged(newValue)
                }
            }
    }
}

class Debouncer: ObservableObject {
    private var cancellable: AnyCancellable?

    func debounce(delay: TimeInterval, action: @escaping () -> Void) {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { _ in
                action()
            }
    }
}
```

### 5.2 输入限制

```swift
struct LimitedTextField: View {
    @Binding var text: String
    let title: String
    let maxLength: Int

    var body: some View {
        TextField(title, text: $text)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
    }
}
```

## 6. 常见用例

### 6.1 登录表单

```swift
struct LoginForm: View {
    @State private var username = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("用户名", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .textContentType(.username)

            SecureField("密码", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)

            Toggle("记住我", isOn: $rememberMe)

            Button("登录") {
                validateAndLogin()
            }
            .buttonStyle(.borderedProminent)
            .disabled(username.isEmpty || password.isEmpty)

            if showError {
                Text("用户名或密码错误")
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }

    private func validateAndLogin() {
        // 登录逻辑
    }
}
```

### 6.2 注册表单

```swift
struct RegistrationForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var birthDate = Date()
    @State private var acceptTerms = false

    var body: some View {
        Form {
            Section("账号信息") {
                TextField("电子邮箱", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)

                SecureField("密码", text: $password)
                SecureField("确认密码", text: $confirmPassword)
            }

            Section("个人信息") {
                DatePicker("出生日期",
                    selection: $birthDate,
                    displayedComponents: [.date]
                )
            }

            Section {
                Toggle("我同意服务条款", isOn: $acceptTerms)

                Button("注册") {
                    register()
                }
                .disabled(!acceptTerms || !isValidForm)
            }
        }
    }

    private var isValidForm: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        email.contains("@")
    }

    private func register() {
        // 注册逻辑
    }
}
```

### 6.3 搜索表单

```swift
struct SearchForm: View {
    @State private var searchText = ""
    @State private var selectedCategory: Category = .all
    @State private var priceRange: ClosedRange<Double> = 0...1000
    @State private var showOnlyAvailable = false

    var body: some View {
        VStack {
            TextField("搜索", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                    }
                    .padding(.trailing, 8)
                )

            Picker("类别", selection: $selectedCategory) {
                ForEach(Category.allCases) { category in
                    Text(category.name).tag(category)
                }
            }
            .pickerStyle(.segmented)

            VStack {
                Text("价格范围: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound))")
                RangeSlider(range: $priceRange, in: 0...1000)
            }

            Toggle("只显示有货", isOn: $showOnlyAvailable)

            Button("搜索") {
                performSearch()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func performSearch() {
        // 搜索逻辑
    }
}
```

## 7. 注意事项

1. 输入验证应该实时进行，给用户即时反馈
2. 对于复杂的输入处理，考虑使用防抖动
3. 适当使用键盘类型，提高输入效率
4. 注意处理输入法和特殊字符
5. 合理使用占位符和提示文本
6. 考虑输入控件的无障碍支持
7. 注意处理输入焦点的切换
8. 合理使用输入限制，避免过度限制
9. 注意键盘遮挡问题的处理
10. 考虑深色模式下的显示效果

## 8. 最佳实践

1. 使用合适的输入控件类型
2. 提供清晰的输入提示和错误信息
3. 实现适当的输入验证
4. 处理好键盘的显示和隐藏
5. 注意表单的提交时机
6. 合理组织输入控件的布局
7. 提供适当的默认值
8. 注意输入控件的状态管理
9. 实现合理的输入限制
10. 注意性能优化

## 9. 完整运行 Demo

将以下代码复制到新的 SwiftUI 项目中即可运行：

```swift
import SwiftUI
import Combine

// MARK: - 文本输入示例
struct TextInputExampleView: View {
    @State private var basicText = ""
    @State private var secureText = ""
    @State private var longText = ""
    @State private var email = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("1. 文本输入示例").font(.title)

            Group {
                TextField("基本输入", text: $basicText)
                    .textFieldStyle(.roundedBorder)

                SecureField("密码输入", text: $secureText)
                    .textFieldStyle(.roundedBorder)

                TextField("邮箱", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextEditor(text: $longText)
                    .frame(height: 100)
                    .border(Color.gray.opacity(0.2))
            }
        }
    }
}

// MARK: - 数值输入示例
struct NumberInputExampleView: View {
    @State private var sliderValue = 50.0
    @State private var stepperValue = 5
    @State private var progress = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("2. 数值输入示例").font(.title)

            Group {
                HStack {
                    Text("滑块: \(sliderValue, specifier: "%.1f")")
                    Slider(value: $sliderValue, in: 0...100)
                }

                Stepper("步进器: \(stepperValue)", value: $stepperValue, in: 0...10)

                ProgressView("进度", value: progress)
                    .padding(.vertical)
            }
        }
    }
}

// MARK: - 选择控件示例
struct SelectionExampleView: View {
    @State private var selectedOption = 0
    @State private var isToggleOn = false
    @State private var selectedDate = Date()

    let options = ["选项1", "选项2", "选项3"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. 选择控件示例").font(.title)

            Group {
                Picker("选择器", selection: $selectedOption) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(options[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)

                Toggle("开关控件", isOn: $isToggleOn)

                DatePicker("日期选择",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
        }
    }
}

// MARK: - 表单示例
struct FormExampleView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var bio = ""
    @State private var notificationsEnabled = true
    @State private var selectedTheme = 0

    var body: some View {
        Form {
            Section("账户信息") {
                TextField("用户名", text: $username)
                SecureField("密码", text: $password)
                Toggle("记住我", isOn: $rememberMe)
            }

            Section("个人资料") {
                TextEditor(text: $bio)
                    .frame(height: 100)
            }

            Section("设置") {
                Toggle("启用通知", isOn: $notificationsEnabled)

                Picker("主题", selection: $selectedTheme) {
                    Text("浅色").tag(0)
                    Text("深色").tag(1)
                    Text("系统").tag(2)
                }
            }
        }
    }
}

// MARK: - 验证输入示例
struct ValidationExampleView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("4. 输入验证示例").font(.title)

            Group {
                TextField("邮箱", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) { oldValue, newValue in
                        isEmailValid = newValue.contains("@") && newValue.contains(".")
                    }

                if !isEmailValid {
                    Text("请输入有效的邮箱地址")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                SecureField("密码", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: password) { oldValue, newValue in
                        isPasswordValid = newValue.count >= 6
                    }

                if !isPasswordValid {
                    Text("密码至少需要6个字符")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

// MARK: - 搜索示例
struct SearchExampleView: View {
    @State private var searchText = ""
    @State private var selectedFilter = 0
    @State private var showOnlyAvailable = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5. 搜索示例").font(.title)

            Group {
                TextField("搜索...", text: $searchText)
                    .textFieldStyle(.roundedBorder)

                Picker("筛选", selection: $selectedFilter) {
                    Text("全部").tag(0)
                    Text("名称").tag(1)
                    Text("描述").tag(2)
                }
                .pickerStyle(.segmented)

                Toggle("只显示可用项", isOn: $showOnlyAvailable)
            }
        }
    }
}

// MARK: - 主视图
struct InputDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                TextInputExampleView()
                NumberInputExampleView()
                SelectionExampleView()
                ValidationExampleView()
                SearchExampleView()

                NavigationLink("查看完整表单示例") {
                    FormExampleView()
                        .navigationTitle("表单示例")
                }
            }
            .padding()
        }
        .navigationTitle("输入控件 Demo")
    }
}

// MARK: - 预览
#Preview {
    NavigationView {
        InputDemoView()
    }
}
```

### 运行说明

1. 创建新的 SwiftUI 项目
2. 创建新文件，命名为`InputDemoView.swift`
3. 将上述代码复制到文件中
4. 在项目的入口文件（通常是`XXXApp.swift`）中设置根视图：

```swift
import SwiftUI

@main
struct InputDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                InputDemoView()
            }
        }
    }
}
```

### Demo 包含功能

1. 文本输入示例

   - 基本文本输入
   - 密码输入
   - 多行文本输入
   - 邮箱输入

2. 数值输入示例

   - 滑块控件
   - 步进器
   - 进度显示

3. 选择控件示例

   - 选择器（分段样式）
   - 开关控件
   - 日期选择器

4. 验证输入示例

   - 邮箱验证
   - 密码验证
   - 实时反馈

5. 搜索示例

   - 搜索框
   - 筛选选项
   - 可用性过滤

6. 完整表单示例
   - 分组表单
   - 多类型输入
   - 设置选项

### 注意事项

1. Demo 包含了 ScrollView，适合在真机上滚动查看所有示例
2. 所有示例都有清晰的分组和标题
3. 包含了输入验证和即时反馈
4. 适配了深色模式
5. 支持动态字体大小
6. 添加了导航标题和层级
