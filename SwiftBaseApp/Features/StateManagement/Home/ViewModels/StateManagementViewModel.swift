import SwiftUI

@MainActor
class StateManagementViewModel: ObservableObject {
    @Published var stateManagementItems: [StateManagementType: [StateManagementItem]] = [:]
    
    init() {
        setupStateManagementItems()
    }
    
    private func setupStateManagementItems() {
        // 属性包装器
        stateManagementItems[.propertyWrapper] = [
            StateManagementItem(title: "@State 基础状态管理", description: "视图内部状态管理", type: .propertyWrapper),
            StateManagementItem(title: "@Binding 数据传递", description: "父子视图数据绑定", type: .propertyWrapper),
            StateManagementItem(title: "@StateObject 视图模型", description: "视图模型状态管理", type: .propertyWrapper),
            StateManagementItem(title: "@ObservedObject 观察对象", description: "外部对象观察", type: .propertyWrapper),
            StateManagementItem(title: "@EnvironmentObject 环境对象", description: "全局状态管理", type: .propertyWrapper),
            StateManagementItem(title: "@Published 属性发布", description: "属性发布机制", type: .propertyWrapper),
            StateManagementItem(title: "自定义属性包装器", description: "自定义状态包装器", type: .propertyWrapper)
        ]
        
        // 状态管理
        stateManagementItems[.stateManagement] = [
            StateManagementItem(title: "视图内状态管理", description: "本地状态设计和管理", type: .stateManagement),
            StateManagementItem(title: "父子视图数据传递", description: "数据流设计和状态提升", type: .stateManagement),
            StateManagementItem(title: "视图间状态共享", description: "共享状态设计和同步", type: .stateManagement),
            StateManagementItem(title: "环境值的使用", description: "环境值定义和传递", type: .stateManagement),
            StateManagementItem(title: "状态恢复和持久化", description: "状态序列化和恢复", type: .stateManagement),
            StateManagementItem(title: "状态管理最佳实践", description: "状态设计原则和优化", type: .stateManagement),
            StateManagementItem(title: "性能优化技巧", description: "状态更新和内存优化", type: .stateManagement)
        ]
        
        // Combine 框架
        stateManagementItems[.combine] = [
            StateManagementItem(title: "Publisher 和 Subscriber", description: "发布者和订阅者基础", type: .combine),
            StateManagementItem(title: "基本操作符使用", description: "转换、过滤、组合操作符", type: .combine),
            StateManagementItem(title: "数据流转换", description: "数据映射、过滤、组合", type: .combine),
            StateManagementItem(title: "错误处理", description: "错误传播和恢复机制", type: .combine),
            StateManagementItem(title: "异步操作处理", description: "异步发布者和并发控制", type: .combine),
            StateManagementItem(title: "内存管理", description: "订阅管理和资源释放", type: .combine),
            StateManagementItem(title: "实际应用案例", description: "网络请求和用户输入处理", type: .combine)
        ]
        
        // MVVM 架构
        stateManagementItems[.mvvm] = [
            StateManagementItem(title: "ViewModel 设计原则", description: "职责分离和数据绑定", type: .mvvm),
            StateManagementItem(title: "数据绑定实现", description: "双向绑定和单向数据流", type: .mvvm),
            StateManagementItem(title: "业务逻辑处理", description: "业务规则封装和状态转换", type: .mvvm),
            StateManagementItem(title: "依赖注入模式", description: "服务注入和配置注入", type: .mvvm),
            StateManagementItem(title: "单元测试编写", description: "ViewModel 和业务逻辑测试", type: .mvvm),
            StateManagementItem(title: "代码组织和结构", description: "模块化设计和协议抽象", type: .mvvm),
            StateManagementItem(title: "实际项目应用", description: "项目架构设计和模块通信", type: .mvvm)
        ]
        
        // 响应式编程
        stateManagementItems[.reactive] = [
            StateManagementItem(title: "响应式数据流", description: "数据流设计和转换", type: .reactive),
            StateManagementItem(title: "事件处理", description: "用户事件和系统事件", type: .reactive),
            StateManagementItem(title: "异步数据流", description: "异步操作和并发控制", type: .reactive),
            StateManagementItem(title: "数据绑定模式", description: "单向和双向数据绑定", type: .reactive)
        ]
        
        // 进阶主题
        stateManagementItems[.advanced] = [
            StateManagementItem(title: "复杂状态管理", description: "状态机设计和状态组合", type: .advanced),
            StateManagementItem(title: "状态恢复机制", description: "状态序列化和迁移", type: .advanced),
            StateManagementItem(title: "性能优化", description: "状态更新和渲染优化", type: .advanced),
            StateManagementItem(title: "内存管理", description: "引用循环避免和资源释放", type: .advanced),
            StateManagementItem(title: "测试策略", description: "单元测试和集成测试", type: .advanced),
            StateManagementItem(title: "调试技巧", description: "状态调试和性能分析", type: .advanced)
        ]
    }
    
