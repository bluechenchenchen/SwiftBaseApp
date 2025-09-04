import SwiftUI
import Combine

// MARK: - 主演示视图

struct CombineOperatorsDemoView: View {
  var body: some View {
    ShowcaseList {
      ShowcaseSection("转换操作符") {
        ShowcaseItem(title: "Map 映射") {
          CombineOperatorsMapExample()
        }
        
        ShowcaseItem(title: "FlatMap 扁平化映射") {
          CombineOperatorsFlatMapExample()
        }
        
        ShowcaseItem(title: "Scan 累积扫描") {
          CombineOperatorsScanExample()
        }
        
        ShowcaseItem(title: "TryMap 可抛出映射") {
          CombineOperatorsTryMapExample()
        }
      }
      
      ShowcaseSection("过滤操作符") {
        ShowcaseItem(title: "Filter 条件过滤") {
          CombineOperatorsFilterExample()
        }
        
        ShowcaseItem(title: "RemoveDuplicates 去重") {
          CombineOperatorsRemoveDuplicatesExample()
        }
        
        ShowcaseItem(title: "DropFirst 跳过开头") {
          CombineOperatorsDropFirstExample()
        }
        
        ShowcaseItem(title: "Prefix 取前几个") {
          CombineOperatorsPrefixExample()
        }
      }
      
      ShowcaseSection("组合操作符") {
        ShowcaseItem(title: "CombineLatest 组合最新值") {
          CombineOperatorsCombineLatestExample()
        }
        
        ShowcaseItem(title: "Merge 合并流") {
          CombineOperatorsMergeExample()
        }
        
        ShowcaseItem(title: "Zip 配对组合") {
          CombineOperatorsZipExample()
        }
        
        ShowcaseItem(title: "SwitchToLatest 切换到最新") {
          CombineOperatorsSwitchToLatestExample()
        }
      }
      
      ShowcaseSection("错误处理操作符") {
        ShowcaseItem(title: "Catch 错误捕获") {
          CombineOperatorsCatchExample()
        }
        
        ShowcaseItem(title: "Retry 重试机制") {
          CombineOperatorsRetryExample()
        }
        
        ShowcaseItem(title: "MapError 错误转换") {
          CombineOperatorsMapErrorExample()
        }
        
        ShowcaseItem(title: "ReplaceError 错误替换") {
          CombineOperatorsReplaceErrorExample()
        }
      }
      
      ShowcaseSection("时间操作符") {
        ShowcaseItem(title: "Debounce 防抖") {
          CombineOperatorsDebounceExample()
        }
        
        ShowcaseItem(title: "Throttle 节流") {
          CombineOperatorsThrottleExample()
        }
        
        ShowcaseItem(title: "Delay 延迟") {
          CombineOperatorsDelayExample()
        }
        
        ShowcaseItem(title: "Timeout 超时") {
          CombineOperatorsTimeoutExample()
        }
      }
      
      ShowcaseSection("聚合操作符") {
        ShowcaseItem(title: "Reduce 归约") {
          CombineOperatorsReduceExample()
        }
        
        ShowcaseItem(title: "Collect 收集") {
          CombineOperatorsCollectExample()
        }
        
        ShowcaseItem(title: "Count 计数") {
          CombineOperatorsCountExample()
        }
        
        ShowcaseItem(title: "Min/Max 最值") {
          CombineOperatorsMinMaxExample()
        }
      }
      
      ShowcaseSection("高级应用") {
        ShowcaseItem(title: "操作符链组合") {
          CombineOperatorsChainExample()
        }
        
        ShowcaseItem(title: "实时搜索") {
          CombineOperatorsSearchExample()
        }
        
        ShowcaseItem(title: "数据验证管道") {
          CombineOperatorsValidationExample()
        }
        
        ShowcaseItem(title: "多源数据聚合") {
          CombineOperatorsAggregationExample()
        }
      }
    }
    .navigationTitle("Combine 操作符")
  }
}

// MARK: - 转换操作符示例

// Map 映射示例
struct CombineOperatorsMapExample: View {
  @State private var numbers: [Int] = []
  @State private var mappedNumbers: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Map 映射演示")
        .font(.headline)
      
      Text("将数字转换为格式化字符串")
        .foregroundColor(.secondary)
      
