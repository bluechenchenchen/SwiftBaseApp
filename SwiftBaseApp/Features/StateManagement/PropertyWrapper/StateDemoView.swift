import SwiftUI

struct StateDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础用法
      ShowcaseSection("基础用法") {
        ShowcaseItem(title: "计数器示例") {
          StateDemoCounterExample()
        }
        
        ShowcaseItem(title: "文本输入示例") {
          StateDemoTextInputExample()
        }
        
        ShowcaseItem(title: "开关示例") {
          StateDemoToggleExample()
        }
      }
      
      // MARK: - 进阶用法
      ShowcaseSection("进阶用法") {
        ShowcaseItem(title: "待办事项应用") {
          StateDemoTodoAppExample()
        }
        
        ShowcaseItem(title: "表单状态管理") {
          StateDemoFormStateExample()
        }
      }
      
      // MARK: - 动画效果
      ShowcaseSection("动画效果") {
        ShowcaseItem(title: "展开/收起动画") {
          StateDemoExpandCollapseAnimation()
        }
        
        ShowcaseItem(title: "旋转动画") {
          StateDemoRotationAnimation()
        }
        
        ShowcaseItem(title: "缩放动画") {
          StateDemoScaleAnimation()
        }
        
        ShowcaseItem(title: "透明度动画") {
          StateDemoOpacityAnimation()
        }
        
        ShowcaseItem(title: "位移动画") {
          StateDemoOffsetAnimation()
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "数据加载优化") {
          StateDemoDataLoadingExample()
        }
        
        ShowcaseItem(title: "计算属性优化") {
          StateDemoComputedPropertyExample()
        }
      }
    }
    .navigationTitle("@State 状态管理")
  }
}

// MARK: - 基础用法示例
struct StateDemoCounterExample: View {
  @State private var counter = 0
  @State private var isVisible = true
  
  var body: some View {
    VStack(spacing: 15) {
      if isVisible {
        Text("计数: \(counter)")
          .font(.title)
          .foregroundColor(.primary)
      }
      
      HStack(spacing: 15) {
        Button("增加") {
          counter += 1
        }
        .buttonStyle(.borderedProminent)
        
        Button("减少") {
          counter -= 1
        }
        .buttonStyle(.bordered)
        
        Button("重置") {
          counter = 0
        }
        .buttonStyle(.bordered)
        .foregroundColor(.red)
        
        Button(isVisible ? "隐藏" : "显示") {
          withAnimation(.easeInOut) {
            isVisible.toggle()
          }
        }
        .buttonStyle(.bordered)
      }
      
      
    }
    //        .frame(minWidth: .infinity)
    //        .padding()
    //        .background(Color.gray.opacity(0.1))
    //        .cornerRadius(10)
  }
}

struct StateDemoTextInputExample: View {
  @State private var name = ""
  
  var body: some View {
    VStack(spacing: 15) {
      TextField("请输入姓名", text: $name)
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
      
      Text("你好，\(name.isEmpty ? "世界" : name)！")
        .font(.title2)
        .foregroundColor(.blue)
    }
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(10)
  }
}

struct StateDemoToggleExample: View {
  @State private var isOn = false
  
  var body: some View {
    VStack(spacing: 15) {
      Toggle("状态开关", isOn: $isOn)
        .padding(.horizontal)
      
      Text("当前状态: \(isOn ? "开启" : "关闭")")
        .foregroundColor(isOn ? .green : .red)
    }
    .padding()
    .background(Color.green.opacity(0.1))
    .cornerRadius(10)
  }
}

// MARK: - 进阶用法示例
struct StateDemoTodoAppExample: View {
  @State private var todos: [StateDemoTodoItem] = []
  @State private var newTodoText = ""
  @State private var filterOption = FilterOption.all
  @State private var showingAddSheet = false
  
