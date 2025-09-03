import SwiftUI

struct BindingDemoView: View {
    var body: some View {
        ShowcaseList {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
              ShowcaseItem(title: "简单绑定示例", backgroundColor: Color.blue.opacity(0.1)) {
                BindingDemoSimpleBindingExample().padding()
                }
                
              ShowcaseItem(title: "文本输入绑定",backgroundColor: Color.green.opacity(0.1)) {
                    BindingDemoTextInputBindingExample().padding()
                }
                
                ShowcaseItem(title: "开关绑定",backgroundColor: Color.red.opacity(0.1)) {
                    BindingDemoToggleBindingExample().padding()
                }
            }
            
            // MARK: - 进阶用法
            ShowcaseSection("进阶用法") {
              ShowcaseItem(title: "表单验证绑定",backgroundColor: Color.orange.opacity(0.1)) {
                BindingDemoFormValidationExample().padding()
                }
                
                ShowcaseItem(title: "复杂状态绑定", backgroundColor: Color.purple.opacity(0.1)) {
                  BindingDemoComplexStateBindingExample().padding()
                }
                
              ShowcaseItem(title: "多个绑定组合", backgroundColor: Color.yellow.opacity(0.1)) {
                BindingDemoMultiBindingExample().padding()
                }
            }
            
            // MARK: - 动画效果
            ShowcaseSection("动画效果") {
              ShowcaseItem(title: "动画绑定", backgroundColor: Color.blue.opacity(0.1)) {
                BindingDemoAnimatedBindingExample().padding()
                }
                
              ShowcaseItem(title: "展开收起动画", backgroundColor: Color.green.opacity(0.1)) {
                BindingDemoExpandCollapseBindingExample().padding()
                }
                
              ShowcaseItem(title: "颜色变化动画",backgroundColor: Color.pink.opacity(0.1)) {
                BindingDemoColorChangeBindingExample().padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
              ShowcaseItem(title: "计算属性优化",backgroundColor: Color.purple.opacity(0.1)) {
                BindingDemoComputedPropertyExample().padding()
                }
                
              ShowcaseItem(title: "条件绑定",backgroundColor: Color.orange.opacity(0.1)) {
                BindingDemoConditionalBindingExample().padding()
                }
                
              ShowcaseItem(title: "延迟绑定", backgroundColor: Color.brown.opacity(0.1)) {
                BindingDemoLazyBindingExample().padding()
                }
            }
            
            // MARK: - 实际应用
            ShowcaseSection("实际应用") {
              ShowcaseItem(title: "用户资料编辑",backgroundColor: Color.random.opacity(0.1)) {
                BindingDemoUserProfileExample().padding()
                }
                
                ShowcaseItem(title: "设置页面",backgroundColor: Color.red.opacity(0.1)) {
                  BindingDemoSettingsExample().padding()
                }
                
                ShowcaseItem(title: "购物车",backgroundColor: Color.red.opacity(0.1)) {
                  BindingDemoShoppingCartExample().padding()
                }
            }
        }
        .navigationTitle("@Binding 数据传递")
    }
}

// MARK: - 基础用法示例
struct BindingDemoSimpleBindingExample: View {
    @State private var counter = 0
    
    var body: some View {
        VStack(spacing: 15) {
            Text("计数: \(counter)")
                .font(.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: 15) {
                BindingDemoCounterButton(counter: $counter, title: "增加", action: { $0 + 1 })
                BindingDemoCounterButton(counter: $counter, title: "减少", action: { $0 - 1 })
                BindingDemoCounterButton(counter: $counter, title: "重置", action: { _ in 0 })
            }
        }
       
    }
}

struct BindingDemoCounterButton: View {
    @Binding var counter: Int
    let title: String
    let action: (Int) -> Int
    
