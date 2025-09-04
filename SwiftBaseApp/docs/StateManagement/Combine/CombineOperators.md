<!--
 * @Author: blue
 * @Date: 2025-01-14 16:30:00
 * @FilePath: /SwiftBaseApp/SwiftBaseApp/docs/StateManagement/CombineOperators.md
-->

# Combine 基本操作符使用

## 1. 基本介绍

### 概念解释

Combine 操作符是用于处理和转换数据流的工具函数。对于前端开发者来说，这类似于 RxJS 中的操作符：

- **转换操作符**：类似于 RxJS 的 `map`、`flatMap`、`scan`
- **过滤操作符**：类似于 RxJS 的 `filter`、`distinct`、`take`
- **组合操作符**：类似于 RxJS 的 `combineLatest`、`merge`、`zip`
- **错误处理操作符**：类似于 RxJS 的 `catchError`、`retry`

```javascript
// RxJS 示例
const numbers$ = of(1, 2, 3, 4, 5);

numbers$
  .pipe(
    filter((x) => x % 2 === 0), // 过滤偶数
    map((x) => x * 2), // 乘以2
    catchError((err) => of(0)) // 错误处理
  )
  .subscribe(console.log);
```

在 Swift Combine 中，这种模式变成：

```swift
let numbers = (1...5).publisher

numbers
    .filter { $0 % 2 == 0 }    // 过滤偶数
    .map { $0 * 2 }            // 乘以2
    .catch { _ in Just(0) }    // 错误处理
    .sink { print($0) }
```

### 使用场景

- **数据转换**：格式化、计算、类型转换
- **数据过滤**：条件筛选、去重、限制数量
- **数据组合**：多源合并、并行处理
- **错误处理**：异常捕获、重试机制、降级处理
- **时间控制**：防抖、节流、延迟

### 主要特性

- **链式调用**：操作符可以无缝连接
- **类型安全**：编译时验证数据类型
- **惰性执行**：只有订阅时才开始处理
- **内存高效**：自动管理资源生命周期

## 2. 基础用法

### 转换操作符

#### map - 数据映射

```swift
// 基本转换
let numbers = [1, 2, 3, 4, 5].publisher
numbers
    .map { $0 * 2 }  // 每个值乘以2
    .sink { print($0) }  // 输出: 2, 4, 6, 8, 10
```

#### flatMap - 扁平化映射

```swift
struct User {
    let id: Int
    let name: String
}

let userIds = [1, 2, 3].publisher

userIds
    .flatMap { id in
        // 模拟异步获取用户信息
        Just(User(id: id, name: "User\(id)"))
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
    }
    .sink { user in
        print("获取用户: \(user.name)")
    }
```

#### scan - 累积扫描

```swift
let numbers = [1, 2, 3, 4, 5].publisher

numbers
    .scan(0) { accumulator, value in
        accumulator + value  // 累积求和
    }
    .sink { print($0) }  // 输出: 1, 3, 6, 10, 15
```

#### tryMap - 可抛出异常的映射

```swift
enum ValidationError: Error {
    case invalidValue
}

let values = ["1", "2", "invalid", "4"].publisher

values
    .tryMap { string -> Int in
        guard let number = Int(string) else {
            throw ValidationError.invalidValue
        }
        return number
    }
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("错误: \(error)")
            }
        },
        receiveValue: { value in
            print("转换成功: \(value)")
        }
    )
```

### 过滤操作符

#### filter - 条件过滤

```swift
let numbers = (1...10).publisher

numbers
    .filter { $0 % 2 == 0 }  // 只保留偶数
    .sink { print($0) }      // 输出: 2, 4, 6, 8, 10
```

#### removeDuplicates - 去重

```swift
let values = [1, 1, 2, 2, 3, 2, 1].publisher

values
    .removeDuplicates()  // 移除连续重复值
    .sink { print($0) }  // 输出: 1, 2, 3, 2, 1
```

#### dropFirst - 跳过前几个值

```swift
let numbers = (1...5).publisher

numbers
    .dropFirst(2)        // 跳过前2个值
    .sink { print($0) }  // 输出: 3, 4, 5
```

#### prefix - 只取前几个值

