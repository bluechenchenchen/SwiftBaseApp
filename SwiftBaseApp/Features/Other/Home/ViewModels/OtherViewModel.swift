import SwiftUI

@MainActor
class OtherViewModel: ObservableObject {
    @Published var otherItems: [OtherItemType: [OtherItem]] = [:]
    
    init() {
        setupOtherItems()
    }
    
    private func setupOtherItems() {
        // 工具分类
        otherItems[.tools] = [
            OtherItem(title: "代码生成器", description: "自动生成常用代码模板", type: .tools),
            OtherItem(title: "调试工具", description: "应用调试和性能分析工具", type: .tools),
            OtherItem(title: "配置管理", description: "应用配置和环境管理", type: .tools)
        ]
        
        // 实用工具分类
        otherItems[.utilities] = [
            OtherItem(title: "日期工具", description: "日期格式化和计算工具", type: .utilities),
            OtherItem(title: "字符串工具", description: "字符串处理和格式化工具", type: .utilities),
            OtherItem(title: "加密工具", description: "数据加密和解密工具", type: .utilities)
        ]
        
        // 示例分类
        otherItems[.examples] = [
            OtherItem(title: "动画示例", description: "各种动画效果示例", type: .examples),
            OtherItem(title: "手势示例", description: "手势识别和交互示例", type: .examples),
            OtherItem(title: "自定义组件", description: "自定义 SwiftUI 组件示例", type: .examples)
        ]
        
        // 高级功能分类
        otherItems[.advanced] = [
            OtherItem(title: "性能优化", description: "应用性能优化技巧", type: .advanced),
            OtherItem(title: "内存管理", description: "内存管理和泄漏检测", type: .advanced),
            OtherItem(title: "测试策略", description: "单元测试和 UI 测试策略", type: .advanced)
        ]
        
        // 学习指南分类
        otherItems[.examples] = [
            OtherItem(title: "动画示例", description: "各种动画效果示例", type: .examples),
            OtherItem(title: "手势示例", description: "手势识别和交互示例", type: .examples),
            OtherItem(title: "自定义组件", description: "自定义 SwiftUI 组件示例", type: .examples),
            OtherItem(title: "修饰符指南", description: "SwiftUI 修饰符使用指南和最佳实践", type: .examples)
        ]
    }
    
    @ViewBuilder
    func destinationView(for item: OtherItem) -> some View {
        NavigationStack {
            switch item.title {
            case "代码生成器":
                Text("代码生成器页面")
                    .navigationTitle("代码生成器")
            case "调试工具":
                Text("调试工具页面")
                    .navigationTitle("调试工具")
            case "配置管理":
                Text("配置管理页面")
                    .navigationTitle("配置管理")
            case "日期工具":
                Text("日期工具页面")
                    .navigationTitle("日期工具")
            case "字符串工具":
                Text("字符串工具页面")
                    .navigationTitle("字符串工具")
            case "加密工具":
                Text("加密工具页面")
                    .navigationTitle("加密工具")
            case "动画示例":
                Text("动画示例页面")
                    .navigationTitle("动画示例")
            case "手势示例":
                Text("手势示例页面")
                    .navigationTitle("手势示例")
            case "自定义组件":
                Text("自定义组件页面")
                    .navigationTitle("自定义组件")
            case "性能优化":
                Text("性能优化页面")
                    .navigationTitle("性能优化")
            case "修饰符指南":
                ModifierGuideView()
            case "内存管理":
                Text("内存管理页面")
                    .navigationTitle("内存管理")
            case "测试策略":
                Text("测试策略页面")
                    .navigationTitle("测试策略")
            default:
                Text("待实现")
                    .navigationTitle("待实现")
            }
        }
    }
}