    var body: some View {
        Button(title) {
            counter = action(counter)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct BindingDemoTextInputBindingExample: View {
    @State private var text = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("父视图文本: \(text)")
                .font(.headline)
                .foregroundColor(.blue)
            
            BindingDemoTextInputChild(text: $text)
            
            Text("文本长度: \(text.count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
       
    }
}

struct BindingDemoTextInputChild: View {
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("输入文本", text: $text)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("清空") {
                    text = ""
                }
                .buttonStyle(.bordered)
                
                Button("设置默认") {
                    text = "默认文本"
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct BindingDemoToggleBindingExample: View {
    @State private var isOn = false
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("主开关状态: \(isOn ? "开启" : "关闭")")
                .font(.headline)
                .foregroundColor(isOn ? .green : .red)
            
            BindingDemoToggleChild(isOn: $isOn, showDetails: $showDetails)
            
            if showDetails {
                Text("详细信息已显示")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
       
    }
}

struct BindingDemoToggleChild: View {
    @Binding var isOn: Bool
    @Binding var showDetails: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Toggle("主开关", isOn: $isOn)
            
            Toggle("显示详情", isOn: $showDetails)
                .disabled(!isOn)
        }
    }
}

// MARK: - 进阶用法示例
struct BindingDemoFormValidationExample: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("表单验证示例")
                .font(.headline)
            
            BindingDemoValidatedTextField(
                title: "邮箱",
                text: $email,
                validator: { $0.contains("@") },
                errorMessage: "请输入有效的邮箱地址"
            )
            
            BindingDemoValidatedTextField(
                title: "密码",
                text: $password,
                validator: { $0.count >= 6 },
                errorMessage: "密码至少6位"
            )
            
            BindingDemoValidatedTextField(
                title: "确认密码",
                text: $confirmPassword,
                validator: { $0 == password },
                errorMessage: "两次密码不一致"
            )
        }
       
    }
}

struct BindingDemoValidatedTextField: View {
    let title: String
    @Binding var text: String
    let validator: (String) -> Bool
    let errorMessage: String
    
    @State private var isValid = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { _ in
                    isValid = validator(text)
                }
            
            if !isValid && !text.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}

struct BindingDemoComplexStateBindingExample: View {
    @State private var user = BindingDemoUser()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("用户信息")
                .font(.headline)
            
            BindingDemoUserInfoSection(user: $user)
            
            Text("完整信息: \(user.fullName) - \(user.email)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
    }
}

struct BindingDemoUser: Equatable {
    var firstName = ""
    var lastName = ""
    var email = ""
    var age = 0
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

struct BindingDemoUserInfoSection: View {
    @Binding var user: BindingDemoUser
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("名", text: $user.firstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("姓", text: $user.lastName)
                .textFieldStyle(.roundedBorder)
            
            TextField("邮箱", text: $user.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            Stepper("年龄: \(user.age)", value: $user.age, in: 0...120)
        }
    }
}

struct BindingDemoMultiBindingExample: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("多绑定组合")
                .font(.headline)
            
            BindingDemoFullNameView(
                firstName: $firstName,
                lastName: $lastName,
                isEditing: $isEditing
            )
            
            Text("全名: \(firstName) \(lastName)")
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
}

struct BindingDemoFullNameView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            if isEditing {
                TextField("名", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("姓", text: $lastName)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text("\(firstName) \(lastName)")
                    .font(.title2)
            }
            
            Button(isEditing ? "完成" : "编辑") {
                isEditing.toggle()
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - 动画效果示例
struct BindingDemoAnimatedBindingExample: View {
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 15) {
            Text("动画绑定")
                .font(.headline)
            
            BindingDemoAnimatedView(offset: $offset, scale: $scale)
            
            HStack(spacing: 15) {
                Button("移动") {
                    withAnimation(.spring()) {
                        offset = offset == 0 ? 50 : 0
                    }
                }
                .buttonStyle(.bordered)
                
                Button("缩放") {
                    withAnimation(.easeInOut) {
                        scale = scale == 1.0 ? 1.5 : 1.0
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        
    }
}

struct BindingDemoAnimatedView: View {
    @Binding var offset: CGFloat
    @Binding var scale: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 60, height: 60)
            .offset(x: offset)
            .scaleEffect(scale)
    }
}

struct BindingDemoExpandCollapseBindingExample: View {
    @State private var isExpanded = false
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("展开收起动画")
                .font(.headline)
            
            BindingDemoExpandableContent(
                isExpanded: $isExpanded,
                showDetails: $showDetails
            )
            
            Button(isExpanded ? "收起" : "展开") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isExpanded.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }
       
    }
}