  private var filteredTodos: [StateDemoTodoItem] {
    switch filterOption {
    case .all:
      return todos
    case .completed:
      return todos.filter { $0.isCompleted }
    case .pending:
      return todos.filter { !$0.isCompleted }
    }
  }
  
  var body: some View {
    VStack {
      // 过滤器
      Picker("过滤", selection: $filterOption) {
        Text("全部").tag(FilterOption.all)
        Text("已完成").tag(FilterOption.completed)
        Text("待完成").tag(FilterOption.pending)
      }
      .pickerStyle(.segmented)
      .padding()
      
      // 待办事项列表
      List {
        ForEach(filteredTodos) { todo in
          StateDemoTodoRowView(todo: todo) { updatedTodo in
            if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
              todos[index] = updatedTodo
            }
          }
        }
        .onDelete(perform: deleteTodos)
      }
      .frame(height: 200)
      
      // 统计信息
      HStack {
        Text("总计: \(todos.count)")
        Spacer()
        Text("已完成: \(todos.filter { $0.isCompleted }.count)")
        Spacer()
        Text("待完成: \(todos.filter { !$0.isCompleted }.count)")
      }
      .font(.caption)
      .foregroundColor(.secondary)
      .padding()
      
      Button("添加待办") {
        showingAddSheet = true
      }
      .buttonStyle(.borderedProminent)
    }
    .sheet(isPresented: $showingAddSheet) {
      StateDemoAddTodoView { newTodo in
        todos.append(newTodo)
        showingAddSheet = false
      }
    }
  }
  
  private func deleteTodos(offsets: IndexSet) {
    let todosToDelete = offsets.map { filteredTodos[$0] }
    todos.removeAll { todo in
      todosToDelete.contains { $0.id == todo.id }
    }
  }
}

// MARK: - 动画效果示例
struct StateDemoExpandCollapseAnimation: View {
  @State private var isExpanded = false
  
  var body: some View {
    VStack(spacing: 15) {
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.blue)
        .frame(width: isExpanded ? 200 : 100, height: 100)
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
        .onTapGesture {
          isExpanded.toggle()
        }
      
      Text(isExpanded ? "已展开" : "点击展开")
        .foregroundColor(.blue)
    }
    .padding()
    .background(Color.blue.opacity(0.1))
    .cornerRadius(10)
  }
}

struct StateDemoRotationAnimation: View {
  @State private var rotation: Double = 0
  
  var body: some View {
    VStack(spacing: 15) {
      Image(systemName: "arrow.clockwise")
        .font(.system(size: 50))
        .foregroundColor(.green)
        .rotationEffect(.degrees(rotation))
        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
        .onTapGesture {
          rotation += 360
        }
      
      Text("点击开始旋转")
        .foregroundColor(.green)
    }
    .padding()
    .background(Color.green.opacity(0.1))
    .cornerRadius(10)
  }
}

struct StateDemoScaleAnimation: View {
  @State private var scale: CGFloat = 1.0
  
  var body: some View {
    VStack(spacing: 15) {
      Circle()
        .fill(Color.orange)
        .frame(width: 80, height: 80)
        .scaleEffect(scale)
        .animation(.easeInOut(duration: 0.3), value: scale)
        .onTapGesture {
          scale = scale == 1.0 ? 1.5 : 1.0
        }
      
      Text("点击缩放")
        .foregroundColor(.orange)
    }
    .padding()
    .background(Color.orange.opacity(0.1))
    .cornerRadius(10)
  }
}

struct StateDemoOpacityAnimation: View {
  @State private var opacity: Double = 1.0
  
  var body: some View {
    VStack(spacing: 15) {
      Rectangle()
        .fill(Color.purple)
        .frame(width: 120, height: 80)
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.5), value: opacity)
        .onTapGesture {
          opacity = opacity == 1.0 ? 0.3 : 1.0
        }
      
      Text("点击切换透明度")
        .foregroundColor(.purple)
    }
    .padding()
    .background(Color.purple.opacity(0.1))
    .cornerRadius(10)
  }
}

