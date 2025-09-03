# SwiftUI List 控件完整指南

## 1. 基本介绍

### 1.1 控件概述

List 是 SwiftUI 中用于显示数据列表的核心控件。它提供了一个高效且灵活的方式来展示可滚动的数据集合，支持静态内容、动态数据、分组、选择、编辑等多种功能。

### 1.2 使用场景

- 显示数据列表（联系人、消息、设置等）
- 可选择的选项列表
- 分组数据展示
- 可编辑的数据列表
- 可展开/折叠的层级列表
- 自定义列表项的交互界面

### 1.3 主要特性

- 支持静态和动态内容
- 内置分组功能
- 支持单选和多选
- 支持滑动操作（删除、标记等）
- 支持拖拽排序
- 支持搜索和过滤
- 支持下拉刷新
- 支持自定义样式和布局
- 支持列表项动画

## 2. 基础用法

### 2.1 基本示例

```swift
// 静态列表
List {
    Text("第一项")
    Text("第二项")
    Text("第三项")
}

// 动态列表
struct Item: Identifiable {
    let id = UUID()
    let title: String
}

List(items) { item in
    Text(item.title)
}

// 分组列表
List {
    Section("第一组") {
        Text("项目 1.1")
        Text("项目 1.2")
    }

    Section("第二组") {
        Text("项目 2.1")
        Text("项目 2.2")
    }
}
```

### 2.2 常用属性

```swift
// 设置选择模式
List(items, selection: $selection) { item in
    Text(item.title)
}
.environment(\.editMode, .constant(.active))

// 设置列表样式
List {
    // 内容
}
.listStyle(.plain)  // 普通样式
.listStyle(.grouped)  // 分组样式
.listStyle(.inset)  // 嵌入样式
.listStyle(.insetGrouped)  // 嵌入分组样式
.listStyle(.sidebar)  // 侧边栏样式

// 设置分隔线样式
List {
    // 内容
}
.listRowSeparator(.hidden)  // 隐藏分隔线
.listRowSeparatorTint(.red)  // 设置分隔线颜色

// 设置行间距
List {
    // 内容
}
.listRowSpacing(8)  // 设置行间距

// 设置背景色
List {
    // 内容
}
.listRowBackground(Color.gray.opacity(0.1))  // 设置行背景色
```

## 3. 样式和自定义

### 3.1 内置样式

```swift
// 普通样式
List {
    // 内容
}
.listStyle(.plain)

// 分组样式
List {
    // 内容
}
.listStyle(.grouped)

// 嵌入分组样式
List {
    // 内容
}
.listStyle(.insetGrouped)

// 侧边栏样式
List {
    // 内容
}
.listStyle(.sidebar)
```

### 3.2 自定义修饰符

```swift
// 自定义行外观
List {
    Text("自定义行")
        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        .listRowBackground(Color.blue.opacity(0.1))
}

// 自定义分组外观
List {
    Section {
        Text("分组内容")
    } header: {
        Text("自定义头部")
            .font(.headline)
            .foregroundColor(.blue)
    } footer: {
        Text("自定义尾部")
            .font(.caption)
            .foregroundColor(.gray)
    }
}

// 自定义分隔线
List {
    Text("项目 1")
        .listRowSeparator(.hidden)  // 隐藏特定行的分隔线
    Text("项目 2")
        .listRowSeparatorTint(.red)  // 设置特定行的分隔线颜色
}
```

### 3.3 主题适配

```swift
// 适配深色模式
List {
    Text("适配深色模式")
        .listRowBackground(Color("BackgroundColor"))  // 使用 Asset 中定义的颜色
}

// 适配动态字体大小
List {
    Text("适配动态字体")
        .font(.body)  // 使用系统动态字体
}
```

## 4. 高级特性

### 4.1 滑动操作

```swift
List {
    ForEach(items) { item in
        Text(item.title)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    // 删除操作
                } label: {
                    Label("删除", systemImage: "trash")
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    // 标记操作
                } label: {
                    Label("标记", systemImage: "star")
                }
                .tint(.yellow)
            }
    }
}
```

### 4.2 拖拽排序

