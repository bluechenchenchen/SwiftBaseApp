<!--
 * @Author: blue
 * @Date: 2025-01-14 15:30:00
 * @FilePath: /SwiftBaseApp/SwiftBaseApp/docs/StateManagement/PublisherSubscriber.md
-->

# Combine Publisher 和 Subscriber

## 1. 基本介绍

### 概念解释

在 Combine 框架中，Publisher（发布者）和 Subscriber（订阅者）构成了响应式编程的核心模式。对于前端开发者来说，这类似于 RxJS 中的 Observable 和 Observer：

- **Publisher**：类似于 RxJS 的 Observable，负责发送数据流
- **Subscriber**：类似于 RxJS 的 Observer，负责接收和处理数据

```javascript
// RxJS 示例
const observable = new Observable((subscriber) => {
  subscriber.next("Hello");
  subscriber.next("World");
  subscriber.complete();
});

observable.subscribe({
  next: (value) => console.log(value),
  complete: () => console.log("Completed"),
});
```

在 Swift Combine 中，这种模式变成：

```swift
let publisher = Just("Hello World")
let subscription = publisher.sink { value in
    print(value)
}
```

### 使用场景

- **异步数据处理**：网络请求、文件操作
- **用户界面响应**：按钮点击、文本输入
- **状态管理**：数据流转和状态更新
- **事件处理**：系统通知、定时器

### 主要特性

- **类型安全**：编译时检查数据类型
- **内存管理**：自动处理订阅生命周期
- **错误处理**：内置错误传播机制
- **组合能力**：可以链式调用和组合

## 2. 基础用法

### Publisher 基础

Publisher 是一个协议，定义了发送数据的能力：

```swift
protocol Publisher {
    associatedtype Output    // 输出类型
    associatedtype Failure: Error  // 错误类型
}
```

#### 常用的内置 Publisher

**Just Publisher**

```swift
// 发送单个值然后完成
let justPublisher = Just("Hello")
```

**Empty Publisher**

```swift
// 不发送任何值，立即完成
let emptyPublisher = Empty<String, Never>()
```

**Fail Publisher**

```swift
// 立即发送错误
enum CustomError: Error {
    case somethingWrong
}
let failPublisher = Fail<String, CustomError>(error: .somethingWrong)
```

**Future Publisher**

```swift
// 异步操作，类似于 Promise
let futurePublisher = Future<String, Never> { promise in
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        promise(.success("Delayed value"))
    }
}
```

**PassthroughSubject**

```swift
// 手动发送值，类似于 Subject
let subject = PassthroughSubject<String, Never>()
subject.send("Manual value")
```

**CurrentValueSubject**

```swift
// 保存当前值的 Subject
let currentValueSubject = CurrentValueSubject<String, Never>("Initial")
currentValueSubject.send("New value")
```

### Subscriber 基础

Subscriber 协议定义了接收数据的能力：

```swift
protocol Subscriber {
    associatedtype Input     // 输入类型
    associatedtype Failure: Error  // 错误类型
}
```

#### 常用订阅方式

**sink 订阅**

```swift
let subscription = publisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Completed successfully")
        case .failure(let error):
            print("Failed with error: \(error)")
        }
    },
    receiveValue: { value in
        print("Received: \(value)")
    }
)
```

**assign 订阅**

```swift
class ViewModel: ObservableObject {
    @Published var text: String = ""
}

let viewModel = ViewModel()
publisher.assign(to: \.text, on: viewModel)
```

### 数据流控制

#### 操作符链式调用

```swift
publisher
    .filter { $0.count > 3 }  // 过滤
    .map { $0.uppercased() }  // 转换
    .removeDuplicates()       // 去重
    .sink { print($0) }       // 订阅
```

#### 背压处理

```swift
publisher
    .buffer(size: 10, prefetch: .keepFull, whenFull: .dropOldest)
    .sink { print($0) }
```

### 生命周期管理

#### AnyCancellable

