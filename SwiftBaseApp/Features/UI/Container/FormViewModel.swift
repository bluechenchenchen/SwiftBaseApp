import SwiftUI

class FormViewModel: ObservableObject {
  // MARK: - Published Properties
  @Published var username = ""
  @Published var password = ""
  @Published var email = ""
  @Published var phone = ""
  @Published var address = ""
  @Published var bio = ""
  @Published var birthDate = Date()
  @Published var agreeToTerms = false
  
  // Validation States
  @Published var usernameError = ""
  @Published var passwordError = ""
  @Published var emailError = ""
  @Published var isFormValid = false
  
  // Dynamic Form
  @Published var dynamicFields: [FormField] = []
  
  // Settings
  @Published var notificationEnabled = false
  @Published var darkModeEnabled = false
  @Published var fontSize: CGFloat = 16
  
  // MARK: - Validation Methods
  func validateUsername() {
    if username.isEmpty {
      usernameError = "用户名不能为空"
    } else if username.count < 3 {
      usernameError = "用户名至少需要3个字符"
    } else if username.count > 20 {
      usernameError = "用户名不能超过20个字符"
    } else if !username.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "_" }) {
      usernameError = "用户名只能包含字母、数字和下划线"
    } else {
      usernameError = ""
    }
    validateForm()
  }
  
  func validatePassword() {
    if password.isEmpty {
      passwordError = "密码不能为空"
    } else if password.count < 6 {
      passwordError = "密码至少需要6个字符"
    } else if password.count > 20 {
      passwordError = "密码不能超过20个字符"
    } else if !password.contains(where: { $0.isLetter }) ||
                !password.contains(where: { $0.isNumber }) {
      passwordError = "密码必须包含字母和数字"
    } else {
      passwordError = ""
    }
    validateForm()
  }
  
  func validateEmail() {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    if email.isEmpty {
      emailError = "邮箱不能为空"
    } else if !emailPredicate.evaluate(with: email) {
      emailError = "请输入有效的邮箱地址"
    } else {
      emailError = ""
    }
    validateForm()
  }
  
  private func validateForm() {
    isFormValid = usernameError.isEmpty &&
    passwordError.isEmpty &&
    emailError.isEmpty &&
    !username.isEmpty &&
    !password.isEmpty &&
    !email.isEmpty &&
    agreeToTerms
  }
  
  // MARK: - Form Submission
  func submitForm() {
    guard isFormValid else { return }
    // 这里添加表单提交逻辑
    print("表单提交成功：")
    print("用户名：\(username)")
    print("邮箱：\(email)")
  }
  
  // MARK: - Dynamic Form Methods
  func addField() {
    let newField = FormField(
      id: UUID(),
      type: .text,
      title: "字段 \(dynamicFields.count + 1)",
      value: ""
    )
    dynamicFields.append(newField)
  }
  
  func removeField(at index: Int) {
    dynamicFields.remove(at: index)
  }
  
  func moveField(from source: IndexSet, to destination: Int) {
    dynamicFields.move(fromOffsets: source, toOffset: destination)
  }
}

// MARK: - Form Field Model
struct FormField: Identifiable {
  let id: UUID
  var type: FieldType
  var title: String
  var value: String
  
  enum FieldType {
    case text
    case secure
    case email
    case phone
    case number
  }
}
