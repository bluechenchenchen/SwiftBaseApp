import SwiftUI
import Combine

// MARK: - 主演示视图

struct PublisherSubscriberDemoView: View {
  var body: some View {
    ShowcaseList {
      ShowcaseSection("基础发布者") {
        ShowcaseItem(title: "Just Publisher") {
          JustPublisherExample()
        }
        
        ShowcaseItem(title: "Empty Publisher") {
          EmptyPublisherExample()
        }
        
        ShowcaseItem(title: "Fail Publisher") {
          FailPublisherExample()
        }
        
        ShowcaseItem(title: "Future Publisher") {
          FuturePublisherExample()
        }
      }
      
      ShowcaseSection("Subject 发布者") {
        ShowcaseItem(title: "PassthroughSubject") {
          PassthroughSubjectExample()
        }
        
        ShowcaseItem(title: "CurrentValueSubject") {
          CurrentValueSubjectExample()
        }
        
        ShowcaseItem(title: "Subject 对比") {
          SubjectComparisonExample()
        }
      }
      
      ShowcaseSection("订阅方式") {
        ShowcaseItem(title: "Sink 订阅") {
          SinkSubscriberExample()
        }
        
        ShowcaseItem(title: "Assign 订阅") {
          AssignSubscriberExample()
        }
        
        ShowcaseItem(title: "自定义订阅者") {
          CustomSubscriberExample()
        }
      }
      
      ShowcaseSection("数据流控制") {
        ShowcaseItem(title: "操作符链") {
          OperatorChainExample()
        }
        
        ShowcaseItem(title: "背压处理") {
          BackpressureExample()
        }
        
        ShowcaseItem(title: "数据转换") {
          DataTransformExample()
        }
      }
      
      ShowcaseSection("生命周期管理") {
        ShowcaseItem(title: "订阅存储") {
          SubscriptionStorageExample()
        }
        
        ShowcaseItem(title: "取消订阅") {
          CancellationExample()
        }
        
        ShowcaseItem(title: "内存管理") {
          MemoryManagementExample()
        }
      }
      
      ShowcaseSection("组合发布者") {
        ShowcaseItem(title: "CombineLatest") {
          CombineLatestExample()
        }
        
        ShowcaseItem(title: "Merge") {
          MergeExample()
        }
        
        ShowcaseItem(title: "Zip") {
          ZipExample()
        }
      }
      
      ShowcaseSection("实际应用") {
        ShowcaseItem(title: "网络请求") {
          NetworkRequestExample()
        }
        
        ShowcaseItem(title: "用户输入处理") {
          UserInputExample()
        }
        
        ShowcaseItem(title: "定时器应用") {
          TimerApplicationExample()
        }
      }
      
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "自定义 Publisher") {
          CustomPublisherExample()
        }
        
        ShowcaseItem(title: "错误处理") {
          ErrorHandlingExample()
        }
        
        ShowcaseItem(title: "性能优化") {
          PerformanceOptimizationExample()
        }
      }
    }
    .navigationTitle("Publisher 和 Subscriber")
  }
}

// MARK: - 基础发布者示例

// Just Publisher 示例
struct JustPublisherExample: View {
  @State private var receivedValue: String = "等待接收..."
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Just Publisher 演示")
        .font(.headline)
      
      Text("Just 发送单个值然后立即完成")
        .foregroundColor(.secondary)
      
      Text("接收到的值: \(receivedValue)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Button("发送单个值") {
        let publisher = Just("Hello from Just!")
        
        cancellable = publisher.sink { value in
          receivedValue = value
        }
      }
      
