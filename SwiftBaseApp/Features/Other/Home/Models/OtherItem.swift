import SwiftUI

// MARK: - Other Item Type
enum OtherItemType: Int, CaseIterable {
    case tools = 0
    case utilities = 1
    case examples = 2
    case advanced = 3
    
    var title: String {
        switch self {
        case .tools: return "工具"
        case .utilities: return "实用工具"
        case .examples: return "示例"
        case .advanced: return "高级功能"
        }
    }
}

// MARK: - Other Item Model
struct OtherItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let type: OtherItemType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OtherItem, rhs: OtherItem) -> Bool {
        lhs.id == rhs.id
    }
}

// 扩展 Array 以支持 OtherItemType 排序
extension Array where Element == OtherItemType {
    var sorted: [OtherItemType] {
        self.sorted { $0.rawValue < $1.rawValue }
    }
}
