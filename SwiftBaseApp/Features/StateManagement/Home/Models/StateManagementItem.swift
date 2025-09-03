import SwiftUI

struct StateManagementItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let type: StateManagementType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: StateManagementItem, rhs: StateManagementItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum StateManagementType: Int, CaseIterable {
    case propertyWrapper = 0
    case stateManagement = 1
    case combine = 2
    case mvvm = 3
    case reactive = 4
    case advanced = 5
    
    var title: String {
        switch self {
        case .propertyWrapper: return "属性包装器"
        case .stateManagement: return "状态管理"
        case .combine: return "Combine 框架"
        case .mvvm: return "MVVM 架构"
        case .reactive: return "响应式编程"
        case .advanced: return "进阶主题"
        }
    }
}

// 扩展 Array 以支持 StateManagementType 排序
extension Array where Element == StateManagementType {
    var sorted: [StateManagementType] {
        self.sorted { $0.rawValue < $1.rawValue }
    }
}