      Button("重置") {
        receivedValue = "等待接收..."
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// Empty Publisher 示例
struct EmptyPublisherExample: View {
  @State private var status: String = "未启动"
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Empty Publisher 演示")
        .font(.headline)
      
      Text("Empty 不发送任何值，立即完成")
        .foregroundColor(.secondary)
      
      Text("状态: \(status)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Button("启动 Empty Publisher") {
        status = "正在监听..."
        
        let publisher = Empty<String, Never>()
        
        cancellable = publisher.sink(
          receiveCompletion: { completion in
            status = "已完成 (没有接收到任何值)"
          },
          receiveValue: { value in
            status = "接收到值: \(value)"
          }
        )
      }
      
      Button("重置") {
        status = "未启动"
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// Fail Publisher 示例
struct FailPublisherExample: View {
  @State private var status: String = "未启动"
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Fail Publisher 演示")
        .font(.headline)
      
      Text("Fail 立即发送错误")
        .foregroundColor(.secondary)
      
      Text("状态: \(status)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Button("启动 Fail Publisher") {
        status = "正在监听..."
        
        let publisher = Fail<String, PublisherSubscriberError>(
          error: .customError("这是一个测试错误")
        )
        
        cancellable = publisher.sink(
          receiveCompletion: { completion in
            switch completion {
            case .finished:
              status = "完成"
            case .failure(let error):
              status = "接收到错误: \(error.localizedDescription)"
            }
          },
          receiveValue: { value in
            status = "接收到值: \(value)"
          }
        )
      }
      
      Button("重置") {
        status = "未启动"
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// Future Publisher 示例
struct FuturePublisherExample: View {
  @State private var status: String = "未启动"
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Future Publisher 演示")
        .font(.headline)
      
      Text("Future 用于异步操作，类似 Promise")
        .foregroundColor(.secondary)
      
      Text("状态: \(status)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Button("启动异步操作") {
        status = "正在等待异步结果..."
        
        let futurePublisher = Future<String, Never> { promise in
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise(.success("异步操作完成!"))
          }
        }
        
        cancellable = futurePublisher.sink { value in
          status = "接收到: \(value)"
        }
      }
      
      Button("重置") {
        status = "未启动"
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// MARK: - Subject 发布者示例

// PassthroughSubject 示例
struct PassthroughSubjectExample: View {
  @State private var messages: [String] = []
  @State private var inputText: String = ""
  @State private var cancellable: AnyCancellable?
  
  private let subject = PassthroughSubject<String, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("PassthroughSubject 演示")
        .font(.headline)
      
      Text("手动发送值，不保存状态")
        .foregroundColor(.secondary)
      
      TextField("输入消息", text: $inputText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      HStack {
        Button("发送消息") {
          if !inputText.isEmpty {
            subject.send(inputText)
            inputText = ""
          }
        }
        .disabled(inputText.isEmpty)
        
        Button("完成") {
          subject.send(completion: .finished)
        }
        
        Button("清空") {
          messages.removeAll()
        }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(messages.indices, id: \.self) { index in
            Text("\(index + 1). \(messages[index])")
              .padding(.vertical, 2)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = subject.sink { value in
        messages.append(value)
      }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// CurrentValueSubject 示例
struct CurrentValueSubjectExample: View {
  @State private var history: [String] = []
  @State private var inputText: String = ""
  @State private var cancellable: AnyCancellable?
  
  private let subject = CurrentValueSubject<String, Never>("初始值")
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("CurrentValueSubject 演示")
        .font(.headline)
      
      Text("保存当前值，新订阅者会立即收到当前值")
        .foregroundColor(.secondary)
      
      Text("当前值: \(subject.value)")
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      TextField("输入新值", text: $inputText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      HStack {
        Button("更新值") {
          if !inputText.isEmpty {
            subject.send(inputText)
            inputText = ""
          }
        }
        .disabled(inputText.isEmpty)
        
        Button("清空历史") {
          history.removeAll()
        }
      }
      
      Text("值变化历史:")
        .font(.subheadline)
        .bold()
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(history.indices, id: \.self) { index in
            Text("\(index + 1). \(history[index])")
              .padding(.vertical, 2)
          }
        }
      }
      .frame(maxHeight: 120)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = subject.sink { value in
        history.append(value)
      }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Subject 对比示例
struct SubjectComparisonExample: View {
  @State private var passthroughMessages: [String] = []
  @State private var currentValueMessages: [String] = []
  @State private var isSubscribed = false
  
  private let passthroughSubject = PassthroughSubject<String, Never>()
  private let currentValueSubject = CurrentValueSubject<String, Never>("初始状态")
  
  @State private var cancellables = Set<AnyCancellable>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Subject 类型对比")
        .font(.headline)
      
      HStack {
        Button("发送消息到两个 Subject") {
          let message = "消息 \(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1000))"
          passthroughSubject.send(message)
          currentValueSubject.send(message)
        }
        
        Button(isSubscribed ? "取消订阅" : "开始订阅") {
          if isSubscribed {
            cancellables.removeAll()
            isSubscribed = false
          } else {
            subscribeToSubjects()
            isSubscribed = true
          }
        }
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("PassthroughSubject")
            .font(.subheadline)
            .bold()
          
          Text("(不保存当前值)")
            .font(.caption)
            .foregroundColor(.secondary)
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(passthroughMessages.indices, id: \.self) { index in
                Text(passthroughMessages[index])
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 100)
          .background(Color.red.opacity(0.1))
          .cornerRadius(8)
        }
        
        VStack(alignment: .leading) {
          Text("CurrentValueSubject")
            .font(.subheadline)
            .bold()
          
          Text("(保存当前值)")
            .font(.caption)
            .foregroundColor(.secondary)
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(currentValueMessages.indices, id: \.self) { index in
                Text(currentValueMessages[index])
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 100)
          .background(Color.green.opacity(0.1))
          .cornerRadius(8)
        }
      }
      
      Button("清空所有消息") {
        passthroughMessages.removeAll()
        currentValueMessages.removeAll()
      }
    }
    .padding()
  }
  
  private func subscribeToSubjects() {
    passthroughSubject
      .sink { message in
        passthroughMessages.append("PT: \(message)")
      }
      .store(in: &cancellables)
    
    currentValueSubject
      .sink { message in
        currentValueMessages.append("CV: \(message)")
      }
      .store(in: &cancellables)
  }
}

// MARK: - 订阅方式示例

// Sink 订阅示例
struct SinkSubscriberExample: View {
  @State private var values: [String] = []
  @State private var completionStatus: String = "未完成"
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Sink 订阅演示")
        .font(.headline)
      
      Text("Sink 是最常用的订阅方式")
        .foregroundColor(.secondary)
      
      Text("完成状态: \(completionStatus)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Button("启动数据流") {
        values.removeAll()
        completionStatus = "进行中..."
        
        let publisher = ["苹果", "香蕉", "橘子"].publisher
        
        cancellable = publisher.sink(
          receiveCompletion: { completion in
            switch completion {
            case .finished:
              completionStatus = "成功完成"
            case .failure(let error):
              completionStatus = "错误: \(error.localizedDescription)"
            }
          },
          receiveValue: { value in
            values.append(value)
          }
        )
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(values.indices, id: \.self) { index in
            Text("\(index + 1). \(values[index])")
          }
        }
      }
      .frame(maxHeight: 100)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("重置") {
        values.removeAll()
        completionStatus = "未完成"
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// Assign 订阅示例
struct AssignSubscriberExample: View {
  @StateObject private var viewModel = AssignExampleViewModel()
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Assign 订阅演示")
        .font(.headline)
      
      Text("Assign 直接将值赋给对象属性")
        .foregroundColor(.secondary)
      
      Text("ViewModel 文本: \(viewModel.text)")
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      Text("ViewModel 数字: \(viewModel.number)")
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
      
      Button("更新文本") {
        let publisher = Just("更新时间: \(Date())")
        cancellable = publisher.assign(to: \.text, on: viewModel)
      }
      
      Button("更新数字") {
        let publisher = Just(Int.random(in: 1...100))
        cancellable = publisher.assign(to: \.number, on: viewModel)
      }
    }
    .padding()
  }
}

class AssignExampleViewModel: ObservableObject {
  @Published var text: String = "初始文本"
  @Published var number: Int = 0
}

// 自定义订阅者示例
struct CustomSubscriberExample: View {
  @State private var logs: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("自定义订阅者演示")
        .font(.headline)
      
      Text("实现自定义的 Subscriber 协议")
        .foregroundColor(.secondary)
      
      Button("启动自定义订阅") {
        logs.removeAll()
        
        let publisher = (1...5).publisher
        let customSubscriber = CustomStringSubscriber { log in
          logs.append(log)
        }
        
        publisher
          .map { "数字: \($0)" }
          .subscribe(customSubscriber)
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(logs.indices, id: \.self) { index in
            Text(logs[index])
              .font(.caption)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("清空日志") {
        logs.removeAll()
      }
    }
    .padding()
  }
}

class CustomStringSubscriber: Subscriber {
  typealias Input = String
  typealias Failure = Never
  
  private let onLog: (String) -> Void
  
  init(onLog: @escaping (String) -> Void) {
    self.onLog = onLog
  }
  
  func receive(subscription: Subscription) {
    onLog("🔗 订阅已建立")
    subscription.request(.unlimited)
  }
  
  func receive(_ input: String) -> Subscribers.Demand {
    onLog("📨 接收到: \(input)")
    return .none
  }
  
  func receive(completion: Subscribers.Completion<Never>) {
    onLog("✅ 订阅完成")
  }
}

// MARK: - 数据流控制示例

// 操作符链示例
struct OperatorChainExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("操作符链演示")
        .font(.headline)
      
      Text("展示多个操作符的链式调用")
        .foregroundColor(.secondary)
      
      Button("启动数据流处理") {
        results.removeAll()
        
        let publisher = (1...10).publisher
        
        cancellable = publisher
          .filter { $0 % 2 == 0 }  // 只保留偶数
          .map { "偶数: \($0)" }    // 转换为字符串
          .prefix(3)               // 只取前3个
          .sink { value in
            results.append(value)
          }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
          }
        }
      }
      .frame(maxHeight: 100)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("重置") {
        results.removeAll()
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// 背压处理示例
struct BackpressureExample: View {
  @State private var status: String = "未启动"
  @State private var receivedCount: Int = 0
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("背压处理演示")
        .font(.headline)
      
      Text("使用 buffer 处理快速数据流")
        .foregroundColor(.secondary)
      
      Text("状态: \(status)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      
      Text("已接收: \(receivedCount) 个值")
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      Button("启动快速数据流") {
        status = "正在处理..."
        receivedCount = 0
        
        let publisher = Timer.publish(every: 0.1, on: .main, in: .common)
          .autoconnect()
          .map { _ in Int.random(in: 1...100) }
          .prefix(20)  // 限制为20个值
        
        cancellable = publisher
          .buffer(size: 5, prefetch: .keepFull, whenFull: .dropOldest)
          .sink(
            receiveCompletion: { _ in
              status = "完成"
            },
            receiveValue: { value in
              receivedCount += 1
              if receivedCount == 20 {
                status = "所有数据处理完成"
              }
            }
          )
      }
      
      Button("停止") {
        cancellable?.cancel()
        status = "已停止"
      }
    }
    .padding()
  }
}

// 数据转换示例
struct DataTransformExample: View {
  @State private var originalData: [Int] = []
  @State private var transformedData: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("数据转换演示")
        .font(.headline)
      
      Text("使用 filter、map 等操作符转换数据")
        .foregroundColor(.secondary)
      
      Button("生成和转换数据") {
        originalData.removeAll()
        transformedData.removeAll()
        
                let allNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        originalData = allNumbers
        
        let publisher = allNumbers.publisher
        
        cancellable = publisher
            .filter { number in number % 2 == 0 }  // 只保留偶数
            .map { number in number * 2 }          // 乘以2
            .map { number in "结果: \(number)" }    // 转换为字符串
            .collect()                             // 收集所有结果
            .sink { results in
                transformedData = results
            }
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("原始数据:")
            .font(.subheadline)
            .bold()
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(originalData.indices, id: \.self) { index in
                Text("\(originalData[index])")
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 100)
          .background(Color.red.opacity(0.1))
          .cornerRadius(8)
        }
        
        VStack(alignment: .leading) {
          Text("转换结果:")
            .font(.subheadline)
            .bold()
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(transformedData.indices, id: \.self) { index in
                Text(transformedData[index])
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 100)
          .background(Color.green.opacity(0.1))
          .cornerRadius(8)
        }
      }
    }
    .padding()
  }
}

// MARK: - 生命周期管理示例

// 订阅存储示例
struct SubscriptionStorageExample: View {
  @StateObject private var manager = SubscriptionManager()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("订阅存储演示")
        .font(.headline)
      
      Text("正确管理订阅的生命周期")
        .foregroundColor(.secondary)
      
      Text("活跃订阅数: \(manager.activeSubscriptions)")
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      Text("接收到的消息数: \(manager.messageCount)")
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
      
      HStack {
        Button("添加订阅") {
          manager.addSubscription()
        }
        
        Button("清除所有订阅") {
          manager.clearAllSubscriptions()
        }
      }
      
      Button("发送测试消息") {
        manager.sendTestMessage()
      }
    }
    .padding()
  }
}