struct StateDemoOffsetAnimation: View {
  @State private var offset: CGFloat = 0
  
  var body: some View {
    VStack(spacing: 15) {
      Capsule()
        .fill(Color.red)
        .frame(width: 100, height: 40)
        .offset(x: offset)
        .animation(.easeInOut(duration: 0.8), value: offset)
        .onTapGesture {
          offset = offset == 0 ? 100 : 0
        }
      
      Text("点击移动")
        .foregroundColor(.red)
    }
    .padding()
    .background(Color.red.opacity(0.1))
    .cornerRadius(10)
  }
}

// MARK: - 性能优化示例
struct StateDemoDataLoadingExample: View {
  @State private var isLoading = false
  @State private var data: [String] = []
  @State private var searchText = ""
  
  private var filteredData: [String] {
    if searchText.isEmpty {
      return data
    } else {
      return data.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
  }
  
  var body: some View {
    VStack {
      TextField("搜索...", text: $searchText)
        .textFieldStyle(.roundedBorder)
        .padding()
      
      if isLoading {
        ProgressView("加载中...")
          .frame(height: 100)
      } else if filteredData.isEmpty {
        VStack {
          Image(systemName: "magnifyingglass")
            .font(.system(size: 30))
            .foregroundColor(.secondary)
          Text(searchText.isEmpty ? "暂无数据" : "未找到匹配项")
            .foregroundColor(.secondary)
        }
        .frame(height: 100)
      } else {
        List {
          ForEach(filteredData, id: \.self) { item in
            Text(item)
              .padding(.vertical, 4)
          }
        }
        .frame(height: 150)
      }
      
      HStack {
        Button("加载数据") {
          loadData()
        }
        .disabled(isLoading)
        
        Button("清空") {
          withAnimation {
            data.removeAll()
          }
        }
        .disabled(isLoading || data.isEmpty)
      }
      .padding()
    }
  }
  
  private func loadData() {
    isLoading = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      data = ["项目1", "项目2", "项目3", "项目4", "项目5"]
      isLoading = false
    }
  }
}

struct StateDemoComputedPropertyExample: View {
  @State private var items: [String] = []
  @State private var filterText = ""
  
  // 使用计算属性而不是状态
  private var isEmpty: Bool {
    items.isEmpty
  }
  
  private var itemCount: Int {
    items.count
  }
  
  private var filteredItems: [String] {
    if filterText.isEmpty {
      return items
    } else {
      return items.filter { $0.localizedCaseInsensitiveContains(filterText) }
    }
  }
  
  var body: some View {
    VStack(spacing: 15) {
      TextField("过滤...", text: $filterText)
        .textFieldStyle(.roundedBorder)
      
      Text("总项目数: \(itemCount)")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text("过滤后项目数: \(filteredItems.count)")
        .font(.caption)
        .foregroundColor(.secondary)
      
      if isEmpty {
        Text("暂无数据")
          .foregroundColor(.secondary)
      } else {
        List {
          ForEach(filteredItems, id: \.self) { item in
            Text(item)
          }
        }
        .frame(height: 100)
      }
      
      Button("添加项目") {
        withAnimation(.easeInOut) {
          items.append("项目 \(items.count + 1)")
        }
      }
      .buttonStyle(.bordered)
    }
    .padding()
    .background(Color.yellow.opacity(0.1))
    .cornerRadius(10)
  }
}

// MARK: - 辅助类型
struct StateDemoTodoItem: Identifiable, Equatable {
  let id = UUID()
  var title: String
  var isCompleted: Bool = false
  var priority: Priority = .normal
  var createdAt = Date()
  
  enum Priority: String, CaseIterable {
    case low = "低"
    case normal = "中"
    case high = "高"
  }
}

enum FilterOption: Equatable {
  case all, completed, pending
}

struct StateDemoTodoRowView: View {
  let todo: StateDemoTodoItem
  let onUpdate: (StateDemoTodoItem) -> Void
  