```swift
List {
    ForEach(items) { item in
        Text(item.title)
    }
    .onMove { source, destination in
        // 处理移动逻辑
        items.move(fromOffsets: source, toOffset: destination)
    }
}
.environment(\.editMode, .constant(.active))  // 启用编辑模式
```

### 4.3 下拉刷新

```swift
List {
    ForEach(items) { item in
        Text(item.title)
    }
}
.refreshable {
    // 处理刷新逻辑
    await loadData()
}
```

### 4.4 搜索功能

```swift
struct ContentView: View {
    @State private var searchText = ""
    @State private var items: [Item] = []

    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List(filteredItems) { item in
            Text(item.title)
        }
        .searchable(text: $searchText)
    }
}
```

## 5. 性能优化

### 5.1 最佳实践

1. 使用正确的标识符

```swift
// 使用稳定的标识符
struct Item: Identifiable {
    let id: UUID  // 使用稳定的唯一标识符
    let title: String
}

// 避免使用不稳定的标识符
List(items, id: \.self)  // 不推荐，除非确保内容唯一
```

2. 避免重复计算

```swift
// 推荐：将计算移到模型层
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []

    var filteredItems: [Item] {
        // 复杂的过滤逻辑
    }
}

// 不推荐：在视图中进行复杂计算
List {
    ForEach(items) { item in
        // 在这里进行复杂计算
    }
}
```

3. 使用适当的更新策略

```swift
// 使用 id 参数指定何时需要更新
List {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}
.id(updateCounter)  // 只在需要时更新整个列表
```

### 5.2 常见陷阱

1. 避免在列表项中使用大量的状态

```swift
// 不推荐
struct ItemRow: View {
    @State private var isExpanded = false  // 每个项目都有自己的状态
    // ...
}

// 推荐：将状态提升到父视图
struct ItemRow: View {
    @Binding var isExpanded: Bool  // 状态由父视图管理
    // ...
}
```

2. 避免不必要的视图更新

```swift
// 不推荐：整个列表项都会更新
List(items) { item in
    ComplexItemView(item: item, onUpdate: { /* 更新逻辑 */ })
}

// 推荐：将更新限制在需要的范围内
List(items) { item in
    ItemRow(item: item)
        .onChange(of: item.someProperty) { newValue in
            // 只更新需要更新的部分
        }
}
```

### 5.3 优化技巧

1. 使用 `LazyVStack` 替代 List（适用于特定场景）

```swift
ScrollView {
    LazyVStack(spacing: 8) {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}
```

2. 实现视图回收

```swift
List {
    ForEach(items) { item in
        ItemRow(item: item)
            .id(item.id)  // 确保视图正确回收
    }
}
```

## 6. 辅助功能

### 6.1 无障碍支持

```swift
List {
    ForEach(items) { item in
        Text(item.title)
            .accessibilityLabel("项目：\(item.title)")
            .accessibilityHint("双击以查看详情")
            .accessibilityAddTraits(.isButton)
    }
}
```

### 6.2 本地化

```swift
List {
    ForEach(items) { item in
        Text(NSLocalizedString("item.title", comment: "列表项标题"))
    }
}
```

### 6.3 动态类型

```swift
List {
    ForEach(items) { item in
        Text(item.title)
            .font(.body)  // 使用系统动态字体
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
}
```

## 7. 示例代码

### 7.1 基础示例

```swift
struct BasicListDemo: View {
    var body: some View {
        List {
            Text("基本文本项")
            Label("带图标的项", systemImage: "star")
            HStack {
                Image(systemName: "person")
                VStack(alignment: .leading) {
                    Text("自定义布局项")
                    Text("副标题")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
```

### 7.2 进阶示例

```swift
struct AdvancedListDemo: View {
    @State private var items = ["项目1", "项目2", "项目3"]
    @State private var selection: Set<String> = []
    @State private var isEditing = false

    var body: some View {
        List(selection: $selection) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = items.firstIndex(of: item) {
                                items.remove(at: index)
                            }
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
            }
            .onMove { source, destination in
                items.move(fromOffsets: source, toOffset: destination)
            }
        }
        .toolbar {
            EditButton()
        }
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
    }
}
```

### 7.3 完整 Demo