class SubscriptionManager: ObservableObject {
  @Published var activeSubscriptions: Int = 0
  @Published var messageCount: Int = 0
  
  private var cancellables = Set<AnyCancellable>()
  private let testSubject = PassthroughSubject<String, Never>()
  
  func addSubscription() {
    let subscription = testSubject
      .sink { [weak self] message in
        self?.messageCount += 1
      }
    
    subscription.store(in: &cancellables)
    activeSubscriptions = cancellables.count
  }
  
  func clearAllSubscriptions() {
    cancellables.removeAll()
    activeSubscriptions = 0
    messageCount = 0
  }
  
  func sendTestMessage() {
    testSubject.send("测试消息 \(Date())")
  }
}

// 取消订阅示例
struct CancellationExample: View {
  @State private var isSubscribed = false
  @State private var receivedMessages: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let messageSubject = PassthroughSubject<String, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("取消订阅演示")
        .font(.headline)
      
      Text("订阅状态: \(isSubscribed ? "已订阅" : "未订阅")")
        .padding()
        .background(isSubscribed ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(8)
      
      HStack {
        Button(isSubscribed ? "取消订阅" : "开始订阅") {
          if isSubscribed {
            cancellable?.cancel()
            cancellable = nil
            isSubscribed = false
          } else {
            startSubscription()
            isSubscribed = true
          }
        }
        
        Button("发送消息") {
          messageSubject.send("消息 \(receivedMessages.count + 1)")
        }
        .disabled(!isSubscribed)
        
        Button("清空") {
          receivedMessages.removeAll()
        }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(receivedMessages.indices, id: \.self) { index in
            Text(receivedMessages[index])
          }
        }
      }
      .frame(maxHeight: 100)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func startSubscription() {
    cancellable = messageSubject.sink { message in
      receivedMessages.append(message)
    }
  }
}