```swift
let numbers = (1...10).publisher

numbers
    .prefix(3)           // 只取前3个值
    .sink { print($0) }  // 输出: 1, 2, 3
```

#### compactMap - 移除 nil 值

```swift
let optionalNumbers = [1, nil, 3, nil, 5].publisher

optionalNumbers
    .compactMap { $0 }   // 移除 nil 值
    .sink { print($0) }  // 输出: 1, 3, 5
```

### 组合操作符

#### combineLatest - 组合最新值

```swift
let numbers = PassthroughSubject<Int, Never>()
let letters = PassthroughSubject<String, Never>()

Publishers.CombineLatest(numbers, letters)
    .map { number, letter in
        "\(letter)\(number)"
    }
    .sink { print($0) }

numbers.send(1)  // 无输出（需要两个流都有值）
letters.send("A") // 输出: A1
numbers.send(2)  // 输出: A2
letters.send("B") // 输出: B2
```

#### merge - 合并多个流

```swift
let numbers1 = [1, 3, 5].publisher
let numbers2 = [2, 4, 6].publisher

Publishers.Merge(numbers1, numbers2)
    .sink { print($0) }  // 输出: 1, 2, 3, 4, 5, 6 (顺序可能不同)
```

#### zip - 配对组合

```swift
let numbers = [1, 2, 3].publisher
let letters = ["A", "B", "C"].publisher

Publishers.Zip(numbers, letters)
    .map { number, letter in
        "\(letter)\(number)"
    }
    .sink { print($0) }  // 输出: A1, B2, C3
```

### 错误处理操作符

#### catch - 错误捕获

```swift
enum CustomError: Error {
    case networkError
}

let publisher = Fail<String, CustomError>(error: .networkError)

publisher
    .catch { error in
        Just("默认值")  // 发生错误时返回默认值
    }
    .sink { print($0) }  // 输出: 默认值
```

#### retry - 重试机制

```swift
var attemptCount = 0

let flakyPublisher = Future<String, Error> { promise in
    attemptCount += 1
    if attemptCount < 3 {
        promise(.failure(CustomError.networkError))
    } else {
        promise(.success("成功!"))
    }
}

flakyPublisher
    .retry(2)  // 最多重试2次
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("完成")
            case .failure(let error):
                print("最终失败: \(error)")
            }
        },
        receiveValue: { value in
            print("成功: \(value)")
        }
    )
```

#### mapError - 错误转换

```swift
enum NetworkError: Error {
    case timeout
    case serverError
}

enum UIError: Error {
    case displayError(String)
}

let networkPublisher = Fail<String, NetworkError>(error: .timeout)

networkPublisher
    .mapError { networkError in
        switch networkError {
        case .timeout:
            return UIError.displayError("网络超时，请重试")
        case .serverError:
            return UIError.displayError("服务器错误，请稍后重试")
        }
    }
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("UI错误: \(error)")
            }
        },
        receiveValue: { print($0) }
    )
```

## 3. 样式和自定义

### 自定义操作符

```swift
extension Publisher {
    func logEvents(identifier: String) -> AnyPublisher<Output, Failure> {
        return self
            .handleEvents(
                receiveSubscription: { subscription in
                    print("[\(identifier)] 订阅: \(subscription)")
                },
                receiveOutput: { output in
                    print("[\(identifier)] 输出: \(output)")
                },
                receiveCompletion: { completion in
                    print("[\(identifier)] 完成: \(completion)")
                },
                receiveCancel: {
                    print("[\(identifier)] 取消")
                }
            )
            .eraseToAnyPublisher()
    }
}

// 使用自定义操作符
let numbers = [1, 2, 3].publisher

numbers
    .logEvents(identifier: "数字流")
    .map { $0 * 2 }
    .logEvents(identifier: "转换后")
    .sink { _ in }
```

### 条件操作符组合

```swift
extension Publisher where Output: Numeric {
    func filterAndMultiply(
        predicate: @escaping (Output) -> Bool,
        multiplier: Output
    ) -> AnyPublisher<Output, Failure> {
        return self
            .filter(predicate)
            .map { $0 * multiplier }
            .eraseToAnyPublisher()
    }
}

// 使用
let numbers = (1...10).publisher

numbers
    .filterAndMultiply(
        predicate: { $0 % 2 == 0 },  // 过滤偶数
        multiplier: 3                 // 乘以3
    )
    .sink { print($0) }  // 输出: 6, 12, 18, 24, 30
```

