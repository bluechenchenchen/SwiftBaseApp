import SwiftUI

// MARK: - Form Demo View
struct FormDemoView: View {
  // MARK: - Properties
  @StateObject private var viewModel = FormViewModel()
  @State private var selectedDemo = 0
  let demos = ["基础表单", "分组表单", "动态表单", "验证表单", "样式表单", "无障碍表单", "本地化表单", "性能优化"]
  
  // MARK: - Body
  var body: some View {
    TabView(selection: $selectedDemo) {
      BasicFormExample(viewModel: viewModel)
        .tabItem {
          Label("基础表单", systemImage: "1.circle")
        }
        .tag(0)
      
      GroupedFormExample(viewModel: viewModel)
        .tabItem {
          Label("分组表单", systemImage: "2.circle")
        }
        .tag(1)
      
      DynamicFormExample(viewModel: viewModel)
        .tabItem {
          Label("动态表单", systemImage: "3.circle")
        }
        .tag(2)
      
      ValidationFormExample(viewModel: viewModel)
        .tabItem {
          Label("验证表单", systemImage: "4.circle")
        }
        .tag(3)
      
      StyledFormExample(viewModel: viewModel)
        .tabItem {
          Label("样式表单", systemImage: "5.circle")
        }
        .tag(4)
      
      AccessibilityFormExample(viewModel: viewModel)
        .tabItem {
          Label("无障碍", systemImage: "6.circle")
        }
        .tag(5)
      
      LocalizationFormExample(viewModel: viewModel)
        .tabItem {
          Label("本地化", systemImage: "7.circle")
        }
        .tag(6)
      
      PerformanceFormExample(viewModel: viewModel)
        .tabItem {
          Label("性能优化", systemImage: "8.circle")
        }
        .tag(7)
    }
    .navigationTitle(demos[selectedDemo])
  }
}

// MARK: - Basic Form Example
struct BasicFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  
  var body: some View {
    Form {
      Section("基本信息") {
        TextField("用户名", text: $viewModel.username)
          .textContentType(.username)
          .autocapitalization(.none)
          .onChange(of: viewModel.username) { _ in
            viewModel.validateUsername()
          }
        if !viewModel.usernameError.isEmpty {
          Text(viewModel.usernameError)
            .foregroundColor(.red)
            .font(.caption)
        }
        
        SecureField("密码", text: $viewModel.password)
          .textContentType(.password)
          .onChange(of: viewModel.password) { _ in
            viewModel.validatePassword()
          }
        if !viewModel.passwordError.isEmpty {
          Text(viewModel.passwordError)
            .foregroundColor(.red)
            .font(.caption)
        }
        
        TextField("电子邮件", text: $viewModel.email)
          .textContentType(.emailAddress)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .onChange(of: viewModel.email) { _ in
            viewModel.validateEmail()
          }
        if !viewModel.emailError.isEmpty {
          Text(viewModel.emailError)
            .foregroundColor(.red)
            .font(.caption)
        }
      }
      
      Section {
        Toggle("同意服务条款", isOn: $viewModel.agreeToTerms)
        
        Button("提交") {
          viewModel.submitForm()
        }
        .disabled(!viewModel.isFormValid)
      }
    }
  }
}

// MARK: - Grouped Form Example
struct GroupedFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  @State private var showAdvancedSettings = false
  
  var body: some View {
    Form {
      Section("个人信息") {
        TextField("姓名", text: $viewModel.username)
        DatePicker("生日", selection: $viewModel.birthDate, displayedComponents: .date)
        TextField("简介", text: $viewModel.bio)
      }
      
      Section("联系方式") {
        TextField("电话", text: $viewModel.phone)
          .keyboardType(.phonePad)
        TextField("地址", text: $viewModel.address)
      }
      
      Section {
        Toggle("显示高级设置", isOn: $showAdvancedSettings.animation())
        
        if showAdvancedSettings {
          Toggle("通知", isOn: $viewModel.notificationEnabled)
          Toggle("深色模式", isOn: $viewModel.darkModeEnabled)
        }
      }
    }
  }
}

// MARK: - Dynamic Form Example
struct DynamicFormExample: View {
  @ObservedObject var viewModel: FormViewModel
  
  var body: some View {
    Form {
      ForEach(viewModel.dynamicFields) { field in
        Section(field.title) {
          switch field.type {
          case .text:
            TextField("输入文本", text: binding(for: field))
          case .secure:
            SecureField("输入密码", text: binding(for: field))
          case .email:
            TextField("输入邮箱", text: binding(for: field))
              .keyboardType(.emailAddress)
          case .phone:
            TextField("输入电话", text: binding(for: field))
              .keyboardType(.phonePad)
          case .number:
            TextField("输入数字", text: binding(for: field))
              .keyboardType(.numberPad)
          }
        }
      }
      .onDelete { indexSet in
        indexSet.forEach { index in
          viewModel.removeField(at: index)
        }
      }
      .onMove { source, destination in
        viewModel.moveField(from: source, to: destination)
      }
      
      Button("添加字段") {
        viewModel.addField()
      }
    }
    .toolbar {
      EditButton()
    }
  }
  
  private func binding(for field: FormField) -> Binding<String> {
    Binding(
      get: { field.value },
      set: { newValue in
        if let index = viewModel.dynamicFields.firstIndex(where: { $0.id == field.id }) {
          viewModel.dynamicFields[index].value = newValue
        }
      }
    )
  }
}

// MARK: - Preview
#Preview {
  NavigationStack {
    FormDemoView()
  }
}