// 内存管理示例
struct MemoryManagementExample: View {
  @StateObject private var memoryManager = MemoryManager()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("内存管理演示")
        .font(.headline)
      
      Text("展示正确的内存管理模式")
        .foregroundColor(.secondary)
      
      Text("Manager 实例数: \(memoryManager.instanceCount)")
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      Text("活跃订阅: \(memoryManager.hasActiveSubscription ? "是" : "否")")
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
      
      HStack {
        Button("创建订阅") {
          memoryManager.createSubscription()
        }
        
        Button("清理订阅") {
          memoryManager.cleanup()
        }
      }
      
      Text("注意: 使用 weak self 避免循环引用")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

class MemoryManager: ObservableObject {
  @Published var instanceCount: Int = 1
  @Published var hasActiveSubscription: Bool = false
  
  private var cancellable: AnyCancellable?
  private let subject = PassthroughSubject<Int, Never>()
  
  init() {
    instanceCount += 1
  }
  
  deinit {
    instanceCount -= 1
  }
  
  func createSubscription() {
    // 正确的内存管理：使用 weak self
    cancellable = subject
      .sink { [weak self] value in
        // 避免循环引用
        self?.handleValue(value)
      }
    
    hasActiveSubscription = true
    
    // 模拟数据发送
    subject.send(42)
  }
  