## 4. 高级特性

### 时间操作符

#### debounce - 防抖

```swift
let searchText = PassthroughSubject<String, Never>()

searchText
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .removeDuplicates()
    .sink { searchTerm in
        print("搜索: \(searchTerm)")
    }

// 模拟用户快速输入
searchText.send("S")
searchText.send("Sw")
searchText.send("Swi")
searchText.send("Swif")
searchText.send("Swift")
// 只会在300ms后输出一次: "搜索: Swift"
```

#### throttle - 节流

```swift
let scrollPosition = PassthroughSubject<CGFloat, Never>()

scrollPosition
    .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
    .sink { position in
        print("滚动位置: \(position)")
    }
```

#### delay - 延迟

```swift
let immediateValue = Just("立即值")

immediateValue
    .delay(for: .seconds(2), scheduler: DispatchQueue.main)
    .sink { print("延迟输出: \($0)") }
```

### 聚合操作符

#### reduce - 归约

```swift
let numbers = [1, 2, 3, 4, 5].publisher

numbers
    .reduce(0) { accumulator, value in
        accumulator + value  // 求和
    }
    .sink { print("总和: \($0)") }  // 输出: 总和: 15
```

#### collect - 收集

```swift
let numbers = [1, 2, 3, 4, 5].publisher

numbers
    .collect(3)  // 每3个元素收集一次
    .sink { batch in
        print("批次: \(batch)")
    }
    // 输出: 批次: [1, 2, 3]
    //      批次: [4, 5]
```

#### count - 计数

```swift
let items = ["A", "B", "C", "D"].publisher

items
    .count()
    .sink { print("元素数量: \($0)") }  // 输出: 元素数量: 4
```

### 操作符链优化

```swift
let dataProcessor = PassthroughSubject<String, Never>()

let subscription = dataProcessor
    .compactMap { Int($0) }        // 1. 转换为数字
    .filter { $0 > 0 }             // 2. 过滤正数
    .map { $0 * $0 }               // 3. 计算平方
    .scan(0, +)                    // 4. 累积求和
    .removeDuplicates()            // 5. 去重
    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)  // 6. 防抖
    .sink { result in
        print("处理结果: \(result)")
    }
```

## 5. 性能优化

### 最佳实践

1. **合理使用 share()**

```swift
let expensiveOperation = URLSession.shared
    .dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: MyData.self, decoder: JSONDecoder())
    .share()  // 共享结果，避免重复计算

// 多个订阅者
expensiveOperation.sink { /* 处理1 */ }
expensiveOperation.sink { /* 处理2 */ }
```

2. **使用适当的调度器**

```swift
networkPublisher
    .subscribe(on: DispatchQueue.global(qos: .background))  // 后台执行
    .receive(on: DispatchQueue.main)                        // 主线程接收
    .sink { /* 更新UI */ }
```

3. **避免过度使用 flatMap**

```swift
// 好的做法：控制并发数
.flatMap(maxPublishers: .max(3)) { item in
    processItem(item)
}

// 不好的做法：无限制并发
.flatMap { item in
    processItem(item)
}
```

### 常见陷阱

1. **内存泄漏**

```swift
// 错误：没有存储订阅
publisher.sink { print($0) }

// 正确：存储订阅
let subscription = publisher.sink { print($0) }
```

2. **阻塞主线程**

```swift
// 错误：在主线程做重计算
publisher
    .map { heavyComputation($0) }  // 阻塞主线程
    .sink { /* UI更新 */ }

// 正确：后台计算
publisher
    .subscribe(on: DispatchQueue.global())
    .map { heavyComputation($0) }
    .receive(on: DispatchQueue.main)
    .sink { /* UI更新 */ }
```

### 优化技巧

1. **使用 buffer 处理背压**

```swift
fastPublisher
    .buffer(size: 100, prefetch: .keepFull, whenFull: .dropOldest)
    .sink { /* 处理 */ }
```

2. **合并相似操作**