struct BindingDemoExpandableContent: View {
    @Binding var isExpanded: Bool
    @Binding var showDetails: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
                .frame(
                    width: isExpanded ? 200 : 100,
                    height: isExpanded ? 100 : 50
                )
                .animation(.easeInOut(duration: 0.5), value: isExpanded)
            
            if isExpanded {
                Toggle("显示详情", isOn: $showDetails)
                    .transition(.opacity.combined(with: .scale))
                
                if showDetails {
                    Text("这是详细内容")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct BindingDemoColorChangeBindingExample: View {
    @State private var hue: Double = 0
    @State private var saturation: Double = 0.5
    @State private var brightness: Double = 0.8
    
    var body: some View {
        VStack(spacing: 15) {
            Text("颜色变化")
                .font(.headline)
            
            BindingDemoColorView(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness
            )
            
            BindingDemoColorControls(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness
            )
        }
      
    }
}

struct BindingDemoColorView: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
            .frame(width: 150, height: 100)
            .animation(.easeInOut(duration: 0.3), value: hue)
            .animation(.easeInOut(duration: 0.3), value: saturation)
            .animation(.easeInOut(duration: 0.3), value: brightness)
    }
}

struct BindingDemoColorControls: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("色相")
                Slider(value: $hue, in: 0...1)
            }
            
            HStack {
                Text("饱和度")
                Slider(value: $saturation, in: 0...1)
            }
            
            HStack {
                Text("亮度")
                Slider(value: $brightness, in: 0...1)
            }
        }
    }
}

// MARK: - 性能优化示例
struct BindingDemoComputedPropertyExample: View {
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("计算属性优化")
                .font(.headline)
            
            VStack(spacing: 10) {
                TextField("名", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("姓", text: $lastName)
                    .textFieldStyle(.roundedBorder)
            }
            
            // 使用计算属性而不是绑定
            Text("全名: \(fullName)")
                .font(.title3)
                .foregroundColor(.blue)
            
            Text("字符数: \(fullName.count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
    }
    
    // 计算属性，避免不必要的绑定
    private var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

struct BindingDemoConditionalBindingExample: View {
    @State private var isEnabled = true
    @State private var text = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("条件绑定")
                .font(.headline)
            
            Toggle("启用输入", isOn: $isEnabled)
            
            // 条件绑定
            BindingDemoConditionalTextField(
                text: conditionalBinding,
                isEnabled: isEnabled
            )
            
            Text("当前文本: \(text)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
       
    }
    
    // 条件绑定
    private var conditionalBinding: Binding<String> {
        Binding(
            get: { isEnabled ? text : "" },
            set: { if isEnabled { text = $0 } }
        )
    }
}

struct BindingDemoConditionalTextField: View {
    @Binding var text: String
    let isEnabled: Bool
    
    var body: some View {
        TextField("输入文本", text: $text)
            .textFieldStyle(.roundedBorder)
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

struct BindingDemoLazyBindingExample: View {
    @State private var showExpensiveView = false
    @State private var expensiveData = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("延迟绑定")
                .font(.headline)
            
            Toggle("显示昂贵视图", isOn: $showExpensiveView)
            
            if showExpensiveView {
                BindingDemoExpensiveView(data: $expensiveData)
                    .transition(.opacity.combined(with: .scale))
            }
            
            Button("加载数据") {
                expensiveData = "加载的数据 - \(Date())"
            }
            .buttonStyle(.bordered)
        }
    
    }
}

struct BindingDemoExpensiveView: View {
    @Binding var data: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("昂贵视图")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField("数据", text: $data)
                .textFieldStyle(.roundedBorder)
            
            Text("数据长度: \(data.count)")
                .font(.caption)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - 实际应用示例
struct BindingDemoUserProfileExample: View {
    @State private var profile = BindingDemoUserProfile()
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("用户资料编辑")
                .font(.headline)
            
            if isEditing {
                BindingDemoProfileEditView(profile: $profile)
            } else {
                BindingDemoProfileDisplayView(profile: profile)
            }
            
            Button(isEditing ? "保存" : "编辑") {
                isEditing.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
       
    }
}

struct BindingDemoUserProfile: Equatable {
    var name = ""
    var email = ""
    var phone = ""
    var bio = ""
}

struct BindingDemoProfileEditView: View {
    @Binding var profile: BindingDemoUserProfile
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("姓名", text: $profile.name)
                .textFieldStyle(.roundedBorder)
            
            TextField("邮箱", text: $profile.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            TextField("电话", text: $profile.phone)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.phonePad)
            
            TextField("个人简介", text: $profile.bio, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
        }
    }
}

struct BindingDemoProfileDisplayView: View {
    let profile: BindingDemoUserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("姓名: \(profile.name)")
            Text("邮箱: \(profile.email)")
            Text("电话: \(profile.phone)")
            Text("简介: \(profile.bio)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
       
    }
}

struct BindingDemoSettingsExample: View {
    @State private var settings = BindingDemoAppSettings()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("应用设置")
                .font(.headline)
            
            BindingDemoSettingsForm(settings: $settings)
            
            BindingDemoSettingsSummary(settings: settings)
        }
       
    }
}