  var body: some View {
    HStack {
      Button(action: {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        onUpdate(updatedTodo)
      }) {
        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
          .foregroundColor(todo.isCompleted ? .green : .gray)
      }
      .buttonStyle(.plain)
      
      VStack(alignment: .leading) {
        Text(todo.title)
          .strikethrough(todo.isCompleted)
          .foregroundColor(todo.isCompleted ? .secondary : .primary)
        
        Text("优先级: \(todo.priority.rawValue)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Text(todo.createdAt, style: .date)
        .font(.caption2)
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 4)
  }
}

struct StateDemoAddTodoView: View {
  @State private var title = ""
  @State private var priority = StateDemoTodoItem.Priority.normal
  @Environment(\.dismiss) private var dismiss
  let onAdd: (StateDemoTodoItem) -> Void
  
  var body: some View {
    NavigationStack {
      Form {
        Section("待办事项") {
          TextField("标题", text: $title)
          
          Picker("优先级", selection: $priority) {
            ForEach(StateDemoTodoItem.Priority.allCases, id: \.self) { priority in
              Text(priority.rawValue).tag(priority)
            }
          }
        }
      }
      .navigationTitle("添加待办")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("取消") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("添加") {
            let newTodo = StateDemoTodoItem(title: title, priority: priority)
            onAdd(newTodo)
          }
          .disabled(title.isEmpty)
        }
      }
    }
  }
}

struct StateDemoFormStateExample: View {
  @State private var formData = StateDemoFormData()
  @State private var validationErrors: [String] = []
  @State private var isSubmitting = false
  @State private var showingSuccess = false
  
  var body: some View {
    VStack(spacing: 15) {
      Form {
        Section("个人信息") {
          TextField("姓名", text: $formData.name)
            .textFieldStyle(.roundedBorder)
          
          TextField("邮箱", text: $formData.email)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
          
          TextField("年龄", value: $formData.age, format: .number)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
        }
        
        if !validationErrors.isEmpty {
          Section("验证错误") {
            ForEach(validationErrors, id: \.self) { error in
              Text(error)
                .foregroundColor(.red)
            }
          }
        }
        
        Section {
       
          Button(isSubmitting ? "提交中..." : "提交") {
            submitForm()
          }.buttonStyle(.borderedProminent)
          .disabled(isSubmitting || !isFormValid)
         
        }
      }
      .frame(height: 300)
    }
    .onChange(of: formData) { oldValue, newValue in
      validateForm()
    }
    .alert("提交成功", isPresented: $showingSuccess) {
      Button("确定") {
        resetForm()
      }
    } message: {
      Text("表单数据已成功提交")
    }
  }
  
  private var isFormValid: Bool {
    !formData.name.isEmpty &&
    !formData.email.isEmpty &&
    formData.age > 0 &&
    validationErrors.isEmpty
  }
  
  private func validateForm() {
    validationErrors.removeAll()
    
    if formData.name.isEmpty {
      validationErrors.append("姓名不能为空")
    }
    
    if formData.email.isEmpty {
      validationErrors.append("邮箱不能为空")
    } else if !formData.email.contains("@") {
      validationErrors.append("邮箱格式不正确")
    }
    
    if formData.age <= 0 {
      validationErrors.append("年龄必须大于0")
    }
  }
  
  private func submitForm() {
    isSubmitting = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      isSubmitting = false
      showingSuccess = true
    }
  }
  
  private func resetForm() {
    formData = StateDemoFormData()
    validationErrors.removeAll()
    isSubmitting = false
    showingSuccess = false
  }
}

struct StateDemoFormData: Equatable {
  var name = ""
  var email = ""
  var age = 0
  var phone = ""
  var address = ""
  var city = ""
  var zipCode = ""
}

// MARK: - Preview
#Preview {
  NavigationStack {
    StateDemoView()
  }
}
