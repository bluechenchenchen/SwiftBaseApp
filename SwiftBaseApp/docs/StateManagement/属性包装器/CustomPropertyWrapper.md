# 自定义属性包装器

## 基本介绍

### 概念解释

自定义属性包装器（Custom Property Wrapper）是 Swift 5.1 引入的强大功能，允许开发者创建可重用的属性行为。在 SwiftUI 中，这个概念类似于前端开发中的**自定义 Hook**（React）或**组合式函数**（Vue 3），用于封装和重用状态逻辑。

### 使用场景

- 数据验证和转换
- 属性访问控制
- 缓存和持久化
- 数据格式化
- 用户偏好设置
- 表单输入验证
- 线程安全访问
- 延迟初始化

### 主要特性

- **封装复用**: 将复杂的属性行为封装成可重用的组件
- **透明使用**: 使用时语法简洁，就像普通属性一样
- **投影值**: 可以通过 `$` 符号访问额外的功能
- **组合性**: 可以与其他属性包装器组合使用
- **类型安全**: 编译时类型检查，避免运行时错误

## 基础用法

### 基本示例

#### 1. 简单的验证包装器

```swift
@propertyWrapper
struct Clamped<Value: Comparable> {
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
}

// 使用示例
struct SliderView: View {
    @Clamped(0...100) var volume = 50

    var body: some View {
        VStack {
            Text("音量: \(volume)")
            Slider(value: Binding(
                get: { Double(volume) },
                set: { volume = Int($0) }
            ), in: 0...100)
        }
    }
}
```

#### 2. 用户偏好设置包装器

```swift
@propertyWrapper
struct UserDefault<T> {
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
}

// 使用示例
struct SettingsView: View {
    @UserDefault(key: "username", defaultValue: "") var username
    @UserDefault(key: "isDarkMode", defaultValue: false) var isDarkMode
    @UserDefault(key: "fontSize", defaultValue: 16) var fontSize

    var body: some View {
        Form {
            TextField("用户名", text: $username)
            Toggle("深色模式", isOn: $isDarkMode)
            Stepper("字体大小: \(fontSize)", value: $fontSize, in: 12...24)
        }
    }
}
```

### 常用属性和方法

#### 包装器的核心组件

1. **wrappedValue**: 包装的实际值
2. **projectedValue**: 投影值（可选，通过 `$` 访问）
3. **init**: 初始化器

#### 投影值示例

```swift
@propertyWrapper
struct Validated<T> {
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

// 使用示例
struct EmailForm: View {
    @Validated(validator: { $0.contains("@") }) var email = ""

    var body: some View {
        VStack {
            TextField("邮箱", text: $email)
                .textFieldStyle(.roundedBorder)
                .foregroundColor($email ? .primary : .red)

            Text($email ? "邮箱格式正确" : "请输入有效邮箱")
                .foregroundColor($email ? .green : .red)
        }
    }
}
```

### 使用注意事项

- 属性包装器只能用于变量，不能用于常量
- 包装器的初始化在属性声明时完成
- 避免在包装器中进行耗时操作
- 考虑线程安全问题

## 样式和自定义

### 内置样式模式

#### 1. 缓存包装器

```swift
@propertyWrapper
struct Cached<T> {
    private var value: T?
    private let loader: () -> T

    init(loader: @escaping () -> T) {
        self.loader = loader
    }

    var wrappedValue: T {
        mutating get {
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
}
```

#### 2. 格式化包装器

```swift
@propertyWrapper
struct Formatted {
    private var value: String = ""
    private let formatter: (String) -> String

    init(formatter: @escaping (String) -> String) {
        self.formatter = formatter
    }

    var wrappedValue: String {
        get { value }
        set { value = formatter(newValue) }
    }
}

// 使用示例
struct PhoneNumberView: View {
    @Formatted(formatter: { phone in
        let digits = phone.filter { $0.isNumber }
        guard digits.count >= 3 else { return digits }

        if digits.count <= 6 {
            return String(digits.prefix(3)) + "-" + String(digits.dropFirst(3))
        } else {
            return String(digits.prefix(3)) + "-" +
                   String(digits.dropFirst(3).prefix(3)) + "-" +
                   String(digits.dropFirst(6).prefix(4))
        }
    }) var phoneNumber

    var body: some View {
        TextField("电话号码", text: $phoneNumber)
            .keyboardType(.numberPad)
    }
}
```

### 自定义修饰符

#### 线程安全包装器