    @ViewBuilder
    func destinationView(for item: StateManagementItem) -> some View {
        NavigationStack {
            switch item.title {
            case "@State 基础状态管理":
                StateDemoView()
            case "@Binding 数据传递":
                BindingDemoView()
            case "@StateObject 视图模型":
                StateObjectDemoView()
            case "@ObservedObject 观察对象":
                ObservedObjectDemoView()
            case "@EnvironmentObject 环境对象":
                EnvironmentObjectDemoView()
            case "@Published 属性发布":
                PublishedDemoView()
            case "自定义属性包装器":
                Text("自定义属性包装器 Demo - 待实现")
                    .navigationTitle("自定义属性包装器")
            case "视图内状态管理":
                Text("视图内状态管理 Demo - 待实现")
                    .navigationTitle("视图内状态管理")
            case "父子视图数据传递":
                Text("父子视图数据传递 Demo - 待实现")
                    .navigationTitle("父子视图数据传递")
            case "视图间状态共享":
                Text("视图间状态共享 Demo - 待实现")
                    .navigationTitle("视图间状态共享")
            case "环境值的使用":
                Text("环境值的使用 Demo - 待实现")
                    .navigationTitle("环境值的使用")
            case "状态恢复和持久化":
                Text("状态恢复和持久化 Demo - 待实现")
                    .navigationTitle("状态恢复和持久化")
            case "状态管理最佳实践":
                Text("状态管理最佳实践 Demo - 待实现")
                    .navigationTitle("状态管理最佳实践")
            case "性能优化技巧":
                Text("性能优化技巧 Demo - 待实现")
                    .navigationTitle("性能优化技巧")
            case "Publisher 和 Subscriber":
                Text("Publisher 和 Subscriber Demo - 待实现")
                    .navigationTitle("Publisher 和 Subscriber")
            case "基本操作符使用":
                Text("基本操作符使用 Demo - 待实现")
                    .navigationTitle("基本操作符使用")
            case "数据流转换":
                Text("数据流转换 Demo - 待实现")
                    .navigationTitle("数据流转换")
            case "错误处理":
                Text("错误处理 Demo - 待实现")
                    .navigationTitle("错误处理")
            case "异步操作处理":
                Text("异步操作处理 Demo - 待实现")
                    .navigationTitle("异步操作处理")
            case "内存管理":
                Text("内存管理 Demo - 待实现")
                    .navigationTitle("内存管理")
            case "实际应用案例":
                Text("实际应用案例 Demo - 待实现")
                    .navigationTitle("实际应用案例")
            case "ViewModel 设计原则":
                Text("ViewModel 设计原则 Demo - 待实现")
                    .navigationTitle("ViewModel 设计原则")
            case "数据绑定实现":
                Text("数据绑定实现 Demo - 待实现")
                    .navigationTitle("数据绑定实现")
            case "业务逻辑处理":
                Text("业务逻辑处理 Demo - 待实现")
                    .navigationTitle("业务逻辑处理")
            case "依赖注入模式":
                Text("依赖注入模式 Demo - 待实现")
                    .navigationTitle("依赖注入模式")
            case "单元测试编写":
                Text("单元测试编写 Demo - 待实现")
                    .navigationTitle("单元测试编写")
            case "代码组织和结构":
                Text("代码组织和结构 Demo - 待实现")
                    .navigationTitle("代码组织和结构")
            case "实际项目应用":
                Text("实际项目应用 Demo - 待实现")
                    .navigationTitle("实际项目应用")
            case "响应式数据流":
                Text("响应式数据流 Demo - 待实现")
                    .navigationTitle("响应式数据流")
            case "事件处理":
                Text("事件处理 Demo - 待实现")
                    .navigationTitle("事件处理")
            case "异步数据流":
                Text("异步数据流 Demo - 待实现")
                    .navigationTitle("异步数据流")
            case "数据绑定模式":
                Text("数据绑定模式 Demo - 待实现")
                    .navigationTitle("数据绑定模式")
            case "复杂状态管理":
                Text("复杂状态管理 Demo - 待实现")
                    .navigationTitle("复杂状态管理")
            case "状态恢复机制":
                Text("状态恢复机制 Demo - 待实现")
                    .navigationTitle("状态恢复机制")
            case "性能优化":
                Text("性能优化 Demo - 待实现")
                    .navigationTitle("性能优化")
            case "内存管理":
                Text("内存管理 Demo - 待实现")
                    .navigationTitle("内存管理")
            case "测试策略":
                Text("测试策略 Demo - 待实现")
                    .navigationTitle("测试策略")
            case "调试技巧":
                Text("调试技巧 Demo - 待实现")
                    .navigationTitle("调试技巧")
            default:
                Text("待实现")
                    .navigationTitle("待实现")
            }
        }
    }
}
