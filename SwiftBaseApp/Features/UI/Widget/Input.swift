import SwiftUI
import Combine

// MARK: - 主视图
struct InputDemoView: View {
  // MARK: - 基础输入状态
  @State private var basicInputText = ""
  @State private var iconInputText = ""
  @State private var secureText = ""
  @State private var longText = ""
  
  // MARK: - 特殊输入状态
  @State private var emailText = ""
  @State private var numberText = ""
  @State private var urlText = ""
  @State private var phoneText = ""
  
  // MARK: - 格式化输入状态
  @State private var currencyValue = 0.0
  @State private var dateValue = Date()
  @State private var limitedText = ""
  @State private var numberValue = 0
  
  // MARK: - 数值控制状态
  @State private var sliderValue = 50.0
  @State private var stepperValue = 5
  @State private var progress = 0.5
  
  // MARK: - 选择控件状态
  @State private var selectedOption = 0
  @State private var isToggleOn = false
  @State private var selectedDate = Date()
  
  // MARK: - 验证状态
  @State private var validationEmail = ""
  @State private var validationPassword = ""
  @State private var isEmailValid = true
  @State private var isPasswordValid = true
  
  // MARK: - 搜索状态
  @State private var searchText = ""
  @State private var selectedFilter = 0
  @State private var showOnlyAvailable = false
  
  // MARK: - 焦点示例状态
  @State private var focusText1 = ""
  @State private var focusText2 = ""
  