```swift
@propertyWrapper
struct ThreadSafe<T> {
    private var value: T
    private let queue = DispatchQueue(label: "thread-safe-property", attributes: .concurrent)

    init(wrappedValue: T) {
        self.value = wrappedValue
    }

    var wrappedValue: T {
        get {
            queue.sync { value }
        }
        set {
            queue.async(flags: .barrier) {
                self.value = newValue
            }
        }
    }
}
```

### 主题适配

#### 响应式主题包装器

```swift
@propertyWrapper
struct ThemeAware<T> {
    private let lightValue: T
    private let darkValue: T

    init(light: T, dark: T) {
        self.lightValue = light
        self.darkValue = dark
    }

    var wrappedValue: T {
        // 这里需要访问当前主题状态
        // 实际实现中可能需要依赖环境值
        return lightValue // 简化示例
    }
}
```

## 高级特性

### 组合使用

#### 多个包装器的协作

```swift
struct AdvancedForm: View {
    @UserDefault(key: "savedEmail", defaultValue: "")
    @Validated(validator: { email in
        email.contains("@") && email.contains(".")
    })
    var email: String

    @UserDefault(key: "savedAge", defaultValue: 18)
    @Clamped(18...99)
    var age: Int

    var body: some View {
        Form {
            Section("用户信息") {
                TextField("邮箱", text: $email)
                    .foregroundColor($email ? .primary : .red)

                Stepper("年龄: \(age)", value: $age, in: 18...99)
            }

            Section("状态") {
                HStack {
                    Text("邮箱验证:")
                    Text($email ? "✓" : "✗")
                        .foregroundColor($email ? .green : .red)
                }
            }
        }
    }
}
```

### 动画效果

#### 动画属性包装器

```swift
@propertyWrapper
struct Animated<T: VectorArithmetic> {
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
}

struct AnimatedCounter: View {
    @Animated(animation: .spring()) var count: Double = 0

    var body: some View {
        VStack {
            Text("\(count, specifier: "%.1f")")
                .font(.largeTitle)

            HStack {
                Button("减少") { count -= 1 }
                Button("增加") { count += 1 }
            }
        }
    }
}
```

### 状态管理

#### 复杂状态包装器

```swift
@propertyWrapper
struct StateWithHistory<T: Equatable> {
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

    var projectedValue: (history: [T], canUndo: Bool, undo: () -> Void) {
        (
            history: history,
            canUndo: history.count > 1,
            undo: {
                if history.count > 1 {
                    history.removeLast()
                    currentValue = history.last!
                }
            }
        )
    }
}
```

## 性能优化

### 最佳实践

1. **避免在 getter/setter 中进行重计算**

```swift
// ❌ 不好的做法
@propertyWrapper
struct Expensive<T> {
    var wrappedValue: T {
        get { expensiveComputation() } // 每次访问都计算
        set { /* ... */ }
    }
}

// ✅ 好的做法
@propertyWrapper
struct Efficient<T> {
    private var cachedValue: T?
    private var needsUpdate = true

    var wrappedValue: T {
        mutating get {
            if needsUpdate {
                cachedValue = expensiveComputation()
                needsUpdate = false
            }
            return cachedValue!
        }
        set {
            cachedValue = newValue
            needsUpdate = false
        }
    }
}
```

2. **使用延迟初始化**

```swift
@propertyWrapper
struct Lazy<T> {
    private var value: T?
    private let initializer: () -> T

    init(initializer: @escaping () -> T) {
        self.initializer = initializer
    }

    var wrappedValue: T {
        mutating get {
            if let value = value {
                return value
            }
            let newValue = initializer()
            value = newValue
            return newValue
        }
        set {
            value = newValue
        }
    }
}
```

### 常见陷阱

1. **循环引用**

```swift
// ❌ 可能导致循环引用
@propertyWrapper
struct WeakRef<T: AnyObject> {
    weak var value: T?

    var wrappedValue: T? {
        get { value }
        set { value = newValue }
    }
}
```

2. **线程安全问题**

```swift
// ❌ 非线程安全
@propertyWrapper
struct Counter {
    private var count = 0

    var wrappedValue: Int {
        get { count }
        set { count = newValue }
    }

    mutating func increment() {
        count += 1 // 可能导致竞态条件
    }
}
```

### 优化技巧

1. **使用 copy-on-write**
2. **实现适当的缓存策略**
3. **避免不必要的通知**
4. **考虑内存占用**