  func cleanup() {
    cancellable?.cancel()
    cancellable = nil
    hasActiveSubscription = false
  }
  
  private func handleValue(_ value: Int) {
    print("处理值: \(value)")
  }
}

// MARK: - 组合发布者示例

// CombineLatest 示例
struct CombineLatestExample: View {
  @State private var text1 = ""
  @State private var text2 = ""
  @State private var combinedResult = "等待输入..."
  @State private var cancellable: AnyCancellable?
  
  private let subject1 = PassthroughSubject<String, Never>()
  private let subject2 = PassthroughSubject<String, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("CombineLatest 演示")
        .font(.headline)
      
      Text("组合两个发布者的最新值")
        .foregroundColor(.secondary)
      
      TextField("输入1", text: $text1)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onChange(of: text1) { newValue in
          subject1.send(newValue)
        }
      
      TextField("输入2", text: $text2)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onChange(of: text2) { newValue in
          subject2.send(newValue)
        }
      
      Text("组合结果: \(combinedResult)")
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = Publishers.CombineLatest(subject1, subject2)
        .map { text1, text2 in
          if text1.isEmpty && text2.isEmpty {
            return "等待输入..."
          } else {
            return "\"\(text1)\" + \"\(text2)\" = \"\(text1)\(text2)\""
          }
        }
        .sink { result in
          combinedResult = result
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Merge 示例
struct MergeExample: View {
  @State private var messages: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let subject1 = PassthroughSubject<String, Never>()
  private let subject2 = PassthroughSubject<String, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Merge 演示")
        .font(.headline)
      
      Text("合并多个发布者的输出")
        .foregroundColor(.secondary)
      
      HStack {
        Button("发送到流1") {
          subject1.send("流1: 消息\(messages.count + 1)")
        }
        
        Button("发送到流2") {
          subject2.send("流2: 消息\(messages.count + 1)")
        }
        
        Button("清空") {
          messages.removeAll()
        }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(messages.indices, id: \.self) { index in
            Text("\(index + 1). \(messages[index])")
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = Publishers.Merge(subject1, subject2)
        .sink { message in
          messages.append(message)
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Zip 示例
struct ZipExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Zip 演示")
        .font(.headline)
      
      Text("配对两个发布者的值")
        .foregroundColor(.secondary)
      
      Button("启动配对数据流") {
        results.removeAll()
        
        let names = ["张三", "李四", "王五", "赵六"].publisher
        let ages = [25, 30, 35, 40].publisher
        
        cancellable = Publishers.Zip(names, ages)
          .map { name, age in
            "\(name), \(age)岁"
          }
          .sink { result in
            results.append(result)
          }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text("\(index + 1). \(results[index])")
          }
        }
      }
      .frame(maxHeight: 100)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("重置") {
        results.removeAll()
        cancellable?.cancel()
      }
    }
    .padding()
  }
}

// MARK: - 实际应用示例

// 网络请求示例
struct NetworkRequestExample: View {
  @StateObject private var networkManager = NetworkManager()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("网络请求演示")
        .font(.headline)
      