  let options = ["选项1", "选项2", "选项3"]
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础文本输入
      ShowcaseSection("基础文本输入") {
        // 1. 单行输入
        ShowcaseItem(title: "单行输入") {
          VStack(spacing: 10) {
            TextField("基本输入", text: $basicInputText)
              .textFieldStyle(.roundedBorder)
            
            TextField("带图标的输入", text: $iconInputText)
              .textFieldStyle(.roundedBorder)
              .overlay(
                Image(systemName: "magnifyingglass")
                  .foregroundColor(.gray)
                  .padding(.horizontal),
                alignment: .trailing
              )
          }
        }
        
        // 2. 密码输入
        ShowcaseItem(title: "密码输入") {
          SecureField("密码输入", text: $secureText)
            .textFieldStyle(.roundedBorder)
        }
        
        // 3. 多行输入
        ShowcaseItem(title: "多行输入") {
          TextEditor(text: $longText)
            .frame(height: 100)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2))
            )
        }
      }
      
      // MARK: - 特殊输入类型
      ShowcaseSection("特殊输入类型") {
        // 1. 邮箱输入
        ShowcaseItem(title: "邮箱输入") {
          TextField("邮箱", text: $emailText)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textContentType(.emailAddress)
        }
        
        // 2. 数字输入
        ShowcaseItem(title: "数字输入") {
          TextField("数字", value: $numberValue, format: .number)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
        }
        
        // 3. URL输入
        ShowcaseItem(title: "URL输入") {
          TextField("网址", text: $urlText)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.URL)
            .textContentType(.URL)
        }
      }
      
      // MARK: - 数值控制
      ShowcaseSection("数值控制") {
        // 1. 滑块
        ShowcaseItem(title: "滑块") {
          VStack {
            Text("值: \(sliderValue, specifier: "%.1f")")
            Slider(value: $sliderValue, in: 0...100) {
              Text("滑块")
            } minimumValueLabel: {
              Text("0")
            } maximumValueLabel: {
              Text("100")
            }
          }
        }
        
        // 2. 步进器
        ShowcaseItem(title: "步进器") {
          Stepper("值: \(stepperValue)", value: $stepperValue, in: 0...10)
        }
        
        // 3. 进度指示
        ShowcaseItem(title: "进度指示") {
          VStack {
            ProgressView("进度", value: progress)
            Slider(value: $progress)
          }
        }
      }
      
      // MARK: - 选择控件
      ShowcaseSection("选择控件") {
        // 1. 分段选择器
        ShowcaseItem(title: "分段选择器") {
          Picker("选择器", selection: $selectedOption) {
            ForEach(0..<options.count, id: \.self) { index in
              Text(options[index]).tag(index)
            }
          }
          .pickerStyle(.segmented)
        }
        
        // 2. 开关控件
        ShowcaseItem(title: "开关控件") {
          Toggle("开关控件", isOn: $isToggleOn)
        }
        
        // 3. 日期选择
        ShowcaseItem(title: "日期选择") {
          DatePicker(
            "选择日期",
            selection: $selectedDate,
            displayedComponents: [.date, .hourAndMinute]
          )
        }
      }
      
      // MARK: - 输入验证
      ShowcaseSection("输入验证") {
        // 1. 实时验证
        ShowcaseItem(title: "实时验证") {
          VStack(alignment: .leading, spacing: 10) {
            TextField("邮箱", text: $validationEmail)
              .textFieldStyle(.roundedBorder)
              .onChange(of: validationEmail) { oldValue, newValue in
                isEmailValid = newValue.contains("@") && newValue.contains(".")
              }
            
            if !isEmailValid {
              Text("请输入有效的邮箱地址")
                .font(.caption)
                .foregroundStyle(.red)
            }
          }
        }
        
        // 2. 密码验证
        ShowcaseItem(title: "密码验证") {
          VStack(alignment: .leading, spacing: 10) {
            SecureField("密码", text: $validationPassword)
              .textFieldStyle(.roundedBorder)
              .onChange(of: validationPassword) { oldValue, newValue in
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
      
      // MARK: - 搜索和筛选
      ShowcaseSection("搜索和筛选") {
        // 1. 搜索栏
        ShowcaseItem(title: "搜索栏") {
          TextField("搜索...", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .overlay(
              HStack {
                Spacer()
                if !searchText.isEmpty {
                  Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.gray)
                  }
                }
              }.padding(.horizontal)
            )
        }
        
        // 2. 筛选选项
        ShowcaseItem(title: "筛选选项") {
          VStack(spacing: 10) {
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
      
      // MARK: - 输入样式
      ShowcaseSection("输入样式") {
        // 1. 自定义输入框样式
        ShowcaseItem(title: "自定义样式") {
          VStack(spacing: 10) {
            // 圆角边框样式
            TextField("圆角边框", text: $basicInputText)
              .textFieldStyle(.roundedBorder)
            
            // 自定义边框样式
            TextField("自定义边框", text: $basicInputText)
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.blue, lineWidth: 2)
              )
            
            // 材质背景样式
            TextField("材质背景", text: $basicInputText)
              .padding()
              .background(.ultraThinMaterial)
              .cornerRadius(8)
          }
        }
        
        // 2. 输入框状态
        ShowcaseItem(title: "输入状态") {
          VStack(spacing: 10) {
            // 禁用状态
            TextField("禁用状态", text: .constant(""))
              .textFieldStyle(.roundedBorder)
              .disabled(true)
            
            // 只读状态
            TextField("只读状态", text: .constant("只读文本"))
              .textFieldStyle(.roundedBorder)
              .disabled(true)
              .foregroundColor(.primary)
          }
        }
      }
      
      // MARK: - 高级输入特性
      ShowcaseSection("高级输入特性") {
        // 1. 输入建议
        ShowcaseItem(title: "输入建议") {
          TextField("输入城市", text: $basicInputText)
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        
        // 2. 格式化输入
        ShowcaseItem(title: "格式化输入") {
          VStack(spacing: 10) {
            // 数字格式化
            TextField("金额", value: $currencyValue, format: .currency(code: "CNY"))
              .textFieldStyle(.roundedBorder)
              .keyboardType(.decimalPad)
            
            // 日期格式化
            TextField("日期", value: $dateValue, format: .dateTime)
              .textFieldStyle(.roundedBorder)
          }
        }
        
        // 3. 输入限制
        ShowcaseItem(title: "输入限制") {
          VStack(spacing: 10) {
            // 字符数限制
            TextField("最多输入5个字符", text: $limitedText)
              .textFieldStyle(.roundedBorder)
              .onChange(of: limitedText) { oldValue, newValue in
                if newValue.count > 5 {
                  limitedText = String(newValue.prefix(5))
                }
              }
            
            // 数字范围限制
            TextField("数字 (0-100)", value: $numberValue, format: .number)
              .textFieldStyle(.roundedBorder)
              .onChange(of: numberValue) { oldValue, newValue in
                if newValue < 0 { numberValue = 0 }
                if newValue > 100 { numberValue = 100 }
              }
          }
        }
      }
      
      // MARK: - 键盘控制
      ShowcaseSection("键盘控制") {
        // 1. 键盘类型
        ShowcaseItem(title: "键盘类型") {
          VStack(spacing: 10) {
            TextField("数字键盘", text: $numberText)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.numberPad)
            
            TextField("电话键盘", text: $phoneText)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.phonePad)
            
            TextField("邮箱键盘", text: $emailText)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.emailAddress)
          }
        }
        
        // 2. 提交按钮
        ShowcaseItem(title: "提交按钮") {
          VStack(spacing: 10) {
            TextField("回车键显示'搜索'", text: $basicInputText)
              .textFieldStyle(.roundedBorder)
              .submitLabel(.search)
            
            TextField("回车键显示'继续'", text: $basicInputText)
              .textFieldStyle(.roundedBorder)
              .submitLabel(.continue)
            
            TextField("回车键显示'完成'", text: $basicInputText)
              .textFieldStyle(.roundedBorder)
              .submitLabel(.done)
              .onSubmit {
                // 处理提交事件
                print("提交输入")
              }
          }
        }
        
        // 3. 输入事件
        ShowcaseItem(title: "输入事件") {
          TextField("输入时触发事件", text: $basicInputText)
            .textFieldStyle(.roundedBorder)
            .onChange(of: basicInputText) { oldValue, newValue in
              print("输入变化: \(oldValue) -> \(newValue)")
            }
            .onSubmit {
              print("提交输入")
            }
        }
      }
      
      // MARK: - 焦点管理
      ShowcaseSection("焦点管理") {
        // 1. 焦点控制
        ShowcaseItem(title: "焦点控制") {
          SingleFocusExample(text: $focusText1)
        }
        
        // 2. 多输入框焦点
        ShowcaseItem(title: "多输入框焦点") {
          MultiFocusExample(text1: $focusText1, text2: $focusText2)
        }
      }
      
      // MARK: - 表单示例
      ShowcaseSection("表单示例") {
        ShowcaseItem(title: "完整表单") {
          NavigationLink("查看完整表单示例") {
            FormExampleView()
              .navigationTitle("表单示例")
          }
        }
      }
    }.listRowInsets(EdgeInsets(top:10,leading:10,bottom:10,trailing:10,))
      .listRowSpacing(10)
    .navigationTitle("Input 示例")
  }
}