```swift
import Combine

class DataManager {
    private var cancellables = Set<AnyCancellable>()

    func startListening() {
        publisher
            .sink { value in
                print(value)
            }
            .store(in: &cancellables)  // 存储订阅
    }

    func stopListening() {
        cancellables.removeAll()  // 取消所有订阅
    }
}
```

## 3. 样式和自定义

### 自定义 Publisher

```swift
struct CountdownPublisher: Publisher {
    typealias Output = Int
    typealias Failure = Never

    let start: Int

    func receive<S>(subscriber: S) where S: Subscriber,
                   S.Input == Output, S.Failure == Failure {
        let subscription = CountdownSubscription(
            subscriber: subscriber,
            start: start
        )
        subscriber.receive(subscription: subscription)
    }
}

class CountdownSubscription<S: Subscriber>: Subscription
where S.Input == Int, S.Failure == Never {
    private var subscriber: S?
    private var current: Int
    private var timer: Timer?

    init(subscriber: S, start: Int) {
        self.subscriber = subscriber
        self.current = start
    }

    func request(_ demand: Subscribers.Demand) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.current > 0 {
                _ = self.subscriber?.receive(self.current)
                self.current -= 1
            } else {
                self.subscriber?.receive(completion: .finished)
                self.timer?.invalidate()
            }
        }
    }

    func cancel() {
        timer?.invalidate()
        subscriber = nil
    }
}
```

### 自定义 Subscriber

```swift
class CustomSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: String) -> Subscribers.Demand {
        print("Custom received: \(input)")
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Custom completed")
    }
}
```

## 4. 高级特性

### 组合多个 Publisher

#### CombineLatest

```swift
let publisher1 = PassthroughSubject<String, Never>()
let publisher2 = PassthroughSubject<Int, Never>()

Publishers.CombineLatest(publisher1, publisher2)
    .sink { text, number in
        print("\(text): \(number)")
    }
```

#### Merge

```swift
let textPublisher = PassthroughSubject<String, Never>()
let numberPublisher = PassthroughSubject<String, Never>()

Publishers.Merge(textPublisher, numberPublisher)
    .sink { value in
        print("Merged: \(value)")
    }
```

#### Zip

```swift
let names = ["Alice", "Bob", "Charlie"]
let ages = [25, 30, 35]

Publishers.Zip(
    names.publisher,
    ages.publisher
)
.sink { name, age in
    print("\(name) is \(age) years old")
}
```

### 动画效果

在 SwiftUI 中结合使用：

```swift
class AnimationViewModel: ObservableObject {
    @Published var scale: CGFloat = 1.0
    private var cancellables = Set<AnyCancellable>()

    init() {
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map { _ in CGFloat.random(in: 0.5...1.5) }
            .assign(to: \.scale, on: self)
            .store(in: &cancellables)
    }
}
```

### 状态管理

```swift
class StateManager: ObservableObject {
    @Published var isLoading = false
    @Published var data: [String] = []
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()

    func loadData() {
        isLoading = true

        fetchDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] data in
                    self?.data = data
                    self?.error = nil
                }
            )
            .store(in: &cancellables)
    }

    private func fetchDataPublisher() -> AnyPublisher<[String], Error> {
        // 模拟网络请求
        Just(["Item 1", "Item 2", "Item 3"])
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
```

## 5. 性能优化

### 最佳实践

1. **及时取消订阅**

```swift
// 好的做法
class ViewController {
    private var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.removeAll()
    }
}
```

2. **使用 share() 避免重复计算**

```swift
let sharedPublisher = expensivePublisher.share()

sharedPublisher.sink { /* subscriber 1 */ }
sharedPublisher.sink { /* subscriber 2 */ }
```

3. **合理使用 receive(on:)**

```swift
networkPublisher
    .receive(on: DispatchQueue.main)  // UI 更新在主线程
    .sink { /* update UI */ }
```

### 常见陷阱

1. **循环引用**

