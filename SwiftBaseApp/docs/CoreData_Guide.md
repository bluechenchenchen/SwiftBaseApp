# Core Data 学习指南

## 目录

- [Core Data 简介](#core-data-简介)
- [核心概念](#核心概念)
- [基础使用](#基础使用)
- [进阶主题](#进阶主题)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

## Core Data 简介

### 什么是 Core Data？

Core Data 是 Apple 提供的数据持久化框架，它不仅仅是一个简单的数据库，而是一个完整的对象图和持久化框架。你可以把它理解为：

- 一个在内存中管理对象的框架
- 一个数据持久化的解决方案
- 一个对象关系映射（ORM）系统

### 为什么使用 Core Data？

1. **数据持久化**

   - 可以将数据保存到设备中
   - 应用重启后数据依然存在
   - 支持复杂的数据结构

2. **性能优化**

   - 内置的缓存机制
   - 延迟加载
   - 批量操作支持

3. **数据模型管理**
   - 版本控制
   - 数据迁移
   - 模型验证

## 核心概念

### 1. 持久化存储协调器（Persistent Store Coordinator）

- 作为持久化存储和托管对象上下文之间的中介
- 管理一个或多个持久化存储
- 协调数据的保存和加载

### 2. 托管对象上下文（Managed Object Context）

```swift
// 获取上下文
@Environment(\.managedObjectContext) private var viewContext

// 在上下文中创建对象
let newItem = Item(context: viewContext)

// 保存上下文
try? viewContext.save()
```

主要功能：

- 跟踪对象的变化
- 提供撤销/重做功能
- 管理对象的生命周期

### 3. 托管对象模型（Managed Object Model）

- 定义数据结构
- 指定实体之间的关系
- 设置数据验证规则

### 4. 持久化存储（Persistent Store）

- 实际存储数据的地方
- 支持多种存储类型（SQLite、XML、Binary 等）
- 管理数据的读写

## 基础使用

### 1. 创建数据模型

```swift
// 在 .xcdatamodeld 文件中定义实体
entity Item {
    attribute name: String
    attribute timestamp: Date
    relationship category: Category
}
```

### 2. 基本操作

#### 创建数据

```swift
let newItem = Item(context: viewContext)
newItem.name = "新项目"
newItem.timestamp = Date()

try? viewContext.save()
```

#### 读取数据

```swift
@FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default
) private var items: FetchedResults<Item>
```

#### 更新数据

```swift
item.name = "更新后的名称"
try? viewContext.save()
```

#### 删除数据

```swift
viewContext.delete(item)
try? viewContext.save()
```

### 3. 在 SwiftUI 中使用

```swift
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
    ) private var items: FetchedResults<Item>

    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name ?? "")
            }
        }
    }
}
```

## 进阶主题

### 1. 关系管理

```swift
// 一对多关系
entity Category {
    attribute name: String
    relationship items: Item (toMany: true)
}

entity Item {
    attribute name: String
    relationship category: Category
}
```

### 2. 数据过滤和排序

```swift
@FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    predicate: NSPredicate(format: "name CONTAINS[c] %@", searchText)
) private var filteredItems: FetchedResults<Item>
```

### 3. 批量操作

```swift
// 批量更新
let batchUpdate = NSBatchUpdateRequest(entityName: "Item")
batchUpdate.propertiesToUpdate = ["completed": true]
batchUpdate.predicate = NSPredicate(format: "category.name == %@", "Work")
try? viewContext.execute(batchUpdate)
```

### 4. 数据迁移

- 轻量级迁移
- 手动迁移
- 迁移策略

## 最佳实践

### 1. 错误处理

```swift
do {
    try viewContext.save()
} catch {
    let nsError = error as NSError
    print("保存失败: \(nsError), \(nsError.userInfo)")
}
```

### 2. 性能优化

- 使用批量操作
- 适当设置批量大小
- 合理使用缓存

### 3. 数据模型设计

- 合理规划实体关系
- 适当使用索引
- 注意数据完整性

### 4. 线程安全

```swift
// 在后台执行操作
persistenceController.container.performBackgroundTask { context in
    // 执行耗时操作
    try? context.save()
}
```

## 常见问题

### 1. 保存失败

常见原因：

- 数据验证失败
- 磁盘空间不足
- 权限问题

解决方案：

- 检查数据有效性
- 添加适当的错误处理
- 验证存储权限

### 2. 性能问题

常见原因：

- 加载过多数据
- 频繁保存
- 复杂的查询条件

优化方案：

- 使用分页加载
- 批量操作
- 优化查询条件

### 3. 数据不一致

常见原因：

- 多线程操作
- 合并冲突
- 迁移问题

解决方案：

- 正确使用上下文
- 处理合并冲突
- 测试数据迁移

## 学习资源

1. 官方文档

- [Core Data Programming Guide](https://developer.apple.com/documentation/coredata)
- [Core Data Framework Reference](https://developer.apple.com/documentation/coredata)

2. 推荐书籍

- "Core Data by Tutorials" - raywenderlich.com
- "Core Data" - Florian Kugler & Daniel Eggert

3. 在线教程

- [Hacking with Swift - Core Data](https://www.hackingwithswift.com/books/ios-swiftui/core-data-introduction)
- [SwiftUI Core Data Tutorials](https://developer.apple.com/tutorials/swiftui/persisting-data)

## 练习项目建议

1. 入门级

- 待办事项应用
- 简单笔记应用
- 个人收藏夹

2. 进阶级

- 多实体关系的数据管理
- 数据同步功能
- 复杂查询和过滤

3. 高级应用

- 离线数据缓存
- 数据版本迁移
- 多线程数据处理

记住：Core Data 是一个强大的框架，建议循序渐进地学习和使用。从简单的应用开始，逐步掌握更复杂的功能。
