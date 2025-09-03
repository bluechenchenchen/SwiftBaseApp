import SwiftUI

struct StateManagementDemoView: View {
    @StateObject private var viewModel = StateManagementViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.stateManagementItems.keys).sorted, id: \.self) { type in
                    if let items = viewModel.stateManagementItems[type] {
                        Section {
                            ForEach(items) { item in
                                NavigationLink {
                                    viewModel.destinationView(for: item)
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: iconName(for: item))
                                            .font(.title2)
                                            .foregroundColor(.accentColor)
                                            .frame(width: 32)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.title)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            Text(item.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        } header: {
                            HStack {
                                Text(type.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .textCase(nil)
                                Spacer()
                                Text("共 \(items.count) 项")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("状态管理")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func iconName(for item: StateManagementItem) -> String {
        switch item.type {
        case .propertyWrapper:
            switch item.title {
            case "@State 基础状态管理": return "1.circle.fill"
            case "@Binding 数据传递": return "2.circle.fill"
            case "@StateObject 视图模型": return "3.circle.fill"
            case "@ObservedObject 观察对象": return "4.circle.fill"
            case "@EnvironmentObject 环境对象": return "5.circle.fill"
            case "@Published 属性发布": return "6.circle.fill"
            case "自定义属性包装器": return "7.circle.fill"
            default: return "questionmark.circle"
            }
        case .stateManagement:
            switch item.title {
            case "视图内状态管理": return "square.and.pencil"
            case "父子视图数据传递": return "arrow.left.and.right"
            case "视图间状态共享": return "square.stack.3d.up"
            case "环境值的使用": return "gearshape"
            case "状态恢复和持久化": return "arrow.clockwise"
            case "状态管理最佳实践": return "checkmark.seal"
            case "性能优化技巧": return "speedometer"
            default: return "gear"
            }
        case .combine:
            switch item.title {
            case "Publisher 和 Subscriber": return "arrow.up.arrow.down"
            case "基本操作符使用": return "slider.horizontal.3"
            case "数据流转换": return "arrow.triangle.2.circlepath"
            case "错误处理": return "exclamationmark.triangle"
            case "异步操作处理": return "clock"
            case "内存管理": return "memorychip"
            case "实际应用案例": return "app.badge"
            default: return "function"
            }
        case .mvvm:
            switch item.title {
            case "ViewModel 设计原则": return "square.3.layers.3d"
            case "数据绑定实现": return "link"
            case "业务逻辑处理": return "cpu"
            case "依赖注入模式": return "cylinder"
            case "单元测试编写": return "checkmark.circle"
            case "代码组织和结构": return "folder"
            case "实际项目应用": return "building"
            default: return "square.3.layers.3d"
            }
        case .reactive:
            switch item.title {
            case "响应式数据流": return "arrow.triangle.2.circlepath"
            case "事件处理": return "hand.tap"
            case "异步数据流": return "clock.arrow.circlepath"
            case "数据绑定模式": return "link.badge.plus"
            default: return "bolt"
            }
        case .advanced:
            switch item.title {
            case "复杂状态管理": return "puzzlepiece"
            case "状态恢复机制": return "arrow.clockwise.circle"
            case "性能优化": return "speedometer"
            case "内存管理": return "memorychip"
            case "测试策略": return "checkmark.shield"
            case "调试技巧": return "ladybug"
            default: return "star"
            }
        }
    }
}

#Preview {
    StateManagementDemoView()
}