```swift
struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    var isFavorite: Bool
}

class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var searchText = ""
    @Published var selection: Set<UUID> = []

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        return contacts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.phone.localizedCaseInsensitiveContains(searchText)
        }
    }

    func toggleFavorite(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index].isFavorite.toggle()
        }
    }

    func deleteContacts(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }

    func moveContact(from source: IndexSet, to destination: Int) {
        contacts.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContactListView: View {
    @StateObject private var viewModel = ContactViewModel()
    @State private var isEditing = false

    var body: some View {
        List(selection: $viewModel.selection) {
            Section("收藏联系人") {
                ForEach(viewModel.filteredContacts.filter { $0.isFavorite }) { contact in
                    ContactRow(contact: contact, onFavorite: {
                        viewModel.toggleFavorite(contact)
                    })
                }
            }

            Section("所有联系人") {
                ForEach(viewModel.filteredContacts.filter { !$0.isFavorite }) { contact in
                    ContactRow(contact: contact, onFavorite: {
                        viewModel.toggleFavorite(contact)
                    })
                }
                .onDelete { offsets in
                    viewModel.deleteContacts(at: offsets)
                }
                .onMove { source, destination in
                    viewModel.moveContact(from: source, to: destination)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "搜索联系人")
        .refreshable {
            // 刷新数据
            await loadContacts()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle("联系人")
        .listStyle(.insetGrouped)
    }

    private func loadContacts() async {
        // 模拟加载数据
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        viewModel.contacts = [
            Contact(name: "张三", phone: "123-4567", isFavorite: true),
            Contact(name: "李四", phone: "234-5678", isFavorite: false),
            Contact(name: "王五", phone: "345-6789", isFavorite: true)
        ]
    }
}

struct ContactRow: View {
    let contact: Contact
    let onFavorite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                Text(contact.phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button {
                onFavorite()
            } label: {
                Image(systemName: contact.isFavorite ? "star.fill" : "star")
                    .foregroundColor(contact.isFavorite ? .yellow : .gray)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                onFavorite()
            } label: {
                Label("收藏", systemImage: "star")
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                // 删除操作
            } label: {
                Label("删除", systemImage: "trash")
            }

            Button {
                // 分享操作
            } label: {
                Label("分享", systemImage: "square.and.arrow.up")
            }
            .tint(.blue)
        }
    }
}
```

## 8. 注意事项

### 8.1 常见问题

1. 列表更新问题

   - 确保数据模型遵循 `Identifiable` 协议
   - 使用稳定的标识符
   - 避免使用索引作为标识符

2. 性能问题

   - 避免在列表项中进行复杂计算
   - 使用适当的数据结构
   - 实现正确的视图回收机制

3. 布局问题
   - 注意列表项的动态高度
   - 处理好嵌套滚动视图
   - 注意安全区域和边距

### 8.2 兼容性考虑

1. iOS 版本兼容

   - iOS 13+: 基本 List 功能
   - iOS 14+: 支持多选和侧滑操作
   - iOS 15+: 支持异步刷新和搜索
   - iOS 16+: 支持滚动视图对齐

2. 设备适配
   - iPhone: 标准列表布局
   - iPad: 考虑分屏和多列布局
   - Mac: 考虑鼠标和键盘交互

### 8.3 使用建议

1. 数据管理

   - 使用 MVVM 架构管理列表数据
   - 实现适当的数据缓存机制
   - 处理好数据更新的性能问题

2. 用户体验

   - 提供适当的加载状态指示
   - 实现合理的错误处理
   - 添加适当的动画效果

3. 维护性
   - 模块化列表组件
   - 使用清晰的命名约定
   - 添加适当的注释

## 9. 完整运行 Demo

请参考 `ListDemoView.swift` 中的完整示例代码。

### 9.1 运行说明

1. 确保 Xcode 版本 >= 14.0
2. 确保 iOS 部署目标 >= 16.0
3. 运行项目，导航到 List Demo 页面

### 9.2 功能说明

1. 基础功能

   - 静态列表示例
   - 动态列表示例
   - 分组列表示例

2. 交互功能

   - 项目选择
   - 滑动删除
   - 拖拽排序
   - 下拉刷新
   - 搜索过滤

3. 样式演示
   - 不同的列表样式
   - 自定义行样式
   - 动画效果