      Text("使用 Combine 处理网络请求")
        .foregroundColor(.secondary)
      
      if networkManager.isLoading {
        ProgressView("加载中...")
          .frame(maxWidth: .infinity)
      }
      
      if let error = networkManager.error {
        Text("错误: \(error)")
          .foregroundColor(.red)
          .padding()
          .background(Color.red.opacity(0.1))
          .cornerRadius(8)
      }
      
      if !networkManager.data.isEmpty {
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(networkManager.data.indices, id: \.self) { index in
              Text(networkManager.data[index])
                .padding(.vertical, 2)
            }
          }
        }
        .frame(maxHeight: 150)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
      }
      
      Button("发起网络请求") {
        networkManager.fetchData()
      }
      .disabled(networkManager.isLoading)
    }
    .padding()
  }
}

class NetworkManager: ObservableObject {
  @Published var isLoading = false
  @Published var data: [String] = []
  @Published var error: String?
  
  private var cancellables = Set<AnyCancellable>()
  
  func fetchData() {
    isLoading = true
    error = nil
    data.removeAll()
    
    // 模拟网络请求
    simulateNetworkRequest()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.isLoading = false
          if case .failure(let error) = completion {
            self?.error = error.localizedDescription
          }
        },
        receiveValue: { [weak self] data in
          self?.data = data
        }
      )
      .store(in: &cancellables)
  }
  
  private func simulateNetworkRequest() -> AnyPublisher<[String], Error> {
    Future<[String], Error> { promise in
      DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        if Bool.random() {
          promise(.success(["数据1", "数据2", "数据3", "数据4"]))
        } else {
          promise(.failure(PublisherSubscriberError.networkError))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// 用户输入处理示例
struct UserInputExample: View {
  @StateObject private var viewModel = UserInputViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("用户输入处理演示")
        .font(.headline)
      
      Text("防抖搜索实现")
        .foregroundColor(.secondary)
      
      TextField("搜索...", text: $viewModel.searchText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      if viewModel.isSearching {
        ProgressView("搜索中...")
          .frame(maxWidth: .infinity)
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(viewModel.searchResults.indices, id: \.self) { index in
            Text(viewModel.searchResults[index])
              .padding(.vertical, 2)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

class UserInputViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var searchResults: [String] = []
  @Published var isSearching = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    setupSearchPublisher()
  }
  
  private func setupSearchPublisher() {
    $searchText
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] searchTerm in
        self?.performSearch(searchTerm)
      }
      .store(in: &cancellables)
  }
  
  private func performSearch(_ term: String) {
    guard !term.isEmpty else {
      searchResults.removeAll()
      return
    }
    
    isSearching = true
    
    // 模拟搜索延迟
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.searchResults = [
        "\(term) - 结果1",
        "\(term) - 结果2",
        "\(term) - 结果3"
      ]
      self?.isSearching = false
    }
  }
}

// 定时器应用示例
struct TimerApplicationExample: View {
  @State private var timeElapsed: Int = 0
  @State private var isRunning = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("定时器应用演示")
        .font(.headline)
      
      Text("使用 Timer Publisher")
        .foregroundColor(.secondary)
      
      Text("已经过: \(timeElapsed) 秒")
        .font(.title2)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      HStack {
        Button(isRunning ? "暂停" : "开始") {
          if isRunning {
            stopTimer()
          } else {
            startTimer()
          }
        }
        
        Button("重置") {
          stopTimer()
          timeElapsed = 0
        }
      }
    }
    .padding()
  }
  
  private func startTimer() {
    isRunning = true
    cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { _ in
        timeElapsed += 1
      }
  }
  
  private func stopTimer() {
    isRunning = false
    cancellable?.cancel()
    cancellable = nil
  }
}