```swift
// 不好：多次映射
publisher
    .map { $0 + 1 }
    .map { $0 * 2 }
    .map { $0 - 3 }

// 好：合并为一次映射
publisher
    .map { ($0 + 1) * 2 - 3 }
```

## 6. 示例代码

### 基础示例

```swift
import Combine
import Foundation

// 数据转换管道
func dataProcessingPipeline() {
    let rawData = ["1", "2", "invalid", "4", "5"].publisher

    let subscription = rawData
        .compactMap { Int($0) }        // 转换为整数，忽略无效值
        .filter { $0 % 2 == 0 }        // 只保留偶数
        .map { "处理后的值: \($0)" }     // 格式化输出
        .sink(
            receiveCompletion: { completion in
                print("处理完成: \(completion)")
            },
            receiveValue: { value in
                print(value)
            }
        )

    // 输出:
    // 处理后的值: 2
    // 处理后的值: 4
    // 处理完成: finished
}
```

### 进阶示例

```swift
import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [String] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearch()
    }

    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { searchTerm in
                searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { !$0.isEmpty }
            .flatMap { [weak self] searchTerm -> AnyPublisher<[String], Never> in
                self?.performSearch(for: searchTerm) ?? Just([]).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.searchResults = results
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    private func performSearch(for term: String) -> AnyPublisher<[String], Never> {
        isLoading = true

        return Future<[String], Never> { promise in
            // 模拟网络请求
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                let results = [
                    "\(term) - 结果1",
                    "\(term) - 结果2",
                    "\(term) - 结果3"
                ]
                promise(.success(results))
            }
        }
        .eraseToAnyPublisher()
    }
}
```

### 完整 Demo

请参考 `CombineOperatorsDemoView.swift` 文件，包含了所有操作符的完整可运行示例。

## 7. 注意事项

### 常见问题

1. **操作符顺序很重要**

```swift
// 顺序1：先过滤再映射（高效）
publisher
    .filter { $0 > 0 }
    .map { expensiveOperation($0) }

// 顺序2：先映射再过滤（低效）
publisher
    .map { expensiveOperation($0) }
    .filter { $0 > 0 }
```

2. **类型擦除的使用**

```swift
// 复杂类型
let complexPublisher = publisher
    .map { $0 * 2 }
    .filter { $0 > 10 }
    .removeDuplicates()

// 类型擦除简化
let simplePublisher = complexPublisher.eraseToAnyPublisher()
```

3. **错误传播**

```swift
// 任何操作符抛出错误都会中断整个链
publisher
    .tryMap { try someThrowingFunction($0) }  // 可能抛出错误
    .map { $0 * 2 }                          // 如果上面出错，这里不会执行
    .sink(/* 处理 */)
```

### 兼容性考虑

- **iOS 13.0+** 才支持 Combine
- **macOS 10.15+** 才支持 Combine
- 部分操作符在不同版本有差异

### 使用建议

1. **学习路径**：从基础操作符开始，逐步学习组合使用
2. **调试技巧**：使用 `.print()` 操作符查看数据流
3. **性能考虑**：避免过深的操作符链，合理使用调度器
4. **测试策略**：操作符很容易进行单元测试

```swift
// 调试数据流
publisher
    .print("调试点1")
    .map { $0 * 2 }
    .print("调试点2")
    .filter { $0 > 10 }
    .print("调试点3")
    .sink { print($0) }
```

## 8. 完整运行 Demo

### 源代码

详见 `CombineOperatorsDemoView.swift` 文件

### 运行说明

1. 在 Xcode 中打开项目
2. 导航到 "状态管理" -> "Combine" -> "基本操作符使用"
3. 运行各种示例查看效果

### 功能说明

- **转换操作符**：演示 map、flatMap、scan 等的使用
- **过滤操作符**：展示 filter、removeDuplicates 等的效果
- **组合操作符**：演示多个数据流的组合方式
- **错误处理操作符**：展示错误捕获和重试机制
- **时间操作符**：演示防抖、节流等时间控制
- **聚合操作符**：展示数据收集和统计功能
- **实际应用**：结合 SwiftUI 的完整搜索示例

---

**记住**：Combine 操作符是构建响应式应用的基础工具。掌握这些操作符的组合使用，能够优雅地处理复杂的异步数据流。多动手实践，理解每个操作符的特点和适用场景！