struct BindingDemoAppSettings: Equatable {
    var isDarkMode = false
    var notificationsEnabled = true
    var autoSave = true
    var language = "zh-CN"
    var fontSize: Double = 16
}

struct BindingDemoSettingsForm: View {
    @Binding var settings: BindingDemoAppSettings
    
    var body: some View {
        VStack(spacing: 10) {
            Toggle("深色模式", isOn: $settings.isDarkMode)
            
            Toggle("启用通知", isOn: $settings.notificationsEnabled)
            
            Toggle("自动保存", isOn: $settings.autoSave)
            
            Picker("语言", selection: $settings.language) {
                Text("中文").tag("zh-CN")
                Text("English").tag("en-US")
                Text("日本語").tag("ja-JP")
            }
            .pickerStyle(.menu)
            
            HStack {
                Text("字体大小")
                Slider(value: $settings.fontSize, in: 12...24, step: 1)
                Text("\(Int(settings.fontSize))")
            }
        }
    }
}

struct BindingDemoSettingsSummary: View {
    let settings: BindingDemoAppSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("当前设置:")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("• 深色模式: \(settings.isDarkMode ? "开启" : "关闭")")
            Text("• 通知: \(settings.notificationsEnabled ? "开启" : "关闭")")
            Text("• 自动保存: \(settings.autoSave ? "开启" : "关闭")")
            Text("• 语言: \(settings.language)")
            Text("• 字体大小: \(Int(settings.fontSize))")
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
       
    }
}

struct BindingDemoShoppingCartExample: View {
    @State private var cart = BindingDemoShoppingCart()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("购物车")
                .font(.headline)
            
            BindingDemoCartItemsView(cart: $cart)
            
            BindingDemoCartSummaryView(cart: cart)
        }
      
    }
}

struct BindingDemoShoppingCart: Equatable {
    var items: [BindingDemoCartItem] = []
    var isExpanded = false
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
}

struct BindingDemoCartItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var price: Double
    var quantity: Int
}

struct BindingDemoCartItemsView: View {
    @Binding var cart: BindingDemoShoppingCart
    
    var body: some View {
        VStack(spacing: 10) {
            if cart.items.isEmpty {
                Text("购物车为空")
                    .foregroundColor(.secondary)
            } else {
                ForEach($cart.items) { $item in
                    BindingDemoCartItemRow(item: $item)
                }
            }
            
            Button("添加商品") {
                let newItem = BindingDemoCartItem(
                    name: "商品 \(cart.items.count + 1)",
                    price: Double.random(in: 10...100),
                    quantity: 1
                )
                cart.items.append(newItem)
            }
            .buttonStyle(.bordered)
        }
    }
}

struct BindingDemoCartItemRow: View {
    @Binding var item: BindingDemoCartItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.subheadline)
                Text("¥\(item.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Stepper("数量: \(item.quantity)", value: $item.quantity, in: 1...10)
                .labelsHidden()
            
            Text("¥\(item.price * Double(item.quantity), specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct BindingDemoCartSummaryView: View {
    let cart: BindingDemoShoppingCart
    
    var body: some View {
        VStack(spacing: 8) {
            Text("总计: \(cart.itemCount) 件商品")
                .font(.subheadline)
            
            Text("总价: ¥\(cart.totalPrice, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BindingDemoView()
    }
}