```swift
// 错误：强引用循环
publisher.sink { [unowned self] in  // 使用 weak 或 unowned
    self.handleValue($0)
}

// 正确
publisher.sink { [weak self] in
    self?.handleValue($0)
}
```

2. **过度订阅**

```swift
// 错误：每次都创建新订阅
func refresh() {
    dataPublisher.sink { /* handle */ }  // 内存泄漏
}

// 正确：管理订阅生命周期
private var refreshCancellable: AnyCancellable?

func refresh() {
    refreshCancellable = dataPublisher.sink { /* handle */ }
}
```

### 优化技巧

1. **使用 debounce 减少频繁更新**

```swift
searchTextPublisher
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { searchText in
        // 搜索逻辑
    }
```

2. **使用 throttle 限制更新频率**

```swift
scrollPositionPublisher
    .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
    .sink { position in
        // 滚动处理
    }
```

## 6. 示例代码

### 基础示例

```swift
import Combine
import Foundation

// 简单的数据发布
func basicPublisherExample() {
    let publisher = Just("Hello, Combine!")

    let subscription = publisher.sink { value in
        print("Received: \(value)")
    }

    // 输出: Received: Hello, Combine!
}

// Subject 使用
func subjectExample() {
    let subject = PassthroughSubject<String, Never>()

    let subscription = subject.sink { value in
        print("Subject received: \(value)")
    }

    subject.send("First message")
    subject.send("Second message")
    subject.send(completion: .finished)
}
```

### 进阶示例

```swift
import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var isLoading = false
    @Published var users: [User] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchUsers() {
        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.example.com/users")!)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}
```

### 完整 Demo

请参考 `PublisherSubscriberDemoView.swift` 文件，包含了所有概念的完整可运行示例。

## 7. 注意事项

### 常见问题

1. **订阅未存储导致立即取消**

```swift
// 错误：订阅立即被释放
publisher.sink { print($0) }

// 正确：存储订阅
let subscription = publisher.sink { print($0) }
```

2. **错误的线程操作**

```swift
// UI 更新必须在主线程
publisher
    .receive(on: DispatchQueue.main)
    .sink { value in
        // 安全的 UI 更新
    }
```

3. **Subject 的完成状态**

```swift
let subject = PassthroughSubject<String, Never>()
subject.send("Message")
subject.send(completion: .finished)  // 之后无法再发送消息
```

### 兼容性考虑

- **iOS 13.0+** 才支持 Combine
- **macOS 10.15+** 才支持 Combine
- 对于更早版本，考虑使用 RxSwift 或其他替代方案

### 使用建议

1. **学习路径**：先掌握基础概念，再学习操作符
2. **内存管理**：始终注意订阅的生命周期管理
3. **调试技巧**：使用 `.print()` 操作符调试数据流
4. **测试策略**：Publisher 很容易进行单元测试

```swift
// 调试数据流
publisher
    .print("Debug")  // 打印所有事件
    .sink { print($0) }

// 单元测试
func testPublisher() {
    let expectation = XCTestExpectation(description: "Publisher")
    let publisher = Just("Test")

    publisher.sink { value in
        XCTAssertEqual(value, "Test")
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
}
```

## 8. 完整运行 Demo

### 源代码

详见 `PublisherSubscriberDemoView.swift` 文件

### 运行说明

1. 在 Xcode 中打开项目
2. 导航到 "状态管理" -> "Combine" -> "Publisher 和 Subscriber"
3. 运行各种示例查看效果

### 功能说明

- **基础发布者**：演示各种内置 Publisher 的使用
- **订阅方式**：展示不同的订阅方法
- **数据流控制**：演示操作符的链式调用
- **生命周期管理**：展示订阅的创建和取消
- **实际应用**：结合 SwiftUI 的完整示例

---

**记住**：Publisher 和 Subscriber 是 Combine 的基础，理解了这个概念，后续学习其他 Combine 操作符会更加容易。多动手实践，结合实际项目来巩固学习成果！
