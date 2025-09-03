# Swift 语言学习指南

## 目录

- [基础知识](#基础知识)
- [Swift 特性](#swift-特性)
- [面向对象编程](#面向对象编程)
- [函数式编程](#函数式编程)
- [内存管理](#内存管理)
- [并发编程](#并发编程)
- [最佳实践](#最佳实践)

## 基础知识

### 1. 变量和常量

```swift
// 变量声明（可修改）
var name = "张三"
name = "李四"

// 常量声明（不可修改）
let pi = 3.14159

// 类型标注
var age: Int = 25
let height: Double = 175.5
let isStudent: Bool = true
```

### 2. 基本数据类型

```swift
// 整数
let int8: Int8 = 127          // 8位整数
let int16: Int16 = 32767      // 16位整数
let int32: Int32 = 2147483647 // 32位整数
let int64: Int64 = 9223372036854775807 // 64位整数
let int: Int = 42             // 平台相关（64位或32位）

// 浮点数
let float: Float = 3.14       // 32位浮点数
let double: Double = 3.14159  // 64位浮点数

// 布尔值
let true: Bool = true
let false: Bool = false

// 字符串
let string: String = "Hello, Swift!"
let char: Character = "A"

// 可选类型
var optionalString: String? = nil
var optionalInt: Int? = 42
```

### 3. 集合类型

```swift
// 数组
var array = ["苹果", "香蕉", "橙子"]
var numbers: [Int] = [1, 2, 3, 4, 5]

// 字典
var dict = ["name": "张三", "age": "25"]
var scores: [String: Int] = ["语文": 95, "数学": 98]

// 集合
var set: Set<String> = ["红", "绿", "蓝"]
```

### 4. 控制流

```swift
// if 条件语句
if age >= 18 {
    print("成年人")
} else {
    print("未成年")
}

// switch 语句
switch age {
case 0...12:
    print("儿童")
case 13...17:
    print("青少年")
default:
    print("成年人")
}

// for 循环
for item in array {
    print(item)
}

// while 循环
while condition {
    // 循环体
}

// repeat-while 循环
repeat {
    // 循环体
} while condition
```

## Swift 特性

### 1. 可选类型（Optionals）

```swift
// 可选类型声明
var optionalValue: Int?

// 可选绑定
if let value = optionalValue {
    print("值为: \(value)")
}

// 强制解包（谨慎使用）
let forcedValue = optionalValue!

// 可选链
let optionalString: String? = "Hello"
let count = optionalString?.count

// 空合运算符
let defaultValue = optionalValue ?? 0
```

### 2. 类型安全和类型推断

```swift
// 类型推断
let name = "张三"        // String 类型
let age = 25            // Int 类型
let height = 175.5      // Double 类型

// 类型安全
let string = "42"
let number = Int(string) // 返回 Int?
```

### 3. 闭包（Closures）

```swift
// 基本闭包
let simpleClosure = { (name: String) -> String in
    return "Hello, \(name)!"
}

// 尾随闭包
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { $0 * 2 }

// 捕获值
var counter = 0
let increment = {
    counter += 1
}
```

## 面向对象编程

### 1. 类和结构体

```swift
// 类定义
class Person {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func introduce() {
        print("我是 \(name)，今年 \(age) 岁")
    }
}

// 结构体定义
struct Point {
    var x: Double
    var y: Double

    mutating func moveBy(x: Double, y: Double) {
        self.x += x
        self.y += y
    }
}
```

### 2. 属性

```swift
class Temperature {
    // 存储属性
    var celsius: Double

    // 计算属性
    var fahrenheit: Double {
        get {
            return celsius * 9/5 + 32
        }
        set {
            celsius = (newValue - 32) * 5/9
        }
    }

    // 属性观察器
    var steps: Int = 0 {
        willSet {
            print("将要设置新值：\(newValue)")
        }
        didSet {
            print("已经从 \(oldValue) 变为 \(steps)")
        }
    }
}
```

### 3. 继承和多态

```swift
// 基类
class Animal {
    var name: String

    init(name: String) {
        self.name = name
    }

    func makeSound() {
        // 基类方法
    }
}

// 子类
class Dog: Animal {
    override func makeSound() {
        print("汪汪!")
    }
}
```

## 函数式编程

### 1. 高阶函数

```swift
// map
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { $0 * 2 }

// filter
let evenNumbers = numbers.filter { $0 % 2 == 0 }

// reduce
let sum = numbers.reduce(0, +)

// compactMap
let strings = ["1", "2", "three", "4", "5"]
let validNumbers = strings.compactMap { Int($0) }
```

### 2. 函数式编程特性

```swift
// 函数作为参数
func calculate(_ a: Int, _ b: Int, using operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

// 函数作为返回值
func makeIncrementer(increment: Int) -> () -> Int {
    var total = 0
    return {
        total += increment
        return total
    }
}
```

## 内存管理

### 1. ARC（自动引用计数）

```swift
class Person {
    // 强引用
    var apartment: Apartment?

    // 弱引用
    weak var friend: Person?

    // 无主引用
    unowned var passport: Passport
}
```

### 2. 引用循环

```swift
// 闭包中的强引用循环
class HTMLElement {
    let name: String
    let text: String?

    // 使用 [weak self] 避免强引用循环
    lazy var asHTML: () -> String = { [weak self] in
        guard let self = self else { return "" }
        return "<\(self.name)>\(self.text ?? "")</\(self.name)>"
    }
}
```

## 并发编程

### 1. async/await

```swift
// 异步函数
func fetchUserData() async throws -> User {
    let data = try await networkClient.fetchData()
    return try JSONDecoder().decode(User.self, from: data)
}

// 使用异步函数
Task {
    do {
        let user = try await fetchUserData()
        updateUI(with: user)
    } catch {
        handleError(error)
    }
}
```

### 2. Actor

```swift
// 定义 actor
actor BankAccount {
    private var balance: Decimal

    init(initialBalance: Decimal) {
        balance = initialBalance
    }

    func deposit(_ amount: Decimal) {
        balance += amount
    }

    func withdraw(_ amount: Decimal) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }
}
```

## 最佳实践

### 1. 代码风格

```swift
// 使用清晰的命名
func calculateTotalPrice(for items: [Item]) -> Decimal {
    return items.reduce(0) { $0 + $1.price }
}

// 使用类型推断
let names = ["Alice", "Bob", "Charlie"] // 而不是 let names: [String]

// 使用guard提前返回
func process(data: String?) {
    guard let data = data else { return }
    // 处理数据
}
```

### 2. 错误处理

```swift
// 定义错误类型
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// 使用 throws 抛出错误
func fetchData() throws -> Data {
    guard let url = URL(string: "https://api.example.com") else {
        throw NetworkError.invalidURL
    }
    // 获取数据
}

// 处理错误
do {
    let data = try fetchData()
    process(data)
} catch NetworkError.invalidURL {
    handleInvalidURL()
} catch {
    handleOtherError(error)
}
```

### 3. 性能优化

```swift
// 使用 lazy 属性
lazy var expensiveComputation: Int = {
    // 复杂计算
    return result
}()

// 使用值类型
struct Point {
    var x: Double
    var y: Double
}

// 避免过度使用可选类型
struct User {
    let id: String        // 必选
    let name: String      // 必选
    var email: String?    // 可选
}
```

## 学习资源

1. 官方资源

- [Swift 官方文档](https://swift.org/documentation/)
- [Swift 编程语言](https://docs.swift.org/swift-book/)
- [Swift 标准库](https://developer.apple.com/documentation/swift/swift_standard_library)

2. 推荐书籍

- "Swift Programming: The Big Nerd Ranch Guide"
- "Advanced Swift" by Chris Eidhof
- "Swift in Depth" by Tjeerd in 't Veen

3. 在线教程

- [Hacking with Swift](https://www.hackingwithswift.com)
- [Ray Wenderlich](https://www.raywenderlich.com/ios/swift)
- [Swift by Sundell](https://www.swiftbysundell.com)

## 练习项目建议

1. 入门级

- 计算器应用
- 待办事项列表
- 简单游戏（猜数字、井字棋）

2. 进阶级

- 天气应用（网络请求）
- 笔记应用（数据持久化）
- 图片浏览器（异步加载）

3. 高级应用

- 社交媒体客户端
- 实时聊天应用
- 音视频处理应用

记住：Swift 是一个不断发展的语言，建议：

1. 从基础开始，打好基础
2. 多写代码，多实践
3. 关注新特性和最佳实践
4. 参与开源社区