// MARK: - 预览
// MARK: - 表单示例视图
struct FormExampleView: View {
  @State private var username = ""
  @State private var password = ""
  @State private var rememberMe = false
  @State private var bio = ""
  @State private var notificationsEnabled = true
  @State private var selectedTheme = 0
  @State private var birthday = Date()
  @State private var favoriteColor = Color.blue
  @State private var receiveNewsletter = true
  @State private var profileVisibility = 0
  
  var body: some View {
    Form {
      // MARK: - 账户信息
      Section("账户信息") {
        TextField("用户名", text: $username)
          .textContentType(.username)
        
        SecureField("密码", text: $password)
          .textContentType(.password)
        
        Toggle("记住我", isOn: $rememberMe)
      }
      
      // MARK: - 个人资料
      Section("个人资料") {
        DatePicker("生日", selection: $birthday, displayedComponents: .date)
        
        ColorPicker("喜欢的颜色", selection: $favoriteColor)
        
        Picker("个人资料可见性", selection: $profileVisibility) {
          Text("所有人").tag(0)
          Text("仅好友").tag(1)
          Text("仅自己").tag(2)
        }
        
        TextEditor(text: $bio)
          .frame(height: 100)
      }
      
      // MARK: - 通知设置
      Section("通知设置") {
        Toggle("启用通知", isOn: $notificationsEnabled)
        
        if notificationsEnabled {
          Toggle("接收新闻通讯", isOn: $receiveNewsletter)
        }
      }
      
      // MARK: - 主题设置
      Section("主题设置") {
        Picker("主题", selection: $selectedTheme) {
          Text("浅色").tag(0)
          Text("深色").tag(1)
          Text("系统").tag(2)
        }
        .pickerStyle(.segmented)
      }
      
      // MARK: - 操作按钮
      Section {
        Button(action: {
          // 保存操作
        }) {
          Text("保存更改")
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        
        Button(action: {
          // 重置操作
        }) {
          Text("重置表单")
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
      }
    }
  }
}

// MARK: - 焦点管理示例视图
struct SingleFocusExample: View {
  @Binding var text: String
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack(spacing: 10) {
      TextField("自动获取焦点", text: $text)
        .textFieldStyle(.roundedBorder)
        .focused($isFocused)
        .onAppear { isFocused = true }
      
      Button(isFocused ? "失去焦点" : "获取焦点") {
        isFocused.toggle()
      }
    }
  }
}

struct MultiFocusExample: View {
  @Binding var text1: String
  @Binding var text2: String
  @FocusState private var focusedField: Field?
  
  enum Field {
    case field1, field2
  }
  
  var body: some View {
    VStack(spacing: 10) {
      TextField("输入框 1", text: $text1)
        .textFieldStyle(.roundedBorder)
        .focused($focusedField, equals: .field1)
        .submitLabel(.next)
        .onSubmit {
          focusedField = .field2
        }
      
      TextField("输入框 2", text: $text2)
        .textFieldStyle(.roundedBorder)
        .focused($focusedField, equals: .field2)
        .submitLabel(.done)
        .onSubmit {
          focusedField = nil
        }
    }
  }
}

#Preview {
  NavigationView {
    InputDemoView()
  }
}