## 示例代码

### 基础示例

#### 范围限制包装器

```swift
@propertyWrapper
struct Range<T: Comparable> {
    private var value: T
    private let bounds: ClosedRange<T>

    init(wrappedValue: T, _ bounds: ClosedRange<T>) {
        self.bounds = bounds
        self.value = min(max(wrappedValue, bounds.lowerBound), bounds.upperBound)
    }

    var wrappedValue: T {
        get { value }
        set { value = min(max(newValue, bounds.lowerBound), bounds.upperBound) }
    }
}
```

### 进阶示例

#### 表单验证包装器

```swift
@propertyWrapper
struct FormField<T> {
    private var value: T
    private let rules: [(T) -> ValidationResult]
    private var validationResult: ValidationResult = .valid

    init(wrappedValue: T, rules: [(T) -> ValidationResult] = []) {
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

    var projectedValue: ValidationResult {
        validationResult
    }

    private mutating func validate() {
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

enum ValidationResult {
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
```

### 完整 Demo

#### 用户注册表单

```swift
struct RegistrationForm: View {
    @FormField(rules: [
        { $0.count >= 3 ? .valid : .invalid("用户名至少3个字符") },
        { $0.allSatisfy { $0.isLetter || $0.isNumber } ? .valid : .invalid("只能包含字母和数字") }
    ]) var username = ""

    @FormField(rules: [
        { $0.contains("@") ? .valid : .invalid("请输入有效邮箱") },
        { $0.contains(".") ? .valid : .invalid("邮箱格式不正确") }
    ]) var email = ""

    @FormField(rules: [
        { $0.count >= 8 ? .valid : .invalid("密码至少8个字符") },
        { $0.contains { $0.isUppercase } ? .valid : .invalid("密码需要包含大写字母") }
    ]) var password = ""

    var isFormValid: Bool {
        $username.isValid && $email.isValid && $password.isValid
    }

    var body: some View {
        Form {
            Section("用户信息") {
                VStack(alignment: .leading) {
                    TextField("用户名", text: $username)
                    if !$username.isValid {
                        Text($username.message)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                VStack(alignment: .leading) {
                    TextField("邮箱", text: $email)
                    if !$email.isValid {
                        Text($email.message)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                VStack(alignment: .leading) {
                    SecureField("密码", text: $password)
                    if !$password.isValid {
                        Text($password.message)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }

            Button("注册") {
                register()
            }
            .disabled(!isFormValid)
        }
        .navigationTitle("用户注册")
    }

    private func register() {
        print("注册用户: \(username), 邮箱: \(email)")
    }
}
```

## 注意事项

### 常见问题

1. **Q: 属性包装器可以继承吗？**
   A: 不可以。属性包装器不支持继承，但可以通过组合实现复用。

2. **Q: 如何在属性包装器中访问 self？**
   A: 属性包装器在属性声明时初始化，无法直接访问包含它的实例。

3. **Q: 投影值是必需的吗？**
   A: 不是。投影值是可选的，只有需要额外功能时才定义。

### 兼容性考虑

- 属性包装器需要 Swift 5.1+
- SwiftUI 需要 iOS 13.0+
- 某些高级功能可能需要更新版本

### 使用建议

1. **保持简单**: 属性包装器应该专注于单一职责
2. **文档化**: 为自定义包装器编写清晰的文档
3. **测试**: 编写单元测试确保包装器行为正确
4. **性能**: 避免在包装器中进行耗时操作
5. **命名**: 使用清晰描述性的名称

## 完整运行 Demo

### 源代码

完整的自定义属性包装器演示应用包含：

1. **基础包装器**: 范围限制、格式化、验证
2. **进阶包装器**: 缓存、线程安全、历史记录
3. **实际应用**: 用户设置、表单验证、数据持久化
4. **性能优化**: 延迟加载、智能缓存

### 运行说明

1. 确保 Xcode 版本支持 Swift 5.1+
2. 在 iOS 13.0+ 的设备或模拟器上运行
3. 体验不同包装器的功能和效果

### 功能说明

- **交互式演示**: 实时查看包装器效果
- **代码展示**: 每个示例都包含完整的源代码
- **最佳实践**: 展示正确的使用方法
- **性能分析**: 了解不同实现的性能差异

---

**记住**: 自定义属性包装器是强大的工具，类似于前端的自定义 Hook，能够极大提升代码的复用性和可维护性。从简单的验证开始，逐步探索更复杂的应用场景！