      Button("生成数字并映射") {
        numbers.removeAll()
        mappedNumbers.removeAll()
        
        let originalNumbers = Array(1...5)
        numbers = originalNumbers
        
        cancellable = originalNumbers.publisher
          .map { number in
            "数字: \(number) (平方: \(number * number))"
          }
          .collect()
          .sink { results in
            mappedNumbers = results
          }
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("原始数据:")
            .font(.subheadline)
            .bold()
          
          ForEach(numbers.indices, id: \.self) { index in
            Text("\(numbers[index])")
              .font(.caption)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(alignment: .leading) {
          Text("映射结果:")
            .font(.subheadline)
            .bold()
          
          ForEach(mappedNumbers.indices, id: \.self) { index in
            Text(mappedNumbers[index])
              .font(.caption)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// FlatMap 扁平化映射示例
struct CombineOperatorsFlatMapExample: View {
  @State private var users: [CombineOperatorsUser] = []
  @State private var isLoading = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("FlatMap 扁平化映射演示")
        .font(.headline)
      
      Text("从用户ID获取用户详细信息")
        .foregroundColor(.secondary)
      
      Button("获取用户信息") {
        users.removeAll()
        isLoading = true
        
        let userIds = [1, 2, 3]
        
        cancellable = userIds.publisher
          .flatMap { id in
            fetchUserInfo(id: id)
          }
          .collect()
          .sink { fetchedUsers in
            users = fetchedUsers
            isLoading = false
          }
      }
      .disabled(isLoading)
      
      if isLoading {
        ProgressView("加载用户信息...")
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(users) { user in
            VStack(alignment: .leading) {
              Text("ID: \(user.id)")
                .font(.caption)
                .bold()
              Text("姓名: \(user.name)")
                .font(.caption)
              Text("邮箱: \(user.email)")
                .font(.caption)
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(6)
          }
        }
      }
      .frame(maxHeight: 150)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func fetchUserInfo(id: Int) -> AnyPublisher<CombineOperatorsUser, Never> {
    Future<CombineOperatorsUser, Never> { promise in
      // 模拟异步网络请求
      DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.5)) {
        let user = CombineOperatorsUser(
          id: id,
          name: "用户\(id)",
          email: "user\(id)@example.com"
        )
        promise(.success(user))
      }
    }
    .eraseToAnyPublisher()
  }
}

// Scan 累积扫描示例
struct CombineOperatorsScanExample: View {
  @State private var numbers: [Int] = []
  @State private var scannedResults: [Int] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Scan 累积扫描演示")
        .font(.headline)
      
      Text("计算累积和（每次都输出中间结果）")
        .foregroundColor(.secondary)
      
      Button("开始累积计算") {
        numbers.removeAll()
        scannedResults.removeAll()
        
        let sourceNumbers = [1, 2, 3, 4, 5]
        numbers = sourceNumbers
        
        cancellable = sourceNumbers.publisher
          .scan(0) { accumulator, value in
            print("累积: \(accumulator) + \(value) = \(accumulator + value)")
            return accumulator + value
          }
          .collect()
          .sink { results in
            scannedResults = results
          }
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("输入数字:")
            .font(.subheadline)
            .bold()
          
          ForEach(numbers.indices, id: \.self) { index in
            Text("\(numbers[index])")
              .font(.caption)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(alignment: .leading) {
          Text("累积和:")
            .font(.subheadline)
            .bold()
          
          ForEach(scannedResults.indices, id: \.self) { index in
            Text("\(scannedResults[index])")
              .font(.caption)
              .foregroundColor(.blue)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// TryMap 可抛出映射示例
struct CombineOperatorsTryMapExample: View {
  @State private var inputStrings: [String] = []
  @State private var results: [String] = []
  @State private var errorMessage: String?
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("TryMap 可抛出映射演示")
        .font(.headline)
      
      Text("尝试将字符串转换为数字")
        .foregroundColor(.secondary)
      
      Button("处理混合数据") {
        results.removeAll()
        errorMessage = nil
        
        let testData = ["1", "2", "invalid", "4", "5"]
        inputStrings = testData
        
        cancellable = testData.publisher
          .tryMap { string -> String in
            guard let number = Int(string) else {
              throw CombineOperatorsError.invalidNumber(string)
            }
            return "转换成功: \(number)"
          }
          .sink(
            receiveCompletion: { completion in
              if case .failure(let error) = completion {
                errorMessage = error.localizedDescription
              }
            },
            receiveValue: { result in
              results.append(result)
            }
          )
      }
      
      VStack(alignment: .leading) {
        Text("输入数据: \(inputStrings.joined(separator: ", "))")
          .font(.caption)
        
        Text("转换结果:")
          .font(.subheadline)
          .bold()
        
        ForEach(results.indices, id: \.self) { index in
          Text(results[index])
            .font(.caption)
            .foregroundColor(.green)
        }
        
        if let error = errorMessage {
          Text("错误: \(error)")
            .font(.caption)
            .foregroundColor(.red)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// MARK: - 过滤操作符示例

// Filter 条件过滤示例
struct CombineOperatorsFilterExample: View {
  @State private var allNumbers: [Int] = []
  @State private var filteredNumbers: [Int] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Filter 条件过滤演示")
        .font(.headline)
      
      Text("过滤出偶数")
        .foregroundColor(.secondary)
      
      Button("生成并过滤数字") {
        allNumbers.removeAll()
        filteredNumbers.removeAll()
        
        let numbers = Array(1...10)
        allNumbers = numbers
        
        cancellable = numbers.publisher
          .filter { $0 % 2 == 0 }  // 只保留偶数
          .collect()
          .sink { evenNumbers in
            filteredNumbers = evenNumbers
          }
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("所有数字:")
            .font(.subheadline)
            .bold()
          
          Text(allNumbers.map(String.init).joined(separator: ", "))
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(alignment: .leading) {
          Text("过滤结果 (偶数):")
            .font(.subheadline)
            .bold()
          
          Text(filteredNumbers.map(String.init).joined(separator: ", "))
            .font(.caption)
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// RemoveDuplicates 去重示例
struct CombineOperatorsRemoveDuplicatesExample: View {
  @State private var originalValues: [Int] = []
  @State private var deduplicatedValues: [Int] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("RemoveDuplicates 去重演示")
        .font(.headline)
      
      Text("移除连续重复的值")
        .foregroundColor(.secondary)
      
      Button("处理重复数据") {
        originalValues.removeAll()
        deduplicatedValues.removeAll()
        
        let values = [1, 1, 2, 2, 2, 3, 2, 1, 1, 4]
        originalValues = values
        
        cancellable = values.publisher
          .removeDuplicates()
          .collect()
          .sink { uniqueValues in
            deduplicatedValues = uniqueValues
          }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("原始数据: \(originalValues.map(String.init).joined(separator: ", "))")
          .font(.caption)
        
        Text("去重结果: \(deduplicatedValues.map(String.init).joined(separator: ", "))")
          .font(.caption)
          .foregroundColor(.blue)
        
        Text("注意：只移除连续重复的值")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// DropFirst 跳过开头示例
struct CombineOperatorsDropFirstExample: View {
  @State private var allValues: [String] = []
  @State private var droppedValues: [String] = []
  @State private var dropCount = 2
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("DropFirst 跳过开头演示")
        .font(.headline)
      
      Text("跳过前面指定数量的值")
        .foregroundColor(.secondary)
      
      VStack(alignment: .leading) {
        HStack {
          Text("跳过数量:")
          Stepper("\(dropCount)", value: $dropCount, in: 0...5)
            .frame(width: 100)
        }
        
        Button("生成并跳过数据") {
          allValues.removeAll()
          droppedValues.removeAll()
          
          let values = ["A", "B", "C", "D", "E", "F"]
          allValues = values
          
          cancellable = values.publisher
            .dropFirst(dropCount)
            .collect()
            .sink { remainingValues in
              droppedValues = remainingValues
            }
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("所有数据: \(allValues.joined(separator: ", "))")
          .font(.caption)
        
        Text("跳过前\(dropCount)个后: \(droppedValues.joined(separator: ", "))")
          .font(.caption)
          .foregroundColor(.blue)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// Prefix 取前几个示例
struct CombineOperatorsPrefixExample: View {
  @State private var allValues: [String] = []
  @State private var prefixValues: [String] = []
  @State private var takeCount = 3
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Prefix 取前几个演示")
        .font(.headline)
      
      Text("只取前面指定数量的值")
        .foregroundColor(.secondary)
      
      VStack(alignment: .leading) {
        HStack {
          Text("取前几个:")
          Stepper("\(takeCount)", value: $takeCount, in: 1...6)
            .frame(width: 100)
        }
        
        Button("生成并取前几个") {
          allValues.removeAll()
          prefixValues.removeAll()
          
          let values = ["第1个", "第2个", "第3个", "第4个", "第5个", "第6个"]
          allValues = values
          
          cancellable = values.publisher
            .prefix(takeCount)
            .collect()
            .sink { firstFew in
              prefixValues = firstFew
            }
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("所有数据: \(allValues.joined(separator: ", "))")
          .font(.caption)
        
        Text("前\(takeCount)个: \(prefixValues.joined(separator: ", "))")
          .font(.caption)
          .foregroundColor(.blue)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// MARK: - 组合操作符示例

// CombineLatest 组合最新值示例
struct CombineOperatorsCombineLatestExample: View {
  @State private var stream1Values: [String] = []
  @State private var stream2Values: [Int] = []
  @State private var combinedResults: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let subject1 = PassthroughSubject<String, Never>()
  private let subject2 = PassthroughSubject<Int, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("CombineLatest 组合最新值演示")
        .font(.headline)
      
      Text("组合两个流的最新值")
        .foregroundColor(.secondary)
      
      HStack {
        Button("发送字母") {
          let letter = ["A", "B", "C"].randomElement()!
          stream1Values.append(letter)
          subject1.send(letter)
        }
        
        Button("发送数字") {
          let number = Int.random(in: 1...9)
          stream2Values.append(number)
          subject2.send(number)
        }
        
        Button("重置") {
          stream1Values.removeAll()
          stream2Values.removeAll()
          combinedResults.removeAll()
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("字母流: \(stream1Values.joined(separator: ", "))")
          .font(.caption)
        
        Text("数字流: \(stream2Values.map(String.init).joined(separator: ", "))")
          .font(.caption)
        
        Text("组合结果:")
          .font(.caption)
          .bold()
        
        ForEach(combinedResults.indices, id: \.self) { index in
          Text(combinedResults[index])
            .font(.caption)
            .foregroundColor(.blue)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = Publishers.CombineLatest(subject1, subject2)
        .map { letter, number in
          "\(letter)\(number)"
        }
        .sink { combined in
          combinedResults.append(combined)
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Merge 合并流示例
struct CombineOperatorsMergeExample: View {
  @State private var stream1Events: [String] = []
  @State private var stream2Events: [String] = []
  @State private var mergedEvents: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let subject1 = PassthroughSubject<String, Never>()
  private let subject2 = PassthroughSubject<String, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Merge 合并流演示")
        .font(.headline)
      
      Text("将多个流合并为一个")
        .foregroundColor(.secondary)
      
      HStack {
        Button("流1发送") {
          let message = "流1-\(stream1Events.count + 1)"
          stream1Events.append(message)
          subject1.send(message)
        }
        
        Button("流2发送") {
          let message = "流2-\(stream2Events.count + 1)"
          stream2Events.append(message)
          subject2.send(message)
        }
        
        Button("清空") {
          stream1Events.removeAll()
          stream2Events.removeAll()
          mergedEvents.removeAll()
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("流1事件: \(stream1Events.joined(separator: ", "))")
          .font(.caption)
        
        Text("流2事件: \(stream2Events.joined(separator: ", "))")
          .font(.caption)
        
        Text("合并结果:")
          .font(.caption)
          .bold()
        
        Text(mergedEvents.joined(separator: ", "))
          .font(.caption)
          .foregroundColor(.blue)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = Publishers.Merge(subject1, subject2)
        .sink { event in
          mergedEvents.append(event)
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Zip 配对组合示例
struct CombineOperatorsZipExample: View {
  @State private var names: [String] = []
  @State private var ages: [Int] = []
  @State private var zippedResults: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Zip 配对组合演示")
        .font(.headline)
      
      Text("将两个流的值一一配对")
        .foregroundColor(.secondary)
      
      Button("生成配对数据") {
        names.removeAll()
        ages.removeAll()
        zippedResults.removeAll()
        
        let nameList = ["张三", "李四", "王五", "赵六"]
        let ageList = [25, 30, 35, 40]
        
        names = nameList
        ages = ageList
        
        cancellable = Publishers.Zip(nameList.publisher, ageList.publisher)
          .map { name, age in
            "\(name), \(age)岁"
          }
          .collect()
          .sink { pairs in
            zippedResults = pairs
          }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("姓名: \(names.joined(separator: ", "))")
          .font(.caption)
        
        Text("年龄: \(ages.map(String.init).joined(separator: ", "))")
          .font(.caption)
        
        Text("配对结果:")
          .font(.caption)
          .bold()
        
        ForEach(zippedResults.indices, id: \.self) { index in
          Text(zippedResults[index])
            .font(.caption)
            .foregroundColor(.blue)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// SwitchToLatest 切换到最新示例
struct CombineOperatorsSwitchToLatestExample: View {
  @State private var currentPublisher = 1
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let publisherSubject = PassthroughSubject<AnyPublisher<String, Never>, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("SwitchToLatest 切换到最新演示")
        .font(.headline)
      
      Text("切换到最新的内部发布者")
        .foregroundColor(.secondary)
      
      HStack {
        Button("切换到发布者1") {
          currentPublisher = 1
          let publisher = createTimerPublisher(id: 1, interval: 1.0)
          publisherSubject.send(publisher)
        }
        
        Button("切换到发布者2") {
          currentPublisher = 2
          let publisher = createTimerPublisher(id: 2, interval: 0.5)
          publisherSubject.send(publisher)
        }
        
        Button("清空结果") {
          results.removeAll()
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("当前发布者: \(currentPublisher)")
          .font(.caption)
          .bold()
        
        Text("接收到的值:")
          .font(.caption)
          .bold()
        
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(results.indices, id: \.self) { index in
              Text(results[index])
                .font(.caption)
            }
          }
        }
        .frame(maxHeight: 100)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = publisherSubject
        .switchToLatest()
        .sink { value in
          results.append(value)
          // 限制显示的结果数量
          if results.count > 10 {
            results.removeFirst()
          }
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
  
  private func createTimerPublisher(id: Int, interval: TimeInterval) -> AnyPublisher<String, Never> {
    Timer.publish(every: interval, on: .main, in: .common)
      .autoconnect()
      .map { _ in "发布者\(id): \(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100))" }
      .eraseToAnyPublisher()
  }
}

// MARK: - 错误处理操作符示例

// Catch 错误捕获示例
struct CombineOperatorsCatchExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Catch 错误捕获演示")
        .font(.headline)
      
      Text("捕获错误并提供替代值")
        .foregroundColor(.secondary)
      
      Button("模拟错误和恢复") {
        results.removeAll()
        
        let publisher = createFlakyPublisher()
        
        cancellable = publisher
          .catch { error in
            Just("错误已恢复: \(error.localizedDescription)")
          }
          .sink { value in
            results.append(value)
          }
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
              .font(.caption)
              .foregroundColor(results[index].contains("错误") ? .red : .green)
          }
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func createFlakyPublisher() -> AnyPublisher<String, CombineOperatorsError> {
    Future<String, CombineOperatorsError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if Bool.random() {
          promise(.success("操作成功!"))
        } else {
          promise(.failure(.networkError))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// Retry 重试机制示例
struct CombineOperatorsRetryExample: View {
  @State private var attempts: [String] = []
  @State private var isRunning = false
  @State private var cancellable: AnyCancellable?
  @State private var attemptCount = 0
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Retry 重试机制演示")
        .font(.headline)
      
      Text("失败时自动重试")
        .foregroundColor(.secondary)
      
      Button("开始重试演示") {
        attempts.removeAll()
        attemptCount = 0
        isRunning = true
        
        cancellable = createRetryablePublisher()
          .retry(3)  // 最多重试3次
          .sink(
            receiveCompletion: { completion in
              isRunning = false
              switch completion {
              case .finished:
                attempts.append("✅ 最终成功!")
              case .failure(let error):
                attempts.append("❌ 重试失败: \(error.localizedDescription)")
              }
            },
            receiveValue: { value in
              attempts.append("🎉 成功: \(value)")
            }
          )
      }
      .disabled(isRunning)
      
      if isRunning {
        ProgressView("重试中...")
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(attempts.indices, id: \.self) { index in
            Text(attempts[index])
              .font(.caption)
          }
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func createRetryablePublisher() -> AnyPublisher<String, CombineOperatorsError> {
    Future<String, CombineOperatorsError> { [self] promise in
      attemptCount += 1
      attempts.append("🔄 尝试 \(attemptCount)")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        // 模拟前几次失败，最后成功
        if attemptCount < 3 {
          promise(.failure(.networkError))
        } else {
          promise(.success("第\(attemptCount)次尝试成功"))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MapError 错误转换示例
struct CombineOperatorsMapErrorExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("MapError 错误转换演示")
        .font(.headline)
      
      Text("将网络错误转换为用户友好的错误")
        .foregroundColor(.secondary)
      
      Button("模拟错误转换") {
        results.removeAll()
        
        let networkPublisher = Fail<String, CombineOperatorsNetworkError>(
          error: .timeout
        )
        
        cancellable = networkPublisher
          .mapError { networkError -> CombineOperatorsUIError in
            switch networkError {
            case .timeout:
              return .userFriendlyError("网络超时，请检查网络连接")
            case .serverError:
              return .userFriendlyError("服务器繁忙，请稍后重试")
            case .unauthorized:
              return .userFriendlyError("登录已过期，请重新登录")
            }
          }
          .sink(
            receiveCompletion: { completion in
              if case .failure(let error) = completion {
                results.append("用户看到的错误: \(error.localizedDescription)")
              }
            },
            receiveValue: { value in
              results.append("成功: \(value)")
            }
          )
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
              .font(.caption)
              .foregroundColor(.red)
          }
        }
      }
      .frame(maxHeight: 80)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// ReplaceError 错误替换示例
struct CombineOperatorsReplaceErrorExample: View {
  @State private var results: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("ReplaceError 错误替换演示")
        .font(.headline)
      
      Text("用默认值替换任何错误")
        .foregroundColor(.secondary)
      
      Button("测试错误替换") {
        results.removeAll()
        
        let flakyPublisher = PassthroughSubject<String, CombineOperatorsError>()
        
        cancellable = flakyPublisher
          .replaceError(with: "默认值")
          .sink { value in
            results.append(value)
          }
        
        // 模拟发送一些值和错误
        flakyPublisher.send("正常值1")
        flakyPublisher.send("正常值2")
        flakyPublisher.send(completion: .failure(.networkError))
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
              .font(.caption)
              .foregroundColor(results[index] == "默认值" ? .orange : .green)
          }
        }
      }
      .frame(maxHeight: 80)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// MARK: - 时间操作符示例

// Debounce 防抖示例
struct CombineOperatorsDebounceExample: View {
  @StateObject private var viewModel = CombineOperatorsDebounceViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Debounce 防抖演示")
        .font(.headline)
      
      Text("搜索防抖 - 停止输入300ms后才搜索")
        .foregroundColor(.secondary)
      
      TextField("输入搜索关键词", text: $viewModel.searchText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      VStack(alignment: .leading) {
        Text("搜索历史:")
          .font(.subheadline)
          .bold()
        
        ForEach(viewModel.searchHistory.indices, id: \.self) { index in
          Text(viewModel.searchHistory[index])
            .font(.caption)
            .foregroundColor(.blue)
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

class CombineOperatorsDebounceViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var searchHistory: [String] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    $searchText
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .filter { !$0.isEmpty }
      .sink { [weak self] searchTerm in
        self?.performSearch(searchTerm)
      }
      .store(in: &cancellables)
  }
  
  private func performSearch(_ term: String) {
    let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
    searchHistory.append("[\(timestamp)] 搜索: \(term)")
    
    // 限制历史记录数量
    if searchHistory.count > 5 {
      searchHistory.removeFirst()
    }
  }
}

// Throttle 节流示例
struct CombineOperatorsThrottleExample: View {
  @State private var scrollEvents: [String] = []
  @State private var throttledEvents: [String] = []
  @State private var cancellable: AnyCancellable?
  
  private let scrollSubject = PassthroughSubject<CGFloat, Never>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Throttle 节流演示")
        .font(.headline)
      
      Text("模拟滚动事件节流")
        .foregroundColor(.secondary)
      
      Button("模拟快速滚动") {
        // 模拟快速滚动事件
        for i in 1...10 {
          let position = CGFloat(i * 10)
          scrollEvents.append("滚动到: \(position)")
          scrollSubject.send(position)
        }
      }
      
      Button("清空") {
        scrollEvents.removeAll()
        throttledEvents.removeAll()
      }
      
      HStack {
        VStack(alignment: .leading) {
          Text("所有滚动事件:")
            .font(.subheadline)
            .bold()
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(scrollEvents.indices, id: \.self) { index in
                Text(scrollEvents[index])
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 100)
        }
        
        VStack(alignment: .leading) {
          Text("节流后事件:")
            .font(.subheadline)
            .bold()
          
          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(throttledEvents.indices, id: \.self) { index in
                Text(throttledEvents[index])
                  .font(.caption)
                  .foregroundColor(.blue)
              }
            }
          }
          .frame(maxHeight: 100)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
    .onAppear {
      cancellable = scrollSubject
        .throttle(for: .milliseconds(200), scheduler: DispatchQueue.main, latest: true)
        .sink { position in
          throttledEvents.append("节流滚动: \(position)")
        }
    }
    .onDisappear {
      cancellable?.cancel()
    }
  }
}

// Delay 延迟示例
struct CombineOperatorsDelayExample: View {
  @State private var events: [String] = []
  @State private var isRunning = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Delay 延迟演示")
        .font(.headline)
      
      Text("延迟2秒后输出值")
        .foregroundColor(.secondary)
      
      Button("发送延迟消息") {
        isRunning = true
        events.append("[\(currentTime())] 发送消息")
        
        cancellable = Just("延迟的消息")
          .delay(for: .seconds(2), scheduler: DispatchQueue.main)
          .sink { message in
            events.append("[\(currentTime())] 收到: \(message)")
            isRunning = false
          }
      }
      .disabled(isRunning)
      
      if isRunning {
        ProgressView("等待延迟消息...")
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(events.indices, id: \.self) { index in
            Text(events[index])
              .font(.caption)
          }
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func currentTime() -> String {
    DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
  }
}

// Timeout 超时示例
struct CombineOperatorsTimeoutExample: View {
  @State private var results: [String] = []
  @State private var isRunning = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Timeout 超时演示")
        .font(.headline)
      
      Text("3秒内没有收到值就超时")
        .foregroundColor(.secondary)
      
      HStack {
        Button("快速响应 (1秒)") {
          testTimeout(delay: 1.0)
        }
        .disabled(isRunning)
        
        Button("慢响应 (5秒)") {
          testTimeout(delay: 5.0)
        }
        .disabled(isRunning)
        
        Button("清空") {
          results.removeAll()
        }
      }
      
      if isRunning {
        ProgressView("等待响应...")
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(results.indices, id: \.self) { index in
            Text(results[index])
              .font(.caption)
              .foregroundColor(results[index].contains("超时") ? .red : .green)
          }
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func testTimeout(delay: TimeInterval) {
    isRunning = true
    results.append("[\(currentTime())] 开始请求 (延迟\(delay)秒)")
    
    cancellable = Future<String, CombineOperatorsError> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        promise(.success("响应数据"))
      }
    }
    .timeout(.seconds(3), scheduler: DispatchQueue.main, customError: { CombineOperatorsError.timeout })
    .sink(
      receiveCompletion: { completion in
        isRunning = false
        switch completion {
        case .finished:
          break
        case .failure(let error):
          results.append("[\(currentTime())] 错误: \(error.localizedDescription)")
        }
      },
      receiveValue: { value in
        results.append("[\(currentTime())] 成功: \(value)")
      }
    )
  }
  
  private func currentTime() -> String {
    DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
  }
}

// MARK: - 聚合操作符示例

// Reduce 归约示例
struct CombineOperatorsReduceExample: View {
  @State private var numbers: [Int] = []
  @State private var operations: [String] = []
  @State private var finalResult: Int?
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Reduce 归约演示")
        .font(.headline)
      
      Text("计算数组的累积和")
        .foregroundColor(.secondary)
      
      Button("计算1到5的累积和") {
        numbers.removeAll()
        operations.removeAll()
        finalResult = nil
        
        let sourceNumbers = Array(1...5)
        numbers = sourceNumbers
        
        cancellable = sourceNumbers.publisher
          .reduce(0) { accumulator, value in
            let result = accumulator + value
            operations.append("\(accumulator) + \(value) = \(result)")
            return result
          }
          .sink { result in
            finalResult = result
          }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("输入数字: \(numbers.map(String.init).joined(separator: ", "))")
          .font(.caption)
        
        Text("计算过程:")
          .font(.subheadline)
          .bold()
        
        ForEach(operations.indices, id: \.self) { index in
          Text(operations[index])
            .font(.caption)
            .foregroundColor(.blue)
        }
        
        if let result = finalResult {
          Text("最终结果: \(result)")
            .font(.subheadline)
            .bold()
            .foregroundColor(.green)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// Collect 收集示例
struct CombineOperatorsCollectExample: View {
  @State private var allValues: [String] = []
  @State private var batches: [[String]] = []
  @State private var batchSize = 3
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Collect 收集演示")
        .font(.headline)
      
      Text("将流中的值收集成批次")
        .foregroundColor(.secondary)
      
      VStack(alignment: .leading) {
        HStack {
          Text("批次大小:")
          Stepper("\(batchSize)", value: $batchSize, in: 2...5)
            .frame(width: 100)
        }
        
        Button("收集字母数据") {
          allValues.removeAll()
          batches.removeAll()
          
          let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
          allValues = letters
          
          cancellable = letters.publisher
            .collect(batchSize)
            .collect()  // 收集所有批次
            .sink { collectedBatches in
              batches = collectedBatches
            }
        }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("所有数据: \(allValues.joined(separator: ", "))")
          .font(.caption)
        
        Text("收集结果 (每\(batchSize)个一批):")
          .font(.subheadline)
          .bold()
        
        ForEach(batches.indices, id: \.self) { index in
          Text("批次\(index + 1): [\(batches[index].joined(separator: ", "))]")
            .font(.caption)
            .foregroundColor(.blue)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// Count 计数示例
struct CombineOperatorsCountExample: View {
  @State private var items: [String] = []
  @State private var itemCount: Int?
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Count 计数演示")
        .font(.headline)
      
      Text("统计流中元素的数量")
        .foregroundColor(.secondary)
      
      Button("生成随机项目并计数") {
        items.removeAll()
        itemCount = nil
        
        let randomItems = (1...Int.random(in: 3...8)).map { "项目\($0)" }
        items = randomItems
        
        cancellable = randomItems.publisher
          .count()
          .sink { count in
            itemCount = count
          }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("生成的项目:")
          .font(.subheadline)
          .bold()
        
        Text(items.joined(separator: ", "))
          .font(.caption)
        
        if let count = itemCount {
          Text("元素数量: \(count)")
            .font(.subheadline)
            .bold()
            .foregroundColor(.blue)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// Min/Max 最值示例
struct CombineOperatorsMinMaxExample: View {
  @State private var numbers: [Int] = []
  @State private var minValue: Int?
  @State private var maxValue: Int?
  @State private var cancellables = Set<AnyCancellable>()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Min/Max 最值演示")
        .font(.headline)
      
      Text("找出数字流中的最小值和最大值")
        .foregroundColor(.secondary)
      
      Button("生成随机数字") {
        numbers.removeAll()
        minValue = nil
        maxValue = nil
        
        let randomNumbers = (1...7).map { _ in Int.random(in: 1...100) }
        numbers = randomNumbers
        
        randomNumbers.publisher
          .min()
          .sink { min in
            minValue = min
          }
          .store(in: &cancellables)
        
        randomNumbers.publisher
          .max()
          .sink { max in
            maxValue = max
          }
          .store(in: &cancellables)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("随机数字: \(numbers.map(String.init).joined(separator: ", "))")
          .font(.caption)
        
        if let min = minValue {
          Text("最小值: \(min)")
            .font(.subheadline)
            .bold()
            .foregroundColor(.red)
        }
        
        if let max = maxValue {
          Text("最大值: \(max)")
            .font(.subheadline)
            .bold()
            .foregroundColor(.green)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// MARK: - 高级应用示例

// 操作符链组合示例
struct CombineOperatorsChainExample: View {
  @State private var rawData: [String] = []
  @State private var processedData: [String] = []
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("操作符链组合演示")
        .font(.headline)
      
      Text("复杂的数据处理管道")
        .foregroundColor(.secondary)
      
      Button("处理复杂数据") {
        rawData.removeAll()
        processedData.removeAll()
        
        let data = ["1", "2", "invalid", "3", "4", "", "5", "6", "7", "8", "9", "10"]
        rawData = data
        
        cancellable = data.publisher
          .filter { !$0.isEmpty }                    // 1. 过滤空字符串
          .compactMap { Int($0) }                   // 2. 转换为数字，忽略无效值
          .filter { $0 > 0 }                        // 3. 过滤正数
          .map { $0 * $0 }                          // 4. 计算平方
          .filter { $0 % 2 == 0 }                   // 5. 只保留偶数平方
          .scan(0, +)                               // 6. 累积求和
          .map { "累积和: \($0)" }                   // 7. 格式化输出
          .collect()
          .sink { results in
            processedData = results
          }
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("原始数据:")
          .font(.subheadline)
          .bold()
        Text(rawData.joined(separator: ", "))
          .font(.caption)
        
        Text("处理结果:")
          .font(.subheadline)
          .bold()
        
        ForEach(processedData.indices, id: \.self) { index in
          Text(processedData[index])
            .font(.caption)
            .foregroundColor(.blue)
        }
        
        Text("处理步骤: 过滤空字符串 → 转换数字 → 过滤正数 → 计算平方 → 保留偶数 → 累积求和 → 格式化")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

// 实时搜索示例
struct CombineOperatorsSearchExample: View {
  @StateObject private var viewModel = CombineOperatorsSearchViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("实时搜索演示")
        .font(.headline)
      
      Text("组合防抖、去重、过滤等操作符")
        .foregroundColor(.secondary)
      
      TextField("搜索产品...", text: $viewModel.searchText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      if viewModel.isLoading {
        ProgressView("搜索中...")
          .frame(maxWidth: .infinity)
      }
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(viewModel.searchResults.indices, id: \.self) { index in
            Text(viewModel.searchResults[index])
              .font(.caption)
              .padding(.vertical, 2)
          }
        }
      }
      .frame(maxHeight: 100)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

class CombineOperatorsSearchViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var searchResults: [String] = []
  @Published var isLoading = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    $searchText
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.count > 1 }  // 至少2个字符才搜索
      .flatMap { [weak self] searchTerm -> AnyPublisher<[String], Never> in
        guard let self = self else { return Just([]).eraseToAnyPublisher() }
        return self.performSearch(searchTerm)
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] results in
        self?.searchResults = results
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  private func performSearch(_ term: String) -> AnyPublisher<[String], Never> {
    isLoading = true
    
    return Future<[String], Never> { promise in
      // 模拟网络搜索
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        let allProducts = [
          "iPhone 手机", "iPad 平板", "MacBook 电脑",
          "Apple Watch 手表", "AirPods 耳机", "HomePod 音响",
          "Mac Studio 台式机", "Studio Display 显示器"
        ]
        
        let filteredResults = allProducts.filter { product in
          product.lowercased().contains(term.lowercased())
        }
        
        promise(.success(filteredResults.isEmpty ? ["未找到相关产品"] : filteredResults))
      }
    }
    .eraseToAnyPublisher()
  }
}

// 数据验证管道示例
struct CombineOperatorsValidationExample: View {
  @StateObject private var viewModel = CombineOperatorsValidationViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("数据验证管道演示")
        .font(.headline)
      
      Text("使用操作符构建验证链")
        .foregroundColor(.secondary)
      
      VStack(alignment: .leading) {
        TextField("输入邮箱", text: $viewModel.email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        TextField("输入密码", text: $viewModel.password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .textContentType(.password)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("验证结果:")
          .font(.subheadline)
          .bold()
        
        ForEach(viewModel.validationMessages.indices, id: \.self) { index in
          Text(viewModel.validationMessages[index])
            .font(.caption)
            .foregroundColor(viewModel.validationMessages[index].contains("✅") ? .green : .red)
        }
        
        if viewModel.isValid {
          Text("🎉 所有验证通过!")
            .font(.caption)
            .bold()
            .foregroundColor(.green)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
}

class CombineOperatorsValidationViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var validationMessages: [String] = []
  @Published var isValid = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    Publishers.CombineLatest($email, $password)
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .map { [weak self] email, password in
        self?.validateInput(email: email, password: password) ?? []
      }
      .sink { [weak self] messages in
        self?.validationMessages = messages
        self?.isValid = messages.allSatisfy { $0.contains("✅") }
      }
      .store(in: &cancellables)
  }
  
  private func validateInput(email: String, password: String) -> [String] {
    var messages: [String] = []
    
    // 邮箱验证
    if email.isEmpty {
      messages.append("❌ 邮箱不能为空")
    } else if email.contains("@") && email.contains(".") {
      messages.append("✅ 邮箱格式正确")
    } else {
      messages.append("❌ 邮箱格式错误")
    }
    
    // 密码验证
    if password.isEmpty {
      messages.append("❌ 密码不能为空")
    } else if password.count >= 6 {
      messages.append("✅ 密码长度符合要求")
    } else {
      messages.append("❌ 密码至少需要6位")
    }
    
    return messages
  }
}

// 多源数据聚合示例
struct CombineOperatorsAggregationExample: View {
  @State private var weatherData: String = "未加载"
  @State private var locationData: String = "未加载"
  @State private var userPreferences: String = "未加载"
  @State private var aggregatedResult: String = "等待数据聚合..."
  @State private var isLoading = false
  @State private var cancellable: AnyCancellable?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("多源数据聚合演示")
        .font(.headline)
      
      Text("使用 CombineLatest 聚合多个异步数据源")
        .foregroundColor(.secondary)
      
      Button("加载所有数据") {
        isLoading = true
        weatherData = "加载中..."
        locationData = "加载中..."
        userPreferences = "加载中..."
        aggregatedResult = "等待数据聚合..."
        
        let weatherPublisher = fetchWeatherData()
        let locationPublisher = fetchLocationData()
        let preferencesPublisher = fetchUserPreferences()
        
        cancellable = Publishers.CombineLatest3(weatherPublisher, locationPublisher, preferencesPublisher)
          .sink { weather, location, preferences in
            weatherData = weather
            locationData = location
            userPreferences = preferences
            aggregatedResult = "聚合完成: \(weather) + \(location) + \(preferences)"
            isLoading = false
          }
      }
      .disabled(isLoading)
      
      if isLoading {
        ProgressView("聚合数据中...")
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text("天气数据: \(weatherData)")
          .font(.caption)
        
        Text("位置数据: \(locationData)")
          .font(.caption)
        
        Text("用户偏好: \(userPreferences)")
          .font(.caption)
        
        Text("聚合结果:")
          .font(.subheadline)
          .bold()
        
        Text(aggregatedResult)
          .font(.caption)
          .foregroundColor(.blue)
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }
  
  private func fetchWeatherData() -> AnyPublisher<String, Never> {
    Future<String, Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        promise(.success("晴天 25°C"))
      }
    }
    .eraseToAnyPublisher()
  }
  
  private func fetchLocationData() -> AnyPublisher<String, Never> {
    Future<String, Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        promise(.success("北京市"))
      }
    }
    .eraseToAnyPublisher()
  }
  
  private func fetchUserPreferences() -> AnyPublisher<String, Never> {
    Future<String, Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        promise(.success("摄氏度"))
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - 数据模型和错误类型

struct CombineOperatorsUser: Identifiable {
  let id: Int
  let name: String
  let email: String
}

enum CombineOperatorsError: LocalizedError {
  case invalidNumber(String)
  case networkError
  case timeout
  
  var errorDescription: String? {
    switch self {
    case .invalidNumber(let value):
      return "无效数字: \(value)"
    case .networkError:
      return "网络连接错误"
    case .timeout:
      return "请求超时"
    }
  }
}

enum CombineOperatorsNetworkError: Error {
  case timeout
  case serverError
  case unauthorized
}

enum CombineOperatorsUIError: LocalizedError {
  case userFriendlyError(String)
  
  var errorDescription: String? {
    switch self {
    case .userFriendlyError(let message):
      return message
    }
  }
}

// MARK: - 预览

#Preview {
  NavigationView {
    CombineOperatorsDemoView()
  }
}