// MARK: - 高级特性示例

// 自定义 Publisher 示例
struct CustomPublisherExample: View {
  @State private var countdownValues: [Int] = []
  @State private var isCountingDown = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("自定义 Publisher 演示")
        .font(.headline)
      
      Text("创建自定义的倒计时 Publisher")
        .foregroundColor(.secondary)
      
      Button("开始倒计时 (从5)") {
        countdownValues.removeAll()
        isCountingDown = true
        
        let customPublisher = CountdownPublisher(start: 5)
        
        cancellable = customPublisher
          .sink(
            receiveCompletion: { _ in
              isCountingDown = false
            },
            receiveValue: { value in
              countdownValues.append(value)
            }
          )
      }
      .disabled(isCountingDown)
      
      if isCountingDown {
        ProgressView("倒计时中...")
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(countdownValues.indices, id: \.self) { index in
            Text("倒计时: \(countdownValues[index])")
          }
        }
      }
      .frame(maxHeight: 100)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("停止") {
        cancellable?.cancel()
        isCountingDown = false
      }
      .disabled(!isCountingDown)
    }
    .padding()
  }
}

// 自定义倒计时 Publisher
struct CountdownPublisher: Publisher {
  typealias Output = Int
  typealias Failure = Never
  
  let start: Int
  
  func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
    let subscription = CountdownSubscription(subscriber: subscriber, start: start)
    subscriber.receive(subscription: subscription)
  }
}

class CountdownSubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {
  private var subscriber: S?
  private var current: Int
  private var timer: Timer?
  
  init(subscriber: S, start: Int) {
    self.subscriber = subscriber
    self.current = start
  }
  
