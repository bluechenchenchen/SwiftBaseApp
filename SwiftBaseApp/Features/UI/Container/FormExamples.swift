import SwiftUI

// MARK: - Validation Form Example
struct ValidationFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @FocusState private var focusedField: Field?
  
  enum Field {
    case username
    case password
    case email
  }
  
  var body: some View {
    Form {
      Section("账户信息") {
        TextField("用户名", text: $viewModel.username)
          .focused($focusedField, equals: .username)
          .textContentType(.username)
          .onChange(of: viewModel.username) { _ in
            viewModel.validateUsername()
          }
          .overlay(alignment: .trailing) {
            if !viewModel.usernameError.isEmpty {
              Image(systemName: "exclamationmark.circle")
                .foregroundColor(.red)
            }
          }
        
        SecureField("密码", text: $viewModel.password)
          .focused($focusedField, equals: .password)
          .textContentType(.password)
          .onChange(of: viewModel.password) { _ in
            viewModel.validatePassword()
          }
          .overlay(alignment: .trailing) {
            if !viewModel.passwordError.isEmpty {
              Image(systemName: "exclamationmark.circle")
                .foregroundColor(.red)
            }
          }
        
        TextField("电子邮件", text: $viewModel.email)
          .focused($focusedField, equals: .email)
          .textContentType(.emailAddress)
          .keyboardType(.emailAddress)
          .onChange(of: viewModel.email) { _ in
            viewModel.validateEmail()
          }
          .overlay(alignment: .trailing) {
            if !viewModel.emailError.isEmpty {
              Image(systemName: "exclamationmark.circle")
                .foregroundColor(.red)
            }
          }
      }
      
      Section("验证状态") {
        if !viewModel.usernameError.isEmpty {
          Text(viewModel.usernameError)
            .foregroundColor(.red)
        }
        if !viewModel.passwordError.isEmpty {
          Text(viewModel.passwordError)
            .foregroundColor(.red)
        }
        if !viewModel.emailError.isEmpty {
          Text(viewModel.emailError)
            .foregroundColor(.red)
        }
      }
      
      Section {
        Button("提交") {
          viewModel.submitForm()
        }
        .disabled(!viewModel.isFormValid)
      }
    }
    .onSubmit {
      switch focusedField {
      case .username:
        focusedField = .password
      case .password:
        focusedField = .email
      case .email:
        focusedField = nil
      case .none:
        break
      }
    }
  }
}

// MARK: - Styled Form Example
struct StyledFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    Form {
      Section {
        Toggle("深色模式", isOn: $viewModel.darkModeEnabled)
        
        VStack(alignment: .leading) {
          Text("字体大小: \(Int(viewModel.fontSize))")
          Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
        }
      }
      .formStyle(.grouped)
      
      Section("自定义样式") {
        TextField("用户名", text: $viewModel.username)
          .textFieldStyle(.roundedBorder)
          .padding()
          .background(Color.secondary.opacity(0.1))
          .cornerRadius(8)
        
        TextField("邮箱", text: $viewModel.email)
          .textFieldStyle(.roundedBorder)
          .padding()
          .background(Color.secondary.opacity(0.1))
          .cornerRadius(8)
      }
      .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
    }
    .scrollContentBackground(.hidden)
    .background {
      LinearGradient(
        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
    }
  }
}

// MARK: - Accessibility Form Example
struct AccessibilityFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @Environment(\.sizeCategory) var sizeCategory
  
  var body: some View {
    Form {
      Section("无障碍支持") {
        TextField("用户名", text: $viewModel.username)
          .accessibilityLabel("用户名输入框")
          .accessibilityHint("请输入您的用户名，支持字母、数字和下划线")
        
        SecureField("密码", text: $viewModel.password)
          .accessibilityLabel("密码输入框")
          .accessibilityHint("请输入您的密码，至少6个字符")
        
        Toggle("通知", isOn: $viewModel.notificationEnabled)
          .accessibilityLabel("通知开关")
          .accessibilityHint("开启或关闭通知提醒")
      }
      
      Section("动态字体") {
        Text("当前字体大小")
          .font(.body)
          .dynamicTypeSize(...DynamicTypeSize.accessibility5)
        
        Text("支持动态字体的文本")
          .font(.body)
          .dynamicTypeSize(...DynamicTypeSize.accessibility5)
      }
      
      Section("辅助功能动作") {
        Text("可调整的值: \(Int(viewModel.fontSize))")
          .accessibilityValue("\(Int(viewModel.fontSize))")
          .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
              viewModel.fontSize += 1
            case .decrement:
              viewModel.fontSize -= 1
            @unknown default:
              break
            }
          }
      }
    }
  }
}

// MARK: - Localization Form Example
struct LocalizationFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @Environment(\.locale) var locale
  @Environment(\.layoutDirection) var layoutDirection
  
  var body: some View {
    Form {
      Section("本地化文本") {
        Text("welcome_message")
          .environment(\.locale, .current)
        
        TextField(NSLocalizedString("username", comment: "Username field"), text: $viewModel.username)
        
        Button(String(localized: "submit_button")) {
          viewModel.submitForm()
        }
      }
      
      Section("日期和数字格式化") {
        Text(viewModel.birthDate, style: .date)
        Text(123.45, format: .currency(code: locale.currency?.identifier ?? "USD"))
        Text(0.75, format: .percent)
      }
      
      Section("布局方向") {
        HStack {
          if layoutDirection == .leftToRight {
            Text("左对齐文本")
            Spacer()
            Text("右对齐文本")
          } else {
            Text("右对齐文本")
            Spacer()
            Text("左对齐文本")
          }
        }
      }
    }
  }
}

// MARK: - Performance Form Example
struct PerformanceFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @State private var isAdvancedSectionLoaded = false
  @State private var cache: [String: Any] = [:]
  
  var body: some View {
    Form {
      Section("延迟加载") {
        // 基础内容直接加载
        TextField("用户名", text: $viewModel.username)
        TextField("邮箱", text: $viewModel.email)
        
        // 高级内容延迟加载
        if isAdvancedSectionLoaded {
          VStack {
            TextField("详细地址", text: $viewModel.address)
            TextField("电话号码", text: $viewModel.phone)
          }
        } else {
          ProgressView("加载中...")
            .onAppear {
              // 模拟延迟加载
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isAdvancedSectionLoaded = true
              }
            }
        }
      }
      
      Section("缓存优化") {
        ForEach(viewModel.dynamicFields) { field in
          if let cached = cache[field.id.uuidString] {
            Text("缓存的值: \(cached as? String ?? "")")
          } else {
            TextField(field.title, text: binding(for: field))
              .onAppear {
                // 模拟缓存
                cache[field.id.uuidString] = field.value
              }
          }
        }
      }
      
      Section("批量更新") {
        Button("批量添加字段") {
          // 使用批处理避免多次重绘
          withAnimation {
            for _ in 1...5 {
              viewModel.addField()
            }
          }
        }
      }
    }
    .onDisappear {
      // 清理缓存
      cache.removeAll()
    }
  }
  
  private func binding(for field: FormField) -> Binding<String> {
    Binding(
      get: { field.value },
      set: { newValue in
        if let index = viewModel.dynamicFields.firstIndex(where: { $0.id == field.id }) {
          viewModel.dynamicFields[index].value = newValue
          // 更新缓存
          cache[field.id.uuidString] = newValue
        }
      }
    )
  }
}