  func request(_ demand: Subscribers.Demand) {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      if self.current >= 0 {
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

// 错误处理示例
struct ErrorHandlingExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("错误处理演示")
        .font(.headline)
      
      Text("展示各种错误处理策略")
        .foregroundColor(.secondary)
      
      HStack {
        Button("重试机制") {
          results.removeAll()
          demonstrateRetry()
        }
        
        Button("错误恢复") {
          results.removeAll()
          demonstrateRecover()
        }
        
        Button("错误映射") {
          results.removeAll()
          demonstrateMapError()
        }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
              .font(.caption)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("清空") {
        results.removeAll()
      }
    }
    .padding()
  }
  
  private func demonstrateRetry() {
    let flakyPublisher = createFlakyPublisher()
    
    cancellable = flakyPublisher
      .retry(3)
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            results.append("✅ 成功完成")
          case .failure(let error):
            results.append("❌ 重试失败: \(error.localizedDescription)")
          }
        },
        receiveValue: { value in
          results.append("📨 接收: \(value)")
        }
      )
  }
  
  private func demonstrateRecover() {
    let flakyPublisher = createFlakyPublisher()
    
    cancellable = flakyPublisher
      .catch { error in
        Just("恢复值: 从错误中恢复")
      }
      .sink { value in
        results.append("📨 接收: \(value)")
      }
  }
  
  private func demonstrateMapError() {
    let flakyPublisher = createFlakyPublisher()
    
    cancellable = flakyPublisher
      .mapError { error in
        PublisherSubscriberError.customError("自定义错误: \(error.localizedDescription)")
      }
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            results.append("❌ 映射错误: \(error.localizedDescription)")
          }
        },
        receiveValue: { value in
          results.append("📨 接收: \(value)")
        }
      )
  }
  
  private func createFlakyPublisher() -> AnyPublisher<String, PublisherSubscriberError> {
    Future<String, PublisherSubscriberError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if Bool.random() {
          promise(.success("成功的数据"))
        } else {
          promise(.failure(.networkError))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// 性能优化示例
struct PerformanceOptimizationExample: View {
  @State private var measurements: [String] = []
  @State private var cancellables = Set<AnyCancellable>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("性能优化演示")
        .font(.headline)
      
      Text("展示性能优化技巧")
        .foregroundColor(.secondary)
      
      HStack {
        Button("Share 操作符") {
          measurements.removeAll()
          demonstrateShare()
        }
        
        Button("防抖优化") {
          measurements.removeAll()
          demonstrateDebounce()
        }
        
        Button("批处理") {
          measurements.removeAll()
          demonstrateBatching()
        }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(measurements.indices, id: \.self) { index in
            Text(measurements[index])
              .font(.caption)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
      
      Button("清空") {
        measurements.removeAll()
        cancellables.removeAll()
      }
    }
    .padding()
  }
  
  private func demonstrateShare() {
    let expensivePublisher = createExpensivePublisher().share()
    
    // 多个订阅者共享同一个计算结果
    expensivePublisher
      .sink { value in
        measurements.append("订阅者1: \(value)")
      }
      .store(in: &cancellables)
    
    expensivePublisher
      .sink { value in
        measurements.append("订阅者2: \(value)")
      }
      .store(in: &cancellables)
  }
  
  private func demonstrateDebounce() {
    let rapidFirePublisher = Timer.publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .map { _ in "快速消息" }
      .prefix(10)
    
    rapidFirePublisher
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .sink { value in
        measurements.append("防抖后: \(value)")
      }
      .store(in: &cancellables)
  }
  
  private func demonstrateBatching() {
    let dataStream = (1...20).publisher
    
    dataStream
      .collect(5)  // 批量收集5个元素
      .sink { batch in
        measurements.append("批次: \(batch)")
      }
      .store(in: &cancellables)
  }
  
  private func createExpensivePublisher() -> AnyPublisher<String, Never> {
    Future<String, Never> { promise in
      // 模拟昂贵的计算
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        promise(.success("昂贵计算结果"))
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - 错误类型定义

enum PublisherSubscriberError: LocalizedError {
  case networkError
  case customError(String)
  
  var errorDescription: String? {
    switch self {
    case .networkError:
      return "网络连接错误"
    case .customError(let message):
      return message
    }
  }
}

// MARK: - 预览

#Preview {
  NavigationView {
    PublisherSubscriberDemoView()
  }
}
